<?php 

class MeetingReviewer extends DataObject {
	
	function MeetingReviewer() {
		parent::DataObject();
	}
	
	function setMeetingId($meetingId) {
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
}


?>