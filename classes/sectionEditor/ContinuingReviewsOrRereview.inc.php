<?php

class ContinuingReviewsOrRereview {
	
	var $principalInvestigator;
	
	var $titleOfExpeditedAction;
	
	var $typeOfExpeditedAction;
	
	var $dateApproved;
	
	var $description;
	
	function getPrincipalInvestigator() {
		return $this->principalInvestigator;
	}
	
	function getTitleOfExpeditedAction() {
		return $this->titleOfExpeditedAction;
	}
	
	function getTypeOfExpeditedAction() {
		return $this->typeOfExpeditedAction;
	}
	
	function getDateApproved() {
		return $this->dateApproved;
	}
	
	function getDescription() {
		return $this->description;
	}
	
	function setPrincipalInvestigator($principalInvestigator) {
		$this->principalInvestigator=$principalInvestigator;
	}

	function setTitleOfExpeditedAction($titleOfExpeditedAction) {
		$this->titleOfExpeditedAction=$titleOfExpeditedAction;
	}
	
	function setTypeOfExpeditedAction($typeOfExpeditedAction) {
		$this->typeOfExpeditedAction=$typeOfExpeditedAction;
	}
	
	function setDateApproved($dateApproved) {
		$this->dateApproved=$dateApproved;
	}
	function setDescription($description) {
		$this->description=$description;
	}
	
}

?>