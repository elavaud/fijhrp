<?php

/**
 * @defgroup article
 */

/**
 * @file classes/article/Article.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class Article
 * @ingroup article
 * @see ArticleDAO
 *
 * @brief Article class.
 */


// Submission status constants
define('STATUS_ARCHIVED', 0);
define('STATUS_QUEUED', 1);
// define('STATUS_SCHEDULED', 2); // #2187: Scheduling queue removed.
define('STATUS_PUBLISHED', 3);
define('STATUS_DECLINED', 4);

// AuthorSubmission::getSubmissionStatus will return one of these in place of QUEUED:
define ('STATUS_QUEUED_UNASSIGNED', 5);
define ('STATUS_QUEUED_REVIEW', 6);
define ('STATUS_QUEUED_EDITING', 7);
define ('STATUS_INCOMPLETE', 8);

define ('STATUS_WITHDRAWN', 9); //Added by AIM, May 25, 2011

// Author display in ToC
define ('AUTHOR_TOC_DEFAULT', 0);
define ('AUTHOR_TOC_HIDE', 1);
define ('AUTHOR_TOC_SHOW', 2);

// Article RT comments
define ('COMMENTS_SECTION_DEFAULT', 0);
define ('COMMENTS_DISABLE', 1);
define ('COMMENTS_ENABLE', 2);

/**
 * Reasons for exemption constants
 * Added by aglet 6/22/2011
 */
define ('EXEMPTION_NO_HUMAN_PARTICIPANTS', 1);
define ('EXEMPTION_ALREADY_EXISTS', 2);
define ('EXEMPTION_PUBLIC_OFFICIALS', 4);
define ('EXEMPTION_LIMITED_OBSERVATION', 8);
define ('EXEMPTION_LIMITED_SURVEILLANCE', 16);
define ('EXEMPTION_REGISTERED', 32);

import('lib.pkp.classes.submission.Submission');

class Article extends Submission {
	/**
	 * Constructor.
	 */
	function Article() {
		parent::Submission();
	}

	/**
	 * @see Submission::getAssocType()
	 */
	function getAssocType() {
		return ASSOC_TYPE_ARTICLE;
	}

	/**
	 * Add an author.
	 * @param $author Author
	 */
	function addAuthor($author) {
		if ($author->getSubmissionId() == null) {
			$author->setSubmissionId($this->getId());
		}
		parent::addAuthor($author);
	}

