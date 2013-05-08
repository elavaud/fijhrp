<?php

/**
* class MeetingsHandler for SectionEditor and Editor Roles (STO)
* page handler class for minutes-related operations
* @var unknown_type
*/

/**
 * Last update on February 2013
 * EL
**/

define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);

// Filter section
define('FILTER_SECTION_ALL', 0);
	
import('classes.submission.sectionEditor.SectionEditorAction');

import('classes.handler.Handler');
import('classes.meeting.Meeting');
import('classes.meeting.MeetingAction');
import('classes.meeting.MeetingAttendance');

class MeetingsHandler extends Handler {
	/**
	* Constructor
	**/
	var $meeting;
	
	function MeetingsHandler() {
		
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
		$pageHierarchy = $subclass ? array(array(Request::url(null, 'user'), $roleKey), array(Request::url(null, $roleSymbolic, 'meetings'), 'editor.meetings'))
		: array(array(Request::url(null, 'user'), $roleKey));
		
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
	* Last modified by EL on February 25th 2013
	*/
	function instructions($args) {
		$this->setupTemplate();
		import('classes.submission.proofreader.ProofreaderAction');
		if (!isset($args[0]) || !ProofreaderAction::instructions($args[0], array('copy', 'proof', 'referenceLinking'))) {
			Request::redirect(null, null, 'index');
		}
	}

	function meetings($args) {
		$this->validate(0, true);
		$this->setupTemplate(false);
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'id';
		$sortDirection = Request::getUserVar('sortDirection');
		$rangeInfo = Handler::getRangeInfo('meetings');
		
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		$status = Request::getUserVar('status');
		$minutesStatus = Request::getUserVar('minutesStatus');
		
		$meetings = $meetingDao->getMeetingsOfSection($user->getSecretaryCommitteeId(), $sort, $rangeInfo, $sortDirection, $status, $minutesStatus, $fromDate, $toDate);
		$meetingsArray = $meetings->toArray();
		$map = array();
			
		foreach($meetingsArray as $meeting) {
			$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meeting->getId());
			$submissions = array();
			foreach($submissionIds as $submissionId) {
				$submission = $articleDao->getArticle($submissionId, $journalId, false);
				array_push($submissions, $submission);
			}
			$map[$meeting->getId()] = $submissions;
		}
		
		$meetings = $meetingDao->getMeetingsOfSection($user->getSecretaryCommitteeId(), $sort, $rangeInfo, $sortDirection, $status, $minutesStatus, $fromDate, $toDate);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meetings', $meetings);
		$templateMgr->assign_by_ref('submissions', $submissions); 
		$templateMgr->assign_by_ref('map', $map);
		$templateMgr->assign('rangeInfo', count($meetings)); 
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		//$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());
		$templateMgr->assign('baseUrl', Config::getVar('general', "base_url"));
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign('status', $status);
		$templateMgr->assign('minutesStatus', $minutesStatus);
		
		$templateMgr->assign('ercId', $user->getSecretaryCommitteeId());
		
		// Set search parameters
		$duplicateParameters = array(
			'dateFromMonth', 'dateFromDay', 'dateFromYear',
			'dateToMonth', 'dateToDay', 'dateToYear', 'status', 'minutesStatus'
		);
		foreach ($duplicateParameters as $param)
			$templateMgr->assign($param, Request::getUserVar($param));
		
		$templateMgr->display('sectionEditor/meetings/meetings.tpl');
	}


	/**
	* Added by MSB, Updated Last: July 14, 2011
	* Display the setMeeting page
	* @param $args (type)
	*/
	function setMeeting($args, &$request){
		import ('classes.meeting.form.SetMeetingForm');
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId,false, true);
		$this->setupTemplate();
		$setMeetingForm= new SetMeetingForm($args,$request);
		$saveMeetingSubmit = Request::getUserVar('saveMeeting') != null ? true : false;
		
