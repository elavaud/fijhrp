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

class MeetingAttendanceReportForm extends Form {

	/**
	 * Constructor.
	 */
	function MeetingAttendanceReportForm(&$request) {
		parent::Form('sectionEditor/reports/meetingAttendance.tpl');
		$site =& Request::getSite();
		$user =& Request::getUser();
		
		// Validation checks for this form
		$this->addCheck(new FormValidatorPost($this));
		$this->addCheck(new FormValidator($this,'ercMembers', 'required', 'editor.reports.form.selectAtLeastOneMember'));
	}
	
	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'ercMembers',
			'dateFrom',
			'dateTo'
		));
	
	}


	/**
	 * Display the form.
	 */
	function display(&$args) {

		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();

		$userDao =& DAORegistry::getDAO('UserDAO');		
		$reviewers =& $userDao->getUsersWithReviewerRole($journalId);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('reviewers', $reviewers);
		parent::display();
	}

	
}

?>
