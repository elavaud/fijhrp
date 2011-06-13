<?php

class MeetingUser {
	
	var $fullname;
	var $affiliation;
	
	function MeetingUser() {		
	}
	
	function setFullname($fullname) {
		$this->fullname = $fullname;
	}
	
	function setAffiliation($affiliation) {
		$this->affiliation = $affiliation;
	}
	
	function getFullname() {
		return $this->fullname;
	}
	
	function getAffiliation() {
		return $this->affiliation;
	}
}

?>