<?php

/**
 * @file SubmitHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SubmitHandler
 * @ingroup pages_author
 *
 * @brief Handle requests for author article submission.
 */

// $Id$

import('pages.author.AuthorHandler');
import('classes.article.Article');

class SubmitHandler extends AuthorHandler {
	/** article associated with the request **/
	var $article;

	/**
	 * Constructor
	 **/
	function SubmitHandler() {
		parent::AuthorHandler();
	}


    function resubmit($args, $request, $reviewType = STATUS_QUEUED) {
		$articleDAO = DAORegistry::getDAO('ArticleDAO');
        $articleId = isset($args[0]) ? (int) $args[0] : 0;

        $sectionDecisionDao = DAORegistry::getDAO('SectionDecisionDAO');
        $lastDecision = $sectionDecisionDao->getLastSectionDecision($articleId);

        $authorSubmissionDao =& DAORegistry::getDAO('AuthorSubmissionDAO');
        $authorSubmission = $authorSubmissionDao->getAuthorSubmission($articleId);

        if (
        	$sectionDecisionDao->getProposalStatus($articleId) == PROPOSAL_STATUS_RETURNED 
        	|| ($lastDecision->getDecision() == SUBMISSION_SECTION_DECISION_RESUBMIT 
        		&& !($articleDAO->isProposalResubmitted($articleId))) 
        	|| ($lastDecision->getDecision() == SUBMISSION_SECTION_DECISION_APPROVED 
        		&& $authorSubmission->isSubmissionDue())
        ) {
            $step = 2;
            $articleDAO->changeArticleStatus($reviewType, $step);
            $articleDAO->changeArticleProgress($articleId, $step);
           
            Request::redirect(null, null, 'submit', $step, array('articleId' => $articleId));
        }
        else
        {
            Request::redirect(null, 'author', '');
        }
    }
        
     /**
      * Added by MSB, Sept 29, 2011
      * Rename all the submitted files 
      * Enter description here ...
      */
    function renameSubmittedFiles(){
    	import('classes.file.ArticleFileManager');
    	
    	$article =& $this->article;
    	$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
    	$articleFiles =& $articleFileDao->getArticleFilesByArticle($article->getId());
    	$articleId = $article->getId();

    	$articleFileManager = new ArticleFileManager($articleId);
    	
    	$suppFileCounter = 0;
    	$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
    	 
    	/*Rename each uploaded file*/
    	foreach  ($articleFiles as $file){
    		$suppFileCounter = $articleFileManager->renameFile($file->getFileId(),$file->getType(),$suppFileCounter);
    	}
    }

	/**
	 * Display journal author article submission.
	 * Displays author index page if a valid step is not specified.
	 * @param $args array optional, if set the first parameter is the step to display
	 */
	function submit($args, $request) {
		$step = isset($args[0]) ? (int) $args[0] : 0;
		$articleId = $request->getUserVar('articleId');
                $journal =& $request->getJournal();

                $this->validate($articleId, $step, 'author.submit.authorSubmitLoginMessage');
		$article =& $this->article;
		$this->setupTemplate(true);

		$formClass = "AuthorSubmitStep{$step}Form";
		import("classes.author.form.submit.$formClass");

		$submitForm = new $formClass($article, $journal);
		if ($submitForm->isLocaleResubmit()) {
			$submitForm->readInputData();
		} else {
			$submitForm->initData();
		}
		$submitForm->display();
	}

