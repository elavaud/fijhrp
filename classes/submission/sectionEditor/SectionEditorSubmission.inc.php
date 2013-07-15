<?php

/**
 * @file classes/submission/sectionEditor/SectionEditorSubmission.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SectionEditorSubmission
 * @ingroup submission
 * @see SectionEditorSubmissionDAO
 *
 * @brief SectionEditorSubmission class.
 */

// $Id$
import('classes.article.Article');

class SectionEditorSubmission extends Article {

	/** @var array the editor decisions of this article */
	var $sectionDecisions;

	/**
	 * Constructor.
	 */
	function SectionEditorSubmission() {
		parent::Article();
	}
	
	/**
	 * Get the submission status. Returns one of the defined constants
         * PROPOSAL_STATUS_DRAFT, PROPOSAL_STATUS_WITHDRAWN, PROPOSAL_STATUS_SUBMITTED,
         * PROPOSAL_STATUS_RETURNED, PROPOSAL_STATUS_REVIEWED, PROPOSAL_STATUS_EXEMPTED
         * Copied from AuthorSubmission::getSubmissionStatus
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
	
	        if($isResubmitted) return PROPOSAL_STATUS_RESUBMITTED;
	    }
	
	    //For all other statuses
	    return $status;
	}
	
	/*
	 * Override getProposalStatusKey in Submission.inc.php
	 */
	function getProposalStatusKey() {
		$proposalStatusMap =& $this->getProposalStatusMap();
		return $proposalStatusMap[$this->getSubmissionStatus()];
	}
	
	//
	// Section Decisions
	//

	/**
	 * Get section decisions.
	 * @return array
	 */
	private function usortDecisions($a, $b){
    	return $a->getDateDecided() == $b->getDateDecided() ? 0 : ( $a->getDateDecided() > $b->getDateDecided() ) ? 1 : -1;
   	}
	
	function getDecisions() {
		$sectionDecisions =& $this->sectionDecisions;
		usort($sectionDecisions, array($this, "usortDecisions"));
		
		if ($sectionDecisions) return $sectionDecisions;
		else return null;
	}

		
	/**
	 * Set section decisions.
	 * @param $sectionDecisions array
	 */
	function setDecisions($sectionDecisions) {
		return $this->sectionDecisions = $sectionDecisions;
	}

	/**
	 * Add a section decision for this article.
	 * @param $sectionDecision array
	 */
	function addDecision($newSectionDecision) {
		if (isset($this->sectionDecisions) && is_array($this->sectionDecisions)) {
			$replaced = false;
			foreach ($this->sectionDecisions as $key => $sectionDecision) {
				if ($sectionDecision->getId() == $newSectionDecision->getId()) {
					$this->sectionDecisions[$key] = $newSectionDecision;
					$replaced = true;
				}
			}
			if (!$replaced) array_push($this->sectionDecisions, $newSectionDecision);
		}
		else $this->sectionDecisions = Array($newSectionDecision);
	}

