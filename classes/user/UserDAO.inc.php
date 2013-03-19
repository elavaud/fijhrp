<?php

/**
 * @file classes/user/UserDAO.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class UserDAO
 * @ingroup user
 * @see PKPUserDAO
 *
 * @brief Basic class describing users existing in the system.
 */

// $Id$

import('classes.security.Role');
import('classes.user.User');
import('lib.pkp.classes.user.PKPUserDAO');

class UserDAO extends PKPUserDAO {
	/**
	 * Renew a membership to dateEnd + 1 year
	 * if the was expired, renew to current date + 1 year  
	 * @param $user User
	 */	
	function renewMembership(&$user){
		$dateEnd = $user->getSetting('dateEndMembership', 0);
		if (!$dateEnd) $dateEnd = 0;
		
		// if the membership is expired, extend it to today + 1 year
		$time = time();
		if ($dateEnd < $time ) $dateEnd = $time;

		$dateEnd = mktime(23, 59, 59, date("m", $dateEnd), date("d", $dateEnd), date("Y", $dateEnd)+1);
		$user->updateSetting('dateEndMembership', $dateEnd, 'date', 0);
	}

	/**
	 * Retrieve an array of journal users matching a particular field value.
	 * @param $field string the field to match on
	 * @param $match string "is" for exact match, otherwise assume "like" match
	 * @param $value mixed the value to match
	 * @param $allowDisabled boolean
	 * @param $journalId int optional, return only user from this journal
	 * @param $dbResultRange object The desired range of results to return
	 * @return array matching Users
	 */

