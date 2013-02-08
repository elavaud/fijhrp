<?php

/**
 * @defgroup user
 */

/**
 * @file classes/user/PKPUser.inc.php
 *
 * Copyright (c) 2000-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class PKPUser
 * @ingroup user
 * @see UserDAO
 *
 * @brief Basic class describing users existing in the system.
 */


class PKPUser extends DataObject {

	function PKPUser() {
		parent::DataObject();
	}

	//
	// Get/set methods
	//

	/**
	 * Get the ID of the user. DEPRECATED in favour of getId.
	 * @return int
	 */
	function getUserId() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getId();
	}

	/**
	 * Set the ID of the user. DEPRECATED in favour of setId.
	 * @param $userId int
	 */
	function setUserId($userId) {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->setId($userId);
	}

	/**
	 * Get username.
	 * @return string
	 */
	function getUsername() {
		return $this->getData('username');
	}

	/**
	 * Set username.
	 * @param $username string
	 */
	function setUsername($username) {
		return $this->setData('username', $username);
	}

	/**
	 * Get implicit auth ID string.
	 * @return String
	 */
	function getAuthStr() {
		return $this->getData('authStr');
	}

	/**
	 * Set Shib ID string for this user.
	 * @param $authStr string
	 */
	function setAuthStr($authStr) {
		return $this->setData('authStr', $authStr);
	}

	/**
	 * Get localized user signature.
	 */
	function getLocalizedSignature() {
		return $this->getLocalizedData('signature');
	}

	function getUserSignature() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedSignature();
	}

	/**
	 * Get email signature.
	 * @param $locale string
	 * @return string
	 */
	function getSignature($locale) {
		return $this->getData('signature', $locale);
	}

	/**
	 * Set signature.
	 * @param $signature string
	 * @param $locale string
	 */
	function setSignature($signature, $locale) {
		return $this->setData('signature', $signature, $locale);
	}

	/**
	 * Get password (encrypted).
	 * @return string
	 */
	function getPassword() {
		return $this->getData('password');
	}

	/**
	 * Set password (assumed to be already encrypted).
	 * @param $password string
	 */
	function setPassword($password) {
		return $this->setData('password', $password);
	}

	/**
	 * Get first name.
	 * @return string
	 */
	function getFirstName() {
		return $this->getData('firstName');
	}

	/**
	 * Set first name.
	 * @param $firstName string
	 */
	function setFirstName($firstName)
	{
		return $this->setData('firstName', $firstName);
	}

	/**
	 * Get middle name.
	 * @return string
	 */
	function getMiddleName() {
		return $this->getData('middleName');
	}

	/**
	 * Set middle name.
	 * @param $middleName string
	 */
	function setMiddleName($middleName) {
		return $this->setData('middleName', $middleName);
	}

	/**
	 * Get initials.
	 * @return string
	 */
	function getInitials() {
		return $this->getData('initials');
	}

	/**
	 * Set initials.
	 * @param $initials string
	 */
	function setInitials($initials) {
		return $this->setData('initials', $initials);
	}

	/**
	 * Get last name.
	 * @return string
	 */
	function getLastName() {
		return $this->getData('lastName');
	}

	/**
	 * Set last name.
	 * @param $lastName string
	 */
	function setLastName($lastName) {
		return $this->setData('lastName', $lastName);
	}

	/**
	 * Get user salutation.
	 * @return string
	 */
	function getSalutation() {
		return $this->getData('salutation');
	}

	/**
	 * Set user salutation.
	 * @param $salutation string
	 */
	function setSalutation($salutation) {
		return $this->setData('salutation', $salutation);
	}

	/**
	 * Get user gender.
	 * @return string
	 */
	function getGender() {
		return $this->getData('gender');
	}

	/**
	 * Set user gender.
	 * @param $gender string
	 */
	function setGender($gender) {
		return $this->setData('gender', $gender);
	}

	/**
	 * Get affiliation (position, institution, etc.).
	 * @param $locale string
	 * @return string
	 */
	function getAffiliation($locale) {
		return $this->getData('affiliation', $locale);
	}
	
	/**
	 * Set affiliation.
	 * @param $affiliation string
	 * @param $locale string
	 */
	function setAffiliation($affiliation, $locale) {
		return $this->setData('affiliation', $affiliation, $locale);
	}
	
	/**
	 * Get localized user affiliation.
	 */
	function getLocalizedAffiliation() {
		return $this->getLocalizedData('affiliation');
	}

	/**
	 * Get email address.
	 * @return string
	 */
	function getEmail() {
		return $this->getData('email');
	}

	/**
	 * Set email address.
	 * @param $email string
	 */
	function setEmail($email) {
		return $this->setData('email', $email);
	}

	/**
	 * Get URL.
	 * @return string
	 */
	function getUrl() {
		return $this->getData('url');
	}

	/**
	 * Set URL.
	 * @param $url string
	 */
	function setUrl($url) {
		return $this->setData('url', $url);
	}

	/**
	 * Get phone number.
	 * @return string
	 */
	function getPhone() {
		return $this->getData('phone');
	}

	/**
	 * Set phone number.
	 * @param $phone string
	 */
	function setPhone($phone) {
		return $this->setData('phone', $phone);
	}

	/**
	 * Get fax number.
	 * @return string
	 */
	function getFax() {
		return $this->getData('fax');
	}

	/**
	 * Set fax number.
	 * @param $fax string
	 */
	function setFax($fax) {
		return $this->setData('fax', $fax);
	}

	/**
	 * Get mailing address.
	 * @return string
	 */
	function getMailingAddress() {
		return $this->getData('mailingAddress');
	}

	/**
	 * Set mailing address.
	 * @param $mailingAddress string
	 */
	function setMailingAddress($mailingAddress) {
		return $this->setData('mailingAddress', $mailingAddress);
	}

	/**
	 * Get country.
	 * @return string
	 */
	function getCountry() {
		return $this->getData('country');
	}

	/**
	 * Set country.
	 * @param $country string
	 */
	function setCountry($country) {
		return $this->setData('country', $country);
	}

	/**
	 * Get localized user biography.
	 */
	function getLocalizedBiography() {
		return $this->getLocalizedData('biography');
	}

	function getUserBiography() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getLocalizedBiography();
	}

	/**
	 * Get user biography.
	 * @param $locale string
	 * @return string
	 */
	function getBiography($locale) {
		return $this->getData('biography', $locale);
	}

	/**
	 * Set user biography.
	 * @param $biography string
	 * @param $locale string
	 */
	function setBiography($biography, $locale) {
		return $this->setData('biography', $biography, $locale);
	}

	function getUserInterests() {
		if (Config::getVar('debug', 'deprecation_warnings')) trigger_error('Deprecated function.');
		return $this->getInterests();
	}

	/**
	 * Get user reviewing interests.
	 * @param $locale string
	 * @return string
	 */
	function getInterests() {
		$interestDao =& DAORegistry::getDAO('InterestDAO');
		return implode(", ", $interestDao->getInterests($this->getId()));
	}

	/**
	 * Set user reviewing interests.
	 * @param $interests string
	 * @param $locale string
	 */
	function setInterests($interests) {
		$interestDao =& DAORegistry::getDAO('InterestDAO');
		$interestDao->insertInterests(explode(",", $interests), $this->getId(), true);
	}

	/**
	 * Get localized user gossip.
	 */
	function getLocalizedGossip() {
		return $this->getLocalizedData('gossip');
	}

	/**
	 * Get user gossip.
	 * @param $locale string
	 * @return string
	 */
	function getGossip($locale) {
		return $this->getData('gossip', $locale);
	}

	/**
	 * Set user gossip.
	 * @param $gossip string
	 * @param $locale string
	 */
	function setGossip($gossip, $locale) {
		return $this->setData('gossip', $gossip, $locale);
	}

	/**
	 * Get user's working languages.
	 * @return array
	 */
	function getLocales() {
		$locales = $this->getData('locales');
		return isset($locales) ? $locales : array();
	}

	/**
	 * Set user's working languages.
	 * @param $locales array
	 */
	function setLocales($locales) {
		return $this->setData('locales', $locales);
	}

	/**
	 * Get date user last sent an email.
	 * @return datestamp (YYYY-MM-DD HH:MM:SS)
	 */
	function getDateLastEmail() {
		return $this->getData('dateLastEmail');
	}

	/**
	 * Set date user last sent an email.
	 * @param $dateLastEmail datestamp (YYYY-MM-DD HH:MM:SS)
	 */
	function setDateLastEmail($dateLastEmail) {
		return $this->setData('dateLastEmail', $dateLastEmail);
	}

	/**
	 * Get date user registered with the site.
	 * @return datestamp (YYYY-MM-DD HH:MM:SS)
	 */
	function getDateRegistered() {
		return $this->getData('dateRegistered');
	}

	/**
	 * Set date user registered with the site.
	 * @param $dateRegistered datestamp (YYYY-MM-DD HH:MM:SS)
	 */
	function setDateRegistered($dateRegistered) {
		return $this->setData('dateRegistered', $dateRegistered);
	}

	/**
	 * Get date user email was validated with the site.
	 * @return datestamp (YYYY-MM-DD HH:MM:SS)
	 */
	function getDateValidated() {
		return $this->getData('dateValidated');
	}

	/**
	 * Set date user email was validated with the site.
	 * @param $dateValidated datestamp (YYYY-MM-DD HH:MM:SS)
	 */
	function setDateValidated($dateValidated) {
		return $this->setData('dateValidated', $dateValidated);
	}

	/**
	 * Get date user last logged in to the site.
	 * @return datestamp
	 */
	function getDateLastLogin() {
		return $this->getData('dateLastLogin');
	}

	/**
	 * Set date user last logged in to the site.
	 * @param $dateLastLogin datestamp
	 */
	function setDateLastLogin($dateLastLogin) {
		return $this->setData('dateLastLogin', $dateLastLogin);
	}

	/**
	 * Check if user must change their password on their next login.
	 * @return boolean
	 */
	function getMustChangePassword() {
		return $this->getData('mustChangePassword');
	}

	/**
	 * Set whether or not user must change their password on their next login.
	 * @param $mustChangePassword boolean
	 */
	function setMustChangePassword($mustChangePassword) {
		return $this->setData('mustChangePassword', $mustChangePassword);
	}

	/**
	 * Check if user is disabled.
	 * @return boolean
	 */
	function getDisabled() {
		return $this->getData('disabled');
	}

	/**
	 * Set whether or not user is disabled.
	 * @param $disabled boolean
	 */
	function setDisabled($disabled) {
		return $this->setData('disabled', $disabled);
	}

	/**
	 * Get the reason the user was disabled.
	 * @return string
	 */
	function getDisabledReason() {
		return $this->getData('disabled_reason');
	}

	/**
	 * Set the reason the user is disabled.
	 * @param $reasonDisabled string
	 */
	function setDisabledReason($reasonDisabled) {
		return $this->setData('disabled_reason', $reasonDisabled);
	}

	/**
	 * Get ID of authentication source for this user.
	 * @return int
	 */
	function getAuthId() {
		return $this->getData('authId');
	}

	/**
	 * Set ID of authentication source for this user.
	 * @param $authId int
	 */
	function setAuthId($authId) {
		return $this->setData('authId', $authId);
	}

	/**
	 * Get the user's complete name.
	 * Includes first name, middle name (if applicable), and last name.
	 * @param $lastFirst boolean return in "LastName, FirstName" format
	 * @return string
	 */
	function getFullName($lastFirst = false) {
		$salutation = $this->getData('salutation');
		$firstName = $this->getData('firstName');
		$middleName = $this->getData('middleName');
		$lastName = $this->getData('lastName');
		if ($lastFirst) {
			return "$lastName, " . ($salutation != ''?"$salutation ":'') . "$firstName" . ($middleName != ''?" $middleName":'');
		} else {
			return ($salutation != ''?"$salutation ":'') . "$firstName " . ($middleName != ''?"$middleName ":'') . $lastName;
		}
	}
	
	function getFunctions(){
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		$roles =& $roleDao->getRolesByUserId($this->getId(), '4');
		$functions;
		foreach ($roles as $role){
			$roleId =& $role->getRoleId();
			if ($roleId == '512'){
				if($userSettingsDao->getSetting($this->getId(), 'secretaryStatus', '4') && ($userSettingsDao->getSetting($this->getId(), 'secretaryStatus', '4') != "Retired")){
					if ($functions != null){
						$functions = $functions . ' & ' . $userSettingsDao->getSetting($this->getId(), 'secretaryStatus', '4');
					}
					else {
						$functions = $userSettingsDao->getSetting($this->getId(), 'secretaryStatus', '4');
					}
				}
			}
			if ($roleId == '4096'){
				if ($userSettingsDao->getSetting($this->getId(), 'uhsMemberStatus', '4') && ($userSettingsDao->getSetting($this->getId(), 'uhsMemberStatus', '4') != "Retired")){
					if ($functions != null){
						$functions = $functions . ' & ' . $userSettingsDao->getSetting($this->getId(), 'uhsMemberStatus', '4'); 
					}else {
						$functions = $userSettingsDao->getSetting($this->getId(), 'uhsMemberStatus', '4'); 
					}
				}
				if ($userSettingsDao->getSetting($this->getId(), 'niophMemberStatus', '4') && ($userSettingsDao->getSetting($this->getId(), 'niophMemberStatus', '4') != "Retired")){
					if ($functions != null){
						$functions = $functions . ' & ' . $userSettingsDao->getSetting($this->getId(), 'niophMemberStatus', '4'); 
					}else {
						$functions = $userSettingsDao->getSetting($this->getId(), 'niophMemberStatus', '4'); 
					}
				}
				if ($this->isLocalizedExternalReviewer() == "Yes"){
					if ($functions != null){
						$functions = $functions . ' & External Reviewer'; 
					}else {
						$functions = 'External Reviewer'; 
					}
				}	
			}
			if ($roleId == '65536'){
				if ($functions != null){
					$functions = $functions . ' & ' . 'Investigator';
				}
				else {
					$functions = 'Investigator';
				}
			}
			if ($roleId == '256'){
				if ($functions != null){
					$functions = $functions . ' & ' . 'Coordinator';
				}
				else {
					$functions = 'Coordinator';
				}
			}
		}
		return $functions;
	}
	
	function getSecretaryEthicsCommittee(){
		$ethicsCommittee;
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		if (($userSettingsDao->getSetting($this->getId(), 'secretaryStatus', '4')) == "UHS Secretary"){
			$ethicsCommittee = 'UHS';
		}
		if (($userSettingsDao->getSetting($this->getId(), 'secretaryStatus', '4')) == "NIOPH Secretary"){
			$ethicsCommittee = 'NIOPH';
		}
		return $ethicsCommittee;
	}
	
	function isNiophMember(){
		$niophMember = false;
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		$userStatus = $userSettingsDao->getSetting($this->getId(), 'niophMemberStatus', '4');
		if ($userStatus == "NIOPH Chair" || $userStatus == "NIOPH Vice-Chair" || $userStatus == "NIOPH Member"){
			$niophMember = true;
		}
		return $niophMember;
	}
	
	function isUhsMember(){
		$uhsMember = false;
		$userSettingsDao =& DAORegistry::getDAO('UserSettingsDAO');
		$userStatus = $userSettingsDao->getSetting($this->getId(), 'uhsMemberStatus', '4');
		if ($userStatus == "UHS Chair" || $userStatus == "UHS Vice-Chair" || $userStatus == "UHS Member"){
			$uhsMember = true;
		}
		return $uhsMember;
	}
	
	
	function getContactSignature() {
		$signature = $this->getFullName();
		if ($a = $this->getLocalizedAffiliation()) $signature .= "\n" . $a;
		if ($p = $this->getPhone()) $signature .= "\n" . Locale::translate('user.phone') . ' ' . $p;
		if ($f = $this->getFax()) $signature .= "\n" . Locale::translate('user.fax') . ' ' . $f;
		$signature .= "\n" . $this->getEmail();
		return $signature;
	}
	/*
	 * Getters and setters for additional user settings: health and wpro affiliation
	 * Added by aglet
	 * Last Update: 6/20/2011
	 */
	
	/**
	 * Get localized health affiliation
	 */
	function getLocalizedHealthAffiliation() {
		return $this->getLocalizedData('healthAffiliation');
	}

	/**
	 * Get user health affiliation.
	 * @param $locale string
	 * @return string
	 */
	function getHealthAffiliation($locale) {
		return $this->getData('healthAffiliation', $locale);
	}

	/**
	 * Set user health affiliation.
	 * @param $healthAffiliation string
	 * @param $locale string
	 */
	function setHealthAffiliation($healthAffiliation, $locale) {
		return $this->setData('healthAffiliation', $healthAffiliation, $locale);
	}


			//Added by EL on May 8, 2012

			/**
	 		* Get localized health affiliation
	 		*/
			function getLocalizedFieldOfActivity() {
				return $this->getLocalizedData('fieldOfActivity');
			}

			/**
	 		* Get user field of Activity.
	 		* @param $locale string
	 		* @return string
	 		*/
			function getFieldOfActivity($locale) {
				return $this->getData('fieldOfActivity', $locale);
			}

			/**
	 		* Set user field of activity.
	 		* @param $fieldOfActivity string
	 		* @param $locale string
	 		*/
			function setFieldOfActivity($fieldOfActivity, $locale) {
				return $this->setData('fieldOfActivity', $fieldOfActivity, $locale);
			}
			
	
	/**
	 * Get localized wpro affiliation
	 */
	function getLocalizedWproAffiliation() {
		return $this->getLocalizedData('wproAffiliation');
	}

	/**
	 * Get user wpro affiliation.
	 * @param $locale string
	 * @return string
	 */
	function getWproAffiliation($locale) {
		return $this->getData('wproAffiliation', $locale);
	}

	/**
	 * Set user wpro affiliation.
	 * @param $wproAffiliation string
	 * @param $locale string
	 */
	function setWproAffiliation($wproAffiliation, $locale) {
		return $this->setData('wproAffiliation', $wproAffiliation, $locale);
	}

	/**
	 * Set user as external reviewer
	 * @param $isExternalReviewer string
	 * @param @locale string
	 */
	function setExternalReviewer($externalReviewer, $locale) {		
		return $this->setData('externalReviewer', $externalReviewer, $locale);
	}
	
	/**
	 * Get externalReviewer indicator
	 */
	function isLocalizedExternalReviewer() {
		return $this->getLocalizedData('externalReviewer');
	}	
	
	/**
	 * Get externalReviewer indicator
	 */
	function isExternalReviewer($locale) {
		return $this->getData('externalReviewer', $locale);
	}
	
	
	/**
	 * Get ERC Member Status.
	 * @param $locale string
	 * @return string
	 */
	function getErcMemberStatus($locale){
		return $this->getData('ercMemberStatus', $locale);
	}
	/**
	 * Set ERC Member Status.
	 * @param $ercMemberStatus string
	 * @param $locale string
	 */
	function setErcMemberStatus ($ercMemberStatus, $locale){
			return $this->setData('ercMemberStatus', $ercMemberStatus, $locale);
	}
	/**
	 * Get localized ERC Member Status.
	 */
	function getLocalizedErcMemberStatus() {
		return $this->getLocalizedData('ercMemberStatus');
	}
	
}

?>
