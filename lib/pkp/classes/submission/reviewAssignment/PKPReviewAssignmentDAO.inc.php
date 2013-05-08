<?php

/**
 * @file classes/submission/reviewAssignment/PKPReviewAssignmentDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class PKPReviewAssignmentDAO
 * @ingroup submission
 * @see PKPReviewAssignment
 *
 * @brief Class for DAO relating reviewers to submissions.
 */

// $Id$


import('lib.pkp.classes.submission.reviewAssignment.PKPReviewAssignment');

class PKPReviewAssignmentDAO extends DAO {
	var $userDao;

	/**
	 * Constructor.
	 */
	function PKPReviewAssignmentDAO() {
		parent::DAO();
		$this->userDao =& DAORegistry::getDAO('UserDAO');
	}

	/**
	 * Retrieve a review assignment by reviewer and decision.
	 * @param $decisionId int
	 * @param $reviewerId int
	 * @param $reviewType int
	 * @return ReviewAssignment
	 */
	function &getReviewAssignment($decisionId, $reviewerId) {

		$result =& $this->retrieve(
			'SELECT r.*, u.first_name, u.last_name, sd.article_id
			FROM    review_assignments r
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id)
			WHERE   r.decision_id = ? AND
				r.reviewer_id = ? AND
				r.cancelled <> 1',
			array((int) $decisionId, (int) $reviewerId)
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_fromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Retrieve a review assignment by review assignment id.
	 * @param $reviewId int
	 * @return ReviewAssignment
	 */
	function &getById($reviewId) {
		$result =& $this->retrieve(
			'SELECT	r.*, u.first_name, u.last_name, sd.article_id
			FROM    review_assignments r
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id)
			WHERE   r.review_id = ?',
			(int) $reviewId
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_fromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Get all incomplete review assignments for all journals/conferences/presses
	 * @param $articleId int
	 * @return array ReviewAssignments
	 */
	function &getIncompleteReviewAssignments() {
		$reviewAssignments = array();

		$result =& $this->retrieve(
			'SELECT	r.*, u.first_name, u.last_name, sd.article_id
			FROM	review_assignments r
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id)
			WHERE	(r.cancelled IS NULL OR r.cancelled = 0) AND
				r.date_notified IS NOT NULL AND
				r.date_completed IS NULL AND
				r.declined <> 1
			ORDER BY r.decision_id'
		);

		while (!$result->EOF) {
			$reviewAssignments[] =& $this->_fromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $reviewAssignments;
	}

	/**
	 * Get all review assignments for a decision.
	 * @param $decisionId int optional
	 * @return array ReviewAssignments
	 */
	function &getByDecisionId($decisionId) {
		$reviewAssignments = array();

		$query = 'SELECT r.*, u.first_name, u.last_name, sd.article_id
			FROM	review_assignments r
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id)
			WHERE	r.decision_id = ?';

		$orderBy = ' ORDER BY review_id';

		$queryParams[] = (int) $decisionId;

		$query .= $orderBy;

		$result =& $this->retrieve($query, $queryParams);

		while (!$result->EOF) {
			$reviewAssignments[$result->fields['review_id']] =& $this->_fromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $reviewAssignments;
	}

	/**
	 * Get all review assignments for a reviewer.
	 * @param $userId int
	 * @return array ReviewAssignments
	 */
	function &getByUserId($userId) {
		$reviewAssignments = array();

		$result =& $this->retrieve(
			'SELECT	r.*, u.first_name, u.last_name, sd.article_id
			FROM	review_assignments r
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id)
			WHERE	r.reviewer_id = ?
			ORDER BY r.decision_id, review_id',
			(int) $userId
		);

		while (!$result->EOF) {
			$reviewAssignments[] =& $this->_fromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $reviewAssignments;
	}

	/**
	 * Get all review assignments for a review form.
	 * @param $reviewFormId int
	 * @return array ReviewAssignments
	 */
	function &getByReviewFormId($reviewFormId) {
		$reviewAssignments = array();

		$result =& $this->retrieve(
			'SELECT	r.*, u.first_name, u.last_name, sd.article_id
			FROM	review_assignments r
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id)
			WHERE	r.review_form_id = ?
			ORDER BY r.decision_id, review_id',
			(int) $reviewFormId
		);

		while (!$result->EOF) {
			$reviewAssignments[] =& $this->_fromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $reviewAssignments;
	}

	/**
	 * Get all cancelled/declined review assignments for a decision.
	 * @param $decisionId int
	 * @return array ReviewAssignments
	 */
	function &getCancelsAndRegrets($decisionId) {
		$reviewAssignments = array();

		$result =& $this->retrieve(
			'SELECT	r.*, u.first_name, u.last_name, sd.article_id
			FROM	review_assignments r
				LEFT JOIN users u ON (r.reviewer_id = u.user_id)
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.section_decision_id AND sd.section_decision_id = ?)
			WHERE r.cancelled = 1 OR r.declined = 1
			ORDER BY review_id',
			(int) $decisionId
		);

		while (!$result->EOF) {
			$reviewAssignments[] =& $this->_fromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $reviewAssignments;
	}

	/**
	 * Determine the order of active reviews for the given decision
	 * @param $submissionId int
	 * @return array associating review ID with number; ie if review ID 26 is first, returned['26']=0
	 */
	function &getReviewIndexesForDecision($decisionId) {
		$returner = array();
		$index = 0;
		$result =& $this->retrieve(
			'SELECT	review_id
			FROM	review_assignments
			WHERE	decision_id = ? AND (cancelled = 0 OR cancelled IS NULL)
			ORDER BY review_id',
			array((int) $decisionId)
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$returner[$row['review_id']] = $index++;
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Get the most recent last modified date for all review assignments for each decision of a submission.
	 * @param $submissionId int
	 * @return array associating decision with most recent last modified date
	 */
	function &getLastModifiedByDecision($submissionId) {
		$returner = array();

		$result =& $this->retrieve(
			'SELECT	r.decision_id, MAX(r.last_modified) as last_modified
			FROM	review_assignments r
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.decision_id AND sd.article_id = ?)
			GROUP BY r.decision_id',
			(int) $submissionId
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$returner[$row['decision_id']] = $this->datetimeFromDB($row['last_modified']);
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Get the first notified date from all review assignments for a decision of a submission.
	 * @param $submissionId int
	 * @return array Associative array of ($decision_num => $earliest_date_of_notification)*
	 */
	function &getEarliestNotificationByDecsion($submissionId) {
		$returner = array();

		$result =& $this->retrieve(
			'SELECT	r.decision_id, MIN(r.date_notified) as earliest_date
			FROM	review_assignments r
				LEFT JOIN section_decisions sd ON (r.decision_id = sd.decision_id AND sd.article_id = ?)
			GROUP BY r.decision_id',
			(int) $submissionId
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$returner[$row['decision_id']] = $this->datetimeFromDB($row['earliest_date']);
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	function insertReviewAssignment(&$reviewAssignment) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->insertObject($reviewAssignment);
	}

	/**
	 * Insert a new Review Assignment.
	 * @param $reviewAssignment ReviewAssignment
	 */
	function insertObject(&$reviewAssignment) {
		$this->update(
			sprintf('INSERT INTO review_assignments (
				decision_id,
				reviewer_id,
				review_method,
				regret_message,
				competing_interests,
				recommendation,
				declined, replaced, cancelled,
				date_assigned, date_notified, date_confirmed,
				date_completed, date_acknowledged, date_due, date_response_due,
				reviewer_file_id,
				quality, date_rated,
				last_modified,
				date_reminded, reminder_was_automatic,
				review_form_id
				) VALUES (
				?, ?, ?, ?, ?, ?, ?, ?, ?, %s, %s, %s, %s, %s, %s, %s, ?, ?, %s, %s, %s, ?, ?
				)',
				$this->datetimeToDB($reviewAssignment->getDateAssigned()), $this->datetimeToDB($reviewAssignment->getDateNotified()), $this->datetimeToDB($reviewAssignment->getDateConfirmed()), $this->datetimeToDB($reviewAssignment->getDateCompleted()), $this->datetimeToDB($reviewAssignment->getDateAcknowledged()), $this->datetimeToDB($reviewAssignment->getDateDue()), $this->datetimeToDB($reviewAssignment->getDateResponseDue()), $this->datetimeToDB($reviewAssignment->getDateRated()), $this->datetimeToDB($reviewAssignment->getLastModified()), $this->datetimeToDB($reviewAssignment->getDateReminded())),
			array(
				(int) $reviewAssignment->getDecisionId(),
				(int) $reviewAssignment->getReviewerId(),
				(int) $reviewAssignment->getReviewMethod(),
				$reviewAssignment->getRegretMessage(),
				$reviewAssignment->getCompetingInterests(),
				$reviewAssignment->getRecommendation(),
				(int) $reviewAssignment->getDeclined(),
				(int) $reviewAssignment->getReplaced(),
				(int) $reviewAssignment->getCancelled(),
				$reviewAssignment->getReviewerFileId(),
				$reviewAssignment->getQuality(),
				$reviewAssignment->getReminderWasAutomatic(),
				$reviewAssignment->getReviewFormId()
			)
		);

		$reviewAssignment->setId($this->getInsertReviewId());
		return $reviewAssignment->getId();
	}

	/**
	 * Update an existing review assignment.
	 * @param $reviewAssignment object
	 */
	function updateReviewAssignment(&$reviewAssignment) {
		return $this->update(
			sprintf('UPDATE review_assignments
				SET	decision_id = ?,
					reviewer_id = ?,
					review_method = ?,
					regret_message = ?,
					competing_interests = ?,
					recommendation = ?,
					declined = ?,
					replaced = ?,
					cancelled = ?,
					date_assigned = %s,
					date_notified = %s,
					date_confirmed = %s,
					date_completed = %s,
					date_acknowledged = %s,
					date_due = %s,
					date_response_due = %s,
					reviewer_file_id = ?,
					quality = ?,
					date_rated = %s,
					last_modified = %s,
					date_reminded = %s,
					reminder_was_automatic = ?,
					review_form_id = ?
				WHERE review_id = ?',
				$this->datetimeToDB($reviewAssignment->getDateAssigned()), $this->datetimeToDB($reviewAssignment->getDateNotified()), $this->datetimeToDB($reviewAssignment->getDateConfirmed()), $this->datetimeToDB($reviewAssignment->getDateCompleted()), $this->datetimeToDB($reviewAssignment->getDateAcknowledged()), $this->datetimeToDB($reviewAssignment->getDateDue()), $this->datetimeToDB($reviewAssignment->getDateResponseDue()), $this->datetimeToDB($reviewAssignment->getDateRated()), $this->datetimeToDB($reviewAssignment->getLastModified()), $this->datetimeToDB($reviewAssignment->getDateReminded())),
			array(
				(int) $reviewAssignment->getDecisionId(),
				(int) $reviewAssignment->getReviewerId(),
				(int) $reviewAssignment->getReviewMethod(),
				$reviewAssignment->getRegretMessage(),
				$reviewAssignment->getCompetingInterests(),
				$reviewAssignment->getRecommendation(),
				(int) $reviewAssignment->getDeclined(),
				(int) $reviewAssignment->getReplaced(),
				(int) $reviewAssignment->getCancelled(),
				$reviewAssignment->getReviewerFileId(),
				$reviewAssignment->getQuality(),
				$reviewAssignment->getReminderWasAutomatic(),
				$reviewAssignment->getReviewFormId(),
				(int) $reviewAssignment->getId()
			)
		);
	}

	/**
	 * Internal function to return a review assignment object from a row.
	 * @param $row array
	 * @return ReviewAssignment
	 */
	function &_fromRow(&$row) {
		
		$reviewAssignment = $this->newDataObject();

		$reviewAssignment->setReviewId($row['review_id']);
		$reviewAssignment->setDecisionId($row['decision_id']);
		$reviewAssignment->setReviewerId($row['reviewer_id']);
		$reviewAssignment->setReviewerFullName($row['first_name'].' '.$row['last_name']);
		$reviewAssignment->setCompetingInterests($row['competing_interests']);
		$reviewAssignment->setRegretMessage($row['regret_message']);
		$reviewAssignment->setRecommendation($row['recommendation']);
		$reviewAssignment->setDateAssigned($this->datetimeFromDB($row['date_assigned']));
		$reviewAssignment->setDateNotified($this->datetimeFromDB($row['date_notified']));	
		$reviewAssignment->setDateConfirmed($this->datetimeFromDB($row['date_confirmed']));
		$reviewAssignment->setDateCompleted($this->datetimeFromDB($row['date_completed']));
		$reviewAssignment->setDateAcknowledged($this->datetimeFromDB($row['date_acknowledged']));
		$reviewAssignment->setDateDue($this->datetimeFromDB($row['date_due']));
		$reviewAssignment->setDateResponseDue($this->datetimeFromDB($row['date_response_due']));
		$reviewAssignment->setLastModified($this->datetimeFromDB($row['last_modified']));
		$reviewAssignment->setDeclined($row['declined']);
		$reviewAssignment->setReplaced($row['replaced']);
		$reviewAssignment->setCancelled($row['cancelled']);
		$reviewAssignment->setReviewerFileId($row['reviewer_file_id']);
		$reviewAssignment->setQuality($row['quality']);
		$reviewAssignment->setDateRated($this->datetimeFromDB($row['date_rated']));
		$reviewAssignment->setDateReminded($this->datetimeFromDB($row['date_reminded']));
		$reviewAssignment->setReminderWasAutomatic($row['reminder_was_automatic']);
		$reviewAssignment->setReviewFormId($row['review_form_id']);
		return $reviewAssignment;
	}

	/**
	 * Return a new review assignment data object.
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be implemented by subclasses
	}

	function deleteReviewAssignmentById($reviewId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->deleteById($reviewId);
	}

	/**
	 * Delete review assignment.
	 * @param $reviewId int
	 */
	function deleteById($reviewId) {
		$reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
		$reviewFormResponseDao->deleteByReviewId($reviewId);

		return $this->update(
			'DELETE FROM review_assignments WHERE review_id = ?',
			(int) $reviewId
		);
	}

	/**
	 * Delete review assignments by decision ID.
	 * @param $submissionId int
	 * @return boolean
	 */
	function deleteByDecisionId($decisionId) {
		$returner = false;
		$result =& $this->retrieve(
			'SELECT review_id FROM review_assignments WHERE decision_id = ?',
			array((int) $decisionId)
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$reviewId = $row['review_id'];

			$this->update('DELETE FROM review_form_responses WHERE review_id = ?', $reviewId);
			$this->update('DELETE FROM review_assignments WHERE review_id = ?', $reviewId);

			$result->MoveNext();
			$returner = true;
		}
		$result->Close();
		return $returner;
	}

	/**
	 * Delete review assignments by article ID.
	 * @param $submissionId int
	 * @return boolean
	 */
	function deleteBySubmissionId($articleId) {
		$returner = false;
		$result =& $this->retrieve(
			'SELECT ra.review_id 
			FROM review_assignments ra
				LEFT JOIN section_decisions sd ON (ra.decision_id = sd.section_decision_id)
			WHERE sd.article_id = ?',
			array((int) $articleId)
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$reviewId = $row['review_id'];

			$this->update('DELETE FROM review_form_responses WHERE review_id = ?', $reviewId);
			$this->update('DELETE FROM review_assignments WHERE review_id = ?', $reviewId);

			$result->MoveNext();
			$returner = true;
		}
		$result->Close();
		return $returner;
	}

	/**
	 * Get the ID of the last inserted review assignment.
	 * @return int
	 */
	function getInsertReviewId() {
		return $this->getInsertId('review_assignments', 'review_id');
	}
}

?>