	function &getJournalUsersByField($field = USER_FIELD_NONE, $match = null, $value = null, $allowDisabled = true, $journalId = null, $dbResultRange = null) {
		$sql = 'SELECT * FROM users u WHERE 1=1';
		if ($journalId) $sql = 'SELECT u.* FROM users u LEFT JOIN roles r ON u.user_id=r.user_id WHERE (r.journal_id='.$journalId.' or r.role_id IS NULL)';

		switch ($field) {
			case USER_FIELD_USERID:
				$sql .= ' AND u.user_id = ?';
				$var = $value;
				break;
			case USER_FIELD_USERNAME:
				$sql .= ' AND LOWER(u.username) ' . 		($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				$var = $match == 'is' ? $value : "%$value%";
				break;
			case USER_FIELD_INITIAL:
				$sql .= ' AND LOWER(u.last_name) LIKE LOWER(?)';
				$var = "$value%";
				break;
			case USER_FIELD_EMAIL:
				$sql .= ' AND LOWER(u.email) ' . 			($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				$var = $match == 'is' ? $value : "%$value%";
				break;
			case USER_FIELD_URL:
				$sql .= ' AND LOWER(u.url) ' . 			($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				$var = $match == 'is' ? $value : "%$value%";
				break;
			case USER_FIELD_FIRSTNAME:
				$sql .= ' AND LOWER(u.first_name) ' . 	($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				$var = $match == 'is' ? $value : "%$value%";
				break;
			case USER_FIELD_LASTNAME:
				$sql .= ' AND LOWER(u.last_name) ' . 		($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				$var = $match == 'is' ? $value : "%$value%";
				break;
		}

		$groupSql = ' GROUP BY u.user_id';
		$orderSql = ' ORDER BY u.last_name, u.first_name'; // FIXME Add "sort field" parameter?

		if ($field != USER_FIELD_NONE)
			$result =& $this->retrieveRange($sql . ($allowDisabled?'':' AND u.disabled = 0') . $groupSql . $orderSql, $var, $dbResultRange);
		else
			$result =& $this->retrieveRange($sql . ($allowDisabled?'':' AND u.disabled = 0') . $groupSql . $orderSql, false, $dbResultRange);

		$returner = new DAOResultFactory($result, $this, '_returnUserFromRowWithData');
		return $returner;
	}
	
	/**
	 * Retrieve an array of users with reviewer role
	 * @param $allowDisabled boolean
	 * @param $dbResultRange object The desired range of results to return
	 * @return array matching Users
	 * Added by aglet 6/30/2011
	 */
	function &getUsersWithReviewerRole($journalId) {
		$reviewers = array();
		$sql = 'SELECT u.* FROM users u LEFT JOIN roles r ON u.user_id=r.user_id AND r.journal_id = '. $journalId .  ' WHERE r.role_id = ' .  ROLE_ID_REVIEWER;
		$orderSql = ' ORDER BY u.last_name, u.first_name'; // FIXME Add "sort field" parameter?

		//$result =& $this->retrieve($sql . ($allowDisabled?'':' AND u.disabled = 0') . $orderSql, false, $dbResultRange);
		$result =& $this->retrieve($sql . $orderSql);
		
		while (!$result->EOF) {
			$reviewers[] =& $this->_returnUserFromRowWithData($result->GetRowAssoc(false));
			$result->MoveNext();
		}

		$result->Close();
		unset($result);

		return $reviewers;		
	}

	/**
	 * Retrieve an array of enrollable users (no secretary, administrator, coordinator)
	 * @param $allowDisabled boolean
	 * @param $dbResultRange object The desired range of results to return
	 * @return array matching Users
	 * Added by EL February 12th 2013
	 */
	function &getEnrollableUsers($journalId, $field = USER_FIELD_NONE, $match = null, $value = null, $allowDisabled = true, $dbResultRange = null, $sortBy = null, $sortDirection = SORT_DIRECTION_ASC) {
		
		$sqlBeg = 'SELECT DISTINCT u.* FROM (';
		$sqlEnd = ') u';
		
		$sql1Beg = 'SELECT u.* 
						FROM users AS u 
						INNER JOIN roles AS r1 
							ON u.user_id = r1.user_id
						INNER JOIN roles AS r2 
							ON u.user_id = r2.user_id 
							AND r2.journal_id = '.$journalId.' 
						WHERE r2.role_id = '.ROLE_ID_AUTHOR.' OR r2.role_id = '.ROLE_ID_REVIEWER.' OR r2.role_id = '.ROLE_ID_SECTION_EDITOR;
		$sql1End = ' GROUP BY u.user_id 
					HAVING COUNT(r1.user_id) = 1';
		
		$sql2Beg = ' UNION SELECT u.*
							FROM users u
 							WHERE NOT EXISTS (
 								SELECT NULL FROM roles r
 									WHERE u.user_id=r.user_id
 									AND r.journal_id = '. $journalId;
 		$sql2End =  ')';

 					
		switch ($field) {
			case USER_FIELD_USERNAME:
				$var = $match == 'is' ? $value : "%$value%";
				$sqlEnd .= ' WHERE LOWER(u.username) ' . ($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				break;
			case USER_FIELD_EMAIL:
				$var = $match == 'is' ? $value : "%$value%";
				$sqlEnd .= ' WHERE LOWER(u.email) ' . ($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				break;
			case USER_FIELD_FIRSTNAME:
				$var = $match == 'is' ? $value : "%$value%";
				$sqlEnd .= ' WHERE LOWER(u.first_name) ' . ($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				break;
			case USER_FIELD_LASTNAME:
				$var = $match == 'is' ? $value : "%$value%";
				$sqlEnd .= ' WHERE LOWER(u.last_name) ' . ($match == 'is' ? '=' : 'LIKE') . ' LOWER(?)';
				break;
		}
		
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$orderSql = ($sortBy?(' ORDER BY ' . $roleDao->getSortMapping($sortBy) . ' ' . $this->getDirectionMapping($sortDirection)) : '');
		
		if ($field != USER_FIELD_NONE) 
			$result =& $this->retrieveRange($sqlBeg . $sql1Beg . $sql1End . $sql2Beg . $sql2End . $sqlEnd . ($allowDisabled?'':' AND u.disabled = 0') . $orderSql, $var, $dbResultRange);
		else $result =& $this->retrieveRange($sqlBeg . $sql1Beg . $sql1End . $sql2Beg . $sql2End . $sqlEnd . ($allowDisabled?'':' WHERE u.disabled = 0') . $orderSql, false, $dbResultRange);
		
		$returner = new DAOResultFactory($result, $this, '_returnUserFromRowWithData');
		return $returner;
	}
	
		
	function insertExternalReviewer($userId, $locale) {
		$sql = 'INSERT INTO user_settings (user_id, locale, setting_name, setting_value, setting_type) '.
			 ' values (?, ?, ?, ?, ?)';		
		$this->update($sql, array($userId, $locale, 'externalReviewer', 'Yes', 'string'));
		$this->flushCache();
		return $userId;
	}
	
	function deleteExternalReviewer($userId, $locale) {	
		$this->update('DELETE FROM user_settings WHERE user_id = '.$userId.' AND setting_name = "externalReviewer"');
		$this->flushCache();
		return $userId;
	}
}

?>
