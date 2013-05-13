<?php

/**
 * @file classes/submission/author/AuthorSubmissionDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorSubmissionDAO
 * @ingroup submission
 * @see AuthorSubmission
 *
 * @brief Operations for retrieving and modifying AuthorSubmission objects.
 */

// $Id$
import('classes.submission.author.AuthorSubmission');

class AuthorSubmissionDAO extends DAO {
	var $articleDao;
	var $authorDao;
	var $userDao;
	var $articleFileDao;
	var $suppFileDao;
	var $copyeditorSubmissionDao;
	var $articleCommentDao;
	var $galleyDao;
	var $sectionDecisionDao;
	
	/**
	 * Constructor.
	 */
	function AuthorSubmissionDAO() {
		parent::DAO();
		$this->articleDao =& DAORegistry::getDAO('ArticleDAO');
		$this->authorDao =& DAORegistry::getDAO('AuthorDAO');
		$this->userDao =& DAORegistry::getDAO('UserDAO');
		$this->articleFileDao =& DAORegistry::getDAO('ArticleFileDAO');
		$this->suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$this->copyeditorSubmissionDao =& DAORegistry::getDAO('CopyeditorSubmissionDAO');
		$this->articleCommentDao =& DAORegistry::getDAO('ArticleCommentDAO');
		$this->galleyDao =& DAORegistry::getDAO('ArticleGalleyDAO');
		$this->sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
	}

	/**
	 * Retrieve a author submission by article ID.
	 * @param $articleId int
	 * @return AuthorSubmission
	 */
	function &getAuthorSubmission($articleId) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$result =& $this->retrieve(
			'SELECT	a.*,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM articles a
				LEFT JOIN sections s ON (s.section_id = a.section_id)
				LEFT JOIN section_settings stpl ON (s.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (s.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				LEFT JOIN section_settings sapl ON (s.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (s.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
			WHERE	a.article_id = ?',
			array(
				'title',
				$primaryLocale,
				'title',
				$locale,
				'abbrev',
				$primaryLocale,
				'abbrev',
				$locale,
				$articleId,
			)
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnAuthorSubmissionFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Internal function to return a AuthorSubmission object from a row.
	 * @param $row array
	 * @return AuthorSubmission
	 */
	function &_returnAuthorSubmissionFromRow(&$row) {
		$authorSubmission = new AuthorSubmission();

		// Article attributes
		$this->articleDao->_articleFromRow($authorSubmission, $row);
		
		// Editor Decisions
		$authorSubmission->setDecisions($this->sectionDecisionDao->getSectionDecisionsByArticleId($row['article_id']));
		
		// Comments
		$authorSubmission->setMostRecentEditorDecisionComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_SECTION_DECISION, $row['article_id']));
		$authorSubmission->setMostRecentCopyeditComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_COPYEDIT, $row['article_id']));
		$authorSubmission->setMostRecentProofreadComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_PROOFREAD, $row['article_id']));
		$authorSubmission->setMostRecentLayoutComment($this->articleCommentDao->getMostRecentArticleComment($row['article_id'], COMMENT_TYPE_LAYOUT, $row['article_id']));

		// Files
		$authorSubmission->setSubmissionFile($this->articleFileDao->getArticleFile($row['submission_file_id']));
		$authorSubmission->setRevisedFile($this->articleFileDao->getArticleFile($row['revised_file_id']));
		$authorSubmission->setSuppFiles($this->suppFileDao->getSuppFilesByArticle($row['article_id']));
		
		$authorSubmission->setGalleys($this->galleyDao->getGalleysByArticle($row['article_id']));

		HookRegistry::call('AuthorSubmissionDAO::_returnAuthorSubmissionFromRow', array(&$authorSubmission, &$row));