	/**
	 * Save a submission step.
	 * @param $args array first parameter is the step being saved
	 * @param $request Request
	 */
	function saveSubmit($args, &$request) {
		$step = isset($args[0]) ? (int) $args[0] : 0;
		$articleId = $request->getUserVar('articleId');
                
		$journal =& $request->getJournal();

		$this->validate($articleId, $step);
		$this->setupTemplate(true);
		$article =& $this->article;

		$formClass = "AuthorSubmitStep{$step}Form";
		import("classes.author.form.submit.$formClass");

		$submitForm = new $formClass($article, $journal);
		$submitForm->readInputData();

		if (!HookRegistry::call('SubmitHandler::saveSubmit', array($step, &$article, &$submitForm))) {
                
			// Check for any special cases before trying to save
			switch ($step) {
				case 3:
					if ($request->getUserVar('uploadSubmissionFile')) {
                                                $submitForm->uploadSubmissionFile('submissionFile');
						$editData = true;
					}
					break;

				case 2:
					if ($request->getUserVar('addAuthor')) {
						// Add a sponsor
						$editData = true;
						$authors = $submitForm->getData('authors');
						array_push($authors, array());
						$submitForm->setData('authors', $authors);

					} else if (($delAuthor = $request->getUserVar('delAuthor')) && count($delAuthor) == 1) {
						// Delete an author
						$editData = true;
						list($delAuthor) = array_keys($delAuthor);
						$delAuthor = (int) $delAuthor;
						$authors = $submitForm->getData('authors');
						if (isset($authors[$delAuthor]['authorId']) && !empty($authors[$delAuthor]['authorId'])) {
							$deletedAuthors = explode(':', $submitForm->getData('deletedAuthors'));
							array_push($deletedAuthors, $authors[$delAuthor]['authorId']);
							$submitForm->setData('deletedAuthors', join(':', $deletedAuthors));
						}
						array_splice($authors, $delAuthor, 1);
						$submitForm->setData('authors', $authors);

						if ($submitForm->getData('primaryContact') == $delAuthor) {
							$submitForm->setData('primaryContact', 0);
						}

					} else if ($request->getUserVar('moveAuthor')) {
						// Move an author up/down
						$editData = true;
						$moveAuthorDir = $request->getUserVar('moveAuthorDir');
						$moveAuthorDir = $moveAuthorDir == 'u' ? 'u' : 'd';
						$moveAuthorIndex = (int) $request->getUserVar('moveAuthorIndex');
						$authors = $submitForm->getData('authors');

						if (!(($moveAuthorDir == 'u' && $moveAuthorIndex <= 0) || ($moveAuthorDir == 'd' && $moveAuthorIndex >= count($authors) - 1))) {
							$tmpAuthor = $authors[$moveAuthorIndex];
							$primaryContact = $submitForm->getData('primaryContact');
							if ($moveAuthorDir == 'u') {
								$authors[$moveAuthorIndex] = $authors[$moveAuthorIndex - 1];
								$authors[$moveAuthorIndex - 1] = $tmpAuthor;
								if ($primaryContact == $moveAuthorIndex) {
									$submitForm->setData('primaryContact', $moveAuthorIndex - 1);
								} else if ($primaryContact == ($moveAuthorIndex - 1)) {
									$submitForm->setData('primaryContact', $moveAuthorIndex);
								}
							} else {
								$authors[$moveAuthorIndex] = $authors[$moveAuthorIndex + 1];
								$authors[$moveAuthorIndex + 1] = $tmpAuthor;
								if ($primaryContact == $moveAuthorIndex) {
									$submitForm->setData('primaryContact', $moveAuthorIndex + 1);
								} else if ($primaryContact == ($moveAuthorIndex + 1)) {
									$submitForm->setData('primaryContact', $moveAuthorIndex);
								}
							}
						}
						$submitForm->setData('authors', $authors);
					}
					break;

				case 4:
                                        if ($request->getUserVar('submitUploadSuppFile')) {  //AIM, 12.12.2011
                                            if($request->getUserVar('fileType'))
                                                SubmitHandler::submitUploadSuppFile(array(), $request);
                                            else
                                                Request::redirect(null, null, 'submit', '4', array('articleId' => $articleId));
                                        }
                                        break;
			}

			if (!isset($editData) && $submitForm->validate()) {
				$articleId = $submitForm->execute($request);
				HookRegistry::call('Author::SubmitHandler::saveSubmit', array(&$step, &$article, &$submitForm));
                                
				if ($step == 5) {
					
					// Rename uploaded files
					$this->renameSubmittedFiles(); /*Added by MSB, Sept29, 2011*/

					$journal =& $request->getJournal();
					$templateMgr =& TemplateManager::getManager();
					$templateMgr->assign_by_ref('journal', $journal);
					// If this is an editor and there is a
					// submission file, article can be expedited.
					if (Validation::isEditor($journal->getId()) && $article->getSubmissionFileId()) {
						$templateMgr->assign('canExpedite', true);
					}
					$templateMgr->assign('articleId', $articleId);
					$templateMgr->assign('helpTopicId','submission.index');

                    //Last updated, AIM, 1.20.2012
                    $templateMgr->assign_by_ref('article', $this->article);

                    $articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
                    $articleFiles =& $articleFileDao->getArticleFilesByArticle($articleId);
                    $templateMgr->assign_by_ref('files', $articleFiles);

                    // EL on March 11th 2013
					$templateMgr->assign_by_ref('riskAssessment', $this->article->getRiskAssessment());

					$templateMgr->assign_by_ref('abstract', $this->article->getLocalizedAbstract());
                											
					$templateMgr->display('author/submit/complete.tpl');
					
				} else {
					$request->redirect(null, null, 'submit', $step+1, array('articleId' => $articleId));
				}
			} else {
				$submitForm->display();
			}
		}
	}

