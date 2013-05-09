<?php

/**
 * @file classes/file/ArticleFileManager.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ArticleFileManager
 * @ingroup file
 *
 * @brief Class defining operations for article file management.
 *
 * Article directory structure:
 * [article id]/note
 * [article id]/public
 * [article id]/submission
 * [article id]/submission/original
 * [article id]/submission/review
 * [article id]/submission/editor
 * [article id]/submission/copyedit
 * [article id]/submission/layout
 * [article id]/supp
 * [article id]/attachment
 */


import('lib.pkp.classes.file.FileManager');

/* File type suffixes */
define('ARTICLE_FILE_SUBMISSION',	'MainProposal');
define('ARTICLE_FILE_REVIEW',		'ReviewFile');
define('ARTICLE_FILE_EDITOR',		'Editor');
define('ARTICLE_FILE_COPYEDIT',		'CopyEdit');
define('ARTICLE_FILE_LAYOUT',		'Layout');
define('ARTICLE_FILE_PUBLIC',		'PublicFile');
define('ARTICLE_FILE_SUPP',			'SupplementaryFile');
define('ARTICLE_FILE_NOTE',			'FileNote');
define('ARTICLE_FILE_ATTACHMENT',	'Attachment');

class ArticleFileManager extends FileManager {

	/** @var string the path to location of the files */
	var $filesDir;

	/** @var int the ID of the associated article */
	var $articleId;

	/** @var Article the associated article */
	var $article;

	/**
	 * Constructor.
	 * Create a manager for handling article file uploads.
	 * @param $articleId int
	 */
	function ArticleFileManager($articleId) {
		$this->articleId = $articleId;
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$this->article =& $articleDao->getArticle($articleId);
		$journalId = $this->article->getJournalId();
		$this->filesDir = Config::getVar('files', 'files_dir') .
		'articles/' . $articleId . '/';
	}

	/**
	 * Upload a submission file.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is false if failure
	 */
	function uploadSubmissionFile($fileName, $fileId = null) {
        return $this->handleUpload($fileName, ARTICLE_FILE_SUBMISSION, null, $fileId);
	}

	/**
	 * Upload a file to the review file folder.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is false if failure
	 */
	function uploadReviewFile($fileName, $assocId = null, $fileId = null) {		
		return $this->handleUpload($fileName, ARTICLE_FILE_REVIEW, $assocId, $fileId);
	}

	/**
	 * Upload a file to the editor decision file folder.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is false if failure
	 */
	function uploadEditorDecisionFile($fileName, $assocId, $fileId = null) {	
		return $this->handleUpload($fileName, ARTICLE_FILE_EDITOR, $assocId, $fileId, 1);
	}

	/**
	 * Upload a file to the copyedit file folder.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is false if failure
	 */
	function uploadCopyeditFile($fileName, $fileId = null) {	
		return $this->handleUpload($fileName, ARTICLE_FILE_COPYEDIT, null, $fileId);
	}

	/**
	 * Upload a section editor's layout editing file.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is null if failure
	 */
	function uploadLayoutFile($fileName, $fileId = null) {	
		return $this->handleUpload($fileName, ARTICLE_FILE_LAYOUT, null, $fileId);
	}

	/**
	 * Upload a supp file.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is false if failure
	 */
	function uploadSuppFile($fileName, $fileId = null) {	
		return $this->handleUpload($fileName, ARTICLE_FILE_SUPP, null, $fileId);
	}

	/**
	 * Upload a public file.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is false if failure
	 */
	function uploadPublicFile($fileName, $fileId = null) {	
		return $this->handleUpload($fileName, ARTICLE_FILE_PUBLIC, null, $fileId);
	}

	/**
	 * Upload a note file.
	 * @param $fileName string the name of the file used in the POST form
	 * @param $fileId int
	 * @return int file ID, is false if failure
	 */
	function uploadSubmissionNoteFile($fileName, $fileId = null) {	
		return $this->handleUpload($fileName, ARTICLE_FILE_NOTE, null, $fileId);
	}

