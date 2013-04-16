<?php

/**
 * Last update on February 2013
 * EL
**/

import('classes.meeting.Meeting');
import('lib.pkp.classes.db.DBRowIterator');

class MeetingDAO extends DAO {
	/**
	 * Constructor
	 */
	var $userDao;
	function MeetingDAO() {
		parent::DAO();
		$this->userDao =& DAORegistry::getDAO('UserDAO');
	}

	/**
	 * Get meeting object
	 * @param $meeting int
	 * @return Meeting
	 */
	function &getMeetingsOfSection($sectionId, $sortBy = null, $rangeInfo = null, $sortDirection = SORT_DIRECTION_ASC, $status=null, $minutesStatus=null, $dateFrom=null, $dateTo=null) {
		$sql = 'SELECT meeting_id, meeting_date, section_id, minutes_status, status FROM meetings as a WHERE section_id = ?';
		$searchSql = '';
		
		if (!empty($dateFrom) || !empty($dateTo)) {
			if (!empty($dateFrom)) {
				$searchSql .= ' AND meeting_date >= ' . $this->datetimeToDB($dateFrom);
			}
			if (!empty($dateTo)) {
				$searchSql .= ' AND meeting_date <= ' . $this->datetimeToDB($dateTo);
			}
		}
		if(!empty($status)) {
			$searchSql .= ' AND status = ' . $status;
		}
		
		if(!empty($minutesStatus)) {
			$searchSql .= ' AND minutes_status = ' . $minutesStatus;
		}
		
		
		$result =& $this->retrieveRange(
			$sql. ' ' . $searchSql . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''), 
			(int) $sectionId, $rangeInfo
		);
			
