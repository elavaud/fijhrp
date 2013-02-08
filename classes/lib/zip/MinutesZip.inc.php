<?php

import('classes.lib.zip.zip');
import('lib.pkp.classes.file.FileManager');

class MinutesZip extends Zip {

	var $filename;
	var $meetingsDir;
	var $filesDir;
	var $archivesDir;
	
	function MinutesZip($journalId, $meetingId, $section = null) {
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);		
		
		$this->filename = $meetingId."-".date("d-F-Y-gia", strtotime($meeting->getDate()));
		$this->meetingsDir = Config::getVar('files', 'files_dir') . '/journals/' . $journalId .'/meetings/';
		$this->filesDir = $this->meetingsDir.$meetingId.'/';
		$this->archivesDir = $this->meetingsDir."archives/";
		if($section != null) {
			$this->filesDir = $this->filesDir.$section."/";
			$this->filename = $this->filename."-initialReviews";
		}		
	}
	
	function test() {
		echo "directory to archive=". $this->filesDir."<br/>";
		echo "filename=". $this->filename."<br/>";
		echo "archive in directory=" . $this->archivesDir."<br/>" ;
	}
	
	function export() {
		
		$this->compress($this->filesDir, $this->filename, $this->archivesDir);
	}
}

?>