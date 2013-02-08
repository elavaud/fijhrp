<?php

define ('MEETING_REPLY_ATTENDING', 1);
define ('MEETING_REPLY_NOT_ATTENDING', 2);

class MeetingReviewer extends DataObject {

	function MeetingReviewer() {
		parent::DataObject();
	}
	
	function setMeetingId($meetingId){
			$this->setData('meetingId', $meetingId);
	}
	
	function getMeetingId() {
		return $this->getData('meetingId');
	}
	
	function setReviewerId($reviewerId) {
		$this->setData('reviewerId', $reviewerId);
	}
	
	function getReviewerId() {
		return $this->getData('reviewerId');
	}
	
	function  setIsAttending($isAttending){
		$this->setData('isAttending', $isAttending);
	}
	
	function getIsAttending(){
		return $this->getData('isAttending');
	}
	
	function setRemarks($remarks){
		$this->setData('remarks', $remarks);
	}
	
	function getRemarks(){
		return $this->getData('remarks');
	}
	
	function setDateReminded($dateReminded) {
		$this->setData('dateReminded', $dateReminded);
	}
	
	function getDateReminded(){
		return $this->getData('dateReminded');
	}
	
	function setFirstName($firstName){
		return $this->setData('firstName', $firstName);
	}
	
	function getFirstName(){
		return $this->getData('firstName');
	}
	
	function setLastName($lastName){
		return $this->setData('lastName', $lastName);
	}
	
	function getLastName(){
		return $this->getData('lastName');
	}

	function setSalutation($salutation){
		return $this->setData('salutation', $salutation);
	}
	
	function getSalutation(){
		return $this->getData('salutation');
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
}

?>
