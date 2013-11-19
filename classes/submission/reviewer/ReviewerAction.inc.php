<?php

/**
 * @file classes/submission/reviewer/ReviewerAction.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ReviewerAction
 * @ingroup submission
 *
 * @brief ReviewerAction class.
 */

// $Id$


import('classes.submission.common.Action');

class ReviewerAction extends Action {

	/**
	 * Constructor.
	 */
	function ReviewerAction() {

	}

	/**
	 * Actions.
	 */

	/**
	 * Records whether or not the reviewer accepts the review assignment.
	 * @param $user object
	 * @param $reviewerSubmission object
	 * @param $decline boolean
	 * @param $send boolean
	 */
	function confirmReview($reviewerSubmission, $decline, $send) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');

		$reviewId = $reviewerSubmission->getReviewId();

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
		if (!isset($reviewer)) return true;

		// Only confirm the review for the reviewer if 
		// he has not previously done so.
		if ($reviewAssignment->getDateConfirmed() == null) {
			import('classes.mail.ArticleMailTemplate');
			$email = new ArticleMailTemplate($reviewerSubmission, $decline?'REVIEW_DECLINE':'REVIEW_CONFIRM');
			// Must explicitly set sender because we may be here on an access
			// key, in which case the user is not technically logged in
			$email->setFrom($reviewer->getEmail(), $reviewer->getFullName());
			if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
				HookRegistry::call('ReviewerAction::confirmReview', array(&$reviewerSubmission, &$email, $decline));
				if ($email->isEnabled()) {
					$email->setAssoc($decline?ARTICLE_EMAIL_REVIEW_DECLINE:ARTICLE_EMAIL_REVIEW_CONFIRM, ARTICLE_EMAIL_TYPE_REVIEW, $reviewId);
					$email->send();
				}

				$reviewAssignment->setDeclined($decline);
				$reviewAssignment->setDateConfirmed(Core::getCurrentDate());
				$reviewAssignment->stampModified();
				$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

				//Send a notification to section editors
				import('lib.pkp.classes.notification.NotificationManager');
				$articleDao =& DAORegistry::getDAO('ArticleDAO');
				$article =& $articleDao->getArticle($reviewerSubmission->getArticleId());
				$user =& Request::getUser();
				$notificationManager = new NotificationManager();
				$notificationUsers = $article->getAssociatedUserIds(false, false);
				if ($decline == '1') $message = $article->getLocalizedProposalId().':<br/>'.$user->getUsername().' declined';
				else $message = $article->getLocalizedProposalId().':<br/>'.$user->getUsername().' accepted';
				foreach ($notificationUsers as $userRole) {
					$url = Request::url(null, $userRole['role'], 'submissionReview', $article->getId(), null, 'peerReview');
            		$notificationManager->createNotification(
            			$userRole['id'], 'notification.type.reviewAssignmentConfirmed',
                		$message, $url, 1, NOTIFICATION_TYPE_REVIEWER_COMMENT
            		);
				}
				
				// Add log
				import('classes.article.log.ArticleLog');
				import('classes.article.log.ArticleEventLogEntry');

				$entry = new ArticleEventLogEntry();
				$entry->setArticleId($reviewerSubmission->getArticleId());
				$entry->setUserId($reviewer->getId());
				$entry->setDateLogged(Core::getCurrentDate());
				$entry->setEventType($decline?ARTICLE_LOG_REVIEW_DECLINE:ARTICLE_LOG_REVIEW_ACCEPT);
				$entry->setLogMessage($decline?'log.review.reviewDeclined':'log.review.reviewAccepted', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $reviewerSubmission->getLocalizedProposalId()));
				$entry->setAssocType(ARTICLE_LOG_TYPE_REVIEW);
				$entry->setAssocId($reviewAssignment->getId());

				ArticleLog::logEventEntry($reviewerSubmission->getArticleId(), $entry);

