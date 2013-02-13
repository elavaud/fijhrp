<?php

/**
 * @file PeopleHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class PeopleHandler
 * @ingroup pages_manager
 *
 * @brief Handle requests for people management functions.
 */

// $Id$


import('pages.manager.ManagerHandler');

class PeopleHandler extends ManagerHandler {
	/**
	 * Constructor
	 **/
	function PeopleHandler() {
		parent::ManagerHandler();
	}

	/**
	 * Display list of people in the selected role.
	 * @param $args array first parameter is the role ID to display
	 */
	function people($args) {
		$this->validate();
		$this->setupTemplate(true);

		$roleDao =& DAORegistry::getDAO('RoleDAO');

		if (Request::getUserVar('roleSymbolic')!=null) $roleSymbolic = Request::getUserVar('roleSymbolic');
		else $roleSymbolic = isset($args[0])?$args[0]:'all';

		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'name';
		$sortDirection = Request::getUserVar('sortDirection');

		if ($roleSymbolic != 'all' && String::regexp_match_get('/^(\w+)s$/', $roleSymbolic, $matches)) {
			$roleId = $roleDao->getRoleIdFromPath($matches[1]);
			if ($roleId == null) {
				Request::redirect(null, null, null, 'all');
			}
			$roleName = $roleDao->getRoleName($roleId, true);

		} else {
			$roleId = 0;
			$roleName = 'manager.people.allUsers';
		}

		$journal =& Request::getJournal();
		$templateMgr =& TemplateManager::getManager();

		$searchType = null;
		$searchMatch = null;
		$search = Request::getUserVar('search');
		$searchInitial = Request::getUserVar('searchInitial');
		if (!empty($search)) {
			$searchType = Request::getUserVar('searchField');
			$searchMatch = Request::getUserVar('searchMatch');

		} elseif (!empty($searchInitial)) {
			$searchInitial = String::strtoupper($searchInitial);
			$searchType = USER_FIELD_INITIAL;
			$search = $searchInitial;
		}

		$rangeInfo = Handler::getRangeInfo('users');

		if ($roleId) {
			$users =& $roleDao->getUsersByRoleId($roleId, $journal->getId(), $searchType, $search, $searchMatch, $rangeInfo, $sort);
			$templateMgr->assign('roleId', $roleId);
			switch($roleId) {
				case ROLE_ID_JOURNAL_MANAGER:
					$helpTopicId = 'journal.roles.journalManager';
					break;
				case ROLE_ID_EDITOR:
					$helpTopicId = 'journal.roles.editor';
					break;
				case ROLE_ID_SECTION_EDITOR:
					$helpTopicId = 'journal.roles.sectionEditor';
					break;
				//case ROLE_ID_LAYOUT_EDITOR:
				//	$helpTopicId = 'journal.roles.layoutEditor';
				//	break;
				case ROLE_ID_REVIEWER:
					$helpTopicId = 'journal.roles.reviewer';
					//For External Reviewers
					$reviewers =& $roleDao->getUsersByRoleId('4096', $journal->getId(), $searchType, $search, $searchMatch, $rangeInfo, $sort);
					$templateMgr->assign_by_ref('reviewers', $reviewers);
					break;
				/* Commented out by EL on April 4 2012 */
				//case ROLE_ID_COPYEDITOR:
				//	$helpTopicId = 'journal.roles.copyeditor';
				//	break;
				//case ROLE_ID_PROOFREADER:
				//	$helpTopicId = 'journal.roles.proofreader';
				//	break;
				case ROLE_ID_AUTHOR:
					$helpTopicId = 'journal.roles.author';
					break;
				/* Commented out by EL on April 4 2012 */
				//case ROLE_ID_READER:
				//	$helpTopicId = 'journal.roles.reader';
				//	break;
				//case ROLE_ID_SUBSCRIPTION_MANAGER:
				//	$helpTopicId = 'journal.roles.subscriptionManager';
				//	break;
				default:
					$helpTopicId = 'journal.roles.index';
					break;
			}
		} else {
			$users =& $roleDao->getUsersByJournalId($journal->getId(), $searchType, $search, $searchMatch, $rangeInfo, $sort);
			$helpTopicId = 'journal.users.allUsers';
		}

		$templateMgr->assign('currentUrl', Request::url(null, null, 'people', 'all'));
		$templateMgr->assign('roleName', $roleName);
		$templateMgr->assign_by_ref('users', $users);
		$templateMgr->assign_by_ref('thisUser', Request::getUser());
		$templateMgr->assign('isReviewer', $roleId == ROLE_ID_REVIEWER);

		$templateMgr->assign('searchField', $searchType);
		$templateMgr->assign('searchMatch', $searchMatch);
		$templateMgr->assign('search', $search);
		$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));

		$templateMgr->assign_by_ref('roleSettings', $this->retrieveRoleAssignmentPreferences($journal->getId()));

		if ($roleId == ROLE_ID_REVIEWER) {
			$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
			$templateMgr->assign('rateReviewerOnQuality', $journal->getSetting('rateReviewerOnQuality'));
			$templateMgr->assign('qualityRatings', $journal->getSetting('rateReviewerOnQuality') ? $reviewAssignmentDao->getAverageQualityRatings($journal->getId()) : null);
		}
		$templateMgr->assign('helpTopicId', $helpTopicId);
		$fieldOptions = Array(
			USER_FIELD_FIRSTNAME => 'user.firstName',
			USER_FIELD_LASTNAME => 'user.lastName',
			USER_FIELD_USERNAME => 'user.username',
			USER_FIELD_INTERESTS => 'user.interests',
			USER_FIELD_EMAIL => 'user.email'
		);
		if ($roleId == ROLE_ID_REVIEWER) $fieldOptions = array_merge(array(USER_FIELD_INTERESTS => 'user.interests'), $fieldOptions);
		$templateMgr->assign('fieldOptions', $fieldOptions);
		$templateMgr->assign('rolePath', $roleDao->getRolePath($roleId));
		$templateMgr->assign('alphaList', explode(' ', Locale::translate('common.alphaList')));
		$templateMgr->assign('roleSymbolic', $roleSymbolic);
		$templateMgr->assign('sort', $sort);

		$session =& Request::getSession();
		$session->setSessionVar('enrolmentReferrer', Request::getRequestedArgs());

		$templateMgr->display('manager/people/enrollment.tpl');
	}
	


	/**
	 * Search for users to enroll in a specific role.
	 * @param $args array first parameter is the selected role ID
	 * Last update EL on February 13th 2013
	 */
	function enrollSearch($args) {
		$this->validate();

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$journalDao =& DAORegistry::getDAO('JournalDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');
			// For sending the list of ERCs to the template
			// EL on February 12th 2013
			$sectionDao =& DAORegistry::getDAO('SectionDAO');

		$roleId = (int)(isset($args[0])?$args[0]:Request::getUserVar('roleId'));
		$journal =& $journalDao->getJournalByPath(Request::getRequestedJournalPath());

		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'name';
		$sortDirection = Request::getUserVar('sortDirection');

		$templateMgr =& TemplateManager::getManager();

		$this->setupTemplate(true);

		$searchType = null;
		$searchMatch = null;
		$search = Request::getUserVar('search');
		$searchInitial = Request::getUserVar('searchInitial');
		if (!empty($search)) {
			$searchType = Request::getUserVar('searchField');
			$searchMatch = Request::getUserVar('searchMatch');

		} elseif (!empty($searchInitial)) {
			$searchInitial = String::strtoupper($searchInitial);
			$searchType = USER_FIELD_INITIAL;
			$search = $searchInitial;
		}

		$rangeInfo = Handler::getRangeInfo('users');

		$users =& $userDao->getEnrollableUsers($journal->getId(), $searchType, $searchMatch, $search, true, $rangeInfo, $sort, $sortDirection);
		
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
			
			// Send the list of IRBs to the template
			$templateMgr->assign('sections', $sectionDao->getJournalSections($journal->getId()));		
		$templateMgr->assign('searchField', $searchType);
		$templateMgr->assign('searchMatch', $searchMatch);
		$templateMgr->assign('search', $search);
		$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));

		$templateMgr->assign_by_ref('roleSettings', $this->retrieveRoleAssignmentPreferences($journal->getId()));

		$templateMgr->assign('roleId', $roleId);
		$templateMgr->assign('roleName', $roleDao->getRoleName($roleId));
		$fieldOptions = Array(
			USER_FIELD_FIRSTNAME => 'user.firstName',
			USER_FIELD_LASTNAME => 'user.lastName',
			USER_FIELD_USERNAME => 'user.username',
			USER_FIELD_EMAIL => 'user.email'
		);
		if ($roleId == ROLE_ID_REVIEWER) $fieldOptions = array_merge(array(USER_FIELD_INTERESTS => 'user.interests'), $fieldOptions);
		$templateMgr->assign('fieldOptions', $fieldOptions);
		$templateMgr->assign_by_ref('users', $users);
		$templateMgr->assign_by_ref('thisUser', Request::getUser());
		$templateMgr->assign('alphaList', explode(' ', Locale::translate('common.alphaList')));
		$templateMgr->assign('helpTopicId', 'journal.users.index');
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);

		$session =& Request::getSession();
		$referrerUrl = $session->getSessionVar('enrolmentReferrer');
			$templateMgr->assign('enrolmentReferrerUrl', isset($referrerUrl) ? Request::url(null,'manager','people',$referrerUrl) : Request::url(null,'manager'));
			$session->unsetSessionVar('enrolmentReferrer');

		$templateMgr->display('manager/people/searchUsers.tpl');
	}

	/**
	 * Show users with no role.
	 */
	function showNoRole() {
		$this->validate();

		$userDao =& DAORegistry::getDAO('UserDAO');
			
			// For sending the list of ERCs to the template
			// EL on February 13th 2013
			$sectionDao =& DAORegistry::getDAO('SectionDAO');
			$journalDao =& DAORegistry::getDAO('JournalDAO');
			$journal =& $journalDao->getJournalByPath(Request::getRequestedJournalPath());

		$templateMgr =& TemplateManager::getManager();

		parent::setupTemplate(true);

		$rangeInfo = PKPHandler::getRangeInfo('users');

		$users =& $userDao->getUsersWithNoRole(true, $rangeInfo);
		
		// Send the list of IRBs to the template
			$templateMgr->assign('sections', $sectionDao->getJournalSections($journal->getId()));
			
		$templateMgr->assign('omitSearch', true);
		$templateMgr->assign_by_ref('users', $users);
		$templateMgr->assign_by_ref('thisUser', Request::getUser());
		$templateMgr->assign('helpTopicId', 'journal.users.index');
		$templateMgr->display('manager/people/searchUsers.tpl');
	}

	/**
	 * Enroll a user in a role.
	 */
	function enroll($args) {
		$this->validate();
		$roleId = (int)(isset($args[0])?$args[0]:Request::getUserVar('roleId'));

		// Get a list of users to enroll -- either from the
		// submitted array 'users', or the single user ID in
		// 'userId'
		$users = Request::getUserVar('users');
		if (!isset($users) && Request::getUserVar('userId') != null) {
			$users = array(Request::getUserVar('userId'));
		}

		$journalDao =& DAORegistry::getDAO('JournalDAO');
		$journal =& $journalDao->getJournalByPath(Request::getRequestedJournalPath());
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$rolePath = $roleDao->getRolePath($roleId);
		
		//Added by EL on April 24, 2012
		//Management of the ERC Member Status
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		$sectionEditorsDAO =& DAORegistry::getDAO('SectionEditorsDAO');
		$ercMemberStatus =& Request::getUserVar('ercMemberStatus');
		$ethicsCommittee =& Request::getUserVar('ethicsCommittee');
		if ($users != null && is_array($users) && $rolePath == 'reviewer') {
			if($ethicsCommittee == "UHS"){
				if($ercMemberStatus == "ERC, Secretary" ){
					$uhsSecretary =& $userSettingsDao->getUsersBySetting("secretaryStatus", "UHS Secretary");
					$uhsSecretary =& $uhsSecretary->toArray();
					$rolePath = 'sectionEditor';
					$roleId = '512';
					if(count($uhsSecretary)<'3'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'uhsMemberStatus', '4')) == "UHS Member"){
								$userSettingsDao->updateSetting($users[$i], 'uhsMemberStatus', 'Retired', 'string', 0, 0);
								if (($userSettingsDao->getSetting($users[$i], 'niophMemberStatus', '4')) != "NIOPH-ERC, Member"){
									$roleDao->deleteRoleByUserId($users[$i], '4', '4096');
								}
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId(0x00000200);
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'UHS Secretary');
								$roleDao->insertRole($role);
								$sectionEditorsDAO->insertEditor($journal->getId(), '2', $users[$i], '1', '0');
							}
						}						
					}
				}
				elseif($ercMemberStatus == "ERC, Chair"){
					$uhsChair =& $userSettingsDao->getUsersBySetting("uhsMemberStatus", "UHS Chair");
					$uhsChair =& $uhsChair->toArray();
					if(count($uhsChair)<'1'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'secretaryStatus', '4')) == "UHS Secretary"){
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'Retired', 'string', 0, 0);
								$roleDao->deleteRoleByUserId($users[$i], '4', '512');
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId($roleId);
								$roleDao->insertRole($role);
							}
							$userSettingsDao->updateSetting($users[$i], 'uhsMemberStatus', 'UHS Chair');
						}						
					}
				}
				elseif($ercMemberStatus == "ERC, Vice-Chair"){
					$uhsViceChair =& $userSettingsDao->getUsersBySetting("uhsMemberStatus", "UHS Vice-Chair");
					$uhsViceChair =& $uhsViceChair->toArray();
					if(count($uhsViceChair)<'1'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'secretaryStatus', '4')) == "UHS Secretary"){
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'Retired', 'string', 0, 0);
								$roleDao->deleteRoleByUserId($users[$i], '4', '512');
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId($roleId);
								$roleDao->insertRole($role);
							}
							$userSettingsDao->updateSetting($users[$i], 'uhsMemberStatus', 'UHS Vice-Chair');
						}						
					}
				}
				elseif($ercMemberStatus == "ERC, Member"){
					$uhsMember =& $userSettingsDao->getUsersBySetting("uhsMemberStatus", "UHS Member");
					$uhsMember =& $uhsMember->toArray();
					if(count($uhsMember)<'15'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'secretaryStatus', '4')) == "UHS Secretary"){
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'Retired', 'string', 0, 0);
								$roleDao->deleteRoleByUserId($users[$i], '4', '512');
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId($roleId);
								$roleDao->insertRole($role);
							}
							$userSettingsDao->updateSetting($users[$i], 'uhsMemberStatus', 'UHS Member');
						}						
					}
				}
			}
			elseif($ethicsCommittee == "NIOPH"){
				if($ercMemberStatus == "ERC, Secretary" ){
					$niophSecretary =& $userSettingsDao->getUsersBySetting("secretaryStatus", "NIOPH Secretary");
					$niophSecretary =& $niophSecretary->toArray();
					$rolePath = 'sectionEditor';
					$roleId = '512';
					if(count($niophSecretary)<'3'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'niophMemberStatus', '4')) == "NIOPH Member"){
								$userSettingsDao->updateSetting($users[$i], 'niophMemberStatus', 'Retired', 'string', 0, 0);
								if(($userSettingsDao->getSetting($users[$i], 'uhsMemberStatus', '4')) != "UHS Member"){
									$roleDao->deleteRoleByUserId($users[$i], '4', '4096');
								}
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId(0x00000200);
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'NIOPH Secretary');
								$roleDao->insertRole($role);
								$sectionEditorsDAO->insertEditor($journal->getId(), '1', $users[$i], '1', '0');
							}
						}						
					}
				}
				elseif($ercMemberStatus == "ERC, Chair"){
					$niophChair =& $userSettingsDao->getUsersBySetting("niophMemberStatus", "NIOPH Chair");
					$niophChair =& $niophChair->toArray();
					if(count($niophChair)<'1'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'secretaryStatus', '4')) == "NIOPH Secretary"){
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'Retired', 'string', 0, 0);
								$roleDao->deleteRoleByUserId($users[$i], '4', '512');
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId($roleId);
								$roleDao->insertRole($role);
							}
							$userSettingsDao->updateSetting($users[$i], 'niophMemberStatus', 'NIOPH Chair');
						}						
					}
				}
				elseif($ercMemberStatus == "ERC, Vice-Chair"){
					$niophViceChair =& $userSettingsDao->getUsersBySetting("niophMemberStatus", "NIOPH Vice-Chair");
					$niophViceChair =& $niophViceChair->toArray();
					if(count($niophViceChair)<'1'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'secretaryStatus', '4')) == "NIOPH Secretary"){
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'Retired', 'string', 0, 0);
								$roleDao->deleteRoleByUserId($users[$i], '4', '512');
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId($roleId);
								$roleDao->insertRole($role);
							}
							$userSettingsDao->updateSetting($users[$i], 'niophMemberStatus', 'NIOPH Vice-Chair');
						}						
					}
				}
				elseif($ercMemberStatus == "ERC, Member"){
					$niophMember =& $userSettingsDao->getUsersBySetting("niophMemberStatus", "NIOPH Member");
					$niophMember =& $niophMember->toArray();
					if(count($niophMember)<'15'){
						for ($i=0; $i<count($users); $i++) {
							if (($userSettingsDao->getSetting($users[$i], 'secretaryStatus', '4')) == "NIOPH Secretary"){
								$userSettingsDao->updateSetting($users[$i], 'secretaryStatus', 'Retired', 'string', 0, 0);
								$roleDao->deleteRoleByUserId($users[$i], '4', '512');
							}
							if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
								$role = new Role();
								$role->setJournalId($journal->getId());
								$role->setUserId($users[$i]);
								$role->setRoleId($roleId);
								$roleDao->insertRole($role);
							}
							$userSettingsDao->updateSetting($users[$i], 'niophMemberStatus', 'NIOPH Member');
						}						
					}
				}			
			}
			/*
			if($ercMemberStatus == "ERC, Chair"){
				$chair =& $userSettingsDao->getUsersBySetting("ercMemberStatus", "ERC, Chair");
				$chair =& $chair->toArray();
				if(count($chair)=='0'){
					for ($i=0; $i<count($users); $i++) {
						if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
							$role = new Role();
							$role->setJournalId($journal->getId());
							$role->setUserId($users[$i]);
							$role->setRoleId($roleId);
							$userSettingsDao->updateSetting($users[$i], 'ercMemberStatus', 'ERC, Chair');
							$roleDao->insertRole($role);
						}
					}						
				}
			}
			elseif($ercMemberStatus == "ERC, Vice-Chair"){
				$viceChair =& $userSettingsDao->getUsersBySetting("ercMemberStatus", "ERC, Vice-Chair");
				$viceChair =& $viceChair->toArray();
				if(count($viceChair)=='0'){
					for ($i=0; $i<count($users); $i++) {
						if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
							$role = new Role();
							$role->setJournalId($journal->getId());
							$role->setUserId($users[$i]);
							$role->setRoleId($roleId);
							$userSettingsDao->updateSetting($users[$i], 'ercMemberStatus', 'ERC, Vice-Chair');
							$roleDao->insertRole($role);
						}
					}						
				}
			}
			
			else*/
			/*
			elseif($ercMemberStatus == "ERC, Secretary Administrative Assistant"){
				$secretaryAA =& $userSettingsDao->getUsersBySetting("ercMemberStatus", "ERC, Secretary Administrative Assistant");
				$secretaryAA =& $secretaryAA->toArray();
				if(count($secretaryAA)=='0'){
					for ($i=0; $i<count($users); $i++) {
						if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
							$userSettingsDao->updateSetting($users[$i], 'ercMemberStatus', 'ERC, Secretary Administrative Assistant');
						}
					}						
				}
			}
			*/

			/*
			if($ercMemberStatus == "ERC, External Member"){
				$extMember =& $userSettingsDao->getUsersBySetting("ercMemberStatus", "ERC, External Member");
				$extMember =& $extMember->toArray();
				if(count($extMember)<'2'){
					for ($i=0; $i<count($users); $i++) {
						if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
							$role = new Role();
							$role->setJournalId($journal->getId());
							$role->setUserId($users[$i]);
							$role->setRoleId($roleId);
							$userSettingsDao->updateSetting($users[$i], 'ercMemberStatus', 'ERC, External Member');
							$roleDao->insertRole($role);
						}
					}						
				}
			}*/
			
		}
		//End of adding
		// new adding for External Reviewers
		else if ($users != null && is_array($users) && $roleId == 'ExtReviewer'){
			$roleId = '4096';
			$rolePath = 'reviewer';
			$userDAO =& DAORegistry::getDAO('UserDAO');
			for ($i=0; $i<count($users); $i++) {
				if ((!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) && (!$roleDao->roleExists($journal->getId(), $users[$i], '1')) && (!$roleDao->roleExists($journal->getId(), $users[$i], '16')) && (!$roleDao->roleExists($journal->getId(), $users[$i], '256')) && (!$roleDao->roleExists($journal->getId(), $users[$i], '512'))) {
					$userDAO->insertExternalReviewer($users[$i], Locale::getLocale());
					$role = new Role();
					$role->setJournalId($journal->getId());
					$role->setUserId($users[$i]);
					$role->setRoleId($roleId);
					$roleDao->insertRole($role);
				}
			}
		}
		//end
		elseif ($users != null && is_array($users) && $rolePath != '' && $rolePath != 'admin') {
			for ($i=0; $i<count($users); $i++) {
				if (!$roleDao->roleExists($journal->getId(), $users[$i], $roleId)) {
					$role = new Role();
					$role->setJournalId($journal->getId());
					$role->setUserId($users[$i]);
					$role->setRoleId($roleId);
					$roleDao->insertRole($role);
				}
			}
		}

		Request::redirect(null, null, 'people', (empty($rolePath) ? null : $rolePath . 's'));
	}

	/**
	 * Unenroll a user from a role.
	 */
	function unEnroll($args) {
		$roleId = (int) array_shift($args);
		$journalId = (int) Request::getUserVar('journalId');
		$userId = (int) Request::getUserVar('userId');

		$this->validate();

		$journal =& Request::getJournal();
		if ($roleId != ROLE_ID_SITE_ADMIN && (Validation::isSiteAdmin() || $journalId = $journal->getId())) {
			$roleDao =& DAORegistry::getDAO('RoleDAO');
			if ($roleId=='4096'){
				$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
				
				$userSettingsDao->updateSetting($userId, 'niophMemberStatus', 'Retired', 'string', 0, 0);
				$userSettingsDao->updateSetting($userId, 'uhsMemberStatus', 'Retired', 'string', 0, 0);
				//For external Reviewer
				$userDao =& DAORegistry::getDAO('UserDAO');
				$userDao->deleteExternalReviewer($userId, Locale::getLocale());
				//end
				$roleDao->deleteRoleByUserId($userId, $journalId, $roleId);
			}
			if ($roleId=='512'){
				$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
				
				$userSettingsDao->updateSetting($userId, 'secretaryStatus', 'Retired', 'string', 0, 0);
				$sectionEditorsDAO =& DAORegistry::getDAO('SectionEditorsDAO');
				$sectionEditorsDAO->deleteEditorsByUserId($userId);
				$roleDao->deleteRoleByUserId($userId, $journalId, $roleId);
			}			
			else $roleDao->deleteRoleByUserId($userId, $journalId, $roleId);
		}
		Request::redirect(null, null, 'people', $roleDao->getRolePath($roleId) . 's');
	}

	/**
	 * Show form to synchronize user enrollment with another journal.
	 */
	function enrollSyncSelect($args) {
		$this->validate();
		$this->setupTemplate(true);

		$rolePath = isset($args[0]) ? $args[0] : '';
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$roleId = $roleDao->getRoleIdFromPath($rolePath);
		if ($roleId) {
			$roleName = $roleDao->getRoleName($roleId, true);
		} else {
			$rolePath = '';
			$roleName = '';
		}

		$journalDao =& DAORegistry::getDAO('JournalDAO');
		$journalTitles =& $journalDao->getJournalTitles();

		$journal =& Request::getJournal();
		unset($journalTitles[$journal->getId()]);

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('rolePath', $rolePath);
		$templateMgr->assign('roleName', $roleName);
		$templateMgr->assign('journalOptions', $journalTitles);
		$templateMgr->display('manager/people/enrollSync.tpl');
	}

	/**
	 * Synchronize user enrollment with another journal.
	 */
	function enrollSync($args) {
		$this->validate();

		$journal =& Request::getJournal();
		$rolePath = Request::getUserVar('rolePath');
		$syncJournal = Request::getUserVar('syncJournal');

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$roleId = $roleDao->getRoleIdFromPath($rolePath);

		if ((!empty($roleId) || $rolePath == 'all') && !empty($syncJournal)) {
			$roles =& $roleDao->getRolesByJournalId($syncJournal == 'all' ? null : $syncJournal, $roleId);
			while (!$roles->eof()) {
				$role =& $roles->next();
				$role->setJournalId($journal->getId());
				if ($role->getRolePath() != 'admin' && !$roleDao->roleExists($role->getJournalId(), $role->getUserId(), $role->getRoleId())) {
					$roleDao->insertRole($role);
				}
			}
		}

		Request::redirect(null, null, 'people', $roleDao->getRolePath($roleId));
	}

	/**
	 * Display form to create a new user.
	 */
	function createUser($args, &$request) {
		PeopleHandler::editUser($args, $request);
	}

	/**
	 * Get a suggested username, making sure it's not
	 * already used by the system. (Poor-man's AJAX.)
	 */
	function suggestUsername() {
		$this->validate();
		$suggestion = Validation::suggestUsername(
			Request::getUserVar('firstName'),
			Request::getUserVar('lastName')
		);
		echo $suggestion;
	}

	/**
	 * Display form to create/edit a user profile.
	 * @param $args array optional, if set the first parameter is the ID of the user to edit
	 */
	function editUser($args, &$request) {
		$this->validate();
		$this->setupTemplate(true);

		$journal =& Request::getJournal();

		$userId = isset($args[0])?$args[0]:null;

		$templateMgr =& TemplateManager::getManager();

		if ($userId !== null && !Validation::canAdminister($journal->getId(), $userId)) {
			// We don't have administrative rights
			// over this user. Display an error.
			$templateMgr->assign('pageTitle', 'manager.people');
			$templateMgr->assign('errorMsg', 'manager.people.noAdministrativeRights');
			$templateMgr->assign('backLink', Request::url(null, null, 'people', 'all'));
			$templateMgr->assign('backLinkLabel', 'manager.people.allUsers');
			return $templateMgr->display('common/error.tpl');
		}

		import('classes.manager.form.UserManagementForm');

		$templateMgr->assign_by_ref('roleSettings', $this->retrieveRoleAssignmentPreferences($journal->getId()));

		$templateMgr->assign('currentUrl', Request::url(null, null, 'people', 'all'));
		if (checkPhpVersion('5.0.0')) { // WARNING: This form needs $this in constructor
			$userForm = new UserManagementForm($userId);
		} else {
			$userForm =& new UserManagementForm($userId);
		}

		if ($userForm->isLocaleResubmit()) {
			$userForm->readInputData();
		} else {
			$userForm->initData($args, $request);
		}
		$userForm->display();
	}

	/**
	 * Allow the Journal Manager to merge user accounts, including attributed articles etc.
	 */
	function mergeUsers($args) {
		$this->validate();
		$this->setupTemplate(true);

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$userDao =& DAORegistry::getDAO('UserDAO');

		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$templateMgr =& TemplateManager::getManager();

		$oldUserIds = (array) Request::getUserVar('oldUserIds');
		$newUserId = Request::getUserVar('newUserId');

		// Ensure that we have administrative priveleges over the specified user(s).
		$canAdministerAll = true;
		foreach ($oldUserIds as $oldUserId) {
			if (!Validation::canAdminister($journalId, $oldUserId)) $canAdministerAll = false;
		}

		if (
			(!empty($oldUserIds) && !$canAdministerAll) ||
			(!empty($newUserId) && !Validation::canAdminister($journalId, $newUserId))
		) {
			$templateMgr->assign('pageTitle', 'manager.people');
			$templateMgr->assign('errorMsg', 'manager.people.noAdministrativeRights');
			$templateMgr->assign('backLink', Request::url(null, null, 'people', 'all'));
			$templateMgr->assign('backLinkLabel', 'manager.people.allUsers');
			return $templateMgr->display('common/error.tpl');
		}

		if (!empty($oldUserIds) && !empty($newUserId)) {
			import('classes.user.UserAction');
			foreach ($oldUserIds as $oldUserId) {
				UserAction::mergeUsers($oldUserId, $newUserId);
			}
			Request::redirect(null, 'manager');
		}

		// The manager must select one or both IDs.
		if (Request::getUserVar('roleSymbolic')!=null) $roleSymbolic = Request::getUserVar('roleSymbolic');
		else $roleSymbolic = isset($args[0])?$args[0]:'all';

		if ($roleSymbolic != 'all' && String::regexp_match_get('/^(\w+)s$/', $roleSymbolic, $matches)) {
			$roleId = $roleDao->getRoleIdFromPath($matches[1]);
			if ($roleId == null) {
				Request::redirect(null, null, null, 'all');
			}
			$roleName = $roleDao->getRoleName($roleId, true);
		} else {
			$roleId = 0;
			$roleName = 'manager.people.allUsers';
		}

		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'name';
		$sortDirection = Request::getUserVar('sortDirection');

		$searchType = null;
		$searchMatch = null;
		$search = Request::getUserVar('search');
		$searchInitial = Request::getUserVar('searchInitial');
		if (!empty($search)) {
			$searchType = Request::getUserVar('searchField');
			$searchMatch = Request::getUserVar('searchMatch');

		} else if (!empty($searchInitial)) {
			$searchInitial = String::strtoupper($searchInitial);
			$searchType = USER_FIELD_INITIAL;
			$search = $searchInitial;
		}

		$rangeInfo = Handler::getRangeInfo('users');

		if ($roleId) {
			$users =& $roleDao->getUsersByRoleId($roleId, $journalId, $searchType, $search, $searchMatch, $rangeInfo, $sort);
			$templateMgr->assign('roleId', $roleId);
		} else {
			$users =& $roleDao->getUsersByJournalId($journalId, $searchType, $search, $searchMatch, $rangeInfo, $sort);
		}

		$templateMgr->assign_by_ref('roleSettings', $this->retrieveRoleAssignmentPreferences($journal->getId()));

		$templateMgr->assign('currentUrl', Request::url(null, null, 'people', 'all'));
		$templateMgr->assign('helpTopicId', 'journal.managementPages.mergeUsers');
		$templateMgr->assign('roleName', $roleName);
		$templateMgr->assign_by_ref('users', $users);
		$templateMgr->assign_by_ref('thisUser', Request::getUser());
		$templateMgr->assign('isReviewer', $roleId == ROLE_ID_REVIEWER);

		$templateMgr->assign('searchField', $searchType);
		$templateMgr->assign('searchMatch', $searchMatch);
		$templateMgr->assign('search', $search);
		$templateMgr->assign('searchInitial', Request::getUserVar('searchInitial'));

		if ($roleId == ROLE_ID_REVIEWER) {
			$reviewAssignmentDao =& DAORegistry::getDAO('ReviewAssignmentDAO');
			$templateMgr->assign('rateReviewerOnQuality', $journal->getSetting('rateReviewerOnQuality'));
			$templateMgr->assign('qualityRatings', $journal->getSetting('rateReviewerOnQuality') ? $reviewAssignmentDao->getAverageQualityRatings($journalId) : null);
		}
		$templateMgr->assign('fieldOptions', Array(
			USER_FIELD_FIRSTNAME => 'user.firstName',
			USER_FIELD_LASTNAME => 'user.lastName',
			USER_FIELD_USERNAME => 'user.username',
			USER_FIELD_EMAIL => 'user.email',
			USER_FIELD_INTERESTS => 'user.interests'
		));
		$templateMgr->assign('alphaList', explode(' ', Locale::translate('common.alphaList')));
		$templateMgr->assign('oldUserIds', $oldUserIds);
		$templateMgr->assign('rolePath', $roleDao->getRolePath($roleId));
		$templateMgr->assign('roleSymbolic', $roleSymbolic);
		$templateMgr->assign('sort', $sort);
		$templateMgr->assign('sortDirection', $sortDirection);
		$templateMgr->display('manager/people/selectMergeUser.tpl');
	}

	/**
	 * Disable a user's account.
	 * @param $args array the ID of the user to disable
	 */
	function disableUser($args) {
		$this->validate();
		$this->setupTemplate(true);

		$userId = isset($args[0])?$args[0]:Request::getUserVar('userId');
		$user =& Request::getUser();
		$journal =& Request::getJournal();

		if ($userId != null && $userId != $user->getId()) {
			if (!Validation::canAdminister($journal->getId(), $userId)) {
				// We don't have administrative rights
				// over this user. Display an error.
				$templateMgr =& TemplateManager::getManager();
				$templateMgr->assign('pageTitle', 'manager.people');
				$templateMgr->assign('errorMsg', 'manager.people.noAdministrativeRights');
				$templateMgr->assign('backLink', Request::url(null, null, 'people', 'all'));
				$templateMgr->assign('backLinkLabel', 'manager.people.allUsers');
				return $templateMgr->display('common/error.tpl');
			}
			$userDao =& DAORegistry::getDAO('UserDAO');
			$user =& $userDao->getUser($userId);
			if ($user) {
				$user->setDisabled(1);
				$user->setDisabledReason(Request::getUserVar('reason'));
			}
			$userDao->updateObject($user);
		}

		Request::redirect(null, null, 'people', 'all');
	}

	/**
	 * Enable a user's account.
	 * @param $args array the ID of the user to enable
	 */
	function enableUser($args) {
		$this->validate();
		$this->setupTemplate(true);

		$userId = isset($args[0])?$args[0]:null;
		$user =& Request::getUser();

		if ($userId != null && $userId != $user->getId()) {
			$userDao =& DAORegistry::getDAO('UserDAO');
			$user =& $userDao->getUser($userId, true);
			if ($user) {
				$user->setDisabled(0);
			}
			$userDao->updateObject($user);
		}

		Request::redirect(null, null, 'people', 'all');
	}

	/**
	 * Remove a user from all roles for the current journal.
	 * @param $args array the ID of the user to remove
	 */
	function removeUser($args) {
		$this->validate();
		$this->setupTemplate(true);

		$userId = isset($args[0])?$args[0]:null;
		$user =& Request::getUser();
		$journal =& Request::getJournal();

		if ($userId != null && $userId != $user->getId()) {
			$roleDao =& DAORegistry::getDAO('RoleDAO');
			$roleDao->deleteRoleByUserId($userId, $journal->getId());
		}

		Request::redirect(null, null, 'people', 'all');
	}

	/**
	 * Save changes to a user profile.
	 */
	function updateUser() {
		$this->validate();
		$this->setupTemplate(true);

		$journal =& Request::getJournal();
		$userId = Request::getUserVar('userId');

		if (!empty($userId) && !Validation::canAdminister($journal->getId(), $userId)) {
			// We don't have administrative rights
			// over this user. Display an error.
			$templateMgr =& TemplateManager::getManager();
			$templateMgr->assign('pageTitle', 'manager.people');
			$templateMgr->assign('errorMsg', 'manager.people.noAdministrativeRights');
			$templateMgr->assign('backLink', Request::url(null, null, 'people', 'all'));
			$templateMgr->assign('backLinkLabel', 'manager.people.allUsers');
			return $templateMgr->display('common/error.tpl');
		}

		import('classes.manager.form.UserManagementForm');

		if (checkPhpVersion('5.0.0')) { // WARNING: This form needs $this in constructor
			$userForm = new UserManagementForm($userId);
		} else {
			$userForm =& new UserManagementForm($userId);
		}

		$userForm->readInputData();

		if ($userForm->validate()) {
			$userForm->execute();

			if (Request::getUserVar('createAnother')) {
				$templateMgr =& TemplateManager::getManager();
				$templateMgr->assign('currentUrl', Request::url(null, null, 'people', 'all'));
				$templateMgr->assign('userCreated', true);
				unset($userForm);
				if (checkPhpVersion('5.0.0')) { // WARNING: This form needs $this in constructor
					$userForm = new UserManagementForm();
				} else {
					$userForm =& new UserManagementForm();
				}
				$userForm->initData();
				$userForm->display();

			} else {
				if ($source = Request::getUserVar('source')) Request::redirectUrl($source);
				else Request::redirect(null, null, 'people', 'all');
			}
		} else {
			$userForm->display();
		}
	}

	/**
	 * Display a user's profile.
	 * @param $args array first parameter is the ID or username of the user to display
	 */
	function userProfile($args) {
		$this->validate();
		$this->setupTemplate(true);

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('currentUrl', Request::url(null, null, 'people', 'all'));
		$templateMgr->assign('helpTopicId', 'journal.users.index');

		$userDao =& DAORegistry::getDAO('UserDAO');
		$userId = isset($args[0]) ? $args[0] : 0;
		if (is_numeric($userId)) {
			$userId = (int) $userId;
			$user = $userDao->getUser($userId);
		} else {
			$user = $userDao->getUserByUsername($userId);
		}


		if ($user == null) {
			// Non-existent user requested
			$templateMgr->assign('pageTitle', 'manager.people');
			$templateMgr->assign('errorMsg', 'manager.people.invalidUser');
			$templateMgr->assign('backLink', Request::url(null, null, 'people', 'all'));
			$templateMgr->assign('backLinkLabel', 'manager.people.allUsers');
			$templateMgr->display('common/error.tpl');
		} else {
			$site =& Request::getSite();
			$journal =& Request::getJournal();

			$isSiteAdmin = Validation::isSiteAdmin();
			$templateMgr->assign('isSiteAdmin', $isSiteAdmin);
			$roleDao =& DAORegistry::getDAO('RoleDAO');
			$roles =& $roleDao->getRolesByUserId($user->getId(), $isSiteAdmin?null:$journal->getId());
			$templateMgr->assign_by_ref('userRoles', $roles);
			if ($isSiteAdmin) {
				// We'll be displaying all roles, so get ready to display
				// journal names other than the current journal.
				$journalDao =& DAORegistry::getDAO('JournalDAO');
				$journalTitles =& $journalDao->getJournalTitles();
				$templateMgr->assign_by_ref('journalTitles', $journalTitles);
			}

			$countryDao =& DAORegistry::getDAO('CountryDAO');
			$country = null;
			if ($user->getCountry() != '') {
				$country = $countryDao->getCountry($user->getCountry());
			}
			$templateMgr->assign('country', $country);

			$templateMgr->assign_by_ref('user', $user);
			$templateMgr->assign('localeNames', Locale::getAllLocales());
			$templateMgr->display('manager/people/userProfile.tpl');
		}
	}
}

?>
