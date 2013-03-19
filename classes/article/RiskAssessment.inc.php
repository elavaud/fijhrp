<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/RiskAssessment.inc.php
 *
 *
 * @brief risk assessment class.
 * Added by EL on March 11th 2013
 */

class RiskAssessment extends DataObject {
	
	/**
	 * Constructor.
	 */
	function RiskAssessment() {
	}

	/**
	 * Get article id.
	 * @return int
	 */
	function getArticleId() {
		return $this->getData('articleId');
	}

	/**
	 * Set article id.
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		return $this->setData('articleId', $articleId);
	}

	/**
	 * Get identityRevealed.
	 * @return int
	 */
	function getIdentityRevealed() {
		return $this->getData('identityRevealed');
	}

	/**
	 * Set identityRevealed (yes/no).
	 * @param $identityRevealed int
	 */
	function setIdentityRevealed($identityRevealed) {
		return $this->setData('identityRevealed', $identityRevealed);
	}

	/**
	 * Get unableToConsent.
	 * @return int
	 */
	function getUnableToConsent() {
		return $this->getData('unableToConsent');
	}

	/**
	 * Set unableToConsent (yes/no).
	 * @param $unableToConsent int
	 */
	function setUnableToConsent($unableToConsent) {
		return $this->setData('unableToConsent', $unableToConsent);
	}

	/**
	 * Get under18.
	 * @return int
	 */
	function getUnder18() {
		return $this->getData('under18');
	}

	/**
	 * Set under18 (yes/no).
	 * @param $under18 int
	 */
	function setUnder18($under18) {
		return $this->setData('under18', $under18);
	}

	/**
	 * Get dependentRelationship.
	 * @return int
	 */
	function getDependentRelationship() {
		return $this->getData('dependentRelationship');
	}

	/**
	 * Set dependentRelationship (yes/no).
	 * @param $dependentRelationship int
	 */
	function setDependentRelationship($dependentRelationship) {
		return $this->setData('dependentRelationship', $dependentRelationship);
	}

	/**
	 * Get ethnicMinority.
	 * @return int
	 */
	function getEthnicMinority() {
		return $this->getData('ethnicMinority');
	}

	/**
	 * Set ethnicMinority (yes/no).
	 * @param $ethnicMinority int
	 */
	function setEthnicMinority($ethnicMinority) {
		return $this->setData('ethnicMinority', $ethnicMinority);
	}

	/**
	 * Get impairment.
	 * @return int
	 */
	function getImpairment() {
		return $this->getData('impairment');
	}

	/**
	 * Set impairment (yes/no).
	 * @param $impairment int
	 */
	function setImpairment($impairment) {
		return $this->setData('impairment', $impairment);
	}

	/**
	 * Get pregnant.
	 * @return int
	 */
	function getPregnant() {
		return $this->getData('pregnant');
	}

	/**
	 * Set pregnant (yes/no).
	 * @param $pregnant int
	 */
	function setPregnant($pregnant) {
		return $this->setData('pregnant', $pregnant);
	}

	/**
	 * Get newTreatment.
	 * @return int
	 */
	function getNewTreatment() {
		return $this->getData('newTreatment');
	}

	/**
	 * Set newTreatment (yes/no).
	 * @param $newTreatment int
	 */
	function setNewTreatment($newTreatment) {
		return $this->setData('newTreatment', $newTreatment);
	}

	/**
	 * Get bioSamples.
	 * @return int
	 */
	function getBioSamples() {
		return $this->getData('bioSamples');
	}

	/**
	 * Set bioSamples (yes/no).
	 * @param $bioSamples int
	 */
	function setBioSamples($bioSamples) {
		return $this->setData('bioSamples', $bioSamples);
	}

	/**
	 * Get radiation.
	 * @return int
	 */
	function getRadiation() {
		return $this->getData('radiation');
	}

	/**
	 * Set radiation (yes/no).
	 * @param $radiation int
	 */
	function setRadiation($radiation) {
		return $this->setData('radiation', $radiation);
	}

	/**
	 * Get distress.
	 * @return int
	 */
	function getDistress() {
		return $this->getData('distress');
	}

	/**
	 * Set distress (yes/no).
	 * @param $distress int
	 */
	function setDistress($distress) {
		return $this->setData('distress', $distress);
	}

	/**
	 * Get inducements.
	 * @return int
	 */
	function getInducements() {
		return $this->getData('inducements');
	}

	/**
	 * Set inducements (yes/no).
	 * @param $inducements int
	 */
	function setInducements($inducements) {
		return $this->setData('inducements', $inducements);
	}

	/**
	 * Get sensitiveInfo.
	 * @return int
	 */
	function getSensitiveInfo() {
		return $this->getData('sensitiveInfo');
	}

	/**
	 * Set sensitiveInfo (yes/no).
	 * @param $sensitiveInfo int
	 */
	function setSensitiveInfo($sensitiveInfo) {
		return $this->setData('sensitiveInfo', $sensitiveInfo);
	}

	/**
	 * Get deception.
	 * @return int
	 */
	function getDeception() {
		return $this->getData('deception');
	}

	/**
	 * Set deception (yes/no).
	 * @param $deception int
	 */
	function setDeception($deception) {
		return $this->setData('deception', $deception);
	}

	/**
	 * Get reproTechnology.
	 * @return int
	 */
	function getReproTechnology() {
		return $this->getData('reproTechnology');
	}

	/**
	 * Set reproTechnology (yes/no).
	 * @param $reproTechnology int
	 */
	function setReproTechnology($reproTechnology) {
		return $this->setData('reproTechnology', $reproTechnology);
	}

