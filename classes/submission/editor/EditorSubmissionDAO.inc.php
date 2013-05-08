<?php

/**
 * @file classes/editor/EditorSubmissionDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class EditorSubmissionDAO
 * @ingroup submission
 * @see EditorSubmission
 *
 * @brief Operations for retrieving and modifying EditorSubmission objects.
 */

// $Id$


import('classes.submission.editor.EditorSubmission');
import('classes.submission.sectionEditor.SectionEditorSubmissionDAO');

// Bring in editor decision constants
import('classes.submission.common.Action');
import('classes.submission.author.AuthorSubmission');

class EditorSubmissionDAO extends DAO {
	var $articleDao;
	var $authorDao;
	var $userDao;
	var $sectionDecisionDao;

	/**
	 * Constructor.
	 */
	function EditorSubmissionDAO() {
		parent::DAO();
		$this->articleDao =& DAORegistry::getDAO('ArticleDAO');
		$this->authorDao =& DAORegistry::getDAO('AuthorDAO');
		$this->userDao =& DAORegistry::getDAO('UserDAO');
		$this->sectionDecisionDao =& DAORegistry::getDAO('SectionDecisionDAO');
	}

	/**
	 * Retrieve an editor submission by article ID.
	 * @param $articleId int
	 * @return EditorSubmission
	 */
	function &getEditorSubmission($articleId) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$result =& $this->retrieve(
			'SELECT
				a.*,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN sections s ON s.section_id = a.section_id
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
				$articleId
			)
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnEditorSubmissionFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Internal function to return an EditorSubmission object from a row.
	 * @param $row array
	 * @return EditorSubmission
	 */
	function &_returnEditorSubmissionFromRow(&$row) {
		$editorSubmission = new EditorSubmission();

		// Article attributes
		$this->articleDao->_articleFromRow($editorSubmission, $row);

		$editorSubmission->setDecisions($this->sectionDecisionDao->getSectionDecisionsByArticleId($row['article_id']));

		HookRegistry::call('EditorSubmissionDAO::_returnEditorSubmissionFromRow', array(&$editorSubmission, &$row));

		return $editorSubmission;
	}


	/**
	 * Get all unfiltered submissions for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $additionalWhereSql String additional SQL "where" clause info
	 * @param $rangeInfo object
	 * @return array result
	 */
	
	function &_getUnfilteredEditorSubmissions($journalId, $sectionId = null, $editorId = 0, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $additionalWhereSql, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$primaryLocale = Locale::getPrimaryLocale();
		$locale = Locale::getLocale();
		$params = array(
			'title', // Section title
			$primaryLocale,
			'title',
			$locale,
			'abbrev', // Section abbrev
			$primaryLocale,
			'abbrev',
			$locale,
			$locale,
			'researchField',
			'researchField',
			$locale,
			'proposalCountry',
			'proposalCountry',
			$locale,
			'approvalDate',
			$locale,
			'proposalId',
			'proposalId',
			$locale,
			'studentInitiatedResearch',
			'studentInitiatedResearch',
			$locale,
			'academicDegree',
			'academicDegree',
			$locale,
			'primarySponsor',
			'primarySponsor',
			$locale,
			'secondarySponsors',
			'secondarySponsors',
			$locale,
			'proposalType',
			'proposalType',
			$locale,
			'dataCollection',
			'dataCollection',
			$locale,
			'multiCountryResearch',
			'multiCountryResearch',
			$locale,
			'nationwide',
			'nationwide',
			$locale,
			'startDate',
			$locale,
			'endDate',
			$locale,
			$journalId
		);
		$searchSql = '';
		$researchFieldSql = '';
		$countrySql = '';

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
			case SUBMISSION_FIELD_ID:
				if ($searchMatch === 'is') {
					$searchSql = ' AND LOWER(COALESCE(aid.setting_value, atid.setting_value)) = LOWER(?)';
				} elseif ($searchMatch === 'contains') {
					$searchSql = ' AND LOWER(COALESCE(aid.setting_value, atid.setting_value)) LIKE LOWER(?)';
					$search = '%' . $search . '%';
				} else { // $searchMatch === 'startsWith'
					$searchSql = ' AND LOWER(COALESCE(aid.setting_value, atid.setting_value)) LIKE LOWER(?)';
					$search = $search . '%';
				}
				$params[] = $search;
				break;
			case SUBMISSION_FIELD_AUTHOR:
				$searchSql = $this->_generateUserNameSearchSQL($search, $searchMatch, 'aa.', $params);
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
			case SUBMISSION_FIELD_DATE_APPROVED:
				if (!empty($dateFrom)) {
					$searchSql .= ' AND apd.setting_value >= ' . $this->datetimeToDB($dateFrom);
				}
				if (!empty($dateTo)) {
					$searchSql .= ' AND apd.setting_value <= ' . $this->datetimeToDB($dateTo);
				}
				break;
		}
		
