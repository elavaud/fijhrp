<?php

/**
 * @file SectionEditorHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SectionEditorHandler
 * @ingroup pages_sectionEditor
 *
 * @brief Handle requests for section editor functions. 
 */

// $Id$

// Filter section
define('FILTER_SECTION_ALL', 0);
import('classes.submission.sectionEditor.SectionEditorAction');
import('classes.handler.Handler');

class SectionEditorHandler extends Handler {
	/**
	 * Constructor
	 **/
	function SectionEditorHandler() {
		parent::Handler();
		
		$this->addCheck(new HandlerValidatorJournal($this));
		// FIXME This is kind of evil
		$page = Request::getRequestedPage();
		if ( $page == 'sectionEditor' )  
			$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_SECTION_EDITOR)));
		elseif ( $page == 'editor' ) 		
			$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_EDITOR)));

	}

	/**
	 * Display section editor index page.
	 */
	function index($args) {

		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$rangeInfo = Handler::getRangeInfo('submissions');
		// Get the user's search conditions, if any
		$searchField = Request::getUserVar('searchField');
		$dateSearchField = Request::getUserVar('dateSearchField');
		$searchMatch = Request::getUserVar('searchMatch');
		$search = Request::getUserVar('search');
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		$countryField = Request::getUserVar('countryField');

		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');

		$page = isset($args[0]) ? $args[0] : '';
		
		$sections =& $sectionDao->getSectionTitles($journal->getId());

		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'id';
		$sortDirection = Request::getUserVar('sortDirection');
		$filterSectionOptions = array(
			FILTER_SECTION_ALL => Locale::Translate('editor.allSections')
		) + $sections;
		switch($page) {
			case 'submissionsInReview':
				$functionName = 'getSectionEditorSubmissionsInReviewIterator';
				break;
			case 'submissionsApproved':
				$functionName = 'getSectionEditorSubmissionsApprovedIterator';
				break;
			case 'submissionsCompleted':
				$functionName = 'getSectionEditorSubmissionsCompletedIterator';
				break;
			case 'submissionsArchives':
				$functionName = 'getSectionEditorSubmissionsArchivesIterator';
				break;
			default:
				$page = 'submissionsSubmitted';
				$functionName = 'getSectionEditorSubmissionsSubmittedIterator';
		}

		$submissions =& $sectionEditorSubmissionDao->$functionName(
			$user->getSecretaryCommitteeId(),
			$journal->getId(),
			$searchField,
			$searchMatch,
			$search,
			$dateSearchField,
			$fromDate,
			$toDate,
			$countryField,
			$rangeInfo,
			$sort,
			$sortDirection
		);
		$templateMgr =& TemplateManager::getManager();
			//$templateMgr->assign('helpTopicId', $helpTopicId);
		$templateMgr->assign('sectionOptions', $filterSectionOptions);
		$templateMgr->assign_by_ref('submissions', $submissions);
			// EL on February 19th 2013
			//$templateMgr->assign('filterSection', $filterSection);
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());

		// Set search parameters
		$duplicateParameters = array(
			'searchField', 'searchMatch', 'search',
			'dateFromMonth', 'dateFromDay', 'dateFromYear',
			'dateToMonth', 'dateToDay', 'dateToYear',
			'dateSearchField'
		);
		foreach ($duplicateParameters as $param)
			$templateMgr->assign($param, Request::getUserVar($param));

		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign('fieldOptions', Array(
			SUBMISSION_FIELD_TITLE => 'article.title',
			SUBMISSION_FIELD_AUTHOR => 'user.role.author',
			SUBMISSION_FIELD_EDITOR => 'user.role.editor'
		));
		$templateMgr->assign('dateFieldOptions', Array(
			SUBMISSION_FIELD_DATE_SUBMITTED => 'submissions.submitted',
			SUBMISSION_FIELD_DATE_COPYEDIT_COMPLETE => 'submissions.copyeditComplete',
			SUBMISSION_FIELD_DATE_LAYOUT_COMPLETE => 'submissions.layoutComplete',
			SUBMISSION_FIELD_DATE_PROOFREADING_COMPLETE => 'submissions.proofreadingComplete'
		));

        $countryDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
        $countries =& $countryDAO->getAreasOfTheCountry();
        $templateMgr->assign_by_ref('countries', $countries);
        
		import('classes.issue.IssueAction');
		$issueAction = new IssueAction();
		$templateMgr->register_function('print_issue_id', array($issueAction, 'smartyPrintIssueId'));
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->assign('countryField', $countryField);
		
		$templateMgr->assign('ercId', $user->getSecretaryCommitteeId());
		
		$templateMgr->display('sectionEditor/index.tpl');
	}

	/**
	 * Setup common template variables.
	 * @param $subclass int set to 1 if caller is below submissions, set to 2 if the caller is below ERC
	 * Lasot modification: EL on February 22th 2013
	 */
	function setupTemplate($subclass = 0, $articleId = 0, $parentPage = null, $showSidebar = true) {
		parent::setupTemplate();
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_OJS_AUTHOR, LOCALE_COMPONENT_OJS_MANAGER));
		$templateMgr =& TemplateManager::getManager();
		$isEditor = Validation::isEditor();

		if (Request::getRequestedPage() == 'editor') {
			$templateMgr->assign('helpTopicId', 'editorial.editorsRole');

		} else {
			$templateMgr->assign('helpTopicId', 'editorial.sectionEditorsRole');
		}
		
		$thisUser =& Request::getUser();
		
		$roleSymbolic = $isEditor ? 'editor' : 'sectionEditor';
		$roleKey = $isEditor ? 'user.role.editor' : 'user.role.sectionEditor';
		
		if ($subclass == 1) $pageHierarchy = array(array(Request::url(null, 'user'), $roleKey), array(Request::url(null, $roleSymbolic), 'article.submissions'));
		elseif ($subclass == 2) $pageHierarchy = array(array(Request::url(null, 'user'), $roleKey), array(Request::url(null, $roleSymbolic, 'section', $thisUser->getSecretaryCommitteeId()), 'section.section'));
		else $pageHierarchy = array(array(Request::url(null, 'user'), $roleKey));
		
		import('classes.submission.sectionEditor.SectionEditorAction');
		$submissionCrumb = SectionEditorAction::submissionBreadcrumb($articleId, $parentPage, $roleSymbolic);
		if (isset($submissionCrumb)) {
			$pageHierarchy = array_merge($pageHierarchy, $submissionCrumb);
		}
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}


	/**
	 * Search for users to enroll as reviewers.
	 * Last modified: EL on February 16th 2013
	 * Enroll only enrollable users (no reviewers, secretaries, 
	 * administrators or  coordinators)
	 * Originally comming from SubmissionEditHandler 
	 * (just doing the redirection after the enrollment)
	 * Which is not anymore the case
	 */
	function enrollSearch($args) {
		$sectionId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate(true);
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_MANAGER)); // manager.people.enrollment, manager.people.enroll
		$journal =& Request::getJournal();

		
		// For security purposes
		$thisUser =& Request::getUser();
		if ($thisUser->getSecretaryCommitteeId() == $sectionId) {		
			$roleDao =& DAORegistry::getDAO('RoleDAO');
			$roleId = $roleDao->getRoleIdFromPath('reviewer');

			$rangeInfo = Handler::getRangeInfo('users');
			$templateMgr =& TemplateManager::getManager();
			$this->setupTemplate(2);

			$searchType = null;
			$searchMatch = null;
			$search = $searchQuery = Request::getUserVar('search');
			$searchInitial = Request::getUserVar('searchInitial');
			if (!empty($search)) {
				$searchType = Request::getUserVar('searchField');
				$searchMatch = Request::getUserVar('searchMatch');

			} elseif (!empty($searchInitial)) {
				$searchInitial = String::strtoupper($searchInitial);
				$searchType = USER_FIELD_INITIAL;
				$search = $searchInitial;
			}
			
			$sort = Request::getUserVar('sort');
			$sort = isset($sort) ? $sort : 'name';
			$sortDirection = Request::getUserVar('sortDirection');
		
			$userDao =& DAORegistry::getDAO('UserDAO');		
			$users =& $userDao->getEnrollableUsers($journal->getId(), $searchType, $searchMatch, $search, false, $rangeInfo, $sort, $sortDirection);
		
			$sectionDao =& DAORegistry::getDAO('SectionDAO');
			$erc =& $sectionDao->getSection($sectionId);

			$templateMgr->assign('ercAbbrev', $erc->getLocalizedAbbrev());
			$templateMgr->assign('searchField', $searchType);
			$templateMgr->assign('searchMatch', $searchMatch);
			$templateMgr->assign('search', $searchQuery);
			$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));

			$templateMgr->assign('sort', $sort);
			$templateMgr->assign('sortDirection', $sortDirection);
		
			$templateMgr->assign('fieldOptions', Array(
				//USER_FIELD_INTERESTS => 'user.interests',
				USER_FIELD_FIRSTNAME => 'user.firstName',
				USER_FIELD_LASTNAME => 'user.lastName',
				USER_FIELD_USERNAME => 'user.username',
				USER_FIELD_EMAIL => 'user.email'
			));
			$templateMgr->assign('sectionId', $sectionId);
			$templateMgr->assign('roleId', $roleId);
			$templateMgr->assign_by_ref('users', $users);
			$templateMgr->assign('alphaList', explode(' ', Locale::translate('common.alphaList')));

			$templateMgr->assign('helpTopicId', 'journal.roles.index');
			$templateMgr->display('sectionEditor/searchUsers.tpl');
		} else Request::redirect(null, 'user');
	}

	/**
	 * Enrollment of a new committee member
	 * Last modified: EL on February 17th 2013
	 * Originally comming from SubmissionEditHandler
	 * (just doing the redirection after the enrollment)
	 * Which is not anymore the case
	 */
	function enroll($args) {
		$sectionId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate(true);
		$journal =& Request::getJournal();
		
		// For security purposes
		$thisUser =& Request::getUser();
		if ($thisUser->getSecretaryCommitteeId() == $sectionId) {
			
			$roleDao =& DAORegistry::getDAO('RoleDAO');
			$roleId = $roleDao->getRoleIdFromPath('reviewer');
		
			// Get all the secretaries enrolled in this specific erc
			$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
			$secretaries = $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $sectionId);
		
			// Get all the different members enrolled in this specific erc
			$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');		
			$reviewers = $ercReviewersDao->getReviewersBySectionId($journal->getId(), $sectionId);
			$chairs = $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $sectionId, 1);
			$viceChairs = $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $sectionId, 2);
		
			$users = Request::getUserVar('users');
			if (!is_array($users) && Request::getUserVar('userId') != null) $users = array(Request::getUserVar('userId'));
		
			$ercMemberStatus =& Request::getUserVar('ercStatus');

			// Enroll secretaries
			if (($ercMemberStatus == "Secretary") && ((count($secretaries) + count($users)) < 6)){
				$roleId = $roleDao->getRoleIdFromPath('sectionEditor');
				for ($i=0; $i<count($users); $i++) {
					if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId) && !$sectionEditorsDao->ercSecretaryExists($journal->getId(), $sectionId, $users[$i])) {
						$role = new Role();
						$role->setJournalId($journal->getId());
						$role->setUserId($users[$i]);
						$role->setRoleId($roleId);

						$roleDao->insertRole($role);
					
						$sectionEditorsDao->insertEditor($journal->getId(), $sectionId, $users[$i], 1, 1);
					}
				}
				Request::redirect(null, null, 'section', $sectionId);
			} 
			// Enroll erc members (reviewers, chair, vice chair)
			elseif ((($ercMemberStatus == "Chair") && ((count($chairs) + count($users)) < 2)) || (($ercMemberStatus == "Member") && ((count($reviewers) + count($users)) < 21)) || (($ercMemberStatus == "Vice-Chair") && ((count($viceChairs) + count($users)) < 2))) {
				for ($i=0; $i<count($users); $i++) {
					if (!$ercReviewersDao->ercReviewerExists($journal->getId(), $sectionId, $users[$i])) {
							
						// Create the role and insert it
						if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
							$role = new Role();
							$role->setJournalId($journal->getId());
							$role->setUserId($users[$i]);
							$role->setRoleId($roleId);
							$roleDao->insertRole($role);						
						}
							
						// Assign the reviewer to the specified committee
						if ($ercMemberStatus == "Chair") $status = 1;
						elseif ($ercMemberStatus == "Vice-Chair") $status = 2;
						elseif ($ercMemberStatus == "Member") $status = 3;
							
						$ercReviewersDao->insertReviewer($journal->getId(), $sectionId, $users[$i], $status);
					}
				}
				Request::redirect(null, null, 'section', $sectionId);	
			}		
			Request::redirect(null, null, 'enrollSearch', $sectionId);
		} else Request::redirect(null, 'user');
	}

	/**
	 * Unenroll a user from a role.
	 * Added by EL on February 17th 2013
	 */
	function unEnroll($args) {
		$roleId = (int) array_shift($args);
		$journalId = (int) Request::getUserVar('journalId');
		$userId = (int) Request::getUserVar('userId');
		$sectionId = (int) Request::getUserVar('sectionId');
		
		$thisUser =& Request::getUser();
		
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		
		// For security purposes
		if ($thisUser->getSecretaryCommitteeId() == $sectionId) {
			if ($roleId=='512'){
				$sectionEditorsDAO =& DAORegistry::getDAO('SectionEditorsDAO');
				$sectionEditorsDAO->deleteEditorsByUserId($userId);
				$roleDao->deleteRoleByUserId($userId, $journalId, $roleId);
			} elseif ($roleId=='4096') {
				$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
				$ercReviewersDao->deleteReviewersByUserId($userId, $journalId);
				if (!$ercReviewersDao->isErcReviewer($journalId, $userId)) $roleDao->deleteRoleByUserId($userId, $journalId, $roleId);			
			}
			Request::redirect(null, null, 'section', $sectionId);		
		} else Request::redirect(null, 'user');
	}
		
	/**
	 * Display the membership of the ERC
	 * Added by EL on February 17th 2013
	 */	
	function section($args){
		$sectionId = isset($args[0]) ? (int) $args[0] : 0;
		$templateMgr =& TemplateManager::getManager();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		
		// For security purposes
		$thisUser =& Request::getUser();
		if ($thisUser->getSecretaryCommitteeId() == $sectionId) {
			
			// Get ERC
			$sectionDao =& DAORegistry::getDAO('SectionDAO');
			$erc =& $sectionDao->getSection($sectionId);
		
			// Get all the secretaries enrolled in this specific erc
			$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
			$secretaries = $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $sectionId);
		
			// Get all the different members enrolled in this specific erc
			$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');		
			$members = $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $sectionId, 3);
			$chairs = $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $sectionId, 1);
			$viceChairs = $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $sectionId, 2);		
		
			$templateMgr->assign_by_ref('erc', $erc);
			$templateMgr->assign_by_ref('secretaries', $secretaries);
			$templateMgr->assign_by_ref('members', $members);
			$templateMgr->assign_by_ref('chairs', $chairs);
			$templateMgr->assign_by_ref('viceChairs', $viceChairs);
			$templateMgr->assign_by_ref('thisUser', Request::getUser());
			$templateMgr->assign('sectionId', $sectionId);
		
			$templateMgr->display('sectionEditor/section.tpl');
		} else Request::redirect(null, 'user');
	}


	/**
	 * Create a new user as a reviewer.
	 * Come from SubmissionEditHandler
	 * Moved here by EL on February 21th 2013
	 */
	function createReviewer($args, &$request) {
		$sectionId = isset($args[0]) ? (int) $args[0] : 0;

		// For security purposes
		$thisUser =& Request::getUser();
		if ($thisUser->getSecretaryCommitteeId() == $sectionId) {		
			import('classes.sectionEditor.form.CreateReviewerForm');
			$createReviewerForm = new CreateReviewerForm($sectionId);
			$this->setupTemplate(2);

			if (isset($args[1]) && $args[1] === 'create') {
				$createReviewerForm->readInputData();
				if ($createReviewerForm->validate()) {
					// Create a user and enroll them as a reviewer.
					$createReviewerForm->execute();
					Request::redirect(null, null, 'section', $sectionId);
				} else {
					$createReviewerForm->display($args, $request);
				}
			} else {
				// Display the "create user" form.
				if ($createReviewerForm->isLocaleResubmit()) {
					$createReviewerForm->readInputData();
				} else {
					$createReviewerForm->initData();
				}
				$createReviewerForm->display($args, $request);
			}
		} else Request::redirect(null, 'user');
	}
	
	
	/**
	 * Create a new user as an external reviewer.
	 * Added by aglet
	 * Last Update: February 22th 2013 by EL
	 * Moved from SubmissionEditHandler to here
	 */
	function createExternalReviewer($args, &$request) {
		$sectionId = isset($args[0]) ? (int) $args[0] : 0;

		// For security purposes
		$thisUser =& Request::getUser();
		if ($thisUser->getSecretaryCommitteeId() == $sectionId) {
			import('classes.sectionEditor.form.CreateExternalReviewerForm');
			$createReviewerForm = new CreateExternalReviewerForm($sectionId);
			$this->setupTemplate(2);

			if (isset($args[1]) && $args[1] === 'create') {
				$createReviewerForm->readInputData();
				if ($createReviewerForm->validate()) {
					// Create a user and enroll them as a reviewer.				
					$createReviewerForm->execute();
					Request::redirect(null, null, 'section', $sectionId);
				} else {
					$createReviewerForm->display($args, $request);
				}
			} else {
				// Display the "create user" form.
				if ($createReviewerForm->isLocaleResubmit()) {
					$createReviewerForm->readInputData();
				} else {
					$createReviewerForm->initData();
				}
				$createReviewerForm->display($args, $request);
			}
		} else Request::redirect(null, 'user');
	}
			
	/**
	 * Display submission management instructions.
	 * @param $args (type)
	 */
	function instructions($args) {
		$this->setupTemplate();
		import('classes.submission.proofreader.ProofreaderAction');
		if (!isset($args[0]) || !ProofreaderAction::instructions($args[0], array('copy', 'proof', 'referenceLinking'))) {
			Request::redirect(null, null, 'index');
		}
	}
}

?>
