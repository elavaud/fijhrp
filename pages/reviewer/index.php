<?php

/**
 * @defgroup pages_reviewer
 */
 
/**
 * @file pages/reviewer/index.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup pages_reviewer
 * @brief Handle requests for reviewer functions. 
 *
 */

// $Id$


switch ($op) {
	//
	// Submission Tracking
	//
	case 'submission':
	case 'submissionForFullReview':
	case 'confirmReview':
	case 'saveCompetingInterests':
	case 'recordRecommendation':
	case 'viewMetadata':
	case 'uploadReviewerVersion':
	case 'deleteReviewerVersion':
		
	//	Meeting Scheduler
	//	
	//
	
	case 'reviewMeetingSchedule':
	
	//
	// Misc.
	//
	
	case 'downloadFile':
	case 'downloadFileFullReview':
	//
	// Submission Review Form
	//
	case 'editReviewFormResponse':
	case 'saveReviewFormResponse':
		define('HANDLER_CLASS', 'SubmissionReviewHandler');
		import('pages.reviewer.SubmissionReviewHandler');
		break;
	//
	// Submission Comments
	//
	case 'viewPeerReviewComments':
	case 'postPeerReviewComment':
	case 'editComment':
	case 'saveComment':
	case 'deleteComment':
		define('HANDLER_CLASS', 'SubmissionCommentsHandler');
		import('pages.reviewer.SubmissionCommentsHandler');
		break;
	case 'viewMeeting':
	case 'replyMeeting':
		define('HANDLER_CLASS', 'MeetingReviewerHandler');
		import('pages.reviewer.MeetingReviewerHandler');
		break;
	case 'index':
	case 'submissions':
	case 'meetings':
		define('HANDLER_CLASS', 'ReviewerHandler');
		import('pages.reviewer.ReviewerHandler');
		break;
}

?>
