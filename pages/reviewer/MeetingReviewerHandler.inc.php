<?php

/**
 * @file MeetingReviewerHandler.inc.php
 *
 *
 * @class MeetingReviewerHandler
 * @ingroup pages_reviewer
 *
 * @brief Handle requests for meeting reviewer functions.
 * 
 * Added by ayveemallare
 * Last Updated: 7/6/2011
 */



import('classes.handler.Handler');
import('pages.reviewer.ReviewerHandler');

class MeetingReviewerHandler extends ReviewerHandler {
	/**
	 * Constructor
	 **/
	function MeetingReviewerHandler() {
		parent::ReviewerHandler();

		$this->addCheck(new HandlerValidatorJournal($this));
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_REVIEWER)));		
	}

	/**
	 * Display view meeting page.
	 */
	function viewMeeting($args) {
		$this->validate();
		$this->setupTemplate();
		$user =& Request::getUser();
		$userId = $user->getId();
		$meetingId = $args[0];
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$userDao =& DAORegistry::getDao('UserDAO');
		$meeting = $meetingDao->getMeetingByMeetingAndReviewerId($meetingId, $userId);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign('editor', $userDao->getUser($meeting->getUploader())); 
		$templateMgr->display('reviewer/viewMeeting.tpl');
	}
	
	/**
	 *  Response to Meeting Scheduler
	 */
	
	function replyMeeting(){
		$user =& Request::getUser();
		$userId = $user->getId();
		$meetingId = Request::getUserVar('meetingId');
		
		$meetingDao =& DAORegistry::getDao('MeetingDAO');
		$meeting = $meetingDao->getMeetingByMeetingAndReviewerId($meetingId, $userId);
		
		$meeting->setIsAttending(Request::getUserVar('isAttending'));
		$meeting->setRemarks(Request::getUserVar('remarks'));	
		
		$meetingDao->updateReplyOfReviewer($meeting);
		Request::redirect(null, 'reviewer', 'viewMeeting', $meetingId);
		
	}
	
	/** TODO:
	 * (non-PHPdoc)
	 * @see PKPHandler::validate()
	 */
	function validate($meetingId) {
		
	}
}

?>
