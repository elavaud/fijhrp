<?php

/**
 * @defgroup sectionEditor_form
 */

/**
 * @file classes/sectionEditor/form/CreateReviewerForm.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class CreateReviewerForm
 * @ingroup sectionEditor_form
 *
 * @brief Form for section editors to create reviewers.
 */

// $Id$


import('lib.pkp.classes.form.Form');

class CreateReviewerForm extends Form {
	/** @var int the section this form is for */
	var $sectionId;

	/**
	 * Constructor.
	 */
	function CreateReviewerForm($sectionId) {
		parent::Form('sectionEditor/createReviewerForm.tpl');
		$this->addCheck(new FormValidatorPost($this));

		$site =& Request::getSite();
		$this->sectionId = $sectionId;

		// Validation checks for this form
		$this->addCheck(new FormValidator($this, 'username', 'required', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidatorCustom($this, 'username', 'required', 'user.register.form.usernameExists', array(DAORegistry::getDAO('UserDAO'), 'userExistsByUsername'), array(null, true), true));
		$this->addCheck(new FormValidatorAlphaNum($this, 'username', 'required', 'user.register.form.usernameAlphaNumeric'));
		$this->addCheck(new FormValidator($this, 'firstName', 'required', 'user.profile.form.firstNameRequired'));
		$this->addCheck(new FormValidator($this, 'lastName', 'required', 'user.profile.form.lastNameRequired'));
		$this->addCheck(new FormValidatorUrl($this, 'userUrl', 'optional', 'user.profile.form.urlInvalid'));
		$this->addCheck(new FormValidatorEmail($this, 'email', 'required', 'user.profile.form.emailRequired'));
		$this->addCheck(new FormValidatorCustom($this, 'email', 'required', 'user.register.form.emailExists', array(DAORegistry::getDAO('UserDAO'), 'userExistsByEmail'), array(null, true), true));
		$this->addCheck(new FormValidator($this, 'ercStatus', 'required', 'user.profile.form.ercStatusRequired'));
		$this->addCheck(new FormValidatorCustom($this, 'ercStatus', 'required', 'user.register.form.tooManyMembers', create_function('$ercStatus, $sectionId', ' $journal =& Request::getJournal(); if ($ercStatus == "Secretary"){ $sectionEditorsDao =& DAORegistry::getDAO(\'SectionEditorsDAO\'); $secretaries =& $sectionEditorsDao->getEditorsBySectionId($journal->getId(), $sectionId); if (count($secretaries)>4) return true; else return false;} else { $ercReviewersDao =& DAORegistry::getDAO(\'ErcReviewersDAO\'); if ($ercStatus == "Chair") { $chairs =& $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $sectionId, 1); if (count($chairs) != 0) return true; else return false;} elseif ($ercStatus == "Vice-Chair"){ $vicechairs =& $ercReviewersDao->getReviewersBySectionIdByStatus($journal->getId(), $sectionId, 2); if (count($vicechairs) != 0) return true; else return false;} elseif ($ercStatus == "Member"){ $members =& $ercReviewersDao->getReviewersBySectionId($journal->getId(), $sectionId); if (count($members) > 19) return true; else return false;} return false;}'), array($this->sectionId), true));

		// Provide a default for sendNotify: If we're using one-click
		// reviewer access or email-based reviews, it's not necessary;
		// otherwise, it should default to on.
		$journal =& Request::getJournal();
		$reviewerAccessKeysEnabled = $journal->getSetting('reviewerAccessKeysEnabled');
		$isEmailBasedReview = $journal->getSetting('mailSubmissionsToReviewers')==1?true:false;
		$this->setData('sendNotify', ($reviewerAccessKeysEnabled || $isEmailBasedReview)?false:true);
	}

	function getLocaleFieldNames() {
		return array('biography', 'signature');
	}

	/**
	 * Display the form.
	 */
	function display(&$args, &$request) {
		$templateMgr =& TemplateManager::getManager();
		$site =& Request::getSite();
		$templateMgr->assign('sectionId', $this->sectionId);
		
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$templateMgr->assign_by_ref('erc', $sectionDao->getSection($this->sectionId));
		
		$templateMgr->assign('availableLocales', $site->getSupportedLocaleNames());
		$userDao =& DAORegistry::getDAO('UserDAO');
		$templateMgr->assign('genderOptions', $userDao->getGenderOptions());

		$countryDao =& DAORegistry::getDAO('CountryDAO');
		$countries =& $countryDao->getCountries();
		$templateMgr->assign_by_ref('countries', $countries);

		$interestDao =& DAORegistry::getDAO('InterestDAO');
		// Get all available interests to populate the autocomplete with
		if ($interestDao->getAllUniqueInterests()) {
			$existingInterests = $interestDao->getAllUniqueInterests();
		} else $existingInterests = null;
		$templateMgr->assign('existingInterests', $existingInterests);

		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'salutation',
			'firstName',
			'middleName',
			'lastName',
			'gender',
			'affiliation',
			'email',
			'phone',
			'fax',
			'mailingAddress',
			'country',
			'interestsKeywords',
			'sendNotify',
			'username',
			'ercStatus'
		));

		if ($this->getData('userLocales') == null || !is_array($this->getData('userLocales'))) {
			$this->setData('userLocales', array());
		}

