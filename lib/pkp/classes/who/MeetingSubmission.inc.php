<?php

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
	
	function setReviewerId($reviewerId) {
		$this->setData('reviewerId', $reviewerId);
	}
	
	function getReviewerId() {
		return $this->getData('reviewerId');
	}
}