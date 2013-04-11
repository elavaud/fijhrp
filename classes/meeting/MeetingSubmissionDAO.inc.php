<?php

/**
 * Last update on February 2013
 * EL
**/

import('classes.meeting.MeetingSubmission');

class MeetingSubmissionDAO extends DAO {

	
	function MeetingSubmissionDAO() {
		parent::DAO();
	}
	
	/**
	 * Get MeetingSubmission object
	 * @param $meetingId int
	 * @param $submissionId int
	 * @return array
	 */
	function &getMeetingSubmissionsByMeetingId($meetingId) {
		$meetingSubmissions = array();
		$result =& $this->retrieve(
			'SELECT meeting_id, submission_id FROM meeting_submissions WHERE meeting_id = ?',
			(int) $meetingId
		);
		
		while (!$result->EOF) {
			$meetingSubmissions[] =& $this->_returnMeetingSubmissionFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}
		
		
		$result->Close();
		unset($result);

		return $meetingSubmissions;
	}
	
	/* Added by MSB
	 * Last updated: 07/06/11
	 * Delete all submissions in a meeting
	 */

	function deleteMeetingSubmissionsByMeetingId($meetingId){
		return $this->update(
			'DELETE FROM meeting_submissions WHERE meeting_id = ?',
			(int) $meetingId
		);
	}

	/**
	 * Return the submission_id
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return submission_id
	 */
	function &_returnMeetingSubmissionFromRow(&$row) {
		//$meetingSubmission = new MeetingSubmission();
		//$meetingSubmission->setMeetingId($row['meeting_id']);
		//$meetingSubmission->setSubmissionId($row['submission_id']);
		//HookRegistry::call('MeetingSubmissionDAO::_returnMeetingSubmissionFromRow', array(&$meetingSubmission, &$row));
		return $row['submission_id'];
	}
	
	/**
	 * Get a new data object
	 * @return DataObject
	 */
	function newDataObject() {
		assert(false); // Should be overridden by child classes
	}
	
	/** 
	 * Insert new submission for the meeting discussion
	 * Insert a new data object
	 * @param int $meetingId
	 * @param int $SubmissionId
	 */
	function insertMeetingSubmission($meetingId, $submissionId) {
		$this->update (
			'INSERT INTO meeting_submissions
			(meeting_id, submission_id)
			VALUES (?, ?)',
			array($meetingId, $submissionId)
		);
	}
	
	/**
	 * Remove submission from meeting discussion
	 * Update a data object
	 * @param int $meetingId 
	 * @param int $submissionId
	 */
	function deleteMeetingSubmission($meetingId, $submissionId) {
		return $this->update(
			'DELETE FROM meeting_submissions WHERE meeting_id = ? AND submission_id = ?',
			array(
			$meetingSubmission->getMeetingId(),
			$meetingSubmission->getSubmissionId())
		);
	}
	
}
