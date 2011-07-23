<?php

/**
 * class MinutesHandler for SectionEditor and Editor Roles (STO)
 * page handler class for minutes-related operations
 * @var unknown_type
 */
define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);
define('INITIAL_REVIEW', 0x00001);
// Filter section
define('FILTER_SECTION_ALL', 0);

import('classes.submission.sectionEditor.SectionEditorAction');
import('classes.handler.Handler');
import('lib.pkp.classes.who.Meeting');

class MinutesHandler extends Handler {
	/**
	 * Constructor
	 **/
	var $meeting;
	
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
	function setupTemplate($subclass = false, $meetingId = 0, $parentPage = null, $showSidebar = true) {
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
		$pageHierarchy = $subclass ? array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey), array(Request::url(null, $roleSymbolic, 'meetings'), 'editor.meetings'))
		: array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey));
		
		if($meetingId!=0)
			$pageHierarchy[] = array(Request::url(null, 'sectionEditor', 'viewMeeting', $meetingId), "#$meetingId", true);
		
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
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		
		$templateMgr =& TemplateManager::getManager();		
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->display('sectionEditor/minutes/uploadMinutes.tpl');
	}
	
	/**
	 * Added  6/29/2011
	 * Display form for attendance
	 * @param $args
	 * @param $request
	 */
	function uploadAttendance($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, MINUTES_STATUS_ATTENDANCE);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		
		$journal = Request::getJournal();
		import('lib.pkp.classes.who.form.AttendanceForm');           
		$attendanceForm = new AttendanceForm($meetingId, $journal->getId());
		$submitted = Request::getUserVar("submitAttendance") != null ? true : false;
		
		if($submitted) {
			$attendanceForm->readInputData();
			if($attendanceForm->validate()) {
				$attendanceForm->execute();
				$attendanceForm->showPdf();
			}
			else {
				if ($attendanceForm->isLocaleResubmit()) {
		       		$attendanceForm->readInputData();       		
				} 
				else {
					$attendanceForm->initData();
				}
				$attendanceForm->display();
			}
		}
		else {
			$attendanceForm->display();
		}						
	}
	
	/**
	 * Added  6/29/2011
	 * Insert attendance info or ERC members in meeting_attendance table
	 * @param $args
	 * @param $request
	 */
	function submitAttendance($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		
		$journal =& Request::getJournal();
		import('lib.pkp.classes.who.form.AttendanceForm');
		$attendanceForm = new AttendanceForm($meetingId, $journal->getId());
		
		$submitAttendance = Request::getUserVar('submitAttendance') != null ? true : false;
		
		if ($submitAttendance) {
			$attendanceForm->readInputData();
			if($attendanceForm->validate()){	
					$attendanceForm->execute();
					$attendanceForm->savePdf();
					Request::redirect(null, null, 'uploadMinutes', $meetingId);			
			}else{
				if ($attendanceForm->isLocaleResubmit()) {
					$attendanceForm->readInputData();
				}
					$attendanceForm->display($args);
			}
		
		}else {
			$attendanceForm->display($args);
		}
	}
	
	/**
	 * Added  6/29/2011
	 * Display dropdown for proposals assigned for (initial) normal ERC review
	 * @param $args
	 * @param $request
	 */
	function selectInitialReview($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, MEETING_STATUS_INITIAL_REVIEWS);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$journal = Request::getJournal();
		$user = Request::getUser();
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$submissions =& $sectionEditorSubmissionDao->getSectionEditorSubmissionsForErcReview($user->getId(), $journal->getId(), FILTER_SECTION_ALL); 
		
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
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = Request::getUserVar('articleId');
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		
		import('lib.pkp.classes.who.form.InitialReviewForm');           
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
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;		
		
		import('lib.pkp.classes.who.form.InitialReviewForm');
		$initialReviewForm = new InitialReviewForm($meetingId, $articleId);
		$initialReviewForm->readInputData();
		
		if($initialReviewForm->validate()) {
			$initialReviewForm->execute();
			$initialReviewForm->savePdf();
		}
		else {
			$initialReviewForm->display();
		}
	}
	
	function completeInitialReview($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meeting->updateMinutesStatus(MINUTES_STATUS_INITIAL_REVIEWS);
		$meetingDao->updateMinutesStatus($meeting);
		
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
	}
	
	function setMinutesFinal($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meeting->setMinutesStatus(MINUTES_STATUS_COMPLETE);
		$meetingDao->updateMinutesStatus($meeting);
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
	}
		
	/*Added by MSB, July 20, 2010*/
	
	/**
	 * Download file.
	 * @param $meetingId int
	 * @param $fileId int
	 * @param $fileId int
	 */
	
	function viewMinutes($args) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meetingId);
		return $minutesFileManager->viewFile();
	}
	

	function validate($meetingId = 0, $access = null) {
		parent::validate();
		$isValid = true;
		$user = Request::getUser();
		if($meetingId != 0) {
			$meetingDao =& DAORegistry::getDAO('MeetingDAO');
			$meeting = $meetingDao->getMeetingById($meetingId);
			
			if($meeting == null)
				$isValid = false;
			else if($meeting->getUploader() != $user->getId())
				$isValid = false;			
			if($isValid)
				$this->meeting =& $meeting;
				$statusMap = $meeting->getStatusMap();
			if($access != null && $statusMap[$access] == 1) {
				Request::redirect(null, null, 'uploadMinutes', $meetingId);													
			}		
		}
		
		if(!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}
				
		return true;
	}

	/**
	 * Validate that the user is the assigned section editor for
	 * the article, or is a managing editor.
	 * Redirects to sectionEditor index page if validation fails.
	 * @param $articleId int Article ID to validate
	 * @param $access int Optional name of access level required -- see SECTION_EDITOR_ACCESS_... constants
	 */
	function validateAccess($articleId, $access = null, $reviewType = null) {
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

		} else if ($reviewType != null) {
			if ($reviewType == INITIAL_REVIEW && $sectionEditorSubmission->getMostRecentDecision() != SUBMISSION_EDITOR_DECISION_ASSIGNED) 
				Request::redirect(null, null, 'selectInitialReview', $meetingId);			
		}
		 else {
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
