<?php

/**
 * @file NewSearchHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class NewSearchHandler
 * @ingroup pages_search
 *
 * @brief Handle site index requests. 
 */

// $Id$


import('classes.search.ArticleSearch');
import('classes.handler.Handler');

class NewSearchHandler extends Handler {
	/**
	 * Constructor
	 **/
	function NewSearchHandler() {
		parent::Handler();
		$this->addCheck(new HandlerValidatorCustom($this, false, null, null, create_function('$journal', 'return !$journal || $journal->getSetting(\'publishingMode\') != PUBLISHING_MODE_NONE;'), array(Request::getJournal())));
	}

	/**
	 * Show the advanced form
	 */
	function index() {
		$this->validate();
		$this->advanced();
	}

	/**
	 * Show the advanced form
	 */
	function search() {
		$this->validate();
		$this->advanced();
	}

	/**
	 * Show advanced search form.
	 */
	function advanced() {
		$this->validate();
		$this->setupTemplate(false);
		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('query', Request::getUserVar('query'));
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		
		$templateMgr->display('search/search.tpl');
	}

	/**
	 * Show basic search results.
	 */
	function results() {
		$this->validate();
		$this->advancedResults();
	}

	/**
	 * Show advanced search results.
	 */
	function advancedResults() {
		$this->validate();
		$this->setupTemplate(true);

		$query = Request::getUserVar('query');
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		$articleDao =& DAORegistry::getDAO('ArticleDAO');

		$results =& $articleDao->searchProposalsPublic($query, $fromDate, $toDate);

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('results', $results);
		$templateMgr->assign('query', Request::getUserVar('query'));
		
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign('count', count($results));

		$templateMgr->display('search/searchResults.tpl');
	}	
	
	function generateCSV($args) {
		parent::validate();
		$this->setupTemplate();
		$query = Request::getUserVar('query');
		
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=searchResults-' . date('Ymd') . '.csv');
		
		$columns =  array(
		'whoid' => Locale::translate('search.whoid'),
		'date_submitted' => Locale::translate('common.dateSubmitted'),
		'title' => Locale::translate('article.title'),
		'country' => Locale::translate('common.country'),
		'primary_editor' => Locale::translate('search.responsibleOfficer'),
		'primary_author' => Locale::translate('search.primaryInvestigator'),
		'email' => Locale::translate('search.email'),
		'duration' => Locale::translate('search.duration'),
		'decision' => Locale::translate('search.finalDecision')
		);
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array_values($columns));
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$results = $articleDao->searchProposalsPublic($query, $fromDate, $toDate);
		
		foreach ($results as $result) {
			foreach ($columns as $index => $junk) {
				if ($index == 'primary_editor') {
					$columns[$index] = $result->getPrimaryEditor();
				} elseif ($index == 'primary_author') {
					$columns[$index] =  $result->getPrimaryAuthor();
				} elseif ($index == 'email') {
					$columns[$index] = $result->getAuthorEmail();
				} elseif ($index == "duration") {
					$columns[$index] = date("d M Y", strtotime($result->getStartDate()))." to ".date("d M Y", strtotime($result->getEndDate()));
				} elseif ($index == "decision") {
					$decision = $result->getEditorDecisionKey();
					$columns[$index] = Locale::translate($decision)." on ".date("d M Y", strtotime($result->getDateStatusModified()));
				} elseif ($index == 'date_submitted') {
					$decision = $result->getEditorDecisionKey();
					$columns[$index] = date("d M Y", strtotime($result->getDateSubmitted()));
			} elseif ($index == 'title') {
					$columns[$index] = $result->getTitle();
				} elseif ($index == 'country') {
					$columns[$index] = $result->getProposalCountry();
				} elseif ($index == 'whoid') {
					$columns[$index] = $result->getWhoId();
				}
			}
			String::fputcsv($fp, $columns);
			unset($row);
		}
		fclose($fp);
	}

	function viewProposal($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->setupTemplate(true, $articleId);
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$submission = $articleDao->getArticle($articleId);
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('results', $results);
		$templateMgr->assign('query', Request::getUserVar('query'));
		
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign_by_ref('submission', $submission);
		
		$templateMgr->display('search/viewProposal.tpl');
	}
	/**
	 * Setup common template variables.
	 * @param $subclass boolean set to true if caller is below this handler in the hierarchy
	 */
	function setupTemplate($subclass = false, $articleId = null) {
		parent::setupTemplate();
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('helpTopicId', 'user.searchAndBrowse');
		if ($articleId == null) {$templateMgr->assign('pageHierarchy',
			$subclass ? array(array(Request::url(null, 'search'), 'navigation.search'))
				: array()
		);
		} else {
			$templateMgr->assign('pageHierarchy',
			$subclass ? array(array(Request::url(null, 'search'), 'navigation.search'), array(Request::url('whorrp', 'search','advancedResults'), 'search.searchResults'))
				: array()
			);
		}
			

		$journal =& Request::getJournal();
		if (!$journal || !$journal->getSetting('restrictSiteAccess')) {
			$templateMgr->setCacheability(CACHEABILITY_PUBLIC);
		}
	}

}

?>
