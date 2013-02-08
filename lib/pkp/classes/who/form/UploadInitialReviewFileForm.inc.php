<?php

/**
 * @defgroup sectionEditor_form
 */

import('lib.pkp.classes.form.Form');
import('classes.submission.sectionEditor.SectionEditorAction');

class UploadInitialReviewFileForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $submission;
	/**
	 * Constructor.
	 */
	function UploadInitialReviewFileForm($meetingId, $articleId) {
		parent::Form('sectionEditor/minutes/uploadInitialReviewFile.tpl');
		$this->addCheck(new FormValidatorPost($this));

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		$submission =& $sectionEditorSubmissionDao->getSectionEditorSubmission($articleId);
		$this->submission = $submission;

		$this->addCheck(new FormValidator($this, 'minutesFileField', 'required', 'editor.minutes.minutesFileRequired'));		
	}

	/**
	 * Display the form.
	 */
	function display(&$args, &$request) {
		$meeting = $this->meeting;
		$submission =& $this->submission;
		$minutesFile = $this->minutesFile;
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign("minutesFileField", $this->getData("minutesFileField"));
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('submission', $submission);
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'minutesFileField'
		));
	}

	function execute() {
		$meeting =& $this->meeting;
		$submission =& $this->submission;
		import('classes.file.MinutesFileManager');
		$minutesUploader = new MinutesFileManager($meeting->getId(), null, $submission->getId());
		$minutesFile = $minutesUploader->uploadReview("minutesFile",$submission->getId());
	}

}

?>
