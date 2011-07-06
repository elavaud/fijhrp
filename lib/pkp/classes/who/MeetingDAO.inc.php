<?php

import('lib.pkp.classes.who.Meeting');

class MeetingDAO extends DAO {
	/**
	 * Constructor
	 */
	var $userDao;
	function MeetingDAO() {
		parent::DAO();
		$this->userDao &= DAORegistry::getDAO('UserDAO');
	}

	/**
	 * Get meeting object
	 * @param $meeting int
	 * @return Meeting
	 */
	function &getMeetingsOfUser($userId) {
		$meetings = array();
		$result =& $this->retrieve(
			'SELECT meeting_id, meeting_date, user_id, status, final FROM meetings WHERE user_id = ?',
			(int) $userId
		);

		while (!$result->EOF) {
			$meetings[] =& $this->_returnMeetingFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $meetings;
	}
	
	/**
	 * Get meeting object
	 * @param $meeting int
	 * @return Meeting
	 */
	function &getMeetingById($meetingId) {
		$meeting = null;
		$result =& $this->retrieve(
			'SELECT meeting_id, meeting_date, user_id, status, final FROM meetings WHERE meeting_id = ?',
			(int) $meetingId
		);
		
		$meeting =& $this->_returnMeetingFromRow($result->GetRowAssoc(false));
		
		$result->Close();
		unset($result);

		return $meeting;
	}
	
	/********************************** 
	 * Get all meetings by reviewer
	 *  Added by ayveemallare 7/6/2011
	 **********************************/
	function &getMeetingsByReviewerId($reviewerId) {
		$meetingReviewers = array();
		$result =& $this->retrieve(
			'SELECT meetings.meeting_id, reviewer_id, meeting_date, attending, remarks, final
			FROM meeting_reviewer, meetings
			WHERE reviewer_id = ?',
			(int) $reviewerId );
		while (!$result->EOF) {
			$meetingReviewers[] =& $this->_returnMeetingFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $meetingReviewers;
	}

	/**
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return Meeting
	 */
	function &_returnMeetingFromRow(&$row) {
		$meeting = new Meeting();
		$meeting->setId($row['meeting_id']);
		$meeting->setDate($row['meeting_date']);
		$meeting->setUploader($row['user_id']);
		$meeting->setStatus($row['status']);
				
		//Edited by ayveemallare 7/6/2011
		//Added additional fields
		$meeting->setReviewerId($row['reviewer_id']);
		$meeting->setIsAttending($row['attending']);
		$meeting->setRemarks($row['remarks']);
		$meeting->setIsFinal($row['final']);
		
		HookRegistry::call('MeetingDAO::_returnMeetingFromRow', array(&$meeting, &$row));
		return $meeting;
	}

	/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}

	function insertMeeting($userId, $meetingDate = null, $status = 0) {
		$this->update(
			'INSERT INTO meetings (meeting_date, user_id, status) VALUES (?, ?, ?)',
			array($meetingDate, $userId, $status)
		);		
	}
	
	function &createMeeting($userId, $meetingDate = null, $status = 0) {
		$this->insertMeeting($userId, $meetingDate, $status);
				
		$meetingId = 0;
		$result =& $this->retrieve(
			'SELECT max(meeting_id) as meeting_id, meeting_date, user_id, status FROM meetings WHERE user_id = ? GROUP BY meeting_id ORDER BY meeting_id DESC LIMIT 1;',
			(int) $userId
		);
		$row = $result->GetRowAssoc(false);
		$meetingId = $row['meeting_id'];
						
		$result->Close();
		unset($result);

		return $meetingId;
	}
	
	function updateMeetingDate($meeting) {
		$this->update(
			sprintf('UPDATE meetings SET meeting_date = %s where meeting_id = ?',$this->datetimeToDB($meeting->getDate())),
			array($meeting->getId())
		);				
	}
	
	function updateStatus($meeting) {
		$this->update(
			'UPDATE meetings SET status = ? where meeting_id = ?',
			array($meeting->getStatus(), $meeting->getId())
		);
	}
		
}

?>
