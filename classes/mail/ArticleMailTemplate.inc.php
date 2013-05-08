<?php

/**
 * @file classes/mail/ArticleMailTemplate.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ArticleMailTemplate
 * @ingroup mail
 *
 * @brief Subclass of MailTemplate for sending emails related to articles.
 *
 * This allows for article-specific functionality like logging, etc.
 */

// $Id$


import('classes.mail.MailTemplate');
import('classes.article.log.ArticleEmailLogEntry'); // Bring in log constants

class ArticleMailTemplate extends MailTemplate {

	/** @var object the associated article */
	var $article;

	/** @var object the associated journal */
	var $journal;

	/** @var int Event type of this email */
	var $eventType;

	/** @var int Associated type of this email */
	var $assocType;

	/** @var int Associated ID of this email */
	var $assocId;

	/**
	 * Constructor.
	 * @param $article object
	 * @param $emailType string optional
	 * @param $locale string optional
	 * @param $enableAttachments boolean optional
	 * @param $journal object optional
	 * @param $includeSignature boolean optional
	 * @param $ignorePostedData boolean optional
	 * @see MailTemplate::MailTemplate()
	 */
	function ArticleMailTemplate($article, $emailKey = null, $locale = null, $enableAttachments = null, $journal = null, $includeSignature = true, $ignorePostedData = false) {
		parent::MailTemplate($emailKey, $locale, $enableAttachments, $journal, $includeSignature, $ignorePostedData);
		$this->article = $article;
	}

	function assignParams($paramArray = array()) {
		$article =& $this->article;
		$journal = isset($this->journal)?$this->journal:Request::getJournal();
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section =& $sectionDao->getSection($article->getSectionId());
		$abstract =& $article->getLocalizedAbstract();
		$paramArray['articleTitle'] = strip_tags($abstract->getScientificTitle());
		$paramArray['articleId'] = $article->getProposalId(Locale::getLocale());
		$paramArray['journalName'] = strip_tags($journal->getLocalizedTitle());
		$paramArray['sectionName'] = strip_tags($section->getLocalizedTitle());
		$paramArray['articleBackground'] = String::html2text($abstract->getBackground());
		$paramArray['articleObjectives'] = String::html2text($abstract->getObjectives());
		$paramArray['articleStudyMethods'] = String::html2text($abstract->getStudyMethods());
		$paramArray['articleExpectedOutcomes'] = String::html2text($abstract->getExpectedOutcomes());
		$paramArray['authorString'] = strip_tags($article->getAuthorString());
		parent::assignParams($paramArray);
	}

	/**
	 * @see parent::send()
	 */
	function send() {
		if (parent::send(false)) {
			if (!isset($this->skip) || !$this->skip) $this->log();
			$user =& Request::getUser();
			if ($this->attachmentsEnabled) $this->_clearAttachments($user->getId());
			return true;

		} else {
			return false;
		}
	}

	/**
	 * @see parent::sendWithParams()
	 */
	function sendWithParams($paramArray) {
		$savedSubject = $this->getSubject();
		$savedBody = $this->getBody();

		$this->assignParams($paramArray);

		$ret = $this->send();

		$this->setSubject($savedSubject);
		$this->setBody($savedBody);

		return $ret;
	}

	/**
	 * Add a generic association between this email and some event type / type / ID tuple.
	 * @param $eventType int
	 * @param $assocType int
	 * @param $assocId int
	 */
	function setAssoc($eventType, $assocType, $assocId) {
		$this->eventType = $eventType;
		$this->assocType = $assocType;
		$this->assocId = $assocId;
	}

	/**
	 * Set the journal this message is associated with.
	 * @param $journal object
	 */
	function setJournal($journal) {
		$this->journal = $journal;
	}

