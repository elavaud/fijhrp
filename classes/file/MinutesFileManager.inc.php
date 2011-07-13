<?php
import('classes.file.PublicFileManager');

class MinutesFileManager extends PublicFileManager {
	/**
	 * Write a file to a journals's public directory.
	 * @param $journalId int
	 * @param $destFileName string the destination file name
	 * @param $contents string the contents to write to the file
	 * @return boolean
	 */
 	function writeJournalFile($journalId, $destFileName, &$contents) {
 		return $this->writeFile($this->getJournalFilesPath($journalId) . '/' . $destFileName, $contents);
 	}
}

?>
