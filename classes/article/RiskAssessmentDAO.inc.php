<?php

/**
 * @file classes/article/RiskAssessmentDAO.inc.php
 *
 * @class RiskAssessmentDAO
 *
 * @brief Operations for retrieving and modifying risk assessments objects.
 * Added by EL on March 11th 2013
 */

// $Id$

import('classes.article.RiskAssessment');

class RiskAssessmentDAO extends DAO{

	/**
	 * Get the risk assessment for a submission.
	 * @param $submissionId int
	 * @return risk assessment
	 */
	function &getRiskAssessmentByArticleId($submissionId) {

		$result =& $this->retrieve(
			'SELECT * FROM article_risk_assessments WHERE article_id = ? LIMIT 1',
			(int) $submissionId
		);

		$riskAssessment =& $this->_returnRiskAssessmentFromRow($result->GetRowAssoc(false));

		$result->Close();
		unset($result);

		return $riskAssessment;
	}

	/**
	 * Insert a new risk Assessment.
	 * @param $riskAssessment Risk Assessment
	 */
	function insertRiskAssessment(&$riskAssessment) {
		$this->update(
			'INSERT INTO article_risk_assessments
				(article_id, identity_revealed, unable_to_consent, under_18, dependent_relationship, ethnic_minority, mental_impairment, pregnant, new_treatment, biological_samples, ionizing_radiation, distress, inducements, sensitive_information, deception, repro_technology, genetic, stem_cell, biosafety, level_of_risk, risks_list, risks_management, risks_to_team, risks_to_subjects, risks_to_community, benefits_to_participants, knowledge_on_condition, knowledge_on_disease, multi_institution, conflict_of_interest)
				VALUES			(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
			array(
				(int) $riskAssessment->getArticleId(),
				(int) $riskAssessment->getIdentityRevealed(),
				(int) $riskAssessment->getUnableToConsent(),
				(int) $riskAssessment->getUnder18(),
				(int) $riskAssessment->getDependentRelationship(),
				(int) $riskAssessment->getEthnicMinority(),
				(int) $riskAssessment->getImpairment(),
				(int) $riskAssessment->getPregnant(),
				(int) $riskAssessment->getNewTreatment(),
				(int) $riskAssessment->getBioSamples(),
				(int) $riskAssessment->getRadiation(),
				(int) $riskAssessment->getDistress(),
				(int) $riskAssessment->getInducements(),
				(int) $riskAssessment->getSensitiveInfo(),
				(int) $riskAssessment->getDeception(),
				(int) $riskAssessment->getReproTechnology(),
				(int) $riskAssessment->getGenetic(),
				(int) $riskAssessment->getStemCell(),
				(int) $riskAssessment->getBiosafety(),
				(int) $riskAssessment->getRiskLevel(),
				(string) $riskAssessment->getListRisks(),
				(string) $riskAssessment->getHowRisksMinimized(),
				(int) $riskAssessment->getRisksToTeam(),
				(int) $riskAssessment->getRisksToSubjects(),
				(int) $riskAssessment->getRisksToCommunity(),
				(int) $riskAssessment->getBenefitsToParticipants(),
				(int) $riskAssessment->getKnowledgeOnCondition(),
				(int) $riskAssessment->getKnowledgeOnDisease(),
				(int) $riskAssessment->getMultiInstitutions(),
				(int) $riskAssessment->getConflictOfInterest()
			)
		);
		
		return true;
	}

	/**
	 * Update an existing risk assessment.
	 * @param $riskAssessment Risk Assessment
	 */
	function updateRiskAssessment(&$riskAssessment) {
		$returner = $this->update(
			'UPDATE article_risk_assessments
			SET	
				identity_revealed = ?,
				unable_to_consent = ?,
				under_18 = ?,
				dependent_relationship = ?, 
				ethnic_minority = ?,
				mental_impairment = ?,
				pregnant = ?,
				new_treatment = ?,
				biological_samples = ?,
				ionizing_radiation = ?,
				distress = ?,
				inducements = ?,
				sensitive_information = ?,
				deception = ?,
				repro_technology = ?,
				genetic = ?,
				stem_cell = ?,
				biosafety = ?,
				level_of_risk = ?,
				risks_list = ?,
				risks_management = ?,
				risks_to_team = ?,
				risks_to_subjects = ?,
				risks_to_community = ?,
				benefits_to_participants = ?,
				knowledge_on_condition = ?,
				knowledge_on_disease = ?,
				multi_institution = ?,
				conflict_of_interest = ?
			WHERE	article_id = ?',
			array(
				(int) $riskAssessment->getIdentityRevealed(),
				(int) $riskAssessment->getUnableToConsent(),
				(int) $riskAssessment->getUnder18(),
				(int) $riskAssessment->getDependentRelationship(),
				(int) $riskAssessment->getEthnicMinority(),
				(int) $riskAssessment->getImpairment(),
				(int) $riskAssessment->getPregnant(),
				(int) $riskAssessment->getNewTreatment(),
				(int) $riskAssessment->getBioSamples(),
				(int) $riskAssessment->getRadiation(),
				(int) $riskAssessment->getDistress(),
				(int) $riskAssessment->getInducements(),
				(int) $riskAssessment->getSensitiveInfo(),
				(int) $riskAssessment->getDeception(),
				(int) $riskAssessment->getReproTechnology(),
				(int) $riskAssessment->getGenetic(),
				(int) $riskAssessment->getStemCell(),
				(int) $riskAssessment->getBiosafety(),
				(int) $riskAssessment->getRiskLevel(),
				(string) $riskAssessment->getListRisks(),
				(string) $riskAssessment->getHowRisksMinimized(),
				(int) $riskAssessment->getRisksToTeam(),
				(int) $riskAssessment->getRisksToSubjects(),
				(int) $riskAssessment->getRisksToCommunity(),
				(int) $riskAssessment->getBenefitsToParticipants(),
				(int) $riskAssessment->getKnowledgeOnCondition(),
				(int) $riskAssessment->getKnowledgeOnDisease(),
				(int) $riskAssessment->getMultiInstitutions(),
				(int) $riskAssessment->getConflictOfInterest(),
				(int) $riskAssessment->getArticleId()
			)
		);
		return true;
	}

	/**
	 * Delete a specific risk assessment by article ID
	 * @param $submissionId int
	 */
	function deleteRiskAssessment($submissionId) {
		$returner = $this->update(
			'DELETE FROM article_risk_assessments WHERE article_id = ?',
			$submissionId
		);
		return $returner;
	}

	/**
	 * Check if a risk assessment exists
	 * @param $submissionId int
	 * @return boolean
	 */
	function riskAssessmentExists($submissionId) {
		$result =& $this->retrieve('SELECT count(*) FROM article_risk_assessments WHERE article_id = ?', (int) $submissionId);
		$returner = $result->fields[0]?true:false;
		$result->Close();
		return $returner;
	}

	/**
	 * Internal function to return a risk assignment object from a row.
	 * @param $row array
	 * @return riskAssignment
	 */
	function &_returnRiskAssessmentFromRow(&$row) {
		$riskAssessment = new RiskAssessment();
		$riskAssessment->setArticleId($row['article_id']);
		$riskAssessment->setIdentityRevealed($row['identity_revealed']);
		$riskAssessment->setUnableToConsent($row['unable_to_consent']);
		$riskAssessment->setUnder18($row['under_18']);
		$riskAssessment->setDependentRelationship($row['dependent_relationship']);
		$riskAssessment->setEthnicMinority($row['ethnic_minority']);
		$riskAssessment->setImpairment($row['mental_impairment']);
		$riskAssessment->setPregnant($row['pregnant']);
		$riskAssessment->setNewTreatment($row['new_treatment']);
		$riskAssessment->setBioSamples($row['biological_samples']);
		$riskAssessment->setRadiation($row['ionizing_radiation']);
		$riskAssessment->setDistress($row['distress']);
		$riskAssessment->setInducements($row['inducements']);
		$riskAssessment->setSensitiveInfo($row['sensitive_information']);
		$riskAssessment->setDeception($row['deception']);
		$riskAssessment->setReproTechnology($row['repro_technology']);
		$riskAssessment->setGenetic($row['genetic']);
		$riskAssessment->setStemCell($row['stem_cell']);
		$riskAssessment->setBiosafety($row['biosafety']);
		$riskAssessment->setRiskLevel($row['level_of_risk']);
		$riskAssessment->setListRisks($row['risks_list']);
		$riskAssessment->setHowRisksMinimized($row['risks_management']);
		$riskAssessment->setRisksToTeam($row['risks_to_team']);
		$riskAssessment->setRisksToSubjects($row['risks_to_subjects']);
		$riskAssessment->setRisksToCommunity($row['risks_to_community']);
		$riskAssessment->setBenefitsToParticipants($row['benefits_to_participants']);
		$riskAssessment->setKnowledgeOnCondition($row['knowledge_on_condition']);
		$riskAssessment->setKnowledgeOnDisease($row['knowledge_on_disease']);
		$riskAssessment->setMultiInstitutions($row['multi_institution']);
		$riskAssessment->setConflictOfInterest($row['conflict_of_interest']);

		HookRegistry::call('RiskAssessmentDAO::_returnRiskAssessmentFromRow', array(&$riskAssessment, &$row));

		return $riskAssessment;
	}
}

?>
