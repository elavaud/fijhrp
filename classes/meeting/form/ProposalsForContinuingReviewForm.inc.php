<?php

/**
 * @defgroup sectionEditor_form
 */

import('classes.lib.fpdf.pdf');
import('lib.pkp.classes.form.Form');
import('classes.submission.sectionEditor.SectionEditorAction');

class ProposalsForContinuingReviewForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $submissions;
	/**
	 * Constructor.
	 */
	function ProposalsForContinuingReviewForm($meetingId, $journalId) {
		parent::Form('sectionEditor/minutes/selectContinuingReview.tpl');
		$this->addCheck(new FormValidatorPost($this));

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		
		$this->submissions = $sectionEditorSubmissionDao->getRemainingSubmissionsForContinuingReview($meetingId);
		$this->addCheck(new FormValidatorCustom($this, 'articleId', 'required', 'editor.minutes.selectProposalRequired',
		create_function('$articleId', 'if($articleId == "none") return false; else return true;'), array('articleId')));		
	}

	/**
	 * Display the form.
	 */
	function display(&$args, &$request) {
		$meeting = $this->meeting;
		$submissions =& $this->submissions;

		$templateMgr =& TemplateManager::getManager();		
		$templateMgr->assign("meeting", $meeting);
		$templateMgr->assign_by_ref('submissions', $submissions);
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'articleId'	
			));
	}
}
?>
