<?php

/**
 * @file classes/submission/reviewAssignment/ReviewAssignment.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class ReviewAssignment
 * @ingroup submission
 * @see ReviewAssignmentDAO
 *
 * @brief Describes review assignment properties.
 */

// $Id$


import('lib.pkp.classes.submission.reviewAssignment.PKPReviewAssignment');

class ReviewAssignment extends PKPReviewAssignment {
	/**
	 * Constructor.
	 */
	function ReviewAssignment() {
		parent::PKPReviewAssignment();
	}

	//
	// Get/set methods
	//

	/**
	 * Get an associative array matching reviewer recommendation codes with locale strings.
	 * (Includes default '' => "Choose One" string.)
	 * @return array recommendation => localeString
	 * Edited by aglet
	 * Last Update: 6/1/2011
	 */
	function &getReviewerRecommendationOptions() {
		// Bring in reviewer constants
		import('classes.submission.reviewer.ReviewerSubmission');

		static $reviewerRecommendationOptions = array(
			'' => 'common.chooseOne',
			SUBMISSION_REVIEWER_RECOMMENDATION_ACCEPT => 'reviewer.article.decision.accept',
			SUBMISSION_REVIEWER_RECOMMENDATION_RESUBMIT => 'reviewer.article.decision.resubmit',
			SUBMISSION_REVIEWER_RECOMMENDATION_DECLINE => 'reviewer.article.decision.decline'
		);
		return $reviewerRecommendationOptions;
	}

	/**
	 * Get an associative array matching reviewer rating codes with locale strings.
	 * @return array recommendation => localeString
	 */
	function &getReviewerRatingOptions() {
		static $reviewerRatingOptions = array(
			SUBMISSION_REVIEWER_RATING_VERY_GOOD => 'editor.article.reviewerRating.veryGood',
			SUBMISSION_REVIEWER_RATING_GOOD => 'editor.article.reviewerRating.good',
			SUBMISSION_REVIEWER_RATING_AVERAGE => 'editor.article.reviewerRating.average',
			SUBMISSION_REVIEWER_RATING_POOR => 'editor.article.reviewerRating.poor',
			SUBMISSION_REVIEWER_RATING_VERY_POOR => 'editor.article.reviewerRating.veryPoor'
		);
		return $reviewerRatingOptions;
	}
}

?>
