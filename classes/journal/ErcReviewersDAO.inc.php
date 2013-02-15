<?php

/**
 * @file classes/journal/ErcReviewersDAO.inc.php
 *
 *
 * @class ErcReviewersDAO
 * @ingroup journal
 *
 * @brief Class for DAO relating erc to reviewers.
 */

// $Id$

class ErcReviewersDAO extends DAO {
	
	/**
	 * Insert a new erc reviewers.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $userId int
	 * @param $status int
	 */

	function insertReviewer($journalId, $sectionId, $userId, $status) {
		return $this->update(
			'INSERT INTO erc_reviewers
				(journal_id, section_id, user_id, status)
				VALUES
				(?, ?, ?, ?)',
			array(
				$journalId,
				$sectionId,
				$userId,
				$status
			)
		);
	}

	/**
	 * Delete an erc_reviewer.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $userId int
	 */
	function deleteReviewer($journalId, $sectionId, $userId) {
		return $this->update(
			'DELETE FROM erc_reviewers WHERE journal_id = ? AND section_id = ? AND user_id = ?',
			array(
				$journalId,
				$sectionId,
				$userId
			)
		);
	}

	/**
	 * Retrieve a list of all erc reviewers assigned to the specified erc.
	 * @param $journalId int
	 * @param $sectionId int
	 * @return array matching Users
	 */
	function &getReviewersBySectionId($journalId, $sectionId) {
		$users = array();

		$userDao =& DAORegistry::getDAO('UserDAO');

		$result =& $this->retrieve(
			'SELECT u.*, er.status FROM users AS u, erc_reviewers AS er WHERE u.user_id = er.user_id AND er.journal_id = ? AND er.section_id = ? ORDER BY last_name, first_name',
			array($journalId, $sectionId)
		);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$users[] = array(
				'user' => $userDao->_returnUserFromRow($row),
				'status' => $row['status']
			);
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $users;
	}

	/**
	 * Delete all erc reviewers for a specified erc in a journal.
	 * @param $sectionId int
	 * @param $journalId int
	 */
	function deleteReviewersBySectionId($sectionId, $journalId = null) {
		if (isset($journalId)) return $this->update(
			'DELETE FROM erc_reviewers WHERE journal_id = ? AND section_id = ?',
			array($journalId, $sectionId)
		);
		else return $this->update(
			'DELETE FROM erc_reviewers WHERE section_id = ?',
			$sectionId
		);
	}

	/**
	 * Delete all erc reviewers for a specified journal.
	 * @param $journalId int
	 */
	function deleteReviewersByJournalId($journalId) {
		return $this->update(
			'DELETE FROM erc_reviewers WHERE journal_id = ?', $journalId
		);
	}

	/**
	 * Delete all section assignments for the specified user.
	 * @param $userId int
	 * @param $journalId int optional, include assignments only in this journal
	 * @param $sectionId int optional, include only this section
	 */
	function deleteReviewersByUserId($userId, $journalId  = null, $sectionId = null) {
		return $this->update(
			'DELETE FROM erc_reviewers WHERE user_id = ?' . (isset($journalId) ? ' AND journal_id = ?' : '') . (isset($sectionId) ? ' AND section_id = ?' : ''),
			isset($journalId) && isset($sectionId) ? array($userId, $journalId, $sectionId)
			: (isset($journalId) ? array($userId, $journalId)
			: (isset($sectionId) ? array($userId, $sectionId) : $userId))
		);
	}

	/**
	 * Check if a user is assigned to a specified erc.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $userId int
	 * @return boolean
	 */
	function ercReviewerExists($journalId, $sectionId, $userId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM erc_reviewers WHERE journal_id = ? AND section_id = ? AND user_id = ?', array($journalId, $sectionId, $userId)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Check if a user is assigned to any erc.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $userId int
	 * @return boolean
	 */
	function reviewerExists($journalId, $userId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM erc_reviewers WHERE journal_id = ? AND user_id = ?', array($journalId, $userId)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Get the erc of the reviewer
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $userId int
	 * @return boolean
	 */
	function getErcByReviewerId($userId) {
		$result =& $this->retrieve(
			'SELECT DISTINCT s.* FROM sections s 
				LEFT JOIN erc_reviewers er ON s.section_id = er.section_id
			WHERE er.user_id = ?', array($userId)
		);

		$sectionDAO =& DAORegistry::getDAO('SectionDAO');

		$returner = null;
		if ($result->RecordCount() == 1) {
			$returner =& $sectionDAO->_returnSectionFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}
}

?>
