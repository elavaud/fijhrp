<?php

class AdverseEvent {
	
	var $principalInvestigator;
	
	var $protocolTitle;
	
	var $protocolNumber;
	
	var $dateOccurred;
	
	var $description;
	
	function AdverseEvent() {
		
	}
	
	function setPrincipalInvestigator($principalInvestigator) {
		$this->principalInvestigator=$principalInvestigator;
	}
	
	function setProtocolTitle($protocolTitle) {
		$this->protocolTitle=$protocolTitle;
	}
	
	function setProtocolNumber($protocolNumber) {
		$this->protocolNumber=$protocolNumber;
	}
	
	function setDateOccurred($dateOccurred) {
		$this->dateOccurred=$dateOccurred;
	}
	
	function setDescription($description) {
		$this->description=$description;
	}
	
	function getPrincipalInvestigator() {
		return $this->principalInvestigator;
	}
	
	function getProtocolTitle() {
		return $this->protocolTitle;
	}
	
	function getProtocolNumber() {
		return $this->protocolNumber;
	}
	
	function getDateOccurred() {
		return $this->dateOccurred;
	}
	
	function getDescription() {
		return $this->description;
	}
	
	
}

?>