<?php

/**
 * @file classes/manager/form/InstitutionForm.inc.php
 *
 * @class InstitutionForm
 * @ingroup manager_form
 *
 * @brief Form for creating and modifying journal sections.
 */

// $Id$

import('lib.pkp.classes.form.Form');
import('classes.journal.Institution');

class InstitutionForm extends Form {

	/** @var $sectionId int The ID of the section being edited */
	var $institutionId;

	/** @var $includeSectionEditor object Additional section editor to
	 *       include in assigned list for this section
	 */
	var $includeSectionEditor;

	/** @var $omitSectionEditor object Assigned section editor to omit from
	 *       assigned list for this section
	 */
	var $omitSectionEditor;

	/** @var $sectionEditors array List of user objects representing the
	 *       available section editors for this journal.
	 */
	var $sectionEditors;

	/**
	 * Constructor.
	 * @param $journalId int omit for a new journal
	 */
	function InstitutionForm($institutionId = null) {
		parent::Form('manager/institutions/institutionForm.tpl');
		$this->institutionId = $institutionId;

		// Validation checks for this form
		$this->addCheck(new FormValidator($this, 'title', 'required', 'manager.institutions.form.nameRequired'));
		$this->addCheck(new FormValidator($this, 'region', 'required', 'manager.institutions.form.regionRequired'));
		$this->addCheck(new FormValidator($this, 'institution_type', 'required', 'manager.institutions.form.typeRequired'));
	}


	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$templateMgr =& TemplateManager::getManager();
		
		$templateMgr->assign('institutionId', $this->institutionId);

       	$regionDAO =& DAORegistry::getDAO('AreasOfTheCountryDAO');
        $regions =& $regionDAO->getAreasOfTheCountry();
        $templateMgr->assign_by_ref('regions', $regions);
        
        $templateMgr->assign('institutionTypes', array(
        	'' => 'common.chooseOne',
        	INSTITUTION_TYPE_GOVERNMENT => 'institution.government',
        	INSTITUTION_TYPE_PRIVATE => 'institution.private'
        ));
		parent::display(); 
	}

	/**
	 * Initialize form data from current settings.
	 */
	function initData() {
		if (isset($this->institutionId)) {
			$institutionDao =& DAORegistry::getDAO('InstitutionDAO');
			$institution =& $institutionDao->getInstitutionById($this->institutionId);
			
			$this->_data = array(
				'title' => $institution->getInstitution(), // Localized
				'region' => $institution->getRegion(), // Localized
				'institutionType' => $institution->getInstitutionType()
			);
		}
	}

	/**
	 * Assign form data to user-submitted data.
	 * Added region
	 * EL on February 11th 2013
	*/
	function readInputData() {
	
		$this->readUserVars(array('title', 'region', 'institution_type'));
	}

	/**
	 * Save institution.
	*/
	function execute() {

		$institutionDao =& DAORegistry::getDAO('InstitutionDAO');

		if (isset($this->institutionId)) {
			$institution =& $institutionDao->getInstitutionById($this->institutionId);
		}
		
		if (!isset($institution))
			$institution = new Institution();
		
		$institution->setInstitution($this->getData('title'));
		$institution->setRegion($this->getData('region'));
		$institution->setInstitutionType($this->getData('institution_type'));

		if ($institution->getId() != null)
			$institutionDao->updateInstitution($institution);
		else
			$institutionDao->insertInstitution($institution);
	}
}

?>
