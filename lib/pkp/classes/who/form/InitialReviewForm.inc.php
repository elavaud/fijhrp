<?php

/**
 * @defgroup sectionEditor_form
 */

import('classes.lib.fpdf.pdf');
import('lib.pkp.classes.form.Form');
import('classes.submission.sectionEditor.SectionEditorAction');

class InitialReviewForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $submission;
	/**
	 * Constructor.
	 */
	function InitialReviewForm($meetingId, $articleId) {
		parent::Form('sectionEditor/minutes/uploadInitialReview.tpl');
		$this->addCheck(new FormValidatorPost($this));
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');		
		$this->submission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($articleId);
		
		/*
		$this->addCheck(new FormValidator($this, 'generalDiscussion', 'required', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidator($this, 'specificDiscussion', 'required', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidator($this, 'scientificDesign', 'required', 'user.profile.form.usernameRequired'));
		if($submission->getLocalizedProposalType == "CWHS" || $submission->getLocalizedProposalType == "PWHS") {
		
		/*
			$this->addCheck(new FormValidator($this, 'subjectSelection', 'required', 'user.profile.form.usernameRequired'));
			$this->addCheck(new FormValidator($this, 'levelOfRisk', 'required', 'user.profile.form.usernameRequired'));
			$this->addCheck(new FormValidator($this, 'benefitCategory', 'required', 'user.profile.form.usernameRequired'));
			$this->addCheck(new FormValidator($this, 'additionalSafeguards', 'required', 'user.profile.form.usernameRequired'));
			$this->addCheck(new FormValidator($this, 'minimization', 'required', 'user.profile.form.usernameRequired'));
			$this->addCheck(new FormValidator($this, 'confidentiality', 'required', 'user.profile.form.usernameRequired'));
			$this->addCheck(new FormValidator($this, 'consentDocument', 'required', 'user.profile.form.usernameRequired'));
			$this->addCheck(new FormValidator($this, 'additionalConsiderations', 'required', 'user.profile.form.usernameRequired'));
		}
		$this->addCheck(new FormValidatorAlphaNum($this, 'stipulations', 'required', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidatorAlphaNum($this, 'recommendations', 'required', 'user.profile.form.usernameRequired'));		
		$this->addCheck(new FormValidator($this, 'decision', 'required', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidator($this, 'unanimous', 'optional', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidator($this, 'startDate', 'optional', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidator($this, 'useRtoDate', 'optional', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidatorAlphaNum($this, 'votesApproved', 'optional', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidatorAlphaNum($this, 'votesNotApproved', 'optional', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidatorAlphaNum($this, 'votesAbstain', 'optional', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidatorAlphaNum($this, 'minorityReasons', 'optional', 'user.profile.form.usernameRequired'));
		*/
	}

	/**
	 * Display the form.
	 */
	function display(&$args, &$request) {
		$meeting = $this->meeting;
		$submission =& $this->submission;
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$lastDecision = $articleDao->getLastEditorDecision($submission->getId());			
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign("lastDecision", $lastDecision);
		$templateMgr->assign("meeting", $meeting);
		$templateMgr->assign_by_ref('submission', $submission);
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'meetingId',
			'articleId',
			'lastDecisionId',
			'resubmitCount',  
			'generalDiscussion',
			'specificDiscussion',
			'scientificDesign',
			'stipulations',
			'recommendations',
			'decision',
			'unanimous',
			'useRtoDate',
			'votesApproved',
			'votesNotApproved',
			'votesAbstain',
			'minorityReasons'	
			));
		if($this->submission->getLocalizedProposalType() == "CWHS" || $this->submission->getLocalizedProposalType() == "PWHS") {
			$this->readUserVars(array(
			'subjectSelection',
			'levelOfRisk',
			'benefitCategory',
			'additionalSafeguards',
			'minimization',
			'confidentiality',
			'consentDocument',
			'additionalConsiderations'
			));
		}
		
	}

	/**
	 *
	 * @return userId int
	 */
	function execute() {
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		$decision = $this->getData('decision');
		$decisionId = $this->getData('lastDecisionId');
		$resubmitCount = $this->getData('resubmitCount');
		$useRtoDate = $this->getData('useRtoDate');
		
		$dateDecided = ($decision == SUBMISSION_EDITOR_DECISION_ACCEPT && $useRtoDate == "1") ? $submission->getLocalizedStartDate() : $meeting->getDate() ;
		switch ($decision) {
			case SUBMISSION_EDITOR_DECISION_ACCEPT:
			case SUBMISSION_EDITOR_DECISION_RESUBMIT:
			case SUBMISSION_EDITOR_DECISION_DECLINE:			
				SectionEditorAction::recordDecision($submission, $decision, $decisionId, $resubmitCount, $dateDecided);
				break;
		}		
	}

	function showPdf() {
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		$summary=null;
		foreach ($submission->getSuppFiles() as $suppFile) {
			if ($suppFile->getType() == 'Summary')
				$summary = $suppFile->getSuppFileTitle();
		}
		
		$pdf = new PDF();
		$pdf->AddPage();
		$pdf->ChapterTitle('INITIAL REVIEW of Proposal: ' . $submission->getLocalizedTitle());
		$pdf->ChapterItemBody('Protocol Title', $submission->getLocalizedTitle());
		$pdf->ChapterItemBody('Principal Investigator (PI)', $submission->getAuthorString());
		$pdf->ChapterItemBody('Unique project identification # assigned', $submission->getLocalizedWhoId());
		if($summary!=null)
			$pdf->ChapterItemBody('Protocol Summary', $summary);
		$pdf->ChapterBody("(a) Discussion");
		$pdf->ChapterItemBody('General', $this->getData('generalDiscussion'));
		$pdf->ChapterItemBody('Specific', $this->getData('specificDiscussion'));
		$pdf->ChapterItemBody('Scientific Design', $this->getData('scientificDesign'));
		
		if($submission->getLocalizedProposalType() == "CWHS" || $submission->getLocalizedProposalType() == "PWHS") {
			$pdf->ChapterItemBody('Subject Selection', $this->getData('subjectSelection'));
			$pdf->ChapterItemBody('Level of Risk', $this->getData('levelOfRisk'));
			$pdf->ChapterItemBody('Benefit Category', $this->getData('benefitCategory'));
			$pdf->ChapterItemBody('Addtional Safeguards for Vulnerable Subjects', $this->getData('additionalSafeguards'));
			$pdf->ChapterItemBody('Minimization of Risks to Subjects', $this->getData('minimization'));
			$pdf->ChapterItemBody('Privacy and Confidentiality', $this->getData('confidentiality'));
			$pdf->ChapterItemBody('Consent Document', $this->getData('consentDocument'));
			$pdf->ChapterItemBody('Additional Considerations', $this->getData('additionalConsiderations'));
		}
		$pdf->ChapterItemBody('(b) Stipulations', $this->getData('stipulations'));
		$pdf->ChapterItemBody('(c) Recommendations', $this->getData('recommendations'));
		$decision = $submission->getMostRecentDecision(); 
		switch($decision) {
			case SUBMISSION_EDITOR_DECISION_ACCEPT:
				$decisionStr = "Accept";
				break;
			case SUBMISSION_EDITOR_DECISION_RESUBMIT:
				$decisionStr = "Revise and Resubmit";
				break;
			case SUBMISSION_EDITOR_DECISION_DECLINE:
				$decisionStr = "Not Approved";
				break;
		}  
		$unanimousStr = $this->getData('unanimous')=="1" ? " (unanimous)" : "";
		$pdf->ChapterItemBody('IRB Decision', $decisionStr. $unanimousStr);
		
		if($this->getData('unanimous')!="1") {
			$pdf->ChapterItemBody('Approve', $this->getData('votesApproved'). " votes");
			$pdf->ChapterItemBody('Not Approve', $this->getData('votesNotApproved'). " votes");
			$pdf->ChapterItemBody('Abstain', $this->getData('votesAbstain'). " votes");
			$pdf->ChapterItemBody('Reasons for Minority', $this->getData('minoeityReasons'));
		}
		$pdf->Output();
	}
		
}

?>
