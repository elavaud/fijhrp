<?php

/**
 * Last update on February 2013
 * EL
**/

import('lib.pkp.classes.who.MeetingAttendance');

class MeetingAttendanceDAO extends DAO {
	/**
	 * Constructor
	 */
	var $userDao;
	function MeetingAttendanceDAO() {
		parent::DAO();
		$this->userDao =& DAORegistry::getDAO('UserDAO');
	}

		/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}

	
	/** 
	 * Insert new user for the meeting discussion
	 * Insert a new data object
	 * @param int $meetingId
	 * @param int $userId
	 * @param int $typeOfUser
	 */
	function insertMeetingAttendance($meetingId, $userId, $typeOfUser, $attendance = null) {
		$this->update(
			'INSERT INTO meeting_attendance
			(meeting_id, user_id, type_of_user, attending)
			VALUES (?, ?, ?, ?)',
			array($meetingId, $userId, $typeOfUser, $attendance?$attendance:3)
		); 
	}
	
	function &getMeetingAttendancesByMeetingId($meetingId) {
		
		$meetingAttendances = array();
		$result =& $this->retrieve(
			'SELECT a.meeting_id, a.user_id, a.remarks, a.attending,
			 		b.first_name, b.last_name, b.salutation, a.date_reminded, a.type_of_user
			 FROM meeting_attendance a LEFT JOIN users b ON (a.user_id = b.user_id )
			 WHERE meeting_id = ? ORDER BY a.type_of_user',
			(int) $meetingId
		);
		
		while (!$result->EOF) {
			$meetingAttendances[] =& $this->_returnMeetingAttendanceFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}
		
		$result->Close();
		unset($result);

		return $meetingAttendances;
	}

	function &getMeetingAttendancesByMeetingIdAndTypeOfUser($meetingId, $typeOfUser) {
		
		$meetingAttendances = array();
		$result =& $this->retrieve(
			'SELECT a.meeting_id, a.user_id, a.remarks, a.attending,
			 		b.first_name, b.last_name, b.salutation, a.date_reminded, a.type_of_user
			 FROM meeting_attendance a LEFT JOIN users b ON (a.user_id = b.user_id )
			 WHERE a.meeting_id = ? and a.type_of_user = ?',
			array((int) $meetingId, (int) $typeOfUser)
		);
		
		while (!$result->EOF) {
			$meetingAttendances[] =& $this->_returnMeetingAttendanceFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}
		
		$result->Close();
		unset($result);

		return $meetingAttendances;
	}

	/**
	 * Return the submission_id
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return submission_id
	 */
	function &_returnMeetingAttendanceFromRow(&$row) {

		$user =& $this->userDao->getUser($row['user_id']);
		
		$meetingAttendance = new MeetingAttendance();
		$meetingAttendance->setMeetingId($row['meeting_id']);
		$meetingAttendance->setUserId($row['user_id']);
		$meetingAttendance->setIsAttending($row['attending']);
		$meetingAttendance->setRemarks($row['remarks']);
		$meetingAttendance->setDateReminded($row['date_reminded']);
		$meetingAttendance->setFirstName($row['first_name']);
		$meetingAttendance->setLastName($row['last_name']);
		$meetingAttendance->setSalutation($row['salutation']);
		$meetingAttendance->setTypeOfUser($row['type_of_user']);
		$meetingAttendance->setFunctions($user->getFunctions());
		HookRegistry::call('MeetingAttendanceDAO::_returnMeetingAttendanceFromRow', array(&$meetingAttendance, &$row));
		return $meetingAttendance;
	}
	
	/**
	 * Update meeting_attendance table to save user response 
	 * Added by ayveemallare 7/6/2011
	 * @param Meeting $meeting
	 */
	function updateReplyOfAttendance($meeting) {
		$this->update(
			'UPDATE meeting_attendance SET attending = ?, remarks = ?
			WHERE meeting_id = ? AND user_id = ?',
			array($meeting->getIsAttending(),
			$meeting->getRemarks(), 
			$meeting->getId(), 
			$meeting->getUserId())
		);
	}
	
	function updateDateReminded($dateReminded, $userId, $meeting) {
		$this->update(
			sprintf('UPDATE meeting_attendance SET date_reminded = %s
			WHERE meeting_id = ? AND user_id = ?',
			$this->datetimeToDB($dateReminded)), array($meeting->getId(), $userId));
	}
	
	function resetReplyOfUsers($meeting) {
		$this->update(
			'UPDATE meeting_attendance SET attending = 0, remarks = NULL
			WHERE meeting_id = ?', $meeting->getId()
		);
	}
	
	/**
	 * Update meeting_attendance table to save attendance in meeting 
	 * Added by aglet 7/17/2011
	 * @param Meeting $meeting
	 */
	function updateAttendanceOfUser($meeting) {
		$this->update(
			'UPDATE meeting_attendance SET present = ?, reason_for_absence = ?
			WHERE meeting_id = ? AND user_id = ?',
			array($meeting->isPresent(),
			$meeting->getReasonForAbsence(), 
			$meeting->getId(), 
			$meeting->getUserId())
		);
	}

	/**
	 * check if an attendance already exist
	 * Added by EL 2/28/2013
	 * @param Meeting $meetingId
	 */
	function attendanceExists($meetingId, $userId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM meeting_attendance WHERE meeting_id = ? AND user_id = ?', array($meetingId, $userId)
		);
		$returner = isset($result->fields[0]) && $result->fields[0] == 1 ? true : false;

		$result->Close();
		unset($result);

		return $returner;
	}
}

?>
