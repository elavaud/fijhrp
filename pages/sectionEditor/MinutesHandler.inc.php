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
	 * Insert new minutes_table row and display meeting/minutes sections accdg. to meeting_id
	 * @param $args
	 * @param $request
	 */
	function createMinutes($args, $request) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meetingId =& $meetingDao->createMeeting($userId);
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
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
		$user =& Request::getUser();
		$userId = $user->getId();
		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$userDao =& DAORegistry::getDAO('UserDAO');
		$reviewers =& $userDao->getUsersWithReviewerRole($journalId);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('reviewers', $reviewers);
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());
		$templateMgr->display('sectionEditor/minutes/uploadAttendance.tpl');
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
		$user =& Request::getUser();
		$userId = $user->getId();
		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		$userDao =& DAORegistry::getDAO('UserDAO');
		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		
		$meetingAttendance = array();
		$reviewers =& $userDao->getUsersWithReviewerRole($journalId);
		import('lib.pkp.classes.who.MeetingAttendance');
		foreach($reviewers as $reviewer) {		
			$temp = new MeetingAttendance();			
			$temp->setMeetingId($meetingId);
			$temp->setUser($reviewer->getId());
			$name = "attendance_".$reviewer->getId();
			$remarksName = "absence_reason_".$reviewer->getId();
			$isPresent = Request::getUserVar($name);
			$remarks = Request::getUserVar($remarksName);
							
			if($isPresent == "present") {
				$temp->setIsPresent(1);
				$temp->setRemarks(null);
			}
			else {
				$temp->setIsPresent(0);
				$temp->setRemarks($remarks);
			}
			$meetingAttendance[] = $temp;			
		}
		foreach($meetingAttendance as $attendance) {
			$meetingAttendanceDao->insertMeetingAttendance($attendance);
		}
		
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$meeting->updateStatus(MEETING_STATUS_ATTENDANCE);
		$meetingDao->updateStatus($meeting);		
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
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
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		for($i=1 ; $i<=12 ; $i++) {
			$hour[$i]=$i;
		}
		for($i=0 ; $i<60 ; $i+=10) {
			$minute[$i]=$i;			
		}
		$minute['0']='00';
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('hour', $hour);
		$templateMgr->assign('minute', $minute);
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());
		$templateMgr->display('sectionEditor/minutes/uploadAnnouncements.tpl');
	}
	
	/**
	 * Added  6/29/2011
	 * Update meetings table
	 * @param $args
	 * @param $request
	 */
	function submitAnnouncements($args, $request) {
		$this->validate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$meetingId = isset($args[0]) ? $args[0] : 0;
		$hourConvened = Request::getUserVar("hourConvened");
		$minuteConvened = Request::getUserVar("minuteConvened");
		$amPmConvened = Request::getUserVar("amPmConvened");
		$hourAdjourned = Request::getUserVar("hourAdjourned");
		$minuteAdjourned = Request::getUserVar("minuteAdjourned");
		$amPmAdjourned = Request::getUserVar("amPmAdjourned");
		$dateHeld = Request::getUserVar("dateHeld");
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$dateConvened = explode('-', $dateHeld);
		$meeting->setDate(date('Y-m-d H:i:s', mktime($hourConvened, $minuteConvened, 0, $dateConvened[1], $dateConvened[0], $dateConvened[2])));
		$meetingDao->updateMeetingDate($meeting);
		
		$meeting->updateStatus(MEETING_STATUS_ANNOUNCEMENTS);
		$meetingDao->updateStatus($meeting);
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
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
		$userId = $user->getId();
		$meetingId = isset($args[0]) ? $args[0] : 0;
		
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$submissions =& $sectionEditorSubmissionDao->getSectionEditorSubmissionsForErcReview($userId, $journalId, FILTER_SECTION_ALL); 
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('meetingId', $meetingId);
		$templateMgr->assign_by_ref("submissions", $submissions);
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());
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
		$user =& Request::getUser();
		$userId = $user->getId();
		$meetingId = isset($args[0]) ? $args[0] : 0;
		$articleId = Request::getUserVar('articleId');
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		
		if($articleId == null) {
			Request::redirect(null, null, 'selectInitialReview', $meetingId);
		}
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$submission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($articleId);
		$lastDecision = $articleDao->getLastEditorDecision($articleId);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign("lastDecision", $lastDecision);
		$templateMgr->assign("meeting", $meeting);
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());
		
		$templateMgr->display('sectionEditor/minutes/uploadInitialReview.tpl');
	}
	
	/**
	 * Added  6/29/2011
	 * Generate pdf file for this initial review and update edit_decisions table
	 * @param $args
	 * @param $request
	 */
	function submitInitialReview($args, $request) {
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		$articleId = Request::getUserVar('articleId');
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		
		$meetingId = Request::getUserVar('meetingId');
		$decision = Request::getUserVar('decision');
		$resubmitCount = Request::getUserVar('resubmitCount');
		$decisionId = Request::getUserVar('lastDecisionId'); 
		$useRtoDate = Request::getUserVar('useRtoDate');
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		
		$dateDecided = ($decision == SUBMISSION_EDITOR_DECISION_ACCEPT && $useRtoDate == "1") ? $submission->getLocalizedStartDate() : $meeting->getDate() ; 
		
		switch ($decision) {
			case SUBMISSION_EDITOR_DECISION_ACCEPT:
			case SUBMISSION_EDITOR_DECISION_RESUBMIT:
			case SUBMISSION_EDITOR_DECISION_DECLINE:			
				SectionEditorAction::recordDecision($submission, $decision, $decisionId, $resubmitCount, $dateDecided);
				break;
		}		
		
		Request::redirect(null, null, 'selectInitialReview', $meetingId);
	}
	
	function completeInitialReview($args, $request) {
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		$meetingId = Request::getUserVar("meetingId");
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$meeting->updateStatus(MEETING_STATUS_INITIAL_REVIEWS);
		$meetingDao->updateStatus($meeting);
						
		/*$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());*/
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
