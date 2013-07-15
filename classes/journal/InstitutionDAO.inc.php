<?php

/**
 * @file classes/journal/ErcReviewersDAO.inc.php
 *
 *
 * @class ErcReviewersDAO
 * @ingroup journal
 *
 * @brief Class for DAO relating erc to reviewers.
 */

// $Id$
import ('classes.journal.Institution');
class InstitutionDAO extends DAO {

	/*
	 *Returns all institution in the database
	 * */
	function &getAllInstitutions($rangeInfo = null, $sortBy, $sortDirection) {

		$params = array();
		$sql = 'SELECT * FROM institutions';
		
		$result =& $this->retrieveRange(
			$sql.($sortBy?(' ORDER BY ' . $this->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : ''),
				count($params)===1?array_shift($params):$params,
				$rangeInfo);

		$institution = new DAOResultFactory($result, $this, '_returnInstitutionFromRow');
		return $institution;
	}
	
	function getSortMapping($heading) {
		switch ($heading) {
			case 'instition': return 'institution';
			case 'region': return 'region_code';
			default: return 'institution';
		}
	}

	/*
	 * Return institution object using the institutionID
	 */
	function getInstitutionById($institutionId = null){
		$result =& $this->retrieve(
			"SELECT * FROM institutions WHERE institution_id = '$institutionId'"
		);
		$institution = $this->_returnInstitutionFromRow($result->GetRowAssoc(false));
		
		return $institution;
	}

	function insertInstitution(&$institution){
		print_r($institution->getInstitution());
		print_r($institution->getInstitutionType());
		$this->update(
			'INSERT INTO institutions
				(institution, region_code, institution_type)
				VALUES
				(?,?,?)',
			array(
				$institution->getInstitution(),
				$institution->getRegion(),
				$institution->getInstitutionType()
			)
		);

	}
	
	function deleteInstitutionById($institutionId) {
		return $this->update('DELETE FROM institutions WHERE institution_id = ?', array($institutionId));
	}
	
	function updateInstitution(&$institution){

		return $this->update(
			'UPDATE institutions
				SET
					institution = ?,
					institution_type = ?,
					region_code = ?
				WHERE institution_id = ?',
			array(
				$institution->getInstitution(),
				$institution->getInstitutionType(),
				$institution->getRegion(),
				$institution->getId()
			)
		);
	}
	/**
	 * Internal function to return a Institution object from a row.
	 * @param $row array
	 * @return Section
	 */
	function &_returnInstitutionFromRow(&$row) {
		$institution = new Institution();
		$institution->setId($row['institution_id']);
		$institution->setInstitution($row['institution']);
		$institution->setInstitutionType($row['institution_type']);
		$institution->setRegion($row['region_code']);

		HookRegistry::call('InstitutionDAO::_returnInstitutionFromRow', array(&$institution, &$row));

		return $institution;
	}
}

?>