		if (!empty($researchFieldField)) {
			$researchFieldSql = ' AND LOWER(COALESCE(atu.setting_value, atpu.setting_value)) LIKE LOWER(?)';
			$researchFieldField = '%'.$researchFieldField.'%';
			$params[] = $researchFieldField;
		}
		if (!empty($countryField)) {
			$countrySql = ' AND LOWER(COALESCE(apc.setting_value, appc.setting_value)) LIKE LOWER(?)';
			$countryField = '%'.$countryField.'%';
			$params[] = $countryField;
		}

		$sql = 'SELECT DISTINCT
				a.*,
				COALESCE(abl.clean_scientific_title, abpl.clean_scientific_title) AS submission_title,
				aap.first_name AS afname, aap.last_name AS alname, 
				aap.affiliation as investigatoraffiliation, aap.email as email,
				COALESCE(stl.setting_value, stpl.setting_value) AS section_title,
				COALESCE(sal.setting_value, sapl.setting_value) AS section_abbrev
			FROM	articles a
				LEFT JOIN authors aa ON (aa.submission_id = a.article_id)
				LEFT JOIN authors aap ON (aap.submission_id = a.article_id AND aap.primary_contact = 1)
				LEFT JOIN sections s ON (s.section_id = a.section_id)
				LEFT JOIN section_editors se ON (se.section_id = a.section_id)
				
				LEFT JOIN section_settings stpl ON (s.section_id = stpl.section_id AND stpl.setting_name = ? AND stpl.locale = ?)
				LEFT JOIN section_settings stl ON (s.section_id = stl.section_id AND stl.setting_name = ? AND stl.locale = ?)
				
				LEFT JOIN section_settings sapl ON (s.section_id = sapl.section_id AND sapl.setting_name = ? AND sapl.locale = ?)
				LEFT JOIN section_settings sal ON (s.section_id = sal.section_id AND sal.setting_name = ? AND sal.locale = ?)
				
				LEFT JOIN article_abstract abpl ON (a.article_id = abpl.article_id AND abpl.locale = a.locale)
				LEFT JOIN article_abstract abl ON (a.article_id = abl.article_id AND abl.locale = ?)
				
				LEFT JOIN article_settings atpu ON (a.article_id = atpu.article_id AND atpu.setting_name = ? AND atpu.locale = a.locale)
				LEFT JOIN article_settings atu ON (a.article_id = atu.article_id AND atu.setting_name = ? AND atu.locale = ?)
				
				LEFT JOIN article_settings appc ON (a.article_id = appc.article_id AND appc.setting_name = ? AND appc.locale = a.locale)
				LEFT JOIN article_settings apc ON (a.article_id = apc.article_id AND apc.setting_name = ? AND apc.locale = ?)
				
				LEFT JOIN article_settings apd ON (a.article_id = apd.article_id AND apd.setting_name = ? AND apd.locale = ?)	
				
				LEFT JOIN article_settings atid ON (a.article_id = atid.article_id AND atid.setting_name = ? AND atid.locale = a.locale)
				LEFT JOIN article_settings aid ON (a.article_id = aid.article_id AND aid.setting_name = ? AND aid.locale = ?)
				
