<?php

/**
 * @file classes/user/User.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class User
 * @ingroup user
 * @see UserDAO
 *
 * @brief Basic class describing users existing in the system.
 */

// $Id$


import('lib.pkp.classes.user.PKPUser');

class User extends PKPUser {

	function User() {
		parent::PKPUser();
	}

	/**
	 * Retrieve array of user settings.
	 * @param journalId int
	 * @return array
	 */
	function &getSettings($journalId = null) {
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		$settings =& $userSettingsDao->getSettingsByJournal($this->getId(), $journalId);
		return $settings;
	}

	/**
	 * Retrieve a user setting value.
	 * @param $name
	 * @param $journalId int
	 * @return mixed
	 */
	function &getSetting($name, $journalId = null) {
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		$setting =& $userSettingsDao->getSetting($this->getId(), $name, $journalId);
		return $setting;
	}

	/**
	 * Set a user setting value.
	 * @param $name string
	 * @param $value mixed
	 * @param $type string optional
	 */
	function updateSetting($name, $value, $type = null, $journalId = null) {
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		return $userSettingsDao->updateSetting($this->getId(), $name, $value, $type, $journalId);
	}

	/**
	 * Get the function of the user
	 * @param $ercMemberIndex boolean, if true, retrieve only for erc members.
	 * @return string
	 * Added by EL on February 15th 2013
	 */
	function getFunctions($ercMemberIndex = false){
		$journal =& Request::getJournal();
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$roles =& $roleDao->getRolesByUserId($this->getId(), $journal->getId());
		$functions;
		
		foreach ($roles as $role){ 
			$roleId =& $role->getRoleId();
			if ($roleId == '512'){
				$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
				$erc =& $sectionEditorsDao->getErcBySecretaryId($this->getId());
				if ($functions != null) $functions .= ' & '.$erc->getLocalizedAbbrev().' Secretary';
				else $functions = $erc->getLocalizedAbbrev().' Secretary';
			}
			elseif ($roleId == '4096'){
				$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
				$erc =& $ercReviewersDao->getErcByReviewerId($this->getId());
				if (isset($erc)) {
					if ($functions != null) $functions .= ' & '.$erc->getLocalizedAbbrev().' '.$ercReviewersDao->getReviewerStatus($this->getId(), $erc->getSectionId());
					else $functions = $erc->getLocalizedAbbrev().' '.$ercReviewersDao->getReviewerStatus($this->getId(), $erc->getSectionId());
				} else {
					if ($functions != null) $functions .= ' & External Reviewer';
					else  $functions = 'External Reviewer';
				}
			}
			elseif ($roleId == '65536' && $ercMemberIndex == false){
				if ($functions != null){
					$functions .= ' & Investigator';
				}
				else {
					$functions = 'Investigator';
				}
			}
			elseif ($roleId == '256' && $ercMemberIndex == false){
				if ($functions != null){
					$functions .= ' & Coordinator';
				}
				else {
					$functions = 'Coordinator';
				}
			}
			elseif ($roleId == '16' && $ercMemberIndex == false){
				if ($functions != null){
					$functions .= ' & Administrator';
				}
				else {
					$functions = 'Administrator';
				}
			}
		}
		return $functions;
	}

	/**
	 * Get the erc (section in OJS) id of the user (if exists)
	 * @return int (or null if no committee)
	 * Added by EL on February 17th 2013
	 */	
	function getCommittee(){
		$journal =& Request::getJournal();
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$roles =& $roleDao->getRolesByUserId($this->getId(), $journal->getId());
		foreach ($roles as $role){
			$roleId = $role->getRoleId();
			if ($roleId == '512'){
				$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
				$erc =& $sectionEditorsDao->getErcBySecretaryId($this->getId());
				if (isset($erc)) return $erc->getSectionId();
				else return null;
			} elseif ($roleId == '4096') {
				$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
				$erc =& $ercReviewersDao->getErcByReviewerId($this->getId());
				if (isset($erc)) return $erc->getSectionId();
				else return null;
			}
		}
		return null;		
	}
}

?>
