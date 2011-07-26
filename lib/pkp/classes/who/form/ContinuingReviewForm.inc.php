<?php

/**
 * @defgroup sectionEditor_form
 */

import('classes.lib.fpdf.pdf');
import('lib.pkp.classes.form.Form');
import('classes.submission.sectionEditor.SectionEditorAction');

class ContinuingReviewForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $submission;
	/**
	 * Constructor.
	 */
	function ContinuingReviewForm($meetingId, $articleId) {
		parent::Form('sectionEditor/minutes/uploadContinuingReview.tpl');
		$this->addCheck(new FormValidatorPost($this));

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$submission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($articleId);
		$this->submission = $submission;
		if($submission->getSummaryFile()==null)
		$this->addCheck(new FormValidator($this, 'summary', 'required', 'editor.minutes.summaryRequired'));
		$this->addCheck(new FormValidator($this, 'wproRole', 'required', 'editor.minutes.wproRoleRequired'));
		$this->addCheck(new FormValidator($this, 'generalDiscussion', 'required', 'editor.minutes.generalDiscussionRequired'));
		$this->addCheck(new FormValidator($this, 'decision', 'required', 'editor.minutes.decisionRequired'));
		$this->addCheck(new FormValidator($this, 'unanimous', 'required', 'editor.minutes.unanimousRequired'));
		$this->addCheck(new FormValidatorCustom($this, 'discussionType', 'required', 'editor.minutes.typeOtherRequired',
			create_function('$discussionType, $form', 'foreach($discussionType as $key=>$discussion_type){
				$typeOther = $form->getData(\'typeOther\');
				if($discussion_type==0 && $typeOther[$key]==""){ return false; }
		}return true;'), array(&$this)));	

		$this->addCheck(new FormValidatorCustom($this, 'votesApprove', 'required', 'editor.minutes.approveCountRequired',
			create_function('$votesApprove,$form', 	  'if ($form->getData(\'unanimous\') == "Yes") return true; else return is_numeric($votesApprove);'), array(&$this)));
		$this->addCheck(new FormValidatorCustom($this, 'votesNotApprove', 'required', 'editor.minutes.notApproveCountRequired',
			create_function('$votesNotApprove,$form', 'if ($form->getData(\'unanimous\') == "Yes") return true; else return is_numeric($votesNotApprove);'), array(&$this)));
		$this->addCheck(new FormValidatorCustom($this, 'votesAbstain', 'required', 'editor.minutes.abstainCountRequired',
			create_function('$votesAbstain,$form',    'if ($form->getData(\'unanimous\') == "Yes") return true; else return is_numeric($votesAbstain);'), array(&$this)));
	
		$this->addCheck(new FormValidatorCustom($this, 'minorityReason', 'required', 'editor.minutes.minorityReasonRequired',
			create_function('$minorityReason, $form', 'if ($form->getData(\'unanimous\') == "Yes") return true; else return (($minorityReason != "") || ($minorityReason != null));'), array(&$this)));
		
		$this->addCheck(new FormValidatorCustom($this, 'chairReview', 'required', 'editor.minutes.chairReviewRequired',
		 	create_function('$chairReview, $form', 'if ($form->getData(\'unanimous\') != 1) return true; else return (($chairReview !="") || ($chairReview != null));'), array(&$this)));
		 	
		 	
	}

	/**
	 * Display the form.
	 */
	function display(&$args, &$request) {
		$meeting = $this->meeting;
		$submission =& $this->submission;

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign("meeting", $meeting);
		$templateMgr->assign_by_ref('submission', $submission);
		$templateMgr->assign("discussionTypes", Meeting::getSpecificDiscussionOptions());
		$templateMgr->assign("discussionType", $this->getData('discussionType'));
		$templateMgr->assign("discussionText", $this->getData('discussionText'));
		$templateMgr->assign("typeOther", $this->getData('typeOther'));
		$templateMgr->assign("unanimous", $this->getData('unanimous'));
		$templateMgr->assign("votesApprove", $this->getData('votesApprove'));
		$templateMgr->assign("votesNotApprove", $this->getData('votesNotApprove'));
		$templateMgr->assign("votesAbstain", $this->getData('votesAbstain'));
		$templateMgr->assign("minorityReason", $this->getData('minorityReason'));
		$templateMgr->assign('decision', $this->getData('decision'));
		$templateMgr->assign('wproRole', $this->getData('wproRole'));
		$templateMgr->assign('summary', $this->getData('summary'));
		$templateMgr->assign('generalDiscussion', $this->getData('generalDiscussion'));
		$templateMgr->assign('stipulations', $this->getData('stipulations'));
		$templateMgr->assign('recommendations', $this->getData('recommendations'));
		$templateMgr->assign('chairReview', $this->getData('chairReview'));
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'summary',
			'generalDiscussion',
			'discussionType',
			'discussionText',
			'typeOther',
			'decision',
			'votesApprove',
			'votesNotApprove',
			'votesAbstain',
			'unanimous',
			'minorityReason',
			'wproRole',
			'stipulations',
			'recommendations',
			'chairReview'
			));
	}

	function execute() {
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		$decision = $this->getData('decision');
		$articleDao =& DAORegistry::getDAO("ArticleDAO");
		$previousDecision =& $articleDao->getLastEditorDecision($submission->getId());

		$dateDecided = $meeting->getDate() ;
		switch ($decision) {
			case SUBMISSION_EDITOR_DECISION_ACCEPT:
			case SUBMISSION_EDITOR_DECISION_RESUBMIT:
			case SUBMISSION_EDITOR_DECISION_DECLINE:
				SectionEditorAction::recordDecision($submission, $decision, $previousDecision['editDecisionId'], $previousCount['resubmitCount'], $previousCount['dateDecided']);
				break;
		}
	}

	function savePdf() {
		$meeting =& $this->meeting;
		$submission =& $this->submission;

		$summary = $submission->getSummaryFile()!=null ? $submission->getSummaryFile() : $this->getData('summary');
		$specificDiscussionText = $this->getData('discussionText');
		$discussionType = $this->getData('discussionType');
		$typeOther = $this->getData('typeOther');
		$isUnanimous = $this->getData('unanimous')=="Yes" ? true: false;
		$decision = $this->getData("decision");
		$votes= $this->getData("votes");
		$minorityReason = $this->getData("minorityReason");
		$chairReview = $this->getData('chairReview');
			
		$pdf = new PDF();
		$pdf->AddPage();
		$pdf->ChapterTitle('CONTINUING REVIEW of ' . $submission->getLocalizedTitle());
		$pdf->ChapterItemKeyVal('Protocol Title', $submission->getLocalizedTitle(), "BU");
		$pdf->ChapterItemKeyVal('Principal Investigator (PI)', $submission->getAuthorString(), "BU");
		$pdf->ChapterItemKeyVal('WPRO Role in Research', $this->getData('wproRole'), "BU");
		$pdf->ChapterItemKeyVal('Unique project identification # assigned', $submission->getLocalizedWhoId() , "BU");
		$pdf->ChapterItemKeyVal('Responsible WPRO Staff Member', $submission->getUser()->getFullName(), "BU");

		$pdf->ChapterItemKey('Protocol Summary', "BU");
		$pdf->ChapterItemVal($summary);
		$pdf->ChapterItemKey("(a) Discussion", "BU");
		$pdf->ChapterItemKey('General', "B");
		$pdf->ChapterItemVal($this->getData('generalDiscussion'));

		if($specificDiscussionText!=null) {
			$pdf->ChapterItemKey('Specific', "B");
			$count = 0;
			foreach($specificDiscussionText as $idx=>$discussionText) {
				if($discussionText!="" || $discussionText!=null) {
					$count++;
					$printType = $discussionType[$idx] == MINUTES_REVIEW_OTHER_DISCUSSIONS ? $typeOther[$idx] : $meeting->getSpecificDiscussionsText($discussionType[$idx]);
					$pdf->ChapterItemKey("($count) $printType", "B");
					$pdf->ChapterItemVal($discussionText);
				}
			}
		}

		$pdf->ChapterItemKey('(b) Stipulations / Conditions', "BU");
		$pdf->ChapterItemVal($this->getData('stipulations'));
		$pdf->ChapterItemKey('(c) Recommendations', "BU");
		$pdf->ChapterItemVal($this->getData('recommendations'));

		//$decision = $submission->getMostRecentDecision();
		if($isUnanimous) {
			switch($decision) {
				case SUBMISSION_EDITOR_DECISION_ACCEPT:
					$decisionStr = "The proposal was accepted in principal unanimously by all the members of WPRO-ERC present in the meeting, and was approved with clarifications mentioned above.";
					break;
				case SUBMISSION_EDITOR_DECISION_RESUBMIT:
					$decisionStr = "The proposal was assigned for revision and resubmission in principal unanimously by all the members of WPRO-ERC present in the meeting provided with the considerations and conditions mentioned above.";
					break;
				case SUBMISSION_EDITOR_DECISION_DECLINE:
					$decisionStr = "The proposal was not accepted in principal unanimously by all the members of WPRO-ERC present in the meeting due to concerns stated above.";
					break;
			}
		}
		else {
			switch($decision) {
				case SUBMISSION_EDITOR_DECISION_ACCEPT:
					$decisionStr = "The proposal was accepted in principal by the majority of WPRO-ERC members present in the meeting and was approved with clarifications mentioned above.";
					break;
				case SUBMISSION_EDITOR_DECISION_RESUBMIT:
					$decisionStr = "The proposal was assigned for revision and resubmission in principal by the majority of WPRO-ERC members present in the meeting provided with the considerations and conditions mentioned above.";
					break;
				case SUBMISSION_EDITOR_DECISION_DECLINE:
					$decisionStr = "The proposal was not accepted in principal unanimously by the majority of WPRO-ERC members present in the meeting due to concerns stated above.";
					break;
			}

			$votesStr = "The distribution of votes are as follows. ". $this->getData('votesApprove')." member(s) voted for, ".$this->getData('votesNotApprove')." member(s) voted against, ".$this->getData('votesAbstain')." member(s) abstained.";
			$reasonsStr = "Reasons for minority opinions are as follows: $minorityReason";
		}
		$pdf->ChapterItemKey('(d) IRB Decision and Votes', "BU");
		$pdf->ChapterItemVal($decisionStr);
		if(!$isUnanimous) {
			$pdf->ChapterItemVal($votesStr);
			$pdf->ChapterItemVal($reasonsStr);
			if($chairReview!=null)
			$pdf->ChapterItemVal($chairReview);
		}
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$filename = $submission->getLocalizedTitle().".pdf";
		$meetingFilesDir = Config::getVar('files', 'files_dir').'/journals/'.$journalId.'/meetings/'.$meeting->getId()."/continuingReviews/".$filename;

		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meeting->getId(), "continuingReviews", $submission->getId());
		if($minutesFileManager->createDirectory()) {
			$pdf->Output($meetingFilesDir,"F");
		}
	}


}

?>
