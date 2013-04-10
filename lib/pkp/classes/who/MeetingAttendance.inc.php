<?php

define ('MEETING_REPLY_ATTENDING', 1);
define ('MEETING_REPLY_NOT_ATTENDING', 2);

define ('MEETING_INVESTIGATOR', 1);
define ('MEETING_EXTERNAL_REVIEWER', 2);
define ('MEETING_SECRETARY', 3);
define ('MEETING_ERC_MEMBER', 4);

/**
 * Last update on February 2013
 * EL
**/

class MeetingAttendance extends DataObject {

	function MeetingAttendance() {
		parent::DataObject();
	}
	
	function setMeetingId($meetingId){
			$this->setData('meetingId', $meetingId);
	}
	
	function getMeetingId() {
		return $this->getData('meetingId');
	}
	
	function setUserId($userId) {
		$this->setData('userId', $userId);
	}
	
	function getUserId() {
		return $this->getData('userId');
	}
	
	function setIsAttending($isAttending){
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
	
	function getFullName(){
		return $this->getSalutation().' '.$this->getFirstName().' '.$this->getLastName();
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

	function setTypeOfUser($typeOfUser) {
		return $this->setData('typeOfUser', $typeOfUser);
	}

	function getTypeOfUser() {
		return $this->getData('typeOfUser');
	}
	
	function setFunctions($functions){
		return $this->setData('functions', $functions);
	}	

	function getFunctions() {
		return $this->getData('functions');
	}

	function setReasonForAbsence($reasonForAbsence){
		return $this->setData('reasonForAbsence', $reasonForAbsence);
	}	

	function getReasonForAbsence() {
		return $this->getData('reasonForAbsence');
	}

	function setWasPresent($wasPresent) {
		$this->setData('wasPresent', $wasPresent);
	}

	function getWasPresent() {
		return $this->getData('wasPresent');
	}
}

?>