	/**
	 * Create new supplementary file with a uploaded file.
	 */
	function submitUploadSuppFile($args, $request) {
		$articleId = $request->getUserVar('articleId');
                // Start Edit Raf Tan 04/30/2011
                $fileTypes = $request->getUserVar('fileType');
                $otherFileType = trim($request->getUserVar('otherFileType'));
                // End Edit Raf Tan 04/30/2011
		$journal =& $request->getJournal();

		$this->validate($articleId, 4);
		$article =& $this->article;
		$this->setupTemplate(true);

		import('classes.author.form.submit.AuthorSubmitSuppFileForm');
		$submitForm = new AuthorSubmitSuppFileForm($article, $journal);
		$submitForm->setData('title', array($article->getLocale() => Locale::translate('common.untitled')));
		$suppFileId = $submitForm->execute();

                // Start Edit Raf Tan 04/30/2011
                //Request::redirect(null, null, 'submitSuppFile', $suppFileId, array('articleId' => $articleId));

                // Bypass displaying the supplementay submission form (pass articleId and proposalType)
                $suppFileType = $fileTypes[0];
                if($suppFileType == Locale::translate('common.other') && $otherFileType != "") $suppFileType = $otherFileType;
                $count = 1;
                foreach ($fileTypes as $type) {
                    if($count > 1) {
                        if($type == Locale::translate('common.other') && $otherFileType != "")
                            $type = $otherFileType;

                        $suppFileType = $suppFileType . ', ' . $type;
                    }
                    $count++;
                }
                
                Request::redirect(null, null, 'saveSubmitSuppFile', $suppFileId, array('articleId' => $articleId, 'type' => $suppFileType));
                // End Edit Raf Tan 04/30/2011
	}

	/**
	 * Display supplementary file submission form.
	 * @param $args array optional, if set the first parameter is the supplementary file to edit
	 */
	function submitSuppFile($args, $request) {
		$articleId = $request->getUserVar('articleId');
		$suppFileId = isset($args[0]) ? (int) $args[0] : 0;
		$journal =& $request->getJournal();

		$this->validate($articleId, 4);
		$article =& $this->article;
		$this->setupTemplate(true);

		import('classes.author.form.submit.AuthorSubmitSuppFileForm');
		$submitForm = new AuthorSubmitSuppFileForm($article, $journal, $suppFileId);

		if ($submitForm->isLocaleResubmit()) {
			$submitForm->readInputData();
		} else {
			$submitForm->initData();
		}
		$submitForm->display();
	}

