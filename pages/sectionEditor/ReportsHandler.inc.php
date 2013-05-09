<?php

/**
* class MeetingsHandler for SectionEditor and Editor Roles (Secretary)
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
		$roleKey = $isEditor ? 'user.role.coordinator' : 'user.role.sectionEditor';
		$pageHierarchy = array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey), array(Request::url(null, $roleSymbolic, ''), 'editor.reports.reportGenerator'));
		
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}

	
	/**
	* Added by igmallare 10/10/2011
	* Display the meeting attendance report form
	* @param $args (type)
	*/
	function meetingAttendanceReport($args, &$request){
		import ('classes.meeting.form.MeetingAttendanceReportForm');
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
		import ('classes.submission.sectionEditor.SubmissionsReportForm');
		parent::validate();
		$this->setupTemplate();
		$submissionsReportForm= new SubmissionsReportForm($args);
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
	 * Generate csv file for the submission report
	 * @param $args (type)
	 */
	function generateSubmissionsReport($args) {
		parent::validate();
		$this->setupTemplate();
	
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$articleDao =& DAORegistry::getDAO('ArticleDAO');

		
		//Get user filter decision
		$sectionId = Request::getUserVar('erc');
		if ($sectionId != '1' && $sectionId != '2') $sectionId = null;
		$decisionField = Request::getUserVar('decisions');
		$sresearch = Request::getUserVar('studentResearch');
		$adegree = Request::getUserVar('academicDegree');
		$primarySponsorField = Request::getUserVar('primarySponsors');
		$secondarySponsorField = Request::getUserVar('secondarySponsors');
		$researchFieldField = Request::getUserVar('researchFields');
		$proposalTypeField = Request::getUserVar('proposalTypes');
		$dataCollection = Request::getUserVar('dataCollection');
		$multiCountry = Request::getUserVar('multicountry');
		$nationwide = Request::getUserVar('nationwide');
		$countryField = Request::getUserVar('regions');
		$startDateBefore = Request::getUserVar('startDateBefore');
		$startDateAfter = Request::getUserVar('startDateAfter');
		$endDateBefore = Request::getUserVar('endDateBefore');
		$endDateAfter = Request::getUserVar('endDateAfter');
		$submittedBefore = Request::getUserVar('submittedBefore');
		$submittedAfter = Request::getUserVar('submittedAfter');
		$approvedBefore = Request::getUserVar('approvedBefore');
		$approvedAfter = Request::getUserVar('approvedAfter');
		
		if(array_shift(array_values($countryField)) == "0"){
			$countryDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
        	$countries =& $countryDAO->getAreasOfTheCountry();
        	$countryField = array_keys($countries);
		}
$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'id';
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == 'ASC' || $sortDirection == 'DESC')) ? $sortDirection : 'ASC';
		
		$editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');
				
		$submissions =& $editorSubmissionDao->getEditorSubmissionsReport(
			$journalId,
			$sectionId,
			$sresearch,
			$adegree,
			$primarySponsorField,
			$secondarySponsorField,
			$researchFieldField,
			$proposalTypeField,
			$dataCollection,
			$multiCountry,
			$nationwide,
			$countryField,
			$startDateBefore,
			$startDateAfter,
			$endDateBefore,
			$endDateAfter,
			$submittedBefore,
			$submittedAfter,
			$approvedBefore,
			$approvedAfter,
			$decisionField,
			$sort,
			$sortDirection
		);
		
		$submissionsArray = $submissions->toArray();
	
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=submissionsReport-' . date('Ymd') . '.csv');
		
		// Get ready the csv 
		$columns = array();
		
		if (Request::getUserVar('checkProposalId')){
			$columns = $columns + array('proposalId' => Locale::translate("editor.reports.proposalId"));
		}
		if (Request::getUserVar('checkErc')){
			$columns = $columns + array('erc' => Locale::translate("editor.reports.erc"));
		}
		if (Request::getUserVar('checkDecision')){
			$columns = $columns + array('decision' => Locale::translate("editor.reports.decision"));
		}
		if (Request::getUserVar('checkDateSubmitted')){
			$columns = $columns + array('submitDate' =>  Locale::translate("editor.reports.submitDate"));
		}		
		if (Request::getUserVar('checkDateApproved')){
			$columns = $columns + array('approvedDate' =>  Locale::translate("editor.reports.approveDate"));
		}
		if (Request::getUserVar('checkName')){
			$columns = $columns + array('author' => Locale::translate("editor.reports.author"));
		}
		if (Request::getUserVar('checkAffiliation')){
			$columns = $columns + array('authorAffiliation' => Locale::translate("editor.reports.authorAffiliation"));
		}
		if (Request::getUserVar('checkEmail')){
			$columns = $columns + array('authorEmail' => Locale::translate("editor.reports.authorEmail"));
		}
		if (Request::getUserVar('checkScientificTitle')){
			$columns = $columns + array('scientificTitle' => Locale::translate("editor.reports.scientificTitle"));
		}
		if (Request::getUserVar('checkPublicTitle')){
			$columns = $columns + array('publicTitle' => Locale::translate("editor.reports.publicTitle"));
		}
		if (Request::getUserVar('checkStudentResearch')){
			$columns = $columns + array('studentInstitution' => Locale::translate("editor.reports.studentInstitution"));
			$columns = $columns + array('studentAcademicDegree' => Locale::translate("editor.reports.studentAcademicDegree"));
		}
		if (Request::getUserVar('checkPrimarySponsor')){
			$columns = $columns + array('primarySponsor' => Locale::translate("editor.reports.primarySponsor"));
		}
		if (Request::getUserVar('checkSecondarSponsor')){
			$columns = $columns + array('secondaySponsor' => Locale::translate("editor.reports.secondarySponsor"));
		}
		if (Request::getUserVar('checkResearchFields')){
			$columns = $columns + array('researchField' => Locale::translate("editor.reports.researchField"));
		}
		if (Request::getUserVar('checkProposalTypes')){
			$columns = $columns + array('proposalType' => Locale::translate("editor.reports.proposalType"));
		}
		if (Request::getUserVar('checkDuration')){
			$columns = $columns + array('duration' => Locale::translate("editor.reports.duration"));
		}
		if (Request::getUserVar('checkArea')){
			$columns = $columns + array('geoArea' => Locale::translate("editor.reports.country"));
		}
		if (Request::getUserVar('checkDataCollection')){
			$columns = $columns + array('dataCollection' => Locale::translate("editor.reports.dataCollection"));
		}
		if (Request::getUserVar('checkBudget')){
			$columns = $columns + array('budget' => Locale::translate("editor.reports.budget"));
			$columns = $columns + array('currency' => Locale::translate("editor.reports.currency"));
		}
		if (Request::getUserVar('checkErcReview')){
			$columns = $columns + array('otherErc' => Locale::translate("editor.reports.otherErcReview"));
		}
		if (Request::getUserVar('checkIndustryGrant')){
			$columns = $columns + array('industryGrant' => Locale::translate("editor.reports.industryGrant"));
		}
		if (Request::getUserVar('checkAgencyGrant')){
			$columns = $columns + array('agencyGrant' => Locale::translate("editor.reports.agencyGrant"));
		}
		if (Request::getUserVar('checkMohGrant')){
			$columns = $columns + array('mohGrant' => Locale::translate("editor.reports.mohGrant"));
		}
		if (Request::getUserVar('checkGovernmentGrant')){
			$columns = $columns + array('governmentGrant' => Locale::translate("editor.reports.governmentGrant"));
		}	
		if (Request::getUserVar('checkUniversityGrant')){
			$columns = $columns + array('universityGrant' => Locale::translate("editor.reports.universityGrant"));
		}
		if (Request::getUserVar('checkSelfFunding')){
			$columns = $columns + array('selfFunding' => Locale::translate("editor.reports.selfFunding"));
		}	
		if (Request::getUserVar('checkOtherGrant')){
			$columns = $columns + array('otherGrant' => Locale::translate("editor.reports.otherGrant"));
		}

		
		//Write into the csv
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array(date("F j, Y", mktime(0,0,0)).' '.$journal->getLocalizedTitle().', Report of proposals'));
		
		$criterias = array();		
		
		if ($submittedBefore) array_push($criterias, ('submitted before "'.$submittedBefore.'" (inclusive)'));
		if ($submittedAfter) array_push($criterias, ('submitted after "'.$submittedAfter.'" (inclusive)'));
		if ($approvedBefore) array_push($criterias, ('approved before "'.$approvedBefore.'" (inclusive)'));
		if ($approvedAfter) array_push($criterias, ('approved after "'.$approvedAfter.'" (inclusive)'));
		if ($startDateBefore) array_push($criterias, ('with a start date before "'.$submittedBefore.'" (inclusive)'));
		if ($startDateAfter) array_push($criterias, ('with a start date after "'.$submittedAfter.'" (inclusive)'));
		if ($endDateBefore) array_push($criterias, ('with a end date before "'.$approvedBefore.'" (inclusive)'));
		if ($endDateAfter) array_push($criterias, ('with a end date after "'.$approvedAfter.'" (inclusive)'));
		if ($sectionId) {
			$sectionDao =& DAORegistry::getDAO('SectionDAO');
			$section =& $sectionDao->getSection($sectionId);
			array_push($criterias, ('submitted to '.$section->getLocalizedAbbrev()));
		}
		if (!empty($decisionField)){
			$decisionCriteria = "";
			$present = false;
			foreach ($decisionField as $decision){
				if(!empty($decision)){
					$present = true;
					if ($decisionCriteria == "" || $decisionCriteria == null) $decisionCriteria = Locale::translate($decision).' ';
					else $decisionCriteria .= 'or '.Locale::translate($decision).' ';
				}
			}
			if ($present == true) array_push($criterias, ("committe's decision is ".$decisionCriteria));
		}
		if ($sresearch){
			if (!$adegree){
				if ($sresearch == 'Yes') array_push($criterias, ("is conducted by a student"));
				else array_push($criterias, ("is not conducted by a student"));
			} elseif ($sresearch == 'Yes') array_push($criterias, ("is conducted by a student in a ".$adegree." academic degree"));
		}
		if (!empty($primarySponsorField)){
			$primarySponsorCriteria = "";
			$present = false;
			foreach ($primarySponsorField as $primarySponsor){
				if(!empty($primarySponsor)){
					$present = true;
					if ($primarySponsorCriteria == "" || $primarySponsorCriteria == null) $primarySponsorCriteria = $primarySponsor.' ';
					else $primarySponsorCriteria .= 'or '.$primarySponsor.' ';
				}
			}
			if ($present == true) array_push($criterias, ("the primary sponsor is ".$primarySponsorCriteria));
		}
		if (!empty($secondarySponsorField)){
			$secondarySponsorCriteria = "";
			$present = false;
			foreach ($secondarySponsorField as $secondarySponsor){
				if(!empty($secondarySponsor)){
					$present = true;
					if ($secondarySponsorCriteria == "" || $secondarySponsorCriteria == null) $secondarySponsorCriteria = $secondarySponsor.' ';
					else $secondarySponsorCriteria .= 'or '.$secondarySponsor.' ';
				}
			}
			if ($present == true) array_push($criterias, ("the secondary sponsor list includes ".$secondarySponsorCriteria));
		}
		if (!empty($researchFieldField)){
			$researchFieldCriteria = "";
			$present = false;
			foreach ($researchFieldField as $researchField){
				if(!empty($researchField)){
					$present = true;
					if ($researchFieldCriteria == "" || $researchFieldCriteria == null) $researchFieldCriteria = $articleDao->getResearchField($researchField).' ';
					else $researchFieldCriteria .= 'or '.$articleDao->getResearchField($researchField).' ';
				}
			}
			if ($present == true) array_push($criterias, ("the research field list includes ".$researchFieldCriteria));
		}
		if (!empty($proposalTypeField)){
			$proposalTypeCriteria = "";
			$present = false;
			foreach ($proposalTypeField as $proposalType){
				if(!empty($proposalType)){
					$present = true;
					if ($proposalTypeCriteria == "" || $proposalTypeCriteria == null) $proposalTypeCriteria = $articleDao->getProposalType($proposalType).' ';
					else $proposalTypeCriteria .= 'or '.$articleDao->getProposalType($proposalType).' ';
				}
			}
			if ($present == true) array_push($criterias, ("the proposal type list includes ".$proposalTypeCriteria));
		}		
		if ($dataCollection) {
			if ($dataCollection == 'Both') array_push($criterias, ('with primary and secondary data collections'));
			else array_push($criterias, ('with only '.$dataCollection.' data collection(s)'));
		}
		if ($multiCountry) {
			if ($multiCountry == 'Yes') array_push($criterias, ('is conducted in multiple countries'));
			else array_push($criterias, ('is conducted only in DemoNational'));
		} 
		if ($nationwide) {
			if ($nationwide == 'Yes') array_push($criterias, ('in the whole country'));
			else array_push($criterias, ('not in the whole country'));
		}					
		if (!empty($countryField)){
			$areasOfTheCountryDao =& DAORegistry::getDAO('AreasOfTheCountryDAO');
			$countryCriteria = "";
			$present = false;
			foreach ($countryField as $country){
				if(!empty($country)){
					$present = true;
					if ($countryCriteria == "" || $countryCriteria == null) $countryCriteria = $areasOfTheCountryDao->getAreaOfTheCountry($country).' ';
					else $countryCriteria .= 'or '.$areasOfTheCountryDao->getAreaOfTheCountry($country).' ';
				}
			}
			if ($present == true) array_push($criterias, ("the list of regions includes ".$countryCriteria));
		}	
		
		if (!empty($criterias)) {
			$i = 0;
			foreach ($criterias as $criteria) {
				if ($i != 0) {
					$criteria = 'and '.$criteria;
					String::fputcsv($fp, array('', $criteria));
				} else {
					String::fputcsv($fp, array('Criteria(s):', $criteria));
				}	
				$i++;			
			}
		} else String::fputcsv($fp, array('No criterias.'));
		
		String::fputcsv($fp, array(''));				
		String::fputcsv($fp, array_values($columns));
	
		
		foreach ($submissionsArray as $submission) {
			$abstract = $submission->getLocalizedAbstract();
			foreach ($columns as $index => $junk) {
				if ($index == 'proposalId') {
					$columns[$index] = $submission->getProposalId($submission->getLocale());
				} elseif ($index == 'erc') {
					$columns[$index] = $submission->getSectionAbbrev($submission->getLocale());
				} elseif ($index == 'decision') {
					if ($submission->getEditorDecisionKey()) $columns[$index] = Locale::translate($submission->getEditorDecisionKey());
					else $columns[$index] = 'None';
				} elseif ($index == 'submitDate') {
					$columns[$index] = $submission->getDateSubmitted();
				} elseif ($index == 'approvedDate') {
					if ($submission->getLocalizedApprovalDate()) {
						$approvalDate = $submission->getApprovalDate();
						$columns[$index] = $approvalDate['en_US'];
					}
					else $columns[$index] = 'Not approved';
				} elseif ($index == 'author') {
					$columns[$index] = $submission->getPrimaryAuthor();
				} elseif ($index == 'authorAffiliation') {
					if ($submission->getInvestigatorAffiliation()) $columns[$index] = $submission->getInvestigatorAffiliation();
					else $columns[$index] = 'None';
				} elseif ($index == 'authorEmail') {
					$columns[$index] = $submission->getAuthorEmail();
				} elseif ($index == 'scientificTitle') {
					$columns[$index] = $abstract->getScientificTitle();
				} elseif ($index == 'publicTitle') {
					$columns[$index] = $abstract->getPublicTitle();
				} elseif ($index == 'studentInstitution') {
					if ($submission->getLocalizedStudentInitiatedResearch() == 'Yes') $columns[$index] = $submission->getLocalizedStudentInstitution();
					else $columns[$index] = 'Non-Student';
				} elseif ($index == 'studentAcademicDegree') {
					if ($submission->getLocalizedStudentInitiatedResearch() == 'Yes')$columns[$index] = $submission->getLocalizedAcademicDegree();
					else $columns[$index] = 'Non-Student';
				} elseif ($index == 'primarySponsor') {
					$columns[$index] = $submission->getLocalizedPrimarySponsor();
				} elseif ($index == 'secondaySponsor') {
					if ($submission->getLocalizedSecondarySponsors()) $columns[$index] = $submission->getLocalizedSecondarySponsors();
					else $columns[$index] = 'None';
				} elseif ($index == 'researchField') {
					$columns[$index] = $submission->getLocalizedResearchFieldText();
				} elseif ($index == 'proposalType') {
					$columns[$index] = $submission->getLocalizedProposalTypeText();
				} elseif ($index == 'dataCollection') {
					$columns[$index] = $submission->getLocalizedDataCollection();
				} elseif ($index == 'geoArea') {
					if ($submission->getLocalizedMultiCountryResearch() == 'Yes') $columns[$index] = $submission->getLocalizedMultiCountryText();
					else if ($submission->getLocalizedNationwide()!='No') $columns[$index] = 'Nationwide Research';
					else  $columns[$index] = $submission->getLocalizedProposalCountryText();
				} elseif ($index == 'duration') {
					$columns[$index] = $submission->getLocalizedStartDate().' to '.$submission->getLocalizedEndDate();
				} elseif ($index == 'budget') {
					$columns[$index] = $submission->getLocalizedFundsRequired();
				} elseif ($index == 'currency') {
					$columns[$index] = $submission->getLocalizedSelectedCurrency();
				} elseif ($index == 'otherErc') {
					if ($submission->getLocalizedReviewedByOtherErc() == 'Yes') $columns[$index] = $submission->getLocalizedOtherErcDecision();
					else  $columns[$index] = 'No';
				} elseif ($index == 'industryGrant') {
					if ($submission->getLocalizedIndustryGrant() == 'Yes') $columns[$index] = $submission->getLocalizedNameOfIndustry();
					else  $columns[$index] = 'No';
				} elseif ($index == 'agencyGrant') {
					if ($submission->getLocalizedInternationalGrant() == 'Yes') $columns[$index] = $submission->getLocalizedInternationalGrantName();
					else $columns[$index] = 'No';
				} elseif ($index == 'mohGrant') {
					$columns[$index] = $submission->getLocalizedMohGrant();
				} elseif ($index == 'governmentGrant') {
					if ($submission->getLocalizedGovernmentGrant() == 'Yes') $columns[$index] = $submission->getLocalizedGovernmentGrantName();
					else $columns[$index] = 'No';
				} elseif ($index == 'universityGrant') {
					$columns[$index] = $submission->getLocalizedUniversityGrant();
				} elseif ($index == 'selfFunding') {
					$columns[$index] = $submission->getLocalizedSelfFunding();
				} elseif ($index == 'otherGrant') {
					if ($submission->getLocalizedOtherGrant() == 'Yes') $columns[$index] = $submission->getLocalizedSpecifyOtherGrant();
					else $columns[$index] = 'No';
				}			
			}						
			String::fputcsv($fp, $columns);
			unset($row);
		}
	
		fclose($fp);
	}

}

?>