				LEFT JOIN article_settings str ON (a.article_id = str.article_id AND str.setting_name = ? AND str.locale = a.locale)
				LEFT JOIN article_settings sr ON (a.article_id = sr.article_id AND sr.setting_name = ? AND sr.locale = ?)

				LEFT JOIN article_settings atd ON (a.article_id = atd.article_id AND atd.setting_name = ? AND atd.locale = a.locale)
				LEFT JOIN article_settings ad ON (a.article_id = ad.article_id AND ad.setting_name = ? AND ad.locale = ?)

				LEFT JOIN article_settings pts ON (a.article_id = pts.article_id AND pts.setting_name = ? AND pts.locale = a.locale)
				LEFT JOIN article_settings ps ON (a.article_id = ps.article_id AND ps.setting_name = ? AND ps.locale = ?)				
								
				LEFT JOIN article_settings sts ON (a.article_id = sts.article_id AND sts.setting_name = ? AND sts.locale = a.locale)
				LEFT JOIN article_settings ss ON (a.article_id = ss.article_id AND ss.setting_name = ? AND ss.locale = ?)				
				
				LEFT JOIN article_settings ptt ON (a.article_id = ptt.article_id AND ptt.setting_name = ? AND ptt.locale = a.locale)
				LEFT JOIN article_settings pt ON (a.article_id = pt.article_id AND pt.setting_name = ? AND pt.locale = ?)	

				LEFT JOIN article_settings dtc ON (a.article_id = dtc.article_id AND dtc.setting_name = ? AND dtc.locale = a.locale)
				LEFT JOIN article_settings dc ON (a.article_id = dc.article_id AND dc.setting_name = ? AND dc.locale = ?)								
				LEFT JOIN article_settings mtcr ON (a.article_id = mtcr.article_id AND mtcr.setting_name = ? AND mtcr.locale = a.locale)
				LEFT JOIN article_settings mcr ON (a.article_id = mcr.article_id AND mcr.setting_name = ? AND mcr.locale = ?)
				
				LEFT JOIN article_settings ntwr ON (a.article_id = ntwr.article_id AND ntwr.setting_name = ? AND ntwr.locale = a.locale)
				LEFT JOIN article_settings nwr ON (a.article_id = nwr.article_id AND nwr.setting_name = ? AND nwr.locale = ?)	

				LEFT JOIN article_settings sd ON (a.article_id = sd.article_id AND sd.setting_name = ? AND sd.locale = ?)

				LEFT JOIN article_settings ed ON (a.article_id = ed.article_id AND ed.setting_name = ? AND ed.locale = ?)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
				LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
			WHERE	sdec2.section_decision_id IS NULL
				AND a.journal_id = ?
				AND a.submission_progress = 0' .
				(!empty($additionalWhereSql)?" $additionalWhereSql":'');
				
		if ($sectionId) {
			$searchSql .= ' AND a.section_id = ?';
			$params[] = $sectionId;
		}

		if ($editorId) {
			$searchSql .= ' AND ed.user_id = ?';
			$params[] = $editorId;
		}

