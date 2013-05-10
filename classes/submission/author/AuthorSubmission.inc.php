<?php

/**
 * @file classes/submission/author/AuthorSubmission.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorSubmission
 * @ingroup submission
 * @see AuthorSubmissionDAO
 *
 * @brief AuthorSubmission class.
 */

// $Id$


import('classes.article.Article');

class AuthorSubmission extends Article {

	/** @var array the editor decisions of this article */
	var $sectionDecisions;

	/**
	 * Constructor.
	 */
	function AuthorSubmission() {
		parent::Article();
		$this->reviewAssignments = array();
	}


	//
	// Editor Decisions
	//

	/**
	 * Set editor decisions.
	 * @param $sectionDecisions array
	 */
	function setDecisions($sectionDecisions) {
		return $this->sectionDecisions = $sectionDecisions;
	}

	/**
	 * Get editor decisions.
	 * @param $sectionDecisions array
	 */
	function getDecisions() {
		return $this->sectionDecisions;
	}

	/**
	 * Get the last section decision id for this article.
	 * @return Section Decision object
	 */
	function getLastSectionDecisionId() {
		$sectionDecisions =& $this->getDecisions();
		$sDecision =& $sectionDecisions[(count($sectionDecisions)-1)];
		if ($sDecision) return $sDecision->getId();
		else return null;
	}	
		
	/**
	 * Get the submission status. Returns one of the defined constants
         * PROPOSAL_STATUS_DRAFT, PROPOSAL_STATUS_WITHDRAWN, PROPOSAL_STATUS_SUBMITTED,
         * PROPOSAL_STATUS_RETURNED, PROPOSAL_STATUS_REVIEWED, PROPOSAL_STATUS_EXEMPTED
	 */
	function getSubmissionStatus() {

	    if ($this->getSubmissionProgress() && !$this->getDateSubmitted()) return PROPOSAL_STATUS_DRAFT;
	
	    //"Withdrawn", "Reviewed" and "Archived" statuses are reflected in table articles field status
	    if($this->getStatus() == STATUS_WITHDRAWN) return PROPOSAL_STATUS_WITHDRAWN;
	
	    if($this->getStatus() == STATUS_REVIEWED) return PROPOSAL_STATUS_REVIEWED;
	    
	    if($this->getStatus() == STATUS_ARCHIVED) return PROPOSAL_STATUS_ARCHIVED;  
		
	    if($this->getStatus() != STATUS_ARCHIVED && $this->getStatus() != STATUS_REVIEWED && $this->getStatus() != STATUS_WITHDRAWN && $this->getStatus() != STATUS_COMPLETED) {
	    	if ($this->getLastModified() > $this->getLastSectionDecisionDate()) {
	    		if ($this->getResubmitCount() > 0) return PROPOSAL_STATUS_RESUBMITTED;
	    		else return PROPOSAL_STATUS_SUBMITTED;
	    	}
	    }

	    $status = $this->getProposalStatus();
	    if($status == PROPOSAL_STATUS_RETURNED) {
	        $articleDao = DAORegistry::getDAO('ArticleDAO');
	        $isResubmitted = $articleDao->isProposalResubmitted($this->getArticleId());
	
	        if($isResubmitted) return PROPOSAL_STATUS_SUBMITTED;
	        else return PROPOSAL_STATUS_RETURNED;
	    }
	
	    if ($status==PROPOSAL_STATUS_REVIEWED) {
	        $decision = $this->getMostRecentDecision();
	        if ($decision==SUBMISSION_SECTION_DECISION_RESUBMIT || $decision==SUBMISSION_SECTION_DECISION_APPROVED) {
	
	            $articleDao = DAORegistry::getDAO('ArticleDAO');
	            $isResubmitted = $articleDao->isProposalResubmitted($this->getArticleId());
	
	            if($isResubmitted) return PROPOSAL_STATUS_SUBMITTED;
	            else return PROPOSAL_STATUS_REVIEWED;
	        }
	    }
	
	    //For all other statuses
	    
	    return $status;
	}	

	//
	// Files
	//

	/**
	 * Get submission file for this article.
	 * @return ArticleFile
	 */
	function &getSubmissionFile() {
		$returner =& $this->getData('submissionFile');
		return $returner;
	}

	/**
	 * Set submission file for this article.
	 * @param $submissionFile ArticleFile
	 */
	function setSubmissionFile($submissionFile) {
		return $this->setData('submissionFile', $submissionFile);
	}

	/**
	 * Get revised file for this article.
	 * @return ArticleFile
	 */
	function &getRevisedFile() {
		$returner =& $this->getData('revisedFile');
		return $returner;
	}

	/**
	 * Set revised file for this article.
	 * @param $submissionFile ArticleFile
	 */
	function setRevisedFile($revisedFile) {
		return $this->setData('revisedFile', $revisedFile);
	}

	/**
	 * Get supplementary files for this article.
	 * @return array SuppFiles
	 */
	function &getSuppFiles() {
		$returner =& $this->getData('suppFiles');
		return $returner;
	}

	/**
	 * Set supplementary file for this article.
	 * @param $suppFiles array SuppFiles
	 */
	function setSuppFiles($suppFiles) {
		return $this->setData('suppFiles', $suppFiles);
	}

	/**
	 * Get the galleys for an article.
	 * @return array ArticleGalley
	 */
	function &getGalleys() {
		$galleys =& $this->getData('galleys');
		return $galleys;
	}

	/**
	 * Set the galleys for an article.
	 * @param $galleys array ArticleGalley
	 */
	function setGalleys(&$galleys) {
		return $this->setData('galleys', $galleys);
	}

	//
	// Comments
	//

	/**
	 * Get most recent editor decision comment.
	 * @return ArticleComment
	 */
	function getMostRecentEditorDecisionComment() {
		return $this->getData('mostRecentEditorDecisionComment');
	}

	/**
	 * Set most recent editor decision comment.
	 * @param $mostRecentEditorDecisionComment ArticleComment
	 */
	function setMostRecentEditorDecisionComment($mostRecentEditorDecisionComment) {
		return $this->setData('mostRecentEditorDecisionComment', $mostRecentEditorDecisionComment);
	}

	/**
	 * Get most recent copyedit comment.
	 * @return ArticleComment
	 */
	function getMostRecentCopyeditComment() {
		return $this->getData('mostRecentCopyeditComment');
	}

	/**
	 * Set most recent copyedit comment.
	 * @param $mostRecentCopyeditComment ArticleComment
	 */
	function setMostRecentCopyeditComment($mostRecentCopyeditComment) {
		return $this->setData('mostRecentCopyeditComment', $mostRecentCopyeditComment);
	}

	/**
	 * Get most recent layout comment.
	 * @return ArticleComment
	 */
	function getMostRecentLayoutComment() {
		return $this->getData('mostRecentLayoutComment');
	}

	/**
	 * Set most recent layout comment.
	 * @param $mostRecentLayoutComment ArticleComment
	 */
	function setMostRecentLayoutComment($mostRecentLayoutComment) {
		return $this->setData('mostRecentLayoutComment', $mostRecentLayoutComment);
	}

	/**
	 * Get most recent proofread comment.
	 * @return ArticleComment
	 */
	function getMostRecentProofreadComment() {
		return $this->getData('mostRecentProofreadComment');
	}

	/**
	 * Set most recent proofread comment.
	 * @param $mostRecentProofreadComment ArticleComment
	 */
	function setMostRecentProofreadComment($mostRecentProofreadComment) {
		return $this->setData('mostRecentProofreadComment', $mostRecentProofreadComment);
	}
}

?>
