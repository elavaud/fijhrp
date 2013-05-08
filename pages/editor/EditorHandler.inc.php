<?php

/**
 * @file EditorHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class EditorHandler
 * @ingroup pages_editor
 *
 * @brief Handle requests for editor functions.
 */

// $Id$


import('pages.sectionEditor.SectionEditorHandler');

define('EDITOR_SECTION_HOME', 0);
define('EDITOR_SECTION_SUBMISSIONS', 1);
define('EDITOR_SECTION_ISSUES', 2);

// Filter editor
define('FILTER_EDITOR_ALL', 0);
define('FILTER_EDITOR_ME', 1);

import ('classes.submission.editor.EditorAction');

class EditorHandler extends SectionEditorHandler {
	/**
	 * Constructor
	 **/
	function EditorHandler() {
		parent::SectionEditorHandler();

		$this->addCheck(new HandlerValidatorJournal($this));
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_EDITOR)));
	}

	/**
	 * Displays the editor role selection page.
	 */

	function index($args) {
		$this->validate();
		$this->setupTemplate(EDITOR_SECTION_HOME);

		$templateMgr =& TemplateManager::getManager();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();

		$editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		$sections =& $sectionDao->getSectionTitles($journal->getId());
		$templateMgr->assign('sectionOptions', array(0 => Locale::Translate('editor.allSections')) + $sections);
		$templateMgr->assign('fieldOptions', $this->getSearchFieldOptions());
		$templateMgr->assign('dateFieldOptions', $this->getDateFieldOptions());

        $countryDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
        $countries =& $countryDAO->getAreasOfTheCountry();
       
        $templateMgr->assign_by_ref('countries', $countries);		
		
		// Bring in the print_issue_id function (FIXME?)
		import('classes.issue.IssueAction');
		$issueAction = new IssueAction();
		$templateMgr->register_function('print_issue_id', array($issueAction, 'smartyPrintIssueId'));

		// If a search was performed, get the necessary info.
		if (array_shift($args) == 'search') {
			$rangeInfo = Handler::getRangeInfo('submissions');

			// Get the user's search conditions, if any
			$searchField = Request::getUserVar('searchField');
			$dateSearchField = Request::getUserVar('dateSearchField');
			$searchMatch = Request::getUserVar('searchMatch');
			$search = Request::getUserVar('search');
			
			$countryField = Request::getUserVar('countryField');
			
			$sort = Request::getUserVar('sort');
			$sort = isset($sort) ? $sort : 'id';
			$sortDirection = Request::getUserVar('sortDirection');
			$sortDirection = (isset($sortDirection) && ($sortDirection == 'ASC' || $sortDirection == 'DESC')) ? $sortDirection : 'ASC';

			$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
			if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
			$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
			if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);

			if ($sort == 'status') {
				$rawSubmissions =& $editorSubmissionDao->_getUnfilteredEditorSubmissions(
					$journal->getId(),
					Request::getUserVar('section'),
					0,
					$searchField,
					$searchMatch,
					$search,
					$dateSearchField,
					$fromDate,
					$toDate,
					$countryField,
					null,
					null,
					$sort,
					$sortDirection
				);
				$submissions = new DAOResultFactory($rawSubmissions, $editorSubmissionDao, '_returnEditorSubmissionFromRow');

				// Sort all submissions by status, which is too complex to do in the DB
				$submissionsArray = $submissions->toArray();
				$compare = create_function('$s1, $s2', 'return strcmp($s1->getSubmissionStatus(), $s2->getSubmissionStatus());');
				usort ($submissionsArray, $compare);
				if($sortDirection == 'DESC') {
					$submissionsArray = array_reverse($submissionsArray);
				}
				// Convert submission array back to an ItemIterator class
				import('lib.pkp.classes.core.ArrayItemIterator');
				$submissions =& ArrayItemIterator::fromRangeInfo($submissionsArray, $rangeInfo);
			}  else {
				$rawSubmissions =& $editorSubmissionDao->_getUnfilteredEditorSubmissions(
					$journal->getId(),
					Request::getUserVar('section'),
					0,
					$searchField,
					$searchMatch,
					$search,
					$dateSearchField,
					$fromDate,
					$toDate,
					$countryField,
					null,
					$rangeInfo,
					$sort,
					$sortDirection
				);
				$submissions = new DAOResultFactory($rawSubmissions, $editorSubmissionDao, '_returnEditorSubmissionFromRow');
			}

			$templateMgr->assign_by_ref('submissions', $submissions);
			$templateMgr->assign('section', Request::getUserVar('section'));

			// Set search parameters
			foreach ($this->getSearchFormDuplicateParameters() as $param)
				$templateMgr->assign($param, Request::getUserVar($param));

			$templateMgr->assign('dateFrom', $fromDate);
			$templateMgr->assign('dateTo', $toDate);
			
			// Added by igm 9/24/11
			$templateMgr->assign('countryField', $countryField);
			
			$templateMgr->assign('displayResults', true);
			$templateMgr->assign('sort', $sort);
			$templateMgr->assign('sortDirection', $sortDirection);
		}

		$submissionsCount =& $editorSubmissionDao->getEditorSubmissionsCount($journal->getId());
		$templateMgr->assign('submissionsCount', $submissionsCount);
		$templateMgr->assign('helpTopicId', 'editorial.editorsRole');
		$templateMgr->display('editor/index.tpl');
	}

	/**
	 * Display editor submission queue pages.
	 */
	function submissions($args) {
		$this->validate();
		$this->setupTemplate(EDITOR_SECTION_SUBMISSIONS);

		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();

		$editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		$page = isset($args[0]) ? $args[0] : '';
		$sections =& $sectionDao->getSectionTitles($journalId);

		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'id';
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == 'ASC' || $sortDirection == 'DESC')) ? $sortDirection : 'ASC';

		$filterEditorOptions = array(
			FILTER_EDITOR_ALL => Locale::Translate('editor.allEditors'),
			FILTER_EDITOR_ME => Locale::Translate('editor.me')
		);

		$filterSectionOptions = array(
			FILTER_SECTION_ALL => Locale::Translate('editor.allSections')
		) + $sections;

		// Get the user's search conditions, if any
		$searchField = Request::getUserVar('searchField');
		$dateSearchField = Request::getUserVar('dateSearchField');
		$searchMatch = Request::getUserVar('searchMatch');
		$search = Request::getUserVar('search');
		
		
		/**
		 * Get user's search conditions for research field and regions
		 */
		$researchFieldField = Request::getUserVar('researchFieldField');
		$countryField = Request::getUserVar('countryField');

		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);

		$rangeInfo = Handler::getRangeInfo('submissions');

		switch($page) {
			case 'submissionsUnassigned':
				$functionName = 'getEditorSubmissionsUnassigned';
				$helpTopicId = 'editorial.editorsRole.submissions.unassigned';
				break;
			case 'submissionsInEditing':
				$functionName = 'getEditorSubmissionsInEditingIterator';
				$helpTopicId = 'editorial.editorsRole.submissions.inEditing';
				break;
			case 'submissionsArchives':
				$functionName = 'getEditorSubmissionsArchives';
				$helpTopicId = 'editorial.editorsRole.submissions.archives';
				break;
			default:
				$page = 'submissionsInReview';
				$functionName = 'getEditorSubmissionsInReviewIterator';
				$helpTopicId = 'editorial.editorsRole.submissions.inReview';
		}

		$filterEditor = Request::getUserVar('filterEditor');
		if ($filterEditor != '' && array_key_exists($filterEditor, $filterEditorOptions)) {
			$user->updateSetting('filterEditor', $filterEditor, 'int', $journalId);
		} else {
			$filterEditor = $user->getSetting('filterEditor', $journalId);
			if ($filterEditor == null) {
				$filterEditor = FILTER_EDITOR_ALL;
				$user->updateSetting('filterEditor', $filterEditor, 'int', $journalId);
			}
		}

		if ($filterEditor == FILTER_EDITOR_ME) {
			$editorId = $user->getId();
		} else {
			$editorId = FILTER_EDITOR_ALL;
		}

		$filterSection = Request::getUserVar('filterSection');
		if ($filterSection != '' && array_key_exists($filterSection, $filterSectionOptions)) {
			$user->updateSetting('filterSection', $filterSection, 'int', $journalId);
		} else {
			$filterSection = $user->getSetting('filterSection', $journalId);
			if ($filterSection == null) {
				$filterSection = FILTER_SECTION_ALL;
				$user->updateSetting('filterSection', $filterSection, 'int', $journalId);
			}
		}
		//workaround for multiple use of iterator in one page 3/21/2012
		$submissions =& $editorSubmissionDao->$functionName(
			$journalId,$filterSection,$editorId,$searchField,$searchMatch,$search,$dateSearchField,$fromDate,
			$toDate,$researchFieldField,$countryField,$rangeInfo,$sort,$sortDirection);
		$submissions1 =& $editorSubmissionDao->$functionName(
			$journalId,$filterSection,$editorId,$searchField,$searchMatch,$search,$dateSearchField,$fromDate,
			$toDate,$researchFieldField,$countryField,$rangeInfo,$sort,$sortDirection);
		$submissions2 =& $editorSubmissionDao->$functionName(
			$journalId,$filterSection,$editorId,$searchField,$searchMatch,$search,$dateSearchField,$fromDate,
			$toDate,$researchFieldField,$countryField,$rangeInfo,$sort,$sortDirection);
		$submissions3 =& $editorSubmissionDao->$functionName(
			$journalId,$filterSection,$editorId,$searchField,$searchMatch,$search,$dateSearchField,$fromDate,
			$toDate,$researchFieldField,$countryField,$rangeInfo,$sort,$sortDirection);
		$submissions4 =& $editorSubmissionDao->$functionName(
			$journalId,$filterSection,$editorId,$searchField,$searchMatch,$search,$dateSearchField,$fromDate,
			$toDate,$researchFieldField,$countryField,$rangeInfo,$sort,$sortDirection);
		

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('editor', $user->getFullName());
		$templateMgr->assign('editorOptions', $filterEditorOptions);
		$templateMgr->assign('sectionOptions', $filterSectionOptions);
		
		$templateMgr->assign_by_ref('submissions', $submissions);
		$templateMgr->assign_by_ref('submissions1', $submissions1);
		$templateMgr->assign_by_ref('submissions2', $submissions2);
		$templateMgr->assign_by_ref('submissions3', $submissions3);
		$templateMgr->assign_by_ref('submissions4', $submissions4);
		$templateMgr->assign('filterEditor', $filterEditor);
		$templateMgr->assign('filterSection', $filterSection);

		// Set search parameters
		foreach ($this->getSearchFormDuplicateParameters() as $param)
			$templateMgr->assign($param, Request::getUserVar($param));

		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign('fieldOptions', $this->getSearchFieldOptions());
		$templateMgr->assign('dateFieldOptions', $this->getDateFieldOptions());
		
		/*********************************************************************
		 * Get list of all research fields from the XML file and get all regions
         *********************************************************************/
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$researchFields =& $articleDao->getResearchFields();
		
        $countryDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
        $countries =& $countryDAO->getAreasOfTheCountry();
       
		$templateMgr->assign_by_ref('researchFields', $researchFields);
        $templateMgr->assign_by_ref('countries', $countries);

		import('classes.issue.IssueAction');
		$issueAction = new IssueAction();
		$templateMgr->register_function('print_issue_id', array($issueAction, 'smartyPrintIssueId'));

		$templateMgr->assign('helpTopicId', $helpTopicId);
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);

		$templateMgr->assign('researchFieldField', $researchFieldField);
		$templateMgr->assign('countryField', $countryField);
		
		$templateMgr->display('editor/submissions.tpl');
	}

	/**
	 * Get the list of parameter names that should be duplicated when
	 * displaying the search form (i.e. made available to the template
	 * based on supplied user data).
	 * @return array
	 */
	function getSearchFormDuplicateParameters() {
		return array(
			'searchField', 'searchMatch', 'search',
			'dateFromMonth', 'dateFromDay', 'dateFromYear',
			'dateToMonth', 'dateToDay', 'dateToYear',
			'dateSearchField'
		);
	}

	/**
	 * Get the list of fields that can be searched by contents.
	 * @return array
	 */
	function getSearchFieldOptions() {
		return array(
			SUBMISSION_FIELD_TITLE => 'article.title',
			SUBMISSION_FIELD_AUTHOR => 'user.role.author',
			SUBMISSION_FIELD_ID => 'article.submissionId'
			//SUBMISSION_FIELD_EDITOR => 'user.role.editor',
			//SUBMISSION_FIELD_REVIEWER => 'user.role.reviewer',
			//SUBMISSION_FIELD_COPYEDITOR => 'user.role.copyeditor',
			//SUBMISSION_FIELD_LAYOUTEDITOR => 'user.role.layoutEditor',
			//SUBMISSION_FIELD_PROOFREADER => 'user.role.proofreader'
		);
	}

	/**
	 * Get the list of date fields that can be searched.
	 * @return array
	 */
	function getDateFieldOptions() {
		return array(
			SUBMISSION_FIELD_DATE_SUBMITTED => 'submissions.submitted',
			//SUBMISSION_FIELD_DATE_COPYEDIT_COMPLETE => 'submissions.copyeditComplete',
			//SUBMISSION_FIELD_DATE_LAYOUT_COMPLETE => 'submissions.layoutComplete',
			//SUBMISSION_FIELD_DATE_PROOFREADING_COMPLETE => 'submissions.proofreadingComplete'
			SUBMISSION_FIELD_DATE_APPROVED => 'submissions.dateApproved'
		);
	}
	
	/**
	 * Delete a submission.
	 */
	function deleteSubmission($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		parent::setupTemplate(true);

		$journal =& Request::getJournal();

		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$article =& $articleDao->getArticle($articleId);

		$status = $article->getStatus();

		if ($article->getJournalId() == $journal->getId() && ($status == STATUS_DECLINED || $status == STATUS_ARCHIVED)) {
			// Delete article files
			import('classes.file.ArticleFileManager');
			$articleFileManager = new ArticleFileManager($articleId);
			$articleFileManager->deleteArticleTree();

			// Delete article database entries
			$articleDao->deleteArticleById($articleId);
		}

		Request::redirect(null, null, 'submissions', 'submissionsArchives');
	}

	/**
	 * Setup common template variables.
	 * @param $level int set to 0 if caller is at the same level as this handler in the hierarchy; otherwise the number of levels below this handler
	 */
	function setupTemplate($level = EDITOR_SECTION_HOME, $articleId = 0, $parentPage = null) {
		parent::setupTemplate();

		// Layout Editors have access to some Issue Mgmt functions. Make sure we give them
		// the appropriate breadcrumbs and sidebar.
		$isLayoutEditor = Request::getRequestedPage() == 'layoutEditor';

		$journal =& Request::getJournal();
		$templateMgr =& TemplateManager::getManager();

		if ($level==EDITOR_SECTION_HOME) $pageHierarchy = array(array(Request::url(null, 'user'), 'navigation.user'));
		else if ($level==EDITOR_SECTION_SUBMISSIONS) $pageHierarchy = array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, 'editor'), 'user.role.coordinator'), array(Request::url(null, 'editor', 'submissions'), 'article.submissions'));
		else if ($level==EDITOR_SECTION_ISSUES) $pageHierarchy = array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $isLayoutEditor?'layoutEditor':'editor'), $isLayoutEditor?'user.role.layoutEditor':'user.role.coordinator'), array(Request::url(null, $isLayoutEditor?'layoutEditor':'editor', 'futureIssues'), 'issue.issues'));

		import('classes.submission.sectionEditor.SectionEditorAction');
		$submissionCrumb = SectionEditorAction::submissionBreadcrumb($articleId, $parentPage, 'editor');
		if (isset($submissionCrumb)) {
			$pageHierarchy = array_merge($pageHierarchy, $submissionCrumb);
		}
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}
}

?>
