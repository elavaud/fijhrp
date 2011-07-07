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
	
	function  setIsAttending($isAttending){
		return $this->setData('isAttending', $isAttending);
	}
	
	function getIsAttending(){
		return $this->getData('isAttending');
	}
	
	function setRemarks($remarks){
		return $this->setData('remarks', $remarks);
	}
	
	function getRemarks(){
		return $this->getData('remarks');
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
}


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
	

}

*/

?>