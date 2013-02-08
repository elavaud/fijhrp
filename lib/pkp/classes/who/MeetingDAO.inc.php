<?php

import('lib.pkp.classes.who.Meeting');
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
	function &getMeetingsOfUser($userId, $sortBy = null, $rangeInfo = null, $sortDirection = SORT_DIRECTION_ASC, 
		$status=null, $minutesStatus=null, $dateFrom=null, $dateTo=null) {
		$sql = 'SELECT meeting_id, meeting_date, user_id, minutes_status, status FROM meetings as a WHERE user_id = ?';
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
			(int) $userId, $rangeInfo
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
			'SELECT meeting_id, user_id, meeting_date, minutes_status, status FROM meetings WHERE meeting_id = ?',
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
			FROM meetings a INNER JOIN meeting_reviewers b
			ON a.meeting_id = b.meeting_id WHERE b.reviewer_id= ?';
		
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
			FROM meetings a INNER JOIN meeting_reviewers b
			ON a.meeting_id = b.meeting_id WHERE b.reviewer_id= ?';
		
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
	function &getMeetingByMeetingAndReviewerId($meetingId, $reviewerId) {
		$meeting = null;
		$result =& $this->retrieve(
			'SELECT * 
			FROM meetings a INNER JOIN meeting_reviewers b
			ON a.meeting_id = b.meeting_id WHERE a.meeting_id = ? AND b.reviewer_id= ?',
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
	 */
	function &_returnMeetingFromRow(&$row) {
		$meeting = new Meeting();
		$meeting->setId($row['meeting_id']);
		$meeting->setDate($row['meeting_date']);
		$meeting->setUploader($row['user_id']);
		$meeting->setMinutesStatus($row['minutes_status']);
		//Added additional fields
		//Edited by ayveemallare 7/6/2011
		$meeting->setReviewerId($row['reviewer_id']);
		$meeting->setIsAttending($row['attending']);
		$meeting->setRemarks($row['remarks']);
		$meeting->setStatus($row['status']);
		$meeting->setIsPresent($row['present']);
		$meeting->setReasonForAbsence($row['reason_for_absence']);
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
			sprintf('INSERT INTO meetings (meeting_date, user_id, minutes_status) VALUES (%s, ?, ?)',
			$this->datetimeToDB($meetingDate)),
			array($userId, $status)
		);		
	}
	
	function &createMeeting($userId, $meetingDate = null, $status = 0) {
		$this->insertMeeting($userId, $meetingDate, $status);
				
		$meetingId = 0;
		$result =& $this->retrieve(
			'SELECT max(meeting_id) as meeting_id, meeting_date, user_id, minutes_status FROM meetings WHERE user_id = ? GROUP BY meeting_id ORDER BY meeting_id DESC LIMIT 1;',
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
			case 'replyStatus': return 'attending';
			case 'scheduleStatus': return 'status';
			default: return null;
		}
	}
	
	/**
	 * Update meeting/schedule status
	 * Added by MSB July 7, 2011
	 * Edited by ayveemallare 7/7/2011
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
			 LEFT JOIN meeting_reviewers AS c ON (c.meeting_id = b.meeting_id)
			 WHERE c.meeting_id = ?',
			(int) $meetingId
		);
	}
		
}

?>
