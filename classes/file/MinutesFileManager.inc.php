<?php

/**
 * @file classes/file/MinutesFileManager.inc.php
 * 
 **/

import('lib.pkp.classes.file.FileManager');


class MinutesFileManager extends FileManager {
	
	/** @var string the path to location of the files */
	var $filesDir;

	/** @var string the name of the file */
	var $filename;
	
	/** @var int the ID of the associated meeting */
	var $meetingId;

	/** @var Meeting the associated meeting */
	var $meeting;
	
	/** @var int the ID of the associated journal */
	var $journalId;
	
	/**
	 * Constructor.
	 * Create a manager for handling article file uploads.
	 * @param $articleId int
	 */
	function MinutesFileManager($meetingId) {
		$this->meetingId = $meetingId;
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		$meetingId = $this->meeting->getId();
		$meeting =& $this->meeting;
		
		$journal =& Request::getJournal();
		$this->journalId = $journal->getId();
		
		$this->filename = $meetingId."-".date("FjY-gia", strtotime($meeting->getDate()));
		$this->filesDir = Config::getVar('files', 'files_dir') . '/journals/' . $this->journalId .
		'/meetings/';
	}
	
	/**
	 * Download a file.
	 * @param $fileId int the file id of the file to download
	 * @param $inline print file as inline instead of attachment, optional
	 * @return boolean
	 */
	function downloadFile($inline = false) {
	    $filePath = $this->filesDir . $this->filename;
		$fileType = "application/pdf";	
		return parent::downloadFile($filePath, $fileType, $inline);
	}

	/**
	 * View a file inline (variant of downloadFile).
	 * @see ArticleFileManager::downloadFile
	 */
	function viewFile($inline) {
		$this->downloadFile(true);
	}
	
}



?>
