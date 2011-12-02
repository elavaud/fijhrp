<?php

/**
* class MeetingsHandler for SectionEditor and Editor Roles (STO)
* page handler class for minutes-related operations
* @var unknown_type
*/
define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);
// Filter section
define('FILTER_SECTION_ALL', 0);

import('classes.handler.Handler');

class ReportsHandler extends Handler {
	/**
	* Constructor
	**/
	function ReportsHandler() {
		parent::Handler();
		
		$this->addCheck(new HandlerValidatorJournal($this));
		// FIXME This is kind of evil
		$page = Request::getRequestedPage();
		if ( $page == 'sectionEditor' )
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_SECTION_EDITOR)));
		elseif ( $page == 'editor' )
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_EDITOR)));
	
	}

	/**
	* Setup common template variables.
	* @param $subclass boolean set to true if caller is below this handler in the hierarchy
	*/
	function setupTemplate() {
		parent::setupTemplate();
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_OJS_AUTHOR, LOCALE_COMPONENT_OJS_MANAGER));
		$templateMgr =& TemplateManager::getManager();
		$isEditor = Validation::isEditor();
		
		if (Request::getRequestedPage() == 'editor') {
			$templateMgr->assign('helpTopicId', 'editorial.editorsRole');
		
		} else {
			$templateMgr->assign('helpTopicId', 'editorial.sectionEditorsRole');
		}
		
		$roleSymbolic = $isEditor ? 'editor' : 'sectionEditor';
		$roleKey = $isEditor ? 'user.role.editor' : 'user.role.sectionEditor';
		$pageHierarchy = array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey), array(Request::url(null, $roleSymbolic, ''), 'editor.reports.reportGenerator'));
		
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}

	
	/**
	* Added by igmallare 10/10/2011
	* Display the meeting attendance report form
	* @param $args (type)
	*/
	function meetingAttendanceReport($args, &$request){
		import ('lib.pkp.classes.who.form.MeetingAttendanceReportForm');
		parent::validate();
		$this->setupTemplate();
		$meetingAttendanceReportForm= new MeetingAttendanceReportForm($args, $request);
		$isSubmit = Request::getUserVar('generateMeetingAttendance') != null ? true : false;
		
		if ($isSubmit) {
			$meetingAttendanceReportForm->readInputData();
			if($meetingAttendanceReportForm->validate()){	
					$this->generateMeetingAttendanceReport($args);
			}else{
				if ($meetingAttendanceReportForm->isLocaleResubmit()) {
					$meetingAttendanceReportForm->readInputData();
				}
				$meetingAttendanceReportForm->display($args);
			}
		}else {
			$meetingAttendanceReportForm->display($args);
		}
	}
	
	/**
	* Added by igmallare 10/11/2011
	* Generate csv file for the meeting attendance report
	* @param $args (type)
	*/
	function generateMeetingAttendanceReport($args) {
		parent::validate();
		$this->setupTemplate();
		$ercMembers = Request::getUserVar('ercMembers');
		
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$userDao = DAORegistry::getDAO('UserDAO');
		
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=meetingAttendanceReport-' . date('Ymd') . '.csv');
		
		$columns = array(
		'lastname' => Locale::translate('user.lastName'),
		'firstname' => Locale::translate('user.firstName'),
		'middlename' => Locale::translate('user.middleName'),
		'meeting_date' => Locale::translate('editor.reports.meetingDate'),
		'present' => Locale::translate('editor.reports.isPresent'),
		'reason_for_absence' => Locale::translate('editor.reports.reason')
		);
		$yesNoArray = array('present');
		$yesnoMessages = array( 0 => Locale::translate('common.no'), 1 => Locale::translate('common.yes'));
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array_values($columns));
		
		foreach ($ercMembers as $member) {
			$user = $userDao->getUser($member);
			list($meetingsIterator) =  $meetingDao->getMeetingReportByReviewerId($member, $fromDate, $toDate);
		
			$meetings = array();
			while ($row =& $meetingsIterator->next()) {
				foreach ($columns as $index => $junk) {
					if (in_array($index, $yesNoArray)) {
						$columns[$index] = $yesnoMessages[$row[$index]];
					} elseif ($index == "lastname") {
						$columns[$index] = $user->getLastName();
					} elseif ($index == "firstname") {
						$columns[$index] = $user->getFirstName();
					} elseif ($index == "middlename") {
						$columns[$index] = $user->getMiddleName();
					} else {
						$columns[$index] = $row[$index];
					}
				}
				String::fputcsv($fp, $columns);
				unset($row);
			}
		}
		fclose($fp);
	}
	
	/**
	* Added by MSB 10/11/2011
	* Generate csv file for the submission report
	* @param $args (type)
	*/
	function submissionsReport($args) {
		import ('lib.pkp.classes.who.form.SubmissionsReportForm');
		parent::validate();
		$this->setupTemplate();
		$submissionsReportForm= new SubmissionsReportForm($args, $request);
		$isSubmit = Request::getUserVar('generateSubmissionsReport') != null ? true : false;
	
		if ($isSubmit) {
			$submissionsReportForm->readInputData();
			if($submissionsReportForm->validate()){
				$this->generateSubmissionsReport($args);
			}else{
				if ($submissionsReportForm->isLocaleResubmit()) {
					$submissionsReportForm->readInputData();
				}
				$submissionsReportForm->display($args);
			}
		}else {
			$submissionsReportForm->display($args);
		}
	}
	
	
	/**
	 * Added by MSB 10/11/2011
	 * Generate csv file for the submission report
	 * @param $args (type)
	 */
	function generateSubmissionsReport($args) {
		parent::validate();
		$this->setupTemplate();
	
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
	
		$countryField = Request::getUserVar('countries');
		$countryField = !empty($countryField) ? $countryField : null;
		$decisionField = Request::getUserVar('decisions');
		$technicalUnitField = Request::getUserVar('technicalUnits');
	
	
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
	
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'id';
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == 'ASC' || $sortDirection == 'DESC')) ? $sortDirection : 'ASC';
		$editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');
	
		$submissions =& $editorSubmissionDao->getEditorSubmissionsReport(
		$journalId,
		$sectionId,
		$editorId,
		$searchField,
		$searchMatch,
		$search,
		$dateSearchField,
		$fromDate,
		$toDate,
		$technicalUnitField,
		$countryField,
		$decisionField,
		$rangeInfo,
		$sort,
		$sortDirection
		);
			
	
		$submissionsArray = $submissions->toArray();
	
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=submissionsReport-' . date('Ymd') . '.csv');
	
		$columns = array(
					'whoId' => Locale::translate("editor.reports.whoId"),
					'title' => Locale::translate("editor.reports.title"),
					'author' => Locale::translate("editor.reports.author"),
					'submitDate' =>  Locale::translate("editor.reports.submitDate"),
					'country' => Locale::translate("editor.reports.country"),
					'technicalUnit' =>  Locale::translate("editor.reports.technicalUnit"),
					'decision' => Locale::translate("editor.reports.decision")
		);
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array_values($columns));
	
	
		foreach ($submissionsArray as $submission) {
				
			$row['whoId'] = $submission->getWhoId($submission->getLocale());
			$row['title'] = $submission->getLocalizedTitle();
			$row['author'] = $submission->getFirstAuthor(true);
			$row['submitDate'] = $submission->getDateSubmitted();
			$row['country'] = $submission->getProposalCountry($submission->getLocale());
			$row['technicalUnit'] = $submission->getLocalizedTechnicalUnitText();
			$row['decision'] = Locale::translate($submission->getEditorDecisionKey());
			String::fputcsv($fp, $row);
			unset($row);
		}
	
		fclose($fp);
	}

}

?>
