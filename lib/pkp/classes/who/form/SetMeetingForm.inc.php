<?php

/**
 * @defgroup sectionEditor_form
 */

/**
 * @file lib/pkp/classes/who/SetMeetingForm.inc.php
 *
 * Added by MSB. Last Updated: July 14, 2011
 * @class SetMeetingForm
 * @ingroup sectionEditor_form
 *
 * @brief Form for section editors to create meeting.
 */


import('lib.pkp.classes.form.Form');

class SetMeetingForm extends Form {

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

	/**
	 * Initialize form
	 * */
	function initData($args){

		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		/*Get the selected submissions to be reviewed*/
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
		$selectedSubmissions =$meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
		
		/*Get the meeting details*/
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
	
		/*Get the selected submissions to be reviewed*/
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =$meetingDao->getMeetingById($meetingId);
		
		/*Get the selected submissions to be reviewed*/
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
