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
	function MinutesFileManager($meetingId, $dirNode = null, $articleId = null) {
		$this->meetingId = $meetingId;
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		$meetingId = $this->meeting->getId();
		$meeting =& $this->meeting;
		
		$journal =& Request::getJournal();
		$this->journalId = $journal->getId();
		
		$this->filename = $meetingId."-".date("FjY-gia", strtotime($meeting->getDate()));
		$this->filesDir = Config::getVar('files', 'files_dir') . '/journals/' . $this->journalId .
		'/meetings/'.$meetingId.'/';
		if($dirNode != null) {
			$this->filesDir = $this->filesDir."/".$dirNode."/"; 
		}
		if($articleId != null) {
			$this->filename = $this->filename."-".$articleId; 
		}
	}
	
	/**
	 * Download a file.
	 * @param $fileId int the file id of the file to download
	 * @param $inline print file as inline instead of attachment, optional
	 * @return boolean
	 */
	function downloadFile($inline = false, $section = null, $articleId = null) {
		if($section=="attendance")
			$filename = $this->filename."-". $section;
		else if ($articleId != null)
			$filename = $this->filename."-". $articleId;
		else
			$filename = $this->filename;
		if($section=="initialReviews")
			$filesDir = $this->filesDir."/initialReviews/";
		else 
			$filesDir = $this->filesDir;
		$filePath = $filesDir . $filename;
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
	
	/**
	 * Write a file.
	 * @param $dest string the path where the file is to be saved
	 * @param $contents string the contents to write to the file
	 * @return boolean returns true if successful
	 */
	function createDirectory() {
		if (!FileManager::fileExists($this->filesDir, 'dir')) {
			return FileManager::mkdirtree($this->filesDir);
		}
		return true;
	}	
	
}



?>