	/**
	 * Write a public file.
	 * @param $fileName string The original filename
	 * @param $contents string The contents to be written to the file
	 * @param $mimeType string The mime type of the original file
	 * @param $fileId int
	 */
	function writePublicFile($fileName, &$contents, $mimeType, $fileId = null) {	
		return $this->handleWrite($fileName, $contents, $mimeType, ARTICLE_FILE_PUBLIC, $fileId);
	}

	/**
	 * Copy a public file.
	 * @param $url string The source URL/filename
	 * @param $mimeType string The mime type of the original file
	 * @param $fileId int
	 */
	function copyPublicFile($url, $mimeType, $fileId = null) {	
		return $this->handleCopy($url, $mimeType, ARTICLE_FILE_PUBLIC, $fileId);
	}

	/**
	 * Write a supplemental file.
	 * @param $fileName string The original filename
	 * @param $contents string The contents to be written to the file
	 * @param $mimeType string The mime type of the original file
	 * @param $fileId int
	 */
	function writeSuppFile($fileName, &$contents, $mimeType, $fileId = null) {
		return $this->handleWrite($fileName, $contents, $mimeType, ARTICLE_FILE_SUPP, $fileId);
	}

	/**
	 * Copy a supplemental file.
	 * @param $url string The source URL/filename
	 * @param $mimeType string The mime type of the original file
	 * @param $fileId int
	 */
	function copySuppFile($url, $mimeType, $fileId = null) {
		return $this->handleCopy($url, $mimeType, ARTICLE_FILE_SUPP, $fileId);
	}

	/**
	 * Copy an attachment file.
	 * @param $url string The source URL/filename
	 * @param $mimeType string The mime type of the original file
	 * @param $fileId int
	 */
	function copyAttachmentFile($url, $mimeType, $fileId = null, $assocId = null) {	
		return $this->handleCopy($url, $mimeType, ARTICLE_FILE_ATTACHMENT, $fileId, $assocId);
	}

	/**
	 * Retrieve file information by file ID.
	 * @return ArticleFile
	 */
	function &getFile($fileId) {
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$articleFile =& $articleFileDao->getArticleFile($fileId, $this->articleId);
		return $articleFile;
	}

