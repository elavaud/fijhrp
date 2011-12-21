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
		
		$templateMgr->display('search/search.tpl');
	}

	/**
	 * Show basic search results.
	 */
	function results() {
		$this->validate();
		$this->setupTemplate(true);

		$rangeInfo = Handler::getRangeInfo('search');

		$searchJournalId = Request::getUserVar('searchJournal');
		if (!empty($searchJournalId)) {
			$journalDao =& DAORegistry::getDAO('JournalDAO');
			$journal =& $journalDao->getJournal($searchJournalId);
		} else {
			$journal =& Request::getJournal();
		}

		$searchType = Request::getUserVar('searchField');
		if (!is_numeric($searchType)) $searchType = null;

		// Load the keywords array with submitted values
		$keywords = array($searchType => ArticleSearch::parseQuery(Request::getUserVar('query')));

		$results =& ArticleSearch::retrieveResults($journal, $keywords, null, null, $rangeInfo);

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->setCacheability(CACHEABILITY_NO_STORE);
		$templateMgr->assign_by_ref('results', $results);
		$templateMgr->assign('basicQuery', Request::getUserVar('query'));
		$templateMgr->assign('searchField', Request::getUserVar('searchField'));
		$templateMgr->display('search/searchResults.tpl');
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
		$templateMgr->assign('basicQuery', Request::getUserVar('query'));

		$templateMgr->display('search/searchResults.tpl');
	}	

	/**
	 * Setup common template variables.
	 * @param $subclass boolean set to true if caller is below this handler in the hierarchy
	 */
	function setupTemplate($subclass = false) {
		parent::setupTemplate();
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('helpTopicId', 'user.searchAndBrowse');
		$templateMgr->assign('pageHierarchy',
			$subclass ? array(array(Request::url(null, 'search'), 'navigation.search'))
				: array()
		);

		$journal =& Request::getJournal();
		if (!$journal || !$journal->getSetting('restrictSiteAccess')) {
			$templateMgr->setCacheability(CACHEABILITY_PUBLIC);
		}
	}

}

?>
