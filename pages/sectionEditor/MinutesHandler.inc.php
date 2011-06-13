<?php

define('FILTER_SECTION_ALL', 0);
import('classes.handler.Handler');
import('classes.sectionEditor.Minutes');
import('classes.submission.sectionEditor.SectionEditorSubmission');

class MinutesHandler extends Handler {
	
	/**
	 * Constructor
	 */
	function MinutesHandler(){
		parent::Handler();
		$this->addCheck(new HandlerValidatorJournal($this));
	}
	
	/**
	 * Process submitted minutes
	 */
	/*
	function minutes($args, $request) {
		$step = isset($args[0]) ? (int) $args[0] : Request::getUserVar('step');
		$journal =& $request->getJournal();
		
		$this->setupTemplate();
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('step', $step);
		$templateMgr->display("sectionEditor/minutesStep{$step}.tpl");
	}
	
	function saveMinutes($args, $request) {
		$step = Request::getUserVar('step');
		$journal =& $request->getJournal();	
		Request::redirect(null, null, 'minutes', $step+1);
	}
	*/
	
	function minutes($args, $request) {
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$sectionEditorSubmissionDao =& DAORegistry::getDAO('SectionEditorSubmissionDAO');
		
		$submit = Request::getUserVar("submitMinutes");
		if($submit) {
			$minutesObj = new Minutes();
			$minutesObj->setDateHeld(Request::getUserVar("annc_dateHeld"));
			$minutesObj->setAnnouncements(Request::getUserVar("annc_announcements"));
			$minutesObj->setTimeConvened(Array('hour'=>Request::getUserVar("annc_convenedAtHour"),'minute'=>Request::getUserVar("annc_convenedAtMinute"),'amPm'=>Request::getUserVar("annc_convenedAtAmPm")));						
		}
		else {
			//defaults
			
		}
		
		$filterSection = FILTER_SECTION_ALL;
		$committee =& $sectionEditorSubmissionDao->getErcReviewCommittee();
		$submissions =& $sectionEditorSubmissionDao->getSectionEditorSubmissionsForErcReview($user->getId(),$journal->getId(),$filterSection);
		
		for($ctr = 1 ; $ctr<=12 ; $ctr++) {
			$hours[$ctr] = $ctr;
		}
		for($ctr = 1 ; $ctr<=59 ; $ctr++) {
			$minutes[$ctr] = $ctr;
		}
		$amPm = array ('am' => "a.m.", "pm" => "p.m.");
		
		$this->setupTemplate();
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('minutesObj', $minutesObj);
		$templateMgr->assign_by_ref('committee', $committee);
		$templateMgr->assign('submissions', $submissions);
		$templateMgr->assign('hours', $hours);
		$templateMgr->assign('minutes', $minutes);
		$templateMgr->assign('amPm', $amPm);
		$templateMgr->assign_by_ref('editorDecisionOptions', SectionEditorSubmission::getEditorDecisionOptions());
		$templateMgr->display("sectionEditor/minutesForm.tpl");
	}
	
	function minutesxxx($args, $request) {
		$step = isset($args[0]) ? (int) $args[0] : 0;
		$journal =& $request->getJournal();
		$minutesObj = Request::getUserVar('minutesObj');
		$this->setupTemplate();
		$templateMgr =& TemplateManager::getManager();
		import("classes.sectionEditor.Minutes");
		$minutesObj = new Minutes();
		
		$formClass = "MinutesStep{$step}Form";
		import("classes.sectionEditor.form.$formClass");
		
		$submitForm = new $formClass($minutesObj);
		$submitForm->initData();
		$templateMgr->display();
	}
	
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
			$pageHierarchy = $subclass ? array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey), array(Request::url(null, $roleSymbolic), 'article.submissions'))
				: array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey));
	
			import('classes.submission.sectionEditor.SectionEditorAction');
			$submissionCrumb = SectionEditorAction::submissionBreadcrumb($articleId, $parentPage, $roleSymbolic);
			if (isset($submissionCrumb)) {
				$pageHierarchy = array_merge($pageHierarchy, $submissionCrumb);
			}
			$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}
		
}

?>