	/**
	 * Get "localized" article title (if applicable). DEPRECATED
	 * in favour of getLocalizedTitle.
	 * @return string
	 */
	function getArticleTitle() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedTitle();
	}

	/**
	 * Get "localized" article abstract (if applicable). DEPRECATED
	 * in favour of getLocalizedAbstract.
	 * @return string
	 */
	function getArticleAbstract() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedAbstract();
	}

	//
	// Get/set methods
	//

	/**
	 * Get ID of article.
	 * @return int
	 */
	function getArticleId() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getId();
	}

	/**
	 * Set ID of article.
	 * @param $articleId int
	 */
	function setArticleId($articleId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->setId($articleId);
	}

	/**
	 * Get ID of journal.
	 * @return int
	 */
	function getJournalId() {
		return $this->getData('journalId');
	}

	/**
	 * Set ID of journal.
	 * @param $journalId int
	 */
	function setJournalId($journalId) {
		return $this->setData('journalId', $journalId);
	}

	/**
	 * Get ID of article's section.
	 * @return int
	 */
	function getSectionId() {
		return $this->getData('sectionId');
	}

	/**
	 * Set ID of article's section.
	 * @param $sectionId int
	 */
	function setSectionId($sectionId) {
		return $this->setData('sectionId', $sectionId);
	}

	/**
	 * Get stored DOI of the submission.
	 * @return int
	 */
	function getStoredDOI() {
		return $this->getData('doi');
	}

	/**
	 * Set the stored DOI of the submission.
	 * @param $doi string
	 */
	function setStoredDOI($doi) {
		return $this->setData('doi', $doi);
	}

	/**
	 * Get title of article's section.
	 * @return string
	 */
	function getSectionTitle() {
		return $this->getData('sectionTitle');
	}

	/**
	 * Set title of article's section.
	 * @param $sectionTitle string
	 */
	function setSectionTitle($sectionTitle) {
		return $this->setData('sectionTitle', $sectionTitle);
	}

	/**
	 * Get section abbreviation.
	 * @return string
	 */
	function getSectionAbbrev() {
		return $this->getData('sectionAbbrev');
	}

	/**
	 * Set section abbreviation.
	 * @param $sectionAbbrev string
	 */
	function setSectionAbbrev($sectionAbbrev) {
		return $this->setData('sectionAbbrev', $sectionAbbrev);
	}

	/**
	 * Return the localized discipline. DEPRECATED in favour of
	 * getLocalizedDiscipline.
	 * @return string
	 */
	function getArticleDiscipline() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedDiscipline();
	}

	/**
	 * Return the localized subject classification. DEPRECATED
	 * in favour of getLocalizedSubjectClass.
	 * @return string
	 */
	function getArticleSubjectClass() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedSubjectClass();
	}

	/**
	 * Return the localized subject. DEPRECATED in favour of
	 * getLocalizedSubject.
	 * @return string
	 */
	function getArticleSubject() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedSubject();
	}

	/**
	 * Return the localized geographical coverage. DEPRECATED
	 * in favour of getLocalizedCoverageGeo.
	 * @return string
	 */
	function getArticleCoverageGeo() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedCoverageGeo();
	}

	/**
	 * Return the localized chronological coverage. DEPRECATED
	 * in favour of getLocalizedCoverageChron.
	 * @return string
	 */
	function getArticleCoverageChron() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedCoverageChron();
	}

	/**
	 * Return the localized sample coverage. DEPRECATED in favour
	 * of getLocalizedCoverageSample.
	 * @return string
	 */
	function getArticleCoverageSample() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedCoverageSample();
	}

	/**
	 * Return the localized type (method/approach). DEPRECATED
	 * in favour of getLocalizedType.
	 * @return string
	 */
	function getArticleType() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedType();
	}

	/**
	 * Return the localized sponsor. DEPRECATED in favour
	 * of getLocalizedSponsor.
	 * @return string
	 */
	function getArticleSponsor() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedSponsor();
	}

	/**
	 * Get the localized article cover filename. DEPRECATED
	 * in favour of getLocalizedFileName.
	 * @return string
	 */
	function getArticleFileName() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedFileName('fileName');
	}

	/**
	 * Get the localized article cover width. DEPRECATED
	 * in favour of getLocalizedWidth.
	 * @return string
	 */
	function getArticleWidth() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedWidth();
	}

	/**
	 * Get the localized article cover height. DEPRECATED
	 * in favour of getLocalizedHeight.
	 * @return string
	 */
	function getArticleHeight() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedHeight();
	}

	/**
	 * Get the localized article cover filename on the uploader's computer.
	 * DEPRECATED in favour of getLocalizedOriginalFileName.
	 * @return string
	 */
	function getArticleOriginalFileName() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedData('originalFileName');
	}

	/**
	 * Get the localized article cover alternate text. DEPRECATED
	 * in favour of getLocalizedCoverPageAltText.
	 * @return string
	 */
	function getArticleCoverPageAltText() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedCoverPageAltText();
	}

	/**
	 * Get the flag indicating whether or not to show
	 * an article cover page. DEPRECATED in favour of
	 * getLocalizedShowCoverPage.
	 * @return string
	 */
	function getArticleShowCoverPage() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedShowCoverPage();
	}

	/**
	 * Get comments to editor.
	 * @return string
	 */
	function getCommentsToEditor() {
		return $this->getData('commentsToEditor');
	}

	/**
	 * Set comments to editor.
	 * @param $commentsToEditor string
	 */
	function setCommentsToEditor($commentsToEditor) {
		return $this->setData('commentsToEditor', $commentsToEditor);
	}

	/**
	 * Get current review round.
	 * @return int
	 */
	function getCurrentRound() {
		return $this->getData('currentRound');
	}

	/**
	 * Set current review round.
	 * @param $currentRound int
	 */
	function setCurrentRound($currentRound) {
		return $this->setData('currentRound', $currentRound);
	}

	/**
	 * Get editor file id.
	 * @return int
	 */
	function getEditorFileId() {
		return $this->getData('editorFileId');
	}

	/**
	 * Set editor file id.
	 * @param $editorFileId int
	 */
	function setEditorFileId($editorFileId) {
		return $this->setData('editorFileId', $editorFileId);
	}

	/**
	 * get expedited
	 * @return boolean
	 */
	function getFastTracked() {
		return $this->getData('fastTracked');
	}

	/**
	 * set fastTracked
	 * @param $fastTracked boolean
	 */
	function setFastTracked($fastTracked) {
		return $this->setData('fastTracked',$fastTracked);
	}

	/**
	 * Return boolean indicating if author should be hidden in issue ToC.
	 * @return boolean
	 */
	function getHideAuthor() {
		return $this->getData('hideAuthor');
	}

	/**
	 * Set if author should be hidden in issue ToC.
	 * @param $hideAuthor boolean
	 */
	function setHideAuthor($hideAuthor) {
		return $this->setData('hideAuthor', $hideAuthor);
	}

	/**
	 * Return locale string corresponding to RT comments status.
	 * @return string
	 */
	function getCommentsStatusString() {
		switch ($this->getCommentsStatus()) {
			case COMMENTS_DISABLE:
				return 'article.comments.disable';
			case COMMENTS_ENABLE:
				return 'article.comments.enable';
			default:
				return 'article.comments.sectionDefault';
		}
	}

	/**
	 * Return boolean indicating if article RT comments should be enabled.
	 * Checks both the section and article comments status. Article status
	 * overrides section status.
	 * @return int
	 */
	function getEnableComments() {
		switch ($this->getCommentsStatus()) {
			case COMMENTS_DISABLE:
				return false;
			case COMMENTS_ENABLE:
				return true;
			case COMMENTS_SECTION_DEFAULT:
				$sectionDao =& DAORegistry::getDAO('SectionDAO');
				$section =& $sectionDao->getSection($this->getSectionId(), $this->getJournalId(), true);
				if ($section->getDisableComments()) {
					return false;
				} else {
					return true;
				}
		}
	}

	/**
	 * Get an associative array matching RT comments status codes with locale strings.
	 * @return array comments status => localeString
	 */
	function &getCommentsStatusOptions() {
		static $commentsStatusOptions = array(
			COMMENTS_SECTION_DEFAULT => 'article.comments.sectionDefault',
			COMMENTS_DISABLE => 'article.comments.disable',
			COMMENTS_ENABLE => 'article.comments.enable'
		);
		return $commentsStatusOptions;
	}

	/**
	 * Get an array of user IDs associated with this article
	 * @param $authors boolean
	 * @param $reviewers boolean
	 * @param $editors boolean
	 * @param $proofreader boolean
	 * @param $copyeditor boolean
	 * @param $layoutEditor boolean
	 * @return array User IDs
	 */
	function getAssociatedUserIds($authors = true, $reviewers = true, $editors = true, $sectionEditors = true, $proofreader = true, $copyeditor = true, $layoutEditor = true) {
		$articleId = $this->getId();
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$userIds = array();

		if($authors) {
			$userId = $this->getUserId();
			if ($userId) $userIds[] = array('id' => $userId, 'role' => 'author');
		}

		if($editors) {
			$editAssignmentDao =& DAORegistry::getDAO('EditAssignmentDAO');
			$editAssignments =& $editAssignmentDao->getEditorAssignmentsByArticleId($articleId);
			while ($editAssignment =& $editAssignments->next()) {
				$userId = $editAssignment->getEditorId();
				if ($userId) $userIds[] = array('id' => $userId, 'role' => 'editor');
				unset($editAssignment);
			}
		}
		
		if($sectionEditors) {
			$editAssignmentDao =& DAORegistry::getDAO('EditAssignmentDAO');
			$editAssignments =& $editAssignmentDao->getSectionEditorAssignmentsByArticleId($articleId);
			while ($editAssignment =& $editAssignments->next()) {
				$userId = $editAssignment->getEditorId();
				if ($userId) $userIds[] = array('id' => $userId, 'role' => 'sectionEditor');
				unset($editAssignment);
			}
		}
		
		if($copyeditor) {
			$copyedSignoff = $signoffDao->getBySymbolic('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $articleId);
			$userId = $copyedSignoff->getUserId();
			if ($userId) $userIds[] = array('id' => $userId, 'role' => 'copyeditor');
		}

		if($layoutEditor) {
			$layoutSignoff = $signoffDao->getBySymbolic('SIGNOFF_LAYOUT', ASSOC_TYPE_ARTICLE, $articleId);
			$userId = $layoutSignoff->getUserId();
			if ($userId) $userIds[] = array('id' => $userId, 'role' => 'layoutEditor');
		}

		if($proofreader) {
			$proofSignoff = $signoffDao->getBySymbolic('SIGNOFF_PROOFREADING_PROOFREADER', ASSOC_TYPE_ARTICLE, $articleId);
			$userId = $proofSignoff->getUserId();
			if ($userId) $userIds[] = array('id' => $userId, 'role' => 'proofreader');
		}

		if($reviewers) {
			$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
			$reviewAssignments =& $reviewAssignmentDao->getBySubmissionId($articleId);
			foreach ($reviewAssignments as $reviewAssignment) {
				$userId = $reviewAssignment->getReviewerId();
				if ($userId) $userIds[] = array('id' => $userId, 'role' => 'reviewer');
				unset($reviewAssignment);
			}
		}

		return $userIds;
	}

	/**
	 * Get the signoff for this article
	 * @param $signoffType string
	 * @return Signoff
	 */
	function getSignoff($signoffType) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		return $signoffDao->getBySymbolic($signoffType, ASSOC_TYPE_ARTICLE, $this->getId());
	}

	/**
	 * Get the file for this article at a given signoff stage
	 * @param $signoffType string
	 * @param $idOnly boolean Return only file ID
	 * @return ArticleFile
	 */
	function &getFileBySignoffType($signoffType, $idOnly = false) {
		$articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$signoff = $signoffDao->getBySymbolic($signoffType, ASSOC_TYPE_ARTICLE, $this->getId());
		if (!$signoff) {
			$returner = false;
			return $returner;
		}

		if ($idOnly) {
			$returner = $signoff->getFileId();
			return $returner;
		}

		$articleFile =& $articleFileDao->getArticleFile($signoff->getFileId(), $signoff->getFileRevision());
		return $articleFile;
	}

	/**
	 * Get the user associated with a given signoff and this article
	 * @param $signoffType string
	 * @return User
	 */
	function &getUserBySignoffType($signoffType) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');

		$signoff = $signoffDao->getBySymbolic($signoffType, ASSOC_TYPE_ARTICLE, $this->getId());
		if (!$signoff) {
			$returner = false;
			return $returner;
		}

		$user =& $userDao->getUser($signoff->getUserId());
		return $user;
	}

	/**
	 * Get the user id associated with a given signoff and this article
	 * @param $signoffType string
	 * @return int
	 */
	function getUserIdBySignoffType($signoffType) {
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$signoff = $signoffDao->getBySymbolic($signoffType, ASSOC_TYPE_ARTICLE, $this->getId());
		if (!$signoff) return false;

		return $signoff->getUserId();
	}
	
	/**
	 * Get the most recent decision.
	 * @return int 
	 * Transferred from AuthorSubmission.inc.php
	 * Edited by aglet
	 * Last Update: 6/19/2011
	 */
	function getMostRecentDecision() {
            /**
             *  Edited by: AIM
             *  Last Updated: May 31, 2011
             **/
            $articleId = $this->getArticleId();

            $articleDao = DAORegistry::getDAO('ArticleDAO');
            $decision = $articleDao->getLastEditorDecision($articleId);
            
            return $decision['decision'];
	}
	
	/**
	 * Get the number of resubmission
	 * @return int
	 * Edited by el
	 * Last update: 5/11/2012
	*/
	function getResubmitCount(){
		$articleId = $this->getArticleId();
		$articleDao = DAORegistry::getDAO('ArticleDAO');
		$result = $articleDao->getLastEditorDecision($articleId);
		return $result['resubmitCount'];	
	}


	/*
	 * Get a map for editor decision to locale key.
	 * @return array
	 * Added by aglet 6/20/2011
	 */	 
	function &getEditorDecisionMap() {
		static $editorDecisionMap;
		if (!isset($editorDecisionMap)) {
			$editorDecisionMap = array(
				SUBMISSION_EDITOR_DECISION_ACCEPT => 'editor.article.decision.accept',
				SUBMISSION_EDITOR_DECISION_RESUBMIT => 'editor.article.decision.resubmit',
				SUBMISSION_EDITOR_DECISION_DECLINE => 'editor.article.decision.decline',
				SUBMISSION_EDITOR_DECISION_COMPLETE => 'editor.article.decision.complete',
				SUBMISSION_EDITOR_DECISION_INCOMPLETE => 'editor.article.decision.incomplete',
				SUBMISSION_EDITOR_DECISION_EXEMPTED => 'editor.article.decision.exempted',
				SUBMISSION_EDITOR_DECISION_ASSIGNED => 'editor.article.decision.assigned',
				SUBMISSION_EDITOR_DECISION_EXPEDITED => 'editor.article.decision.expedited',
				SUBMISSION_EDITOR_DECISION_DONE => 'editor.article.decision.researchCompleted'	
			);
		}
		return $editorDecisionMap;
	}
	
	/**
	 * Get a locale key for the paper's most recent decision
	 * @return string
	 */
	function getEditorDecisionKey() {
		$editorDecisionMap =& $this->getEditorDecisionMap();
		return $editorDecisionMap[$this->getMostRecentDecision()];
	}
	
	/**
	 * Get array mapping of selected reasons for exemption
	 * @return array
	 */
	function getProposalReasonsForExemption() {
		$reasonsLocale = $this->getLocalizedReasonsForExemption();
		$reasons = array();
		for($i=5; $i>=0; $i--) {
			$num = pow(2, $i);
			if($num <= $reasonsLocale) {
				$reasons[$num] = 1;
				$reasonsLocale = $reasonsLocale - $num;
			}
			else
				$reasons[$num] = 0;			
		}
		return $reasons;
	}
	
	/*
	 * Get a map for exemption reasons to locale key
	 * @return array
	 * Added by aglet 6/20/2011
	 */	 
	function &getReasonsForExemptionMap() {
		static $reasonsForExemptionMap;
		if (!isset($reasonsForExemptionMap)) {
			$reasonsForExemptionMap = array(
				EXEMPTION_NO_HUMAN_PARTICIPANTS => 'editor.article.exemption.noHumanParticipants',
				EXEMPTION_ALREADY_EXISTS => 'editor.article.exemption.alreadyExists',
				EXEMPTION_PUBLIC_OFFICIALS => 'editor.article.exemption.publicOfficials',
				EXEMPTION_LIMITED_OBSERVATION => 'editor.article.exemption.limitedObservation',
				EXEMPTION_LIMITED_SURVEILLANCE => 'editor.article.exemption.limitedPublicHealthSurveillance',
				EXEMPTION_REGISTERED => 'editor.article.exemption.registered'			
			);
		}
		return $reasonsForExemptionMap;
	}

	function isDueForReview() {
		$today = time();
        $startdate = strtotime($this->getStartDate($this->getLocale()));
        $dueDate = strtotime ('+1 year', $startdate) ;
    	$approvalDate = strtotime($this->getApprovalDate($this->getLocale()));    	
        $approvalDue = strtotime ('+1 year', $approvalDate) ;
        $due = (($today - $dueDate)>0 && ($today - $approvalDue) > 0) ? 1 : 0;
        //echo "$today, $dueDate, $approvalDue, $due";
        return $due;
    }    
}
?>
