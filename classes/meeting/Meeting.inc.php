<?php

define ('MINUTES_STATUS_COMPLETE', 128);
define ('MINUTES_STATUS_INCOMPLETE', 256);
define ('MINUTES_STATUS_ATTENDANCE', 1);
define ('MINUTES_STATUS_INITIAL_REVIEWS', 2);
define ('MINUTES_STATUS_REREVIEWS', 4);
define ('MINUTES_STATUS_CONTINUING_REVIEWS', 8);
define ('MINUTES_STATUS_AMENDMENTS', 16);
define ('MINUTES_STATUS_ADVERSE_EVENTS', 32);
define ('MINUTES_STATUS_INFORMATION_ITEMS', 64);
define ('STATUS_NEW', 4);
define ('STATUS_FINAL', 1);
define ('STATUS_RESCHEDULED', 2);
define ('STATUS_CANCELLED', 3);
define ('STATUS_DONE', 5);
define ('MEETING_REPLY_ATTENDING', 1);
define ('MEETING_REPLY_NOT_ATTENDING', 2);
define ('MINUTES_REVIEW_OTHER_DISCUSSIONS', 0);
define ('MINUTES_REVIEW_SCIENTIFIC_DESIGN', 1);
define ('MINUTES_REVIEW_RISKS', 2);
define ('MINUTES_REVIEW_BENEFITS', 3);
define ('MINUTES_REVIEW_POPULATION_SELECTION', 4);
define ('MINUTES_REVIEW_SAFEGUARDS', 5);
define ('MINUTES_REVIEW_MINIMIZATIONS', 6);
define ('MINUTES_REVIEW_CONFIDENTIALITY', 7);
define ('MINUTES_REVIEW_CONSENT_DOCUMENT', 8);
define ('MINUTES_REVIEW_OTHER_CONSIDERATIONS', 9);
define ('MINUTES_REVIEW_LOCAL_IRB', 10);

/**
 * Last update on February 2013
 * EL
**/

class Meeting extends DataObject {

	function Meeting() {
		parent::DataObject();
	}

	function setId($meetingId) {
		$this->setData('meetingId', $meetingId);
	}

	function getId() {
		return $this->getData('meetingId');
	}

	function setDate($meetingDate) {
		$this->setData('meetingDate', $meetingDate);
	}

	function getDate() {
		return $this->getData('meetingDate');
	}

		/*
		 * New functions for the length, location and if the investigator(s) is(are) invited
		 * EL on February 25th 2013
		 */
		function setLength($length) {
			$this->setData('length', $length);
		}

		function getLength() {
			return $this->getData('length');
		}

		function setLocation($location) {
			$this->setData('location', $location);
		}

		function getLocation() {
			return $this->getData('location');
		}

		function setInvestigator($investigator) {
			return $this->setData('investigator', $investigator);
		}

		function getInvestigator() {
			return $this->getData('investigator');
		}

	function setUploader($sectionId) {
		$this->setSection($sectionId);
	}

	function setSection($sectionId){
		$this->setData('sectionId', $sectionId);
	}

	function getUploader() {
		return $this->getData('sectionId');
	}

	function setMinutesStatus($minutesStatus) {
		$this->setData('minutesStatus', $minutesStatus);
	}

	function getMinutesStatus() {
		return $this->getData('minutesStatus');
	}

	/**********************************
	 * Additional fields for meeting
	 *  Added by ayveemallare 7/6/2011
	 **********************************/

	function setUserId($userId) {
		$this->setData('userId', $userId);
	}

	function getUserId() {
		return $this->getData('userId');
	}

	function setIsAttending($isAttending) {
		$this->setData('isAttending', $isAttending);
	}

	function getIsAttending() {
		return $this->getData('isAttending');
	}

	function setRemarks($remarks) {
		$this->setData('remarks', $remarks);
	}

	function getRemarks() {
		return $this->getData('remarks');
	}

	function setStatus($status) {
		$this->setData('status', $status);
	}

	function getStatus() {
		return $this->getData('status');
	}


	function updateMeetingStatus($meetingStatus){
		$this->setData('meetingStatus', $meetingStatus);
	}

	function getMeetingStatus(){
		return $this->getData('meetingStatus');
	}


	function setIsPresent($isPresent) {
		$this->setData('isPresent', $isPresent);
	}

	function isPresent() {
		return $this->getData('isPresent');
	}

	function getReasonForAbsence() {
		return $this->getData('reasonForAbsence');
	}

	function setReasonForAbsence($reasonForAbsence) {
		$this->setData('reasonForAbsence', $reasonForAbsence);
	}


	/**
	 * Get array mapping of completed sections of the meeting minutes
	 * @return array
	 */
	function getStatusMap() {
		$meetingStatus = $this->getMinutesStatus();
		$meetingMap = array();
		for($i=6; $i>=0; $i--) {
			$num = pow(2, $i);
			if($num <= $meetingStatus) {
				$meetingMap[$num] = 1;
				$meetingStatus = $meetingStatus - $num;
			}
			else
			$meetingMap[$num] = 0;
		}
		return $meetingMap;
	}

