<?php

/**
 * @file SubmissionEditHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SubmissionEditHandler
 * @ingroup pages_sectionEditor
 *
 * @brief Handle requests for submission tracking.
 */


define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);

import('pages.sectionEditor.SectionEditorHandler');
import('pages.sectionEditor.SubmissionCommentsHandler');

class SubmissionEditHandler extends SectionEditorHandler {
	/** submission associated with the request **/
	var $submission;

	/**
	 * Constructor
	 **/
	function SubmissionEditHandler() {
		parent::SectionEditorHandler();
	}

	function getFrom($default = 'submissionEditing') {
		$from = Request::getUserVar('from');
		if (!in_array($from, array('submission', 'submissionEditing'))) return $default;
		return $from;
	}

	function submission($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$journal =& Request::getJournal();
		$submission =& $this->submission;

		// FIXME? For comments.readerComments under Status and
		// author.submit.selectPrincipalContact under Metadata
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_READER, LOCALE_COMPONENT_OJS_AUTHOR));

		$this->setupTemplate(1, $articleId);

		$user =& Request::getUser();

		$journalSettingsDao =& DAORegistry::getDAO('JournalSettingsDAO');
		$journalSettings = $journalSettingsDao->getJournalSettings($journal->getId());

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$isEditor = $roleDao->roleExists($journal->getId(), $user->getId(), ROLE_ID_EDITOR);
		$isSectionEditor = $roleDao->roleExists($journal->getId(), $user->getId(), ROLE_ID_SECTION_EDITOR);
		
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section =& $sectionDao->getSection($submission->getSectionId());

		$enableComments = $journal->getSetting('enableComments');

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('section', $section);
		$templateMgr->assign_by_ref('submissionFile', $submission->getSubmissionFile());
		$templateMgr->assign_by_ref('suppFiles', $submission->getSuppFiles());
		$templateMgr->assign_by_ref('reviewFile', $submission->getReviewFile());
		$templateMgr->assign_by_ref('journalSettings', $journalSettings);
		$templateMgr->assign('userId', $user->getId());
		$templateMgr->assign('isEditor', $isEditor);
		$templateMgr->assign('isSectionEditor', $isSectionEditor);
		$templateMgr->assign('enableComments', $enableComments);

		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$templateMgr->assign_by_ref('sections', $sectionDao->getSectionTitles($journal->getId()));
		if ($enableComments) {
			import('classes.article.Article');
			$templateMgr->assign('commentsStatus', $submission->getCommentsStatus());
			$templateMgr->assign_by_ref('commentsStatusOptions', Article::getCommentsStatusOptions());
		}

		$publishedArticleDao =& DAORegistry::getDAO('PublishedArticleDAO');
		$publishedArticle =& $publishedArticleDao->getPublishedArticleByArticleId($submission->getId());
		if ($publishedArticle) {
			$issueDao =& DAORegistry::getDAO('IssueDAO');
			$issue =& $issueDao->getIssueById($publishedArticle->getIssueId());
			$templateMgr->assign_by_ref('issue', $issue);
			$templateMgr->assign_by_ref('publishedArticle', $publishedArticle);
		}

		if ($isEditor) {
			$templateMgr->assign('helpTopicId', 'editorial.editorsRole.submissionSummary');
		}

		$templateMgr->assign('canEditMetadata', true);

        $templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());
        $templateMgr->assign_by_ref('riskAssessment', $submission->getRiskAssessment());
            
		$templateMgr->display('sectionEditor/submission.tpl');
	}
	
	/*
	Not currently used
	function submissionRegrets($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$journal =& Request::getJournal();
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'review');

		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$cancelsAndRegrets = $reviewAssignmentDao->getCancelsAndRegrets($articleId);
		$reviewFilesByDecision = $reviewAssignmentDao->getReviewFilesByDecision($articleId);

		$reviewAssignments =& $submission->getReviewAssignments();
		$sectionDecisions = $submission->getDecisions();
		$numRounds = $submission->getCurrentRound();

		$reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
		$reviewFormResponses = array();
		if (isset($reviewAssignments[$numRounds-1])) {
			foreach ($reviewAssignments[$numRounds-1] as $reviewAssignment) {
				$reviewFormResponses[$reviewAssignment->getId()] = $reviewFormResponseDao->reviewFormResponseExists($reviewAssignment->getId());
			}
		}

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('reviewAssignments', $reviewAssignments);
		$templateMgr->assign('reviewFormResponses', $reviewFormResponses);
		$templateMgr->assign_by_ref('cancelsAndRegrets', $cancelsAndRegrets);
		$templateMgr->assign_by_ref('reviewFilesByDecision', $reviewFilesByDecision);
		$templateMgr->assign_by_ref('sectionDecisions', $sectionDecisions);
		$templateMgr->assign('numRounds', $numRounds);
		$templateMgr->assign('rateReviewerOnQuality', $journal->getSetting('rateReviewerOnQuality'));

		$templateMgr->assign_by_ref('sectionDecisionOptions', SectionEditorSubmission::getEditorDecisionOptions());

		import('classes.submission.reviewAssignment.ReviewAssignment');
		$templateMgr->assign_by_ref('reviewerRatingOptions', ReviewAssignment::getReviewerRatingOptions());
		$templateMgr->assign_by_ref('reviewerRecommendationOptions', ReviewAssignment::getReviewerRecommendationOptions());

		$templateMgr->display('sectionEditor/submissionRegrets.tpl');
	}
	*/
	
	function submissionReview($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$journal =& Request::getJournal();
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId);

		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_MANAGER));
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$reviewFormDao =& DAORegistry::getDAO('ReviewFormDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');

		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$sections =& $sectionDao->getJournalSections($journal->getId());

		$sectionDecisionDao =& DAORegistry::getDAO("SectionDecisionDAO");
		$lastDecision = $sectionDecisionDao->getLastSectionDecision($articleId);
		$reviewAssignments =& $lastDecision->getReviewAssignments();
		$articleMoreRecent = strtotime($submission->getLastModified())>strtotime($lastDecision->getDateDecided()) ? true : false;
				
		$reasons = $submission->getProposalReasonsForExemption();
		$reasonsMap =& $submission->getReasonsForExemptionMap();

		// Prepare an array to store the 'Notify Reviewer' email logs
		$notifyReviewerLogs = array();
		foreach ($reviewAssignments as $reviewAssignment) {
			$notifyReviewerLogs[$reviewAssignment->getId()] = array();
		}

		// Parse the list of email logs and populate the array.
		import('classes.article.log.ArticleLog');
		$emailLogEntries =& ArticleLog::getEmailLogEntries($articleId);
		foreach ($emailLogEntries->toArray() as $emailLog) {
			if ($emailLog->getEventType() == ARTICLE_EMAIL_REVIEW_NOTIFY_REVIEWER) {
				if (isset($notifyReviewerLogs[$emailLog->getAssocId()]) && is_array($notifyReviewerLogs[$emailLog->getAssocId()])) {
					array_push($notifyReviewerLogs[$emailLog->getAssocId()], $emailLog);
				}
			}
		}

		// get journal published review form titles
		$reviewFormTitles =& $reviewFormDao->getTitlesByAssocId(ASSOC_TYPE_JOURNAL, $journal->getId(), 1);

		$reviewFormResponseDao =& DAORegistry::getDAO('ReviewFormResponseDAO');
		$reviewFormResponses = array();

		$reviewFormDao =& DAORegistry::getDAO('ReviewFormDAO');
		$reviewFormTitles = array();

		foreach ($reviewAssignments as $reviewAssignment) {
			$reviewForm =& $reviewFormDao->getReviewForm($reviewAssignment->getReviewFormId());
			if ($reviewForm) {
				$reviewFormTitles[$reviewForm->getId()] = $reviewForm->getLocalizedTitle();
			}
			unset($reviewForm);
			$reviewFormResponses[$reviewAssignment->getId()] = $reviewFormResponseDao->reviewFormResponseExists($reviewAssignment->getId());
		}			
				
		$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
		$ercReviewers =& $ercReviewersDao->getReviewersBySectionId($journal->getId(), $lastDecision->getSectionId());
			
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('reviewers', $ercReviewers);
		//$templateMgr->assign_by_ref('extReviewers', $extReviewers);
		$templateMgr->assign_by_ref('reviewAssignmentCount', count($reviewAssignments));
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('reviewIndexes', $reviewAssignmentDao->getReviewIndexesForDecision($lastDecision->getId()));
		$templateMgr->assign_by_ref('reviewAssignments', $reviewAssignments);
		$templateMgr->assign('reviewFormResponses', $reviewFormResponses);
		$templateMgr->assign('reviewFormTitles', $reviewFormTitles);
		$templateMgr->assign('sectionId', $submission->getSectionId());
		$templateMgr->assign_by_ref('notifyReviewerLogs', $notifyReviewerLogs);
		$templateMgr->assign_by_ref('submissionFile', $submission->getSubmissionFile());	
        $templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());
		$templateMgr->assign_by_ref('suppFiles', $submission->getSuppFiles());
		$templateMgr->assign_by_ref('reviewFile', $submission->getReviewFile());
		$templateMgr->assign_by_ref('previousFiles', $submission->getPreviousFiles());
		$templateMgr->assign_by_ref('copyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL'));
		$templateMgr->assign_by_ref('revisedFile', $submission->getRevisedFile());
		$templateMgr->assign_by_ref('editorFile', $submission->getEditorFile());
		$templateMgr->assign('rateReviewerOnQuality', $journal->getSetting('rateReviewerOnQuality'));
		$templateMgr->assign_by_ref('sections', $sections->toArray());
		$templateMgr->assign('sectionDecisionOptions',SectionEditorSubmission::getEditorDecisionOptions());
		
		$templateMgr->assign('initialReviewOptions',SectionEditorSubmission::getInitialReviewOptions());
		$templateMgr->assign('exemptionOptions',SectionEditorSubmission::getExemptionOptions());
		$templateMgr->assign('continuingReviewOptions',SectionEditorSubmission::getContinuingReviewOptions());
		$templateMgr->assign('articleMoreRecent', $articleMoreRecent);
		$templateMgr->assign('lastDecision', $lastDecision);
		$templateMgr->assign('reasonsForExemption', $reasons);
		$templateMgr->assign_by_ref('reasonsMap', $reasonsMap);
		
		import('classes.submission.reviewAssignment.ReviewAssignment');
		$templateMgr->assign_by_ref('reviewerRecommendationOptions', ReviewAssignment::getReviewerRecommendationOptions());
		$templateMgr->assign_by_ref('reviewerRatingOptions', ReviewAssignment::getReviewerRatingOptions());
		
		// Not currently used
		//$templateMgr->assign('allowRecommendation', $allowRecommendation);
		//$templateMgr->assign('allowResubmit', $allowResubmit);
		//$templateMgr->assign('allowCopyedit', $allowCopyedit);

		$templateMgr->assign('articleId', $submission->getId());
		
		// Set up required Payment Related Information
		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		if ( $paymentManager->submissionEnabled() || $paymentManager->fastTrackEnabled() || $paymentManager->publicationEnabled()) {
			$templateMgr->assign('authorFees', true);
			$completedPaymentDAO =& DAORegistry::getDAO('OJSCompletedPaymentDAO');

			if ( $paymentManager->submissionEnabled() ) {
				$templateMgr->assign_by_ref('submissionPayment', $completedPaymentDAO->getSubmissionCompletedPayment ( $journal->getId(), $articleId ));
			}

			if ( $paymentManager->fastTrackEnabled()  ) {
				$templateMgr->assign_by_ref('fastTrackPayment', $completedPaymentDAO->getFastTrackCompletedPayment ( $journal->getId(), $articleId ));
			}

			if ( $paymentManager->publicationEnabled()  ) {
				$templateMgr->assign_by_ref('publicationPayment', $completedPaymentDAO->getPublicationCompletedPayment ( $journal->getId(), $articleId ));
			}
		}
		
		// Added by EL on March 13th 2013
		// Provide links to meetings
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meetings =& $meetingDao->getMeetingsBySubmissionId($articleId);
		$templateMgr->assign('meetingsCount', count($meetings));
		$templateMgr->assign_by_ref('meetings', $meetings);
		
		$templateMgr->assign('helpTopicId', 'editorial.sectionEditorsRole.review');
		$templateMgr->display('sectionEditor/submissionReview.tpl');
	}

	function submissionEditing($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$journal =& Request::getJournal();
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId);

		$useCopyeditors = $journal->getSetting('useCopyeditors');
		$useLayoutEditors = $journal->getSetting('useLayoutEditors');
		$useProofreaders = $journal->getSetting('useProofreaders');

		// check if submission is accepted
		$sectionDecisions = $submission->getDecisions();
		$lastDecision = count($sectionDecisions) >= 1 ? $sectionDecisions[count($sectionDecisions) - 1]['decision'] : null;
		$submissionAccepted = ($lastDecision == SUBMISSION_SECTION_DECISION_APPROVED) ? true : false;

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('submissionFile', $submission->getSubmissionFile());
		$templateMgr->assign_by_ref('copyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL'));
		$templateMgr->assign_by_ref('initialCopyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_INITIAL'));
		$templateMgr->assign_by_ref('editorAuthorCopyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_AUTHOR'));
		$templateMgr->assign_by_ref('finalCopyeditFile', $submission->getFileBySignoffType('SIGNOFF_COPYEDITING_FINAL'));
		$templateMgr->assign_by_ref('suppFiles', $submission->getSuppFiles());
		$templateMgr->assign_by_ref('copyeditor', $submission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL'));

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$user =& Request::getUser();
		$templateMgr->assign('isEditor', $roleDao->roleExists($journal->getId(), $user->getId(), ROLE_ID_EDITOR));

		import('classes.issue.IssueAction');
		$templateMgr->assign('issueOptions', IssueAction::getIssueOptions());
		$publishedArticleDao =& DAORegistry::getDAO('PublishedArticleDAO');
		$publishedArticle =& $publishedArticleDao->getPublishedArticleByArticleId($submission->getId());
		$templateMgr->assign_by_ref('publishedArticle', $publishedArticle);

		$templateMgr->assign('useCopyeditors', $useCopyeditors);
		$templateMgr->assign('useLayoutEditors', $useLayoutEditors);
		$templateMgr->assign('useProofreaders', $useProofreaders);
		$templateMgr->assign('submissionAccepted', $submissionAccepted);

		// Set up required Payment Related Information
		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		$completedPaymentDAO =& DAORegistry::getDAO('OJSCompletedPaymentDAO');

		$publicationFeeEnabled = $paymentManager->publicationEnabled();
		$templateMgr->assign('publicatonFeeEnabled',  $publicationFeeEnabled);
		if ( $publicationFeeEnabled ) {
			$templateMgr->assign_by_ref('publicationPayment', $completedPaymentDAO->getPublicationCompletedPayment ( $journal->getId(), $articleId ));
		}

		$templateMgr->assign('helpTopicId', 'editorial.sectionEditorsRole.editing');
		$templateMgr->display('sectionEditor/submissionEditing.tpl');
	}

	/**
	 * View submission history
	 */
	function submissionHistory($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;

		$this->setupTemplate(1, $articleId);

		// submission notes
		$noteDao =& DAORegistry::getDAO('NoteDAO');

		$submissionNotes =& $noteDao->getByAssoc(ASSOC_TYPE_ARTICLE, $articleId);

		import('classes.article.log.ArticleLog');
		$rangeInfo =& Handler::getRangeInfo('eventLogEntries');
		$eventLogEntries =& ArticleLog::getEventLogEntries($articleId, $rangeInfo);
		$rangeInfo =& Handler::getRangeInfo('emailLogEntries');
		$emailLogEntries =& ArticleLog::getEmailLogEntries($articleId, $rangeInfo);

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('isEditor', Validation::isEditor());
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('eventLogEntries', $eventLogEntries);
		$templateMgr->assign_by_ref('emailLogEntries', $emailLogEntries);
		$templateMgr->assign_by_ref('submissionNotes', $submissionNotes);

		$templateMgr->display('sectionEditor/submissionHistory.tpl');
	}

	/**
	 * Display the citation editing assistant.
	 * @param $args array
	 * @param $request Request
	 */
	function submissionCitations($args, $request) {
		// Authorize the request.
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);

		// Prepare the view.
		$this->setupTemplate(1, $articleId);

		// Insert the citation editing assistant into the view.
		SectionEditorAction::editCitations($request, $this->submission);

		// Render the view.
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->display('sectionEditor/submissionCitations.tpl');
	}

	function changeSection() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;

		$sectionId = Request::getUserVar('sectionId');

		SectionEditorAction::changeSection($submission, $sectionId);

		Request::redirect(null, null, 'submission', $articleId);
	}

	/**	 
	 * Record editor decision (Added additional editor decision cases)
	 * Edited by aglet
	 * Last Update: 5/5/2011
	 */

	function recordDecision() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$approvalDate = Request::getUserVar('approvalDate'); 
		
		$fileName = "finalDecisionFile";
		if(($submission->getSubmissionStatus() == PROPOSAL_STATUS_EXPEDITED || $submission->getSubmissionStatus() == PROPOSAL_STATUS_FULL_REVIEW) && isset($_FILES[$fileName])) {			
			if (SectionEditorAction::uploadDecisionFile($articleId, $fileName, $submission->getLastSectionDecisionId()) == '0') Request::redirect(null, null, 'submissionReview', $articleId);
				
		}
		
		$decision = Request::getUserVar('decision');
		$sectionDecisionDao =& DAORegistry::getDAO("SectionDecisionDAO");
		$previousDecision =& $sectionDecisionDao->getLastSectionDecision($articleId);
		
		//pass lastDecisionId of this article to update existing row in section_decisions
		if (isset($previousDecision)) {
			if ($previousDecision->getDecision() == SUBMISSION_SECTION_DECISION_APPROVED
				|| $previousDecision->getDecision() == SUBMISSION_SECTION_DECISION_RESUBMIT
				|| $previousDecision->getDecision() == SUBMISSION_SECTION_DECISION_DECLINED
				|| $previousDecision->getDecision() == SUBMISSION_SECTION_DECISION_EXEMPTED
				|| $previousDecision->getDecision() == SUBMISSION_SECTION_DECISION_DONE)
			$lastDecisionId = null;
			else $lastDecisionId = $previousDecision->getId();
		} else $lastDecisionId = null;
		
		switch ($submission->getStatus()) {
			case STATUS_QUEUED:
				$reviewType = REVIEW_TYPE_INITIAL;
				break;
			case STATUS_QUEUED_CR:
				$reviewType = REVIEW_TYPE_CONTINUING;
				break;
			case STATUS_QUEUED_PA:
				$reviewType = REVIEW_TYPE_AMENDMENT;
				break;
			case STATUS_QUEUED_SAE:
				$reviewType = REVIEW_TYPE_SAE;
				break;
			case STATUS_QUEUED_EOS:
				$reviewType = REVIEW_TYPE_EOS;
				break;
		}
		
		$round = $sectionDecisionDao->getRound($articleId, $reviewType);
		
		switch ($decision) {
			case SUBMISSION_SECTION_DECISION_APPROVED:
			case SUBMISSION_SECTION_DECISION_RESUBMIT:
			case SUBMISSION_SECTION_DECISION_DECLINED:
			case SUBMISSION_SECTION_DECISION_EXEMPTED:
			case SUBMISSION_SECTION_DECISION_FULL_REVIEW:
			case SUBMISSION_SECTION_DECISION_EXPEDITED:
			case SUBMISSION_SECTION_DECISION_COMPLETE:
			case SUBMISSION_SECTION_DECISION_INCOMPLETE:
			case SUBMISSION_SECTION_DECISION_DONE:
				if ($reviewType) SectionEditorAction::recordDecision($submission, $decision, $reviewType, $round, $approvalDate, $lastDecisionId);
				break;
		}
		
		/*Do not start new round of review
		if($decision == SUBMISSION_SECTION_DECISION_RESUBMIT) {
			SectionEditorAction::initiateNewReviewRound($submission);
		}
		*/
		switch ($decision) {
			case SUBMISSION_SECTION_DECISION_APPROVED:
			case SUBMISSION_SECTION_DECISION_DECLINED:
			case SUBMISSION_SECTION_DECISION_INCOMPLETE:
			case SUBMISSION_SECTION_DECISION_EXEMPTED:
				SubmissionCommentsHandler::emailEditorDecisionComment($articleId);
				break;
			default:
				Request::redirect(null, null, 'submissionReview', $articleId);
			break;
		}
	}
	
	/**
	 * If proposal is exempted, record reasons for exemption
	 */
	function recordReasonsForExemption($args, $request) {
		$decision = Request::getUserVar('decision');
		if($decision == SUBMISSION_SECTION_DECISION_EXEMPTED) {
			$articleId = Request::getUserVar('articleId');			
			$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
			$submission =& $this->submission;
			$selectedReasons = Request::getUserVar('exemptionReasons');
			$reasons = 0;
			foreach($selectedReasons as $reason) {
				$reasons = $reasons + (int) $reason;
			}
			if ($reasons != 0){
				$submission->setReasonsForExemption($reasons, null);			
				$articleDao =& DAORegistry::getDAO('ArticleDAO');
				if($articleDao->insertReasonsForExemption($submission, $reasons)) {
					Request::redirect(null, null, 'submissionReview', $articleId);
				}
			} else Request::redirect(null, null, 'submissionReview', $articleId);
		}		
	}
	
	function selectReviewers($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$journal =& Request::getJournal();
		$sectionEditorSubmission =& $this->submission;		
		$selectedReviewers = Request::getUserVar('selectedReviewers');
		
		foreach($selectedReviewers as $reviewerId) {
			SectionEditorAction::addReviewer($sectionEditorSubmission->getLastSectionDecisionId(), $reviewerId);

		}
		
		Request::redirect(null, null, 'notifyReviewers', $articleId);
	}
	
	/**
	 * Peer Review
	 * Last modified: EL on February 16h 2013
	 * Separation of External reviewers and ERC Members
	**/

	function selectReviewer($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$reviewerId = isset($args[1]) && $args[1]!=null ? (int) $args[1] : 0;
		$extReviewers = isset($args[2]) && $args[2]!=null ? (boolean) $args[2] : false;
		
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$journal =& Request::getJournal();
		$submission =& $this->submission;

		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'reviewerName';
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == SORT_DIRECTION_ASC || $sortDirection == SORT_DIRECTION_DESC)) ? $sortDirection : SORT_DIRECTION_ASC;

		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');

		if ($reviewerId > 0) {
			// Assign reviewer to article
			SectionEditorAction::addReviewer($submission->getLastSectionDecisionId(), $reviewerId);
			
			//Notify reviewer and send email by default
			$reviewId = $sectionEditorSubmissionDao->getReviewAssignmentIdByDecisionAndReviewer($submission->getLastSectionDecisionId(), $reviewerId);
			SectionEditorAction::notifyReviewer($submission, $reviewId, true);
			Request::redirect(null, null, 'submissionReview', $articleId);

			// FIXME: Prompt for due date.
		} else {
			$this->setupTemplate(1, $articleId, 'review');
				
			$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');

			$searchType = null;
			$searchMatch = null;
			
			$search = $searchQuery = Request::getUserVar('search');
			$searchInitial = Request::getUserVar('searchInitial');
			
			if (!$extReviewers) {
				$extReviewers = Request::getUserVar('extReviewers');
				if ($extReviewers == "false") $extReviewers = false;
				elseif ($extReviewers == "true") $extReviewers = true;
			}
			
			if (!empty($search)) {
				$searchType = Request::getUserVar('searchField');
				$searchMatch = Request::getUserVar('searchMatch');
			} elseif (!empty($searchInitial)) {
				$searchInitial = String::strtoupper($searchInitial);
				$searchType = USER_FIELD_INITIAL;
				$search = $searchInitial;
			}
			$lastDecision =& $submission->getLastSectionDecision();
			$rangeInfo =& Handler::getRangeInfo('reviewers');
			$reviewers = $sectionEditorSubmissionDao->getReviewersForArticle($journal->getId(), $lastDecision->getId(), $lastDecision->getSectionId(), $extReviewers, $searchType, $search, $searchMatch, $rangeInfo, $sort, $sortDirection);
						
			$journal = Request::getJournal();
			$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
			$sectionDao =& DAORegistry::getDAO('SectionDAO');
			$erc =& $sectionDao->getSection($submission->getSectionId());
			
			$templateMgr =& TemplateManager::getManager();

			$templateMgr->assign_by_ref('submission', $submission);
			$templateMgr->assign('ercAbbrev', $erc->getLocalizedAbbrev());
			$templateMgr->assign('extReviewers', $extReviewers);
			$templateMgr->assign('searchField', $searchType);
			$templateMgr->assign('searchMatch', $searchMatch);
			$templateMgr->assign('search', $searchQuery);
			$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));
		
			$templateMgr->assign_by_ref('reviewers', $reviewers);
			$templateMgr->assign('articleId', $articleId);
			$templateMgr->assign('reviewerStatistics', $sectionEditorSubmissionDao->getReviewerStatistics());
			$templateMgr->assign('fieldOptions', Array(
				USER_FIELD_INTERESTS => 'user.interests',
				USER_FIELD_FIRSTNAME => 'user.firstName',
				USER_FIELD_LASTNAME => 'user.lastName',
				USER_FIELD_USERNAME => 'user.username',
				USER_FIELD_EMAIL => 'user.email'
			));
			$templateMgr->assign('completedReviewCounts', $reviewAssignmentDao->getCompletedReviewCounts($journal->getId()));
			$templateMgr->assign('rateReviewerOnQuality', $journal->getSetting('rateReviewerOnQuality'));
			$templateMgr->assign('averageQualityRatings', $reviewAssignmentDao->getAverageQualityRatings($journal->getId()));

			$templateMgr->assign('helpTopicId', 'journal.roles.reviewer');
			$templateMgr->assign('alphaList', explode(' ', Locale::translate('common.alphaList')));
			$templateMgr->assign('reviewerDatabaseLinks', $journal->getSetting('reviewerDatabaseLinks'));
			$templateMgr->assign('sort', $sort);
			$templateMgr->assign('sortDirection', $sortDirection);
			$templateMgr->display('sectionEditor/selectReviewer.tpl');
		}
	}

	/**
	 * Get a suggested username, making sure it's not
	 * already used by the system. (Poor-man's AJAX.)
	 */
	function suggestUsername() {
		parent::validate();
		$suggestion = Validation::suggestUsername(
			Request::getUserVar('firstName'),
			Request::getUserVar('lastName')
		);
		echo $suggestion;
	}

	function notifyReviewers($args = array()) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		$lastDecision =& $submission->getLastSectionDecision();
		$reviewAssignments = $lastDecision->getReviewAssignments();
		
		//send emails by default
		foreach($reviewAssignments as $reviewAssignment) {			
			SectionEditorAction::notifyReviewer($submission, $reviewAssignment->getId(), true);
		}
		
		Request::redirect(null, null, 'submissionReview', $articleId);
	}
	
	function notifyReviewer($args = array()) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$reviewId = isset($args[1]) ? $args[1] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		
		//send emails by default
		SectionEditorAction::notifyReviewer($submission, $reviewId, true);
		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function clearReview($args) {
		$articleId = isset($args[0])?$args[0]:0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = $args[1];

		SectionEditorAction::clearReview($submission->getLastSectionDecision(), $reviewId);

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function cancelReview($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = Request::getUserVar('reviewId');

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'review');

		if (SectionEditorAction::cancelReview($submission, $reviewId, $send)) {
			Request::redirect(null, null, 'submissionReview', $articleId);
		}
	}

	function remindReviewer($args = null) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = Request::getUserVar('reviewId');
		$this->setupTemplate(1, $articleId, 'review');

		if (SectionEditorAction::remindReviewer($submission, $reviewId, Request::getUserVar('send'))) {
			Request::redirect(null, null, 'submissionReview', $articleId);
		}
	}

	function thankReviewer($args = array()) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = Request::getUserVar('reviewId');

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'review');

		if (SectionEditorAction::thankReviewer($submission, $reviewId, $send)) {
			Request::redirect(null, null, 'submissionReview', $articleId);
		}
	}

	function rateReviewer() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$this->setupTemplate(1, $articleId, 'review');

		$reviewId = Request::getUserVar('reviewId');
		$quality = Request::getUserVar('quality');

		SectionEditorAction::rateReviewer($articleId, $reviewId, $quality);

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function confirmReviewForReviewer($args) {
		$articleId = (int) isset($args[0])?$args[0]:0;
		$accept = Request::getUserVar('accept')?true:false;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = (int) isset($args[1])?$args[1]:0;

		SectionEditorAction::confirmReviewForReviewer($reviewId, $accept);
		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function uploadReviewForReviewer($args) {
		$articleId = (int) Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = (int) Request::getUserVar('reviewId');

		SectionEditorAction::uploadReviewForReviewer($reviewId);
		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function makeReviewerFileViewable() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = Request::getUserVar('reviewId');
		$fileId = Request::getUserVar('fileId');
		$viewable = Request::getUserVar('viewable');

		SectionEditorAction::makeReviewerFileViewable($articleId, $reviewId, $fileId, $viewable);

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function setDueDateForAll($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$dueDate = Request::getUserVar('dueDate');
		$numWeeks = null;
		$lastDecision =& $submission->getLastSectionDecision();
		if ($dueDate != null) {
			foreach ($lastDecision->getReviewAssignments() as $reviewAssignment) {
				if ( ($reviewId = $reviewAssignment->getId()) > 0) {
					SectionEditorAction::setDueDate($articleId, $reviewId, $dueDate, $numWeeks);		
				}			
			}
			Request::redirect(null, null, 'submissionReview', $articleId);
		} else {
			$this->setupTemplate(1, $articleId, 'review');
			$journal =& Request::getJournal();

			$templateMgr =& TemplateManager::getManager();	
			$templateMgr->assign('articleId', $articleId);
			$templateMgr->assign_by_ref('submission', $submission);
			$templateMgr->assign('todaysDate', date('Y-m-d'));
			$templateMgr->display('sectionEditor/setDueDateForAll.tpl');
		}
	}
	
	function setDueDate($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = isset($args[1]) ? $args[1] : 0;
		$dueDate = Request::getUserVar('dueDate');
		$numWeeks = Request::getUserVar('numWeeks');
//		$meetingDate = Request::getUserVar('meetingDate');

		if ($dueDate != null || $numWeeks != null ) {
			SectionEditorAction::setDueDate($articleId, $reviewId, $dueDate, $numWeeks);
			Request::redirect(null, null, 'submissionReview', $articleId);

		} else {
			$this->setupTemplate(1, $articleId, 'review');
			$journal =& Request::getJournal();

			$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
			$reviewAssignment = $reviewAssignmentDao->getById($reviewId);

			$settingsDao =& DAORegistry::getDAO('JournalSettingsDAO');
			$settings =& $settingsDao->getJournalSettings($journal->getId());

			$templateMgr =& TemplateManager::getManager();

			if ($reviewAssignment->getDateDue() != null) {
				$templateMgr->assign('dueDate', $reviewAssignment->getDateDue());
			}
//			/** Added by ayveemallare 6/28/2011 */
//			if ($reviewAssignment->getDateOfMeeting() !=null) {
//				$templateMgr->assign('meetingDate', $reviewAssignment->getDateOfMeeting());
//			}
//			/*************************************/
			
			$numWeeksPerReview = $settings['numWeeksPerReview'] == null ? 0 : $settings['numWeeksPerReview'];

			$templateMgr->assign('articleId', $articleId);
			$templateMgr->assign('reviewId', $reviewId);
			$templateMgr->assign('todaysDate', date('Y-m-d'));
			$templateMgr->assign('numWeeksPerReview', $numWeeksPerReview);
			$templateMgr->assign('actionHandler', 'setDueDate');

			$templateMgr->display('sectionEditor/setDueDate.tpl');
		}
	}

	function enterReviewerRecommendation($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = Request::getUserVar('reviewId');

		$recommendation = Request::getUserVar('recommendation');

		if ($recommendation != null) {
			SectionEditorAction::setReviewerRecommendation($articleId, $reviewId, $recommendation, SUBMISSION_REVIEWER_RECOMMENDATION_ACCEPT);
			Request::redirect(null, null, 'submissionReview', $articleId);
		} else {
			$this->setupTemplate(1, $articleId, 'review');

			$templateMgr =& TemplateManager::getManager();

			$templateMgr->assign('articleId', $articleId);
			$templateMgr->assign('reviewId', $reviewId);

			import('classes.submission.reviewAssignment.ReviewAssignment');
			$templateMgr->assign_by_ref('reviewerRecommendationOptions', ReviewAssignment::getReviewerRecommendationOptions());

			$templateMgr->display('sectionEditor/reviewerRecommendation.tpl');
		}
	}
	
	/**
	 * Display a user's profile.
	 * @param $args array first parameter is the ID or username of the user to display
	 */
	function userProfile($args) {
		parent::validate();
		$this->setupTemplate();

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('currentUrl', Request::url(null, Request::getRequestedPage()));

		$userDao =& DAORegistry::getDAO('UserDAO');
		$userId = isset($args[0]) ? $args[0] : 0;
		if (is_numeric($userId)) {
			$userId = (int) $userId;
			$user = $userDao->getUser($userId);
		} else {
			$user = $userDao->getUserByUsername($userId);
		}


		if ($user == null) {
			// Non-existent user requested
			$templateMgr->assign('pageTitle', 'manager.people');
			$templateMgr->assign('errorMsg', 'manager.people.invalidUser');
			$templateMgr->display('common/error.tpl');

		} else {
			$site =& Request::getSite();
			$journal =& Request::getJournal();

			$countryDao =& DAORegistry::getDAO('CountryDAO');
			$country = null;
			if ($user->getCountry() != '') {
				$country = $countryDao->getCountry($user->getCountry());
			}
			$templateMgr->assign('country', $country);

			$templateMgr->assign_by_ref('user', $user);
			$templateMgr->assign('localeNames', Locale::getAllLocales());
			$templateMgr->assign('helpTopicId', 'journal.roles.index');
			$templateMgr->display('sectionEditor/userProfile.tpl');
		}
	}

	function viewMetadata($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_AUTHOR));
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'summary');

		SectionEditorAction::viewMetadata($submission, $journal);
	}

	function saveMetadata($args, &$request) {
		$articleId = $request->getUserVar('articleId');
		$this->validate($articleId);
		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_AUTHOR));
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'summary');

		if (SectionEditorAction::saveMetadata($submission, $request)) {
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

	//
	// Review Form
	//

	/**
	 * Preview a review form.
	 * @param $args array ($reviewId, $reviewFormId)
	 */
	function previewReviewForm($args) {
		parent::validate();
		$this->setupTemplate(1);

		$reviewId = isset($args[0]) ? (int) $args[0] : null;
		$reviewFormId = isset($args[1]) ? (int)$args[1] : null;

		$journal =& Request::getJournal();
		$reviewFormDao =& DAORegistry::getDAO('ReviewFormDAO');
		$reviewForm =& $reviewFormDao->getReviewForm($reviewFormId, ASSOC_TYPE_JOURNAL, $journal->getId());
		$reviewFormElementDao =& DAORegistry::getDAO('ReviewFormElementDAO');
		$reviewFormElements =& $reviewFormElementDao->getReviewFormElements($reviewFormId);
		$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
		$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);
		$sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
		$sectionDecision =& $sectionDecisionDao->getSectionDecision($reviewAssignment->getDecisionId());
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('pageTitle', 'manager.reviewForms.preview');
		$templateMgr->assign_by_ref('reviewForm', $reviewForm);
		$templateMgr->assign('reviewFormElements', $reviewFormElements);
		$templateMgr->assign('reviewId', $reviewId);
		$templateMgr->assign('articleId', $sectionDecision->getArticleId());
		//$templateMgr->assign('helpTopicId','journal.managementPages.reviewForms');
		$templateMgr->display('sectionEditor/previewReviewForm.tpl');
	}

	/**
	 * Clear a review form, i.e. remove review form assignment to the review.
	 * @param $args array ($articleId, $reviewId)
	 */
	function clearReviewForm($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$reviewId = isset($args[1]) ? (int) $args[1] : null;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		SectionEditorAction::clearReviewForm($submission, $reviewId);

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	/**
	 * Select a review form
	 * @param $args array ($articleId, $reviewId, $reviewFormId)
	 */
	function selectReviewForm($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$reviewId = isset($args[1]) ? (int) $args[1] : null;
		$reviewFormId = isset($args[2]) ? (int) $args[2] : null;

		if ($reviewFormId != null) {
			SectionEditorAction::addReviewForm($submission, $reviewId, $reviewFormId);
			Request::redirect(null, null, 'submissionReview', $articleId);
		} else {
			$journal =& Request::getJournal();
			$rangeInfo =& Handler::getRangeInfo('reviewForms');
			$reviewFormDao =& DAORegistry::getDAO('ReviewFormDAO');
			$reviewForms =& $reviewFormDao->getActiveByAssocId(ASSOC_TYPE_JOURNAL, $journal->getId(), $rangeInfo);
			$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
			$reviewAssignment =& $reviewAssignmentDao->getById($reviewId);

			$this->setupTemplate(1, $articleId, 'review');
			$templateMgr =& TemplateManager::getManager();

			$templateMgr->assign('articleId', $articleId);
			$templateMgr->assign('reviewId', $reviewId);
			$templateMgr->assign('assignedReviewFormId', $reviewAssignment->getReviewFormId());
			$templateMgr->assign_by_ref('reviewForms', $reviewForms);
			//$templateMgr->assign('helpTopicId','journal.managementPages.reviewForms');
			$templateMgr->display('sectionEditor/selectReviewForm.tpl');
		}
	}

	/**
	 * View review form response.
	 * @param $args array ($articleId, $reviewId)
	 */
	function viewReviewFormResponse($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'editing');

		$reviewId = isset($args[1]) ? (int) $args[1] : null;

		SectionEditorAction::viewReviewFormResponse($submission, $reviewId);
	}

	//
	// Editor Review
	//
	/* Not currently used
	function editorReview() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$redirectTarget = 'submissionReview';

		// If the Upload button was pressed.
		$submit = Request::getUserVar('submit');
		if ($submit != null) {
			SectionEditorAction::uploadEditorVersion($submission);
		}

		if (Request::getUserVar('setCopyeditFile')) {
			// If the Send To Copyedit button was pressed
			$file = explode(',', Request::getUserVar('sectionDecisionFile'));
			if (isset($file[0]) && isset($file[1])) {
				$round = $submission->getCurrentRound();
				if ($submission->getMostRecentEditorDecisionComment()) {
					// The conditions are met for being able
					// to send a file to copyediting.
					SectionEditorAction::setCopyeditFile($submission, $file[0], $file[1]);

					$signoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $submission->getId());
					$signoff->setFileId($file[0]);
					$signoff->setFileRevision($file[1]);
					$signoffDao->updateObject($signoff);
				}
				$redirectTarget = 'submissionEditing';
			}

		} else if (Request::getUserVar('resubmit')) {
			// If the Resubmit button was pressed
			$file = explode(',', Request::getUserVar('sectionDecisionFile'));
			if (isset($file[0]) && isset($file[1])) {
				SectionEditorAction::resubmitFile($submission, $file[0], $file[1]);

				$signoff = $signoffDao->build('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $submission->getId());
				$signoff->setFileId($file[0]);
				$signoff->setFileRevision($file[1]);
				$signoffDao->updateObject($signoff);
			}
		}

		Request::redirect(null, null, $redirectTarget, $articleId);
	}
	*/
	
	//
	// Copyedit
	//

	function selectCopyeditor($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$journal =& Request::getJournal();
		$submission =& $this->submission;

		$roleDao =& DAORegistry::getDAO('RoleDAO');

		if (isset($args[1]) && $args[1] != null && $roleDao->roleExists($journal->getId(), $args[1], ROLE_ID_COPYEDITOR)) {
			SectionEditorAction::selectCopyeditor($submission, $args[1]);
			Request::redirect(null, null, 'submissionEditing', $articleId);
		} else {
			$this->setupTemplate(1, $articleId, 'editing');

			$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');

			$searchType = null;
			$searchMatch = null;
			$search = $searchQuery = Request::getUserVar('search');
			$searchInitial = Request::getUserVar('searchInitial');
			if (!empty($search)) {
				$searchType = Request::getUserVar('searchField');
				$searchMatch = Request::getUserVar('searchMatch');

			} elseif (!empty($searchInitial)) {
				$searchInitial = String::strtoupper($searchInitial);
				$searchType = USER_FIELD_INITIAL;
				$search = $searchInitial;
			}

			$copyeditors = $roleDao->getUsersByRoleId(ROLE_ID_COPYEDITOR, $journal->getId(), $searchType, $search, $searchMatch);
			$copyeditorStatistics = $sectionEditorSubmissionDao->getCopyeditorStatistics($journal->getId());

			$templateMgr =& TemplateManager::getManager();

			$templateMgr->assign('searchField', $searchType);
			$templateMgr->assign('searchMatch', $searchMatch);
			$templateMgr->assign('search', $searchQuery);
			$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));

			$templateMgr->assign_by_ref('users', $copyeditors);
			$templateMgr->assign('currentUser', $submission->getUserBySignoffType('SIGNOFF_COPYEDITING_INITIAL'));
			$templateMgr->assign_by_ref('statistics', $copyeditorStatistics);
			$templateMgr->assign('pageSubTitle', 'editor.article.selectCopyeditor');
			$templateMgr->assign('pageTitle', 'user.role.copyeditors');
			$templateMgr->assign('actionHandler', 'selectCopyeditor');
			$templateMgr->assign('fieldOptions', Array(
				USER_FIELD_FIRSTNAME => 'user.firstName',
				USER_FIELD_LASTNAME => 'user.lastName',
				USER_FIELD_USERNAME => 'user.username',
				USER_FIELD_EMAIL => 'user.email'
			));
			$templateMgr->assign('articleId', $args[0]);

			$templateMgr->assign('helpTopicId', 'journal.roles.copyeditor');
			$templateMgr->assign('alphaList', explode(' ', Locale::translate('common.alphaList')));
			$templateMgr->display('sectionEditor/selectUser.tpl');
		}
	}

	function notifyCopyeditor($args = array()) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::notifyCopyeditor($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/* Initiates the copyediting process when the editor does the copyediting */
	function initiateCopyedit() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		SectionEditorAction::initiateCopyedit($submission);
		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	function thankCopyeditor($args = array()) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::thankCopyeditor($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	function notifyAuthorCopyedit($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::notifyAuthorCopyedit($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	function thankAuthorCopyedit($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::thankAuthorCopyedit($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	function notifyFinalCopyedit($args = array()) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::notifyFinalCopyedit($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	function completeCopyedit($args) {
		$articleId = (int) Request::getUserVar('articleId');

		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		SectionEditorAction::completeCopyedit($submission);
		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	function completeFinalCopyedit($args) {
		$articleId = (int) Request::getUserVar('articleId');

		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		SectionEditorAction::completeFinalCopyedit($submission);
		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	function thankFinalCopyedit($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::thankFinalCopyedit($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	function uploadReviewVersion() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;

		SectionEditorAction::uploadReviewVersion($submission);

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	function uploadCopyeditVersion() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$copyeditStage = Request::getUserVar('copyeditStage');
		SectionEditorAction::uploadCopyeditVersion($submission, $copyeditStage);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Add a supplementary file.
	 * @param $args array ($articleId)
	 */
	function addSuppFile($args, $request) {
		$articleId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'summary');

		import('classes.submission.form.SuppFileForm');

		$submitForm = new SuppFileForm($submission, $journal);

		if ($submitForm->isLocaleResubmit()) {
			$submitForm->readInputData();
		} else {
			$submitForm->initData();
		}
		$submitForm->display();
	}

	/**
	 * Edit a supplementary file.
	 * @param $args array ($articleId, $suppFileId)
	 */
	function editSuppFile($args, $request) {
		$articleId = (int) array_shift($args);
		$suppFileId = (int) array_shift($args);
		$journal =& $request->getJournal();

		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'summary');

		import('classes.submission.form.SuppFileForm');

		$submitForm = new SuppFileForm($submission, $journal, $suppFileId);

		if ($submitForm->isLocaleResubmit()) {
			$submitForm->readInputData();
		} else {
			$submitForm->initData();
		}
		$submitForm->display();
	}

	/**
	 * Set reviewer visibility for a supplementary file.
	 * @param $args array ($suppFileId)
	 */
	function setSuppFileVisibility($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;

		$suppFileId = Request::getUserVar('fileId');
		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$suppFile = $suppFileDao->getSuppFile($suppFileId, $articleId);

		if (isset($suppFile) && $suppFile != null) {
			$suppFile->setShowReviewers(Request::getUserVar('show')==1?1:0);
			$suppFileDao->updateSuppFile($suppFile);
		}
		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	/**
	 * Save a supplementary file.
	 * @param $args array ($suppFileId)
	 */
	function saveSuppFile($args, $request) {
		$articleId = $request->getUserVar('articleId');
		$this->validate($articleId);
		$this->setupTemplate(1, $articleId, 'summary');
		$submission =& $this->submission;

		$suppFileId = (int) array_shift($args);
		$journal =& $request->getJournal();

		import('classes.submission.form.SuppFileForm');

		$submitForm = new SuppFileForm($submission, $journal, $suppFileId);
		$submitForm->readInputData();

		if ($submitForm->validate()) {
			$submitForm->execute();

			// Send a notification to associated users
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$article =& $articleDao->getArticle($articleId);
			$notificationUsers = $article->getAssociatedUserIds(true, false);
			foreach ($notificationUsers as $userRole) {
				$url = $request->url(null, $userRole['role'], 'submissionEditing', $article->getId(), null, 'layout');
				$notificationManager->createNotification(
					$userRole['id'], 'notification.type.suppFileModified',
					$article->getLocalizedProposalId(), $url, 1, NOTIFICATION_TYPE_SUPP_FILE_MODIFIED
				);
			}

			$request->redirect(null, null, $this->getFrom(), $articleId);
		} else {
			$submitForm->display();
		}
	}

	/**
	 * Delete an editor version file.
	 * @param $args array ($articleId, $fileId)
	 */
	function deleteArticleFile($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$fileId = isset($args[1]) ? (int) $args[1] : 0;

		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$submission =& $this->submission;
		SectionEditorAction::deleteArticleFile($submission, $fileId);

		Request::redirect(null, null, 'submissionReview', $articleId);
	}

	/**
	 * Delete a supplementary file.
	 * @param $args array ($articleId, $suppFileId)
	 */
	function deleteSuppFile($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$suppFileId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;

		SectionEditorAction::deleteSuppFile($submission, $suppFileId);

		Request::redirect(null, null, $this->getFrom(), $articleId);
	}

	function archiveSubmission($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;

		SectionEditorAction::archiveSubmission($submission);

		Request::redirect(null, null, 'submission', $articleId);
	}

	function restoreToQueue($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;

		SectionEditorAction::restoreToQueue($submission);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	function unsuitableSubmission($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'summary');

		if (SectionEditorAction::unsuitableSubmission($submission, $send)) {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}

	/**
	 * Set section ID.
	 * @param $args array ($articleId)
	 */
	function updateSection($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;
		SectionEditorAction::updateSection($submission, Request::getUserVar('section'));
		Request::redirect(null, null, 'submission', $articleId);
	}

	/**
	 * Set RT comments status for article.
	 * @param $args array ($articleId)
	 */
	function updateCommentsStatus($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;
		SectionEditorAction::updateCommentsStatus($submission, Request::getUserVar('commentsStatus'));
		Request::redirect(null, null, 'submission', $articleId);
	}

	//
	// Layout Editing
	//

	/**
	 * Upload a layout file (either layout version, galley, or supp. file).
	 */
	function uploadLayoutFile($args, $request) {
		$layoutFileType = $request->getUserVar('layoutFileType');
		if ($layoutFileType == 'submission') {
			$this->uploadLayoutVersion();

		} else if ($layoutFileType == 'galley') {
			$this->uploadGalley('layoutFile');

		} else if ($layoutFileType == 'supp') {
			$this->uploadSuppFile('layoutFile', $request);

		} else {
			$request->redirect(null, null, $this->getFrom(), Request::getUserVar('articleId'));
		}
	}

	/**
	 * Upload the layout version of the submission file
	 */
	function uploadLayoutVersion() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		SectionEditorAction::uploadLayoutVersion($submission);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Delete an article image.
	 * @param $args array ($articleId, $fileId)
	 */
	function deleteArticleImage($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$fileId = isset($args[2]) ? (int) $args[2] : 0;

		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;
		SectionEditorAction::deleteArticleImage($submission, $fileId);

		Request::redirect(null, null, 'editGalley', array($articleId, $galleyId));
	}

	/**
	 * Assign/reassign a layout editor to the submission.
	 * @param $args array ($articleId, [$userId])
	 */
	function assignLayoutEditor($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$editorId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$journal =& Request::getJournal();
		$submission =& $this->submission;

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		if ($editorId && $roleDao->roleExists($journal->getId(), $editorId, ROLE_ID_LAYOUT_EDITOR)) {
			SectionEditorAction::assignLayoutEditor($submission, $editorId);
			Request::redirect(null, null, 'submissionEditing', $articleId);
		} else {
			$searchType = null;
			$searchMatch = null;
			$search = $searchQuery = Request::getUserVar('search');
			$searchInitial = Request::getUserVar('searchInitial');
			if (!empty($search)) {
				$searchType = Request::getUserVar('searchField');
				$searchMatch = Request::getUserVar('searchMatch');

			} elseif (!empty($searchInitial)) {
				$searchInitial = String::strtoupper($searchInitial);
				$searchType = USER_FIELD_INITIAL;
				$search = $searchInitial;
			}

			$layoutEditors = $roleDao->getUsersByRoleId(ROLE_ID_LAYOUT_EDITOR, $journal->getId(), $searchType, $search, $searchMatch);

			$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
			$layoutEditorStatistics = $sectionEditorSubmissionDao->getLayoutEditorStatistics($journal->getId());

			$this->setupTemplate(1, $articleId, 'editing');

			$templateMgr =& TemplateManager::getManager();

			$templateMgr->assign('searchField', $searchType);
			$templateMgr->assign('searchMatch', $searchMatch);
			$templateMgr->assign('search', $searchQuery);
			$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));
			$templateMgr->assign('alphaList', explode(' ', Locale::translate('common.alphaList')));

			$templateMgr->assign('pageTitle', 'user.role.layoutEditors');
			$templateMgr->assign('pageSubTitle', 'editor.article.selectLayoutEditor');
			$templateMgr->assign('actionHandler', 'assignLayoutEditor');
			$templateMgr->assign('articleId', $articleId);
			$templateMgr->assign_by_ref('users', $layoutEditors);

			$layoutSignoff = $signoffDao->build('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $articleId);
			if ($layoutSignoff) {
				$templateMgr->assign('currentUser', $layoutSignoff->getUserId());
 			}

			$templateMgr->assign('fieldOptions', Array(
				USER_FIELD_FIRSTNAME => 'user.firstName',
				USER_FIELD_LASTNAME => 'user.lastName',
				USER_FIELD_USERNAME => 'user.username',
				USER_FIELD_EMAIL => 'user.email'
			));
			$templateMgr->assign('statistics', $layoutEditorStatistics);
			$templateMgr->assign('helpTopicId', 'journal.roles.layoutEditor');
			$templateMgr->display('sectionEditor/selectUser.tpl');
		}
	}

	/**
	 * Notify the layout editor.
	 */
	function notifyLayoutEditor($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::notifyLayoutEditor($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Thank the layout editor.
	 */
	function thankLayoutEditor($args) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$send = Request::getUserVar('send')?true:false;
		$this->setupTemplate(1, $articleId, 'editing');

		if (SectionEditorAction::thankLayoutEditor($submission, $send)) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Create a new galley with the uploaded file.
	 */
	function uploadGalley($fileName = null) {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		import('classes.submission.form.ArticleGalleyForm');
 		$galleyForm = new ArticleGalleyForm($articleId);
		$galleyId = $galleyForm->execute($fileName);

		Request::redirect(null, null, 'editGalley', array($articleId, $galleyId));
	}

	/**
	 * Edit a galley.
	 * @param $args array ($articleId, $galleyId)
	 */
	function editGalley($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$this->setupTemplate(1, $articleId, 'editing');

		import('classes.submission.form.ArticleGalleyForm');

		$submitForm = new ArticleGalleyForm($articleId, $galleyId);

		if ($submitForm->isLocaleResubmit()) {
			$submitForm->readInputData();
		} else {
			$submitForm->initData();
		}
		$submitForm->display();
	}

	/**
	 * Save changes to a galley.
	 * @param $args array ($articleId, $galleyId)
	 */
	function saveGalley($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate(1, $articleId, 'editing');
		$submission =& $this->submission;

		import('classes.submission.form.ArticleGalleyForm');

		$submitForm = new ArticleGalleyForm($articleId, $galleyId);

		$submitForm->readInputData();
		if ($submitForm->validate()) {
			$submitForm->execute();

			// Send a notification to associated users
			import('lib.pkp.classes.notification.NotificationManager');
			$notificationManager = new NotificationManager();
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$article =& $articleDao->getArticle($articleId);
			$notificationUsers = $article->getAssociatedUserIds(true, false);
			foreach ($notificationUsers as $userRole) {
				$url = Request::url(null, $userRole['role'], 'submissionEditing', $article->getId(), null, 'layout');
				$notificationManager->createNotification(
					$userRole['id'], 'notification.type.galleyModified',
					$article->getLocalizedProposalId(), $url, 1, NOTIFICATION_TYPE_GALLEY_MODIFIED
				);
			}

			if (Request::getUserVar('uploadImage')) {
				$submitForm->uploadImage();
				Request::redirect(null, null, 'editGalley', array($articleId, $galleyId));
			} else if(($deleteImage = Request::getUserVar('deleteImage')) && count($deleteImage) == 1) {
				list($imageId) = array_keys($deleteImage);
				$submitForm->deleteImage($imageId);
				Request::redirect(null, null, 'editGalley', array($articleId, $galleyId));
			}
			Request::redirect(null, null, 'submissionEditing', $articleId);
		} else {
			$submitForm->display();
		}
	}

	/**
	 * Change the sequence order of a galley.
	 */
	function orderGalley() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		SectionEditorAction::orderGalley($submission, Request::getUserVar('galleyId'), Request::getUserVar('d'));

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Delete a galley file.
	 * @param $args array ($articleId, $galleyId)
	 */
	function deleteGalley($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		SectionEditorAction::deleteGalley($submission, $galleyId);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Proof / "preview" a galley.
	 * @param $args array ($articleId, $galleyId)
	 */
	function proofGalley($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$galleyId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate();
		$submission =& $this->submission;

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
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;
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
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

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
				$this->viewFile(array($articleId, $galley->getFileId()));
			}
		}
	}

	/**
	 * Upload a new supplementary file.
	 */
	function uploadSuppFile($fileName = null, $request) {
		$articleId = $request->getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;
		$journal =& $request->getJournal();

		import('classes.submission.form.SuppFileForm');

		$suppFileForm = new SuppFileForm($submission, $journal);
		$suppFileForm->setData('title', array($submission->getLocale() => Locale::translate('common.untitled')));
		$suppFileId = $suppFileForm->execute($fileName);

		$request->redirect(null, null, 'editSuppFile', array($articleId, $suppFileId));
	}

	/**
	 * Change the sequence order of a supplementary file.
	 */
	function orderSuppFile() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);
		$submission =& $this->submission;

		SectionEditorAction::orderSuppFile($submission, Request::getUserVar('suppFileId'), Request::getUserVar('d'));

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}


	//
	// Submission History (FIXME Move to separate file?)
	//

	/**
	 * View submission event log.
	 */
	function submissionEventLog($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$logId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'history');

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('isEditor', Validation::isEditor());
		$templateMgr->assign_by_ref('submission', $submission);

		if ($logId) {
			$logDao =& DAORegistry::getDAO('ArticleEventLogDAO');
			$logEntry =& $logDao->getLogEntry($logId, $articleId);
		}

		if (isset($logEntry)) {
			$templateMgr->assign('logEntry', $logEntry);
			$templateMgr->display('sectionEditor/submissionEventLogEntry.tpl');

		} else {
			$rangeInfo =& Handler::getRangeInfo('eventLogEntries');

			import('classes.article.log.ArticleLog');
			$eventLogEntries =& ArticleLog::getEventLogEntries($articleId, $rangeInfo);
			$templateMgr->assign('eventLogEntries', $eventLogEntries);
			$templateMgr->display('sectionEditor/submissionEventLog.tpl');
		}
	}

	/**
	 * View submission event log by record type.
	 */
	function submissionEventLogType($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$assocType = isset($args[1]) ? (int) $args[1] : null;
		$assocId = isset($args[2]) ? (int) $args[2] : null;
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'history');

		$rangeInfo =& Handler::getRangeInfo('eventLogEntries');
		$logDao =& DAORegistry::getDAO('ArticleEventLogDAO');
		$eventLogEntries =& $logDao->getArticleLogEntriesByAssoc($articleId, $assocType, $assocId, $rangeInfo);

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('showBackLink', true);
		$templateMgr->assign('isEditor', Validation::isEditor());
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('eventLogEntries', $eventLogEntries);
		$templateMgr->display('sectionEditor/submissionEventLog.tpl');
	}

	/**
	 * Clear submission event log entries.
	 */
	function clearSubmissionEventLog($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$logId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;

		$logDao =& DAORegistry::getDAO('ArticleEventLogDAO');

		if ($logId) {
			$logDao->deleteLogEntry($logId, $articleId);

		} else {
			$logDao->deleteArticleLogEntries($articleId);
		}

		Request::redirect(null, null, 'submissionEventLog', $articleId);
	}

	/**
	 * View submission email log.
	 */
	function submissionEmailLog($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$logId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'history');

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('isEditor', Validation::isEditor());
		$templateMgr->assign_by_ref('submission', $submission);

		$templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());

		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		import('classes.file.ArticleFileManager');
		$templateMgr->assign('attachments', $articleFileDao->getArticleFilesByAssocId($logId, ARTICLE_FILE_ATTACHMENT));

		if ($logId) {
			$logDao =& DAORegistry::getDAO('ArticleEmailLogDAO');
			$logEntry =& $logDao->getLogEntry($logId, $articleId);
		}

		if (isset($logEntry)) {
			$templateMgr->assign_by_ref('logEntry', $logEntry);
			$templateMgr->display('sectionEditor/submissionEmailLogEntry.tpl');

		} else {
			$rangeInfo =& Handler::getRangeInfo('emailLogEntries');

			import('classes.article.log.ArticleLog');
			$emailLogEntries =& ArticleLog::getEmailLogEntries($articleId, $rangeInfo);
			$templateMgr->assign_by_ref('emailLogEntries', $emailLogEntries);
			$templateMgr->display('sectionEditor/submissionEmailLog.tpl');
		}
	}

	/**
	 * View submission email log by record type.
	 */
	function submissionEmailLogType($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$assocType = isset($args[1]) ? (int) $args[1] : null;
		$assocId = isset($args[2]) ? (int) $args[2] : null;
		$this->validate($articleId);
		$submission =& $this->submission;
		$this->setupTemplate(1, $articleId, 'history');

		$rangeInfo =& Handler::getRangeInfo('eventLogEntries');
		$logDao =& DAORegistry::getDAO('ArticleEmailLogDAO');
		$emailLogEntries =& $logDao->getArticleLogEntriesByAssoc($articleId, $assocType, $assocId, $rangeInfo);

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('showBackLink', true);
		$templateMgr->assign('isEditor', Validation::isEditor());
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign_by_ref('emailLogEntries', $emailLogEntries);
		$templateMgr->display('sectionEditor/submissionEmailLog.tpl');
	}

	/**
	 * Clear submission email log entries.
	 */
	function clearSubmissionEmailLog($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$logId = isset($args[1]) ? (int) $args[1] : 0;
		$this->validate($articleId);

		$logDao =& DAORegistry::getDAO('ArticleEmailLogDAO');

		if ($logId) {
			$logDao->deleteLogEntry($logId, $articleId);

		} else {
			$logDao->deleteArticleLogEntries($articleId);
		}

		Request::redirect(null, null, 'submissionEmailLog', $articleId);
	}

	// Submission Notes Functions

	/**
	 * Creates a submission note.
	 * Redirects to submission notes list
	 */
	function addSubmissionNote() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);

		SectionEditorAction::addSubmissionNote($articleId);
		Request::redirect(null, null, 'submissionNotes', $articleId);
	}

	/**
	 * Removes a submission note.
	 * Redirects to submission notes list
	 */
	function removeSubmissionNote() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);

		SectionEditorAction::removeSubmissionNote($articleId);
		Request::redirect(null, null, 'submissionNotes', $articleId);
	}

	/**
	 * Updates a submission note.
	 * Redirects to submission notes list
	 */
	function updateSubmissionNote() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);

		SectionEditorAction::updateSubmissionNote($articleId);
		Request::redirect(null, null, 'submissionNotes', $articleId);
	}

	/**
	 * Clear all submission notes.
	 * Redirects to submission notes list
	 */
	function clearAllSubmissionNotes() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId);

		SectionEditorAction::clearAllSubmissionNotes($articleId);
		Request::redirect(null, null, 'submissionNotes', $articleId);
	}

	/**
	 * View submission notes.
	 */
	function submissionNotes($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$noteViewType = isset($args[1]) ? $args[1] : '';
		$noteId = isset($args[2]) ? (int) $args[2] : 0;

		$this->validate($articleId);
		$this->setupTemplate(1, $articleId, 'history');
		$submission =& $this->submission;

		$rangeInfo =& Handler::getRangeInfo('submissionNotes');
		$noteDao =& DAORegistry::getDAO('NoteDAO');

		// submission note edit
		if ($noteViewType == 'edit') {
			$note = $noteDao->getById($noteId);
		}

		$templateMgr =& TemplateManager::getManager();

		$templateMgr->assign('articleId', $articleId);
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign('noteViewType', $noteViewType);
		if (isset($note)) {
			$templateMgr->assign_by_ref('articleNote', $note);
		}

		if ($noteViewType == 'edit' || $noteViewType == 'add') {
			$templateMgr->assign('showBackLink', true);
		} else {
			$submissionNotes =& $noteDao->getByAssoc(ASSOC_TYPE_ARTICLE, $articleId);
			$templateMgr->assign_by_ref('submissionNotes', $submissionNotes);
		}

		$templateMgr->display('sectionEditor/submissionNotes.tpl');
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
		if (!SectionEditorAction::downloadFile($articleId, $fileId)) {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}

	/**
	 * Download a file.
	 * @param $args array ($articleId, $fileId)
	 */
	function uploadDecisionFile($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$decisionId = isset($args[1]) ? $args[1] : 0;

		//echo $articleId;
		$fileName = "finalDecisionFile";
		$this->validate($articleId);
		if (isset($_FILES[$fileName])){
			SectionEditorAction::uploadDecisionFile($articleId, $fileName, $decisionId);
		}
		Request::redirect(null, null, 'submissionReview', $articleId);
	}
	
	/**
	 * View a file (inlines file).
	 * @param $args array ($articleId, $fileId)
	 */
	function viewFile($args) {
		$articleId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;

		$this->validate($articleId);
		if (!SectionEditorAction::viewFile($articleId, $fileId)) {
			Request::redirect(null, null, 'submission', $articleId);
		}
	}


	//
	// Proofreading
	//

	/**
	 * Select Proofreader.
	 * @param $args array ($articleId, $userId)
	 */
	function selectProofreader($args) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$userId = isset($args[1]) ? (int) $args[1] : 0;

		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$journal =& Request::getJournal();
		$submission =& $this->submission;

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		if ($userId && $articleId && $roleDao->roleExists($journal->getId(), $userId, ROLE_ID_PROOFREADER)) {
			import('classes.submission.proofreader.ProofreaderAction');
			ProofreaderAction::selectProofreader($userId, $submission);
			Request::redirect(null, null, 'submissionEditing', $articleId);
		} else {
			$this->setupTemplate(1, $articleId, 'editing');

			$searchType = null;
			$searchMatch = null;
			$search = $searchQuery = Request::getUserVar('search');
			$searchInitial = Request::getUserVar('searchInitial');
			if (!empty($search)) {
				$searchType = Request::getUserVar('searchField');
				$searchMatch = Request::getUserVar('searchMatch');

			} elseif (!empty($searchInitial)) {
				$searchInitial = String::strtoupper($searchInitial);
				$searchType = USER_FIELD_INITIAL;
				$search = $searchInitial;
			}

			$proofreaders = $roleDao->getUsersByRoleId(ROLE_ID_PROOFREADER, $journal->getId(), $searchType, $search, $searchMatch);

			$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
			$proofreaderStatistics = $sectionEditorSubmissionDao->getProofreaderStatistics($journal->getId());

			$templateMgr =& TemplateManager::getManager();

			$templateMgr->assign('searchField', $searchType);
			$templateMgr->assign('searchMatch', $searchMatch);
			$templateMgr->assign('search', $searchQuery);
			$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));

			$templateMgr->assign_by_ref('users', $proofreaders);

			$proofSignoff = $signoffDao->getBySymbolic('SIGNOFF_PROOFREADING_PROOFREADER', ASSOC_TYPE_ARTICLE, $articleId);
			if ($proofSignoff) {
				$templateMgr->assign('currentUser', $proofSignoff->getUserId());
 			}
			$templateMgr->assign('statistics', $proofreaderStatistics);
			$templateMgr->assign('fieldOptions', Array(
				USER_FIELD_FIRSTNAME => 'user.firstName',
				USER_FIELD_LASTNAME => 'user.lastName',
				USER_FIELD_USERNAME => 'user.username',
				USER_FIELD_EMAIL => 'user.email'
			));
			$templateMgr->assign('articleId', $articleId);
			$templateMgr->assign('pageSubTitle', 'editor.article.selectProofreader');
			$templateMgr->assign('pageTitle', 'user.role.proofreaders');
			$templateMgr->assign('actionHandler', 'selectProofreader');

			$templateMgr->assign('helpTopicId', 'journal.roles.proofreader');
			$templateMgr->display('sectionEditor/selectUser.tpl');
		}
	}

	/**
	 * Notify author for proofreading
	 */
	function notifyAuthorProofreader($args) {
		$articleId = Request::getUserVar('articleId');
		$send = Request::getUserVar('send')?1:0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate(1, $articleId, 'editing');

		import('classes.submission.proofreader.ProofreaderAction');
		if (ProofreaderAction::proofreadEmail($articleId, 'PROOFREAD_AUTHOR_REQUEST', $send?'':Request::url(null, null, 'notifyAuthorProofreader'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Thank author for proofreading
	 */
	function thankAuthorProofreader($args) {
		$articleId = Request::getUserVar('articleId');
		$send = Request::getUserVar('send')?1:0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate(1, $articleId, 'editing');

		import('classes.submission.proofreader.ProofreaderAction');
		if (ProofreaderAction::proofreadEmail($articleId, 'PROOFREAD_AUTHOR_ACK', $send?'':Request::url(null, null, 'thankAuthorProofreader'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Editor initiates proofreading
	 */
	function editorInitiateProofreader() {
		$articleId = Request::getUserVar('articleId');
		$user =& Request::getUser();
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);

		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$signoff = $signoffDao->build('SIGNOFF_PROOFREADING_PROOFREADER', ASSOC_TYPE_ARTICLE, $articleId);
		if (!$signoff->getUserId()) {
			$signoff->setUserId($user->getId());
		}
		$signoff->setDateNotified(Core::getCurrentDate());
		$signoffDao->updateObject($signoff);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Editor completes proofreading
	 */
	function editorCompleteProofreader() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;

		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$signoff = $signoffDao->build('SIGNOFF_PROOFREADING_PROOFREADER', ASSOC_TYPE_ARTICLE, $articleId);
		$signoff->setDateCompleted(Core::getCurrentDate());
		$signoffDao->updateObject($signoff);


		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Notify proofreader for proofreading
	 */
	function notifyProofreader($args) {
		$articleId = Request::getUserVar('articleId');
		$send = Request::getUserVar('send');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate(1, $articleId, 'editing');

		import('classes.submission.proofreader.ProofreaderAction');
		if (ProofreaderAction::proofreadEmail($articleId, 'PROOFREAD_REQUEST', $send?'':Request::url(null, null, 'notifyProofreader'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Thank proofreader for proofreading
	 */
	function thankProofreader($args) {
		$articleId = Request::getUserVar('articleId');
		$send = Request::getUserVar('send')?1:0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate(1, $articleId, 'editing');

		import('classes.submission.proofreader.ProofreaderAction');
		if (ProofreaderAction::proofreadEmail($articleId, 'PROOFREAD_ACK', $send?'':Request::url(null, null, 'thankProofreader'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Editor initiates layout editor proofreading
	 */
	function editorInitiateLayoutEditor() {
		$articleId = Request::getUserVar('articleId');
		$user =& Request::getUser();
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);

		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$signoff = $signoffDao->build('SIGNOFF_PROOFREADING_LAYOUT', ASSOC_TYPE_ARTICLE, $articleId);
		if (!$signoff->getUserId()) {
			$signoff->setUserId($user->getId());
		}
		$signoff->setDateNotified(Core::getCurrentDate());
		$signoff->setDateUnderway(null);
		$signoff->setDateCompleted(null);
		$signoff->setDateAcknowledged(null);
		$signoffDao->updateObject($signoff);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Editor completes layout editor proofreading
	 */
	function editorCompleteLayoutEditor() {
		$articleId = Request::getUserVar('articleId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);

		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$signoff = $signoffDao->build('SIGNOFF_PROOFREADING_LAYOUT', ASSOC_TYPE_ARTICLE, $articleId);
		$signoff->setDateCompleted(Core::getCurrentDate());
		$signoffDao->updateObject($signoff);

		Request::redirect(null, null, 'submissionEditing', $articleId);
	}

	/**
	 * Notify layout editor for proofreading
	 */
	function notifyLayoutEditorProofreader($args) {
		$articleId = Request::getUserVar('articleId');
		$send = Request::getUserVar('send')?1:0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate(1, $articleId, 'editing');

		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$signoff = $signoffDao->getBySymbolic('SIGNOFF_PROOFREADING_LAYOUT', ASSOC_TYPE_ARTICLE, $articleId);
		$signoff->setDateNotified(Core::getCurrentDate());
		$signoff->setDateUnderway(null);
		$signoff->setDateCompleted(null);
		$signoff->setDateAcknowledged(null);
		$signoffDao->updateObject($signoff);

		import('classes.submission.proofreader.ProofreaderAction');
		if (ProofreaderAction::proofreadEmail($articleId, 'PROOFREAD_LAYOUT_REQUEST', $send?'':Request::url(null, null, 'notifyLayoutEditorProofreader'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Thank layout editor for proofreading
	 */
	function thankLayoutEditorProofreader($args) {
		$articleId = Request::getUserVar('articleId');
		$send = Request::getUserVar('send')?1:0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$this->setupTemplate(1, $articleId, 'editing');

		import('classes.submission.proofreader.ProofreaderAction');
		if (ProofreaderAction::proofreadEmail($articleId, 'PROOFREAD_LAYOUT_ACK', $send?'':Request::url(null, null, 'thankLayoutEditorProofreader'))) {
			Request::redirect(null, null, 'submissionEditing', $articleId);
		}
	}

	/**
	 * Schedule/unschedule an article for publication.
	 */
	function scheduleForPublication($args) {
		$articleId = (int) array_shift($args);
		$issueId = (int) Request::getUserVar('issueId');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);

		$journal =& Request::getJournal();
		$submission =& $this->submission;

		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$publishedArticleDao =& DAORegistry::getDAO('PublishedArticleDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$publishedArticle =& $publishedArticleDao->getPublishedArticleByArticleId($articleId);

		$issueDao =& DAORegistry::getDAO('IssueDAO');
		$issue =& $issueDao->getIssueById($issueId, $journal->getId());

		if ($issue) {
			// Schedule against an issue.
			if ($publishedArticle) {
				$publishedArticle->setIssueId($issueId);
				$publishedArticleDao->updatePublishedArticle($publishedArticle);
			} else {
				$publishedArticle = new PublishedArticle();
				$publishedArticle->setId($submission->getId());
				$publishedArticle->setIssueId($issueId);
				$publishedArticle->setDatePublished(Core::getCurrentDate());
				$publishedArticle->setSeq(REALLY_BIG_NUMBER);
				$publishedArticle->setViews(0);
				$publishedArticle->setAccessStatus(ARTICLE_ACCESS_ISSUE_DEFAULT);

				$publishedArticleDao->insertPublishedArticle($publishedArticle);

				// Resequence the articles.
				$publishedArticleDao->resequencePublishedArticles($submission->getSectionId(), $issueId);

				// If we're using custom section ordering, and if this is the first
				// article published in a section, make sure we enter a custom ordering
				// for it. (Default at the end of the list.)
				if ($sectionDao->customSectionOrderingExists($issueId)) {
					if ($sectionDao->getCustomSectionOrder($issueId, $submission->getSectionId()) === null) {
						$sectionDao->insertCustomSectionOrder($issueId, $submission->getSectionId(), REALLY_BIG_NUMBER);
						$sectionDao->resequenceCustomSectionOrders($issueId);
					}
				}
			}
		} else {
			if ($publishedArticle) {
				// This was published elsewhere; make sure we don't
				// mess up sequencing information.
				$publishedArticleDao->resequencePublishedArticles($submission->getSectionId(), $publishedArticle->getIssueId());
				$publishedArticleDao->deletePublishedArticleByArticleId($articleId);
			}
		}
		$submission->stampStatusModified();

		if ($issue && $issue->getPublished()) {
			$submission->setStatus(STATUS_PUBLISHED);
		} else {
			$submission->setStatus(STATUS_QUEUED);
		}

		$sectionEditorSubmissionDao->updateSectionEditorSubmission($submission);

		Request::redirect(null, null, 'submissionEditing', array($articleId), null, 'scheduling');
	}

	/**
	 * Payments
	 */

	function waiveSubmissionFee($args, $request) {
		$articleId = (int) array_shift($args);
		$markAsPaid = $request->getUserVar('markAsPaid');

		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$submission =& $this->submission;
		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		$user =& $request->getUser();
		$journal =& $request->getJournal();

		$queuedPayment =& $paymentManager->createQueuedPayment(
			$journal->getId(),
			PAYMENT_TYPE_SUBMISSION,
			$markAsPaid ? $submission->getUserId() : $user->getId(),
			$articleId,
			$markAsPaid ? $journal->getSetting('submissionFee') : 0,
			$markAsPaid ? $journal->getSetting('currency') : ''
		);

		$queuedPaymentId = $paymentManager->queuePayment($queuedPayment);

		// Since this is a waiver, fulfill the payment immediately
		$paymentManager->fulfillQueuedPayment($queuedPayment, $markAsPaid?'ManualPayment':'Waiver');
		$request->redirect(null, null, 'submissionReview', array($articleId));
	}

	function waiveFastTrackFee($args) {
		$articleId = (int) array_shift($args);
		$markAsPaid = Request::getUserVar('markAsPaid');
		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$journal =& Request::getJournal();
		$submission =& $this->submission;

		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		$user =& Request::getUser();

		$queuedPayment =& $paymentManager->createQueuedPayment(
			$journal->getId(),
			PAYMENT_TYPE_FASTTRACK,
			$markAsPaid ? $submission->getUserId() : $user->getId(),
			$articleId,
			$markAsPaid ? $journal->getSetting('fastTrackFee') : 0,
			$markAsPaid ? $journal->getSetting('currency') : ''
		);

		$queuedPaymentId = $paymentManager->queuePayment($queuedPayment);

		// Since this is a waiver, fulfill the payment immediately
		$paymentManager->fulfillQueuedPayment($queuedPayment, $markAsPaid?'ManualPayment':'Waiver');
		Request::redirect(null, null, 'submission', array($articleId));
	}

	function waivePublicationFee($args) {
		$articleId = (int) array_shift($args);
		$markAsPaid = Request::getUserVar('markAsPaid');
		$sendToScheduling = Request::getUserVar('sendToScheduling')?true:false;

		$this->validate($articleId, SECTION_EDITOR_ACCESS_EDIT);
		$journal =& Request::getJournal();
		$submission =& $this->submission;

		import('classes.payment.ojs.OJSPaymentManager');
		$paymentManager =& OJSPaymentManager::getManager();
		$user =& Request::getUser();

		$queuedPayment =& $paymentManager->createQueuedPayment(
			$journal->getId(),
			PAYMENT_TYPE_PUBLICATION,
			$markAsPaid ? $submission->getUserId() : $user->getId(),
			$articleId,
			$markAsPaid ? $journal->getSetting('publicationFee') : 0,
			$markAsPaid ? $journal->getSetting('currency') : ''
		);

		$queuedPaymentId = $paymentManager->queuePayment($queuedPayment);

		// Since this is a waiver, fulfill the payment immediately
		$paymentManager->fulfillQueuedPayment($queuedPayment, $markAsPaid?'ManualPayment':'Waiver');

		if ( $sendToScheduling ) {
			Request::redirect(null, null, 'submissionEditing', array($articleId), null, 'scheduling');
		} else {
			Request::redirect(null, null, 'submission', array($articleId));
		}
	}

	//
	// Validation
	//

	/**
	 * Validate that the user is the assigned section editor for
	 * the article, or is a managing editor.
	 * Redirects to sectionEditor index page if validation fails.
	 * @param $articleId int Article ID to validate
	 * @param $access int Optional name of access level required -- see SECTION_EDITOR_ACCESS_... constants
	 */
	function validate($articleId, $access = null) {
		parent::validate();
		$isValid = true;

		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();

		$sectionEditorSubmission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($articleId);

		if ($sectionEditorSubmission == null) {
			$isValid = false;

		} else if ($sectionEditorSubmission->getJournalId() != $journal->getId()) {
			$isValid = false;

		} else if ($sectionEditorSubmission->getDateSubmitted() == null) {
			$isValid = false;

		} else {
			$templateMgr =& TemplateManager::getManager();

			if (Validation::isEditor() || Validation::isSectionEditor()) {
				// Make canReview and canEdit available to templates.
				// Since this user is an editor, both are available.
				$templateMgr->assign('canReview', true);
				$templateMgr->assign('canEdit', true);
			} else {
				// If this user isn't the submission's editor, they don't have access.
				$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
				$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $sectionEditorSubmission->getSectionId());
				$wasFound = false;
				foreach ($sectionEditors as $sectionEditor){
					if ($sectionEditor->getId() == $user->getId()) {
						$templateMgr->assign('canReview', true);
						$templateMgr->assign('canEdit', true);
						switch ($access) {
							case SECTION_EDITOR_ACCESS_EDIT:
								$wasFound = true;
								break;
							case SECTION_EDITOR_ACCESS_REVIEW:
								$wasFound = true;
								break;
							default:
								$wasFound = true;
								break;
						}
					}
				}

				if (!$wasFound) $isValid = false;
			}
		}

		if (!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}

		$this->submission =& $sectionEditorSubmission;
		return true;
	}

}
?>
