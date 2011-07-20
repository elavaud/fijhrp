<?php

define ('MEETING_STATUS_COMPLETE', 128);
define ('MEETING_STATUS_ATTENDANCE', 1);
define ('MEETING_STATUS_INITIAL_REVIEWS', 2);
define ('MEETING_STATUS_REREVIEWS', 4);
define ('MEETING_STATUS_CONTINUING_REVIEWS', 8);
define ('MEETING_STATUS_AMENDMENTS', 16);
define ('MEETING_STATUS_ADVERSE_EVENTS', 32);
define ('MEETING_STATUS_INFORMATION_ITEMS', 64);
define ('MEETING_SCHEDULE_FINAL', 1);
define ('MEETING_SCHEDULE_PROPOSED', 0);
define ('MEETING_REPLY_ATTENDING', 1);
define ('MEETING_REPLY_NOT_ATTENDING', 2);

class Meeting extends DataObject {
	
	function Meeting() {
		parent::DataObject();
	}
	
	function setId($meetingId) {
		$this->setData('meetingId', $meetingId);
	}
	
	function getId() {
		return $this->getData('meetingId');
	}
	
	function setDate($meetingDate) {
		$this->setData('meetingDate', $meetingDate);
	}
	
	function getDate() {
		return $this->getData('meetingDate');
	}
	
	function setUploader($userId) {
		$this->setUser($userId);	
	}
	
	function setUser($userId) {
		$this->setData('userId', $userId);
	}
	
	function getUploader() {
		return $this->getData('userId');
	}
	
	function setMinutesStatus($minutesStatus) {
		$this->setData('minutesStatus', $minutesStatus);
	}
	
	function getMinutesStatus() {
		return $this->getData('minutesStatus');
	}
	
	/********************************** 
	 * Additional fields for meeting
	 *  Added by ayveemallare 7/6/2011
	 **********************************/
	
	function setReviewerId($reviewerId) {
		$this->setData('reviewerId', $reviewerId);
	}
	
	function getReviewerId() {
		return $this->getData('reviewerId');
	}
	
	function setIsAttending($isAttending) {
		$this->setData('isAttending', $isAttending);
	}
	
	function getIsAttending() {
		return $this->getData('isAttending');
	}
	
	function setRemarks($remarks) {
		$this->setData('remarks', $remarks);
	}
	
	function getRemarks() {
		return $this->getData('remarks');
	}
	
	function setStatus($status) {
		$this->setData('status', $status);
	}

	function getStatus() {
		return $this->getData('status');
	}
		
	
	function updateMeetingStatus($meetingStatus){
		$this->setData('meetingStatus', $meetingStatus);
	}

	function getMeetingStatus(){
		return $this->getData('meetingStatus');
	}
	

	function setIsPresent($isPresent) {
		$this->setData('isPresent', $isPresent);
	}
	
	function isPresent() {
		return $this->getData('isPresent');
	}
	
	function getReasonForAbsence() {
		return $this->getData('reasonForAbsence');
	}
	
	function setReasonForAbsence($reasonForAbsence) {
		$this->setData('reasonForAbsence', $reasonForAbsence);
	}
	
	
	/**
	 * Get array mapping of completed sections of the meeting minutes
	 * @return array
	 */
	function getStatusMap() {
		$meetingStatus = $this->getMinutesStatus();
		$meetingMap = array();
		for($i=6; $i>=0; $i--) {
			$num = pow(2, $i);
			if($num <= $meetingStatus) {
				$meetingMap[$num] = 1;
				$meetingStatus = $meetingStatus - $num;
			}
			else
				$meetingMap[$num] = 0;			
		}
		return $meetingMap;
	}
	
	/**
	 * Added by aglet 6/30/2011
	 * Get meeting status if complete or incomplete
	 */
	function isComplete() {
		if($this->getMinutesStatus() == MINUTES_STATUS_COMPLETE) {
			return true;
		}
		return false;
	}
	
	function getMinutesStatusKey() {
		if($this->isComplete()) {
			return "COMPLETE";
		}
		return "INCOMPLETE";
	}
	
	function getReplyStatus() {
		switch ($this->getIsAttending()) {
			case MEETING_REPLY_ATTENDING:
				return Locale::Translate('reviewer.meetings.replyStatus.attending');
			case MEETING_REPLY_NOT_ATTENDING:
				return Locale::Translate('reviewer.meetings.replyStatus.notAttending');
			default:
				return Locale::Translate('reviewer.meetings.replyStatus.awaitingReply');
		}
	}
	
	function getStatusKey() {
		switch ($this->getStatus()) {
			case STATUS_FINAL:
				return Locale::Translate('reviewer.meetings.scheduleStatus.final');
			case STATUS_RESCHEDULED:
				return Locale::Translate('reviewer.meetings.scheduleStatus.rescheduled');
			case STATUS_CANCELLED:
				return Locale::Translate('reviewer.meetings.scheduleStatus.cancelled');
			default:
				return Locale::Translate('reviewer.meetings.scheduleStatus.new');
		}
	}
	
	function updateMinutesStatus($addToStatus) {
		$status = $this->getMinutesStatus() + $addToStatus;
		$this->setMinutesStatus($status);
	}
	
}

?>
