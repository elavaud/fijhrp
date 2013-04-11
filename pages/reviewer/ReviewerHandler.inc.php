<?php

/**
 * @file ReviewerHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ReviewerHandler
 * @ingroup pages_reviewer
 *
 * @brief Handle requests for reviewer functions. 
 */



import('classes.submission.reviewer.ReviewerAction');
import('classes.handler.Handler');

class ReviewerHandler extends Handler {
	/**
	 * Constructor
	 **/
	function ReviewerHandler() {
		parent::Handler();

		$this->addCheck(new HandlerValidatorJournal($this));
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_REVIEWER)));		
	}

	/**
	 * Display reviewer index page.
	 * Last update: EL on March 1st 2013
	 */
	function index($args) {
		$this->validate();
		$this->setupTemplate();

		/**
		 * Get user search fields
		 * Added by: Ayvee Mallare
		 * Last Updated: Sept 25, 2011
		 */
		$searchField = Request::getUserVar('searchField');
		$dateSearchField = Request::getUserVar('dateSearchField');
		$searchMatch = Request::getUserVar('searchMatch');
		$search = Request::getUserVar('search');

		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate !== null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate !== null) $toDate = date('Y-m-d H:i:s', $toDate);
		
		$journal =& Request::getJournal();
		$user =& Request::getUser();
		$reviewerSubmissionDao =& DAORegistry::getDAO('ReviewerSubmissionDAO');
		$rangeInfo = Handler::getRangeInfo('submissions');
		$page = isset($args[0]) ? $args[0] : '';
		switch($page) {
			case 'completed':
				$active = false;
				break;
			default:
				$page = 'active';
				$active = true;
		}

		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'title';
		$sortDirection = Request::getUserVar('sortDirection');

		if ($sort == 'decision') {		
			$submissions = $reviewerSubmissionDao->getReviewerSubmissionsByReviewerId($user->getId(), $journal->getId(), $active,  $searchField, $searchMatch, $search, $dateSearchField, $fromDate, $toDate, $rangeInfo);
		
			// Sort all submissions by status, which is too complex to do in the DB
			$submissionsArray = $submissions->toArray();
			$compare = create_function('$s1, $s2', 'return strcmp($s1->getMostRecentDecision(), $s2->getMostRecentDecision());');
			usort ($submissionsArray, $compare);
			if($sortDirection == SORT_DIRECTION_DESC) {
				$submissionsArray = array_reverse($submissionsArray);
			}
			// Convert submission array back to an ItemIterator class
			import('lib.pkp.classes.core.ArrayItemIterator');
			//TODO change to array instead of iterator 
			$submissions =& ArrayItemIterator::fromRangeInfo($submissionsArray, $rangeInfo);
		}  else {
			$submissions = $reviewerSubmissionDao->getReviewerSubmissionsByReviewerId($user->getId(), $journal->getId(), $active,  $searchField, $searchMatch, $search, $dateSearchField, $fromDate, $toDate, $rangeInfo, $sort, $sortDirection);
											  
		}

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('reviewerRecommendationOptions', ReviewAssignment::getReviewerRecommendationOptions());
		$templateMgr->assign('pageToDisplay', $page);

		$templateMgr->assign_by_ref('submissions', $submissions);
		$templateMgr->assign('rangeInfo', $rangeInfo);
		import('classes.submission.reviewAssignment.ReviewAssignment');
		$templateMgr->assign_by_ref('reviewerRecommendationOptions', ReviewAssignment::getReviewerRecommendationOptions());

		/*********************************************************************
		 * Add search fields to template
		 * Added by:  Ayvee Mallare
		 * Last Updated: Sept 25, 2011
         *********************************************************************/
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
			SUBMISSION_FIELD_AUTHOR => 'user.role.author'
		));
		$templateMgr->assign('dateFieldOptions', Array(
			SUBMISSION_FIELD_DATE_SUBMITTED => 'submissions.submitted',
		));
        
        
		import('classes.issue.IssueAction');
		$issueAction = new IssueAction();
		$templateMgr->register_function('print_issue_id', array($issueAction, 'smartyPrintIssueId'));
		$templateMgr->assign('helpTopicId', 'editorial.reviewersRole.submissions');
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->display('reviewer/submissionsIndex.tpl');
	}
	
	
	/****************************************
	 * Display meetings index page
	 * Added by ayveemallare
	 * Last Updated 7/5/2011
	 */
	
	function meetings() {
		$this->validate();
		$this->setupTemplate(true);
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();
		$userId = $user->getId();
		
		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$meetingSubmissionDao = DAORegistry::getDAO('MeetingSubmissionDAO');
		$articleDao = DAORegistry::getDAO('ArticleDAO');
		$ercReviewersDao = DAORegistry::getDAO('ErcReviewersDAO');
		
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'id';
		$sortDirection = Request::getUserVar('sortDirection');
		$rangeInfo = Handler::getRangeInfo('meetings');
		
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		$status = Request::getUserVar('status');
		$replyStatus = Request::getUserVar('replyStatus');
		$meetings = $meetingDao->getMeetingsByReviewerId($userId, $sort, $rangeInfo, $sortDirection, $status, $replyStatus, $fromDate, $toDate);
		
		$map = array();
		$meetingsArray = $meetings->toArray();
		
		foreach($meetingsArray as $meeting) {
			$submissionIds = $meetingSubmissionDao->getMeetingSubmissionsByMeetingId($meeting->getId());
			$submissions = array();
			foreach($submissionIds as $submissionId) {
				$submission = $articleDao->getArticle($submissionId, $journalId, false);
				array_push($submissions, $submission);
			}
			$map[$meeting->getId()] = $submissions;
		}
		$meetings = $meetingDao->getMeetingsByReviewerId($userId, $sort, $rangeInfo, $sortDirection, $status, $replyStatus, $fromDate, $toDate);
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meetings', $meetings); 
		$templateMgr->assign_by_ref('submissions', $submissions); 
		$templateMgr->assign_by_ref('map', $map); 
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('rangeInfo', count($meetings));
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->assign('baseUrl', Config::getVar('general', "base_url"));
		$templateMgr->assign('dateFrom', $fromDate);
		$templateMgr->assign('dateTo', $toDate);
		$templateMgr->assign('status', $status);
		$templateMgr->assign('replyStatus', $replyStatus);
		$templateMgr->assign('isReviewer', !$ercReviewersDao->isExternalReviewer($journalId, $userId));
		
		// Set search parameters
		$duplicateParameters = array(
			'dateFromMonth', 'dateFromDay', 'dateFromYear',
			'dateToMonth', 'dateToDay', 'dateToYear', 'status', 'replyStatus'
		);
		foreach ($duplicateParameters as $param)
			$templateMgr->assign($param, Request::getUserVar($param));
		
		$templateMgr->display('reviewer/meetings.tpl');
	}
	
	function proposalsFromMeetings() {
		$this->validate();
		$this->setupTemplate(true);
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$user =& Request::getUser();

		$ercReviewersDao = DAORegistry::getDAO('ErcReviewersDAO');
		
		$searchField = Request::getUserVar('searchField');
		$searchMatch = Request::getUserVar('searchMatch');
		$search = Request::getUserVar('search');

		$reviewerSubmissionDao =& DAORegistry::getDAO('ReviewerSubmissionDAO');
		$rangeInfo = Handler::getRangeInfo('submissions');
				
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'title';
		$sortDirection = Request::getUserVar('sortDirection');
		
		$submissions =& $reviewerSubmissionDao->getReviewerMeetingSubmissionsByReviewerId($user->getId(), $journalId, $searchField, $searchMatch, $search, $rangeInfo, $sort, $sortDirection);	
						
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('fieldOptions', Array(
			SUBMISSION_FIELD_TITLE => 'article.title',
			SUBMISSION_FIELD_AUTHOR => 'user.role.author'
		));	
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('rangeInfo', count($submissions));
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->assign('rangeInfo', $rangeInfo);
		$templateMgr->assign_by_ref('submissions', $submissions);
		
		$templateMgr->assign('isReviewer', !$ercReviewersDao->isExternalReviewer($journalId, $user->getId()));
		
		$templateMgr->display('reviewer/proposalsFromMeetings.tpl');
	}
	
	/**
	 * Used by subclasses to validate access keys when they are allowed.
	 * @param $userId int The user this key refers to
	 * @param $reviewId int The ID of the review this key refers to
	 * @param $newKey string The new key name, if one was supplied; otherwise, the existing one (if it exists) is used
	 * @return object Valid user object if the key was valid; otherwise NULL.
	 */
	function &validateAccessKey($userId, $reviewId, $newKey = null) {
		$journal =& Request::getJournal();
		if (!$journal || !$journal->getSetting('reviewerAccessKeysEnabled')) {
			$accessKey = false;
			return $accessKey;
		}

		define('REVIEWER_ACCESS_KEY_SESSION_VAR', 'ReviewerAccessKey');

		import('lib.pkp.classes.security.AccessKeyManager');
		$accessKeyManager = new AccessKeyManager();

		$session =& Request::getSession();
		// Check to see if a new access key is being used.
		if (!empty($newKey)) {
			if (Validation::isLoggedIn()) {
				Validation::logout();
			}
			$keyHash = $accessKeyManager->generateKeyHash($newKey);
			$session->setSessionVar(REVIEWER_ACCESS_KEY_SESSION_VAR, $keyHash);
		} else {
			$keyHash = $session->getSessionVar(REVIEWER_ACCESS_KEY_SESSION_VAR);
		}

		// Now that we've gotten the key hash (if one exists), validate it.
		$accessKey =& $accessKeyManager->validateKey(
			'ReviewerContext',
			$userId,
			$keyHash,
			$reviewId
		);

		if ($accessKey) {
			$userDao =& DAORegistry::getDAO('UserDAO');
			$user =& $userDao->getUser($accessKey->getUserId(), false);
			return $user;
		}

		// No valid access key -- return NULL.
		return $accessKey;
	}

	/**
	 * Setup common template variables.
	 * @param $subclass boolean set to true if caller is below this handler in the hierarchy
	 */
	function setupTemplate($meeting = false, $subMeeting = 0, $articleId = 0, $reviewId = 0) {
		parent::setupTemplate();
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_OJS_EDITOR));
		$templateMgr =& TemplateManager::getManager();
		$pageHierarchy = $meeting ? array(array(Request::url(null, 'user'), 'user.role.reviewer'), array(Request::url(null, 'reviewer', 'meetings'), 'reviewer.meeting')) 
			: array(array(Request::url(null, 'user'), 'user.role.reviewer'), array(Request::url(null, 'reviewer'), 'common.queue.short.reviewAssignments'));

		if ($articleId && $reviewId) {
			$articleDao =& DAORegistry::getDAO('ArticleDAO');
			$article =& $articleDao->getArticle($articleId);
			$proposalId = $article->getLocalizedProposalId();
			$pageHierarchy[] = array(Request::url(null, 'reviewer', 'submission', $reviewId), "$proposalId", true);
		}
		
		if ($subMeeting == 1) {
			$pageHierarchy[] = array(Request::url(null, 'reviewer', 'meetings'), 'common.queue.long.meetingList');
		} elseif ($subMeeting == 2) {
			$pageHierarchy[] = array(Request::url(null, 'reviewer', 'proposalsFromMeetings'), 'common.queue.long.meetingProposals');
		}
		
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}
}

?>
