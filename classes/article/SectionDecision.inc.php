<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/SectionDecision.inc.php
 *
 *
 * @brief section decision class.
 * Added by EL on April 2013
 */

// Review type
define('REVIEW_TYPE_INITIAL', 1); 	// Initial Review
define('REVIEW_TYPE_CONTINUING', 2);	// Continuing Review
define('REVIEW_TYPE_AMENDMENT', 3);	// Protocol Amendment
define('REVIEW_TYPE_SAE', 4);	// Serious Adverse Event(s)
define('REVIEW_TYPE_EOS', 5);	// End of study


class SectionDecision extends DataObject {

	var $reviewAssignments;
	
	var $removedReviewAssignments;

	/**
	 * Constructor.
	 */
	function SectionDecision() {
		parent::DataObject();
		$this->reviewAssignments = array();
		$this->removedReviewAssignments = array();
	}

	/**
	 * Get section decision id.
	 * @return int
	 */
	function getId() {
		return $this->getData('sectionDecisionId');
	}

	/**
	 * Set section decision id.
	 * @param $articleId int
	 */
	function setId($sectionDecisionId) {
		return $this->setData('sectionDecisionId', $sectionDecisionId);
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
	 * Get review type.
	 * @return int
	 */
	function getReviewType() {
		return $this->getData('reviewType');
	}

	/**
	 * Set review type.
	 * @param $reviewType int
	 */
	function setReviewType($reviewType) {
		return $this->setData('reviewType', $reviewType);
	}

	/**
	 * Get round.
	 * @return int
	 */
	function getRound() {
		return $this->getData('round');
	}

	/**
	 * Set round.
	 * @param $round int
	 */
	function setRound($round) {
		return $this->setData('round', $round);
	}

	/**
	 * Get section id.
	 * @return int
	 */
	function getSectionId() {
		return $this->getData('sectionId');
	}

	/**
	 * Set section id.
	 * @param $sectionId int
	 */
	function setSectionId($sectionId) {
		return $this->setData('sectionId', $sectionId);
	}

	/**
	 * Get decision.
	 * @return int
	 */
	function getDecision() {
		return $this->getData('decision');
	}

	/**
	 * Set decision.
	 * @param $decision int
	 */
	function setDecision($decision) {
		return $this->setData('decision', $decision);
	}

	/**
	 * Get date decided.
	 * @return date
	 */
	function getDateDecided() {
		return $this->getData('dateDecided');
	}

	/**
	 * Set date decided.
	 * @param $dateDecided date
	 */
	function setDateDecided($dateDecided) {
		return $this->setData('dateDecided', $dateDecided);
	}

	/**
	 * Get review assignments for this decision.
	 * @return array ReviewAssignments
	 */
	function &getReviewAssignments() {
		return $this->reviewAssignments;
	}

	/**
	 * Set review assignments for this article.
	 * @param $reviewAssignments array ReviewAssignments
	 */
	function setReviewAssignments($reviewAssignments) {
		return $this->reviewAssignments = $reviewAssignments;
	}

	/**
	 * Get author viewable review files for this decision.
	 * @return array ReviewAssignments
	 */
	function getAuthorViewableReviewFiles() {
		return $this->getData('authorViewableReviewFiles');
	}

	/**
	 * Set author viewable review files for this decision.
	 * @param $reviewAssignments array ReviewAssignments
	 */
	function setAuthorViewableReviewFiles($authorViewableReviewFiles) {
		return $this->setData('authorViewableReviewFiles', $authorViewableReviewFiles);
	}

	/**
	 * Get decision file.
	 * @return array ReviewAssignments
	 */
	function getDecisionFiles() {
		return $this->getData('decisionFiles');
	}

	/**
	 * Set decision file.
	 * @param $reviewAssignments array ReviewAssignments
	 */
	function setDecisionFiles($decisionFiles) {
		return $this->setData('decisionFiles', $decisionFiles);
	}

	/**
	 * Add a review assignment decision.
	 * @param $reviewAssignment ReviewAssignment
	 */
	function addReviewAssignment($reviewAssignment) {
		if ($reviewAssignment->getDecisionId() == null) {
			$reviewAssignment->setDecisionId($this->getId());
		}

		if (isset($this->reviewAssignments)) {
			$reviewAssignments = $this->reviewAssignments;
		} else {
			$reviewAssignments = Array();
		}
		array_push($reviewAssignments, $reviewAssignment);

		return $this->reviewAssignments = $reviewAssignments;
	}
	
	function removeReviewAssignment($reviewId) {
		$reviewId = (int) $reviewId;

		foreach ($this->reviewAssignments as $key => $assignment) {
			if ($assignment->getReviewId() == $reviewId) {
				$this->removedReviewAssignments[] = $reviewId;
				unset($this->reviewAssignments[$key]);
				return true;
			}
		}
		return false;
	}

	function updateReviewAssignment($reviewAssignment) {
		$reviewAssignments = array();
		$oldReviewAssignments = $this->reviewAssignments;
		for ($i=0, $count=count($oldReviewAssignments); $i < $count; $i++) {
			if ($oldReviewAssignments[$i]->getReviewId() == $reviewAssignment->getId()) {
				array_push($reviewAssignments, $reviewAssignment);
			} else {
				array_push($reviewAssignments, $oldReviewAssignments[$i]);
			}
		}
		$this->reviewAssignments = $reviewAssignments;
	}

	/**
	 * Get the number of resubmission
	 * @return int
	*/
	function getResubmitCount(){
		$sectionDecisionDao = DAORegistry::getDAO('SectionDecisionDAO');
		return $sectionDecisionDao->getResubmitCount($this->getDateDecided(), $this->getArticleId(), $this->getReviewType(), $this->getRound());
	}
	
	/**
	 * Get the public proposal ID of the article concerned by the decision
	 * @return int
	 */
	function getProposalId(){
		$articleDao = DAORegistry::getDAO('ArticleDAO');
		$article =& $articleDao->getArticle($this->getArticleId());
		return $article->getLocalizedProposalId();
	}
}
?>
