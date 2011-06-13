<?php

class ContinuingReview extends ProposalReview {
	
	var $expirationDate;
	
	function ContinuingReview() {
		
	}
	
	function getExpirationDate() {
		return $this->expirationDate;
	}
	
	function setExpirationDate($expirationDate) {
		return $this->expirationDate;
	}
}

?>