		if ($saveMeetingSubmit) {
			$setMeetingForm->readInputData();

			if($setMeetingForm->validate()){	
					$this->saveMeeting($args);
			}else{
				if ($setMeetingForm->isLocaleResubmit()) {
					$setMeetingForm->readInputData();
				}
				$setMeetingForm->display($args);
			}
		}else {
			$setMeetingForm->display($args);
		}
	}
	
	/**
	* Added by MSB 07/06/11
        * Revised c/o IGM 11/18/11
        	* Revised by EL March 2013
	* Store meeting details such as proposals to discuss and meeting date
	* @ param $args (type)
	*/
	
	
        function saveMeeting($args){
			$meetingId = isset($args[0]) ? $args[0]: 0;
			$this->validate($meetingId, false, true);
			$selectedSubmissions = Request::getUserVar('selectedProposals');
			$meetingDate = Request::getUserVar('meetingDate');
			$meetingLength = Request::getUserVar('meetingLength');
			$location = Request::getUserVar('location');
			$investigator = Request::getUserVar('investigator');
			$final = Request::getUserVar('final');
			$meetingId = MeetingAction::saveMeeting($meetingId, $selectedSubmissions, $meetingDate, $meetingLength, $investigator, $location, $final);
			Request::redirect(null, null, 'viewMeeting', array($meetingId));
		}

	/**
	 * Added by MSB July 07 2011
	 * Set the meeting final
	 * @param $args (type)
	 * Last update from EL on March 6th 2013
	 */	
	function setMeetingFinal($args){
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$meetingId = MeetingAction::setMeetingFinal($meetingId);
		Request::redirect(null, null, 'notifyUsersMeeting', array($meetingId, 'MEETING_FINAL'));
	}

	function viewMeeting($args){
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$this->setupTemplate(true, $meetingId);
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		/*MEETING DETAILS*/
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =$meetingDao->getMeetingById($meetingId);
		if(isset($meeting) && $meeting->getUploader()==$user->getSecretaryCommitteeId()){
			/*LIST THE SUBMISSIONS*/
			$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
			$selectedProposals =$meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$submissions = array();
			foreach($selectedProposals as $submission) {
				$submissions[$submission] = $articleDao->getArticle($submission, $journalId, false);
			}
			
			/*RESPONSES FROM USERS*/
			$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');
			$users = $meetingAttendanceDao->getMeetingAttendancesByMeetingId($meetingId);
			$templateMgr =& TemplateManager::getManager();
			$templateMgr->assign('sectionEditor', $user->getFullName());
			$templateMgr->assign_by_ref('meeting', $meeting);
			$templateMgr->assign_by_ref('users', $users);
			$templateMgr->assign_by_ref('submissions', $submissions);
			$templateMgr->assign('baseUrl', Config::getVar('general', "base_url"));
			$templateMgr->display('sectionEditor/meetings/viewMeeting.tpl');
		
		}else{
			Request::redirect(null, null, 'meetings', null);
		}
	}
	
	function cancelMeeting($args){
		$meetingId = isset($args[0]) ? $args[0]: 0;
			
		$this->validate($meetingId);
		
		$meetingId = MeetingAction::cancelMeeting($meetingId);
		
		Request::redirect(null, null, 'notifyUsersMeeting', array($meetingId, 'MEETING_CANCEL'));		
	}
	
	/** 
	 * Notify users if new meeting is set
	 * Added by ayveemallare 7/12/2011
	 * @param int $meetingId
	 * Last modified by EL
	 * Firstly reviewers and then, optionnaly, external reviewers and investigators
	 */
	function notifyUsersMeeting($args) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$informationType = isset($args[1]) ? $args[1]: 'MEETING_NEW';
		$this->validate($meetingId);
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');	
		$reviewerAttendances = $meetingAttendanceDao->getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, MEETING_ERC_MEMBER);
		$this->setupTemplate(true, $meetingId);
		
		$reviewerSent = MeetingAction::notifyReviewersMeeting($meeting, $informationType, $reviewerAttendances, $submissionIds, Request::getUserVar('send'));		
		
		$extReviewerAttendances = $meetingAttendanceDao->getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, MEETING_EXTERNAL_REVIEWER);
		
		$investigatorAttendances = $meetingAttendanceDao->getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, MEETING_INVESTIGATOR);
				
		if ($reviewerSent) {
			$attendanceIncrementNumber = (int)0;
			if (count($extReviewerAttendances)>0) Request::redirect(null, null, 'notifyExternalReviewersMeeting', array($meetingId, $attendanceIncrementNumber, $informationType));
			elseif (count($investigatorAttendances)>0) Request::redirect(null, null, 'notifyInvestigatorsMeeting', array($meetingId, 0, $informationType));
			else Request::redirect(null, null, 'viewMeeting', $meetingId);
		}
	}

	/**
	 * EL on February 28th 2013
	 * Notify the investigators of a new meeting suggestion
	 */
	function notifyExternalReviewersMeeting($args) {
		$meetingId = $args[0];
		$attendanceIncrementNumber = isset($args[1]) ? $args[1]: 0;
		$informationType = isset($args[2]) ? $args[2]: 'MEETING_NEW_EXTERNAL_REVIEWER';
		if ($informationType == 'MEETING_NEW') $informationType = 'MEETING_NEW_EXTERNAL_REVIEWER';
		elseif ($informationType == 'MEETING_CHANGE') $informationType = 'MEETING_CHANGE_EXT_REVIEWER';
		elseif ($informationType == 'MEETING_FINAL') $informationType = 'MEETING_FINAL_EXT_REVIEWER';
		elseif ($informationType == 'MEETING_CANCEL') $informationType = 'MEETING_CANCEL_EXT_REVIEWER';
		$this->validate($meetingId);

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');	
		$this->setupTemplate(true, $meetingId);

		$extReviewerAttendances = $meetingAttendanceDao->getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, MEETING_EXTERNAL_REVIEWER);

		$investigatorAttendances = $meetingAttendanceDao->getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, MEETING_INVESTIGATOR);

		$extReviewerSent = MeetingAction::notifyExternalReviewerMeeting($meeting, $informationType, $extReviewerAttendances[$attendanceIncrementNumber], $attendanceIncrementNumber, $submissionIds, Request::getUserVar('send'));

		if ($extReviewerSent) {
			$attendanceIncrementNumber = $attendanceIncrementNumber+1;
			if ($attendanceIncrementNumber < count($extReviewerAttendances)) {
				Request::redirect(null, null, 'notifyExternalReviewersMeeting', array($meetingId, $attendanceIncrementNumber, $informationType));
			} elseif (count($investigatorAttendances) > 0) Request::redirect(null, null, 'notifyInvestigatorsMeeting', array($meetingId, 0, $informationType));
			else Request::redirect(null, null, 'viewMeeting', $meetingId);
		}
	}
	
	/**
	 * EL on February 28th 2013
	 * Notify the investigators of a new meeting suggestion
	 */
	function notifyInvestigatorsMeeting($args) {
		$meetingId = $args[0];
		$attendanceIncrementNumber = isset($args[1]) ? $args[1]: 0;
		$informationType = isset($args[2]) ? $args[2]: 'MEETING_NEW_INVESTIGATOR';
		
		if ($informationType == 'MEETING_NEW') $informationType = 'MEETING_NEW_INVESTIGATOR';
		elseif ($informationType == 'MEETING_NEW_EXTERNAL_REVIEWER') $informationType = 'MEETING_NEW_INVESTIGATOR';
		elseif ($informationType == 'MEETING_CHANGE') $informationType = 'MEETING_CHANGE_INVESTIGATOR';
		elseif ($informationType == 'MEETING_CHANGE_EXT_REVIEWER') $informationType = 'MEETING_CHANGE_INVESTIGATOR';
		elseif ($informationType == 'MEETING_FINAL') $informationType = 'MEETING_FINAL_INVESTIGATOR';
		elseif ($informationType == 'MEETING_FINAL_EXT_REVIEWER') $informationType = 'MEETING_FINAL_INVESTIGATOR';
		elseif ($informationType == 'MEETING_CANCEL') $informationType = 'MEETING_CANCEL_INVESTIGATOR';
		elseif ($informationType == 'MEETING_CANCEL_EXT_REVIEWER') $informationType = 'MEETING_CANCEL_INVESTIGATOR';
		
		$this->validate($meetingId);
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');	
		$this->setupTemplate(true, $meetingId);
		
		$investigatorAttendances = $meetingAttendanceDao->getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, MEETING_INVESTIGATOR);

		$investigatorSent = MeetingAction::notifyInvestigatorMeeting($meeting, $informationType, $investigatorAttendances[$attendanceIncrementNumber], $attendanceIncrementNumber, $submissionIds, Request::getUserVar('send'));
				
		if ($investigatorSent) {
			$attendanceIncrementNumber = $attendanceIncrementNumber+1;
			if ($attendanceIncrementNumber < count($investigatorAttendances)) {
				Request::redirect(null, null, 'notifyInvestigatorsMeeting', array($meetingId, $attendanceIncrementNumber, $informationType));
			}
			else Request::redirect(null, null, 'viewMeeting', $meetingId);
		}
	}
	
			
	/**
	 * Remind reviewers of schedule meeting
	 * Added by ayveemallare 7/12/2011
	 * Last modified: EL on March 5th
	 * @param $args
	 */
	function remindUserMeeting($args = null) {
		$meetingId = Request::getUserVar('meetingId');
		$addresseeId = Request::getUserVar('addresseeId');
		$this->validate($meetingId);
		$meeting =& $this->meeting;
		
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$this->setupTemplate(true, $meetingId);
		if (MeetingAction::remindUserMeeting($meeting, $addresseeId, $submissionIds, Request::getUserVar('send'))) {
			Request::redirect(null, null, 'viewMeeting', $meetingId);
		}
	}
	
	function validate($meetingId = 0, $isList = false, $isSetMeeting = false) {
		parent::validate();
		$isValid = true;
		$user = Request::getUser();
		if($meetingId != 0) {
			$meetingDao =& DAORegistry::getDAO('MeetingDAO');
			$meeting = $meetingDao->getMeetingById($meetingId);
			
			if($meeting == null)
				$isValid = false;
			else if($meeting->getUploader() != $user->getSecretaryCommitteeId())
				$isValid = false;
			if($isValid)
				$this->meeting =& $meeting;
				
		} else {
			if(!$isList && !$isSetMeeting)
				$isValid = false;	
		}
		
		if(!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}
		
		return true;
	}

	/**
	 * Added by EL on February 27th 2013
	 * Reply the attendance of the user
	 */
	function replyAttendanceForUser($args){
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$userId = $args[1];
		$attendance = $args[2];
			
		$this->validate($meetingId);
		
		if(MeetingAction::replyAttendanceForUser($meetingId, $userId, $attendance)){
			Request::redirect(null, null, 'viewMeeting', $meetingId);
		}	
	}

}

?>