	/**
	 * Save a supplementary file.
	 * @param $args array optional, if set the first parameter is the supplementary file to update
	 */
	function saveSubmitSuppFile($args, $request) {
		$articleId = $request->getUserVar('articleId');
                // Start Edit Raf Tan 04/30/2011
                $type = $request->getUserVar('type');
                // End Edit Raf Tan 04/30/2011
		$suppFileId = isset($args[0]) ? (int) $args[0] : 0;
		$journal =& $request->getJournal();

		$this->validate($articleId, 4);
		$article =& $this->article;
		$this->setupTemplate(true);

		import('classes.author.form.submit.AuthorSubmitSuppFileForm');
		$submitForm = new AuthorSubmitSuppFileForm($article, $journal, $suppFileId);
                /**
                 * Start Edit Raf Tan 04/30/2011
		$submitForm->readInputData();

		if ($submitForm->validate()) {
			$submitForm->execute();
			Request::redirect(null, null, 'submit', '4', array('articleId' => $articleId));
		} else {
			$submitForm->display();
		}
                 *
                 */

                //$submitForm->readInputData();

               // $suppFileDao = DAORegistry::getDAO('SuppFileDAO');
               // $suppFileCount = count($suppFileDao->getSuppFilesByArticle($articleId));
                //$submitForm->setData('title', array($article->getLocale() => ('SuppFile'.$suppFileCount)));
                $submitForm->setData('title', array($article->getLocale() => ($type)));

                $submitForm->setData('type', $type);
                $submitForm->execute();
                Request::redirect(null, null, 'submit', '4', array('articleId' => $articleId));

                // End Edit Raf Tan 04/30/2011
	}

	/**
	 * Delete a supplementary file.
	 * @param $args array, the first parameter is the supplementary file to delete
	 */
	function deleteSubmitSuppFile($args) {
		import('classes.file.ArticleFileManager');

		$articleId = Request::getUserVar('articleId');
		$suppFileId = isset($args[0]) ? (int) $args[0] : 0;

		$this->validate($articleId, 4);
		$article =& $this->article;
		$this->setupTemplate(true);

		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$suppFile = $suppFileDao->getSuppFile($suppFileId, $articleId);
		$suppFileDao->deleteSuppFileById($suppFileId, $articleId);

		if ($suppFile->getFileId()) {
			$articleFileManager = new ArticleFileManager($articleId);
			$articleFileManager->deleteFile($suppFile->getFileId());
		}

		Request::redirect(null, null, 'submit', '4', array('articleId' => $articleId));
	}

	function expediteSubmission() {
		$articleId = (int) Request::getUserVar('articleId');
		$this->validate($articleId);
		$journal =& Request::getJournal();
		$article =& $this->article;

		// The author must also be an editor to perform this task.
		if (Validation::isEditor($journal->getId()) && $article->getSubmissionFileId()) {
			import('classes.submission.editor.EditorAction');
			EditorAction::expediteSubmission($article);
			Request::redirect(null, 'editor', 'submissionEditing', array($article->getId()));
		}

		Request::redirect(null, null, 'track');
	}

	/**
	 * Validation check for submission.
	 * Checks that article ID is valid, if specified.
	 * @param $articleId int
	 * @param $step int
	 */
	function validate($articleId = null, $step = false, $reason = null) {
		parent::validate($reason);
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$user =& Request::getUser();
		$journal =& Request::getJournal();

		if ($step !== false && ($step < 1 || $step > 5 || (!isset($articleId) && $step != 1))) {
			Request::redirect(null, null, 'submit', array(1));
		}

		$article = null;

		// Check that article exists for this journal and user and that submission is incomplete
		if (isset($articleId)) {
			$article =& $articleDao->getArticle((int) $articleId);
			if (!$article || $article->getUserId() !== $user->getId() || $article->getJournalId() !== $journal->getId() || ($step !== false && $step > $article->getSubmissionProgress())) {
				Request::redirect(null, null, 'submit');
			}
		}
                
		$this->article =& $article;
		return true;
	}
}
?>