	/**
	 * Save the email in the article email log.
	 */
	function log() {
		import('classes.article.log.ArticleEmailLogEntry');
		import('classes.article.log.ArticleLog');
		$entry = new ArticleEmailLogEntry();
		$article =& $this->article;

		// Log data
		$entry->setEventType($this->eventType);
		$entry->setAssocType($this->assocType);
		$entry->setAssocId($this->assocId);

		// Email data
		$entry->setSubject($this->getSubject());
		$entry->setBody($this->getBody());
		$entry->setFrom($this->getFromString(false));
		$entry->setRecipients($this->getRecipientString());
		$entry->setCcs($this->getCcString());
		$entry->setBccs($this->getBccString());

		// Add log entry
		$logEntryId = ArticleLog::logEmailEntry($article->getId(), $entry);

		// Add attachments
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($article->getId());
		foreach ($this->getAttachmentFiles() as $attachment) {
			$articleFileManager->temporaryFileToArticleFile(
				$attachment,
				ARTICLE_FILE_ATTACHMENT,
				$logEntryId
			);
		}
	}

	function ccAssignedEditors($articleId) {
		$returner = array();
			// Removed by EL on February 17th 2013
			// No edit assignments anymore
			// Every section editors (erc secretaries) review and edit
			//$edit Assignment Dao =& DAORegistry::getDAO('Edit Assignment DAO');
			//$edit Assignments =& $edit Assignment Dao->getEditor AssignmentsByArticleId($articleId);
			//while ($edit Assignment =& $edit Assignments->next()) {
				//$this->addCc($edit Assignment->getEditorEmail(), $edit Assignment->getEditorFullName());
				//$returner[] =& $edit Assignment;
				//unset($edit Assignment);
			//}
			//$journal = isset($this->journal)?$this->journal:Request::getJournal();
			//$articleDao =& DAORegistry::getDAO('ArticleDAO');
			//$article =& $articleDao->getArticle($articleId);
			//$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
			//$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $article->getSectionId());
			//foreach ($sectionEditors as $sectionEditor){
			//	$this->addCc($sectionEditor->getEmail(), $sectionEditor->getFullName());
			//	$returner[] =& $sectionEditor;			
			//}
		return $returner;
	}

	function toAssignedReviewingSectionEditors($articleId) {
		$returner = array();
		$journal = isset($this->journal)?$this->journal:Request::getJournal();
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$article =& $articleDao->getArticle($articleId);
		$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
		$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $article->getSectionId());
		foreach ($sectionEditors as $sectionEditor){
			$this->addRecipient($sectionEditor->getEmail(), $sectionEditor->getFullName());
			$returner[] = $sectionEditor;			
		}
		return $returner;
	}

	function toAssignedEditingSectionEditors($articleId) {
		$returner = array();
		$journal = isset($this->journal)?$this->journal:Request::getJournal();
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$article =& $articleDao->getArticle($articleId);
		$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
		$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $article->getSectionId());
		foreach ($sectionEditors as $sectionEditor){
			$this->addRecipient($sectionEditor->getEmail(), $sectionEditor->getFullName());
			$returner[] =& $sectionEditor;			
		}
		return $returner;
	}

	function ccAssignedReviewingSectionEditors($articleId) {
		$returner = array();
		$journal = isset($this->journal)?$this->journal:Request::getJournal();
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$article =& $articleDao->getArticle($articleId);
		$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
		$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $article->getSectionId());
		foreach ($sectionEditors as $sectionEditor){
			$this->addCc($sectionEditor->getEmail(), $sectionEditor->getFullName());
			$returner[] =& $sectionEditor;			
		}
		return $returner;
	}

	function ccAssignedEditingSectionEditors($articleId) {
		$returner = array();
		$journal = isset($this->journal)?$this->journal:Request::getJournal();
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$article =& $articleDao->getArticle($articleId);
		$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
		$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $article->getSectionId());
		foreach ($sectionEditors as $sectionEditor){
			$this->addCc($sectionEditor->getEmail(), $sectionEditor->getFullName());
			$returner[] =& $sectionEditor;			
		}
		return $returner;
	}
}

?>
