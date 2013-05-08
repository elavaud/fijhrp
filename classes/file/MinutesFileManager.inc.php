<?php

/**
 * @file classes/file/MinutesFileManager.inc.php
 * 
 **/

define('MINUTES_FILE_ATTENDANCE', 1);
define('MINUTES_FILE_INIT_REVIEW', 2);
define('MINUTES_FILE_CONT_REVIEW', 3);
define('MINUTES_FILE_PROT_AMEND', 4);
define('MINUTES_FILE_SAE', 5);
define('MINUTES_FILE_END_OF_STUDY', 6);

import('lib.pkp.classes.file.FileManager');


class MinutesFileManager extends FileManager {

	/** @var string the path to location of the files */
	var $filesDir;

	/** @var int the ID of the associated meeting */
	var $meetingId;

	/** @var meeting the associated meeting */
	var $meeting;

	/**
	 * Constructor.
	 * Create a manager for handling minutes file uploads.
	 * @param $meetingId int
	 */
	function MinutesFileManager($meetingId) {
		$this->meetingId = $meetingId;
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		$this->filesDir = Config::getVar('files', 'files_dir') .
		'/meetings/' . $meetingId . '/';
	}

	/**
	 * Retrieve file information by file ID.
	 * @return MinutesFile
	 */
	function &getFile($fileId) {
		$minutesFileDao =& DAORegistry::getDAO('MinutesFileDAO');
		$minutesFile =& $minutesFileDao->getMinutesFile($fileId, $this->meetingId);
		return $minutesFile;
	}

	/**
	 * Read a file's contents.
	 * @param $output boolean output the file's contents instead of returning a string
	 * @return boolean
	 */
	function readFile($fileId, $output = false) {
		$minutesFile =& $this->getFile($fileId);

		if (isset($minutesFile)) {
			$filePath = $this->filesDir . $minutesFile->getType() . '/' . $minutesFile->getFileName();
			return parent::readFile($filePath, $output);
		} else {
			return false;
		}
	}

	/**
	 * Delete a file by ID.
	 * @param $fileId int
	 * @return int number of files removed
	 */
	function deleteFile($fileId) {
		$minutesFileDao =& DAORegistry::getDAO('MinutesFileDAO');
		
		$file =& $minutesFileDao->getMinutesFile($fileId);

		parent::deleteFile($this->filesDir . $file->getType() . '/' . $file->getFileName());

		return $minutesFileDao->deleteMinutesFileById($fileId);
	}

	/**
	 * Delete the entire tree of files belonging to a meeting.
	 */
	function deleteMeetingTree() {
		parent::rmtree($this->filesDir);
	}

	/**
	 * Download a file.
	 * @param $fileId int the file id of the file to download
	 * @param $inline print file as inline instead of attachment, optional
	 * @return boolean
	 */
	function downloadFile($fileId, $inline = false) {
		$minutesFile =& $this->getFile($fileId);
		if (isset($minutesFile)) {
			$fileType = $minutesFile->getFileType();
			$filePath = $this->filesDir . $minutesFile->getType() . '/' . $minutesFile->getFileName();

			return parent::downloadFile($filePath, $fileType, $inline);

		} else {
			return false;
		}
	}

	/**
	 * View a file inline (variant of downloadFile).
	 * @see MinutesFileManager::downloadFile
	 */
	function viewFile($fileId) {
		$this->downloadFile($fileId, true);
	}

	/**
	 * Return type path associated with a type code.
	 * @param $type string
	 * @return string
	 */
	function typeToPath($type) {
                /* This determines the directory path where the file will be saved.  This is also the "type" column in minutes_files */
            switch ($type) {
			case MINUTES_FILE_ATTENDANCE: return 'attendance';
			case MINUTES_FILE_INIT_REVIEW: return 'initial_review';
			case MINUTES_FILE_CONT_REVIEW: return 'continuing_review';
			case MINUTES_FILE_PROT_AMEND: return 'protocol_amendment';
			case MINUTES_FILE_SAE: return 'serious_adverse_event';
			case MINUTES_FILE_END_OF_STUDY: return 'end_of_study';
		}
	}

	/**
	 * Return type code associated with the type path
	 * @param String $path
	 */
	function pathToType($path){
		switch ($path) {
			case "attendance": return MINUTES_FILE_ATTENDANCE;
			case "initial_review": return MINUTES_FILE_INIT_REVIEW;
			case "continuing_review": return MINUTES_FILE_CONT_REVIEW;
			case "protocol_amendment": return MINUTES_FILE_PROT_AMEND;
			case "serious_adverse_event": return MINUTES_FILE_SAE;
			case "end_of_study": return MINUTES_FILE_END_OF_STUDY;
		}
	}

	/**
	 * PRIVATE routine to generate a dummy file. Used in handleUpload.
	 * @param $meeting object
	 * @return object minutesFile
	 */
	function &generateDummyFile(&$meeting) {
		$minutesFileDao =& DAORegistry::getDAO('MinutesFileDAO');
		$minutesFile = new MinutesFile();
		$minutesFile->setMeetingId($meeting->getId());
		$minutesFile->setFileName('temp');
		$minutesFile->setOriginalFileName('temp');
		$minutesFile->setFileType('temp');
		$minutesFile->setFileSize(0);
		$minutesFile->setType('temp');
		$minutesFile->setDateCreated(Core::getCurrentDate());


		$minutesFile->setFileId($minutesFileDao->insertMinutesFile($minutesFile));

		return $minutesFile;
	}


