<?php

/**
 * @file classes/submission/form/WithdrawForm.inc.php
 *
 * Copyright (c) 2003-2011 AIM
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class WithdrawForm
 * @ingroup submission_form
 *
 * @brief Supplementary file form.
 */

// $Id$


import('lib.pkp.classes.form.Form');

class WithdrawForm extends Form {
	/** @var int the ID of the supplementary file */
	var $suppFileId;

	/** @var Article current article */
	var $article;

	/** @var SuppFile current file */
	var $suppFile;

	/**
	 * Constructor.
	 * @param $article object
	 */
	function WithdrawForm($article, $journal) {
		$supportedSubmissionLocales = $journal->getSetting('supportedSubmissionLocales');
		if (empty($supportedSubmissionLocales)) $supportedSubmissionLocales = array($journal->getPrimaryLocale());
		parent::Form(
			'submission/suppFile/withdraw.tpl',
			true,
			$article->getLocale(),
			array_flip(array_intersect(
				array_flip(Locale::getAllLocales()),
				$supportedSubmissionLocales
			))
		);
		$this->article = $article;

                $this->addCheck(new FormValidatorLocale($this, 'withdrawReason', 'required', 'author.submit.form.withdrawReasonRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'otherReason', 'required', 'author.submit.form.otherReasonRequired', $this->getRequiredLocale()));
	}

	/**
	 * Get the default form locale.
	 * @return string
	 */
	function getDefaultFormLocale() {
		if ($this->article) return $this->article->getLocale();
		return parent::getDefaultFormLocale();
	}

	/**
	 * Get the names of fields for which data should be localized
	 * @return array
	 */
	function getLocaleFieldNames() {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		return $articleDao->getLocaleFieldNames();
	}

	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('rolePath', Request::getRequestedPage());
		$templateMgr->assign('articleId', $this->article->getArticleId());
		
                parent::display();
	}

	/**
	 * Validate the form
	 */
	function validate() {
                /**
		$journal =& Request::getJournal();
		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');

		$publicSuppFileId = $this->getData('publicSuppFileId');
		if ($publicSuppFileId && $suppFileDao->suppFileExistsByPublicId($publicSuppFileId, $this->suppFileId, $journal->getId())) {
			$this->addError('publicIssueId', Locale::translate('author.suppFile.suppFilePublicIdentificationExists'));
			$this->addErrorField('publicSuppFileId');
		}
                **/


		return parent::validate();
	}

	/**
	 * Initialize form data from current supplementary file (if applicable).
	 */
	function initData() {
            $this->_data = array(
                    'type' => $this->getData('type')
            );
                
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array(
				'type',
                                'withdrawReason',
                                'otherReason',
                                'withdrawComments'
			)
		);
	}

	/**
	 * Save changes to the supplementary file.
	 * @return int the supplementary file ID
	 */
	function execute($fileName = null) {
		import('classes.file.ArticleFileManager');
		$articleFileManager = new ArticleFileManager($this->article->getArticleId());
		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');

		$fileName = 'uploadSuppFile';
		
                // Upload file, if file selected.
                if ($articleFileManager->uploadedFileExists($fileName)) {
                	$fileId = $articleFileManager->uploadSuppFile($fileName);
                    import('classes.search.ArticleSearchIndex');
                    ArticleSearchIndex::updateFileIndex($this->article->getArticleId(), ARTICLE_SEARCH_SUPPLEMENTARY_FILE, $fileId);
                        
                    // Insert new supplementary file
                	$suppFile = new SuppFile();
                	$suppFile->setArticleId($this->article->getArticleId());
                	$suppFile->setFileId($fileId);
                	$this->setSuppFileData($suppFile);

                	$suppFileDao->insertSuppFile($suppFile);
                	$this->suppFileId = $suppFile->getId();
                } else {
                        $fileId = 0;
                }


                // Save article settings (withdrawReason and withdrawComments)
                $articleDao =& DAORegistry::getDAO('ArticleDAO');
                $article =& $this->article;
								
                $article->setWithdrawReason($this->getData('withdrawReason'), null);
                if ($article->getWithdrawReason('en_US') == "2") $article->setWithdrawReason($this->getData('otherReason'), null);
                $article->setWithdrawComments($this->getData('withdrawComments'), null);

                // Save the article
		$articleDao->updateArticle($article);

		return $this->suppFileId;

	}

	/**
	 * Assign form data to a SuppFile.
	 * @param $suppFile SuppFile
	 */
	function setSuppFileData(&$suppFile) {
            $suppFile->setType($this->getData('type'));
            $suppFile->setShowReviewers(1);
                
	}
}

?>