		$result =& $this->retrieveRange(
			$sql . ' ' . $searchSql . $researchFieldSql . $countrySql . ($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
			count($params)===1?array_shift($params):$params,
			$rangeInfo
		);
		return $result;
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

	/**
	 * Get all submissions unassigned for a journal.
	 * for including resubmitted proposals into unassigned
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	function &getEditorSubmissionsUnassigned($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED . ' AND (ea.edit_id IS NULL AND a.submission_progress = 0) OR (sdec.decision = 5 AND a.submission_progress = 0)', //and not draft aglet 9/26/2011
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all submissions in review for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	//function &getEditorSubmissionsInReviewIterator($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
	function &getEditorSubmissionsInReviewIterator($editorId, $journalId, $Id, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$rawSubmissions =& $this->_getUnfilteredEditorSubmissions(
					$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED 
			// EL on April 2013: no edit assignments anymore
			//. ' AND e.can_review = 1 '
			,
			$rangeInfo, $sortBy, $sortDirection
				);
		$submissions = new DAOResultFactory($rawSubmissions, $this, '_returnEditorSubmissionFromRow');
		return $submissions;
	}

	/**
	 * Get all submissions in editing for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	function &getEditorSubmissionsInEditingIterator($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED . ' AND ea.edit_id IS NOT NULL AND sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED,
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all submissions archived for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 * ARTICLE STATUS = 9 if proposal is withdrawn
	 * Edited by aglet
	 * Last Update: 6/4/2011
	 */
	function &getEditorSubmissionsArchivesIterator($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, null, null,
			' AND a.status <> '. STATUS_QUEUED,
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}

	/**
	 * Get all submissions for a journal.
	 * @param $journalId int
	 * @param $sectionId int
	 * @param $editorId int
	 * @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	 * @param $searchMatch string "is" or "contains" or "startsWith"
	 * @param $search String to look in $searchField for
	 * @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	 * @param $dateFrom String date to search from
	 * @param $dateTo String date to search to
	 * @param $rangeInfo object
	 * @return array EditorSubmission
	 */
	function &getEditorSubmissions($journalId, $sectionId, $editorId, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$result =& $this->_getUnfilteredEditorSubmissions(
			$journalId, $sectionId, $editorId,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, null, null,
			null,
			$rangeInfo, $sortBy, $sortDirection
		);
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}
	
	/**
	 * Function used for counting purposes for right nav bar
	 * Edited: removed AND a.submission_progress = 0				
	 * Edited by aglet
	 * Last Update: 6/4/2011				
	 */
	function &getEditorSubmissionsCount($journalId) {
		$submissionsCount = array();
		for($i = 0; $i < 3; $i++) {
			$submissionsCount[$i] = 0;
		}

		$result =& $this->retrieve(
			"SELECT	COUNT(*) AS unassigned_count
			FROM	articles a
				LEFT JOIN section_editors se ON (a.section_id = se.section_id)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
			WHERE	a.journal_id = ? ".
				"AND (a.submission_progress = 0 AND a.status = " . STATUS_QUEUED . "
				) OR (sdec.decision = 5 AND a.submission_progress = 0)",
			array((int) $journalId)
		);
		
		$submissionsCount[0] = $result->Fields('unassigned_count');
		$result->Close();

		$result =& $this->retrieve(
			'SELECT	COUNT(*) AS review_count
			FROM	articles a
				LEFT JOIN section_editors se ON (a.section_id = se.section_id)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
				LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
			WHERE	a.journal_id = ?
				AND a.status = ' . STATUS_QUEUED . '
				AND sdec2.section_decision_id IS NULL ',
			array((int) $journalId)
		);
		
		$submissionsCount[1] = $result->Fields('review_count');
		$result->Close();
		
		$result =& $this->retrieve(
			'SELECT	COUNT(*) AS editing_count
			FROM	articles a
				LEFT JOIN section_editors se ON (a.section_id = se.section_id)
				LEFT JOIN section_decisions sdec ON (a.article_id = sdec.article_id)
				LEFT JOIN section_decisions sdec2 ON (a.article_id = sdec2.article_id AND sdec.section_decision_id < sdec2.section_decision_id)
			WHERE	a.journal_id = ?
				AND a.status = ' . STATUS_QUEUED . '
				AND sdec2.section_decision_id IS NULL
				AND sdec.decision = ' . SUBMISSION_SECTION_DECISION_APPROVED,
			array((int) $journalId)
		);
		
		$submissionsCount[2] = $result->Fields('editing_count');
		$result->Close();

		return $submissionsCount;
	}

	//
	// Miscellaneous
	//

	/**
	 * Get the editor decisions for an editor.
	 * @param $userId int
	 */
	function transferSectionDecisions($oldUserId, $newUserId) {
		$this->update(
			'UPDATE section_decisions SET section_id = ? WHERE section_id = ?',
			array($newUserId, $oldUserId)
		);
	}

	/**
	 * Get the ID of the last inserted editor assignment.
	 * @return int
	 */
	function getInsertEditId() {
		return $this->getInsertId('edit_assignments', 'edit_id');
	}

