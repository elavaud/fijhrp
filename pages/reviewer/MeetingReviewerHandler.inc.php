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
	var $meeting;
	var $submissions;
	var $user;
	var $submissionReviewMap;
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
		$meetingId = $args[0];
		$this->validate($meetingId);
		$user =& Request::getUser();
		$userId = $user->getId();
		$userDao =& DAORegistry::getDao('UserDAO');
		
		$meeting =& $this->meeting;
		$submissions =& $this->submissions;
		
		$submissionReviewMap =& $this->submissionReviewMap;
		$this->setupTemplate(true, $meetingId);
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('submissions', $submissions);
		$templateMgr->assign_by_ref('map', $submissionReviewMap);
		$templateMgr->assign('editor', $userDao->getUser($meeting->getUploader())); 
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->display('reviewer/viewMeeting.tpl');
	}
	
	/**
	 *  Response to Meeting Scheduler
	 */
	
	function replyMeeting(){
		$meetingId = Request::getUserVar('meetingId');
		$this->validate($meetingId);
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$meetingDao =& DAORegistry::getDao('MeetingDAO');
		$meeting = $meetingDao->getMeetingByMeetingAndReviewerId($meetingId, $userId);
		
		$meeting->setIsAttending(Request::getUserVar('isAttending'));
		$meeting->setRemarks(Request::getUserVar('remarks'));	
		
		$meetingReviewerDao =& DAORegistry::getDao('MeetingReviewerDAO');
		$meetingReviewerDao->updateReplyOfReviewer($meeting);
		Request::redirect(null, 'reviewer', 'viewMeeting', $meetingId);
		
	}
	
	/** TODO:
	 * (non-PHPdoc)
	 * @see PKPHandler::validate()
	 */
	function validate($meetingId) {
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$isValid = true;
		$newKey = Request::getUserVar('key');

		$meeting =& $meetingDao->getMeetingByMeetingAndReviewerId($meetingId, $user->getId());

		if (!$meeting) {
			$isValid = false;
		} else if ($user && empty($newKey)) {
			if ($meeting->getReviewerId() != $user->getId()) {
				$isValid = false;
			}
		} 
		else {
			//$user =& MeetingReviewerHandler::validateAccessKey($meeting->getReviewerId(), $meetingId, $newKey);
			if (!$user) $isValid = false;
		}

		if (!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}
		$submissionIds = array();
		$submissions = array();
		$reviewIds = array();
		$map = array();
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$reviewerSubmissionDao =& DAORegistry::getDAO('ReviewerSubmissionDAO');
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meeting->getId());
		
		foreach($submissionIds as $submissionId) {
			$submission = $articleDao->getArticle($submissionId, $journalId, false);
			$review = $reviewerSubmissionDao->getReviewerSubmissionByReviewerAndSubmissionId($user->getId(), $submissionId, $journal->getId());
			$map[$submissionId] = $review->getReviewId();
			array_push($submissions, $submission);
		}
		$this->submissionReviewMap =& $map;
		$this->submissions =& $submissions;
		$this->meeting =& $meeting;
		$this->user =& $user;
		
		return true;
	}
}

?>
