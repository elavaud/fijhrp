<?php

import('classes/sectionEditor/ProposalReview');

class InitialReview extends ProposalReview {
	
	var $scientificDesign;
	
	var $subjectSelection;
	
	var $additionalSafeguards;
	
	var $minimizationOfRisks;
	
	var $confidentiality;
	
	var $consentDocument;
	
	var $additionalConsiderations;
	
	var $minorityNotes;
	
	var $comments;
	
	function InitialReview() {
		//parent::;
	}
	
	function setScientificDesign($scientificDesign) {
		$this->scientificDesign=$scientificDesign;
	}
	
	function setSubjectSelection($subjectSelection) {
		$this->subjectSelection=$subjectSelection;
	}
	
	function setAdditionalSafeguards($additionalSafeguards) {
		$this->additionalSafeguards=$additionalSafeguards;
	}
	
	function setMinimizationOfRisks($minimizationOfRisks) {
		$this->minimizationOfRisks=$minimizationOfRisks;
	}
	
	function setConfidentiality($confidentiality) {
		$this->confidentiality=$confidentiality;
	}
	
	function setConsentDocument($consentDocument) {
		$this->consentDocument=$consentDocument;
	}
	
	function setAdditionalConsiderations($additionalConsiderations) {
		$this->additionalConsiderations=$additionalConsiderations;
	}
	
	function setMinorityNotes($minorityNotes) {
		$this->minorityNotes=$minorityNotes;
	}
	
	function setComments($comments) {
		$this->comments=$comments;
	}
	
	function getSubjectSelection() {
		return $this->subjectSelection;
	}
	
	function getAdditionalSafeguards() {
		return $this->additionalSafeguards;
	}
	
	function getMinimizationOfRisks() {
		return $this->minimizationOfRisks;
	}
	
	function getConfidentiality() {
		return $this->confidentiality;
	}
	
	function getConsentDocument() {
		return $this->consentDocument;
	}
	
	function getAdditionalConsiderations() {
		return $this->additionalConsiderations;
	}
	
	function getMinorityNotes() {
		return $this->minorityNotes;
	}
	
	function getComments() {
		return $this->comments;
	}
}
?>