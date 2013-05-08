<?php

/**
 * @file TrackSubmissionHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class TrackSubmissionHandler
 * @ingroup pages_author
 *
 * @brief Handle requests for submission tracking.
 */

// $Id$

import('pages.author.AuthorHandler');

class TrackSubmissionHandler extends AuthorHandler {
	/** submission associated with the request **/
	var $submission;

	/**
	 * Constructor
	 **/
	function TrackSubmissionHandler() {
		parent::AuthorHandler();
	}

	/**
	 * Delete a submission.
	 */
	function deleteSubmission($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$authorSubmission =& $this->submission;
		$this->setupTemplate(true);

		// If the submission is incomplete, allow the author to delete it.
		if ($authorSubmission->getSubmissionProgress()!=0 && !$authorSubmission->getDateSubmitted()) { 
			import('classes.file.ArticleFileManager');
			$articleFileManager = new ArticleFileManager($articleId);
			$articleFileManager->deleteArticleTree();

			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$articleDao->deleteArticleById($args[0]);

                        Request::redirect(null, null, 'index');
		}
        	if($authorSubmission->getProposalStatus() == PROPOSAL_STATUS_SUBMITTED) {
			import('classes.file.ArticleFileManager');
			$articleFileManager = new ArticleFileManager($articleId);
			$articleFileManager->deleteArticleTree();

			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$articleDao->deleteArticleById($args[0]);
		}
                
		Request::redirect(null, null, 'index');
	}

	/**
	 * Delete an author version file.
	 * @param $args array ($articleId, $fileId)
	 */
	function deleteArticleFile($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$fileId = isset($args[1]) ? (int) $args[1] : 0;

		$this->validate($articleId);
		$authorSubmission =& $this->submission;

		if ($authorSubmission->getStatus() != STATUS_PUBLISHED && $authorSubmission->getStatus() != STATUS_ARCHIVED) {
			AuthorAction::deleteArticleFile($authorSubmission, $fileId);
		}

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	/**
	 * Display a summary of the status of an author's submission.
	 */
	function submission($args) {
                
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$articleId = isset($args[0]) ? (int) $args[0] : 0;

		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(true, $articleId);

		$journalSettingsDao =& DAORegistry::getDAO('JournalSettingsDAO');
		$journalSettings = $journalSettingsDao->getJournalSettings($journal->getId());
                
		$templateMgr =& TemplateManager::getManager();

		$publishedArticleDao =& DAORegistry::getDAO('PublishedArticleDAO');
		$publishedArticle =& $publishedArticleDao->getPublishedArticleByArticleId($submission->getArticleId());
		if ($publishedArticle) {
			$issueDao =& DAORegistry::getDAO('IssueDAO');
			$issue =& $issueDao->getIssueById($publishedArticle->getIssueId());
			$templateMgr->assign_by_ref('issue', $issue);
		}

		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section =& $sectionDao->getSection($submission->getSectionId());
		$templateMgr->assign_by_ref('section', $section);

		$templateMgr->assign_by_ref('journalSettings', $journalSettings);
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('publishedArticle', $publishedArticle);
		$templateMgr->assign_by_ref('submissionFile', $submission->getSubmissionFile());
		$templateMgr->assign_by_ref('revisedFile', $submission->getRevisedFile());
		$templateMgr->assign_by_ref('suppFiles', $submission->getSuppFiles());

		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$templateMgr->assign_by_ref('suppFileDao', $suppFileDao);

		import('classes.submission.sectionEditor.SectionEditorSubmission');
		$templateMgr->assign_by_ref('editorDecisionOptions', SectionEditorSubmission::getEditorDecisionOptions());

		$templateMgr->assign('helpTopicId','editorial.authorsRole');

        if($submission->getSubmissionStatus()==PROPOSAL_STATUS_SUBMITTED) {
                $canEditMetadata = true;
                $canEditFiles = true;
        }
        else {
                $canEditMetadata = false;
                $canEditFiles = false;
        }
        $templateMgr->assign('canEditMetadata', $canEditMetadata);
        $templateMgr->assign('canEditFiles', $canEditFiles);
        $templateMgr->assign_by_ref('riskAssessment', $submission->getRiskAssessment());
        $templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());
                
		$templateMgr->display('author/submission.tpl');
                
	}

