<?php

/**
 * @defgroup sectionEditor_form
 */

/**
 * @file classes/sectionEditor/form/CreateExternalReviewerForm.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class CreateExternalReviewerForm
 * @ingroup sectionEditor_form
 *
 * @brief Form for section editors to create reviewers.
 */

// $Id$


import('lib.pkp.classes.form.Form');

class SetMeetingForm extends Form {

	/** @var int The article this form is for */

	var $userId;
	/**
	 * Constructor.
	 */
	function SetMeetingForm(&$request) {
		parent::Form('sectionEditor/meetings/setMeeting.tpl');
		$site =& Request::getSite();
		$user =& Request::getUser();
		
		// Validation checks for this form
		$this->addCheck(new FormValidatorPost($this));
		$this->addCheck(new FormValidator($this,'meetingDate', 'required', 'editor.meetings.form.meetingDateRequired'));
		$this->addCheck(new FormValidator($this,'selectedProposals', 'required', 'editor.meetings.form.selectAtleastOneProposal'));
	}
	
	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'selectedProposals',
			'meetingDate',
			'meetingId'
		));
	
	}

	function initData($args){

		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		/*LIST THE SUBMISSIONS*/
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$selectedSubmissions =$meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		
		/*MEETING DETAILS*/
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =$meetingDao->getMeetingById($meetingId);
		
		$this->_data = array(
			'selectedProposals' => $selectedSubmissions,
			'meetingDate' => $meeting->getDate(),
			'meetingId' => $meeting->getId()
		);
	}
	
	/**
	 * Display the form.
	 */
	function display(&$args) {

		$meetingId = isset($args[0]) ? $args[0]: 0;
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();

		$site =& Request::getSite();
		
		$editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		
		$editor = $user->getId();

		
		$filterSection = Request::getUserVar('filterSection');
		if ($filterSection != '' && array_key_exists($filterSection, $filterSectionOptions)) {
			$user->updateSetting('filterSection', $filterSection, 'int', $journalId);
		} else {
			$filterSection = $user->getSetting('filterSection', $journalId);
			if ($filterSection == null) {
				$filterSection = FILTER_SECTION_ALL;
				$user->updateSetting('filterSection', $filterSection, 'int', $journalId);
			}	
		}
		
		$submissions =& $editorSubmissionDao->getEditorSubmissionsForERCReview(
			$journalId,
			$filterSection,
			$editorId
		);
	
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =$meetingDao->getMeetingById($meetingId);

		/*LIST THE SUBMISSIONS*/
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$selectedSubmissions =$meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('meetingId', $meetingId);
		$templateMgr->assign('meetingDate', $meeting->getDate());
		$templateMgr->assign_by_ref('submissions', $submissions);
		$templateMgr->assign_by_ref('selectedProposals', $selectedSubmissions);
		$templateMgr->assign('baseUrl', Config::getVar('general', "base_url"));
		parent::display();
	}

	
}

?>
