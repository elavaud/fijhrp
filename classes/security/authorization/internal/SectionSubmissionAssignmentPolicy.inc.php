<?php
/**
 * @file classes/security/authorization/internal/SectionSubmissionAssignmentPolicy.inc.php
 *
 * Copyright (c) 2000-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SectionSubmissionAssignmentPolicy
 * @ingroup security_authorization_internal
 *
 * @brief Class to control access to journal sections.
 *
 * NB: This policy expects a previously authorized section editor
 * submission in the authorization context.
 */

import('lib.pkp.classes.security.authorization.AuthorizationPolicy');

class SectionSubmissionAssignmentPolicy extends AuthorizationPolicy {
	/** @var PKPRequest */
	var $_request;

	/**
	 * Constructor
	 * @param $request PKPRequest
	 */
	function SectionSubmissionAssignmentPolicy(&$request) {
		parent::AuthorizationPolicy('user.authorization.sectionAssignment');
		$this->_request =& $request;
	}

	//
	// Implement template methods from AuthorizationPolicy
	//
	/**
	 * @see AuthorizationPolicy::effect()
	 */
	function effect() {
		// Get the user
		$user =& $this->_request->getUser();
		if (!is_a($user, 'PKPUser')) return AUTHORIZATION_DENY;

		// Get the section editor submission.
		$sectionEditorSubmission =& $this->getAuthorizedContextObject(ASSOC_TYPE_ARTICLE);
		if (!is_a($sectionEditorSubmission, 'SectionEditorSubmission')) return AUTHORIZATION_DENY;

		// Section editors can only access submissions in their series
		// that they have been explicitly assigned to.
		$sectionEditorsDao =& DAORegistry::getDAO('SectionEditorsDAO');
		$sectionEditors =& $sectionEditorsDao->getEditorsBySectionId($sectionEditorSubmission->getJournalId(), $sectionEditorSubmission->getSectionId());
		$foundAssignment = false;
		foreach ($sectionEditors as $sectionEditor) if ($sectionEditor->getId() == $user->getId()) $foundAssignment = true;

		if ($foundAssignment) {
			return AUTHORIZATION_PERMIT;
		} else {
			return AUTHORIZATION_DENY;
		}
	}
}

?>
