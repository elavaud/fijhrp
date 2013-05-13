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
		
        $countryDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
        $proposalCountries =& $countryDAO->getAreasOfTheCountry();
        $templateMgr->assign_by_ref('proposalCountries', $proposalCountries);	
		
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
		
		$fromDate = Request::getUserVar('dateFrom');
		if(!$fromDate) $fromDate = Request::getUserDateVar('dateFrom', 1, 1);

		$toDate = Request::getUserVar('dateTo');		
		if(!$toDate) $toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		
		$country = Request::getUserVar('proposalCountry');
		
		$status = Request::getUserVar('status');
		if($status != '1' && $status != '2') $status = false;
		
		$rangeInfo =& Handler::getRangeInfo('search');
		
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'title';
		
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == SORT_DIRECTION_ASC || $sortDirection == SORT_DIRECTION_DESC)) ? $sortDirection : SORT_DIRECTION_ASC;

		$templateMgr =& TemplateManager::getManager();
		
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$countryDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
		$results =& $articleDao->searchProposalsPublic($query, $fromDate, $toDate, $country, $status, $rangeInfo, $sort, $sortDirection);

		$templateMgr->assign('formattedDateFrom', $fromDate);
		$templateMgr->assign('formattedDateTo', $toDate);
										
		$templateMgr->assign('statusFilter', $status);
		$templateMgr->assign_by_ref('results', $results);
		$templateMgr->assign('query', $query);
		$templateMgr->assign('region', $country);
		$templateMgr->assign('country', $countryDAO->getAreaOfTheCountry($country));
		

		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);

		$templateMgr->assign('count', $results->getCount());
		$templateMgr->display('search/searchResults.tpl');
	}
	
	function generateCustomizedCSV($args) {
		parent::validate();
		$this->setupTemplate();
		$query = Request::getUserVar('query');

		$region = Request::getUserVar('region');
		$statusFilter = Request::getUserVar('statusFilter');
				
		$fromDate = Request::getUserVar('dateFrom');
		//if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);		
		$toDate = Request::getUserVar('dateTo');
		//if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$columns = array();
		
		$investigatorName = false;
		if (Request::getUserVar('investigatorName')) {
			$columns = $columns + array('investigator' => Locale::translate('search.investigator'));
			$investigatorName = true;
		}
					
		$investigatorAffiliation = false;
		if (Request::getUserVar('investigatorAffiliation')) {
			$columns = $columns + array('investigator_affiliation' => Locale::translate('search.investigatorAffiliation'));
			$investigatorAffiliation = true;
		}
							
		$investigatorEmail = false;
		if (Request::getUserVar('investigatorEmail')) {
			$columns = $columns + array('investigator_email' => Locale::translate('search.investigatorEmail'));
			$investigatorEmail = true;
		}
		
		if (Request::getUserVar('title')) {
			$columns = $columns + array('title' => Locale::translate('article.scientificTitle'));
		}
		
		$researchField = false;
		if (Request::getUserVar('researchField')) {
			$columns = $columns + array('research_field' => Locale::translate('search.researchField'));
			$researchField = true;
		}
		
		$proposalType = false;
		if (Request::getUserVar('proposalType')) {
			$columns = $columns + array('proposal_type' => Locale::translate('article.proposalType'));
			$proposalType = true;
		}
		
		$duration = false;
		if (Request::getUserVar('duration')) {
			$columns = $columns + array('duration' => Locale::translate('search.duration'));
			$duration = true;
		}

		$area = false;
		if (Request::getUserVar('area')) {
			$columns = $columns + array('area' => Locale::translate('common.area'));
			$area = true;
		}
		
		$dataCollection = false;
		if (Request::getUserVar('dataCollection')) {
			$columns = $columns + array('data_collection' => Locale::translate('search.dataCollection'));
			$dataCollection = true;
		}
		
		$status = false;
		if (Request::getUserVar('status')) {
			$columns = $columns + array('status' => Locale::translate('search.status'));
			$status = true;
		}

		$studentResearch = false;
		if (Request::getUserVar('studentResearch')) {
			$columns = $columns + array('student_institution' => Locale::translate('article.studentInstitution'));
			$columns = $columns + array('academic_degree' => Locale::translate('article.academicDegree'));
			$studentResearch = true;
		}

		$primarySponsor = false;
		if (Request::getUserVar('primarySponsor')) {
			$columns = $columns + array('primary_sponsor' => Locale::translate('article.primarySponsor'));
			$primarySponsor = true;
		}

		$fundsRequired = false;
		if (Request::getUserVar('fundsRequired')) {
			$columns = $columns + array('funds_required' => Locale::translate('article.fundsRequired'));
			$fundsRequired = true;
		}
		
		$dateSubmitted = false;
		if (Request::getUserVar('dateSubmitted')) {
			$columns = $columns + array('date_submitted' => Locale::translate('search.dateSubmitted'));
			$dateSubmitted = true;
		}		
		
		
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=searchResults-' . date('Ymd') . '.csv');
				
		
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array_values($columns));
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		
		$results = $articleDao->searchCustomizedProposalsPublic($query, $region, $statusFilter, $fromDate, $toDate, $investigatorName, $investigatorAffiliation, $investigatorEmail, $researchField, $proposalType, $duration, $area, $dataCollection, $status, $studentResearch, $primarySponsor, $fundsRequired, $dateSubmitted);
		
		
		foreach ($results as $result) {
			$abstract = $result->getLocalizedAbstract();
			foreach ($columns as $index => $junk) {
				if ($index == 'investigator') {
					$columns[$index] = $result->getPrimaryAuthor();
				} elseif ($index == 'investigator_affiliation') {
					$columns[$index] = $result->getInvestigatorAffiliation();
				} elseif ($index == 'investigator_email') {
					$columns[$index] = $result->getAuthorEmail();
				} elseif ($index == 'title') {
					$columns[$index] = $abstract->getScientificTitle();
				} elseif ($index == 'research_field') {
					$columns[$index] = $result->getLocalizedResearchFieldText();
				} elseif ($index == 'proposal_type') {
					$columns[$index] = $result->getLocalizedProposalTypeText();
				} elseif ($index == "duration") {
					$columns[$index] = date("d M Y", strtotime($result->getStartDate()))." to ".date("d M Y", strtotime($result->getEndDate()));
				} elseif ($index == 'area') {
					if ($result->getLocalizedMultiCountryResearch() == "Yes") $columns[$index] = "Multi-country Research";
					elseif ($result->getLocalizedNationwide() != "No") $columns[$index] = "Nationwide Research";
					else  $columns[$index] = $result->getLocalizedProposalCountryText();
				} elseif ($index == 'data_collection') {
					$columns[$index] = $result->getLocalizedDataCollection();
				} elseif ($index == 'status') {
					if ($result->getStatus() == '11') $columns[$index] = 'Complete';
					else $columns[$index] = 'Ongoing';
				} elseif ($index == 'student_institution') {
					if ($result->getLocalizedStudentInstitution() != "NA") $columns[$index] = $result->getLocalizedStudentInstitution(); else $columns[$index] = "Non Student Research";
				} elseif ($index == 'academic_degree') {
					if ($result->getLocalizedAcademicDegree() != "NA") $columns[$index] = $result->getLocalizedAcademicDegree();else $columns[$index] = "Non Student Research";
				} elseif ($index == 'primary_sponsor') {
					$columns[$index] = $result->getLocalizedPrimarySponsor();
				} elseif ($index == 'funds_required') {
					$columns[$index] = $result->getLocalizedFundsRequired()." ".$result->getLocalizedSelectedCurrency();
				} elseif ($index == 'date_submitted') {
					$columns[$index] = $result->getDateSubmitted();
				} 
			}
			String::fputcsv($fp, $columns);
		}
		fclose($fp);
		unset($columns);
	}
	
	function viewProposal($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->setupTemplate(true, $articleId);
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$submission = $articleDao->getArticle($articleId);
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('results', $results);
		$templateMgr->assign('query', Request::getUserVar('query'));
		
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$proposal = $sectionEditorSubmissionDao->getSectionEditorSubmission($articleId);
		$templateMgr->assign_by_ref('suppFiles', $proposal->getSuppFiles());
			
			// Undefined. EL on March 15th 2013
			//$templateMgr->assign('dateFrom', $fromDate);
			//$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());
		
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
			$subclass ? array(array(Request::url(null, 'search'), 'navigation.search'), array(Request::url('hrp', 'search','advancedResults'), 'search.searchResults'))
				: array()
			);
		}
			

		$journal =& Request::getJournal();
		if (!$journal || !$journal->getSetting('restrictSiteAccess')) {
			$templateMgr->setCacheability(CACHEABILITY_PUBLIC);
		}
	}

	/**
	 * Download a file.
	 * @param $args array ($articleId, $fileId)
	 */
	function downloadFile($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;
		$suppFileId = isset($args[2]) ? $args[2] : 0;
		
		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$suppFile =& $suppFileDao->getSuppFile($suppFileId);
		if ($suppFile->getType() == "Completion Report") {
			import('classes.file.ArticleFileManager');
			$articleFileManager = new ArticleFileManager($articleId);
			return $articleFileManager->downloadFile($fileId);
		} else return null;
	}

}

?>
