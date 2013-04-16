<?php

/**
 * @file classes/meeting/MinutesFileDAO.inc.php
 *
 * @class MinutesFileDAO
 * @ingroup meeting
 * @see MinutesFile
 *
 * @brief Operations for retrieving and modifying MinutesFile objects.
 */

// $Id$

import('classes.meeting.MinutesFile');

define('INLINEABLE_TYPES_FILE', Config::getVar('general', 'registry_dir') . DIRECTORY_SEPARATOR . 'inlineTypes.txt');

class MinutesFileDAO extends DAO {
	/**
	 * Array of MIME types that can be displayed inline in a browser
	 */
	var $inlineableTypes;

	/**
	 * Retrieve a minutes file by ID.
	 * @param $fileId int
	 * @param $meetingId int optional
	 * @return MinutesFile
	 */
	function &getMinutesFile($fileId, $meetingId = null) {
		
		if ($fileId === null) return null;
		
		$params = array($fileId);
		if ($meetingId) $params[] = $meetingId;
		
		$result =& $this->retrieve(
			'SELECT * FROM minutes_files WHERE file_id = ?' 
			. ($meetingId?' AND meeting_id = ?':''), 
			$params
		);


		$returner = null;
		if (isset($result) && $result->RecordCount() != 0) {
			$returner =& $this->_returnMinutesFileFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Retrieve all minutes files for a meeting.
	 * @param $meetingId int
	 * @return array MinutesFiles
	 */
	function &getMinutesFilesByMeetingId($meetingId) {
		$minutesFiles = array();

		$result =& $this->retrieve(
			'SELECT * FROM minutes_files WHERE meeting_id = ?',
			$meetingId
		);

		while (!$result->EOF) {
			$minutesFiles[] =& $this->_returnMinutesFileFromRow($result->GetRowAssoc(false));
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $minutesFiles;
	}


	/**
	 * Internal function to return an MinutesFile object from a row.
	 * @param $row array
	 * @return MinutesFile
	 */
	function &_returnMinutesFileFromRow(&$row) {
		$minutesFile = new MinutesFile();
		$minutesFile->setFileId($row['file_id']);
		$minutesFile->setMeetingId($row['meeting_id']);
		$minutesFile->setFileName($row['file_name']);
		$minutesFile->setOriginalFileName($row['original_file_name']);
		$minutesFile->setFileType($row['file_type']);
		$minutesFile->setFileSize($row['file_size']);
		$minutesFile->setType($row['type']);
		$minutesFile->setArticleId($row['article_id']);
		$minutesFile->setDateCreated($row['date_created']);
		HookRegistry::call('MinutesFileDAO::_returnMinutesFileFromRow', array(&$minutesFile, &$row));
		return $minutesFile;
	}

	/**
	 * Insert a new MinutesFile.
	 * @param $minutesFile MinutesFile
	 * @return int
	 */
	function insertMinutesFile(&$minutesFile) {
		$fileId = $minutesFile->getFileId();
		$params = array(
			(int) $minutesFile->getMeetingId(),
			(string) $minutesFile->getFileName(),
			(string) $minutesFile->getOriginalFileName(),
			(string) $minutesFile->getFileType(),
			(int) $minutesFile->getFileSize(),
			(string) $minutesFile->getType(),
			(int) $minutesFile->getArticleId()
		);

		if ($fileId) {
			array_unshift($params, $fileId);
		}

		$this->update(
			sprintf('INSERT INTO minutes_files
				(' . ($fileId ? 'file_id, ' : '') . 'meeting_id, file_name, original_file_name, file_type, file_size, type, article_id, date_created)
				VALUES
				(' . ($fileId ? '?, ' : '') . '?, ?, ?, ?, ?, ?, ?, %s)',
				$this->datetimeToDB($minutesFile->getDateCreated())),
			$params
		);

		if (!$fileId) {
			$minutesFile->setFileId($this->getInsertMinutesFileId());
		}

		return $minutesFile->getFileId();
	}

	/**
	 * Update an existing minutes file.
	 * @param $minutesFile MinutesFile
	 */
	function updateMinutesFile(&$minutesFile) {
		$this->update(
			sprintf('UPDATE minutes_files
				SET
					meeting_id = ?,
					file_name = ?,
					original_file_name = ?,
					file_type = ?,
					file_size = ?,
					type = ?,
					article_id = ?,
					date_created = %s
				WHERE file_id = ?',
				$this->datetimeToDB($minutesFile->getDateCreated())),
			array(
				(int) $minutesFile->getMeetingId(),
				(string) $minutesFile->getFileName(),
				(string) $minutesFile->getOriginalFileName(),
				(string) $minutesFile->getFileType(),
				(int) $minutesFile->getFileSize(),
				(string) $minutesFile->getType(),
				(int) $minutesFile->getArticleId(),
				$minutesFile->getFileId()
			)
		);	
		
		return $minutesFile->getFileId();
	}

	/**
	 * Delete a minutes file.
	 * @param $minutesFile MinutesFile
	 */
	function deleteMinutesFile(&$minutesFile) {
		return $this->deleteMinutesFileById($minutesFile->getFileId());
	}

	/**
	 * Delete a minutes file by ID.
	 * @param $minutesFileId int
	 */
	function deleteMinutesFileById($minutesFileId) {
		return $this->update('DELETE FROM minutes_files WHERE file_id = ?', $minutesFileId);
	}

	/**
	 * Delete all minutes files for a meeting.
	 * @param $meetingId int
	 */
	function deleteMeetingFiles($meetingId) {
		return $this->update('DELETE FROM minutes_files WHERE meeting_id = ?', $meetingId);
	}

	/**
	 * Get the ID of the last inserted minutes file.
	 * @return int
	 */
	function getInsertMinutesFileId() {
		return $this->getInsertId('minutes_files', 'file_id');
	}

	/**
	 * Check whether a file may be displayed inline.
	 * @param $minutesFile object
	 * @return boolean
	 */
	function isInlineable(&$minutesFile) {
		if (!isset($this->inlineableTypes)) {
			$this->inlineableTypes = array_filter(file(INLINEABLE_TYPES_FILE), create_function('&$a', 'return ($a = trim($a)) && !empty($a) && $a[0] != \'#\';'));
		}
		return in_array($minutesFile->getFileType(), $this->inlineableTypes);
	}
	
	/**
	 * Get a generated minutes file by meeting id, type and article id
	 */
	function getGeneratedMinutesFile($meetingId, $type, $articleId = null){
		
		$params = array($meetingId, $type);
		if ($articleId) $params[] = $articleId;
				
		$result =& $this->retrieve(
			'SELECT * FROM minutes_files WHERE original_file_name = "" AND meeting_id = ? AND type = ?' 
			. ($articleId?' AND article_id = ?':''), 
			$params
		);

		$returner = null;
		if (isset($result) && $result->RecordCount() != 0) {
			$returner =& $this->_returnMinutesFileFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;		
	}

	/**
	 * Get uploaded minutes files by meeting id, type and article id
	 */
	function getUploadedMinutesFiles($meetingId, $type, $articleId = null){
		
		$minutesFiles = array();
		
		$params = array($meetingId, $type);
		if ($articleId) $params[] = $articleId;
				
		$result =& $this->retrieve(
			'SELECT * FROM minutes_files WHERE original_file_name <> "" AND meeting_id = ? AND type = ?' 
			. ($articleId?' AND article_id = ?':''), 
			$params
		);

		while (!$result->EOF) {
			$minutesFiles[] =& $this->_returnMinutesFileFromRow($result->GetRowAssoc(false));
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $minutesFiles;		
	}

	function getUploadedFileIterator($meetingId, $type, $articleId = null){

		$params = array($meetingId, $type);
		if ($articleId) $params[] = $articleId;
				
		$result =& $this->retrieve(
			'SELECT file_name FROM minutes_files WHERE original_file_name <> "" AND meeting_id = ? AND type = ? '. ($articleId?' AND article_id = ?':'') .' ORDER BY file_id DESC LIMIT 1', $params
		);

		if (isset($result->fields[0])) {
			$array = explode(".", $result->fields[0]);
			return ((int)$array[5])+1;
		} else return 1;
	}
}

?>
