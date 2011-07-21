<?php

/**
 * @defgroup sectionEditor_form
 */

import('classes.lib.fpdf.pdf');
import('lib.pkp.classes.form.Form');

class AttendanceForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $reviewers;
	var $reviewerItems;
	var $quorum;
	/**
	 * Constructor.
	 */
	function AttendanceForm($meetingId, $journalId) {
		parent::Form('sectionEditor/minutes/uploadAttendance.tpl');
		$this->addCheck(new FormValidatorPost($this));
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);		

		$userDao =& DAORegistry::getDAO('UserDAO');		
		$this->reviewers =& $userDao->getUsersWithReviewerRole($journalId);
		import('lib.pkp.classes.who.MeetingAttendance');
		
		$this->addCheck(new FormValidator($this, 'adjourned', 'required', 'editor.minutes.adjournedRequired'));
		$this->addCheck(new FormValidator($this, 'venue', 'required', 'editor.minutes.venueRequired'));
		$this->addCheck(new FormValidatorArray($this, 'reviewer_attendance', 'required', 'editor.minutes.uploadAttendance.requiredAttendance',array('attendance','userId')));

		
		$this->addCheck(new FormValidatorArrayMyCustom($this, 'reviewer_absent', 'required', 'editor.minutes.uploadAttendance.requiredReasonOfAbsence', 
		create_function('$attendance, $reason', 'if(($attendance=="absent") && !isset($reason)) return false; else return true;'), array('attendance','reason')));	
		
	
		
	}

	
	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$meeting =& $this->meeting;
		$reviewers =& $this->reviewers;

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('reviewers', $reviewers);
		$templateMgr->assign('adjourned', $this->getData('adjourned'));
		$templateMgr->assign('venue', $this->getData('$venue'));
		$templateMgr->assign('announcements', $this->getData('announcements'));
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array("adjourned", 
				  "venue", 
				  "announcements", 
				  "reviewer_attendance",
				  "reviewer_absent",
				  "guestName",
				  "guestAffiliation"
		));
	}
	
	/**
	 *
	 * @return userId int
	 */
	function execute() {

		$meeting =& $this->meeting;
		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meetingReviewerDao =& DAORegistry::getDAO("MeetingReviewerDAO");
		$quorum = 0;
		$reviewerItems = array();
		
		$reviewer  = $this->getData('reviewer_attendance');
		$reasonOfAbsence = $this->getData('reviewer_absent');
		for ($i=0, $count=count($reviewer); $i < $count; $i++) {

			$reviewerId = $reviewer[$i]['userId'];
		
				$meetingReviewer = new Meeting();
				$meetingReviewer->setId($meeting->getId());
				$meetingReviewer->setReviewerId($reviewerId);
				
				
				if($reviewer[$i]['attendance'] =="absent"){
					$meetingReviewer->setIsPresent(0);
					$meetingReviewer->setReasonForAbsence($reasonOfAbsence[$i]["reason"]);
				}else {
					
					$meetingReviewer->setIsPresent(1);
					$meetingReviewer->setReasonForAbsence(null);
					$quorum++;
				}
				
				$reviewerItems[$reviewerId] = $meetingReviewer;
				$meetingReviewerDao->updateAttendanceOfReviewer($meetingReviewer);
		}
		
		$this->quorum = $quorum;
		$this->reviewerItems = $reviewerItems;
		$meeting->updateMinutesStatus(MINUTES_STATUS_ATTENDANCE);
		$meetingDao->updateMinutesStatus($meeting);		 
			
		//$quorum = 0;
		//$reviewerItems = array();
		/*foreach($attendance as $index=>$item) {
			
			$meetingReviewer = new Meeting();
			$meetingReviewer->setId($meeting->getId());
			$meetingReviewer->setReviewerId($index);			
			if($item == "absent") {
				$meetingReviewer->setIsPresent(0);
				$meetingReviewer->setReasonForAbsence($reasons[$index]);
			}
			else {
				$meetingReviewer->setIsPresent(1);
				$meetingReviewer->setReasonForAbsence(null);
				$quorum++;
			}
			$reviewerItems[$index] = $meetingReviewer;
			$meetingReviewerDao->updateAttendanceOfReviewer($meetingReviewer);
		} */
		
		
		//$this->quorum = $quorum;
		//$this->reviewerItems = $reviewerItems;
		//$meeting->updateMeetingStatus(MINUTES_STATUS_ATTENDANCE);
		//$meetingDao->updateStatus($meeting);		 
	}

	function showPdf() {
		$meeting =& $this->meeting;
		$reviewers =& $this->reviewers;
		$reviewerItems =& $this->reviewerItems;		
		$guestNames = $this->getData("guestName");
		$guestAffiliations = $this->getData("guestAffiliation");
		$details= "The meeting was convened at ". $this->getData("venue") . " on " . $meeting->getDate() . " with the required quorum of ".$this->quorum." members present. The meeting was adjourned at " .  $this->getData('adjourned') .".";				
		$pdf = new PDF();
		$pdf->AddPage();
		$pdf->ChapterTitle("Minutes of the Meeting held on ".$meeting->getDate(), "BU");
		$pdf->ChapterItemKey('Members Present', 'BU');
		
		foreach($reviewers as $reviewer) {
			$reviewerId = $reviewer->getId();
			if($reviewerItems[$reviewerId]->isPresent()==1) {
				$pdf->ChapterItemVal($reviewer->getFullName());									
			}
		}
		$pdf->ChapterItemKey('Members Absent', 'BU');
		foreach($reviewers as $reviewer) {
			$reviewerId = $reviewer->getId();
			if($reviewerItems[$reviewerId]->isPresent()==0) {
				$pdf->ChapterItemVal($reviewer->getFullName(). " (Reason for absence: " . $reviewerItems[$reviewerId]->getReasonForAbsence() .")");																	
			}			
		}
		
		if(count($guestNames)>0) {		
			$pdf->ChapterItemKey('Member Participating in Other Capacity', 'BU');
			foreach($guestNames as $key=>$guest)
				$pdf->ChapterItemVal("$guest (Affiliation: $guestAffiliations[$key])");
		}
			
		$pdf->Ln(10);
		$pdf->ChapterItemVal($details);
		if($this->getData("announcements"))
			$pdf->ChapterItemKeyVal("Announcements", $this->getData("announcements"), "BU");
		$pdf->Output();
	}
}

?>