	/**
	 * Get genetic.
	 * @return int
	 */
	function getGenetic() {
		return $this->getData('genetic');
	}

	/**
	 * Set genetic (yes/no).
	 * @param $genetic int
	 */
	function setGenetic($genetic) {
		return $this->setData('genetic', $genetic);
	}

	/**
	 * Get stemCell.
	 * @return int
	 */
	function getStemCell() {
		return $this->getData('stemCell');
	}

	/**
	 * Set stemCell (yes/no).
	 * @param $stemCell int
	 */
	function setStemCell($stemCell) {
		return $this->setData('stemCell', $stemCell);
	}

	/**
	 * Get biosafety.
	 * @return int
	 */
	function getBiosafety() {
		return $this->getData('biosafety');
	}

	/**
	 * Set biosafety (yes/no).
	 * @param $biosafety int
	 */
	function setBiosafety($biosafety) {
		return $this->setData('biosafety', $biosafety);
	}

	/**
	 * Get riskLevel.
	 * @return int
	 */
	function getRiskLevel() {
		return $this->getData('riskLevel');
	}

	/**
	 * Set riskLevel (yes/no).
	 * @param $riskLevel int
	 */
	function setRiskLevel($riskLevel) {
		return $this->setData('riskLevel', $riskLevel);
	}

	/**
	 * Get listRisks.
	 * @return string
	 */
	function getListRisks() {
		return $this->getData('listRisks');
	}

	/**
	 * Set listRisks (yes/no).
	 * @param $listRisks string
	 */
	function setListRisks($listRisks) {
		return $this->setData('listRisks', $listRisks);
	}

	/**
	 * Get howRisksMinimized.
	 * @return string
	 */
	function getHowRisksMinimized() {
		return $this->getData('howRisksMinimized');
	}

	/**
	 * Set howRisksMinimized.
	 * @param $identityRevealed string
	 */
	function setHowRisksMinimized($howRisksMinimized) {
		return $this->setData('howRisksMinimized', $howRisksMinimized);
	}

	/**
	 * Get risksToTeam.
	 * @return int
	 */
	function getRisksToTeam() {
		return $this->getData('risksToTeam');
	}

	/**
	 * Set risksToTeam (yes/no).
	 * @param $risksToTeam int
	 */
	function setRisksToTeam($risksToTeam) {
		return $this->setData('risksToTeam', $risksToTeam);
	}
	
	/**
	 * Get risksToSubjects.
	 * @return int
	 */
	function getRisksToSubjects() {
		return $this->getData('risksToSubjects');
	}

	/**
	 * Set risksToSubjects (yes/no).
	 * @param $risksToSubjects int
	 */
	function setRisksToSubjects($risksToSubjects) {
		return $this->setData('risksToSubjects', $risksToSubjects);
	}
	
	/**
	 * Get risksToCommunity.
	 * @return int
	 */
	function getRisksToCommunity() {
		return $this->getData('risksToCommunity');
	}

	/**
	 * Set risksToCommunity (yes/no).
	 * @param $risksToCommunity int
	 */
	function setRisksToCommunity($risksToCommunity) {
		return $this->setData('risksToCommunity', $risksToCommunity);
	}
	
	/**
	 * Get benefitsToParticipants.
	 * @return int
	 */
	function getBenefitsToParticipants() {
		return $this->getData('benefitsToParticipants');
	}

	/**
	 * Set benefitsToParticipants (yes/no).
	 * @param $benefitsToParticipants int
	 */
	function setBenefitsToParticipants($benefitsToParticipants) {
		return $this->setData('benefitsToParticipants', $benefitsToParticipants);
	}
	
	/**
	 * Get knowledgeOnCondition.
	 * @return int
	 */
	function getKnowledgeOnCondition() {
		return $this->getData('knowledgeOnCondition');
	}

	/**
	 * Set knowledgeOnCondition (yes/no).
	 * @param $knowledgeOnCondition int
	 */
	function setKnowledgeOnCondition($knowledgeOnCondition) {
		return $this->setData('knowledgeOnCondition', $knowledgeOnCondition);
	}
	
	/**
	 * Get knowledgeOnDisease.
	 * @return int
	 */
	function getKnowledgeOnDisease() {
		return $this->getData('knowledgeOnDisease');
	}

	/**
	 * Set knowledgeOnDisease (yes/no).
	 * @param $knowledgeOnDisease int
	 */
	function setKnowledgeOnDisease($knowledgeOnDisease) {
		return $this->setData('knowledgeOnDisease', $knowledgeOnDisease);
	}


	/**
	 * Get multiInstitutions.
	 * @return int
	 */
	function getMultiInstitutions() {
		return $this->getData('multiInstitutions');
	}

	/**
	 * Set multiInstitutions (yes/no).
	 * @param $multiInstitutions int
	 */
	function setMultiInstitutions($multiInstitutions) {
		return $this->setData('multiInstitutions', $multiInstitutions);
	}

	/**
	 * Get conflictOfInterest.
	 * @return int
	 * Modified and moved to the Risk Assessment part by EL on March 9th 2013
	 */
	function getConflictOfInterest() {
		return $this->getData('conflictOfInterest');
	}

	/**
	 * Set conflictOfInterest (yes/no).
	 * @param $conflictOfInterest int
	 * Modified and moved to the Risk Assessment part by EL on March 9th 2013
	 */
	function setConflictOfInterest($conflictOfInterest) {
		return $this->setData('conflictOfInterest', $conflictOfInterest);
	}   
}
?>
