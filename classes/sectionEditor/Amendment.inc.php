<?php

class Amendment extends ProposalReview {
	
	var $expirationDate;
	
	function Amendment() {
		
	}
	
	function getExpirationDate() {
		return $this->expirationDate;
	}
	
	function setExpirationDate($expirationDate) {
		return $this->expirationDate;
	}
}

?>