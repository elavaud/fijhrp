<?php

/**
 * @file classes/submission/reviewAssignment/ReviewAssignmentDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ReviewAssignmentDAO
 * @ingroup submission
 * @see ReviewAssignment
 *
 * @brief Class for DAO relating reviewers to articles.
 */

// $Id$


import('classes.submission.reviewAssignment.ReviewAssignment');
import('lib.pkp.classes.submission.reviewAssignment.PKPReviewAssignmentDAO');

class ReviewAssignmentDAO extends PKPReviewAssignmentDAO {
	var $articleFileDao;
	var $suppFileDao;
	var $articleCommentsDao;

	/**
	 * Constructor.
	 */
	function ReviewAssignmentDAO() {
		parent::PKPReviewAssignmentDAO();
		$this->articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$this->suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$this->articleCommentDao =& DAORegistry::getDAO('ArticleCommentDAO');
	}

	/**
	 * Return the review file ID for a submission, given its submission ID.
	 * @param $submissionId int
	 * @return int
	 */
	function _getSubmissionReviewFileId($decisionId) {
		$result =& $this->retrieve(
			'SELECT a.review_file_id 
			FROM articles a 
				LEFT JOIN section_decisions sd ON (a.article_id = sd.article_id) 
			WHERE sd.section_decision_id = ?',
			(int) $decisionId
		);
		$returner = isset($result->fields[0]) ? $result->fields[0] : null;
		$result->Close();
		unset($result);
		return $returner;
	}

	/**
	 * Retrieve a review assignment by review assignment id.
	 * @param $reviewId int
	 * @return ReviewAssignment
	 */
	function &getReviewAssignmentById($reviewId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		$returner =& $this->getById($reviewId);
		return $returner;
	}

	/**
	 * Get all review assignments for a decision.
	 * @param $decisionId int
	 * @return array ReviewAssignments
	 */
	function &getReviewAssignmentsByDecisionId($decisionId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		$returner =& $this->getByDecisionId($decisionId);
		return $returner;
	}

	/**
	 * Get all review assignments for a reviewer.
	 * @param $userId int
	 * @return array ReviewAssignments
	 */
	function &getReviewAssignmentsByUserId($userId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		$returner =& $this->getByUserId($userId);
		return $returner;
	}

	/**
	 * Get all review assignments for a review form.
	 * @param $reviewFormId int
	 * @return array ReviewAssignments
	 */
	function &getReviewAssignmentsByReviewFormId($reviewFormId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		$returner =& $this->getByReviewFormId($reviewFormId);
		return $returner;
	}

