<?php

import('lib.pkp.classes.who.MeetingSubmission');

class MeetingSubmissionDAO extends DAO {

	
	function MeetingSubmissionDAO() {
		parent::DAO();
	}
	
	/**
	 * Get meeting Submission object
	 * @param $meetingId int
	 * @param $SubmissionId int
	 * @return MeetingSubmission
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


	/**
	 * Internal function to return an meeting object from a row. Simplified
	 * not to include object settings.
	 * @param $row array
	 * @return MeetingSubmission
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
	 * Update data object
	 * @param MeetingSubmission $meetingSubmission
	 */
	function deleteMeetingSubmission($meetingId, $submissionId) {
		return $this->update(
			'DELETE FROM meeting_submissions WHERE meeting_id = ? AND submissions_id = ?', 
			array(
			$meetingSubmission->getMeetingId(),
			$meetingSubmission->getSubmissionId()
			)
		);
	}
	

}