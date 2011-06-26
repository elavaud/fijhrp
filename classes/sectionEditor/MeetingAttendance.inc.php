<?php

class MeetingAttendance {
	
	var $groupName;
	var $meetingUsers;
	
	function MeetingAttendance() {
		$meetingUsers = array();
	}
	
	function setGroupName($groupName) {
		$this->groupName = $groupName;
	}
	
	function getGroupName() {
		return $this->groupName;
	}
	
	function addMeetingUser(&$meetingUser) {
		if(!isset($this->meetingUsers)) {
			$this->meetingUsers = array();
		}
		$this->meetingUsers[count($this->meetingUsers)] &= $meetingUser;
	}
	
	function getMeetingUsers() {
		return $this->meetingUsers;
	}
}

?>