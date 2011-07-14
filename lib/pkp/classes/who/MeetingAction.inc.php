<?php
class MeetingAction extends Action {

	/**
	 * Constructor.
	 */
	function MeetingAction() {
		parent::Action();
	}
	

	function cancelMeeting($meetingId,$user = null){
		
		if ($user == null) $user =& Request::getUser();

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);

		/*Only the author can cancel the meeting*/
		if ($meeting->getUploader() == $user->getId()) {
			if (!HookRegistry::call('Action::cancelMeeting', array(&$meetingId))) {
				$meetingDao->cancelMeeting($meetingId);
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
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		
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
		//else {
		//	$meetingDate = Core::getCurrentDate();
		//}
		/**
		 * Create new meeting
		 */
		
		$isNew = true;
		if($meetingId == null) {
		
			$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');			
		
			if($meetingId == 0) {
				$meetingDao =& DAORegistry::getDAO('MeetingDAO');
				$meetingId = $meetingDao->createMeeting($userId,$meetingDate,$status = 0);
				$userDao =& DAORegistry::getDAO('UserDAO');
				$reviewers =& $userDao->getUsersWithReviewerRole($journal->getId());
				$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');		

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
			 $meetingDao =& DAORegistry::getDAO('MeetingDAO');
			 $meeting = $meetingDao->getMeetingById($meetingId);
			 //check if new meeting date is equal to old meeting date
			 $oldDate = 0;
			 $diff = $meetingDate - strtotime($meeting->getDate());
			 if($diff != 0)
				$oldDate = $meeting->getDate();
			 $meeting->setDate($meetingDate);
			 $meetingDao->updateMeetingDate($meeting);
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
			if (!HookRegistry::call('Action::cancelMeeting', array(&$meetingId))) {
				$meetingDao->setMeetingFinal($meetingId);
			} return true;
			
		}return false;
	
	}
	
	
}