	/**
	 * Display specific details of an author's submission.
	 */
	function submissionReview($args) {
		$user =& Request::getUser();
		$articleId = isset($args[0]) ? (int) $args[0] : 0;

		$this->validate($articleId);
		$authorSubmission =& $this->submission;
		$this->setupTemplate(true, $articleId);
		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_EDITOR)); // editor.article.decision etc. FIXME?

		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$reviewFilesByDecision =& $reviewAssignmentDao->getReviewFilesByDecision($articleId);
		$authorViewableFilesByDecision =& $reviewAssignmentDao->getAuthorViewableFilesByDecision($articleId);

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign_by_ref('submission', $authorSubmission);
		$templateMgr->assign_by_ref('abstract', $authorSubmission->getLocalizedAbstract());
		$templateMgr->assign_by_ref('reviewFilesByDecision', $reviewFilesByDecision);
		$templateMgr->assign_by_ref('authorViewableFilesByDecision', $authorViewableFilesByDecision);

		$templateMgr->assign_by_ref('submissionFile', $authorSubmission->getSubmissionFile());
		$templateMgr->assign_by_ref('revisedFile', $authorSubmission->getRevisedFile());
		$templateMgr->assign_by_ref('suppFiles', $authorSubmission->getSuppFiles());
		import('classes.submission.sectionEditor.SectionEditorSubmission');
		$templateMgr->assign('editorDecisionOptions', SectionEditorSubmission::getEditorDecisionOptions());
		
		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');
		$meetingsAndAttendances =& $meetingAttendanceDao->getAttendancesByUserIdAndSubmissionId($user->getId(), $articleId);
		$templateMgr->assign('countMeetings', count($meetingsAndAttendances));
		$templateMgr->assign('meetingsAndAttendances', $meetingsAndAttendances);
		
		$templateMgr->assign('helpTopicId', 'editorial.authorsRole.review');
		$templateMgr->display('author/submissionReview.tpl');
	}

	/**
	 * Add a supplementary file.
	 * @param $args array ($articleId)
         *
         * Last Edit Jan 31 2012
	 */
	function addSuppFile($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		$authorSubmission =& $this->submission;

		//if ($authorSubmission->getStatus() != STATUS_PUBLISHED && $authorSubmission->getStatus() != STATUS_ARCHIVED) {
                if ($authorSubmission->getSubmissionStatus()==PROPOSAL_STATUS_SUBMITTED) {
			$this->setupTemplate(true, $articleId, 'summary');

			import('classes.submission.form.SuppFileForm');

			$submitForm = new SuppFileForm($authorSubmission, $journal);

                        //Added Jan 31 2012
                        $submitForm->setData('type', 'Supp File');

			if ($submitForm->isLocaleResubmit()) {
				$submitForm->readInputData();
			} else {
				$submitForm->initData();
			}
			$submitForm->display();
		} else {
			$request->redirect(null, null, 'submission', $articleId);
		}
	}

        /**
         * Added by AIM Jan 30 2012
         *
	 * Delete a supplementary file.
	 * @param $args array, the first parameter is the supplementary file to delete
	 */
	function deleteSuppFile($args) {
		import('classes.file.ArticleFileManager');

                $articleId = (int)Request::getUserVar('articleId');
		$suppFileId = isset($args[0]) ? (int) $args[0] : 0;
                //$this->validate($articleId, 4);
		$article =& $this->article;
		//$this->setupTemplate(true);

                $suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$suppFile = $suppFileDao->getSuppFile($suppFileId, $articleId);
		$suppFileDao->deleteSuppFileById($suppFileId, $articleId);

                if ($suppFile->getFileId()) {
			$articleFileManager = new ArticleFileManager($articleId);
			$articleFileManager->deleteFile($suppFile->getFileId());
		}

                Request::redirect(null, null, 'submission', $articleId);
	}


	/**
	 * Edit a supplementary file.
	 * @param $args array ($articleId, $suppFileId)
	 */
	function editSuppFile($args, &$request) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$suppFileId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);
		$authorSubmission =& $this->submission;

		if ($authorSubmission->getStatus() != STATUS_PUBLISHED && $authorSubmission->getStatus() != STATUS_ARCHIVED) {
			$this->setupTemplate(true, $articleId, 'summary');

			import('classes.submission.form.SuppFileForm');

			$journal =& $request->getJournal();
			$submitForm = new SuppFileForm($authorSubmission, $journal, $suppFileId);

			if ($submitForm->isLocaleResubmit()) {
				$submitForm->readInputData();
			} else {
				$submitForm->initData();
			}
			$submitForm->display();
		} else {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}

	/**
	 * Set reviewer visibility for a supplementary file.
	 * @param $args array ($suppFileId)
	 */
	function setSuppFileVisibility($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$authorSubmission =& $this->submission;

		if ($authorSubmission->getStatus() != STATUS_PUBLISHED && $authorSubmission->getStatus() != STATUS_ARCHIVED) {
			$suppFileId = Request::getUserVar('fileId');
			$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
			$suppFile = $suppFileDao->getSuppFile($suppFileId, $articleId);

			if (isset($suppFile) && $suppFile != null) {
				$suppFile->setShowReviewers(Request::getUserVar('hide')==1?0:1);
				$suppFileDao->updateSuppFile($suppFile);
			}
		}
		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	/**
	 * Save a supplementary file.
	 * @param $args array ($suppFileId)
	 */
	function saveSuppFile($args, &$request) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$authorSubmission =& $this->submission;
		$this->setupTemplate(true, $articleId, 'summary');
                
		if ($authorSubmission->getStatus() != STATUS_PUBLISHED && $authorSubmission->getStatus() != STATUS_ARCHIVED) {
			$suppFileId = isset($args[0]) ? (int) $args[0] : 0;

			import('classes.submission.form.SuppFileForm');

			$journal =& $request->getJournal();
			$submitForm = new SuppFileForm($authorSubmission, $journal, $suppFileId);
			$submitForm->readInputData();

			if ($submitForm->validate()) {
				$submitForm->execute();

                                if($submitForm->getData('type') == 'Completion Report') {
                                    Request::redirect(null, null, 'setAsCompleted', $articleId);
                                }
                                else {
                                    Request::redirect(null, null, 'submission', $articleId);
                                }
			} else {
				$submitForm->display();
			}
		} else {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}

        /**
	 * Save uploaded file, reason for withdrawal and comments.
	 * @param $args array
	 */
	function saveWithdrawal($args, &$request) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$authorSubmission =& $this->submission;
		$this->setupTemplate(true, $articleId, 'summary');


		import('classes.submission.form.WithdrawForm');

		$journal =& $request->getJournal();
		$withdrawForm = new WithdrawForm($authorSubmission, $journal);
		$withdrawForm->readInputData();

		if ($withdrawForm->validate()) {
                    $withdrawForm->execute();

                    Request::redirect(null, null, 'setAsWithdrawn', $articleId);
		} else {
                    $withdrawForm->display();
		}
	}


	/**
	 * Display the status and other details of an author's submission.
	 */
	function submissionEditing($args) {
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$articleId = isset($args[0]) ? (int) $args[0] : 0;

		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(true, $articleId);

		AuthorAction::copyeditUnderway($submission);
		import('classes.submission.proofreader.ProofreaderAction');
		ProofreaderAction::proofreadingUnderway($submission, 'SIGNOFF_PROOFREADING_AUTHOR');

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('copyeditor', $submission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL'));
		$templateMgr->assign_by_ref('submissionFile', $submission->getSubmissionFile());
		$templateMgr->assign_by_ref('initialCopyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL'));
		$templateMgr->assign_by_ref('editorAuthorCopyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_AUTHOR'));
		$templateMgr->assign_by_ref('finalCopyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_FINAL'));
		$templateMgr->assign_by_ref('suppFiles', $submission->getSuppFiles());
		$templateMgr->assign('useCopyeditors', $journal->getSetting('useCopyeditors'));
		$templateMgr->assign('useLayoutEditors', $journal->getSetting('useLayoutEditors'));
		$templateMgr->assign('useProofreaders', $journal->getSetting('useProofreaders'));
		$templateMgr->assign('helpTopicId', 'editorial.authorsRole.editing');
		$templateMgr->display('author/submissionEditing.tpl');
	}

	/**
	 * Upload the author's revised version of an article.
	 */
	function uploadRevisedVersion() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(true);

		AuthorAction::uploadRevisedVersion($submission);

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function viewMetadata($args, $request) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$journal =& $request->getJournal();
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(true, $articleId, 'summary');

		AuthorAction::viewMetadata($submission, $journal);
	}

	function saveMetadata($args, &$request) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(true, $articleId);

		// If the copy editor has completed copyediting, disallow
		// the author from changing the metadata.
                
		//$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		//$initialSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $submission->getArticleId());
		if (/*$initialSignoff->getDateCompleted() != null || */AuthorAction::saveMetadata($submission, $request)) {
 			$request->redirect(null, null, 'submission', $articleId);
 		}
                 
                 
	}

	/**
	 * Remove cover page from article
	 */
	function removeCoverPage($args) {
		$articleId = isset($args[0]) ? (int)$args[0] : 0;
		$formLocale = $args[1];
		$this->validate($articleId);
		$submission =& $this->submission;
		$journal =& Request::getJournal();

		import('classes.file.PublicFileManager');
		$publicFileManager = new PublicFileManager();
		$publicFileManager->removeJournalFile($journal->getId(),$submission->getFileName($formLocale));
		$submission->setFileName('', $formLocale);
		$submission->setOriginalFileName('', $formLocale);
		$submission->setWidth('', $formLocale);
		$submission->setHeight('', $formLocale);

		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$articleDao->updateArticle($submission);

		Request::redirect(null, null, 'viewMetadata', $articleId);
	}

	function uploadCopyeditVersion() {
		$copyeditStage = Request::getUserVar('copyeditStage');
		$articleId = Request::getUserVar('articleId');

		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(true, $articleId);

		AuthorAction::uploadCopyeditVersion($submission, $copyeditStage);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	function completeAuthorCopyedit($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(true);

		if (AuthorAction::completeAuthorCopyedit($submission, Request::getUserVar('send'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	//
	// Misc
	//

	/**
	 * Download a file.
	 * @param $args array ($articleId, $fileId)
	 */
	function downloadFile($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;

		$this->validate($articleId);
		$submission =& $this->submission;
		if (!AuthorAction::downloadAuthorFile($submission, $fileId)) {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}

	/**
	 * Download a file.
	 * @param $args array ($articleId, $fileId)
	 */
	function download($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;

		$this->validate($articleId);
		Action::downloadFile($articleId, $fileId);
	}

	//
	// Validation
	//

	/**
	 * Validate that the user is the author for the article.
	 * Redirects to author index page if validation fails.
	 */
	function validate($articleId) {
		parent::validate();
		$authorSubmissionDao =& DAORegistry::getDAO('AuthorSubmissionDAO');
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$isValid = true;

		$authorSubmission =& $authorSubmissionDao->getAuthorSubmission($articleId);

		if ($authorSubmission == null) {
			$isValid = false;
		} else if ($authorSubmission->getJournalId() != $journal->getId()) {
			$isValid = false;
		} else {
			if ($authorSubmission->getUserId() != $user->getId()) {
				$isValid = false;
			}
		}

		if (!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}

		$this->journal =& $journal;
		$this->submission =& $authorSubmission;
		return true;
	}

	//
	// Proofreading
	//

	/**
	 * Set the author proofreading date completion
	 */
	function authorProofreadingComplete($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$this->setupTemplate(true);

		$send = isset($args[0]) && $args[0] == 'send' ? true : false;

		import('classes.submission.proofreader.ProofreaderAction');

		if (ProofreaderAction::proofreadEmail($articleId,'PROOFREAD_AUTHOR_COMPLETE', $send?'':Request::url(null, 'author', 'authorProofreadingComplete', 'send'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Proof / "preview" a galley.
	 * @param $args array ($articleId, $galleyId)
	 */
	function proofGalley($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);
		$this->setupTemplate();

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('articleId', $articleId);
		$templateMgr->assign('galleyId', $galleyId);
		$templateMgr->display('submission/layout/proofGalley.tpl');
	}

	/**
	 * Proof galley (shows frame header).
	 * @param $args array ($articleId, $galleyId)
	 */
	function proofGalleyTop($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);
		$this->setupTemplate();

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('articleId', $articleId);
		$templateMgr->assign('galleyId', $galleyId);
		$templateMgr->assign('backHandler', 'submissionEditing');
		$templateMgr->display('submission/layout/proofGalleyTop.tpl');
	}

	/**
	 * Proof galley (outputs file contents).
	 * @param $args array ($articleId, $galleyId)
	 */
	function proofGalleyFile($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);

		$galleyDao =& DAORegistry::getDAO('ArticleGalleyDAO');
		$galley =& $galleyDao->getGalley($galleyId, $articleId);

		import('classes.file.ArticleFileManager'); // FIXME

		if (isset($galley)) {
			if ($galley->isHTMLGalley()) {
				$templateMgr =& TemplateManager::getManager();
				$templateMgr->assign_by_ref('galley', $galley);
				if ($galley->isHTMLGalley() && $styleFile =& $galley->getStyleFile()) {
					$templateMgr->addStyleSheet(Request::url(null, 'article', 'viewFile', array(
						$articleId, $galleyId, $styleFile->getFileId()
					)));
				}
				$templateMgr->display('submission/layout/proofGalleyHTML.tpl');

			} else {
				// View non-HTML file inline
				TrackSubmissionHandler::viewFile(array($articleId, $galley->getFileId()));
			}
		}
	}

	/**
	 * View a file (inlines file).
	 * @param $args array ($articleId, $fileId)
	 */
	function viewFile($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;

		$this->validate($articleId);
		if (!AuthorAction::viewFile($articleId, $fileId)) {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}

	//
	// Payment Actions
	//

	/**
	 * Display a form to pay for the submission an article
	 * @param $args array ($articleId)
	 */
	function paySubmissionFee($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;

		$this->validate($articleId);
		$this->setupTemplate(true, $articleId);

		$journal =& Request::getJournal();

		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		$user =& Request::getUser();

		$queuedPayment =& $paymentManager->createQueuedPayment($journal->getId(), PAYMENT_TYPE_SUBMISSION, $user->getId(), $articleId, $journal->getSetting('submissionFee'));
		$queuedPaymentId = $paymentManager->queuePayment($queuedPayment);

		$paymentManager->displayPaymentForm($queuedPaymentId, $queuedPayment);
	}

	/**
	 * Display a form to pay for Fast Tracking an article
	 * @param $args array ($articleId)
	 */
	function payFastTrackFee($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;

		$this->validate($articleId);
		$this->setupTemplate(true, $articleId);

		$journal =& Request::getJournal();

		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		$user =& Request::getUser();

		$queuedPayment =& $paymentManager->createQueuedPayment($journal->getId(), PAYMENT_TYPE_FASTTRACK, $user->getId(), $articleId, $journal->getSetting('fastTrackFee'));
		$queuedPaymentId = $paymentManager->queuePayment($queuedPayment);

		$paymentManager->displayPaymentForm($queuedPaymentId, $queuedPayment);
	}

	/**
	 * Display a form to pay for Publishing an article
	 * @param $args array ($articleId)
	 */
	function payPublicationFee($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;

		$this->validate($articleId);
		$this->setupTemplate(true, $articleId);

		$journal =& Request::getJournal();

		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		$user =& Request::getUser();

		$queuedPayment =& $paymentManager->createQueuedPayment($journal->getId(), PAYMENT_TYPE_PUBLICATION, $user->getId(), $articleId, $journal->getSetting('publicationFee'));
		$queuedPaymentId = $paymentManager->queuePayment($queuedPayment);

		$paymentManager->displayPaymentForm($queuedPaymentId, $queuedPayment);
	}

        /**
         *  Withdraw a proposal.
         *  Added by: AIM
         *  Last updated: June 15, 2011
         */

        function withdrawSubmission($args, $request) {
            $articleId = (int) array_shift($args);
            $journal =& $request->getJournal();
            $this->setupTemplate(true);

            $this->validate($articleId);
            $authorSubmission =& $this->submission;
            
            import('classes.submission.form.WithdrawForm');
            
            $withdrawForm = new WithdrawForm($authorSubmission, $journal);
           
            //Added by AIM, June 15 2011
            $withdrawForm->setData('type', 'Withdraw Report');
            
            if ($withdrawForm->isLocaleResubmit()) {
                    $withdrawForm->readInputData();
		} else {
                    $withdrawForm->initData();
		}

           $withdrawForm->display();
        }


        function sendToArchive($args) {
            $articleId = isset($args[0]) ? $args[0] : 0;
            $this->validate($articleId);
            $this->setupTemplate(true);

            //$authorSubmission =& $this->submission;
            //$authorSubmission->setStatus = PROPOSAL_STATUS_WITHDRAWN;

            $articleDao = DAORegistry::getDAO('ArticleDAO');
            $articleDao->sendToArchive($articleId);

            Request::redirect(null, null, 'index');
        }


        function setAsCompleted($args) {
            $articleId = isset($args[0]) ? $args[0] : 0;
            $this->validate($articleId);
            $this->setupTemplate(true);

            $articleDao = DAORegistry::getDAO('ArticleDAO');
            $article = $articleDao->getArticle($articleId);
            $article->setStatus(PROPOSAL_STATUS_COMPLETED);
            $articleDao->updateArticle($article);

                        
            Request::redirect(null, null, 'index');
        }


        function setAsWithdrawn($args) {
            $articleId = isset($args[0]) ? $args[0] : 0;
            $this->validate($articleId);
            $this->setupTemplate(true);

            $articleDao = DAORegistry::getDAO('ArticleDAO');
            $article = $articleDao->getArticle($articleId);
            $article->setStatus(PROPOSAL_STATUS_WITHDRAWN);
            $articleDao->updateArticle($article);

				// Send a regular notification to section editors
				// Removed by EL on February 17th 2013
				// No edit assignments anymore
				//$edit Assignment Dao =& DAORegistry::getDAO('Edit Assignment DAO');
				//$notificationSectionEditors = array();
				//$sectionEditors = $edit Assignment Dao->getEditorAssignmentsByArticleId3($article->getArticleId());
			
			$user =& Request::getUser();
			$journal =& Request::getJournal();
			
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$param = $article->getLocalizedProposalId().':<br/>'.$user->getUsername();
			$url = Request::url($journal->getPath(), 'sectionEditor', 'submission', array($article->getId()));
        	
        		//foreach ($sectionEditors as $sectionEditorEntry) {
        			//$sectionEditor =& $sectionEditorEntry['user'];
            		//$notificationManager->createNotification(
            			//$sectionEditor->getId(), 'notification.type.proposalWithdrawn',
            			//$param, $url, 1, NOTIFICATION_TYPE_ARTICLE_SUBMITTED
        			//);
        		//}
				$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
				$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $article->getSectionId());
				foreach ($sectionEditors as $sectionEditor){
            		$notificationManager->createNotification(
            			$sectionEditor->getId(), 'notification.type.proposalWithdrawn',
            			$param, $url, 1, NOTIFICATION_TYPE_ARTICLE_SUBMITTED
        			);		
				}
			        	
            Request::redirect(null, null, 'index');
        }


        /**
         * Add a progress report
         * @param $args array ($articleId)
         *
         * Added by: AIM
         * Last Updated: June 15, 2011
         */

        function addProgressReport($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		$authorSubmission =& $this->submission;


		$this->setupTemplate(true, $articleId, 'summary');

		import('classes.submission.form.SuppFileForm');

                $submitForm = new SuppFileForm($authorSubmission, $journal);

                //Added by AIM, June 15 2011
                $submitForm->setData('type','Progress Report');

                if ($submitForm->isLocaleResubmit()) {
                    $submitForm->readInputData();
		} else {
                    $submitForm->initData();
		}

                $submitForm->display();

	}


        /**
         * Add a completion report
         * @param $args array ($articleId)
         *
         * Added by: AIM
         * Last Updated: June 22, 2011
         */

        function addCompletionReport($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();
		                
		$this->validate($articleId);
		$authorSubmission =& $this->submission;

                
		$this->setupTemplate(true, $articleId, 'summary');

		import('classes.submission.form.SuppFileForm');
                
        $submitForm = new SuppFileForm($authorSubmission, $journal);

        //Added by AIM, June 22 2011
        $submitForm->setData('type','Completion Report');

        if ($submitForm->isLocaleResubmit()) {
			$submitForm->readInputData();
		} else {
            $submitForm->initData();
		}
        $submitForm->display();
	}


        /**
         * Submit a request for extension
         * @param $args array ($articleId)
         *
         * Added by: AIM
         * Last Updated: July 18, 2011
         */

        function addExtensionRequest($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		$authorSubmission =& $this->submission;


		$this->setupTemplate(true, $articleId, 'summary');

		import('classes.submission.form.SuppFileForm');

                $submitForm = new SuppFileForm($authorSubmission, $journal);

                //Added by AIM, June 22 2011
                $submitForm->setData('type', 'Extension Request');

                if ($submitForm->isLocaleResubmit()) {
                    $submitForm->readInputData();
		} else {
                    $submitForm->initData();
		}

                $submitForm->display();
	}
        /**
         * Submit raw datafile
         * @param $args array ($articleId)
         *
         * Added by: AIM
         * Last Updated: July 18, 2011
         */

        function addRawDataFile($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		$authorSubmission =& $this->submission;


		$this->setupTemplate(true, $articleId, 'summary');

		import('classes.submission.form.SuppFileForm');

                $submitForm = new SuppFileForm($authorSubmission, $journal);

                //Added by AIM, June 22 2011
                $submitForm->setData('type', 'Raw Data File');

                if ($submitForm->isLocaleResubmit()) {
                    $submitForm->readInputData();
		} else {
                    $submitForm->initData();
		}
                $submitForm->display();
	}
        /**
         * Submit other supplementary research output
         * @param $args array ($articleId)
         *
         * Added by: AIM
         * Last Updated: July 18, 2011
         */

        function addOtherSuppResearchOutput($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		$authorSubmission =& $this->submission;


		$this->setupTemplate(true, $articleId, 'summary');

		import('classes.submission.form.SuppFileForm');

                $submitForm = new SuppFileForm($authorSubmission, $journal);

                //Added by AIM, June 22 2011
                $submitForm->setData('type', 'Other Supplementary Research Output');

                if ($submitForm->isLocaleResubmit()) {
                    $submitForm->readInputData();
		} else {
                    $submitForm->initData();
		}
                $submitForm->display();
	}

	/**
	 * Response to Meeting Scheduler
	 * Added by EL on March 13th 2013
	 */
	
	function replyMeeting(){
		$meetingId = Request::getUserVar('meetingId');
		$submissionId = Request::getUserVar('submissionId');
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$meetingAttendanceDao =& DAORegistry::getDao('MeetingAttendanceDAO');
		$meetingAttendance = $meetingAttendanceDao->getMeetingAttendance($meetingId, $userId);
		
		$meetingAttendance->setIsAttending(Request::getUserVar('isAttending'));
		$meetingAttendance->setRemarks(Request::getUserVar('remarks'));	
		
		$meetingAttendanceDao =& DAORegistry::getDao('MeetingAttendanceDAO');
		$meetingAttendanceDao->updateReplyOfAttendance($meetingAttendance);
		Request::redirect(null, 'author', 'submissionReview', $submissionId);
	}
}
?>