	/**
	 * Read a file's contents.
	 * @param $output boolean output the file's contents instead of returning a string
	 * @return boolean
	 */
	function readFile($fileId, $output = false) {
		$articleFile =& $this->getFile($fileId);

		if (isset($articleFile)) {
			$fileType = $articleFile->getFileType();
			$filePath = $this->filesDir . $articleFile->getType() . '/' . $articleFile->getFileName();

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
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');

		$files = array();
		$file =& $articleFileDao->getArticleFile($fileId);
		if (isset($file)) {
			$files[] = $file;
		}

		foreach ($files as $f) {
			parent::deleteFile($this->filesDir . $f->getType() . '/' . $f->getFileName());
		}

		$articleFileDao->deleteArticleFileById($fileId);

		return count($files);
	}

	/**
	 * Delete the entire tree of files belonging to an article.
	 */
	function deleteArticleTree() {
		parent::rmtree($this->filesDir);
	}

	/**
	 * Download a file.
	 * @param $fileId int the file id of the file to download
	 * @param $inline print file as inline instead of attachment, optional
	 * @return boolean
	 */
	function downloadFile($fileId, $inline = false) {
		$articleFile =& $this->getFile($fileId);
		if (isset($articleFile)) {
			$fileType = $articleFile->getFileType();
			$filePath = $this->filesDir . $articleFile->getType() . '/' . $articleFile->getFileName();
			return parent::downloadFile($filePath, $fileType, $inline);
		} else {
			return false;
		}
	}

	/**
	 * View a file inline (variant of downloadFile).
	 * @see ArticleFileManager::downloadFile
	 */
	function viewFile($fileId) {
		$this->downloadFile($fileId, true);
	}

	/**
	 * Copies an existing file to create a review file.
	 * @param $originalFileId int the file id of the original file.
	 * @param $destFileId int the file id of the current review file
	 * @return int the file id of the new file.
	 */
	function copyToReviewFile($fileId, $destFileId = null) {	
        return $this->copyAndRenameFile($fileId, ARTICLE_FILE_REVIEW, $destFileId);
	}

	/**
	 * Copies an existing file to create an editor decision file.
	 * @param $fileId int the file id of the review file.
	 * @param $destFileId int file ID to copy to
	 * @return int the file id of the new file.
	 */
	function copyToEditorFile($fileId, $destFileId = null) {	
		return $this->copyAndRenameFile($fileId, ARTICLE_FILE_EDITOR, $destFileId);
	}

	/**
	 * Copies an existing file to create a copyedit file.
	 * @param $fileId int the file id of the editor file.
	 * @return int the file id of the new file.
	 */
	function copyToCopyeditFile($fileId) {
		return $this->copyAndRenameFile($fileId, ARTICLE_FILE_COPYEDIT);
	}

	/**
	 * Copies an existing file to create a layout file.
	 * @param $fileId int the file id of the copyedit file.
	 * @return int the file id of the new file.
	 */
	function copyToLayoutFile($fileId) {	
		return $this->copyAndRenameFile($fileId, ARTICLE_FILE_LAYOUT);
	}

	/**
	 * Return type path associated with a type code.
	 * @param $type string
	 * @return string
	 */
	function typeToPath($type) {
                /* This determines the directory path where the file will be saved.  This is also the "type" column in article_files */

            switch ($type) {
			case ARTICLE_FILE_PUBLIC: return 'public';
			case ARTICLE_FILE_SUPP: return 'supp';
			case ARTICLE_FILE_NOTE: return 'note';
			case ARTICLE_FILE_REVIEW: return 'submission/review';
			case ARTICLE_FILE_EDITOR: return 'submission/editor';
			case ARTICLE_FILE_COPYEDIT: return 'submission/copyedit';
			case ARTICLE_FILE_LAYOUT: return 'submission/layout';
			case ARTICLE_FILE_ATTACHMENT: return 'attachment';
			case ARTICLE_FILE_SUBMISSION: default: return 'submission/original';
		}
	}

	/**
	 * Added by MSB, Sept 29, 2011
	 * Return type code associated with the type path
	 * @param String $path
	 */
	function pathToType($path){
		switch ($path) {
			case "public": return ARTICLE_FILE_PUBLIC;
			case "supp": return ARTICLE_FILE_SUPP;
			case "note": return ARTICLE_FILE_NOTE;
			case "submission/review": return ARTICLE_FILE_REVIEW;
			case "submission/editor": return ARTICLE_FILE_EDITOR;
			case "submission/copyedit": return ARTICLE_FILE_COPYEDIT;
			case "submission/layout": return ARTICLE_FILE_LAYOUT;
			case "attachment": return ARTICLE_FILE_ATTACHMENT;
			case "submission/original": default: return ARTICLE_FILE_SUBMISSION;
		}
	}
	
	/**
	* Added by MSB, Sept 29, 2011
	* Rename an existing ArticleFile
	* @param fileId int
	* @param path string
	* @param suppFileCounter  int
	*/
	function renameFile($fileId, $path, $suppFileCounter){
		if (HookRegistry::call('ArticleFileManager::renameFile', array(&$fileId, &$path, $suppFileCounter, &$result))) return $result;
	
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
	
		$sourceDir = $this->filesDir . $path . "/";
		$sourceArticleFile = $articleFileDao->getArticleFile($fileId, $this->articleId);
	
		$type = $this->pathToType($path);
	
		if($type == ARTICLE_FILE_SUPP ){
			$suppFileCounter = $suppFileCounter + 1;
			$type = $type.$suppFileCounter;
		}
		
		
		$fileExtension = $this->parseFileExtension($sourceArticleFile->getFileName());
		
		$date = new DateTime($sourceArticleFile->getDateUploaded());
		$dateUploaded = $date->format('MdY-g:ia');
		
		$newFileName = $this->article->getLocalizedProposalId().".".$type.'.'.$dateUploaded.'.'.$fileExtension;

		//rename file
		rename($sourceDir.$sourceArticleFile->getFileName(), $sourceDir.$newFileName);
	
		$sourceArticleFile->setFileName($newFileName);
		$articleFileDao->updateArticleFile($sourceArticleFile);
		return $suppFileCounter;
	}
	
	/**
	 * Copies an existing ArticleFile and renames it.
	 * @param $sourceFileId int
	 * @param $destType string
	 * @param $destFileId int (optional)
	 */
	function copyAndRenameFile($sourceFileId, $destType, $destFileId = null) {
		if (HookRegistry::call('ArticleFileManager::copyAndRenameFile', array(&$sourceFileId, &$destType, &$destFileId, &$result))) return $result;

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$articleFile = new ArticleFile();

		$destTypePath = $this->typeToPath($destType);
		$destDir = $this->filesDir . $destTypePath . '/';

		$sourceArticleFile = $articleFileDao->getArticleFile($sourceFileId, $this->articleId);

		if (!isset($sourceArticleFile)) {
			return false;
		}

		$sourceDir = $this->filesDir . $sourceArticleFile->getType() . '/';

		if ($destFileId != null) {
			$articleFile->setFileId($destFileId);
		}
		$articleFile->setArticleId($this->articleId);
		$articleFile->setSourceFileId($sourceFileId);
		$articleFile->setFileName($sourceArticleFile->getFileName());
		$articleFile->setFileType($sourceArticleFile->getFileType());
		$articleFile->setFileSize($sourceArticleFile->getFileSize());
		$articleFile->setOriginalFileName($sourceArticleFile->getFileName());
		$articleFile->setType($destTypePath);
		$articleFile->setDateUploaded(Core::getCurrentDate());
		$articleFile->setDateModified(Core::getCurrentDate());

		$fileId = $articleFileDao->insertArticleFile($articleFile);
		
		// Rename the file.
		$fileExtension = $this->parseFileExtension($sourceArticleFile->getFileName());
		$newFileName = $this->articleId.'-'.$fileId.'-'.$destType.'.'.$fileExtension;
		if (!$this->fileExists($destDir, 'dir')) {
			// Try to create destination directory
			$this->mkdirtree($destDir);
		}

		copy($sourceDir.$sourceArticleFile->getFileName(), $destDir.$newFileName);
		
		$articleFile->setFileName($newFileName);
		$articleFileDao->updateArticleFile($articleFile);
		
		return $fileId;
	}

	/**
	 * PRIVATE routine to generate a dummy file. Used in handleUpload.
	 * @param $article object
	 * @return object articleFile
	 */
	function &generateDummyFile(&$article) {
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$articleFile = new ArticleFile();
		$articleFile->setArticleId($article->getId());
		$articleFile->setFileName('temp');
		$articleFile->setOriginalFileName('temp');
		$articleFile->setFileType('temp');
		$articleFile->setFileSize(0);
		$articleFile->setType('temp');
		$articleFile->setDateUploaded(Core::getCurrentDate());
		$articleFile->setDateModified(Core::getCurrentDate());

		$articleFile->setFileId($articleFileDao->insertArticleFile($articleFile));

		return $articleFile;
	}

	/**
	 * PRIVATE routine to generate a filename for an article file. Sets the filename
	 * field in the articleFile to the generated value.
	 * @param $articleFile The article to generate a filename for
	 * @param $type The type of the article (e.g. as supplied to handleUpload)
	 * @param $originalName The name of the original file
	 */
	function generateFilename(&$articleFile, $type, $originalName) {
		$extension = $this->parseFileExtension($originalName);
		/** Start edit, MSB Sept29, 2011
		 *  If proposalId is already created, use it in naming the file (proposalId.type
		.dateuploaded.extension)
		 *  Else, use the default naming scheme (articleId.fileId.type.extension)
		 **/
		$proposalId = $this->article->getLocalizedProposalId();
		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		 
		if($proposalId!=null || $proposalId!=''){
			
			$date = new DateTime($articleFile->getDateUploaded());
			$dateUploaded = $date->format('MdY-g:ia');
			$newFileName = $proposalId.'.'.$type.'.'.$dateUploaded.'.'.$extension;
			
		}else{
			$newFileName = $articleFile->getArticleId().'-'.$articleFile->getFileId().'-'.$type.'.'.$extension;
		}	
		/**
		 * End of edit, MSB
		 */
		$articleFile->setFileName($newFileName);
		return $newFileName;
	}

	/**
	 * PRIVATE routine to upload the file and add it to the database.
	 * @param $fileName string index into the $_FILES array
	 * @param $type string identifying type
	 * @param $fileId int ID of an existing file to update
	 * @return int the file ID (false if upload failed)
	 */
	function handleUpload($fileName, $type, $assocId = null, $fileId = null, $viewable = null) {
        
        if (HookRegistry::call('ArticleFileManager::handleUpload', array(&$fileName, &$type, &$assocId, &$fileId, &$viewable, &$result))) return $result;

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');

		$typePath = $this->typeToPath($type);
		$dir = $this->filesDir . $typePath . '/';

		if (!$fileId) {
			// Insert dummy file to generate file id FIXME?
			$dummyFile = true;
			$articleFile =& $this->generateDummyFile($this->article);
		} else {
			$dummyFile = false;
			$articleFile = new ArticleFile();
			$articleFile->setArticleId($this->articleId);
			$articleFile->setFileId($fileId);
			$articleFile->setDateUploaded(Core::getCurrentDate());
			$articleFile->setDateModified(Core::getCurrentDate());
		}
		
		if ($viewable) $articleFile->setViewable($viewable);
		$articleFile->setAssocId($assocId);
		$articleFile->setFileType($_FILES[$fileName]['type']);
		$articleFile->setFileSize($_FILES[$fileName]['size']);
		$articleFile->setOriginalFileName(ArticleFileManager::truncateFileName($_FILES[$fileName]['name'], 127));
		$articleFile->setType($typePath);
		$newFileName = $this->generateFilename($articleFile, $type, $this->getUploadedFileName($fileName));

		if (!$this->uploadFile($fileName, $dir.$newFileName)) {
			// Delete the dummy file we inserted
			$articleFileDao->deleteArticleFileById($articleFile->getFileId());

			return false;
		}

		if ($dummyFile) $articleFileDao->updateArticleFile($articleFile);
		else $articleFileDao->insertArticleFile($articleFile);
		return $articleFile->getFileId();
	}

	/**
	 * PRIVATE routine to write an article file and add it to the database.
	 * @param $fileName original filename of the file
	 * @param $contents string contents of the file to write
	 * @param $mimeType string the mime type of the file
	 * @param $type string identifying type
	 * @param $fileId int ID of an existing file to update
	 * @return int the file ID (false if upload failed)
	 */
	function handleWrite($fileName, &$contents, $mimeType, $type, $fileId = null) {
		if (HookRegistry::call('ArticleFileManager::handleWrite', array(&$fileName, &$contents, &$mimeType, &$fileId, &$result))) return $result;

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');

		$typePath = $this->typeToPath($type);
		$dir = $this->filesDir . $typePath . '/';

		if (!$fileId) {
			// Insert dummy file to generate file id FIXME?
			$dummyFile = true;
			$articleFile =& $this->generateDummyFile($this->article);
		} else {
			$dummyFile = false;
			$articleFile = new ArticleFile();
			$articleFile->setArticleId($this->articleId);
			$articleFile->setFileId($fileId);
			$articleFile->setDateUploaded(Core::getCurrentDate());
			$articleFile->setDateModified(Core::getCurrentDate());
		}

		$articleFile->setFileType($mimeType);
		$articleFile->setFileSize(strlen($contents));
		$articleFile->setOriginalFileName(ArticleFileManager::truncateFileName($fileName, 127));
		$articleFile->setType($typePath);
		$newFileName = $this->generateFilename($articleFile, $type, $fileName);

		if (!$this->writeFile($dir.$newFileName, $contents)) {
			// Delete the dummy file we inserted
			$articleFileDao->deleteArticleFileById($articleFile->getFileId());

			return false;
		}

		if ($dummyFile) $articleFileDao->updateArticleFile($articleFile);
		else $articleFileDao->insertArticleFile($articleFile);

		return $articleFile->getFileId();
	}

	/**
	 * PRIVATE routine to copy an article file and add it to the database.
	 * @param $url original filename/url of the file
	 * @param $mimeType string the mime type of the file
	 * @param $type string identifying type
	 * @param $fileId int ID of an existing file to update
	 * @return int the file ID (false if upload failed)
	 */
	function handleCopy($url, $mimeType, $type, $fileId = null) {
		if (HookRegistry::call('ArticleFileManager::handleCopy', array(&$url, &$mimeType, &$type, &$fileId, &$result))) return $result;

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');

		$typePath = $this->typeToPath($type);
		$dir = $this->filesDir . $typePath . '/';

		if (!$fileId) {
			// Insert dummy file to generate file id FIXME?
			$dummyFile = true;
			$articleFile =& $this->generateDummyFile($this->article);
		} else {
			$dummyFile = false;
			$articleFile = new ArticleFile();
			$articleFile->setArticleId($this->articleId);
			$articleFile->setFileId($fileId);
			$articleFile->setDateUploaded(Core::getCurrentDate());
			$articleFile->setDateModified(Core::getCurrentDate());
		}

		$articleFile->setFileType($mimeType);
		$articleFile->setOriginalFileName(ArticleFileManager::truncateFileName(basename($url), 127));
		$articleFile->setType($typePath);
		$newFileName = $this->generateFilename($articleFile, $type, $articleFile->getOriginalFileName());

		if (!$this->copyFile($url, $dir.$newFileName)) {
			// Delete the dummy file we inserted
			$articleFileDao->deleteArticleFileById($articleFile->getFileId());

			return false;
		}

		$articleFile->setFileSize(filesize($dir.$newFileName));

		if ($dummyFile) $articleFileDao->updateArticleFile($articleFile);
		else $articleFileDao->insertArticleFile($articleFile);

		return $articleFile->getFileId();
	}

	/**
	 * Copy a temporary file to an article file.
	 * @param TemporaryFile
	 * @return int the file ID (false if upload failed)
	 */
	function temporaryFileToArticleFile(&$temporaryFile, $type, $assocId = null) {
		if (HookRegistry::call('ArticleFileManager::temporaryFileToArticleFile', array(&$temporaryFile, &$type, &$assocId, &$result))) return $result;

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');

		$typePath = $this->typeToPath($type);
		$dir = $this->filesDir . $typePath . '/';

		$articleFile =& $this->generateDummyFile($this->article);
		$articleFile->setFileType($temporaryFile->getFileType());
		$articleFile->setOriginalFileName($temporaryFile->getOriginalFileName());
		$articleFile->setType($typePath);
		$articleFile->setAssocId($assocId);

		$newFileName = $this->generateFilename($articleFile, $type, $articleFile->getOriginalFileName());

		if (!$this->copyFile($temporaryFile->getFilePath(), $dir.$newFileName)) {
			// Delete the dummy file we inserted
			$articleFileDao->deleteArticleFileById($articleFile->getFileId());

			return false;
		}

		$articleFile->setFileSize(filesize($dir.$newFileName));
		$articleFileDao->updateArticleFile($articleFile);

		return $articleFile->getFileId();
	}
}

?>
