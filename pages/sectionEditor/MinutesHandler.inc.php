<?php

/**
 * class MinutesHandler for SectionEditor and Editor Roles (STO)
 * page handler class for minutes-related operations
 * @var unknown_type
 */
define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);
define('INITIAL_REVIEW', 0x00001);
define('CONTINUING_REVIEW', 0x00002);
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
		// 02-01-2012 
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
	 * Display meeting/minutes sections accdg. to meeting_id  OR Insert attendance info or ERC members in meeting_attendance table
	 * @param $args
	 * @param $request
	 */
	function uploadMinutes($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		
		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meetingSubmissionDao =& DAORegistry::getDAO("MeetingSubmissionDAO");
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$minutesStatusMap = $meeting->getStatusMap();

		$remainingSubmissionsForInitialReview = $sectionEditorSubmissionDao->getRemainingSubmissionsForInitialReview($meetingId);
		$remainingSubmissionsForContinuingReview = $sectionEditorSubmissionDao->getRemainingSubmissionsForContinuingReview($meetingId);
		$actualMeetingSubmissionsForInitialReview = $sectionEditorSubmissionDao->getMeetingSubmissionsAssignedForInitialReview($meetingId);
		$actualMeetingSubmissionsForContinuingReview = $sectionEditorSubmissionDao->getMeetingSubmissionsAssignedForContinuingReview($meetingId);
		
		$hasProposalsForInitialReview = (count($actualMeetingSubmissionsForInitialReview)>0) ? true : false ;
		$hasProposalsForContinuingReview = (count($actualMeetingSubmissionsForContinuingReview)>0) ? true : false ;
		
		if ($minutesStatusMap[MINUTES_STATUS_INITIAL_REVIEWS]!=1 && $hasProposalsForInitialReview && (count($remainingSubmissionsForInitialReview) == 0)) {
			$meeting->updateMinutesStatus(MINUTES_STATUS_INITIAL_REVIEWS);
			$meetingDao->updateMinutesStatus($meeting);				
		}
				
		if ($minutesStatusMap[MINUTES_STATUS_CONTINUING_REVIEWS]!=1 && $hasProposalsForContinuingReview && (count($remainingSubmissionsForContinuingReview) == 0)) {
			$meeting->updateMinutesStatus(MINUTES_STATUS_CONTINUING_REVIEWS);
			$meetingDao->updateMinutesStatus($meeting);				
		}	
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign('allowInitialReview', $hasProposalsForInitialReview);
		$templateMgr->assign('allowContinuingReview', $hasProposalsForContinuingReview);
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

		$journal =& Request::getJournal();
		import('lib.pkp.classes.who.form.AttendanceForm');
		$attendanceForm = new AttendanceForm($meetingId, $journal->getId());
		$submitted = Request::getUserVar("submitAttendance") != null ? true : false;

		if($submitted) {
			$attendanceForm->readInputData();
			if($attendanceForm->validate()) {
				$attendanceForm->execute();
				$attendanceForm->savePdf();
				Request::redirect(null, null, 'uploadMinutes', $meetingId);
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
	 * Display dropdown for proposals assigned for (initial) normal ERC review
	 * @param $args
	 * @param $request
	 */
	function selectInitialReview($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, MINUTES_STATUS_INITIAL_REVIEWS);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$journal = Request::getJournal();
		import('lib.pkp.classes.who.form.ProposalsForInitialReviewForm');
		$initialReviewForm = new ProposalsForInitialReviewForm($meetingId, $journal->getId());
		$submitted = Request::getUserVar("selectProposal") != null ? true : false;
		$articleId = Request::getUserVar("articleId");
		
		if($submitted) {
			$initialReviewForm->readInputData();
			if($initialReviewForm->validate()) {
				Request::redirect(null, null, 'uploadInitialReviewFile', array($meetingId, $articleId));
			}
			else {
				if ($initialReviewForm->isLocaleResubmit()) {
					$initialReviewForm->readInputData();
				}
				else {
					$initialReviewForm->initData();
				}
				$initialReviewForm->display();
			}
		}
		else {
			$initialReviewForm->display();
		}
	}

	/**
	 * Added  6/29/2011
	 * Display form for initial review given article id and Generate pdf file for this initial review and update edit_decisions table
	 * @param $args
	 * @param $request
	 */
	function uploadInitialReviewDecision($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		
		import('lib.pkp.classes.who.form.InitialReviewDecisionForm');
		$initialReviewForm = new InitialReviewDecisionForm($meetingId, $articleId);
		$submitted = Request::getUserVar("submitInitialReview") != null ? true : false;

		if($submitted) {
			$initialReviewForm->readInputData();
			if($initialReviewForm->validate()) {
				$initialReviewForm->execute();
				$initialReviewForm->savePdf();
				Request::redirect(null, null, 'uploadMinutes', $meetingId);
			}
			else {
				if ($initialReviewForm->isLocaleResubmit()) {
					$initialReviewForm->readInputData();
				}
				else {
					$initialReviewForm->initData();
				}
				$initialReviewForm->display();
			}
		}
		else {
			$initialReviewForm->display();
		}
	}
	
	
	function uploadInitialReviewFile($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		
		import('lib.pkp.classes.who.form.UploadInitialReviewFileForm');
		$uploadReviewFileForm = new UploadInitialReviewFileForm($meetingId, $articleId);
		
		if($request->getUserVar('uploadMinutesFile')) {
			$uploadReviewFileForm->readInputData();
			if($uploadReviewFileForm->validate()) {
				$uploadReviewFileForm->execute();				
				Request::redirect(null, null, 'uploadInitialReviewDecision', array($meetingId, $articleId));
			}
			else {
				if ($uploadReviewFileForm->isLocaleResubmit()) {
					$uploadReviewFileForm->readInputData();
				}
				else {
					$uploadReviewFileForm->initData();
				}
				$uploadReviewFileForm->display();
			}
		}
		else {
			$uploadReviewFileForm->display();
		}				
	}
	
	function completeInitialReviews($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, MINUTES_STATUS_INITIAL_REVIEWS);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meeting->updateMinutesStatus(MINUTES_STATUS_INITIAL_REVIEWS);
		$meetingDao->updateMinutesStatus($meeting);
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
	}
	
	/**
	 * Added  6/29/2011
	 * Display dropdown for proposals assigned for (continuing) normal ERC review
	 * @param $args
	 * @param $request
	 */
	function selectContinuingReview($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, MINUTES_STATUS_CONTINUING_REVIEWS);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$journal = Request::getJournal();
		import('lib.pkp.classes.who.form.ProposalsForContinuingReviewForm');
		$continuingReviewForm = new ProposalsForContinuingReviewForm($meetingId, $journal->getId());
		$submitted = Request::getUserVar("selectProposal") != null ? true : false;
		$articleId = Request::getUserVar("articleId");
		
		if($submitted) {
			$continuingReviewForm->readInputData();
			if($continuingReviewForm->validate()) {
				Request::redirect(null, null, 'uploadContinuingReviewFile', array($meetingId, $articleId));
			}
			else {
				if ($continuingReviewForm->isLocaleResubmit()) {
					$continuingReviewForm->readInputData();
				}
				else {
					$continuingReviewForm->initData();
				}
				$continuingReviewForm->display();
			}
		}
		else {
			$continuingReviewForm->display();
		}
	}
	
	/**
	 * Added  6/29/2011
	 * Display form for continuing review given article id and Generate pdf file for this continuing review and update edit_decisions table
	 * @param $args
	 * @param $request
	 */
	function uploadContinuingReviewDecision($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, CONTINUING_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;

		import('lib.pkp.classes.who.form.ContinuingReviewDecisionForm');
		$continuingReviewForm = new ContinuingReviewDecisionForm($meetingId, $articleId);
		$submitted = Request::getUserVar("submitContinuingReview") != null ? true : false;

		if($submitted) {
			$continuingReviewForm->readInputData();
			if($continuingReviewForm->validate()) {
				$continuingReviewForm->execute();
				$continuingReviewForm->savePdf();
				Request::redirect(null, null, 'uploadMinutes', $meetingId);
			}
			else {
				if ($continuingReviewForm->isLocaleResubmit()) {
					$continuingReviewForm->readInputData();
				}
				else {
					$continuingReviewForm->initData();
				}
				$continuingReviewForm->display();
			}
		}
		else {
			$continuingReviewForm->display();
		}
	}
	
	function uploadContinuingReviewFile($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		
		import('lib.pkp.classes.who.form.UploadContinuingReviewFileForm');
		$uploadReviewFileForm = new UploadContinuingReviewFileForm($meetingId, $articleId);
		
		if($request->getUserVar('uploadMinutesFile')) {
			$uploadReviewFileForm->readInputData();
			if($uploadReviewFileForm->validate()) {
				$uploadReviewFileForm->execute();				
				Request::redirect(null, null, 'uploadContinuingReviewDecision', array($meetingId, $articleId));
			}
			else {
				if ($uploadReviewFileForm->isLocaleResubmit()) {
					$uploadReviewFileForm->readInputData();
				}
				else {
					$uploadReviewFileForm->initData();
				}
				$uploadReviewFileForm->display();
			}
		}
		else {
			$uploadReviewFileForm->display();
		}				
	}
	
	function completeContinuingReviews($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, MINUTES_STATUS_CONTINUING_REVIEWS);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meeting->updateMinutesStatus(MINUTES_STATUS_CONTINUING_REVIEWS);
		$meetingDao->updateMinutesStatus($meeting);
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
	}

	/**
	 * Update minutes_status as complete, activate download link
	 * @param $args
	 * @param $request
	 */
	function setMinutesFinal($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meeting->setMinutesStatus(MINUTES_STATUS_COMPLETE);
		$meeting->setStatus(STATUS_DONE);
		$meetingDao->updateMinutesStatus($meeting);
		$meetingDao->updateStatus($meeting->getId(), STATUS_DONE);
		Request::redirect(null, null, 'uploadMinutes', $meetingId);
	}

	/*Added by MSB, July 20, 2010*/

	function downloadMinutes($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meetingId);
		return $minutesFileManager->downloadMinutesArchive();
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
		else {
			$isValid = false;
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

		if ($reviewType == INITIAL_REVIEW) {
			if ($articleId == 0)
				Request::redirect(null, null, 'selectInitialReview', $this->meeting->getId());
		}
		if ($reviewType == CONTINUING_REVIEW) {
			if ($articleId == 0)
				Request::redirect(null, null, 'selectContinuingReview', $this->meeting->getId());
		}
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
