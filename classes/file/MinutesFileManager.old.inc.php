<?php

/**
 * @file classes/file/MinutesFileManager.inc.php
 * 
 **/

define('MINUTES_FILE_ATTENDANCE', 1);
define('MINUTES_FILE_INIT_REVIEW', 2);
define('MINUTES_FILE_CONT_REVIEW', 3);
define('MINUTES_FILE_PROT_AMENDMENT', 4);
define('MINUTES_FILE_SAE', 5);
define('MINUTES_FILE_END_OF_STUDY', 6);

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
		
		$this->filename = $meetingId."-".date("d-F-Y-gia", strtotime($meeting->getDate()));
		$this->filesDir = Config::getVar('files', 'files_dir') .'/meetings/'.$meetingId.'/';
		if($dirNode != null) {
			$this->filesDir = $this->filesDir.$dirNode."/"; 
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
	 * Check if directory exists and create one if it doesn't exist
	 * aglet 7/25/2011
	 * @return boolean returns true if successful
	 */
	function createDirectory() {
		if (!FileManager::fileExists($this->filesDir, 'dir')) {
			return FileManager::mkdirtree($this->filesDir);
		}
		return true;
	}
	
	/**
	 * Create meetings/archives directory if it doesn't exist, create zip archive of meetings/$meetingId if it doesn't exist then download archive
	 */
	function downloadMinutesArchive() {
		$archiveDir = Config::getVar('files', 'files_dir') . '/journals/' .$this->journalId.'/meetings/archives/';
		if(!FileManager::fileExists($archiveDir, 'dir')) {
			FileManager::mkdirtree($archiveDir);
		}
		if(!FileManager::fileExists($archiveDir.$this->filename.".zip")) { 
			import('classes.lib.zip.MinutesZip');
			$zip = new MinutesZip($this->journalId, $this->meetingId);
	//		$zip->test();
			$zip->export();
		}		
		$filePath = $archiveDir.$this->filename.".zip";
		$fileType = "application/zip";
		return parent::downloadFile($filePath, $fileType, false);		
	}	

	
	function uploadReview($filename, $articleId) {
		if ($_FILES[$filename]['size'] > 0 && $_FILES[$filename]['tmp_name'] != null && $this->createDirectory() && $articleId!=null) {
			$filesDir = $this->filesDir;
			$name = $_FILES[$filename]['name'];
			$targetFile =  $filesDir.$name;
			if($this->uploadFile($filename, $targetFile)) {
				return $name;
			}
		}
		return null;
	}
	 
}
?>
