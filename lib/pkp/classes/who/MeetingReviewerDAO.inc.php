<?php 

import('lib.pkp.classes.who.MeetingReviewer');

class MeetingReviewerDAO extends DAO {
	/**
	 * Constructor
	 */
	function MeetingReviewerDAO() {
		parent::DAO();
	}
	
	/**
	 * Get meeting reviewer object
	 * @param $meetingId int
	 * @param $reviewerId int
	 * @return MeetingReviewer
	 */
	function &getMeetingReviewersByMeetingId($meetingId) {
		$meetingReviewer = null;
		$result =& $this->retrieve(
			'SELECT meeting_id, reviewer_id, attending, remarks 
			FROM meeting_reviewer
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
	function &_returnMeetingReviewerFromRow(&$row) {
		$meetingReviewer = new MeetingReviewer();
		$meetingReviewer->setMeetingId($row['meeting_id']);
		$meetingReviewer->setReviewerId($row['reviewer_id']);
		$meetingReviewer->setIsAttending($row['attending']);
		$meetingReviewer->setRemarks($row['remarks']);
		
		HookRegistry::call('MeetingReviewerDAO::_returnMeetingReviewerFromRow', array(&$meetingReviewer, &$row));
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
	function insertMeetingReviewer($meetingId, $reviewerId) {
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
	function updateMeetingReviewer($meetingReviewer) {
		$this->update(
			sprintf('UPDATE meeting_reviewer
			SET 
			attending = ?,
			remarks = ?
			WHERE meeting_id = ? AND reviewer_id = ?'),
			array(
			$meetingReviewer->getIsAttending(),
			$meetingReviewer->getRemarks(),
			$meetingReviewer->getMeetingId(),
			$meetingReviewer->getReviewerId())
		);
	}
}

?>