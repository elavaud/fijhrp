<?php

/**
 * @defgroup pages_editor
 */

/**
 * @file pages/editor/index.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup pages_editor
 * @brief Handle requests for editor functions.
 *
 */

// $Id$

switch ($op) {
	//
	// Submission Tracking
	//
	case 'enrollSearch':
	case 'createReviewer':
	case 'createExternalReviewer':
	case 'suggestUsername':
	case 'enroll':
	case 'submission':
	case 'submissionRegrets':
	case 'submissionReview':
	case 'submissionEditing':
	case 'submissionHistory':
	case 'submissionCitations':
	case 'changeSection':
	case 'recordDecision':
	//if proposal is exempted, record reasons for exemption
	case 'recordReasonsForExemption':
	//if proposal was tabled for expedited review, allow STO to upload approval/disapproval file
	case 'uploadDecisionFile':
	case 'selectReviewer':
	case 'selectReviewers':
	case 'notifyReviewer':
	case 'notifyReviewers':
	case 'userProfile':
	case 'clearReview':
	case 'cancelReview':
	case 'remindReviewer':
	case 'thankReviewer':
	case 'rateReviewer':
	case 'confirmReviewForReviewer':
	case 'uploadReviewForReviewer':
	case 'enterReviewerRecommendation':
	case 'makeReviewerFileViewable':
	case 'setDueDate':
	case 'setDueDateForAll':
	case 'viewMetadata':
	case 'saveMetadata':
	case 'removeArticleCoverPage':
	case 'editorReview':
	case 'selectCopyeditor':
	case 'notifyCopyeditor':
	case 'initiateCopyedit':
	case 'thankCopyeditor':
	case 'notifyAuthorCopyedit':
	case 'thankAuthorCopyedit':
	case 'notifyFinalCopyedit':
	case 'thankFinalCopyedit':
	case 'selectCopyeditRevisions':
	case 'uploadReviewVersion':
	case 'uploadCopyeditVersion':
	case 'completeCopyedit':
	case 'completeFinalCopyedit':
	case 'addSuppFile':
	case 'setSuppFileVisibility':
	case 'editSuppFile':
	case 'saveSuppFile':
	case 'deleteSuppFile':
	case 'deleteArticleFile':
	case 'archiveSubmission':
	case 'unsuitableSubmission':
	case 'restoreToQueue':
	case 'updateSection':
	case 'updateCommentsStatus':
	//
	// Layout Editing
	//
	case 'deleteArticleImage':
	case 'uploadLayoutFile':
	case 'uploadLayoutVersion':
	case 'assignLayoutEditor':
	case 'notifyLayoutEditor':
	case 'thankLayoutEditor':
	case 'uploadGalley':
	case 'editGalley':
	case 'saveGalley':
	case 'orderGalley':
	case 'deleteGalley':
	case 'proofGalley':
	case 'proofGalleyTop':
	case 'proofGalleyFile':
	case 'uploadSuppFile':
	case 'orderSuppFile':
	//
	// Submission History
	//
	case 'submissionEventLog':
	case 'submissionEventLogType':
	case 'clearSubmissionEventLog':
	case 'submissionEmailLog':
	case 'submissionEmailLogType':
	case 'clearSubmissionEmailLog':
	case 'addSubmissionNote':
	case 'removeSubmissionNote':
	case 'updateSubmissionNote':
	case 'clearAllSubmissionNotes':
	case 'submissionNotes':
	//
	// Misc.
	//
	case 'downloadFile':
	case 'viewFile':
	// Submission Review Form
	case 'clearReviewForm':
	case 'selectReviewForm':
	case 'previewReviewForm':
	case 'viewReviewFormResponse':
	// Proof Assignment Functions
	case 'selectProofreader':
	case 'notifyAuthorProofreader':
	case 'thankAuthorProofreader':
	case 'editorInitiateProofreader':
	case 'editorCompleteProofreader':
	case 'notifyProofreader':
	case 'thankProofreader':
	case 'editorInitiateLayoutEditor':
	case 'editorCompleteLayoutEditor':
	case 'notifyLayoutEditorProofreader':
	case 'thankLayoutEditorProofreader':
	//
	// Scheduling functions
	//
	case 'scheduleForPublication':
	 //
	 // Payments
	 //
	 case 'waiveSubmissionFee':
	 case 'waiveFastTrackFee':
	 case 'waivePublicationFee':
		define('HANDLER_CLASS', 'SubmissionEditHandler');
		import('pages.sectionEditor.SubmissionEditHandler');
		break;
	//
	// Submission Comments
	//
	case 'viewPeerReviewComments':
	case 'postPeerReviewComment':
	case 'viewEditorDecisionComments':
	case 'blindCcReviewsToReviewers':
	case 'postEditorDecisionComment':
	case 'viewCopyeditComments':
	case 'postCopyeditComment':
	case 'emailEditorDecisionComment':
	case 'viewLayoutComments':
	case 'postLayoutComment':
	case 'viewProofreadComments':
	case 'postProofreadComment':
	case 'editComment':
	case 'saveComment':
	case 'deleteComment':
		define('HANDLER_CLASS', 'SubmissionCommentsHandler');
		import('pages.sectionEditor.SubmissionCommentsHandler');
		break;
	//
	// Issue
	//
	case 'futureIssues':
	case 'backIssues':
	case 'removeIssue':
	case 'createIssue':
	case 'saveIssue':
	case 'issueData':
	case 'editIssue':
	case 'removeCoverPage':
	case 'removeStyleFile':
	case 'issueToc':
	case 'updateIssueToc':
	case 'setCurrentIssue':
	case 'moveIssue':
	case 'resetIssueOrder':
	case 'moveSectionToc':
	case 'resetSectionOrder':
	case 'moveArticleToc':
	case 'publishIssue':
	case 'unpublishIssue':
	case 'notifyUsers':
		define('HANDLER_CLASS', 'IssueManagementHandler');
		import('pages.editor.IssueManagementHandler');
		break;
	case 'index':
	case 'submissions':
	case 'setEditorFlags':
	case 'assignEditor':
	case 'deleteSubmission':
	case 'instructions':
		define('HANDLER_CLASS', 'EditorHandler');
		import('pages.editor.EditorHandler');
		break;
	case 'minutes':
	case 'createMinutes':
	case 'manageMinutesmanageMinutes':
	case 'viewMinutes':
	case 'downloadMinutes':
	case 'generateAttendance':	
	case 'downloadAttendance':
	case 'selectInitialReview':
	case 'generateInitialReviewFile':
	case 'generateInitialReviewDecision':
	case 'completeInitialReviews':
	case 'downloadInitialReviews':
	case 'selectContinuingReview':
	case 'generateContinuingReviewFile':
	case 'generateContinuingReviewDecision':
	case 'completeContinuingReviews':
	case 'setMinutesFinal':
	case 'deleteUploadedFile':
	case 'uploadFile':
		define('HANDLER_CLASS', 'MinutesHandler');
		import('pages.sectionEditor.MinutesHandler');
		break;
	case 'meetings':
	case 'notifyReviewers':
	case 'setMeeting':
	case 'saveMeeting':
	case 'viewMeeting':
	case 'cancelMeeting':
	case 'setMeetingFinal':
	case 'notifyUsersNewMeeting':
	case 'notifyReviewersChangeMeeting':
	case 'notifyReviewersFinalMeeting':
	case 'notifyReviewersCancelMeeting':
	case 'remindUsersMeeting':
		define('HANDLER_CLASS', 'MeetingsHandler');
		import('pages.sectionEditor.MeetingsHandler');
		break;	

	/*Added by MSB, Oct11, 2011
	* Report generation
	* */
	case 'submissionsReport':
	/*Added by IJM, Oct11, 2011*/	
	case 'meetingAttendanceReport':
	case 'previewMeetingAttendanceReport':
			define('HANDLER_CLASS', 'ReportsHandler');
			import('pages.sectionEditor.ReportsHandler');
			break;
	/*  Added by AIM, 07.25.2012
         *  Send emails to a set of users
         */
	case 'sendEmailAllUsers':
        case 'sendEmailERCMembers':
        case 'sendEmailRTOs':
        		define('HANDLER_CLASS', 'SendEmailHandler');
			import('pages.sectionEditor.SendEmailHandler');
			break;
}

?>
