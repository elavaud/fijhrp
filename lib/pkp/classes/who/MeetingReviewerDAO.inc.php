<?php


import('lib.pkp.classes.who.MeetingReviewer');
class MeetingReviewerDAO extends DAO {
	/**
	 * Constructor
	 */
	var $userDao;
	function MeetingReviewerDAO() {
		parent::DAO();
	}

		/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}

	
	/** 
	 * Insert new reviewer for the meeting discussion
	 * Insert a new data object
	 * @param int $meetingId
	 * @param int $reviewerId
	 */
	function insertMeetingReviewer($meetingId, $reviewerId) {
		$this->update(
			'INSERT INTO meeting_reviewers
			(meeting_id, reviewer_id)
			VALUES (?, ?)',
			array($meetingId, $reviewerId)
		); 
	}
	
	function &getMeetingReviewersByMeetingId($meetingId) {
		$meetingReviewers = array();
		$result =& $this->retrieve(
			'SELECT a.meeting_id, a.reviewer_id, a.remarks, a.attending,
			 		b.first_name, b.last_name, b.salutation, a.date_reminded
			 FROM meeting_reviewers a LEFT JOIN users b ON (a.reviewer_id = b.user_id )
			 WHERE meeting_id = ?',
			(int) $meetingId
		);
		
		while (!$result->EOF) {
			$meetingReviewers[] =& $this->_returnMeetingReviewerFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}
		
		$result->Close();
		unset($result);

		return $meetingReviewers;
	}

	/**
	 * Return the submission_id
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return submission_id
	 */
	function &_returnMeetingReviewerFromRow(&$row) {
		$meetingReviewer = new MeetingReviewer();
		$meetingReviewer->setMeetingId($row['meeting_id']);
		$meetingReviewer->setReviewerId($row['reviewer_id']);
		$meetingReviewer->setIsAttending($row['attending']);
		$meetingReviewer->setRemarks($row['remarks']);
		$meetingReviewer->setDateReminded($row['date_reminded']);
		$meetingReviewer->setFirstName($row['first_name']);
		$meetingReviewer->setLastName($row['last_name']);
		$meetingReviewer->setSalutation($row['salutation']);
		HookRegistry::call('MeetingReviewerDAO::_returnMeetingReviewerFromRow', array(&$meetingReviewer, &$row));
		return $meetingReviewer;
	}
	
	/**
	 * Update meeting_reviewers table to save reviewer response 
	 * Added by ayveemallare 7/6/2011
	 * @param Meeting $meeting
	 */
	function updateReplyOfReviewer($meeting) {
		$this->update(
			'UPDATE meeting_reviewers SET attending = ?, remarks = ?
			WHERE meeting_id = ? AND reviewer_id = ?',
			array($meeting->getIsAttending(),
			$meeting->getRemarks(), 
			$meeting->getId(), 
			$meeting->getReviewerId())
		);
	}
	
	function updateDateReminded($dateReminded, $reviewerId, $meeting) {
		$this->update(
			sprintf('UPDATE meeting_reviewers SET date_reminded = %s
			WHERE meeting_id = ? AND reviewer_id = ?',
			$this->datetimeToDB($dateReminded)), array($meeting->getId(), $reviewerId));
	}
	
	function resetReplyOfReviewers($meeting) {
		$this->update(
			'UPDATE meeting_reviewers SET attending = 0, remarks = NULL
			WHERE meeting_id = ?', $meeting->getId()
		);
	}
	
	/**
	 * Update meeting_reviewers table to save attendance in meeting 
	 * Added by aglet 7/17/2011
	 * @param Meeting $meeting
	 */
	function updateAttendanceOfReviewer($meeting) {
		$this->update(
			'UPDATE meeting_reviewers SET present = ?, reason_for_absence = ?
			WHERE meeting_id = ? AND reviewer_id = ?',
			array($meeting->isPresent(),
			$meeting->getReasonForAbsence(), 
			$meeting->getId(), 
			$meeting->getReviewerId())
		);
	}
	 
	
}

?>