	/**
	 * Added by aglet 6/30/2011
	 * Get meeting status if complete or incomplete
	 */
	function isMinutesComplete() {
		$status = $this->getMinutesStatus(); 
		if($status == MINUTES_STATUS_COMPLETE || ($status == (MINUTES_STATUS_ATTENDANCE + MINUTES_STATUS_INITIAL_REVIEWS + MINUTES_STATUS_CONTINUING_REVIEWS)) || ($status == (MINUTES_STATUS_ATTENDANCE + MINUTES_STATUS_INITIAL_REVIEWS)) || ($status == (MINUTES_STATUS_ATTENDANCE + MINUTES_STATUS_CONTINUING_REVIEWS))) {
			return true;
		}
		return false;
	}

	function getMinutesStatusKey() {
		if ($this->isMinutesComplete()) {
			return Locale::Translate('editor.minutes.complete');
		}
		else {
			return Locale::Translate('editor.minutes.incomplete');
		}
	}

	function getReplyStatus() {
		switch ($this->getIsAttending()) {
			case MEETING_REPLY_ATTENDING:
				return Locale::Translate('reviewer.meetings.replyStatus.attending');
			case MEETING_REPLY_NOT_ATTENDING:
				return Locale::Translate('reviewer.meetings.replyStatus.notAttending');
			default:
				return Locale::Translate('reviewer.meetings.replyStatus.awaitingReply');
		}
	}

	function getStatusKey() {
		switch ($this->getStatus()) {
			case STATUS_FINAL:
				return Locale::Translate('reviewer.meetings.scheduleStatus.final');
			case STATUS_RESCHEDULED:
				return Locale::Translate('reviewer.meetings.scheduleStatus.rescheduled');
			case STATUS_CANCELLED:
				return Locale::Translate('reviewer.meetings.scheduleStatus.cancelled');
			case STATUS_DONE:
				return Locale::Translate('common.done');
			default:
				return Locale::Translate('reviewer.meetings.scheduleStatus.new');
		}
	}

	function updateMinutesStatus($addToStatus) {
		$status = $this->getMinutesStatus() + $addToStatus;
		$this->setMinutesStatus($status);
	}

	/**
	 * Get an assoc array matching dropdown options for type of discussion in Minutes with locale strings
	 * @return array type => localeString
	 */
	function &getSpecificDiscussionOptions() {
		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		static $specificOptions = array(
			MINUTES_REVIEW_POPULATION_SELECTION => 'editor.minutes.initialReview.populationSelect',
			MINUTES_REVIEW_SCIENTIFIC_DESIGN => 'editor.minutes.initialReview.scientificDesign',
			MINUTES_REVIEW_MINIMIZATIONS => 'editor.minutes.initialReview.minimizations',
			MINUTES_REVIEW_SAFEGUARDS => 'editor.minutes.initialReview.safeguards',
			MINUTES_REVIEW_CONFIDENTIALITY => 'editor.minutes.initialReview.confidentiality',
			MINUTES_REVIEW_RISKS => 'editor.minutes.initialReview.risks',
			MINUTES_REVIEW_BENEFITS => 'editor.minutes.initialReview.benefits',
			MINUTES_REVIEW_CONSENT_DOCUMENT => 'editor.minutes.initialReview.consentDocument',
			MINUTES_REVIEW_OTHER_CONSIDERATIONS => 'editor.minutes.initialReview.otherConsiderations',
			MINUTES_REVIEW_LOCAL_IRB => 'editor.minutes.initialReview.localIrbApproval',
			MINUTES_REVIEW_OTHER_DISCUSSIONS => 'editor.minutes.initialReview.other'
		);
		return $specificOptions;
	}
	
	function getSpecificDiscussionsText($option) {
		switch ($option) {
			case MINUTES_REVIEW_POPULATION_SELECTION:
				return Locale::Translate('editor.minutes.initialReview.populationSelect');
			case MINUTES_REVIEW_SCIENTIFIC_DESIGN:
				return Locale::Translate('editor.minutes.initialReview.scientificDesign');
			case MINUTES_REVIEW_MINIMIZATIONS:
				return Locale::Translate('editor.minutes.initialReview.minimizations');
			case MINUTES_REVIEW_SAFEGUARDS:
				return Locale::Translate('editor.minutes.initialReview.safeguards');
			case MINUTES_REVIEW_CONFIDENTIALITY:
				return Locale::Translate('editor.minutes.initialReview.confidentiality');
			case MINUTES_REVIEW_RISKS:
				return Locale::Translate('editor.minutes.initialReview.risks');
			case MINUTES_REVIEW_BENEFITS:
				return Locale::Translate('editor.minutes.initialReview.benefits');
			case MINUTES_REVIEW_CONSENT_DOCUMENT:
				return Locale::Translate('editor.minutes.initialReview.consentDocument');
			case MINUTES_REVIEW_OTHER_CONSIDERATIONS:
				return Locale::Translate('editor.minutes.initialReview.otherConsiderations');
			case MINUTES_REVIEW_LOCAL_IRB:
				return Locale::Translate('editor.minutes.initialReview.localIrbApproval');				
			default:
				return Locale::Translate('editor.minutes.specificDiscussion');				
		}
	}

	function getPublicId(){
		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$ercDao =& DAORegistry::getDAO("SectionDAO");
		$erc =& $ercDao->getSection($this->getUploader());
		return $erc->getLocalizedAbbrev().'.'.$meetingDao->countPreviousMeetingsOfERC($this->getUploader(), $this->getId());
	}
}

?>
