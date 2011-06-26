<?php

/*
 * Wrapper class for meeting minutes template
 */

class Minutes {
	
	var $dateHeld;
	
	var $announcements;
	
	var $presentErcMembers;
	
	var $absentErcMembers;
	
	var $guests;
	
	var $initialReviews;
	
	var $continuingReviewsOrRereviews;
	
	var $continuingReviews;
	
	var $amendments;
	
	var $timeConvened;
	
	var $minutesId;

	var $submittedBy;
	
	
	function Minutes() {
		
	}
	
	function setDateHeld($dateHeld) {
		$this->dateHeld=$dateHeld;
	}
	
	function getDateHeld() {
		return $this->dateHeld;
	}
	
	function setAnnouncements($announcements) {
		$this->announcements=$announcements;
	}
	
	function getAnnouncements() {
		return $this->announcements;
	}
	
	function setPresentErcMembers($ercMembers) {
		$this->presentErcMembers=$ercMembers;
	}
	
	function getPresentErcMembers() {
		return $this->presentErcMembers;
	}
	
	function setAbsentErcMembers($ercMembers) {
		$this->absentErcMembers=$ercMembers;
	}
	
	function getAbsentErcMembers() {
		return $this->absentErcMembers;
	}
	
	function setGuests($guests) {
		$this->guests=$guests;
	}
	
	function getGuests() {
		return $this->guests;
	}
	
	function setInitialReviews($initialReviews) {
		$this->initialReviews=$initialReviews;
	}
	
	function addInitialReview($initialReview) {
		if(!isset($this->initialReviews)) {
			$this->initialReviews=array();
		} 
		$this->initialReviews[count($this->initialReviews)]=$initialReview;
	}
	
	function getInitialReviews() {
		return $this->initialReviews;
	}
	
	function setContinuingReviewsOrRereviews($continuingReviewsOrRereviews) {
		$this->continuingReviewsOrRereviews=$continuingReviewsOrRereviews;
	}
	
	function addContinuingReviewOrRereviews($continuingReviewOrRereview) {
		if(!isset($this->continuingReviewsOrRereviews)) {
			$this->continuingReviewsOrRereviews=array();
		} 
		$this->continuingReviewsOrRereviews[count($this->continuingReviewsOrRereviews)]=$continuingReviewOrRereview;
	}
	
	function getContinuingReviewsOrRereviews() {
		return $this->continuingReviewsOrRereviews;
	}
	
	function setContinuingReviews($continuingReviews) {
		$this->continuingReviews=$continuingReviews;
	}
	
	function addContinuingReview($continuingReview) {
		if(!isset($this->continuingReviews)) {
			$this->continuingReviews=array();
		} 
		$this->continuingReviews[count($this->continuingReviews)]=$continuingReview;
	}
	
	function getContinuingReviews() {
		return $this->continuingReviews;
	}
	

	function setAmendments($amendments) {
		$this->amendments=$amendments;
	}
	
	function getAmendments() {
		return $this->amendments;
	}
	
	function setTimeConvened($timeConvened) {
		$this->timeConvened=$timeConvened;
	}
	
	function getTimeConvened() {
		return $this->timeConvened;
	}

	function setMinutesId($minutesId) {
		$this->minutesId=$minutesId;
	}
	
	function getMinutesid() {
		return $this->minutesId;
	}
	
	function getSubmittedBy() {
		return $this->submittedBy;
	}
	
	function setSubmittedBy($submittedBy) {
		$this->submittedBy=$submittedBy;
	}
}

?>