		$returner = new DAOResultFactory($result, $this, '_returnMeetingFromRow');
		return $returner;
	}
	
	/**
	 * Get meeting object
	 * @param $meeting int
	 * @return Meeting
	 */
	function &getMeetingById($meetingId) {
		$meeting = null;
		
		//Added field 'final'
		//Edited by ayveemallare 7/6/2011
		
		$result =& $this->retrieve(
			'SELECT * FROM meetings WHERE meeting_id = ?',
			(int) $meetingId
		);
		
		$meeting =& $this->_returnMeetingFromRow($result->GetRowAssoc(false));
		
		$result->Close();
		unset($result);

		return $meeting;
	}
	
	/**
	 * Get all meetings to be attended by reviewer
	 * Added by ayveemallare 7/6/2011
	 * 
	 * @param unknown_type $reviewerId
	 */
	function &getMeetingsByReviewerId($reviewerId, $sortBy = null, $rangeInfo = null, $sortDirection = SORT_DIRECTION_ASC,
		$status=null, $replyStatus=null, $dateFrom=null, $dateTo=null) {
			
		$sql = 
			'SELECT * 
			FROM meetings a INNER JOIN meeting_attendance b
			ON a.meeting_id = b.meeting_id WHERE b.user_id= ?';
		
		$searchSql = '';
		
		if (!empty($dateFrom) || !empty($dateTo)) {
			if (!empty($dateFrom)) {
				$searchSql .= ' AND meeting_date >= ' . $this->datetimeToDB($dateFrom);
			}
			if (!empty($dateTo)) {
				$searchSql .= ' AND meeting_date <= ' . $this->datetimeToDB($dateTo);
			}
		}
		if(!empty($status)) {
			$searchSql .= ' AND status = ' . $status;
		}
		if(!empty($replyStatus)) {
			$searchSql .= ' AND attending = ' . $replyStatus;
		}
		
		$result =& $this->retrieveRange(
			$sql. ' ' . $searchSql . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''), 
			(int) $reviewerId, $rangeInfo );
			
		$returner = new DAOResultFactory($result, $this, '_returnMeetingFromRow');
		return $returner;
	}
	
	
	function getMeetingReportByReviewerId($reviewerId, $dateFrom=null, $dateTo=null)  {
		$sql = 
			'SELECT * 
			FROM meetings a INNER JOIN meeting_attendance b
			ON a.meeting_id = b.meeting_id WHERE b.user_id= ?';
		
		$searchSql = '';
		
		if (!empty($dateFrom) || !empty($dateTo)) {
			if (!empty($dateFrom)) {
				$searchSql .= ' AND meeting_date >= ' . $this->datetimeToDB($dateFrom);
			}
			if (!empty($dateTo)) {
				$searchSql .= ' AND meeting_date <= ' . $this->datetimeToDB($dateTo);
			}
		}
		if(!empty($status)) {
			$searchSql .= ' AND status = ' . $status;
		}
		if(!empty($replyStatus)) {
			$searchSql .= ' AND attending = ' . $replyStatus;
		}
		
		$result =& $this->retrieveRange(
			$sql. ' ' . $searchSql .  ' ORDER BY ' .$this->getSortMapping('meetingDate') . ' ' .$this->getDirectionMapping(SORT_DIRECTION_ASC), 
			(int) $reviewerId, $rangeInfo );
		
		$meetingsReturner = new DBRowIterator($result);

		return array($meetingsReturner);
	}
	/**
	 * Get meeting by meetingId and reviewerId
	 * Added by ayveemallare 7/6/2011
	 * 
	 * @param int $meetingId
	 * @param int $reviewerId
	 */
	function &getMeetingByMeetingAndUserId($meetingId, $reviewerId) {
		$meeting = null;
		$result =& $this->retrieve(
			'SELECT * 
			FROM meetings a INNER JOIN meeting_attendance b
			ON a.meeting_id = b.meeting_id WHERE a.meeting_id = ? AND b.user_id= ?',
			array((int) $meetingId, (int) $reviewerId));
		
		$meeting =& $this->_returnMeetingFromRow($result->GetRowAssoc(false));
		
		$result->Close();
		unset($result);

		return $meeting;
	}

	
	/**
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return Meeting
	 * Last upadte: EL on February 25th 2013. 
	 */
	function &_returnMeetingFromRow(&$row) {
		$meeting = new Meeting();
		if (isset($row['meeting_id'])) $meeting->setId($row['meeting_id']);
		if (isset($row['meeting_date'])) $meeting->setDate($row['meeting_date']);
			if (isset($row['meeting_length'])) $meeting->setLength($row['meeting_length']);
			if (isset($row['location'])) $meeting->setLocation($row['location']);
			if (isset($row['investigator'])) $meeting->setInvestigator($row['investigator']);
		if (isset($row['section_id'])) $meeting->setUploader($row['section_id']);
		if (isset($row['minutes_status'])) $meeting->setMinutesStatus($row['minutes_status']);
		//Added additional fields
		//Edited by ayveemallare 7/6/2011
		if (isset($row['user_id'])) $meeting->setUserId($row['user_id']);
		if (isset($row['attending'])) $meeting->setIsAttending($row['attending']);
		if (isset($row['remarks'])) $meeting->setRemarks($row['remarks']);
		if (isset($row['status'])) $meeting->setStatus($row['status']);
		if (isset($row['present'])) $meeting->setIsPresent($row['present']);
		if (isset($row['reason_for_absence'])) $meeting->setReasonForAbsence($row['reason_for_absence']);
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

	function insertMeeting($sectionId, $meetingDate = null, $meetingLength = null, $location = null, $investigator = 0, $status = 0) {
		$this->update(
			sprintf('INSERT INTO meetings (meeting_date, meeting_length, location, investigator, section_id, minutes_status) VALUES (%s, ?, ?, ?, ?, ?)',
			$this->datetimeToDB($meetingDate)),
			array($meetingLength, $location, $investigator, $sectionId, $status)
		);		
	}
	
	function &createMeeting($sectionId, $meetingDate = null, $meetingLength = null, $location = null, $investigator = 0, $status = 0) {
		$this->insertMeeting($sectionId, $meetingDate, $meetingLength, $location, $investigator, $status);
				
		$meetingId = 0;
		$result =& $this->retrieve(
			'SELECT max(meeting_id) as meeting_id, meeting_date, meeting_length, location, investigator, section_id, minutes_status FROM meetings WHERE section_id = ? GROUP BY meeting_id ORDER BY meeting_id DESC LIMIT 1;',
			(int) $sectionId
		);
		$row = $result->GetRowAssoc(false);
		$meetingId = $row['meeting_id'];
						
		$result->Close();
		unset($result);

		return $meetingId;
	}
	
	function updateMeeting($meeting) {
		$this->update(
			sprintf('UPDATE meetings SET meeting_date = %s, meeting_length = ?, location = ?, investigator = ? where meeting_id = ?',$this->datetimeToDB($meeting->getDate())),
			array($meeting->getLength(), $meeting->getLocation(), $meeting->getInvestigator(), $meeting->getId())
		);				
	}
	
	/**
	 * Okay na. Update minutes_status
	 * @param Meeting $meeting
	 */
	function updateMinutesStatus($meeting) {
		$this->update(
			'UPDATE meetings SET minutes_status = ? where meeting_id = ?',
			array($meeting->getMinutesStatus(), $meeting->getId())
		);
	}
	
	function getSortMapping($heading) {
		switch ($heading) {
			case 'id': return 'a.meeting_id';
			case 'meetingDate': return 'meeting_date';
			case 'meetingLength': return 'meeting_length';
			case 'replyStatus': return 'attending';
			case 'scheduleStatus': return 'status';
			default: return null;
		}
	}
	
	/**
	 * Update meeting/schedule status
	 * Added by MSB July 7, 2011
	 * Edited by ayveemallare 7/7/2011
	 * Edited by EL on February 26th 2013
	 */
	
	function updateStatus($meetingId, $status){
		$this->update(
			'UPDATE meetings SET status = ? where meeting_id = ?',
			array($status, $meetingId)
		);
	} 
	
	function cancelMeeting($meetingId){
		$this->update(
			'DELETE a,b,c FROM meetings AS a
			 LEFT JOIN meeting_submissions AS b ON (b.meeting_id = a.meeting_id)
			 LEFT JOIN meeting_attendance AS c ON (c.meeting_id = b.meeting_id)
			 WHERE c.meeting_id = ?',
			(int) $meetingId
		);
	}

	/**
	 * Get meetings object by submission ID
	 * @param $submissionId int
	 * @return Meeting
	 * Added by EL on March 13th 2013
	 */
	function &getMeetingsBySubmissionId($submissionId) {
		
		$meetings = array();
		
		$sql = 'SELECT m.* 
				FROM meetings m
					LEFT JOIN meeting_submissions ms ON (ms.meeting_id =  m.meeting_id)
				WHERE ms.submission_id = ? ORDER BY m.meeting_date';
		
		$result =& $this->retrieveRange($sql, (int) $submissionId);

		while (!$result->EOF) {
			$row = $result->GetRowAssoc(false);
			$meetings[] = $this->_returnMeetingFromRow($row);
			$result->moveNext();
		}
							
		return $meetings;
	}
	
	/**
	 * Count the number of previous meetings for the specific section
	 * Used for the generation of the meeting public id
	 * @param $ercId int
	 * @param $meetingId int
	 * Added by EL on April 2013
	 */
	 function countPreviousMeetingsOfERC($ercId, $meetingId) {
		$result =& $this->retrieve(
			'SELECT COUNT(*) FROM meetings WHERE section_id = ? AND meeting_id < ?', array($ercId, $meetingId)
		);
		$returner = isset($result->fields[0])? $result->fields[0] + 1 : 0;

		$result->Close();
		unset($result);
		return $returner;
	 }		
}

?>
