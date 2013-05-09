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

/**
 * Last update on February 2013
 * EL
**/

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
	 * Last update: EL on February 25th 2013
	 */
	function viewMeeting($args) {
		$meetingId = $args[0];
		$this->validate($meetingId);
		$user =& Request::getUser();
		$journal =& Request::getJournal();
		$sectionDao =& DAORegistry::getDao('SectionDAO');
		$ercReviewersDao = DAORegistry::getDAO('ErcReviewersDAO');
		
		$meeting =& $this->meeting;
		$submissions =& $this->submissions;
		
		$submissionReviewMap =& $this->submissionReviewMap;
		$this->setupTemplate(true, 1);
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('submissions', $submissions);
		$templateMgr->assign_by_ref('map', $submissionReviewMap);
		$templateMgr->assign('erc', $sectionDao->getSection($meeting->getUploader())); 
			// EL on March 1st. 
			// Unused + undefined variables
			// $templateMgr->assign('sort', $sort);
			// $templateMgr->assign('sortDirection', $sortDirection);
			
		$templateMgr->assign('isReviewer', $ercReviewersDao->ercReviewerExists($journal->getId(),$meeting->getUploader(), $user->getId()));
		$templateMgr->assign('userId', $user->getId());

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
		
		$meetingAttendanceDao =& DAORegistry::getDao('MeetingAttendanceDAO');
		$meetingAttendance = $meetingAttendanceDao->getMeetingAttendance($meetingId, $userId);
		
		$meetingAttendance->setIsAttending(Request::getUserVar('isAttending'));
		$meetingAttendance->setRemarks(Request::getUserVar('remarks'));	
		
		$meetingAttendanceDao =& DAORegistry::getDao('MeetingAttendanceDAO');
		$meetingAttendanceDao->updateReplyOfAttendance($meetingAttendance);
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
			
			// EL on March 1st 2013
			$journalId = $journal->getId();
		
		$isValid = true;
		$newKey = Request::getUserVar('key');

		$meeting =& $meetingDao->getMeetingByMeetingAndUserId($meetingId, $user->getId());

		if (!$meeting) {
			$isValid = false;
		} elseif ($user && empty($newKey)) {
			if ($meeting->getUserId() != $user->getId()) {
				$isValid = false;
			}
		} 
		else {
			//$user =& MeetingReviewerHandler::validateAccessKey($meeting->getUserId(), $meetingId, $newKey);
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
