<?php

/**
 * class MinutesHandler for SectionEditor and Editor Roles (STO)
 * page handler class for minutes-related operations
 * @var unknown_type
 */
define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);
// Filter section
define('FILTER_SECTION_ALL', 0);

import('classes.submission.sectionEditor.SectionEditorAction');
import('classes.handler.Handler');
import('lib.pkp.classes.who.Meeting');

class MinutesHandler extends Handler {
	/**
	 * Constructor
	 **/
	function MinutesHandler() {
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
	 * Setup common template variables.
	 * @param $subclass boolean set to true if caller is below this handler in the hierarchy
	 */
	function setupTemplate($subclass = false, $articleId = 0, $parentPage = null, $showSidebar = true) {
		parent::setupTemplate();
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_OJS_AUTHOR, LOCALE_COMPONENT_OJS_MANAGER));
		$templateMgr =& TemplateManager::getManager();
		$isEditor = Validation::isEditor();

		if (Request::getRequestedPage() == 'editor') {
			$templateMgr->assign('helpTopicId', 'editorial.editorsRole');

		} else {
			$templateMgr->assign('helpTopicId', 'editorial.sectionEditorsRole');
		}

		$roleSymbolic = $isEditor ? 'editor' : 'sectionEditor';
		$roleKey = $isEditor ? 'user.role.editor' : 'user.role.sectionEditor';
		$pageHierarchy = $subclass ? array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey), array(Request::url(null, $roleSymbolic), 'article.submissions'))
			: array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey));

		import('classes.submission.sectionEditor.SectionEditorAction');
		$submissionCrumb = SectionEditorAction::submissionBreadcrumb($articleId, $parentPage, $roleSymbolic);
		if (isset($submissionCrumb)) {
			$pageHierarchy = array_merge($pageHierarchy, $submissionCrumb);
		}
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
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
	
	/**
	 * Added  6/29/2011
	 * Display list of uploaded minutes or allow STO to create a new one
	 * @param $args
	 * @param $request
	 */
	function minutes($args) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$meetings =& $meetingDao->getMeetingsOfUser($userId);
				
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meetings', $meetings); 
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());
		$templateMgr->display('sectionEditor/minutes/minutes.tpl');
	}
	
	/**
	 * Added  6/29/2011
	 * Display meeting/minutes sections accdg. to meeting_id 
	 * @param $args
	 * @param $request
	 */
	function uploadMinutes($args, $request) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		if($meetingId == null) {
			Request::redirect(null, null, 'minutes', null);
		}
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		
		$templateMgr =& TemplateManager::getManager();		
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());	
		$templateMgr->display('sectionEditor/minutes/uploadMinutes.tpl');
	}
	
	/**
	 * Added  6/29/2011
	 * Display form for attendance
	 * @param $args
	 * @param $request
	 */
	function uploadAttendance($args, $request) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$meetingId = isset($args[0]) ? $args[0]: 0;

		if($meetingId == 0) {
			Request::redirect(null, null, 'minutes', null);
		}
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$statusMap = $meeting->getStatusMap();
		
		if($statusMap[MEETING_STATUS_ATTENDANCE]) {
			Request::redirect(null, null, 'uploadMinutes', $meetingId);
		}
		
		import('classes.sectionEditor.form.AttendanceForm');           
		$attendanceForm = new AttendanceForm($meetingId, $journalId);
		if ($attendanceForm->isLocaleResubmit()) {
       		$attendanceForm->readInputData();
		} 
		else {
			$attendanceForm->initData();
		}
		$attendanceForm->display();
						
	}
	
	/**
	 * Added  6/29/2011
	 * Insert attendance info or ERC members in meeting_attendance table
	 * @param $args
	 * @param $request
	 */
	function submitAttendance($args, $request) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		import('classes.sectionEditor.form.AttendanceForm');
		$attendanceForm = new AttendanceForm($meetingId, $journalId);
		$attendanceForm->readInputData();
		if($attendanceForm->validate()) {
			$attendanceForm->execute();
			$attendanceForm->showPdf();
			//Request::redirect(null, null, 'uploadMinutes', $meetingId);
		}
		else {
			$attendanceForm->display();
		}	
	}
	
	/**
	 * Added  6/29/2011
	 * Display form for announcements
	 * @param $args
	 * @param $request
	 */
	function uploadAnnouncements($args, $request) {
		$this->validate();
		$this->setupTemplate();
		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		if($meetingId == 0) {
			Request::redirect(null, null, 'minutes', null);
		}
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$statusMap = $meeting->getStatusMap();
		
		if($statusMap[MEETING_STATUS_ANNOUNCEMENTS]) {
			Request::redirect(null, null, 'uploadMinutes', $meetingId);
		}
		
		import('classes.sectionEditor.form.AnnouncementsForm');           
		$announcementsForm = new AnnouncementsForm($meetingId);           
		if ($announcementsForm->isLocaleResubmit()) {
       		$announcementsForm->readInputData();
		} 
		else {
			$announcementsForm->initData();
		}
		$announcementsForm->display();		
	}
	
	/**
	 * Added  6/29/2011
	 * Update meetings table
	 * @param $args
	 * @param $request
	 */
	function submitAnnouncements($args, $request) {
		$this->validate();
		$meetingId = isset($args[0]) ? $args[0] : 0;
		
		import('classes.sectionEditor.form.AnnouncementsForm');
		$announcementsForm = new AnnouncementsForm($meetingId);
		$announcementsForm->readInputData();
		if($announcementsForm->validate()) {
			$announcementsForm->execute();
			$announcementsForm->showPdf();			
		}
		else {
			$announcementsForm->display();
		}		
	}
	
	/**
	 * Added  6/29/2011
	 * Display dropdown for proposals assigned for (initial) normal ERC review
	 * @param $args
	 * @param $request
	 */
	function selectInitialReview($args, $request) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();		
		$meetingId = isset($args[0]) ? $args[0] : 0;
		
		if($meetingId == 0) {
			Request::redirect(null, null, 'minutes', null);
		}
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$statusMap = $meeting->getStatusMap();
		
		if($statusMap[MEETING_STATUS_INITIAL_REVIEWS]) {
			Request::redirect(null, null, 'uploadMinutes', $meetingId);
		}
		
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$submissions =& $sectionEditorSubmissionDao->getSectionEditorSubmissionsForErcReview($user->getId(), $journalId, FILTER_SECTION_ALL); 
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('meetingId', $meetingId);
		$templateMgr->assign_by_ref("submissions", $submissions);
		$templateMgr->display('sectionEditor/minutes/selectInitialReview.tpl');
	}
	
	/**
	 * Added  6/29/2011
	 * Display form for initial review given article id
	 * @param $args
	 * @param $request
	 */
	function uploadInitialReview($args, $request) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$meetingId = isset($args[0]) ? $args[0] : 0;
		$articleId = Request::getUserVar('articleId');
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		if($articleId == null || $submission->getMostRecentDecision() != SUBMISSION_EDITOR_DECISION_ASSIGNED) {
			Request::redirect(null, null, 'selectInitialReview', $meetingId);
		}		
		if($meetingId == 0) {
			Request::redirect(null, null, 'minutes', null);
		}		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$statusMap = $meeting->getStatusMap();
				
		if($statusMap[MEETING_STATUS_INITIAL_REVIEWS]) {
			Request::redirect(null, null, 'uploadMinutes', $meetingId);
		}		
		import('classes.sectionEditor.form.InitialReviewForm');           
		$initialReviewForm = new InitialReviewForm($meetingId, $articleId);           
		if ($initialReviewForm->isLocaleResubmit()) {
       		$initialReviewForm->readInputData();
		} 
		else {
			$initialReviewForm->initData();
		}
		$initialReviewForm->display();		
	}
	
	/**
	 * Added  6/29/2011
	 * Generate pdf file for this initial review and update edit_decisions table
	 * @param $args
	 * @param $request
	 */
	function submitInitialReview($args, $request) {
		$articleId = Request::getUserVar('articleId');
		$meetingId = Request::getUserVar('meetingId');
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		
		if($articleId == null) {
			Request::redirect(null, null, 'selectInitialReview', $meetingId);
		}		
		
		import('classes.sectionEditor.form.InitialReviewForm');
		$initialReviewForm = new InitialReviewForm($meetingId, $articleId);
		$initialReviewForm->readInputData();
		
		if($initialReviewForm->validate()) {
			$initialReviewForm->execute();
			$initialReviewForm->showPdf();
		}
		else {
			$initialReviewForm->display();
		}
	}
	
	function completeInitialReview($args, $request) {
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$meetingId = Request::getUserVar("meetingId");
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$meeting->updateStatus(MEETING_STATUS_INITIAL_REVIEWS);
		$meetingDao->updateStatus($meeting);
						
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
	}
	

	/**
	 * Validate that the user is the assigned section editor for
	 * the article, or is a managing editor.
	 * Redirects to sectionEditor index page if validation fails.
	 * @param $articleId int Article ID to validate
	 * @param $access int Optional name of access level required -- see SECTION_EDITOR_ACCESS_... constants
	 */
	function validateAccess($articleId, $access = null) {
		parent::validate();
		$isValid = true;

		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$sectionEditorSubmission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($articleId);

		if ($sectionEditorSubmission == null) {
			$isValid = false;

		} else if ($sectionEditorSubmission->getJournalId() != $journal->getId()) {
			$isValid = false;

		} else if ($sectionEditorSubmission->getDateSubmitted() == null) {
			$isValid = false;

		} else {
			$templateMgr =& TemplateManager::getManager();

			if (Validation::isEditor()) {
				// Make canReview and canEdit available to templates.
				// Since this user is an editor, both are available.
				$templateMgr->assign('canReview', true);
				$templateMgr->assign('canEdit', true);
			} else {
				// If this user isn't the submission's editor, they don't have access.
				$editAssignments =& $sectionEditorSubmission->getEditAssignments();
				$wasFound = false;
				foreach ($editAssignments as $editAssignment) {
					if ($editAssignment->getEditorId() == $user->getId()) {
						$templateMgr->assign('canReview', $editAssignment->getCanReview());
						$templateMgr->assign('canEdit', $editAssignment->getCanEdit());
						switch ($access) {
							case SECTION_EDITOR_ACCESS_EDIT:
								if ($editAssignment->getCanEdit()) {
									$wasFound = true;
								}
								break;
							case SECTION_EDITOR_ACCESS_REVIEW:
								if ($editAssignment->getCanReview()) {
									$wasFound = true;
								}
								break;

							default:
								$wasFound = true;
						}
						break;
					}
				}

				if (!$wasFound) $isValid = false;
			}
		}

		if (!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}

		// If necessary, note the current date and time as the "underway" date/time
		$editAssignmentDao =& DAORegistry::getDAO('EditAssignmentDAO');
		$editAssignments =& $sectionEditorSubmission->getEditAssignments();
		foreach ($editAssignments as $editAssignment) {
			if ($editAssignment->getEditorId() == $user->getId() && $editAssignment->getDateUnderway() === null) {
				$editAssignment->setDateUnderway(Core::getCurrentDate());
				$editAssignmentDao->updateEditAssignment($editAssignment);
			}
		}

		$this->submission =& $sectionEditorSubmission;
		return true;
	}
	
}

?>
