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
import('lib.pkp.classes.who.Meeting');

class MeetingsHandler extends Handler {
/**
* Constructor
**/
function MeetingsHandler() {
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
function setupTemplate($subclass = false, $articleId = 0, $parentPage = null, $showSidebar = true) {
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

/**
* Display submission management instructions.
* @param $args (type)
*/
function instructions($args) {
	$this->setupTemplate();
	import('classes.submission.proofreader.ProofreaderAction');
	if (!isset($args[0]) || !ProofreaderAction::instructions($args[0], array('copy', 'proof', 'referenceLinking'))) {
		Request::redirect(null, null, 'index');
	}
}

function meetings($args) {
	$this->validate();
	$this->setupTemplate();
	$journal =& Request::getJournal();
	$journalId = $journal->getId();
	$user =& Request::getUser();
	$userId = $user->getId();
	
	$meetingDao = DAORegistry::getDAO('MeetingDAO');
	$meetings =& $meetingDao->getMeetingsOfUser($userId);
	
	$templateMgr =& TemplateManager::getManager();
	$templateMgr->assign_by_ref('meetings', $meetings);
	$templateMgr->assign('pageToDisplay', $page);
	$templateMgr->assign('sectionEditor', $user->getFullName());
	$templateMgr->display('sectionEditor/meetings/meetings.tpl');
}

/**
* Added by MSB
* Display the setMeeting page
* @param $args (type)
*/

function setMeeting($args) {

	$this->validate();
	$this->setupTemplate();
	$journal =& Request::getJournal();
	$journalId = $journal->getId();
	$user =& Request::getUser();
	
	$editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');
	$sectionDao =& DAORegistry::getDAO('SectionDAO');
	
	$sections =& $sectionDao->getSectionTitles($journalId);

	$submissions =& $editorSubmissionDao->getEditorSubmissionsForERCReview(
		$journalId,
		FILTER_SECTION_ALL,
		$user->getId()
	);
	
	
	$meetingId = isset($args[0]) ? $args[0]: 0;
	/*LIST THE SUBMISSIONS*/
	$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');
	$selectedProposals =$meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meetingId);
	
	/*MEETING DETAILS*/
	$meetingDao =& DAORegistry::getDAO('MeetingDAO');
	$meeting =$meetingDao->getMeetingById($meetingId);
			
	/*RESPONSES FROM REVIEWERS*/
	$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');	
	$reviewers = $meetingReviewerDao->getMeetingReviewersByMeetingId($meetingId);

	
	$templateMgr =& TemplateManager::getManager();
	$templateMgr->assign('helpTopicId', $helpTopicId);
	$templateMgr->assign('sectionOptions', $filterSectionOptions);
	$templateMgr->assign_by_ref('submissions', $submissions);
	$templateMgr->assign('filterSection', $filterSection);
	$templateMgr->assign('pageToDisplay', $page);
	$templateMgr->assign('sectionEditor', $user->getFullName());
	$templateMgr->assign_by_ref('selectedProposals', $selectedProposals);
	$templateMgr->assign_by_ref('meeting', $meeting);
	$templateMgr->assign_by_ref('reviewers', $reviewers);

	// Set search parameters
	$duplicateParameters = array(
		'searchField', 'searchMatch', 'search',
		'dateFromMonth', 'dateFromDay', 'dateFromYear',
		'dateToMonth', 'dateToDay', 'dateToYear',
		'dateSearchField'
		);
	foreach ($duplicateParameters as $param)
		$templateMgr->assign($param, Request::getUserVar($param));
	
	$templateMgr->assign('dateFrom', $fromDate);
	$templateMgr->assign('dateTo', $toDate);
	$templateMgr->assign('fieldOptions', Array(
		SUBMISSION_FIELD_TITLE => 'article.title',
		SUBMISSION_FIELD_AUTHOR => 'user.role.author',
		SUBMISSION_FIELD_EDITOR => 'user.role.editor'
		));
	$templateMgr->assign('dateFieldOptions', Array(
		SUBMISSION_FIELD_DATE_SUBMITTED => 'submissions.submitted',
		SUBMISSION_FIELD_DATE_COPYEDIT_COMPLETE => 'submissions.copyeditComplete',
		SUBMISSION_FIELD_DATE_LAYOUT_COMPLETE => 'submissions.layoutComplete',
		SUBMISSION_FIELD_DATE_PROOFREADING_COMPLETE => 'submissions.proofreadingComplete'
		));
	
	import('classes.issue.IssueAction');
	$issueAction = new IssueAction();
	$templateMgr->register_function('print_issue_id', array($issueAction, 'smartyPrintIssueId'));
	$templateMgr->assign('sort', $sort);
	$templateMgr->assign('sortDirection', $sortDirection);
	$templateMgr->display('sectionEditor/meetings/setMeeting.tpl');
	}
	
	/**
	* Added by MSB 07/06/11
	* Store meeting details such as proposals to discuss and meeting date
	* @ param $args (type)
	*/
	
	function saveMeeting($args){
		$this->validate();
		$selectedProposals = Request::getUserVar('selectedProposals');
		$meetingDate = Request::getUserVar('meetingDate');
		$meetingId = isset($args[0]) ? $args[0]: 0;
		
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$meetingSubmissionDao =& DAORegistry::getDAO('MeetingSubmissionDAO');			
		if($meetingId == 0) {
		
			$meetingDao =& DAORegistry::getDAO('MeetingDAO');
			$meetingId = $meetingDao->createMeeting($userId,$meetingDate,$status = 0);
			
			$userDao =& DAORegistry::getDAO('UserDAO');
			$reviewers =& $userDao->getUsersWithReviewerRole();
			$meetingReviewerDao =& DAORegistry::getDAO('MeetingReviewerDAO');		


			$count = 0;
			foreach($reviewers as $reviewer) {
				$reviewerId = $reviewer->getId();
				$meetingReviewerDao->insertMeetingReviewer($meetingId,$reviewerId);
			}

		}else{

			$meetingSubmissionDao->deleteMeetingSubmissionsByMeetingId($meetingId);
		}


		if (count($selectedProposals) > 0) {
			for ($i=0;$i<count($selectedProposals);$i++) {
				//echo "Proposal' IDs";
				//should insert into database
				$selectedProposals[$i];
				$meetingSubmissionDao->insertMeetingSubmission($meetingId,$selectedProposals[$i]);
			}
		}
		
			Request::redirect(null, null, 'setMeeting', array($meetingId));
			//$this->setMeeting(array($meetingId));
		}
	}

?>