	/**
	 * Get a review file for an article for each decision.
	 * @param $articleId int
	 * @return array ArticleFiles
	 */
	function &getReviewFilesByDecision($articleId) {
		$returner = array();

		$result =& $this->retrieve(
			'SELECT	f.*, sd.section_decision_id as decision
			FROM	section_decisions sd,
				article_files f,
				articles a
			WHERE	a.article_id = sd.article_id AND
				sd.article_id = ? AND
				sd.article_id = f.article_id AND
				f.file_id = a.review_file_id',
			(int) $articleId
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$returner[$row['decision']] =& $this->articleFileDao->_returnArticleFileFromRow($row);
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Get all author-viewable reviewer files for an article for each decision.
	 * @param $articleId int
	 * @return array returned[decision][reviewer_index] = array of ArticleFiles
	 */
	function &getAuthorViewableFilesByDecision($articleId) {
		$files = array();

		$result =& $this->retrieve(
			'SELECT	f.*, r.reviewer_id, r.review_id, r.decision_id
			FROM	review_assignments r
				LEFT JOIN article_files f ON (r.reviewer_file_id = f.file_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id)
			WHERE viewable = 1 AND
				sd.article_id = ?
			ORDER BY r.decision_id, r.reviewer_id, r.review_id',
			array((int) $articleId)
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			if (!isset($files[$row['decision_id']]) || !is_array($files[$row['decision_id']])) {
				$files[$row['decision_id']] = array();
				$thisReviewerId = $row['reviewer_id'];
				$reviewerIndex = 0;
			} else if ($thisReviewerId != $row['reviewer_id']) {
				$thisReviewerId = $row['reviewer_id'];
				$reviewerIndex++;
			}

			$thisArticleFile =& $this->articleFileDao->_returnArticleFileFromRow($row);
			$files[$row['decision_id']][$reviewerIndex][$row['review_id']][] = $thisArticleFile;
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $files;
	}


	/**
	 * Delete review assignments by decision.
	 * @param $decisionId int
	 * @return boolean
	 */
	function deleteReviewAssignmentsByDecisionId($decisionId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->deleteByDecisionId($decisionId);
	}

	/**
	 * Get the average quality ratings and number of ratings for all users of a journal.
	 * @return array
	 */
	function getAverageQualityRatings($journalId) {
		$averageQualityRatings = Array();
		$result =& $this->retrieve(
			'SELECT	r.reviewer_id, AVG(r.quality) AS average, COUNT(r.quality) AS count
			FROM	review_assignments r, 
					section_decisions sd,
					articles a
			WHERE	r.decision_id = sd.section_decision_id AND 
				sd.article_id = a.article_id AND
				a.journal_id = ?
			GROUP BY r.reviewer_id',
			(int) $journalId
			);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$averageQualityRatings[$row['reviewer_id']] = array('average' => $row['average'], 'count' => $row['count']);
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $averageQualityRatings;
	}

	/**
	 * Get the average quality ratings and number of ratings for all users of a journal.
	 * @return array
	 */
	function getCompletedReviewCounts($journalId) {
		$returner = Array();
		$result =& $this->retrieve(
			'SELECT	r.reviewer_id, COUNT(r.review_id) AS count
			FROM	review_assignments r,
				section_decisions sd,
				articles a
			WHERE	r.decision_id = sd.section_decision_id AND 
				sd.article_id = a.article_id AND
				a.journal_id = ? AND
				r.date_completed IS NOT NULL AND
				r.cancelled = 0
			GROUP BY r.reviewer_id',
			(int) $journalId
			);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$returner[$row['reviewer_id']] = $row['count'];
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Get the number of completed reviews for all published review forms of a journal.
	 * @return array
	 */
	function getCompletedReviewCountsForReviewForms($journalId) {
		$returner = array();
		$result =& $this->retrieve(
			'SELECT	r.review_form_id, COUNT(r.review_id) AS count
			FROM	review_assignments r,
				section_decisions sd,
				articles a,
				review_forms rf
			WHERE	r.decision_id = sd.section_decision_id AND 
				sd.article_id = a.article_id AND
				a.journal_id = ? AND
				r.review_form_id = rf.review_form_id AND
				rf.published = 1 AND
				r.date_completed IS NOT NULL
			GROUP BY r.review_form_id',
			(int) $journalId
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$returner[$row['review_form_id']] = $row['count'];
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Get the number of active reviews for all published review forms of a journal.
	 * @return array
	 */
	function getActiveReviewCountsForReviewForms($journalId) {
		$returner = array();
		$result =& $this->retrieve(
			'SELECT	r.review_form_id, COUNT(r.review_id) AS count
			FROM	review_assignments r,
				section_decisions sd,
				articles a,
				review_forms rf
			WHERE	r.decision_id = sd.section_decision_id AND 
				sd.article_id = a.article_id AND
				a.journal_id = ? AND
				r.review_form_id = rf.review_form_id AND
				rf.published = 1 AND
				r.date_confirmed IS NOT NULL AND
				r.date_completed IS NULL
			GROUP BY r.review_form_id',
			$journalId
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$returner[$row['review_form_id']] = $row['count'];
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Construct a new data object corresponding to this DAO.
	 * @return ReviewAssignment
	 */
	function newDataObject() {
		return new ReviewAssignment();
	}

	/*
	 * Return a review id by decision id and user id
	 */
	function &getReviewIdByDecisionIdAndUserId($decisionId, $userId){
		$result =& $this->retrieve('SELECT review_id FROM review_assignments WHERE decision_id = '. $decisionId . ' AND reviewer_id = '. $userId);
		$row = $result->GetRowAssoc(false);
		return $row['review_id'];
	}
	
	
	/**
	 * Internal function to return a review assignment object from a row.
	 * @param $row array
	 * @return ReviewAssignment
	 */
	 
	function &_fromRow(&$row) {
		
		$reviewAssignment =& parent::_fromRow($row);
		
		$reviewFileId = $this->_getSubmissionReviewFileId($row['decision_id']);
		$reviewAssignment->setReviewFileId($reviewFileId);

		// Files
		$reviewAssignment->setReviewFile($this->articleFileDao->getArticleFile($reviewFileId));
		$reviewAssignment->setReviewerFile($this->articleFileDao->getArticleFile($row['reviewer_file_id']));
		$reviewAssignment->setSuppFiles($this->suppFileDao->getSuppFilesByArticle($row['article_id']));

		// Comments
		$reviewAssignment->setMostRecentPeerReviewComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_PEER_REVIEW, $row['review_id']));
		
		HookRegistry::call('ReviewAssignmentDAO::_fromRow', array(&$reviewAssignment, &$row));
		return $reviewAssignment;
	}
	
}

?>
