<?php

define ('STATUS_NEW', 0);
define ('STATUS_FINAL', 1);
define ('STATUS_RESCHEDULED', 2);
define ('STATUS_CANCELLED', 3);

class MeetingAction extends Action {

	/**
	 * Constructor.
	 */
	function MeetingAction() {
		parent::Action();
	}
	

	function cancelMeeting($meetingId, $user = null){
		
		if ($user == null) $user =& Request::getUser();

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);

		/*Only the author can cancel the meeting*/
		if ($meeting->getUploader() == $user->getId()) {
			if (!HookRegistry::call('Action::cancelMeeting', array(&$meetingId))) {
				//$meetingDao->cancelMeeting($meetingId);
				$meetingDao->updateStatus($meetingId, STATUS_CANCELLED);
			} return true;
			
		}
		return false;
	
	}
	
	
	function saveMeeting($meetingId,$selectedSubmissions,$meetingDate, $user = null){
	
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$selectedSubmissions =& $selectedSubmissions;
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');		
		
		/*
		 * Parse date
		 * */
		if ($meetingDate != null) {
			$meetingDateParts = explode('-', $meetingDate);
			$tmp = explode(' ', $meetingDateParts[2]);
			$meetingTime = $tmp[1];
			$meetingTimeMarker = $tmp[2];
			$meetingTimeParts = explode(':', $meetingTime);
			$hour = intval($meetingTimeParts[0]);
			
			if(strcasecmp($meetingTimeMarker, 'pm') == 0) {
				if($hour != 12) $hour += 12;
			}
			else {
				if($hour == 12) $hour = 0;
			}
			$meetingDate = mktime($hour, $meetingTimeParts[1], 0, $meetingDateParts[1], $meetingDateParts[2], $meetingDateParts[0]);
		}
		/**
		 * Create new meeting
		 */
		$isNew = true;
		if($meetingId == null) {
			if($meetingId == 0) {
				$meetingId = $meetingDao->createMeeting($userId,$meetingDate,$status = 0);
				$userDao =& DAORegistry::getDAO('UserDAO');
				$reviewers =& $userDao->getUsersWithReviewerRole($journal->getId());
				
				$count = 0;
				foreach($reviewers as $reviewer) {
						$reviewerId = $reviewer->getId();
						$meetingReviewerDao->insertMeetingReviewer($meetingId,$reviewerId);
				}			
			}
		/**
		 * Update an existing meeting
		 */
		}else{ 
			 $isNew = false;
			 $meetingSubmissionDao->deleteMeetingSubmissionsByMeetingId($meetingId);
			 $meeting = $meetingDao->getMeetingById($meetingId);
			 //check if new meeting date is equal to old meeting date
			 $oldDate = 0;
			 $diff = $meetingDate - strtotime($meeting->getDate());
			 if($diff != 0)
				$oldDate = $meeting->getDate();
			 
			 $meetingSubmissionDao->deleteMeetingSubmissionsByMeetingId($meetingId);
		}

		/**
		 * Store submissions to be discussed
		 */
		if (count($selectedSubmissions) > 0) {
			for ($i=0;$i<count($selectedSubmissions);$i++) {
				/*Set submissions to be discussed in the meeting*/
				$selectedProposals[$i];
				$meetingSubmissionDao->insertMeetingSubmission($meetingId,$selectedSubmissions[$i]);
			}
		}
		
		if($isNew) {
			Request::redirect(null, null, 'notifyReviewersNewMeeting', $meetingId);
		} else if($oldDate!=0){
			//reset reply of all reviewers
			$meetingReviewerDao->resetReplyOfReviewers($meeting);
			//update meeting date since old date != new date
			$meeting->setDate($meetingDate);
			$meetingDao->updateMeetingDate($meeting);
			//update meeting as rescheduled
			$meetingDao->updateStatus($meetingId, STATUS_RESCHEDULED);
			Request::redirect(null, null, 'notifyReviewersChangeMeeting', array($meetingId, $oldDate));
		}
		
		return $meetingId;
	}
	
	
	function setMeetingFinal($meetingId, $user=null){
		if ($user == null) $user =& Request::getUser();

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);

		/*Only the author can set the meeting final*/
		if ($meeting->getUploader() == $user->getId()) {
			if (!HookRegistry::call('Action::setMeetingFinal', array(&$meetingId))) {
				$meetingDao->updateStatus($meetingId, STATUS_FINAL);
			} 
			return $meetingId;
			
		}
		return false;
	
	}
	
	
}
