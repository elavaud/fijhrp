
<?php

/**
 * @defgroup sectionEditor_form
 */

/**
 * @file /classes/meeting/form/MeetingAttendanceReportForm.inc.php
 *
 * Added by igmallare. Last Updated: Oct 11, 2011
 * @class MeetingAttendanceReportForm
 * @ingroup sectionEditor_form
 *
 * @brief Form for section editors to generate meeting attendance report form.
 */

/**
 * Last update on February 2013
 * EL
**/

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
		$this->addCheck(new FormValidator($this,'ercMembers', 'required', 'editor.reports.ercMemberRequired'));
	}
	
	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'ercMembers'
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
		$ercMembers =& $userDao->getUsersWithReviewerRole($journalId);
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('members', $ercMembers);
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		parent::display();
	}

	
}

?>
