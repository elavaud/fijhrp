<?php

/**
 * @file InstitutionHandler.inc.php
 * @class InstitutionHandler
 * @ingroup pages_manager
 *
 * @brief Handle requests for institution management functions.
 */

// $Id$

import('pages.manager.ManagerHandler');

class InstitutionHandler extends ManagerHandler {
	/**
	 * Constructor
	 **/
	function InstitutionHandler() {
		parent::ManagerHandler();
	}
	/**
	 * Display a list of the institutions within the current journal.
	 */
	function institutions() {
		$this->validate();
		$this->setupTemplate();
		$institutionDAO =& DAORegistry::getDAO('InstitutionDAO');
		
		$rangeInfo =& Handler::getRangeInfo('institutions');
		
		/* Addition of sort and sortDirection*/
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'institution';
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == SORT_DIRECTION_ASC || $sortDirection == SORT_DIRECTION_DESC)) ? $sortDirection : SORT_DIRECTION_ASC;
		
		$institutions =& $institutionDAO->getAllInstitutions($rangeInfo, $sort, $sortDirection);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->addJavaScript('lib/pkp/js/jquery.tablednd_0_5.js');
		$templateMgr->addJavaScript('lib/pkp/js/tablednd.js');
		//$templateMgr->assign('pageHierarchy', array(array(Request::url(null, 'manager'), 'manager.journalManagement')));
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->assign_by_ref('institutions', $institutions);
		$templateMgr->display('manager/institutions/institutions.tpl');
	}
	
	/**
	 * Deletes an institution.
	 */
	function deleteInstitution($args) {
		$this->validate();

		if (isset($args) && !empty($args)) {
			$institutionDao =& DAORegistry::getDAO('InstitutionDAO');
			$institutionDao->deleteInstitutionById($args[0]);
		}
		Request::redirect(null, null, 'institutions');
	}
	
	/**
	 * Save changes to an institution.
	 */
	function updateInstitution($args = array()) {
		$this->validate();
		$this->setupTemplate(true);
		import('classes.manager.form.institutionForm');
		$institutionForm = new InstitutionForm(!isset($args) || empty($args) ? null : ((int) $args[0]));

		$institutionForm->readInputData();
		if ($institutionForm->validate()) {
			$institutionForm->execute();
			Request::redirect(null, null, 'institutions');
		} else {
			$institutionForm->display();
		}
	}
	
	/*
	 * Display form to create a new institution.
	*/
	function createInstitution() { 
		$this->editInstitution();
	}
	
	/**
	 * Display form to create/edit a institution.
	 * @param $args array optional, if set the first parameter is the ID of the institution to edit
	*/
	function editInstitution($args = array()) {

		$this->validate();
		$this->setupTemplate(true);
		import('classes.manager.form.InstitutionForm');
		
		$institutionForm = new InstitutionForm(!isset($args) || empty($args) ? null : ((int) $args[0]));
		
		$institutionForm->initData();
		
		$institutionForm->display();
	}
	

	function setupTemplate($subclass = false) {
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_PKP_READER));
		parent::setupTemplate(true);
		if ($subclass) {
			$templateMgr =& TemplateManager::getManager();
			$templateMgr->append('pageHierarchy', array(Request::url(null, 'manager', 'institutions'), 'institution.institutions'));
		}
	}
}

?>