		return $authorSubmission;
	}

	/**
	 * Update an existing author submission.
	 * @param $authorSubmission AuthorSubmission
	 */
	function updateAuthorSubmission(&$authorSubmission) {
		// Update article
		if ($authorSubmission->getArticleId()) {
			$article =& $this->articleDao->getArticle($authorSubmission->getArticleId());

			// Only update fields that an author can actually edit.
			$article->setRevisedFileId($authorSubmission->getRevisedFileId());
			$article->setDateStatusModified($authorSubmission->getDateStatusModified());
			$article->setLastModified($authorSubmission->getLastModified());
			// FIXME: These two are necessary for designating the
			// original as the review version, but they are probably
			// best not exposed like this.
			$article->setReviewFileId($authorSubmission->getReviewFileId());
			$article->setEditorFileId($authorSubmission->getEditorFileId());

			$this->articleDao->updateArticle($article);
		}

	}

	/**
	 * Get all author submissions for an author.
	 * @param $authorId int
	 * @return DAOResultFactory continaing AuthorSubmissions
	 */
	function &getAuthorSubmissions($authorId, $journalId, $active = true,  $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$params = array(
				$locale,
				$locale,
				'proposalCountry',
				'proposalCountry',
				$locale,
				'title',
				$primaryLocale,
				'title',
				$locale,
				'abbrev',
				$primaryLocale,
				'abbrev',
				$locale,
				$authorId,
				$journalId
		);

		$searchSql = '';

		if (!empty($search)) switch ($searchField) {
			case SUBMISSION_FIELD_TITLE:
				if ($searchMatch === 'is') {
					$searchSql = ' AND LOWER(COALESCE(abl.scientific_title, abpl.scientific_title)) = LOWER(?)';
				} elseif ($searchMatch === 'contains') {
					$searchSql = ' AND LOWER(COALESCE(abl.scientific_title, abpl.scientific_title)) LIKE LOWER(?)';
					$search = '%' . $search . '%';
				} else { // $searchMatch === 'startsWith'
					$searchSql = ' AND LOWER(COALESCE(abl.scientific_title, abpl.scientific_title)) LIKE LOWER(?)';
					$search = $search . '%';
				}
				$params[] = $search;
				break;
			case SUBMISSION_FIELD_AUTHOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'aa.', $params);
				break;
			case SUBMISSION_FIELD_EDITOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'ed.', $params);
				break;
			case SUBMISSION_FIELD_REVIEWER:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 're.', $params);
				break;
			case SUBMISSION_FIELD_COPYEDITOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'ce.', $params);
				break;
			case SUBMISSION_FIELD_LAYOUTEDITOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'le.', $params);
				break;
			case SUBMISSION_FIELD_PROOFREADER:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'pe.', $params);
				break;
		}
		if (!empty($dateFrom) || !empty($dateTo)) switch($dateField) {
			case SUBMISSION_FIELD_DATE_SUBMITTED:
				if (!empty($dateFrom)) {
					$searchSql .= ' AND a.date_submitted >= ' . $this->datetimeToDB($dateFrom);
				}
				if (!empty($dateTo)) {
					$searchSql .= ' AND a.date_submitted <= ' . $this->datetimeToDB($dateTo);
				}
				break;
		}

       	$countrySql = '';
		if (!empty($countryField)) {
			$countrySql = " AND LOWER(COALESCE(apc.setting_value, appc.setting_value)) like '%" . $countryField . "%'";
		}

		$sql = 'SELECT DISTINCT	a.*,
				COALESCE(abl.clean_scientific_title, abpl.clean_scientific_title) AS submission_title,
				aa.last_name AS author_name,
				(SELECT SUM(g.views) FROM article_galleys g WHERE (g.article_id = a.article_id AND g.locale = ?)) AS galley_views,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN authors aa ON (aa.submission_id = a.article_id AND aa.primary_contact = 1)
				LEFT JOIN article_abstract abpl ON (abpl.article_id = a.article_id AND abpl.locale = a.locale)
				LEFT JOIN article_abstract abl ON (abl.article_id = a.article_id AND abl.locale = ?)
				LEFT JOIN article_settings appc ON (a.article_id = appc.article_id AND appc.setting_name = ? AND appc.locale = a.locale)
				LEFT JOIN article_settings apc ON (a.article_id = apc.article_id AND apc.setting_name = ? AND apc.locale = ?)	
				LEFT JOIN sections s ON (s.section_id = a.section_id)
				LEFT JOIN section_settings stpl ON (s.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (s.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				LEFT JOIN section_settings sapl ON (s.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (s.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
			WHERE	a.user_id = ? AND a.journal_id = ? AND ' .
			//($active?('a.status = ' . STATUS_QUEUED):('(a.status <> ' . STATUS_QUEUED . ' AND a.submission_progress = 0)'));
                        //Edited by AIM, Sep 28, 2011
                        ($active?('a.status NOT IN (' . PROPOSAL_STATUS_ARCHIVED . ', ' . PROPOSAL_STATUS_WITHDRAWN . ', ' . PROPOSAL_STATUS_COMPLETED . ')'):('(a.status IN (' . PROPOSAL_STATUS_ARCHIVED . ', ' . PROPOSAL_STATUS_WITHDRAWN . ', ' . PROPOSAL_STATUS_COMPLETED . ') AND a.submission_progress = 0)'));

			$result =& $this->retrieveRange(
				$sql . ' ' . $searchSql . $countrySql . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
				count($params)===1?array_shift($params):$params,
				$rangeInfo
			);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * FIXME Move this into somewhere common (SubmissionDAO?) as this is used in several classes.
	 */
	function _generateUserNameSearchSQL($search, $searchMatch, $prefix, &$params) {
		$first_last = $this->_dataSource->Concat($prefix.'first_name', '\' \'', $prefix.'last_name');
		$first_middle_last = $this->_dataSource->Concat($prefix.'first_name', '\' \'', $prefix.'middle_name', '\' \'', $prefix.'last_name');
		$last_comma_first = $this->_dataSource->Concat($prefix.'last_name', '\', \'', $prefix.'first_name');
		$last_comma_first_middle = $this->_dataSource->Concat($prefix.'last_name', '\', \'', $prefix.'first_name', '\' \'', $prefix.'middle_name');
		if ($searchMatch === 'is') {
			$searchSql = " AND (LOWER({$prefix}last_name) = LOWER(?) OR LOWER($first_last) = LOWER(?) OR LOWER($first_middle_last) = LOWER(?) OR LOWER($last_comma_first) = LOWER(?) OR LOWER($last_comma_first_middle) = LOWER(?))";
		} elseif ($searchMatch === 'contains') {
			$searchSql = " AND (LOWER({$prefix}last_name) LIKE LOWER(?) OR LOWER($first_last) LIKE LOWER(?) OR LOWER($first_middle_last) LIKE LOWER(?) OR LOWER($last_comma_first) LIKE LOWER(?) OR LOWER($last_comma_first_middle) LIKE LOWER(?))";
			$search = '%' . $search . '%';
		} else { // $searchMatch === 'startsWith'
			$searchSql = " AND (LOWER({$prefix}last_name) LIKE LOWER(?) OR LOWER($first_last) LIKE LOWER(?) OR LOWER($first_middle_last) LIKE LOWER(?) OR LOWER($last_comma_first) LIKE LOWER(?) OR LOWER($last_comma_first_middle) LIKE LOWER(?))";
			$search = $search . '%';
		}
		$params[] = $params[] = $params[] = $params[] = $params[] = $search;
		return $searchSql;
	}
	//
	// Miscellaneous
	//

	/**
	 * Get count of active and complete assignments
	 * @param authorId int
	 * @param journalId int
	 */
	function getSubmissionsCount($authorId, $journalId) {
		$submissionsCount = array();
		$submissionsCount[0] = 0;
		$submissionsCount[1] = 0;
		$submissionsCount[2] = 0;
		$submissionsCount[3] = 0;

		$sql = 'SELECT COUNT(DISTINCT a.article_id) as review_count
				FROM articles a			
					LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
					LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				WHERE	a.user_id = ? 
					AND a.journal_id = ?';
					
		$sql0 = ' AND (a.status <> ' . STATUS_ARCHIVED . ' 
				AND a.status <> '.STATUS_WITHDRAWN.' 
				AND a.status <> '.STATUS_COMPLETED.' 
				AND (
						(
						a.status <> '.STATUS_REVIEWED.' 
						AND (
							a.submission_progress <> 0 
							OR sdec.decision = '.SUBMISSION_SECTION_DECISION_INCOMPLETE.'
						)
					) 
					OR (
						a.status = '.STATUS_REVIEWED.' 
						AND sdec.decision = '.SUBMISSION_SECTION_DECISION_RESUBMIT.'
					)
				))';
				
		$sql1 = ' AND (a.status <> ' . STATUS_ARCHIVED . ' 
				AND a.status <> ' . STATUS_WITHDRAWN . ' 
				AND a.status <> ' . STATUS_REVIEWED . '
				AND a.status <> ' . STATUS_COMPLETED . '
				AND (sdec.decision <> '.SUBMISSION_SECTION_DECISION_INCOMPLETE.' OR NOT EXISTS (SELECT * FROM section_decisions sd WHERE sd.section_decision_id = sdec.section_decision_id AND sd.review_type = a.status))
				AND a.submission_progress = 0)';
				
		$sql2 = ' AND (a.status = '.STATUS_REVIEWED.' 
				AND (sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED . '
				OR sdec.decision = ' . SUBMISSION_SECTION_DECISION_EXEMPTED . '
				) AND a.submission_progress = 0)';
				
		$sql3 = ' AND (a.status = ' . STATUS_COMPLETED .')';
				
		$result0 =& $this->retrieve($sql.$sql0, array($authorId, $journalId));
		$result1 =& $this->retrieve($sql.$sql1, array($authorId, $journalId));
		$result2 =& $this->retrieve($sql.$sql2, array($authorId, $journalId));
		$result3 =& $this->retrieve($sql.$sql3, array($authorId, $journalId));

		$submissionsCount[0] = $result0->Fields('review_count');
		$result0->Close();
		unset($result0);
		$submissionsCount[1] = $result1->Fields('review_count');
		$result1->Close();
		unset($result1);
		$submissionsCount[2] = $result2->Fields('review_count');
		$result2->Close();
		unset($result2);
		$submissionsCount[3] = $result3->Fields('review_count');
		$result3->Close();
		unset($result3);

		return $submissionsCount;
	}

	/**
	 * Map a column heading value to a database value for sorting
	 * @param string
	 * @return string
	 */
	function getSortMapping($heading) {
		switch ($heading) {
			case 'status': return 'a.status';
			case 'id': return 'a.article_id';
			case 'submitDate': return 'a.date_submitted';
			case 'section': return 'section_abbrev';
			case 'authors': return 'author_name';
			case 'title': return 'submission_title';
			case 'active': return 'a.submission_progress';
			case 'views': return 'galley_views';
			case 'status': return 'a.status';
			default: return null;
		}
	}


	/**
	 * Retrieve unfiltered author submissions
	 */
	function &_getUnfilteredAuthorSubmissions($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $countryField = null, $additionalWhereSql = '', $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();

		$params = array(
				$locale,
				$locale,
				'proposalCountry',
				'proposalCountry',
				$locale,
				'title',
				$primaryLocale,
				'title',
				$locale,
				'abbrev',
				$primaryLocale,
				'abbrev',
				$locale,
				$authorId,
				$journalId
		);
		
		$searchSql = '';
		$countrySql = '';

		if (!empty($search)) switch ($searchField) {
			case SUBMISSION_FIELD_TITLE:
				if ($searchMatch === 'is') {
					$searchSql = ' AND LOWER(COALESCE(abl.scientific_title, abpl.scientific_title)) = LOWER(?)';
				} elseif ($searchMatch === 'contains') {
					$searchSql = ' AND LOWER(COALESCE(abl.scientific_title, abpl.scientific_title)) LIKE LOWER(?)';
					$search = '%' . $search . '%';
				} else {
					$searchSql = ' AND LOWER(COALESCE(abl.scientific_title, abpl.scientific_title)) LIKE LOWER(?)';
					$search = $search . '%';
				}
				$params[] = $search;
				break;		
		}
		
		if (!empty($dateFrom) || !empty($dateTo)) switch($dateField) {
			case SUBMISSION_FIELD_DATE_SUBMITTED:
				if (!empty($dateFrom)) {
					$searchSql .= ' AND a.date_submitted >= ' . $this->datetimeToDB($dateFrom);
				}
				if (!empty($dateTo)) {
					$searchSql .= ' AND a.date_submitted <= ' . $this->datetimeToDB($dateTo);
				}
				break;
		}
											  	
		if (!empty($countryField)) {
			$countrySql = " AND LOWER(COALESCE(apc.setting_value, appc.setting_value)) = '" . $countryField . "'";
		}


				
		$sql = 'SELECT DISTINCT
					a.*,
					COALESCE(abl.clean_scientific_title, abpl.clean_scientific_title) AS submission_title,
					aa.last_name AS author_name,
					(SELECT SUM(g.views) FROM article_galleys g WHERE (g.article_id = a.article_id AND g.locale = ?)) AS galley_views,
					COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
					COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
				FROM	articles a
					LEFT JOIN authors aa ON (aa.submission_id = a.article_id AND aa.primary_contact = 1)
					LEFT JOIN article_abstract abpl ON (abpl.article_id = a.article_id AND abpl.locale = a.locale)
					LEFT JOIN article_abstract abl ON (abl.article_id = a.article_id AND abl.locale = ?)
					LEFT JOIN article_settings appc ON (a.article_id = appc.article_id AND appc.setting_name = ? AND appc.locale = a.locale)
					LEFT JOIN article_settings apc ON (a.article_id = apc.article_id AND apc.setting_name = ? AND apc.locale = ?)	
					LEFT JOIN sections s ON (s.section_id = a.section_id)
					LEFT JOIN section_settings stpl ON (s.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
					LEFT JOIN section_settings stl ON (s.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
					LEFT JOIN section_settings sapl ON (s.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
					LEFT JOIN section_settings sal ON (s.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)				
					LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
					LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
				WHERE	a.user_id = ? 
					AND a.journal_id = ?'.
					(!empty($additionalWhereSql)?" AND ($additionalWhereSql)":'');


		$result =& $this->retrieveRange($sql . ' ' . $searchSql . $countrySql . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
			$params,
			$rangeInfo
		);

		return $result;
	}

	/**
	 * Get all proposals to submit for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorProposalsToSubmitIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $countryField,
				'a.status <> ' . STATUS_ARCHIVED . ' 
				AND a.status <> '.STATUS_WITHDRAWN.' 
				AND a.status <> '.STATUS_COMPLETED.' 
				AND (
						(
						a.status <> '.STATUS_REVIEWED.' 
						AND (
							a.submission_progress <> 0 
							OR sdec.decision = '.SUBMISSION_SECTION_DECISION_INCOMPLETE.'
						)
					) 
					OR (
						a.status = '.STATUS_REVIEWED.' 
						AND sdec.decision = '.SUBMISSION_SECTION_DECISION_RESUBMIT.'
					)
				)', 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all proposals in review for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorProposalsInReviewIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $countryField,
				'a.status <> ' . STATUS_ARCHIVED . ' 
				AND a.status <> ' . STATUS_WITHDRAWN . ' 
				AND a.status <> ' . STATUS_REVIEWED . '
				AND a.status <> ' . STATUS_COMPLETED . '
				AND (sdec.decision <> '.SUBMISSION_SECTION_DECISION_INCOMPLETE.' OR NOT EXISTS (SELECT * FROM section_decisions sd WHERE sd.section_decision_id = sdec.section_decision_id AND sd.review_type = a.status))
				AND a.submission_progress = 0', 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all ongoing proposals for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorOngoingResearchesIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $countryField,
				'a.status = '.STATUS_REVIEWED.' 
				AND (sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED . '
				OR sdec.decision = ' . SUBMISSION_SECTION_DECISION_EXEMPTED . '
				) AND a.submission_progress = 0', 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all completed proposals for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorCompletedResearchesIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $countryField,
				'a.status = '.STATUS_COMPLETED, 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all archives proposals for a journal and a specific author.
	 * @param $journalId int
	 * @param $authorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array AuthorSubmission
	 */
	function &getAuthorArchivesIterator($authorId, $journalId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		
		$result =& $this->_getUnfilteredAuthorSubmissions(
			$authorId, $journalId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $countryField,
				'a.status = ' . STATUS_ARCHIVED . ' 
				OR a.status = ' . STATUS_WITHDRAWN, 
			$rangeInfo, $sortBy, $sortDirection
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorSubmissionFromRow');
		return $returner;
	}
}

?>
