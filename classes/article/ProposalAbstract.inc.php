<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/Abstract.inc.php
 *
 *
 * @brief abstract class.
 * Added by EL on March 11th 2013
 */

class ProposalAbstract extends DataObject {
	
	/**
	 * Constructor.
	 */
	function ProposalAbstract() {
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
	 * Get locale.
	 * @return string
	 */
	function getLocale() {
		return $this->getData('locale');
	}

	/**
	 * Set locale.
	 * @param $locale string
	 */
	function setLocale($locale) {
		return $this->setData('locale', $locale);
	}

	/**
	 * Get the scientific title.
	 * @return string
	 */
	function getScientificTitle() {
		return $this->getData('scientificTitle');
	}

	/**
	 * Get the clean scientific title.
	 * @return string
	 */
	function getCleanScientificTitle() {
		return $this->getData('cleanScientificTitle');
	}

	/**
	 * Set the scientific title.
	 * @param $title string
	 */
	function setScientificTitle($title) {
		$this->setCleanScientificTitle($title);
		return $this->setData('scientificTitle', $title);
	} 

	/**
	 * Set 'clean' scientific title (with punctuation removed).
	 * @param $cleanTitle string
	 */
	function setCleanScientificTitle($cleanTitle) {
		$punctuation = array ("\"", "\'", ",", ".", "!", "?", "-", "$", "(", ")");
		$cleanTitle = str_replace($punctuation, "", $cleanTitle);
		return $this->setData('cleanScientificTitle', $cleanTitle);
	}

	
	/**
	 * Get public title.
	 * @return string
	 */
	function getPublicTitle() {
		return $this->getData('publicTitle');
	}

	/**
	 * Get clean public title.
	 * @return string
	 */
	function getCleanPublicTitle() {
		return $this->getData('cleanPublicTitle');
	}
	
	/**
	 * Set public title.
	 * @param $title string
	 */
	function setPublicTitle($title) {
		$this->setCleanPublicTitle($title);
		return $this->setData('publicTitle', $title);
	}

	/**
	 * Set 'clean' public title (with punctuation removed).
	 * @param $cleanTitle string
	 */
	function setCleanPublicTitle($cleanTitle) {
		$punctuation = array ("\"", "\'", ",", ".", "!", "?", "-", "$", "(", ")");
		$cleanTitle = str_replace($punctuation, "", $cleanTitle);
		return $this->setData('cleanPublicTitle', $cleanTitle);
	}

	/**
	 * Get background.
	 * @return string
	 */
	function getBackground() {
		return $this->getData('background');
	}
	
	/**
	 * Set background.
	 * @param $background string
	 */
	function setBackground($background) {
                $background = preg_replace('/<\s*/', '< ', $background);
                $background = preg_replace('/\s*>/', ' >', $background);
		return $this->setData('background', $background);
	}

	/**
	 * Get objectives.
	 * @return string
	 */
	function getObjectives() {
		return $this->getData('objectives');
	}
	
	/**
	 * Set objectives.
	 * @param $objectives string
	 */
	function setObjectives($objectives) {
                $objectives = preg_replace('/<\s*/', '< ', $objectives);
                $objectives = preg_replace('/\s*>/', ' >', $objectives);
		return $this->setData('objectives', $objectives);
	}

	/**
	 * Get study methods.
	 * @return string
	 */
	function getStudyMethods() {
		return $this->getData('studyMethods');
	}
	
	/**
	 * Set study methods.
	 * @param $studyMethods string
	 */
	function setStudyMethods($studyMethods) {
                $studyMethods = preg_replace('/<\s*/', '< ', $studyMethods);
                $studyMethods = preg_replace('/\s*>/', ' >', $studyMethods);
		return $this->setData('studyMethods', $studyMethods);
	}

	/**
	 * Get expected outcomes and use of results.
	 * @return string
	 */
	function getExpectedOutcomes() {
		return $this->getData('expectedOutcomes');
	}
	
	/**
	 * Set expected outcomes.
	 * @param $expectedOutcomes string
	 */
	function setExpectedOutcomes($expectedOutcomes) {
                $expectedOutcomes = preg_replace('/<\s*/', '< ', $expectedOutcomes);
                $expectedOutcomes = preg_replace('/\s*>/', ' >', $expectedOutcomes);
		return $this->setData('expectedOutcomes', $expectedOutcomes);
	}

	/**
	 * Get proposal keywords.
	 * @param $locale
	 * @return string
	 */
	function getKeywords() {
		return $this->getData('keywords');
	}

	/**
	 * Set proposal keywords.
	 * @param $keywords string
	 * @param $locale
	 */
	function setKeywords($keywords) {
		return $this->setData('keywords', $keywords);
	}

	/**
	 * Get the whole abstract.
	 * @param $locale
	 * @return string
	 */
	function getWholeAbstract() {
		$wholeAbstract = (string)'';
		$wholeAbstract = 
			Locale::translate('proposal.background').':\n'.$this->getBackground().'\n\n'
			.Locale::translate('proposal.objectives').':\n'.$this->getObjectives().'\n\n'
			.Locale::translate('proposal.studyMethods').':\n'.$this->getStudyMethods().'\n\n'
			.Locale::translate('proposal.expectedOutcomes').':\n'.$this->getExpectedOutcomes();
		return $wholeAbstract;
	}

}
?>
