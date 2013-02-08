<?php

class MeetingAttendance extends DataObject {
	
	function MeetingAttendance() {
		parent::DataObject();
	}
	
	function setId($meetingId) {
		$this->setData('meetingId', $meetingId);
	}
	
	function getId() {
		return $this->getData('meetingId');
	}
	
	function setMeetingId($meetingId) {
		$this->setData('meetingId', $meetingId);
	}
	
	function getMeetingId() {
		return $this->getData('meetingId');
	}
	
	function setUser($userId) {
		$this->setData('userId', $userId);
	}
	
	function getUser() {
		return $this->getData('userId');
	}
	
	function setIsPresent($isPresent = false) {
		$this->setData('isPresent', $isPresent);
	}
	
	function isPresent() {
		return $this->getData('isPresent');
	}
	
	function setRemarks($remarks) {
		$this->setData('remarks', $remarks);
	}
	
	function getRemarks() {
		return $this->getData('remarks');
	}
}

?>