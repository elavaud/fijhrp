<?php

/**
 * @defgroup pages_author
 */
 
/**
 * @file pages/author/index.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup pages_author
 * @brief Handle requests for journal author functions. 
 *
 */

// $Id$

switch ($op) {
	//
	// Article Submission
	//

	case 'submit':
	case 'saveSubmit':
	case 'submitSuppFile':
	case 'saveSubmitSuppFile':
	case 'deleteSubmitSuppFile':
		case 'renameSubmittedFiles': //Added by MSB, Sept 29, 2011
	case 'expediteSubmission':
	    case 'resubmit':   //Added by AIM, May 18, 2011
		define('HANDLER_CLASS', 'SubmitHandler');
		import('pages.author.SubmitHandler');
		break;
	//
	// Submission Tracking
	//
	case 'deleteArticleFile':
	case 'deleteSubmission':
        case 'withdrawSubmission':   //Added by AIM, May 25, 2011
        case 'sendToArchive':       //Added by AIM, June 15, 2011
        case 'setAsCompleted':       //Added by AIM, June 21, 2011
        case 'setAsWithdrawn':      //Added by AIM, June 21, 2011
	case 'submission':
	case 'editSuppFile':
	case 'setSuppFileVisibility':
	case 'saveSuppFile':
        case 'saveWithdrawal':    //Added by AIM, July 3, 2011
	case 'addSuppFile':
	case 'deleteSuppFile':      //Added by AIM, Jan 31, 2012
        case 'addProgressReport':   //Added by AIM, June 15, 2011
        case 'addCompletionReport': //Added by AIM, June 21, 2011
        case 'addExtensionRequest': //Added by AIM, Jul 18, 2011
        case 'addRawDataFile': //Added by EL, April 18, 2012
        case 'addOtherSuppResearchOutput': //Added by EL, April 18, 2012
	case 'submissionReview':
	case 'submissionEditing':
	case 'uploadRevisedVersion':
	case 'viewMetadata':
	case 'saveMetadata':
	case 'removeArticleCoverPage':
	case 'uploadCopyeditVersion':
	case 'completeAuthorCopyedit':
	//
	// Misc.
	//
	case 'replyMeeting':
	case 'downloadFile':
	case 'viewFile':
	case 'download':
	//
	// Proofreading Actions
	//
	case 'authorProofreadingComplete':
	case 'proofGalley':
	case 'proofGalleyTop':
	case 'proofGalleyFile':
	// 
	// Payment Actions
	//
	case 'paySubmissionFee':
	case 'payFastTrackFee':
	case 'payPublicationFee':	
		define('HANDLER_CLASS', 'TrackSubmissionHandler');
		import('pages.author.TrackSubmissionHandler');
		break;
	//
	// Submission Comments
	//
	case 'viewEditorDecisionComments':
	case 'viewCopyeditComments':
	case 'postCopyeditComment':
	case 'emailEditorDecisionComment':
	case 'postEditorDecisionComment':
	case 'viewProofreadComments':
	case 'viewLayoutComments':
	case 'postLayoutComment':
	case 'postProofreadComment':
	case 'editComment':
	case 'saveComment':
	case 'deleteComment':
		define('HANDLER_CLASS', 'SubmissionCommentsHandler');
		import('pages.author.SubmissionCommentsHandler');
		break;
	case 'index':
	case 'instructions':
		define('HANDLER_CLASS', 'AuthorHandler');
		import('pages.author.AuthorHandler');
		break;
}

?>