	/**
	 * Map a column heading value to a database value for sorting
	 * @param string
	 * @return string
	 */
	function getSortMapping($heading) {
		switch ($heading) {
			case 'id': return 'a.article_id';
			case 'submitDate': return 'a.date_submitted';
			case 'section': return 'section_abbrev';
			case 'authors': return 'author_name';
			case 'title': return 'submission_title';
			case 'active': return 'a.submission_progress';
			case 'subCopyedit': return 'copyedit_completed';
			case 'subLayout': return 'layout_completed';
			case 'subProof': return 'proofread_completed';
			case 'status': return 'a.status';
			case 'country': return 'appc.setting_value';
			case 'decision': return 'sdec.decision';
			case 'researchField': return 'atu.setting_value';
			default: return null;
		}
	}
	
	/**
	*Added by MSB, Oct12, 2011
	**/
	function getDecisionMapping($decision){
		switch ($decision){
			case 'editor.article.decision.approved': 		return SUBMISSION_SECTION_DECISION_APPROVED;
			case 'editor.article.decision.resubmit': 	return SUBMISSION_SECTION_DECISION_RESUBMIT;
			case 'editor.article.decision.declined': 	return SUBMISSION_SECTION_DECISION_DECLINED;
			case 'editor.article.decision.complete': 	return SUBMISSION_SECTION_DECISION_COMPLETE;
			case 'editor.article.decision.incomplete':	return SUBMISSION_SECTION_DECISION_INCOMPLETE;
			case 'editor.article.decision.exempted': 	return SUBMISSION_SECTION_DECISION_EXEMPTED;
			case 'editor.article.decision.fullReview': 	return SUBMISSION_SECTION_DECISION_FULL_REVIEW;
			case 'editor.article.decision.expedited':	return SUBMISSION_SECTION_DECISION_EXPEDITED;
		}
	}

