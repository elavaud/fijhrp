<?php

/**@file pages/sectionEditor/MeetingMinutesHandler.inc.php
 * Added by Gay Figueroa

 * Last Update: 5/14/2011
 * @class MeetingMinutesHandler
 * @ingroup pages_sectionEditor
 *
 * @brief Handle meeting minutes form submission and related requests
 *
 */

import('classes.handler.Handler');

class MeetingMinutesHandler extends Handler {

	/**
	 * Constructor
	 **/
	function MeetingMinutesHandler() {
		parent::Handler();
		
		$this->addCheck(new HandlerValidatorJournal($this));
	}


	/**
	 * Handle submission of meeting minutes for a submission/proposal
	 **/
	function submit($args, $request) {
		$articleId = isset($args[0]) ? (int) $args[0] : 0;
		$this->validate($articleId, SECTION_EDITOR_ACCESS_REVIEW);
		$journal =& Request::getJournal();
		//check kung kelan naseset ung submission variable ng class na to
		$submission =& $this->submission;
		//TODO: create function setupTemplate
		$this->setupTemplate(true, $articleId);
		
		//if !isset(args[1]), this is a newly submitted form
		$meetingMinutesId = isset($args[1]) ? (int) $args[1] : 0;
	}
}


?>