	/**
	 * PRIVATE routine to generate a filename for a minutes file. Sets the filename
	 * field in the minutesFile to the generated value.
	 * @param $minutesFile The minutes file to generate a filename for
	 * @param $type The type of the minutes file (e.g. as supplied to handleUpload)
	 * @param $originalName The name of the original file
	 */
	function generateFilename(&$minutesFile, $typePath, $originalName, $articleId = null) {

		$minutesFileDao =& DAORegistry::getDAO('MinutesFileDAO');
	
		$extension = $this->parseFileExtension($originalName);
		
		$metingPublicId = $this->meeting->getPublicId();
		$date = new DateTime($this->meeting->getDate());
		$dateCreated = $date->format('dMY');
		
		if ($minutesFile->getOriginalFileName() != null) $newFileName = $metingPublicId.'.'.$date->format('dMY').'.'.$typePath.'.upload.'.$minutesFileDao->getUploadedFileIterator($this->meeting->getId(), $typePath, $articleId).'.'.$extension;
		else $newFileName = $metingPublicId.'.'.$date->format('dMY').'.'.$typePath.'.'.$extension;	
		
		$minutesFile->setFileName($newFileName);
		return $newFileName;
	}

	/**
	 * PRIVATE routine to upload the file and add it to the database.
	 * @param $fileName string index into the $_FILES array
	 * @param $type string identifying type
	 * @param $fileId int ID of an existing file to update
	 * @return int the file ID (false if upload failed)
	 */
	function handleUpload($fileName, $type, $fileId = null) {
        
        if (HookRegistry::call('MinutesFileManager::handleUpload', array(&$fileName, &$type, &$fileId, &$result))) return $result;

		$minutesFileDao =& DAORegistry::getDAO('MinutesFileDAO');

		$typePath = $this->typeToPath($type);
		$dir = $this->filesDir . $typePath . '/';

		if (!$fileId) {
			// Insert dummy file to generate file id FIXME?
			$dummyFile = true;
			$minutesFile =& $this->generateDummyFile($this->meeting);
		} else {
			$dummyFile = false;
			$minutesFile = new MinutesFile();
			$minutesFile->setMeetingId($this->meetingId);
			$minutesFile->setFileId($fileId);
			$minutesFile->setDateCreated(Core::getCurrentDate());
		}

		$minutesFile->setFileType($_FILES[$fileName]['type']);
		$minutesFile->setFileSize($_FILES[$fileName]['size']);
		$minutesFile->setOriginalFileName(MinutesFileManager::truncateFileName($_FILES[$fileName]['name'], 127));
		$minutesFile->setType($typePath);
		
		$newFileName = $this->generateFilename($minutesFile, $typePath, $this->getUploadedFileName($fileName));

		if (!$this->uploadFile($fileName, $dir.$newFileName)) {
			// Delete the dummy file we inserted
			$minutesFileDao->deleteMinutesFileById($minutesFile->getFileId());

			return false;
		}

		if ($dummyFile) $minutesFileDao->updateMinutesFile($minutesFile);
		else $minutesFileDao->insertMinutesFile($minutesFile);

		return $minutesFile->getFileId();
	}

	/**
	 * PRIVATE routine to write a minutes file and add it to the database.
	 * @param $fileName original filename of the file
	 * @param $contents string contents of the file to write
	 * @param $mimeType string the mime type of the file
	 * @param $type string identifying type
	 * @param $fileId int ID of an existing file to update
	 * @return int the file ID (false if upload failed)
	 */
	function handleWrite(&$pdf, $type, $fileId = null) {
		if (HookRegistry::call('MinutesFileManager::handleWrite', array(&$contents, &$fileId, &$result))) return $result;
		

		$minutesFileDao =& DAORegistry::getDAO('MinutesFileDAO');
		$typePath = $this->typeToPath($type);
		$dir = $this->filesDir . $typePath . '/';
		if (!$fileId) {
			$minutesFile =& $minutesFileDao->getGeneratedMinutesFile($this->meeting->getId(), $typePath);
			if (!$minutesFile) $minutesFile =& $this->generateDummyFile($this->meeting);	
			
			$dummyFile = true;
		
		} else {
			$dummyFile = false;
			$minutesFile = new MinutesFile();
			$minutesFile->setMeetingId($this->meetingId);
			$minutesFile->setFileId($fileId);
		}
		
		$minutesFile->setFileType('application/pdf');
		$minutesFile->setOriginalFileName(null);
		$minutesFile->setType($typePath);
		$minutesFile->setDateCreated(Core::getCurrentDate());
		
		$newFileName = $this->generateFilename($minutesFile, $typePath, '.pdf');
		
		if (!FileManager::fileExists($dir, 'dir')) FileManager::mkdirtree($dir);

		if($pdf->Output($dir.$newFileName,"F") != '') {
			$minutesFileDao->deleteMinutesFileById($minutesFile->getFileId());
			return false;	
		} else $minutesFile->setFileSize(filesize($dir.$newFileName));

		if ($dummyFile) $minutesFileDao->updateMinutesFile($minutesFile);
		else $minutesFileDao->insertMinutesFile($minutesFile);

		return $minutesFile->getFileId();
	}
}
?>
