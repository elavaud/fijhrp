<?php

/**
 * @defgroup sectionEditor_form
 */

/**
 * @file /classes/submission/sectionEditor/form/SubmissionReportForm.inc.php
 *
 * Added by MSB. Last Updated: Oct 13, 2011
 * @class SubmissionsReportForm
 * @ingroup sectionEditor_form
 *
 * @brief Form for section editors to generate meeting attendance report form.
 */


import('lib.pkp.classes.form.Form');

class SubmissionsReportForm extends Form {
	/**
	 * Constructor.
	 */
	function SubmissionsReportForm(&$request) {
		parent::Form('sectionEditor/reports/submissionsReport.tpl');
		$site =& Request::getSite();
		$user =& Request::getUser();
		// Validation checks for this form
		$this->addCheck(new FormValidatorPost($this));
		//$this->addCheck(new FormValidator($this,'countries', 'required', 'editor.reports.countryRequired'));
		//$this->addCheck(new FormValidator($this,'decisions', 'required', 'editor.reports.decisionRequired'));
	}
	
	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'decisions',
			'countries',
		));
	}

	function display() {
		
		$templateMgr =& TemplateManager::getManager();
		$decisionOptions = array(
				'editor.article.decision.approved' => 'editor.article.decision.approved',
				'editor.article.decision.resubmit' => 'editor.article.decision.resubmit',
				'editor.article.decision.declined' => 'editor.article.decision.declined',
				'editor.article.decision.complete' => 'editor.article.decision.complete',
				'editor.article.decision.incomplete' => 'editor.article.decision.incomplete',
				'editor.article.decision.exempted' => 'editor.article.decision.exempted',
				'editor.article.decision.fullReview' => 'editor.article.decision.fullReview',
				'editor.article.decision.expedited' => 'editor.article.decision.expedited'
		);
		$templateMgr->assign_by_ref('decisionsOptions', $decisionOptions);

        $articleDao =& DAORegistry::getDAO('ArticleDAO');
        $agencies = $articleDao->getAgencies();
        $templateMgr->assign('agencies', $agencies);
        
        //Get research fields
        $researchFields = $articleDao->getResearchFields();
        $templateMgr->assign('researchFields', $researchFields);
		
        // Get proposal types
        $proposalTypes = $articleDao->getProposalTypes();
        $templateMgr->assign('proposalTypes', $proposalTypes);
		
		$countryDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
        $countries =& $countryDAO->getAreasOfTheCountry();
        $templateMgr->assign_by_ref('countriesOptions', $countries);
                
                $fromDate = Request::getUserDateVar('dateFrom', 1, 1);
                if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
                $toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
                if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
                $templateMgr->assign('dateFrom', $fromDate);
                $templateMgr->assign('dateTo', $toDate);
        
     	        parent::display();
	}

	
}

?>
