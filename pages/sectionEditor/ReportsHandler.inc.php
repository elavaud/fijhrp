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

import('classes.submission.sectionEditor.SectionEditorAction');
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
	function setupTemplate($subclass = false, $parentPage = null, $showSidebar = true) {
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
		$pageHierarchy = $subclass ? array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey), array(Request::url(null, $roleSymbolic, 'reports'), 'editor.reports'))
		: array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey));
		
		
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}

	function meetingReports($args) {
		$this->validate(0, true);
		$this->setupTemplate(false);
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		
		
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('sectionEditor', $user->getFullName());
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		
		// Set search parameters
		$duplicateParameters = array(
			'dateFromMonth', 'dateFromDay', 'dateFromYear',
			'dateToMonth', 'dateToDay', 'dateToYear'
		);
		foreach ($duplicateParameters as $param)
			$templateMgr->assign($param, Request::getUserVar($param));
		
		$templateMgr->display('sectionEditor/reports/meetingAttendance.tpl');
	}

}

?>
