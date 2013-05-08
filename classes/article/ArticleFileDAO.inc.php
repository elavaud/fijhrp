<?php

/**
 * @file classes/articleArticleFileDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ArticleFileDAO
 * @ingroup article
 * @see ArticleFile
 *
 * @brief Operations for retrieving and modifying ArticleFile objects.
 */

// $Id$


import('classes.article.ArticleFile');

define('INLINEABLE_TYPES_FILE', Config::getVar('general', 'registry_dir') . DIRECTORY_SEPARATOR . 'inlineTypes.txt');

class ArticleFileDAO extends DAO {
	/**
	 * Array of MIME types that can be displayed inline in a browser
	 */
	var $inlineableTypes;

	/**
	 * Retrieve an article by ID.
	 * @param $fileId int
	 * @param $articleId int optional
	 * @return ArticleFile
	 */
	function &getArticleFile($fileId, $articleId = null) {
		if ($fileId === null) {
			$returner = null;
			return $returner;
		}
		
		if ($articleId != null) {
			$result =& $this->retrieveLimit(
				'SELECT a.* FROM article_files a WHERE file_id = ? AND article_id = ?',
				array($fileId, $articleId),
				1
			);
		} else {
			$result =& $this->retrieveLimit(
				'SELECT a.* FROM article_files a WHERE file_id = ?',
				$fileId,
				1
			);
		}

		$returner = null;
		if (isset($result) && $result->RecordCount() != 0) {
			$returner =& $this->_returnArticleFileFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Retrieve all previous main files for an article.
	 * @param $articleId int
	 * @return array SuppFiles
	 */
	function &getPreviousFilesByArticleId($articleId) {
		$previousFiles = array();

		$result =& $this->retrieve(
			'SELECT * FROM article_files WHERE article_id = ? AND source_file_id IS NOT NULL ORDER BY date_modified DESC',
			$articleId
		);

		while (!$result->EOF) {
			$previousFiles[] =& $this->_returnArticleFileFromRow($result->GetRowAssoc(false));
			$result->moveNext();
		}

		$result->Close();
		unset($result);
		return $previousFiles;
	}

	/**
	 * Retrieve all article files for an article.
	 * @param $articleId int
	 * @return array ArticleFiles
	 */
	function &getArticleFilesByArticle($articleId) {
		$articleFiles = array();

		$result =& $this->retrieve(
			'SELECT * FROM article_files WHERE article_id = ?',
			$articleId
		);

		while (!$result->EOF) {
			$articleFiles[] =& $this->_returnArticleFileFromRow($result->GetRowAssoc(false));
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $articleFiles;
	}

	/**
	 * Retrieve all article files for a type and assoc ID.
	 * @param $assocId int
	 * @param $type int
	 * @return array ArticleFiles
	 */
	function &getArticleFilesByAssocId($assocId, $type) {
		import('classes.file.ArticleFileManager');
		$articleFiles = array();

		$result =& $this->retrieve(
			'SELECT * FROM article_files WHERE assoc_id = ? AND type = ?',
			array($assocId, ArticleFileManager::typeToPath($type))
		);

		while (!$result->EOF) {
			$articleFiles[] =& $this->_returnArticleFileFromRow($result->GetRowAssoc(false));
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $articleFiles;
	}

	/**
	 * Internal function to return an ArticleFile object from a row.
	 * @param $row array
	 * @return ArticleFile
	 */
	function &_returnArticleFileFromRow(&$row) {
		$articleFile = new ArticleFile();
		$articleFile->setFileId($row['file_id']);
		$articleFile->setSourceFileId($row['source_file_id']);
		$articleFile->setArticleId($row['article_id']);
		$articleFile->setFileName($row['file_name']);
		$articleFile->setFileType($row['file_type']);
		$articleFile->setFileSize($row['file_size']);
		$articleFile->setOriginalFileName($row['original_file_name']);
		$articleFile->setType($row['type']);
		$articleFile->setAssocId($row['assoc_id']);
		$articleFile->setDateUploaded($this->datetimeFromDB($row['date_uploaded']));
		$articleFile->setDateModified($this->datetimeFromDB($row['date_modified']));
		$articleFile->setViewable($row['viewable']);
		HookRegistry::call('ArticleFileDAO::_returnArticleFileFromRow', array(&$articleFile, &$row));
		return $articleFile;
	}

	/**
	 * Insert a new ArticleFile.
	 * @param $articleFile ArticleFile
	 * @return int
	 */
	function insertArticleFile(&$articleFile) {
		$fileId = $articleFile->getFileId();
		$params = array(
			(int) $articleFile->getArticleId(),
			$articleFile->getSourceFileId()?$articleFile->getSourceFileId():null,
			$articleFile->getFileName(),
			$articleFile->getFileType(),
			$articleFile->getFileSize(),
			$articleFile->getOriginalFileName(),
			$articleFile->getType(),
			$articleFile->getViewable(),
			$articleFile->getAssocId()
		);

		if ($fileId) {
			array_unshift($params, $fileId);
		}

		$this->update(
			sprintf('INSERT INTO article_files
				(' . ($fileId ? 'file_id, ' : '') . 'article_id, source_file_id, file_name, file_type, file_size, original_file_name, type, date_uploaded, date_modified, viewable, assoc_id)
				VALUES
				(' . ($fileId ? '?, ' : '') . '?, ?, ?, ?, ?, ?, ?, %s, %s, ?, ?)',
				$this->datetimeToDB($articleFile->getDateUploaded()), $this->datetimeToDB($articleFile->getDateModified())),
			$params
		);

		if (!$fileId) {
			$articleFile->setFileId($this->getInsertArticleFileId());
		}

		return $articleFile->getFileId();
	}

	/**
	 * Update an existing article file.
	 * @param $article ArticleFile
	 */
	function updateArticleFile(&$articleFile) {
		$this->update(
			sprintf('UPDATE article_files
				SET
					article_id = ?,
					source_file_id = ?,
					file_name = ?,
					file_type = ?,
					file_size = ?,
					original_file_name = ?,
					type = ?,
					date_uploaded = %s,
					date_modified = %s,
					viewable = ?,
					assoc_id = ?
				WHERE file_id = ?',
				$this->datetimeToDB($articleFile->getDateUploaded()), $this->datetimeToDB($articleFile->getDateModified())),
			array(
				(int) $articleFile->getArticleId(),
				$articleFile->getSourceFileId()?$articleFile->getSourceFileId():null,
				$articleFile->getFileName(),
				$articleFile->getFileType(),
				$articleFile->getFileSize(),
				$articleFile->getOriginalFileName(),
				$articleFile->getType(),
				$articleFile->getViewable(),
				$articleFile->getAssocId(),
				$articleFile->getFileId()
			)
		);

		return $articleFile->getFileId();

	}

	/**
	 * Delete an article file.
	 * @param $article ArticleFile
	 */
	function deleteArticleFile(&$articleFile) {
		return $this->deleteArticleFileById($articleFile->getFileId());
	}

	/**
	 * Delete an article file by ID.
	 * @param $articleId int
	 */
	function deleteArticleFileById($fileId) {
		return $this->update(
			'DELETE FROM article_files WHERE file_id = ?', $fileId
		);
	}

	/**
	 * Delete all article files for an article.
	 * @param $articleId int
	 */
	function deleteArticleFiles($articleId) {
		return $this->update(
			'DELETE FROM article_files WHERE article_id = ?', $articleId
		);
	}

	/**
	 * Get the ID of the last inserted article file.
	 * @return int
	 */
	function getInsertArticleFileId() {
		return $this->getInsertId('article_files', 'file_id');
	}

	/**
	 * Check whether a file may be displayed inline.
	 * @param $articleFile object
	 * @return boolean
	 */
	function isInlineable(&$articleFile) {
		if (!isset($this->inlineableTypes)) {
			$this->inlineableTypes = array_filter(file(INLINEABLE_TYPES_FILE), create_function('&$a', 'return ($a = trim($a)) && !empty($a) && $a[0] != \'#\';'));
		}
		return in_array($articleFile->getFileType(), $this->inlineableTypes);
	}


    /**
	 * Delete an article file by source file ID.
	 * @param $articleId int
	**/
	function deleteArticleFileBySourceFileId($sourceFileId) {
	    return $this->update(
	            'DELETE FROM article_files WHERE source_file_id = ?', $sourceFileId
	    );
	}
}

?>
