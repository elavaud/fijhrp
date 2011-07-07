<?php



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
		echo $meetingId;
		$this->update(
			'INSERT INTO meeting_reviewers
			(meeting_id, reviewer_id)
			VALUES (?, ?)',
			array($meetingId, $reviewerId)
		); 
	}
	
}

?>