				return true;
			} else {
				if (!Request::getUserVar('continued')) {
					//$assignedEditors = $email->ccAssignedEditors($reviewerSubmission->getArticleId());
					$reviewingSectionEditors = $email->toAssignedReviewingSectionEditors($reviewerSubmission->getArticleId());
					if (empty($reviewingSectionEditors)) {
						$journal =& Request::getJournal();
						$email->addRecipient($journal->getSetting('contactEmail'), $journal->getSetting('contactName'));
						$editorialContactName = $journal->getSetting('contactName');
					} else {
						$editorialContactName = (string)'';
						foreach ($reviewingSectionEditors as $reviewingSectionEditor) {
							if ($editorialContactName == '') $editorialContactName = $reviewingSectionEditor->getFullName();
							else $editorialContactName .= ', '.$reviewingSectionEditor->getFullName();
						}
					}
					$email->promoteCcsIfNoRecipients();

					// Format the review due date
					$reviewDueDate = strtotime($reviewAssignment->getDateDue());
					$dateFormatLong = Config::getVar('general', 'date_format_long');
					if ($reviewDueDate == -1) $reviewDueDate = $dateFormatShort; // Default to something human-readable if no date specified
					else $reviewDueDate = strftime($dateFormatLong, $reviewDueDate);
					
					$email->assignParams(array(
						'editorialContactName' => $editorialContactName,
						'reviewerName' => $reviewer->getFullName(),
						'reviewDueDate' => $reviewDueDate
					));
				}
				$paramArray = array('reviewId' => $reviewId);
				if ($decline) $paramArray['declineReview'] = 1;
				$email->displayEditForm(Request::url(null, 'reviewer', 'confirmReview'), $paramArray);
				return false;
			}
		}
		return true;
	}

	/**
	 * Records the reviewer's submission recommendation.
	 * @param $reviewId int
	 * @param $recommendation int
	 * @param $send boolean
	 */
	function recordRecommendation(&$reviewerSubmission, $recommendation, $send) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');

		// Check validity of selected recommendation
		$reviewerRecommendationOptions =& ReviewAssignment::getReviewerRecommendationOptions();
		if (!isset($reviewerRecommendationOptions[$recommendation])) return true;

		$reviewAssignment =& $reviewAssignmentDao->getById($reviewerSubmission->getReviewId());
		$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());
		if (!isset($reviewer)) return true;

		// Only record the reviewers recommendation if
		// no recommendation has previously been submitted.
		if ($reviewAssignment->getRecommendation() === null || $reviewAssignment->getRecommendation === '') {
			import('classes.mail.ArticleMailTemplate');
			$email = new ArticleMailTemplate($reviewerSubmission, 'REVIEW_COMPLETE');
			// Must explicitly set sender because we may be here on an access
			// key, in which case the user is not technically logged in
			$email->setFrom($reviewer->getEmail(), $reviewer->getFullName());

			if (!$email->isEnabled() || ($send && !$email->hasErrors())) {
				HookRegistry::call('ReviewerAction::recordRecommendation', array(&$reviewerSubmission, &$email, $recommendation));
				if ($email->isEnabled()) {
					$email->setAssoc(ARTICLE_EMAIL_REVIEW_COMPLETE, ARTICLE_EMAIL_TYPE_REVIEW, $reviewerSubmission->getReviewId());
					$email->send();
				}
				
				$reviewAssignment->setRecommendation($recommendation);
				$reviewAssignment->setDateCompleted(Core::getCurrentDate());
				$reviewAssignment->stampModified();
				$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

				// Add log
				import('classes.article.log.ArticleLog');
				import('classes.article.log.ArticleEventLogEntry');

				$entry = new ArticleEventLogEntry();
				$entry->setArticleId($reviewerSubmission->getArticleId());
				$entry->setUserId($reviewer->getId());
				$entry->setDateLogged(Core::getCurrentDate());
				$entry->setEventType(ARTICLE_LOG_REVIEW_RECOMMENDATION);
				$entry->setLogMessage('log.review.reviewRecommendationSet', array('reviewerName' => $reviewer->getFullName(), 'articleId' => $reviewerSubmission->getLocalizedProposalId()));
				$entry->setAssocType(ARTICLE_LOG_TYPE_REVIEW);
				$entry->setAssocId($reviewAssignment->getId());

				ArticleLog::logEventEntry($reviewerSubmission->getArticleId(), $entry);
			} else {
				if (!Request::getUserVar('continued')) {
					$assignedEditors = $email->ccAssignedEditors($reviewerSubmission->getArticleId());
					$reviewingSectionEditors = $email->toAssignedReviewingSectionEditors($reviewerSubmission->getArticleId());
					if (empty($assignedEditors) && empty($reviewingSectionEditors)) {
						$journal =& Request::getJournal();
						$email->addRecipient($journal->getSetting('contactEmail'), $journal->getSetting('contactName'));
						$editorialContactName = $journal->getSetting('contactName');
					} else {
						if (!empty($reviewingSectionEditors)) $editorialContact = array_shift($reviewingSectionEditors);
						else $editorialContact = array_shift($assignedEditors);
							// Modified by EL on February 17th 2013
							// No edit assigment anymore
						$editorialContactName = $editorialContact->getFullName();
					}

					$reviewerRecommendationOptions =& ReviewAssignment::getReviewerRecommendationOptions();
					$abstract = $reviewerSubmission->getLocalizedAbstract();
					$email->assignParams(array(
						'editorialContactName' => $editorialContactName,
						'reviewerName' => $reviewer->getFullName(),
						'articleTitle' => strip_tags($abstract->getScientificTitle()),
						'recommendation' => Locale::translate($reviewerRecommendationOptions[$recommendation])
					));
				}

				$email->displayEditForm(Request::url(null, 'reviewer', 'recordRecommendation'),
					array('reviewId' => $reviewerSubmission->getReviewId(), 'recommendation' => $recommendation)
				);
				return false;
			}
		}
		return true;
	}

	/**
	 * Upload the annotated version of an article.
	 * @param $reviewId int
	 */
	function uploadReviewerVersion($reviewId) {
		import('classes.file.ArticleFileManager');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');		
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);

		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		$articleFileManager = new ArticleFileManager($sectionDecision->getArticleId());

		// Only upload the file if the reviewer has yet to submit a recommendation
		// and if review forms are not used
		if (($reviewAssignment->getRecommendation() === null || $reviewAssignment->getRecommendation() === '') && !$reviewAssignment->getCancelled()) {
			$fileName = 'upload';
			if ($articleFileManager->uploadedFileExists($fileName)) {
					
				// Check if file already uploaded
				$reviewFile =& $reviewAssignment->getReviewerFile();
				if ($reviewFile != null) {
					$articleFileManager->deleteFile($reviewFile->getFileId());
				}
				
				HookRegistry::call('ReviewerAction::uploadReviewFile', array(&$reviewAssignment));
				if ($reviewAssignment->getReviewerFileId() != null) {
					$fileId = $articleFileManager->uploadReviewFile($fileName, $reviewAssignment->getDecisionId(), $reviewAssignment->getReviewerFileId());
				} else {
					$fileId = $articleFileManager->uploadReviewFile($fileName, $reviewAssignment->getDecisionId());
				}
			}
		}

		if (isset($fileId) && $fileId != 0) {
			$reviewAssignment->setReviewerFileId($fileId);
			$reviewAssignment->stampModified();
			$reviewAssignmentDao->updateReviewAssignment($reviewAssignment);

			// Add log
			import('classes.article.log.ArticleLog');
			import('classes.article.log.ArticleEventLogEntry');

			$userDao =& DAORegistry::getDAO('UserDAO');
			$reviewer =& $userDao->getUser($reviewAssignment->getReviewerId());

			$entry = new ArticleEventLogEntry();
			$entry->setArticleId($sectionDecision->getArticleId());
			$entry->setUserId($reviewer->getId());
			$entry->setDateLogged(Core::getCurrentDate());
			$entry->setEventType(ARTICLE_LOG_REVIEW_FILE);
			$entry->setLogMessage('log.review.reviewerFile');
			$entry->setAssocType(ARTICLE_LOG_TYPE_REVIEW);
			$entry->setAssocId($reviewAssignment->getId());

			ArticleLog::logEventEntry($sectionDecision->getArticleId(), $entry);
			
			//Send a notification to section editors
			import('lib.pkp.classes.notification.NotificationManager');
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$article =& $articleDao->getArticle($sectionDecision->getArticleId());
			$notificationManager = new NotificationManager();
			$notificationUsers = $article->getAssociatedUserIds(false, false);
			$user =& Request::getUser();
			$message = $article->getLocalizedProposalId().':<br/>'.$user->getUsername();
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionReview', $article->getId(), null, 'peerReview');
            	$notificationManager->createNotification(
            		$userRole['id'], 'notification.type.reviewerFile',
                	$message, $url, 1, NOTIFICATION_TYPE_REVIEWER_COMMENT
            	);
			}
		}
	}

	/**
	 * Delete an annotated version of an article.
	 * @param $reviewId int
	 * @param $fileId int
	 */
	function deleteReviewerVersion($reviewId, $fileId, $articleId) {
		import('classes.file.ArticleFileManager');

		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);

		if (!HookRegistry::call('ReviewerAction::deleteReviewerVersion', array(&$reviewAssignment, &$fileId))) {
			$articleFileManager = new ArticleFileManager($articleId);
			$articleFileManager->deleteFile($fileId);
			
			//Send a notification to section editors
			import('lib.pkp.classes.notification.NotificationManager');
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$article =& $articleDao->getArticle($articleId);
			$notificationManager = new NotificationManager();
			$notificationUsers = $article->getAssociatedUserIds(false, false);
			$user =& Request::getUser();
			$message = $article->getLocalizedProposalId().':<br/>'.$user->getUsername();
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionReview', $article->getId(), null, 'peerReview');
            	$notificationManager->createNotification(
            		$userRole['id'], 'notification.type.reviewerFileDeleted',
                	$message, $url, 1, NOTIFICATION_TYPE_REVIEWER_COMMENT
            	);
			}
		}
	}

	/**
	 * View reviewer comments.
	 * @param $user object Current user
	 * @param $article object
	 * @param $reviewId int
	 */
	function viewPeerReviewComments(&$user, &$article, $reviewId) {
		if (!HookRegistry::call('ReviewerAction::viewPeerReviewComments', array(&$user, &$article, &$reviewId))) {
			import('classes.submission.form.comment.PeerReviewCommentForm');

			$commentForm = new PeerReviewCommentForm($article, $reviewId, ROLE_ID_REVIEWER);
			$commentForm->setUser($user);
			$commentForm->initData();
			$commentForm->setData('reviewId', $reviewId);
			$commentForm->display();
		}
	}

	/**
	 * Post reviewer comments.
	 * @param $user object Current user
	 * @param $article object
	 * @param $reviewId int
	 * @param $emailComment boolean
	 */
	function postPeerReviewComment(&$user, &$article, $reviewId, $emailComment) {
		if (!HookRegistry::call('ReviewerAction::postPeerReviewComment', array(&$user, &$article, &$reviewId, &$emailComment))) {
			import('classes.submission.form.comment.PeerReviewCommentForm');

			$commentForm = new PeerReviewCommentForm($article, $reviewId, ROLE_ID_REVIEWER);
			$commentForm->setUser($user);
			$commentForm->readInputData();

			if ($commentForm->validate()) {
				$commentForm->execute();

                // Send a notification to secretary(ies)
				import('lib.pkp.classes.notification.NotificationManager');
				$notificationManager = new NotificationManager();
				$notificationUsers = $article->getAssociatedUserIds(false, false, false, true);
				$url = Request::url(null, 'sectionEditor', 'submissionReview', $article->getId(), null, 'peerReview');
				$param = $article->getLocalizedProposalId().':<br/>'.$user->getUsername().' commented his review';
				foreach ($notificationUsers as $userRole) {
                	$notificationManager->createNotification(
                    	$userRole['id'], 'notification.type.reviewerComment',
                        $param, $url, 1, NOTIFICATION_TYPE_REVIEWER_COMMENT
                    );
				}
				
				if ($emailComment) {
					$commentForm->email();
				}

			} else {
				$commentForm->display();
				return false;
			}
			return true;
		}
	}

	/**
	 * Edit review form response.
	 * @param $reviewId int
	 * @param $reviewFormId int
	 */
	function editReviewFormResponse($reviewId, $reviewFormId) {
		if (!HookRegistry::call('ReviewerAction::editReviewFormResponse', array($reviewId, $reviewFormId))) {
			import('classes.submission.form.ReviewFormResponseForm');

			$reviewForm = new ReviewFormResponseForm($reviewId, $reviewFormId);
			$reviewForm->initData();
			$reviewForm->display();
		}
	}

	/**
	 * Save review form response.
	 * @param $reviewId int
	 * @param $reviewFormId int
	 */
	function saveReviewFormResponse($reviewId, $reviewFormId) {
		if (!HookRegistry::call('ReviewerAction::saveReviewFormResponse', array($reviewId, $reviewFormId))) {
			import('classes.submission.form.ReviewFormResponseForm');

			$reviewForm = new ReviewFormResponseForm($reviewId, $reviewFormId);
			$reviewForm->readInputData();
			if ($reviewForm->validate()) {
				$reviewForm->execute();

				// Send a notification to associated users
				import('lib.pkp.classes.notification.NotificationManager');
				$notificationManager = new NotificationManager();
				$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
				$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
				$reviewAssignment = $reviewAssignmentDao->getById($reviewId);
				$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
				$articleId = $sectionDecision->getArticleId();
				$articleDao =& DAORegistry::getDAO('ArticleDAO'); 
				$article =& $articleDao->getArticle($articleId);
				$abstract = $article->getLocalizedAbstract();
				$notificationUsers = $article->getAssociatedUserIds();
				foreach ($notificationUsers as $userRole) {
					$url = Request::url(null, $userRole['role'], 'submissionReview', $article->getId(), null, 'peerReview');
					$notificationManager->createNotification(
						$userRole['id'], 'notification.type.reviewerFormComment',
						$abstract->getScientificTitle(), $url, 1, NOTIFICATION_TYPE_REVIEWER_FORM_COMMENT
					);
				}
				
			} else {
				$reviewForm->display();
				return false;
			}
			return true;
		}
	}

	//
	// Misc
	//

	/**
	 * Download a file a reviewer has access to.
	 * @param $reviewId int
	 * @param $article object
	 * @param $fileId int
	 */
	function downloadReviewerFile($reviewId, $article, $fileId) {
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');		
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');		
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$journal =& Request::getJournal();

		$canDownload = false;
		
		$submissionFile = $article->getSubmissionFile();
		
		// Reviewers have access to:
		// 1) The current revision of the file to be reviewed.
		// 2) Any file that he uploads.
		// 3) Any supplementary file that is visible to reviewers.
		// 4) Any of the previous main proposal files
		if ($reviewAssignment->getReviewFileId() == $fileId) {
			$canDownload = true;
		} else if ($reviewAssignment->getReviewerFileId() == $fileId) {
			$canDownload = true;
		} else if ($submissionFile->getFileId() == $fileId) {
			$canDownload = true;
		} else {
			foreach ($reviewAssignment->getSuppFiles() as $suppFile) {
				if ($suppFile->getFileId() == $fileId && $suppFile->getShowReviewers()) {
					$canDownload = true;
				}
			}
			if (!$canDownload) {
				$previousFiles =& $articleFileDao->getPreviousFilesByArticleId($article->getId());
				foreach ($previousFiles as $previousFile) {
					if ($previousFile->getFileId() == $fileId) {
						$canDownload = true;
					}
				}
			}
		} 

		$result = false;
		if (!HookRegistry::call('ReviewerAction::downloadReviewerFile', array(&$article, &$fileId, &$canDownload, &$result))) {
			if ($canDownload) {
				return Action::downloadFile($article->getId(), $fileId);
			} else {
				return false;
			}
		}
		return $result;
	}

	/**
	 * Edit comment.
	 * @param $commentId int
	 */
	function editComment ($article, $comment, $reviewId) {
		if (!HookRegistry::call('ReviewerAction::editComment', array(&$article, &$comment, &$reviewId))) {
			import ('classes.submission.form.comment.EditCommentForm');

			$commentForm = new EditCommentForm ($article, $comment);
			$commentForm->initData();
			$commentForm->setData('reviewId', $reviewId);
			$commentForm->display(array('reviewId' => $reviewId));
		}
	}
}

?>