	/**
	 * Get the last section decision for this article.
	 * @return Section Decision object
	 */
	function getLastSectionDecision() {
		$sectionDecisions =& $this->getDecisions();
		if ($sectionDecisions) return $sectionDecisions[(count($sectionDecisions)-1)];
		else return null;
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
	 * Get review file.
	 * @return ArticleFile
	 */
	function &getReviewFile() {
		$returner =& $this->getData('reviewFile');
		return $returner;
	}

	/**
	 * Set review file.
	 * @param $reviewFile ArticleFile
	 */
	function setReviewFile($reviewFile) {
		return $this->setData('reviewFile', $reviewFile);
	}

	/**
	 * Get previousFiles.
	 * @return ArticleFile
	 */
	function &getPreviousFiles() {
		$returner =& $this->getData('previousFiles');
		return $returner;
	}

	/**
	 * Set previousFiles.
	 * @param $reviewFile ArticleFile
	 */
	function setPreviousFiles($previousFiles) {
		return $this->setData('previousFiles', $previousFiles);
	}

	/**
	 * Get post-review file.
	 * @return ArticleFile
	 */
	function &getEditorFile() {
		$returner =& $this->getData('editorFile');
		return $returner;
	}

	/**
	 * Set post-review file.
	 * @param $editorFile ArticleFile
	 */
	function setEditorFile($editorFile) {
		return $this->setData('editorFile', $editorFile);
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

	/**
	 * 
	 */
	function &getAllPossibleEditorDecisionOptions() {
		static $sectionDecisionOptions = array(
			SUBMISSION_SECTION_DECISION_APPROVED => 'editor.article.decision.approved',
			SUBMISSION_SECTION_DECISION_RESUBMIT => 'editor.article.decision.resubmit',
			SUBMISSION_SECTION_DECISION_DECLINED => 'editor.article.decision.declined',
			SUBMISSION_SECTION_DECISION_COMPLETE => 'editor.article.decision.complete',
			SUBMISSION_SECTION_DECISION_INCOMPLETE=> 'editor.article.decision.incomplete',
			SUBMISSION_SECTION_DECISION_EXEMPTED => 'editor.article.decision.exempted',
			SUBMISSION_SECTION_DECISION_FULL_REVIEW => 'editor.article.decision.fullReview',
			SUBMISSION_SECTION_DECISION_EXPEDITED => 'editor.article.decision.expedited'			
			);
		return $sectionDecisionOptions;
	}
	/**
	 * Return array mapping editor decision constants to their locale strings.
	 * (Includes default mapping '' => "Choose One".)
	 * @return array decision => localeString
	 * Edited by aglet
	 * Last Update: 5/28/2011
	 */
	function &getEditorDecisionOptions() {
		static $sectionDecisionOptions = array(
			'' => 'common.chooseOne',
			SUBMISSION_SECTION_DECISION_APPROVED => 'editor.article.decision.approved',
			SUBMISSION_SECTION_DECISION_RESUBMIT => 'editor.article.decision.resubmit',
			SUBMISSION_SECTION_DECISION_DECLINED => 'editor.article.decision.declined'
		);
		return $sectionDecisionOptions;
	}

	/********************************************
	 * Return array mapping submission completeness options to their locale strings
	 * Added by aglet
	 * Last Update: 5/3/2011
	********************************************/

	function &getInitialReviewOptions() {
		static $initialReviewOptions = array(
			'' => 'common.chooseOne',
			SUBMISSION_SECTION_DECISION_COMPLETE => 'editor.article.decision.complete',
			SUBMISSION_SECTION_DECISION_INCOMPLETE=> 'editor.article.decision.incomplete'
		);
		return $initialReviewOptions;
	}

	/********************************************
	 * Return array mapping of exemption options to their locale strings
	 * Added by aglet
	 * Last Update: 5/28/2011
	********************************************/
	
	function &getExemptionOptions() {
		static $exemptionOptions = array(
			'' => 'common.chooseOne',
			SUBMISSION_SECTION_DECISION_EXEMPTED => 'editor.article.decision.exempted',
			SUBMISSION_SECTION_DECISION_FULL_REVIEW => 'editor.article.decision.fullReview',
			SUBMISSION_SECTION_DECISION_EXPEDITED => 'editor.article.decision.expedited'
		);
		return $exemptionOptions;
	}
	
	/********************************************
	 * Return array mapping of continuing review options to their locale strings
	 * Added by aglet
	 * Last Update: 5/28/2011
	********************************************/
	
	function &getContinuingReviewOptions() {
		static $continuingReviewOptions = array(
			'' => 'common.chooseOne',
			SUBMISSION_SECTION_DECISION_FULL_REVIEW => 'editor.article.decision.fullReview',
			SUBMISSION_SECTION_DECISION_EXPEDITED => 'editor.article.decision.expedited',
			SUBMISSION_SECTION_DECISION_EXEMPTED => 'editor.article.decision.exempted',
			SUBMISSION_SECTION_DECISION_DONE => 'editor.article.decision.done'
		);
		return $continuingReviewOptions;
	}
	
	/**
	 * Get the CSS class for highlighting this submission in a list, based on status.
	 * @return string
	 */
	function getHighlightClass() {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$highlightClass = 'highlight';
		$overdueSeconds = 60 * 60 * 24 * 14; // Two weeks

		// Submissions that are not still queued (i.e. published) are not highlighted.
		if ($this->getStatus() != STATUS_QUEUED) return null;

		$journal =& Request::getJournal();
		// Sanity check
		if (!$journal || $journal->getId() != $this->getJournalId()) return null;

		// Check whether it's in review or editing.
		$inEditing = false;
		$decisionsEmpty = true;
		$lastDecisionDate = null;
		$decisions = $this->getDecisions();
		$decision = array_pop($decisions);
		if (!empty($decision)) {
			$latestDecision = array_pop($decision);
			if (is_array($latestDecision)) {
				if ($latestDecision['decision'] == SUBMISSION_SECTION_DECISION_APPROVED) $inEditing = true;
				$decisionsEmpty = false;
				$lastDecisionDate = strtotime($latestDecision['dateDecided']);
			}
		}

		if ($inEditing) {
			// ---
			// --- Highlighting conditions for submissions in editing
			// ---

			// COPYEDITING

			// First round of copyediting
			$initialSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $this->getArticleId());
			$dateCopyeditorNotified = $initialSignoff->getDateNotified() ?
				strtotime($initialSignoff->getDateNotified()) : 0;
			$dateCopyeditorUnderway = $initialSignoff->getDateUnderway() ?
				strtotime($initialSignoff->getDateUnderway()) : 0;
			$dateCopyeditorCompleted = $initialSignoff->getDateCompleted() ?
				strtotime($initialSignoff->getDateCompleted()) : 0;
			$dateCopyeditorAcknowledged = $initialSignoff->getDateAcknowledged() ?
				strtotime($initialSignoff->getDateAcknowledged()) : 0;
			$dateLastCopyeditor = max($dateCopyeditorNotified, $dateCopyeditorUnderway);

			// If the Copyeditor has not been notified, highlight.
			if (!$dateCopyeditorNotified) return $highlightClass;

			// Check if the copyeditor is overdue on round 1
			if (	$dateLastCopyeditor &&
				!$dateCopyeditorCompleted &&
				$dateLastCopyeditor + $overdueSeconds < time()
			) return $highlightClass;

			// Check if acknowledgement is overdue for CE round 1
			if ($dateCopyeditorCompleted && !$dateCopyeditorAcknowledged) return $highlightClass;

			// Second round of copyediting
			$authorSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_AUTHOR', ASSOC_TYPE_ARTICLE, $this->getArticleId());
			$dateCopyeditorAuthorNotified = $authorSignoff->getDateNotified() ?
				strtotime($authorSignoff->getDateNotified()) : 0;
			$dateCopyeditorAuthorUnderway = $authorSignoff->getDateUnderway() ?
				strtotime($authorSignoff->getDateUnderway()) : 0;
			$dateCopyeditorAuthorCompleted = $authorSignoff->getDateCompleted() ?
				strtotime($authorSignoff->getDateCompleted()) : 0;
			$dateCopyeditorAuthorAcknowledged = $authorSignoff->getDateAcknowledged() ?
				strtotime($authorSignoff->getDateAcknowledged()) : 0;
			$dateLastCopyeditorAuthor = max($dateCopyeditorAuthorNotified, $dateCopyeditorAuthorUnderway);

			// Check if round 2 is awaiting notification.
			if ($dateCopyeditorAcknowledged && !$dateCopyeditorAuthorNotified) return $highlightClass;

			// Check if acknowledgement is overdue for CE round 2
			if ($dateCopyeditorAuthorCompleted && !$dateCopyeditorAuthorAcknowledged) return $highlightClass;

			// Check if author is overdue on CE round 2
			if (	$dateLastCopyeditorAuthor &&
				!$dateCopyeditorAuthorCompleted &&
				$dateLastCopyeditorAuthor + $overdueSeconds < time()
			) return $highlightClass;

			// Third round of copyediting
			$finalSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $this->getArticleId());
			$dateCopyeditorFinalNotified = $finalSignoff->getDateNotified() ?
				strtotime($finalSignoff->getDateNotified()) : 0;
			$dateCopyeditorFinalUnderway = $finalSignoff->getDateUnderway() ?
				strtotime($finalSignoff->getDateUnderway()) : 0;
			$dateCopyeditorFinalCompleted = $finalSignoff->getDateCompleted() ?
				strtotime($finalSignoff->getDateCompleted()) : 0;
			$dateLastCopyeditorFinal = max($dateCopyeditorFinalNotified, $dateCopyeditorUnderway);

			// Check if round 3 is awaiting notification.
			if ($dateCopyeditorAuthorAcknowledged && !$dateCopyeditorFinalNotified) return $highlightClass;

			// Check if copyeditor is overdue on round 3
			if (	$dateLastCopyeditorFinal &&
				!$dateCopyeditorFinalCompleted &&
				$dateLastCopyeditorFinal + $overdueSeconds < time()
			) return $highlightClass;

			// Check if acknowledgement is overdue for CE round 3
			if ($dateCopyeditorFinalCompleted && !$dateCopyeditorFinalAcknowledged) return $highlightClass;

			// LAYOUT EDITING
			$layoutSignoff = $signoffDao->build('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $this->getArticleId());
			$dateLayoutNotified = $layoutSignoff->getDateNotified() ?
				strtotime($layoutSignoff->getDateNotified()) : 0;
			$dateLayoutUnderway = $layoutSignoff->getDateUnderway() ?
				strtotime($layoutSignoff->getDateUnderway()) : 0;
			$dateLayoutCompleted = $layoutSignoff->getDateCompleted() ?
				strtotime($layoutSignoff->getDateCompleted()) : 0;
			$dateLayoutAcknowledged = $layoutSignoff->getDateAcknowledged() ?
				strtotime($layoutSignoff->getDateAcknowledged()) : 0;
			$dateLastLayout = max($dateLayoutNotified, $dateLayoutUnderway);

			// Check if Layout Editor needs to be notified.
			if ($dateLastCopyeditorFinal && !$dateLayoutNotified) return $highlightClass;

			// Check if layout editor is overdue
			if (	$dateLastLayout &&
				!$dateLayoutCompleted &&
				$dateLastLayout + $overdueSeconds < time()
			) return $highlightClass;

			// Check if acknowledgement is overdue for layout
			if ($dateLayoutCompleted && !$dateLayoutAcknowledged) return $highlightClass;

			// PROOFREADING
			$signoffDao =& DAORegistry::getDAO('SignoffDAO');

			// First round of proofreading
			$authorSignoff = $signoffDao->build('SIGNOFF_PROOFREADING_AUTHOR', ASSOC_TYPE_ARTICLE, $this->getArticleId());
			$dateAuthorNotified = $authorSignoff->getDateNotified() ?
				strtotime($authorSignoff->getDateNotified()) : 0;
			$dateAuthorUnderway = $authorSignoff->getDateUnderway() ?
				strtotime($authorSignoff->getDateUnderway()) : 0;
			$dateAuthorCompleted = $authorSignoff->getDateCompleted() ?
				strtotime($authorSignoff->getDateCompleted()) : 0;
			$dateAuthorAcknowledged = $authorSignoff->getDateAcknowledged() ?
				strtotime($authorSignoff->getDateAcknowledged()) : 0;
			$dateLastAuthor = max($dateNotified, $dateAuthorUnderway);

			// Check if the author is awaiting proofreading notification.
			if ($dateLayoutAcknowledged && !$dateAuthorNotified) return $highlightClass;

			// Check if the author is overdue on round 1 of proofreading
			if (	$dateLastAuthor &&
				!$dateAuthorCompleted &&
				$dateLastAuthor + $overdueSeconds < time()
			) return $highlightClass;

			// Check if acknowledgement is overdue for proofreading round 1
			if ($dateAuthorCompleted && !$dateAuthorAcknowledged) return $highlightClass;

			// Second round of proofreading
			$proofreaderSignoff = $signoffDao->build('SIGNOFF_PROOFREADING_PROOFREADER', ASSOC_TYPE_ARTICLE, $this->getArticleId());
			$dateProofreaderNotified = $proofreaderSignoff->getDateNotified() ?
				strtotime($proofreaderSignoff->getDateNotified()) : 0;
			$dateProofreaderUnderway = $proofreaderSignoff->getDateUnderway() ?
				strtotime($proofreaderSignoff->getDateUnderway()) : 0;
			$dateProofreaderCompleted = $proofreaderSignoff->getDateCompleted() ?
				strtotime($proofreaderSignoff->getDateCompleted()) : 0;
			$dateProofreaderAcknowledged = $proofreaderSignoff->getDateAcknowledged() ?
				strtotime($proofreaderSignoff->getDateAcknowledged()) : 0;
			$dateLastProofreader = max($dateProofreaderNotified, $dateProofreaderUnderway);

			// Check if the proofreader is awaiting notification.
			if ($dateAuthorAcknowledged && !$dateProofreaderNotified) return $highlightClass;

			// Check if acknowledgement is overdue for proofreading round 2
			if ($dateProofreaderCompleted && !$dateProofreaderAcknowledged) return $highlightClass;

			// Check if proofreader is overdue on proofreading round 2
			if (	$dateLastProofreader &&
				!$dateProofreaderCompleted &&
				$dateLastProofreader + $overdueSeconds < time()
			) return $highlightClass;

			// Third round of proofreading
			$layoutEditorSignoff = $signoffDao->build('SIGNOFF_PROOFREADING_LAYOUT', ASSOC_TYPE_ARTICLE, $this->getArticleId());
			$dateLayoutEditorNotified = $layoutEditorSignoff->getDateNotified() ?
				strtotime($layoutEditorSignoff->getDateNotified()) : 0;
			$dateLayoutEditorUnderway = $layoutEditorSignoff->getDateUnderway() ?
				strtotime($layoutEditorSignoff->getDateUnderway()) : 0;
			$dateLayoutEditorCompleted = $layoutEditorSignoff->getDateCompleted() ?
				strtotime($layoutEditorSignoff->getDateCompleted()) : 0;
			$dateLastLayoutEditor = max($dateLayoutEditorNotified, $dateCopyeditorUnderway);

			// Check if the layout editor is awaiting notification.
			if ($dateProofreaderAcknowledged && !$dateLayoutEditorNotified) return $highlightClass;

			// Check if proofreader is overdue on round 3 of proofreading
			if (	$dateLastLayoutEditor &&
				!$dateLayoutEditorCompleted &&
				$dateLastLayoutEditor + $overdueSeconds < time()
			) return $highlightClass;

			// Check if acknowledgement is overdue for proofreading round 3
			if ($dateLayoutEditorCompleted && !$dateLayoutEditorAcknowledged) return $highlightClass;
		} else {
			// ---
			// --- Highlighting conditions for submissions in review
			// ---
			$lastSectionDecision =& $this->getLastSectionDecision();
			$reviewAssignments =& $lastSectionDecision->getReviewAssignments();
			if (is_array($reviewAssignments) && !empty($reviewAssignments)) {
				$allReviewsComplete = true;
				foreach ($reviewAssignments as $i => $junk) {
					$reviewAssignment =& $reviewAssignments[$i];

					// If the reviewer has not been notified, highlight.
					if ($reviewAssignment->getDateNotified() === null) return $highlightClass;

					// Check review status.
					if (!$reviewAssignment->getCancelled() && !$reviewAssignment->getDeclined()) {
						if (!$reviewAssignment->getDateCompleted()) $allReviewsComplete = false;

						$dateReminded = $reviewAssignment->getDateReminded() ?
							strtotime($reviewAssignment->getDateReminded()) : 0;
						$dateNotified = $reviewAssignment->getDateNotified() ?
							strtotime($reviewAssignment->getDateNotified()) : 0;
						$dateConfirmed = $reviewAssignment->getDateConfirmed() ?
							strtotime($reviewAssignment->getDateConfirmed()) : 0;

						// Check whether a reviewer is overdue to confirm invitation
						if (	!$reviewAssignment->getDateCompleted() &&
							!$dateConfirmed &&
							!$journal->getSetting('remindForInvite') &&
							max($dateReminded, $dateNotified) + $overdueSeconds < time()
						) return $highlightClass;

						// Check whether a reviewer is overdue to complete review
						if (	!$reviewAssignment->getDateCompleted() &&
							$dateConfirmed &&
							!$journal->getSetting('remindForSubmit') &&
							max($dateReminded, $dateConfirmed) + $overdueSeconds < time()
						) return $highlightClass;
					}

					unset($reviewAssignment);
				}
				// If all reviews are complete but no decision is recorded, highlight.
				if ($allReviewsComplete && $decisionsEmpty) return $highlightClass;

				// If the author's last file upload hasn't been taken into account in
				// the most recent decision or author/editor correspondence, highlight.
				$comment = $this->getMostRecentEditorDecisionComment();
				$commentDate = $comment ? strtotime($comment->getDatePosted()) : 0;
				$authorFileDate = null;
				if (	($lastDecisionDate || $commentDate) &&
					$authorFileDate &&
					$authorFileDate > max($lastDecisionDate, $commentDate)
				) return $highlightClass;
			}
		}
		return null;
	}
	
	function getSummaryFile() {
		$summaryFile = null;
		$suppFiles = $this->getSuppFiles();
		foreach($suppFiles as $file) {
			if($file->getType()=="Summary") {
				$summaryFile = $file->getSuppFileTitle();
				break;
			}
		}
		return $summaryFile;
	}
}

?>
