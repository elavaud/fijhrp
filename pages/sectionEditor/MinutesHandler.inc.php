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
import('classes.meeting.Meeting');

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

		if($meetingId!=0) {
			$meetingDao =& DAORegistry::getDAO('MeetingDAO');
			$meeting =& $meetingDao->getMeetingById($meetingId);
			$publicId = $meeting->getPublicId();
			$pageHierarchy[] = array(Request::url(null, 'sectionEditor', 'viewMeeting', $meetingId), "#$publicId", true);
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
	 * Last updated by EL on February 25th 2013
	 */
	function minutes($args) {
		$this->validate();
		$this->setupTemplate();
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();

		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$meetings =& $meetingDao->getMeetingsOfSection($user->getSecretaryCommitteeId());

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
	function manageMinutes($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		
		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meetingSubmissionDao =& DAORegistry::getDAO("MeetingSubmissionDAO");
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$minutesFileDao =& DAORegistry::getDAO('MinutesFileDAO');
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
		
		$generatedAttendanceFile =& $minutesFileDao->getGeneratedMinutesFile($meetingId, 'attendance');
		$uploadedAttendanceFiles =& $minutesFileDao->getUploadedMinutesFiles($meetingId, 'attendance');
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('generatedAttendanceFile', $generatedAttendanceFile);
		$templateMgr->assign_by_ref('uploadedAttendanceFiles', $uploadedAttendanceFiles);
		$templateMgr->assign('allowInitialReview', $hasProposalsForInitialReview);
		$templateMgr->assign('allowContinuingReview', $hasProposalsForContinuingReview);
		$templateMgr->display('sectionEditor/minutes/manageMinutes.tpl');
	}

	/**
	 * Added  6/29/2011
	 * Display form for attendance
	 * @param $args
	 * @param $request
	 */
	function generateAttendance($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, MINUTES_STATUS_ATTENDANCE);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;

		$journal =& Request::getJournal();
		import('classes.meeting.form.AttendanceForm');
		$attendanceForm = new AttendanceForm($meetingId, $journal->getId());
		$submitted = Request::getUserVar("submitAttendance") != null ? true : false;

		if($submitted) {
			$attendanceForm->readInputData();
			if($attendanceForm->validate()) {
				$attendanceForm->execute();
				$attendanceForm->savePdf();
				Request::redirect(null, null, 'manageMinutes', $meetingId);
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
		import('classes.meeting.form.ProposalsForInitialReviewForm');
		$initialReviewForm = new ProposalsForInitialReviewForm($meetingId, $journal->getId());
		$submitted = Request::getUserVar("selectProposal") != null ? true : false;
		$articleId = Request::getUserVar("articleId");
		
		if($submitted) {
			$initialReviewForm->readInputData();
			if($initialReviewForm->validate()) {
				Request::redirect(null, null, 'generateInitialReviewFile', array($meetingId, $articleId));
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
	 * Display form for initial review given article id and Generate pdf file for this initial review and update section_decisions table
	 * @param $args
	 * @param $request
	 */
	function generateInitialReviewDecision($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		
		import('classes.meeting.form.InitialReviewDecisionForm');
		$initialReviewForm = new InitialReviewDecisionForm($meetingId, $articleId);
		$submitted = Request::getUserVar("submitInitialReview") != null ? true : false;

		if($submitted) {
			$initialReviewForm->readInputData();
			if($initialReviewForm->validate()) {
				$initialReviewForm->execute();
				$initialReviewForm->savePdf();
				Request::redirect(null, null, 'manageMinutes', $meetingId);
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
	
	
	function generateInitialReviewFile($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		
		import('classes.meeting.form.GenerateInitialReviewFileForm');
		$generateReviewFileForm = new GenerateInitialReviewFileForm($meetingId, $articleId);
		
		if($request->getUserVar('uploadMinutesFile')) {
			$generateReviewFileForm->readInputData();
			if($generateReviewFileForm->validate()) {
				$generateReviewFileForm->execute();				
				Request::redirect(null, null, 'generateInitialReviewDecision', array($meetingId, $articleId));
			}
			else {
				if ($generateReviewFileForm->isLocaleResubmit()) {
					$generateReviewFileForm->readInputData();
				}
				else {
					$generateReviewFileForm->initData();
				}
				$generateReviewFileForm->display();
			}
		}
		else {
			$generateReviewFileForm->display();
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
		Request::redirect(null, null, 'manageMinutes', $meetingId);
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
		import('classes.meeting.form.ProposalsForContinuingReviewForm');
		$continuingReviewForm = new ProposalsForContinuingReviewForm($meetingId, $journal->getId());
		$submitted = Request::getUserVar("selectProposal") != null ? true : false;
		$articleId = Request::getUserVar("articleId");
		
		if($submitted) {
			$continuingReviewForm->readInputData();
			if($continuingReviewForm->validate()) {
				Request::redirect(null, null, 'generateContinuingReviewFile', array($meetingId, $articleId));
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
	 * Display form for continuing review given article id and Generate pdf file for this continuing review and update section_decisions table
	 * @param $args
	 * @param $request
	 */
	function generateContinuingReviewDecision($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, CONTINUING_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;

		import('classes.meeting.form.ContinuingReviewDecisionForm');
		$continuingReviewForm = new ContinuingReviewDecisionForm($meetingId, $articleId);
		$submitted = Request::getUserVar("submitContinuingReview") != null ? true : false;

		if($submitted) {
			$continuingReviewForm->readInputData();
			if($continuingReviewForm->validate()) {
				$continuingReviewForm->execute();
				$continuingReviewForm->savePdf();
				Request::redirect(null, null, 'manageMinutes', $meetingId);
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
	
	function generateContinuingReviewFile($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$articleId = isset($args[1]) ? $args[1]: 0;
		$this->validate($meetingId);
		$this->validateAccess($articleId, SECTION_EDITOR_ACCESS_REVIEW, INITIAL_REVIEW);
		$this->setupTemplate(true, $meetingId);
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		
		import('classes.meeting.form.GenerateContinuingReviewFileForm');
		$generateReviewFileForm = new GenerateContinuingReviewFileForm($meetingId, $articleId);
		
		if($request->getUserVar('uploadMinutesFile')) {
			$generateReviewFileForm->readInputData();
			if($generateReviewFileForm->validate()) {
				$generateReviewFileForm->execute();				
				Request::redirect(null, null, 'generateContinuingReviewDecision', array($meetingId, $articleId));
			}
			else {
				if ($generateReviewFileForm->isLocaleResubmit()) {
					$generateReviewFileForm->readInputData();
				}
				else {
					$generateReviewFileForm->initData();
				}
				$generateReviewFileForm->display();
			}
		}
		else {
			$generateReviewFileForm->display();
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
		Request::redirect(null, null, 'manageMinutes', $meetingId);
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
		Request::redirect(null, null, 'manageMinutes', $meetingId);
	}

	function downloadMinutes($args, $request) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$fileId = isset($args[1]) ? $args[1]: 0;
		$this->validate($meetingId);
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meetingId);
		return $minutesFileManager->downloadFile($fileId);
	}
	
	function validate($meetingId = 0, $access = null) {
		parent::validate();
		$isValid = true;
		$user = Request::getUser();
		if($meetingId != 0) {
			$meetingDao =& DAORegistry::getDAO('MeetingDAO');
			$meeting = $meetingDao->getMeetingById($meetingId);

			if($meeting == null) $isValid = false;
			else if($meeting->getUploader() != $user->getSecretaryCommitteeId()) $isValid = false;
			
			if($isValid) $this->meeting =& $meeting;
			$statusMap = $meeting->getStatusMap();
			/*
			if($access != null && $statusMap[$access] == 1) {
				Request::redirect(null, null, 'manageMinutes', $meetingId);
			}
			*/
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
				$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
				$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $sectionEditorSubmission->getSectionId());	
				$wasFound = false;
				foreach ($sectionEditors as $sectionEditor) {	
					if ($sectionEditor->getId() == $user->getId()) {
						$templateMgr->assign('canReview', true);
						$templateMgr->assign('canEdit', true);
						switch ($access) {
							case SECTION_EDITOR_ACCESS_EDIT:
								$wasFound = true;
								break;
							case SECTION_EDITOR_ACCESS_REVIEW:
								$wasFound = true;
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

		$this->submission =& $sectionEditorSubmission;
		return true;
	}

	/*
	 * Delete a specific minutes file.
	 */
	function deleteUploadedFile($args) {		
		$meetingId = isset($args[0]) ? (int) $args[0] : 0;
		$fileId = isset($args[1]) ? (int) $args[1] : 0;
		
		$this->validate($meetingId);
		
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meetingId);
		$minutesFileManager->deleteFile($fileId);		
		Request::redirect(null, null, 'manageMinutes', $meetingId);
	}

	/*
	 * Upload a minutes file.
	 */
	function uploadFile($args) {		
		$meetingId = isset($args[0]) ? (int) $args[0] : 0;
		$type = isset($args[1]) ? (string) $args[1] : '';
		
		$this->validate($meetingId);
		
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meetingId);
		$minutesFileManager->handleUpload('uploadMinutesFile', $type);		
		Request::redirect(null, null, 'manageMinutes', $meetingId);
	}
}

?>