		if ($this->getData('username') != null) {
			// Usernames must be lowercase
			$this->setData('username', strtolower($this->getData('username')));
		}
	}

	/**
	 * Register a new user.
	 * @return userId int
	 * Last modified: EL on February 22th 2013
	 */
	function execute() {
		$userDao =& DAORegistry::getDAO('UserDAO');
		$user = new User();

		$user->setSalutation($this->getData('salutation'));
		$user->setFirstName($this->getData('firstName'));
		$user->setMiddleName($this->getData('middleName'));
		$user->setLastName($this->getData('lastName'));
		$user->setGender($this->getData('gender'));
		$user->setInitials($this->getData('initials'));
		$user->setAffiliation($this->getData('affiliation'), null); // Localized
		$user->setEmail($this->getData('email'));
		$user->setUrl($this->getData('userUrl'));
		$user->setPhone($this->getData('phone'));
		$user->setFax($this->getData('fax'));
		$user->setMailingAddress($this->getData('mailingAddress'));
		$user->setCountry($this->getData('country'));
		$user->setBiography($this->getData('biography'), null); // Localized
		$user->setGossip($this->getData('gossip'), null); // Localized
		$user->setMustChangePassword($this->getData('mustChangePassword') ? 1 : 0);

		$authDao =& DAORegistry::getDAO('AuthSourceDAO');
		$auth =& $authDao->getDefaultPlugin();
		$user->setAuthId($auth?$auth->getAuthId():0);

		$site =& Request::getSite();
		$availableLocales = $site->getSupportedLocales();
		$locales = array();
		foreach ($this->getData('userLocales') as $locale) {
			if (Locale::isLocaleValid($locale) && in_array($locale, $availableLocales)) {
				array_push($locales, $locale);
			}
		}
		$user->setLocales($locales);

		$user->setUsername($this->getData('username'));
		$password = Validation::generatePassword();
		$sendNotify = $this->getData('sendNotify');
		if (isset($auth)) {
			$user->setPassword($password);
			// FIXME Check result and handle failures
			$auth->doCreateUser($user);
			$user->setAuthId($auth->authId);
			$user->setPassword(Validation::encryptCredentials($user->getId(), Validation::generatePassword())); // Used for PW reset hash only
		} else {
			$user->setPassword(Validation::encryptCredentials($this->getData('username'), $password));
		}

		$user->setDateRegistered(Core::getCurrentDate());
		
		$userId = $userDao->insertUser($user);

		// Add reviewing interests to interests table
		$interestDao =& DAORegistry::getDAO('InterestDAO');
		$interests = is_array(Request::getUserVar('interestsKeywords')) ? Request::getUserVar('interestsKeywords') : array();
		if (is_array($interests)){
			$interests = array_map('urldecode', $interests); // The interests are coming in encoded -- Decode them for DB storage
			$interestTextOnly = Request::getUserVar('interests');
			if(!empty($interestsTextOnly)) {
				// If JS is disabled, this will be the input to read
				$interestsTextOnly = explode(",", $interestTextOnly);
			} else $interestsTextOnly = null;
			if ($interestsTextOnly && !isset($interests)) {
				$interests = $interestsTextOnly;
			} elseif (isset($interests) && !is_array($interests)) {
				$interests = array($interests);
			}
			$interestDao->insertInterests($interests, $user->getId(), true);
		}
		$interestDao->insertInterests($interests, $user->getId(), true);

		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$journal =& Request::getJournal();

		$ercStatus = $this->getData('ercStatus');
		if ($ercStatus == "Secretary") {
			$role = new Role();
			$role->setJournalId($journal->getId());
			$role->setUserId($userId);
			$role->setRoleId(ROLE_ID_SECTION_EDITOR);
			$roleDao->insertRole($role);

			$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
			$sectionEditorsDao->insertEditor($journal->getId(), $this->sectionId, $userId, 1, 1);
		} elseif ($ercStatus == "Chair" || $ercStatus == "Vice-Chair" || $ercStatus == "Member") {
			$role = new Role();
			$role->setJournalId($journal->getId());
			$role->setUserId($userId);
			$role->setRoleId(ROLE_ID_REVIEWER);
			$roleDao->insertRole($role);
			
			$ercReviewersDao =& DAORegistry::getDAO('ErcReviewersDAO');
			if ($ercStatus == "Chair") $ercReviewersDao->insertReviewer($journal->getId(), $this->sectionId, $userId, 1);
			elseif ($ercStatus == "Vice-Chair") $ercReviewersDao->insertReviewer($journal->getId(), $this->sectionId, $userId, 2);
			if ($ercStatus == "Member") $ercReviewersDao->insertReviewer($journal->getId(), $this->sectionId, $userId, 3);
		}

		if ($sendNotify) {
			$sectionDao =& DAORegistry::getDAO('SectionDAO');
			$erc =& $sectionDao->getSection($this->sectionId);
			$thisUser =& Request::getUser();
			// Send welcome email to user
			import('classes.mail.MailTemplate');
			$mail = new MailTemplate('COMMITTEE_REGISTER');
			$mail->setFrom($journal->getSetting('contactEmail'), $journal->getSetting('contactName'));
			$mail->assignParams(array(
				'username' => $this->getData('username'), 
				'password' => $password, 
				'userFullName' => $user->getFullName(), 
				'ercStatus' => $ercStatus, 
				'ercTitle' => $erc->getLocalizedTitle(),
				'editProfile' => Request::url(null, 'user', 'profile'),
				'secretaryFullName' => $thisUser->getFullName(),
				'secretaryFunctions' => $thisUser->getErcFunction($this->sectionId)	
			));
			$mail->addRecipient($user->getEmail(), $user->getFullName());
			$mail->send();
		}

		return $userId;
	}
}

?>
