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
	var $journalId;
	/**
	 * Constructor.
	 */
	function AttendanceForm($meetingId, $journalId) {
		parent::Form('sectionEditor/minutes/uploadAttendance.tpl');
		$this->addCheck(new FormValidatorPost($this));
		
		$this->journalId =$journalId;
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);		

		$userDao =& DAORegistry::getDAO('UserDAO');		
		$this->reviewers =& $userDao->getUsersWithReviewerRole($journalId);
		
		import('lib.pkp.classes.who.MeetingAttendance');
		
		$this->addCheck(new FormValidator($this, 'adjourned', 'required', 'editor.minutes.adjournedRequired'));
		$this->addCheck(new FormValidator($this, 'venue', 'required', 'editor.minutes.venueRequired'));
		
		$this->addCheck(new FormValidatorArray($this, 'reviewer_attendance', 'required', 'editor.minutes.uploadAttendance.requiredAttendance',array('attendance','userId')));
		$this->addCheck(new FormValidatorCustom($this, 'reviewer_attendance', 'required', 'editor.minutes.uploadAttendance.requiredReasonOfAbsence',
				 create_function('$reviewer_attendance,$form', 'foreach($reviewer_attendance as $key=>$reviewer){
					if(($reviewer["attendance"]=="absent") && ($reviewer["reason"]==null))
					{return false;}	
				 } return true;'), array(&$this)));	
	}

	/**
	 * Initialize form
	 * */
	
	
	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$meeting =& $this->meeting;
		$reviewers =& $this->reviewers;
	
		$attendance  = $this->getData('reviewer_attendance');
		$guestNames = $this->getData("guestName");
		$guestAffiliations = $this->getData("guestAffiliation");
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('reviewers', $reviewers);
		
		$templateMgr->assign_by_ref('attendance', $attendance);
		$templateMgr->assign_by_ref('guestNames', $guestNames);
		$templateMgr->assign_by_ref('guestAffiliations', $guestAffiliations);

		$templateMgr->assign('adjourned', $this->getData('adjourned'));
		$templateMgr->assign('venue', $this->getData('venue'));
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
		foreach($reviewer as $index=>$item) {
		
			$reviewerId = $index;
		
				$meetingReviewer = new Meeting();
				$meetingReviewer->setId($meeting->getId());
				$meetingReviewer->setReviewerId($reviewerId);
				
				
				if($reviewer[$reviewerId]['attendance'] =="absent"){
					$meetingReviewer->setIsPresent(0);
					$meetingReviewer->setReasonForAbsence($reviewer[$reviewerId]["reason"]);
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
		$meeting->updateMinutesStatus(MEETING_STATUS_ATTENDANCE);
		$meetingDao->updateMinutesStatus($meeting);		 
		$meeting->updateMinutesStatus(MINUTES_STATUS_ATTENDANCE);
		$meetingDao->updateMinutesStatus($meeting);		 
	}

	function savePdf() {
		$meeting =& $this->meeting;
		$reviewers =& $this->reviewers;
		$userDao =& DAORegistry::getDAO("UserDAO");
		$reviewerItems =& $this->reviewerItems;		
		$guestNames = $this->getData("guestName");
		$guestAffiliations = $this->getData("guestAffiliation");
		$meetingDateTime = date( "d F Y g:ia", strtotime( $meeting->getDate() ) );
		$meetingDate = date( "d F Y", strtotime( $meeting->getDate() ) );
		$details= "The meeting was convened at ". $this->getData("venue") . " on " . $meetingDateTime . " with the required quorum of ".$this->quorum." members present. The meeting was adjourned at " .  $this->getData('adjourned') .".";
		$pdf = new PDF();
		$pdf->AddPage();
		$pdf->ChapterTitle("Minutes of the ERC Meeting held on ".$meetingDate, "BU");
		
		$memberCount = 0;
		$pdf->ChapterItemKey('Members Present', 'BU');
		foreach($reviewers as $reviewer) {
			$reviewerId = $reviewer->getId();
			if($reviewerItems[$reviewerId]->isPresent()==1) {
				$pdf->ChapterItemVal($reviewer->getFullName());
				$memberCount++;									
			}
		}
		
		if($memberCount == 0) 
			$pdf->ChapterItemVal("None");
		
		$memberCount = 0;
		$pdf->ChapterItemKey('Members Absent', 'BU');
		foreach($reviewers as $reviewer) {
			$reviewerId = $reviewer->getId();
			if($reviewerItems[$reviewerId]->isPresent()==0) {
				$pdf->ChapterItemVal($reviewer->getFullName(). " (Reason for absence: " . $reviewerItems[$reviewerId]->getReasonForAbsence() .")");
				$memberCount++;																	
			}			
		}
		
		if($memberCount == 0) 
			$pdf->ChapterItemVal("None");
		
		if(count($guestNames)>0) {		
			if($guest!="" && $guest!=null) {			
				$pdf->ChapterItemKey('Member Participating in Other Capacity', 'BU');
				foreach($guestNames as $key=>$guest) {
						$pdf->ChapterItemVal("$guest (Affiliation: $guestAffiliations[$key])");				
				}
			}
		}
			
		$pdf->Ln(10);
		$pdf->ChapterItemVal($details);
		if($this->getData("announcements"))
			$pdf->ChapterItemKeyVal("Announcements", $this->getData("announcements"), "BU");
		
		$pdf->ChapterItemKeyVal('Minutes of the Meeting Submitted by', $userDao->getUserFullName($meeting->getUploader()), "B");
			
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$filename = "attendance.pdf";
		$meetingFilesDir = Config::getVar('files', 'files_dir').'/journals/'.$journalId.'/meetings/'.$meeting->getId()."/".$filename;
		
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meeting->getId());
		if($minutesFileManager->createDirectory()) {
			$pdf->Output($meetingFilesDir,"F");
		}		
	} 
	
	
}

?>
