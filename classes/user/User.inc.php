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
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$roles =& $roleDao->getRolesByUserId($this->getId(), $journal->getId());
		$functions = (string)'';
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
				$committeeIds = $ercReviewersDao->getCommitteeIdsByUserId($this->getId());
				foreach ($committeeIds as $committeeId) {
					if ($committeeId != 0) {
						$erc =& $sectionDao->getSection($committeeId);
						if ($functions != null) $functions .= ' & '.$erc->getLocalizedAbbrev().' '.$ercReviewersDao->getReviewerStatus($this->getId(), $erc->getSectionId());
						else $functions = $erc->getLocalizedAbbrev().' '.$ercReviewersDao->getReviewerStatus($this->getId(), $erc->getSectionId());					
					} else {
						if ($functions != null) $functions .= ' & External Reviewer';
						else  $functions = 'External Reviewer';					
					}
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
	 * Get the erc function of the user according to the erc:
	 * Secretary + Chair = Chair
	 * Secretary + Vice-Chair = Vice Chair
	 * Secretary + Member = Secretary
	 * Else secretary or member
	 *
	 * @param $sectionId
	 * @return string
	 * Added by EL on March 14th 2013
	 */
	function getErcFunction($sectionId){
		$journal =& Request::getJournal();
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
		$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
		
		$erc =& $sectionDao->getSection($sectionId);
		$reviewerStatus = $ercReviewersDao->getReviewerStatus($this->getId(), $sectionId);
		$isSecretary = $sectionEditorsDao->ercSecretaryExists($journal->getId(), $sectionId, $this->getId());
		
		$ercAbbrev = $erc->getLocalizedAbbrev();
		$function = (string)'';
		
		if ($isSecretary) {
			if ($reviewerStatus == "Chair" || $reviewerStatus == "Vice-Chair") $function = $ercAbbrev.' '.$reviewerStatus;
			else $function = $ercAbbrev.' Secretary';
		} else $function = $ercAbbrev.' '.$reviewerStatus;
		
		return $function;
	}
	
	/**
	 * Get the erc (section in OJS) id of the secretary (if exists)
	 * @return int (or null if no committee)
	 * Added by EL on February 17th 2013
	 */	
	function getSecretaryCommitteeId(){
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
			} 
		}
		return null;		
	}

	/**
	 * Get the erc abbreviations of a reviewer
	 * @return string
	 * Added by EL on February 17th 2013
	 */	
	function getErcAbbrevsOfReviewer(){
		$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$committeeIds = $ercReviewersDao->getCommitteeIdsByUserId($this->getId());
		$ercList = (string) '';
		foreach ($committeeIds as $committeeId){
			if ($committeeId != 0){
				$erc =& $sectionDao->getSection($committeeId);
				if ($ercList == '') $ercList = $erc->getLocalizedAbbrev();
				else $ercList .= ' & '.$erc->getLocalizedAbbrev();
			} else {
				if ($ercList == '') $ercList = 'External';
				else $ercList .= ' & External';			
			}
		}
		return $ercList.' Reviewer';		
	}
}

?>
