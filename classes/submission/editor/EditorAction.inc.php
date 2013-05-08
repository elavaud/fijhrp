<?php

/**
 * @file classes/submission/editor/EditorAction.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class EditorAction
 * @ingroup submission
 *
 * @brief EditorAction class.
 */

// $Id$


import('classes.submission.sectionEditor.SectionEditorAction');

class EditorAction extends SectionEditorAction {
	/**
	 * Actions.
	 */

	/**
	 * Rush a new submission into the end of the editing queue.
	 * @param $article object
	 */
	function expediteSubmission($article) {
		$user =& Request::getUser();

		import('classes.submission.editor.EditorAction');
		import('classes.submission.sectionEditor.SectionEditorAction');
		import('classes.submission.proofreader.ProofreaderAction');

		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$sectionEditorSubmission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($article->getId());

		$submissionFile = $sectionEditorSubmission->getSubmissionFile();

		// Add a long entry before doing anything.
		import('classes.article.log.ArticleLog');
		import('classes.article.log.ArticleEventLogEntry');
		ArticleLog::logEvent($article->getId(), ARTICLE_LOG_EDITOR_EXPEDITE, ARTICLE_LOG_TYPE_EDITOR, $user->getId(), 'log.editor.submissionExpedited', array('editorName' => $user->getFullName(), 'articleId' => $article->getId()));

		// 1. Accept the submission and send to copyediting.
		$sectionEditorSubmission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($article->getId());
		if (!$sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL', true)) {
			SectionEditorAction::recordDecision($sectionEditorSubmission, SUBMISSION_SECTION_DECISION_APPROVED);
			$reviewFile = $sectionEditorSubmission->getReviewFile();
			SectionEditorAction::setCopyeditFile($sectionEditorSubmission, $reviewFile->getFileId());
		}

		// 2. Add a galley.
		$sectionEditorSubmission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($article->getId());
		$galleys =& $sectionEditorSubmission->getGalleys();
		if (empty($galleys)) {
			// No galley present -- use copyediting file.
			import('classes.file.ArticleFileManager');
			$copyeditFile =& $sectionEditorSubmission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL');
			$fileType = $copyeditFile->getFileType();
			$articleFileManager = new ArticleFileManager($article->getId());
			$fileId = $articleFileManager->copyPublicFile($copyeditFile->getFilePath(), $fileType);

			if (strstr($fileType, 'html')) {
				$galley = new ArticleHTMLGalley();
			} else {
				$galley = new ArticleGalley();
			}
			$galley->setArticleId($article->getId());
			$galley->setFileId($fileId);
			$galley->setLocale(Locale::getLocale());

			if ($galley->isHTMLGalley()) {
				$galley->setLabel('HTML');
			} else {
				if (strstr($fileType, 'pdf')) {
					$galley->setLabel('PDF');
				} else if (strstr($fileType, 'postscript')) {
					$galley->setLabel('Postscript');
				} else if (strstr($fileType, 'xml')) {
					$galley->setLabel('XML');
				} else {
					$galley->setLabel(Locale::translate('common.untitled'));
				}
			}

			$galleyDao =& DAORegistry::getDAO('ArticleGalleyDAO');
			$galleyDao->insertGalley($galley);
		}

		$sectionEditorSubmission->setStatus(STATUS_QUEUED);
		$sectionEditorSubmissionDao->updateSectionEditorSubmission($sectionEditorSubmission);
	}
}

?>
