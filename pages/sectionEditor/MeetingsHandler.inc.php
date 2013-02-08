<?php

/**
* class MeetingsHandler for SectionEditor and Editor Roles (STO)
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
import('lib.pkp.classes.who.MeetingAction');

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

	function meetings($args) {
		$this->validate(0, true);
		$this->setupTemplate(false);
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$meetingSubmissionDao = DAORegistry::getDAO('MeetingSubmissionDAO');
		$articleDao = DAORegistry::getDAO('ArticleDAO');
		
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
		
		$meetings = $meetingDao->getMeetingsOfUser($userId, $sort, $rangeInfo, $sortDirection, $status, $minutesStatus, $fromDate, $toDate);
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
		
		$meetings = $meetingDao->getMeetingsOfUser($userId, $sort, $rangeInfo, $sortDirection, $status, $minutesStatus, $fromDate, $toDate);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meetings', $meetings);
		$templateMgr->assign_by_ref('submissions', $submissions); 
		$templateMgr->assign_by_ref('map', $map);
		$templateMgr->assign('rangeInfo', count($meetings)); 
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->assign('pageToDisplay', $page);
		$templateMgr->assign('sectionEditor', $user->getFullName());
		$templateMgr->assign('baseUrl', Config::getVar('general', "base_url"));
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign('status', $status);
		$templateMgr->assign('minutesStatus', $minutesStatus);
		
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
		import ('lib.pkp.classes.who.form.SetMeetingForm');
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
	* Store meeting details such as proposals to discuss and meeting date
	* @ param $args (type)
	*/
	
	
        function saveMeeting($args){
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId, false, true);
		$selectedSubmissions = Request::getUserVar('selectedProposals');
		$meetingDate = Request::getUserVar('meetingDate');
		$meetingId = MeetingAction::saveMeeting($meetingId,$selectedSubmissions,$meetingDate, null);
		Request::redirect(null, null, 'viewMeeting', array($meetingId));
	}	

	/**
	 * Added by MSB July 07 2011
	 * Set the meeting final
	 * @param $args (type)
	 */	
	function setMeetingFinal($args){
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$meetingId = MeetingAction::setMeetingFinal($meetingId);
		Request::redirect(null, null, 'notifyReviewersFinalMeeting', $meetingId);
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
		
		if(isset($meeting) && $meeting->getUploader()==$user->getId()){
		
			/*LIST THE SUBMISSIONS*/
			$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
			$selectedProposals =$meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$submissions = array();
			foreach($selectedProposals as $submission) {
				$submissions[$submission] = $articleDao->getArticle($submission, $journalId, false);
			}
			
			
			/*RESPONSES FROM REVIEWERS*/
			$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');	
			$reviewers = $meetingReviewerDao->getMeetingReviewersByMeetingId($meetingId);
		
			
			$templateMgr =& TemplateManager::getManager();
			$templateMgr->assign('sectionEditor', $user->getFullName());
			$templateMgr->assign_by_ref('meeting', $meeting);
			$templateMgr->assign_by_ref('reviewers', $reviewers);
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
		
		if(MeetingAction::cancelMeeting($meetingId, null)){
			Request::redirect(null, null, 'meetings', null);
		}
		
	}
	
	/** 
	 * Notify reviewers if new meeting is set
	 * Added by ayveemallare 7/12/2011
	 * Enter description here ...
	 * @param int $meetingId
	 */
	function notifyReviewersNewMeeting($args) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =$meetingDao->getMeetingById($meetingId);
		
		$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');	
		$reviewerIds = $meetingReviewerDao->getMeetingReviewersByMeetingId($meetingId);
	
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$this->setupTemplate(true, $meetingId);
		if (SectionEditorAction::notifyReviewersNewMeeting($meeting, $reviewerIds, $submissionIds, Request::getUserVar('send'))) {
			Request::redirect(null, null, 'viewMeeting', $meetingId);
		}
	}
	
	/**
	 * Notify reviewers if meeting is rescheduled
	 * Added by ayveemallare 7/12/2011
	 * @param int $meetingId, datetime $oldDate
	 */
	function notifyReviewersChangeMeeting($args) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$oldDate = isset($args[1]) ? $args[1]: 0;
		$meeting =& $this->meeting;
		
		$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');	
		$reviewerIds = $meetingReviewerDao->getMeetingReviewersByMeetingId($meetingId);
	
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$this->setupTemplate(true, $meetingId);
		if (SectionEditorAction::notifyReviewersChangeMeeting($oldDate, $meeting, $reviewerIds, $submissionIds, Request::getUserVar('send'))) {
			Request::redirect(null, null, 'viewMeeting', $meetingId);
		}
	}
	
	/**
	 * Notify reviewers if meeting schedule is made final.
	 * Added by ayveemallare 7/12/2011
	 * @param int $meetingId
	 */
	function notifyReviewersFinalMeeting($args) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$meeting =& $this->meeting;
		
		$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');	
		$reviewerIds = $meetingReviewerDao->getMeetingReviewersByMeetingId($meetingId);
	
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$this->setupTemplate(true, $meetingId);
		if (SectionEditorAction::notifyReviewersFinalMeeting($meeting, $reviewerIds, $submissionIds, Request::getUserVar('send'))) {
			Request::redirect(null, null, 'viewMeeting', $meetingId);
		}
	}
	
	/**
	 * Notify reviewers if meeting is cancelled
	 * Added by ayveemallare 7/12/2011
	 * @param int $meetingId
	 */
	function notifyReviewersCancelMeeting($args) {
		$meetingId = isset($args[0]) ? $args[0]: 0;
		$this->validate($meetingId);
		$meeting =& $this->meeting;

		$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');	
		$reviewerIds = $meetingReviewerDao->getMeetingReviewersByMeetingId($meetingId);
	
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$this->setupTemplate(true, $meetingId);
		if (SectionEditorAction::notifyReviewersCancelMeeting($meeting, $reviewerIds, $submissionIds, Request::getUserVar('send'))) {
			Request::redirect(null, null, 'cancelMeeting', $meetingId);
		}
	}
	
	/**
	 * Remind reviewers of schedule meeting
	 * Added by ayveemallare 7/12/2011
	 * @param $args
	 */
	function remindReviewersMeeting($args = null) {
		$meetingId = Request::getUserVar('meetingId');
		$reviewerId = Request::getUserVar('reviewerId');
		$this->validate($meetingId);
		$meeting =& $this->meeting;
		
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		$this->setupTemplate(true, $meetingId);
		if (SectionEditorAction::remindReviewersMeeting($meeting, $reviewerId, $submissionIds, Request::getUserVar('send'))) {
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
			else if($meeting->getUploader() != $user->getId())
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


}

?>
