<?php

/**
 * @file classes/meeting/MinutesFile.inc.php
 *
 * @class MinutesFile
 * @ingroup Meetings
 * @see MinutesFileDAO
 *
 * @brief Minutes file class.
 */

// $Id$


class MinutesFile extends DataObject {

	/**
	 * Constructor.
	 */
	function MinutesFile() {
		parent::DataObject();
	}

	/**
	 * Get ID of file.
	 * @return int
	 */
	function getFileId() {
		return $this->getData('fileId');
	}

	/**
	 * Set ID of file.
	 * @param $fileId int
	 */
	function setFileId($fileId) {
		return $this->setData('fileId', $fileId);
	}

	/**
	 * Get ID of the meeting.
	 * @return int
	 */
	function getMeetingId() {
		return $this->getData('meetingId');
	}

	/**
	 * Set ID of the meeting.
	 * @param $meetingId int
	 */
	function setMeetingId($meetingId) {
		return $this->setData('meetingId', $meetingId);
	}

	/**
	 * Get file name of the file.
	 * @param return string
	 */
	function getFileName() {
		return $this->getData('fileName');
	}

	/**
	 * Set file name of the file.
	 * @param $fileName string
	 */
	function setFileName($fileName) {
		return $this->setData('fileName', $fileName);
	}

	/**
	 * Get original uploaded file name of the file.
	 * @param return string
	 */
	function getOriginalFileName() {
		return $this->getData('originalFileName');
	}

	/**
	 * Set original uploaded file name of the file.
	 * @param $originalFileName string
	 */
	function setOriginalFileName($originalFileName) {
		return $this->setData('originalFileName', $originalFileName);
	}
	
	/**
	 * Get file type of the file.
	 * @ return string
	 */
	function getFileType() {
		return $this->getData('fileType');
	}

	/**
	 * Set file type of the file.
	 * @param $fileType string
	 */
	function setFileType($fileType) {
		return $this->setData('fileType', $fileType);
	}

	/**
	 * Get file size of file.
	 * @return int
	 */

	function getFileSize() {
		return $this->getData('fileSize');
	}

	/**
	 * Set file size of file.
	 * @param $fileSize int
	 */

	function setFileSize($fileSize) {
		return $this->SetData('fileSize', $fileSize);
	}

	/**
	 * Get type of the file.
	 * @ return int
	 */
	function getType() {
		return $this->getData('type');
	}

	/**
	 * Set type of the file.
	 * @param $type int
	 */
	function setType($type) {
		return $this->setData('type', $type);
	}

	/**
	 * Get article id associated (not applicable for "attendance" file).
	 * @ return int
	 */
	function getArticleId() {
		return $this->getData('articleId');
	}

	/**
	 * Set article id associated (not applicable for "attendance" file).
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		return $this->setData('articleId', $articleId);
	}
	
	/**
	 * Get the date the file has been created/uploaded
	 * @return date
	 */
	function getDateCreated() {
		return $this->getData('dateCreated');
	}

	/**
	 * Set the date the file has been created/uploaded
	 * @param $dateCreated date
	 */
	function setDateCreated($dateCreated) {
		return $this->SetData('dateCreated', $dateCreated);
	}

	/**
	 * Get nice file size of file.
	 * @return string
	 */

	function getNiceFileSize() {
		return FileManager::getNiceFileSize($this->getData('fileSize'));
	}
	
	/**
	 * Return absolute path to the file on the host filesystem.
	 * @return string
	 */
	function getFilePath() {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$article =& $articleDao->getArticle($this->getArticleId());
		$journalId = $article->getJournalId();

		return Config::getVar('files', 'files_dir') .
		'/meetings/' . $this->getArticleId() . '/' . $this->getType() . '/' . $this->getFileName();
	}


	/**
	 * Check if the file may be displayed inline.
	 * @return boolean
	 */
	function isInlineable() {
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		return $articleFileDao->isInlineable($this);
	}
}

?>
