<?php

/**
 * Last update on February 2013
 * EL
**/

class MeetingSubmission extends DataObject {

	function MeetingSubmission() {
		parent::DataObject();
	}
	
	function setMeetingId($meetingId){
			$this->setData('meetingId', $meetingId);
	}
	
	function getMeetingId() {
		return $this->getData('meetingId');
	}
	
	function setSubmissionId($submissionId) {
		$this->setData('submissionId', $submissionId);
	}
	
	function getSubmissionId() {
		return $this->getData('submissionId');
	}
}

?>