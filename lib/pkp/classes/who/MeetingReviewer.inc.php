<?php

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
}

?>

/*

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
	
	function getFirstName(){
		return $this->getData('salutation');
	}
}

*/

?>