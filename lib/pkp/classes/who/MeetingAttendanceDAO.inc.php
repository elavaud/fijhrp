
<?php

import('lib.pkp.classes.who.MeetingAttendance');

class MeetingAttendanceDAO extends DAO {
	/**
	 * Constructor
	 */
	function MeetingAttendanceDAO() {
		parent::DAO();
	}

	/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}

	function insertMeetingAttendance($meetingAttendance) {
		$this->update(
			'INSERT INTO meeting_attendance (meeting_id, user_id, is_present, remarks) VALUES (?, ?, ?, ?)',
			array((int) $meetingAttendance->getMeetingId(), (int) $meetingAttendance->getUser(), (int) $meetingAttendance->isPresent(), $meetingAttendance->getRemarks())
		);
	}
	
}

?>
