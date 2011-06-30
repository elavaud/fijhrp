<?php

class ProposalReview {
	
	var $principalInvestigator;
	
	var $protocolTitle;
	
	var $protocolNumber;
	
	var $protocolSummary;
	
	var $generalDiscussion;
	
	var $stipulations;
	
	var $recommendations;
	
	var $riskLevel;
	
	var $benefitCategory;
	
	var $decision;
	
	var $votes;
	
	function ProposalReview() {
		$votes['approvedCount']=0;
		$votes['notApprovedCount']=0;
		$votes['abstainCount']=0;
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
	
	function setProtocolSummary($protocolSummary) {
		$this->protocolSummary=$protocolSummary;
	}
	
	function setGeneralDiscussion($generalDiscussion){
		$this->generalDiscussion=$generalDiscussion;
	}
	
	function setStipulations($stipulations) {
		$this->stipulations=$stipulations;
	}
	
	function setRecommendations($recommendations) {
		$this->recommendations=$recommendations;
	}
	
	function setRiskLevel($riskLevel) {
		$this->riskLevel=$riskLevel;
	}
	
	function setBenefitCategory($benefitCategory) {
		$this->benefitCategory=$benefitCategory;
	}
	
	function setDecision($decision) {
		$this->decision=$decision;
	}
	
	function setVotes($votes) {
		$this->votes['approvedCount']=$votes['approvedCount'];
		$this->votes['notApprovedCount']=$votes['notApprovedCount'];
		$this->votes['abstainCount']=$votes['abstainCount'];
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
	
	function getProtocolSummary() {
		return $this->protocolSummary;
	}
	
	function getGeneralDiscussion() {
		return $this->generalDiscussion;
	}
	
	function getStipulations() {
		return $this->stipulations;
	}
	
	function getRecommendations() {
		return $this->recommendations;
	}
	
	function getRiskLevel() {
		return $this->riskLevel;	
	}
	
	function getBenefitCategory() {
		return $this->benefitCategory;
	}
	
	function getDecision() {
		return $this->decision;
	}
	
	function getVotes() {
		return $this->votes;
	}
	
	
}

?>