	function &getEditorSubmissionsForErcReview($editorId, $journalId, $Id) {
		$editorSubmissions = array();
		$result =& $this->_getUnfilteredEditorSubmissions(
			$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, null, null,
			' AND a.status = ' . STATUS_QUEUED . ' AND 
			// EL on April 2013: no edit assignments anymore
			//e.can_review = 1 AND 
			(sdec.decision = ' . SUBMISSION_SECTION_DECISION_FULL_REVIEW . ')',
			$rangeInfo, $sortBy, $sortDirection
		);

		while (!$result->EOF) {
			$editorSubmissions[] =& $this->_returnEditorSubmissionFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $editorSubmissions;
	}
	
	function &getEditorSubmissionsInReview($editorId, $journalId, $Id, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null, $rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$editorSubmissions = array();
		$result =& $this->_getUnfilteredEditorSubmissions(
			$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND a.status = ' . STATUS_QUEUED
			 // EL on April 2013: no edit assignments anymore
			 //. ' AND e.can_review = 1 '
			 ,
			$rangeInfo, $sortBy, $sortDirection
		);

		while (!$result->EOF) {
			$editorSubmissions[] =& $this->_returnEditorSubmissionFromRow($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $editorSubmissions;
	}
	

	function &getEditorSubmissionsArchives($editorId, $journalId, $Id, $searchField = null, $searchMatch = null, $search = null, $dateField = null, $dateFrom = null, $dateTo = null, $researchFieldField = null, $countryField = null,$rangeInfo = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		$editorSubmissions = array();
		$result = $this->_getUnfilteredEditorSubmissions(
			$editorId, $journalId, $Id,
			$searchField, $searchMatch, $search,
			$dateField, $dateFrom, $dateTo, $researchFieldField, $countryField,
			' AND (a.status <> ' . STATUS_QUEUED . ')',
			$rangeInfo, $sortBy, $sortDirection
		);

       //Array format necessary for pagination in .tpl
       $returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
return $returner;
	}	
	
	
   /**
	* Get all submissions for a report.
	* @param $journalId int
	* @param $sectionId int
	* @param $editorId int
	* @param $searchField int Symbolic SUBMISSION_FIELD_... identifier
	* @param $searchMatch string "is" or "contains" or "startsWith"
	* @param $search String to look in $searchField for
	* @param $dateField int Symbolic SUBMISSION_FIELD_DATE_... identifier
	* @param $dateFrom String date to search from
	* @param $dateTo String date to search to
	* @param $countryFields Array of countries
	* @param $decisionFields Array of decisions
	* @param $researchFieldFields Array of researchFields
	* @param $rangeInfo object
	* @return array EditorSubmission
	*/
	function &getEditorSubmissionsReport($journalId, $sectionId = null, $sresearch = null, $adegree = null, $primarySponsorField = null, $secondarySponsorField = null, $researchFieldFields = null, $proposalTypeFields = null, $dataCollection = null, $multiCountry = null, $nationwide = null,$countryFields = null, $startDateBefore = null, $startDateAfter = null, $endDateBefore = null, $endDateAfter = null, $submittedBefore = null, $submittedAfter = null, $approvedBefore = null, $approvedAfter = null, $decisionFields = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {

		$sql = "";
		if (!empty($sresearch)) {
			$sql .= " AND (LOWER(COALESCE(sr.setting_value, str.setting_value)) LIKE '".$sresearch."')";
		}

		if (!empty($adegree)) {
			$sql .= " AND (LOWER(COALESCE(ad.setting_value, atd.setting_value)) LIKE '".$adegree."')";
		}
				
		if(!empty($decisionFields)){
			$decisionSql = "";
			$present = false;
			foreach ($decisionFields as $decisionField){
				if(!empty($decisionField)){
					$present = true;
					if ($decisionSql == "" || $decisionSql == null) $decisionSql = "sdec.decision = " . $this->getDecisionMapping($decisionField) . "";
					else $decisionSql .= " OR sdec.decision = " . $this->getDecisionMapping($decisionField) . "";
				}
			} if ($present) $sql .= " AND (".$decisionSql.")";
		}

		if(!empty($primarySponsorField)){
			$primarySponsorSql = "";
			$present = false;
			foreach ($primarySponsorField as $primarySponsor){
				if(!empty($primarySponsor)){
					$present = true;
					if ($primarySponsorSql == "" || $primarySponsorSql == null) $primarySponsorSql = "LOWER(COALESCE(ps.setting_value, pts.setting_value)) LIKE '" . $primarySponsor . "%'";
					else $primarySponsorSql .= " OR LOWER(COALESCE(ps.setting_value, pts.setting_value)) LIKE '" . $primarySponsor . "%'";
				}
			} if ($present) $sql .= " AND (".$primarySponsorSql.")";
		}
		
		if(!empty($secondarySponsorField)){
			$secondarySponsorSql = "";
			$present = false;
			foreach ($secondarySponsorField as $secondarySponsor){
				if(!empty($secondarySponsor)){
					$present = true;
					if ($secondarySponsorSql == "" || $secondarySponsorSql == null) $secondarySponsorSql = "LOWER(COALESCE(ss.setting_value, sts.setting_value)) LIKE '%" . $secondarySponsor . "%'";
					else $secondarySponsorSql .= " OR LOWER(COALESCE(ss.setting_value, sts.setting_value)) LIKE '%" . $secondarySponsor . "%'";
				}
			} if ($present) $sql .= " AND (".$secondarySponsorSql.")";
		}
		
		if(!empty($researchFieldFields)){
			$researchFieldSql = "";
			$present = false;
			foreach ($researchFieldFields as $researchFieldField){
				if(!empty($researchFieldField)){
					$present = true;
					if ($researchFieldSql == "" || $researchFieldSql == null) $researchFieldSql = "LOWER(COALESCE(atu.setting_value, atpu.setting_value)) LIKE '%" . $researchFieldField . "%'";
					else $researchFieldSql .= " OR LOWER(COALESCE(atu.setting_value, atpu.setting_value)) LIKE '%" . $researchFieldField . "%'";
				}
			} if ($present) $sql .= " AND (".$researchFieldSql.")";
		} 

		if(!empty($proposalTypeFields)){
			$proposalTypeSql = "";
			$present = false;
			foreach ($proposalTypeFields as $proposalType){
				if(!empty($proposalType)){
					$present = true;
					if ($proposalTypeSql == "" || $proposalTypeSql == null) $proposalTypeSql = "LOWER(COALESCE(pt.setting_value, ptt.setting_value)) LIKE '%" . $proposalType . "%'";
					else $proposalTypeSql .= " OR LOWER(COALESCE(pt.setting_value, ptt.setting_value)) LIKE '%" . $proposalType . "%'";
				}
			} if ($present) $sql .= " AND (".$proposalTypeSql.")";
		} 

		if (!empty($dataCollection)) $sql .= " AND (LOWER(COALESCE(dc.setting_value, dtc.setting_value)) LIKE '".$dataCollection."')";
		

		if (!empty($multiCountry)) {
			$sql .= " AND (LOWER(COALESCE(mcr.setting_value, mtcr.setting_value)) LIKE '".$multiCountry."')";
			if ($multiCountry == 'No' && !empty($nationwide)) {
				$sql .= " AND (LOWER(COALESCE(nwr.setting_value, ntwr.setting_value)) LIKE '".$nationwide."')";
				if ($nationwide == 'No' && !empty($countryFields)){
					$countrySql = "";
					$present = false;
					foreach ($countryFields as $countryField){
						if(!empty($countryField)){
							$present = true;
							if ($countrySql == "" || $countrySql == null) $countrySql = "LOWER(COALESCE(apc.setting_value, appc.setting_value)) LIKE '%" . $countryField . "%'";
							else $countrySql .= " OR LOWER(COALESCE(apc.setting_value, appc.setting_value)) LIKE '%" . $countryField . "%'";
						}
					} if ($present) $sql .= " AND (".$countrySql.")";				
				}
			}
		}
		
		if (!empty($startDateBefore)){
			$newDate = date("Y-m-d", strtotime($startDateBefore));
			$sql .= " AND (STR_TO_DATE(sd.setting_value, '%d-%b-%Y') <= ".$this->datetimeToDB($newDate).")";
		}

		if (!empty($startDateAfter)){
			$newDate = date("Y-m-d", strtotime($startDateAfter));
			$sql .= " AND (STR_TO_DATE(sd.setting_value, '%d-%b-%Y') >= ".$this->datetimeToDB($newDate).")";
		}

		if (!empty($endDateBefore)){
			$newDate = date("Y-m-d", strtotime($endDateBefore));
			$sql .= " AND (STR_TO_DATE(ed.setting_value, '%d-%b-%Y') <= ".$this->datetimeToDB($newDate).")";
		}

		if (!empty($endDateAfter)){
			$newDate = date("Y-m-d", strtotime($endDateAfter));
			$sql .= " AND (STR_TO_DATE(ed.setting_value, '%d-%b-%Y') >= ".$this->datetimeToDB($newDate).")";
		}
		
		if (!empty($submittedBefore)){
			$newDate = date("Y-m-d", strtotime($submittedBefore));
			$sql .= " AND (a.date_submitted <= ".$this->datetimeToDB($newDate).")";
		}

		if (!empty($submittedAfter)){
			$newDate = date("Y-m-d", strtotime($submittedAfter));
			$sql .= " AND (a.date_submitted >= ".$this->datetimeToDB($newDate).")";
		}

		if (!empty($approvedBefore)){
			$newDate = date("Y-m-d", strtotime($approvedBefore));
			$sql .= " AND (apd.setting_value <= ".$this->datetimeToDB($newDate).")";
		}

		if (!empty($approvedAfter)){
			$newDate = date("Y-m-d", strtotime($approvedAfter));
			$sql .= " AND (apd.setting_value >= ".$this->datetimeToDB($newDate).")";
		}
				
		$result =& $this->_getUnfilteredEditorSubmissions(
		$journalId, $sectionId, null,
		null, null, null,
		SUBMISSION_FIELD_DATE_SUBMITTED, null, null, null, null,
		$sql,
		null, $sortBy, $sortDirection
		);
	
		$returner = new DAOResultFactory($result, $this, '_returnEditorSubmissionFromRow');
		return $returner;
	}
	
}

?>
