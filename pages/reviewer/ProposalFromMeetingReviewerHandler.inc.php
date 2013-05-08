<?php

/**
 * @file ProposalFromMeetingReviewerHandler.inc.php
 *
 *
 * @class MeetingReviewerHandler
 * @ingroup pages_reviewer
 *
 * @brief Handle requests for meeting reviewer functions.
 * 
 * Added by EL
 * Last Updated: 4/3/2013
 */

/**
 * Last update on February 2013
 * EL
**/

import('classes.handler.Handler');
import('pages.reviewer.ReviewerHandler');

class ProposalFromMeetingReviewerHandler extends ReviewerHandler {

	var $submission;
	var $user;

	/**
	 * Constructor
	 **/
	function ProposalFromMeetingReviewerHandler() {
		parent::ReviewerHandler();

		$this->addCheck(new HandlerValidatorJournal($this));
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_REVIEWER)));		
	}

	/**
	 * Display view meeting proposal page.
	 * Last update: EL on February 25th 2013
	 */
	function viewProposalFromMeeting($args) {
		$journal =& Request::getJournal();
		$proposalId = $args[0];
		$this->validate($proposalId);
		$user =& Request::getUser();
		$sectionDao =& DAORegistry::getDao('SectionDAO');
		$articleFileDao =& DAORegistry::getDao('ArticleFileDAO');
		$ercReviewersDao = DAORegistry::getDAO('ErcReviewersDAO');

		$submission =& $this->submission;
		$this->setupTemplate(true, 2);
		
		$section =& $sectionDao->getSection($submission->getSectionId());
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign('ercTitle', $section->getLocalizedTitle());
		
		$templateMgr->assign_by_ref('submissionFile', $submission->getSubmissionFile());
		$templateMgr->assign_by_ref('suppFiles', $submission->getSuppFiles());
		$templateMgr->assign_by_ref('previousFiles', $articleFileDao->getPreviousFilesByArticleId($submission->getId()));
		
        $templateMgr->assign_by_ref('riskAssessment', $submission->getRiskAssessment());
        $templateMgr->assign_by_ref('abstract', $submission->getLocalizedAbstract());
            
		$templateMgr->assign('isReviewer', $ercReviewersDao->ercReviewerExists($journal->getId(), $submission->getSectionId(), $user->getId()));
		
		$templateMgr->display('reviewer/viewProposalFromMeeting.tpl');
	}

	/**
	 * Download a file.
	 * @param $args array ($articleId, $fileId)
	 */
	function downloadProposalFromMeetingFile($args) {
		$proposalId = isset($args[0]) ? $args[0] : 0;
		$fileId = isset($args[1]) ? $args[1] : 0;

		$this->validate($proposalId);

		if (!Action::downloadFile($proposalId, $fileId)) {
			Request::redirect(null, 'user');
		}
	}
		
	
	/** TODO:
	 * (non-PHPdoc)
	 * @see PKPHandler::validate()
	 */
	function validate($proposalId) {
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$journalId = $journal->getId();
		$isValid = false;
		$newKey = Request::getUserVar('key');
		$meetings =& $meetingDao->getMeetingsByReviewerId($user->getId());
		$meetings =& $meetings->toArray();
		if (!$ercReviewersDao->isExternalReviewer($journalId, $user->getId())) {
			if ($proposalId && $user && empty($newKey)) {
				$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
				foreach ($meetings as $meeting) {
					$submissionIds =& $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meeting->getId());
					foreach ($submissionIds as $submissionId) if ($submissionId == $proposalId) $isValid = true;
				}
			}
		}
		if (!$isValid) {
			Request::redirect(null, Request::getRequestedPage());
		}
		$reviewerSubmissionDao =& DAORegistry::getDAO('ReviewerSubmissionDAO');
		
		$submission = $reviewerSubmissionDao->getReviewerSubmissionFromMeeting($proposalId);
		$this->submission =& $submission;
		$this->user =& $user;
		
		return true;
	}
}

?>
