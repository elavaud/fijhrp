<?php

import('lib.pkp.classes.who.MeetingReviewer');

class MeetingSubmissionDAO extends DAO {

	
	function MeetingSubmissionDAO() {
		parent::DAO();
	}
	
	/**
	 * Get meeting reviewer object
	 * @param $meetingId int
	 * @param $reviewerId int
	 * @return MeetingReviewer
	 */
	function &getMeetingSubmissionsByMeetingId($meetingId) {
		$meetingReviewer = null;
		$result =& $this->retrieve(
			'SELECT meeting_id, reviewer_id, 
			FROM meeting_submissions
			WHERE meeting_id = ?',
			(int) $meetingId
		);
	}
	
	/**
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return MeetingReviewer
	 */
	function &_returnMeetingSubmissionFromRow(&$row) {
		$meetingSubmission = new MeetingSubmission();
		$meetingSubmission->setMeetingId($row['meeting_id']);
		$meetingSubmission->setReviewerId($row['reviewer_id']);
		HookRegistry::call('MeetingSubmissionDAO::_returnMeetingSubmissionFromRow', array(&$meetingSubmission, &$row));
		return $meetingReviewer;
	}
	
	/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}
	
	/** 
	 * Insert a new data object
	 * @param int $meetingId
	 * @param int $reviewerId
	 */
	function insertMeetingSubmission($meetingId, $reviewerId) {
		$this->update (
			'INSERT INTO meeting_reviewer
			(meeting_id, reviewer_id)
			VALUES (?, ?)',
			array($meetingId, $reviewerId)
		);
	}
	
	/**
	 * Update data object
	 * @param MeetingReviewer $meetingReviewer
	 */
	function deleteMeetingSubmission($meetingId, $reviewerId) {
		return $this->update(
			'DELETE FROM meeting_submissions WHERE meeting_id = ? AND reviewer_id = ?', 
			array(
			$meetingReviewer->getMeetingId(),
			$meetingReviewer->getReviewerId()
			)
		);
	}
	

}