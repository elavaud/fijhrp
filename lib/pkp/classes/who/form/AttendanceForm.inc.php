<?php

/**
 * @defgroup sectionEditor_form
 */

import('classes.lib.fpdf.pdf');
import('lib.pkp.classes.form.Form');

class AttendanceForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $meetingAttendances;
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

		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');	
		$this->meetingAttendances =& $meetingAttendanceDao->getMeetingAttendancesByMeetingId($meetingId);
		
		//import('lib.pkp.classes.who.MeetingAttendance');
		
		$this->addCheck(new FormValidator($this, 'adjourned', 'required', 'editor.minutes.adjournedRequired'));
		$this->addCheck(new FormValidator($this, 'venue', 'required', 'editor.minutes.venueRequired'));
		
		$this->addCheck(new FormValidatorArray($this, 'guest_attendance', 'required', 'editor.minutes.uploadAttendance.requiredAttendance',array('attendance','guestId')));
		$this->addCheck(new FormValidatorCustom($this, 'guest_attendance', 'required', 'editor.minutes.uploadAttendance.requiredReasonOfAbsence',
				 create_function('$guest_attendance,$form', 'foreach($guest_attendance as $key=>$reviewer){
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
		$meetingAttendances =& $this->meetingAttendances;
	
		$attendance  = $this->getData('guest_attendance');
		$suppGuestNames = $this->getData("suppGuestName");
		$suppGuestAffiliations = $this->getData("suppGuestAffiliation");
		
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('meetingAttendances', $meetingAttendances);
		
		$templateMgr->assign_by_ref('attendance', $attendance);
		$templateMgr->assign_by_ref('suppGuestNames', $suppGuestNames);
		$templateMgr->assign_by_ref('suppGuestAffiliations', $suppGuestAffiliations);

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
				  "guest_attendance",
				  "suppGuestName",
				  "suppGuestAffiliation"
		));
	}
	
	/**
	 *
	 * @return userId int
	 */
	function execute() {

		$meeting =& $this->meeting;
		$meetingDao =& DAORegistry::getDAO("MeetingDAO");
		$meetingAttendanceDao =& DAORegistry::getDAO("MeetingAttendanceDAO");
		$quorum = 0;
		
		$guestAttendances  = $this->getData('guest_attendance');
		foreach($guestAttendances as $index=>$item) {		
			$guestId = $index;
			$meetingAttendance = new MeetingAttendance();
			$meetingAttendance->setMeetingId($meeting->getId());
			$meetingAttendance->setUserId($guestId);
			
			if ($guestAttendances[$guestId]['attendance'] =="absent"){
				$meetingAttendance->setIsAttending(2);
				$meetingAttendance->setReasonForAbsence($guestAttendances[$guestId]["reason"]);
			} else {
				$meetingAttendance->setIsAttending(1);
				$meetingAttendance->setReasonForAbsence(null);
				$quorum++;
			}			
			$meetingAttendanceDao->updateAttendanceOfUser($meetingAttendance);
		}
		
		$this->quorum = $quorum;	 
		$meeting->updateMinutesStatus(MINUTES_STATUS_ATTENDANCE);
		$meetingDao->updateMinutesStatus($meeting);		 
	}

	function savePdf() {
		$meeting =& $this->meeting;
		$meetingAttendances =& $this->meetingAttendances;
		$userDao =& DAORegistry::getDAO("UserDAO");
		$suppGuestNames = $this->getData("suppGuestName");
		$suppGuestAffiliations = $this->getData("suppGuestAffiliation");
		$meetingDateTime = date( "d F Y g:ia", strtotime( $meeting->getDate() ) );
		$meetingDate = date( "d F Y", strtotime( $meeting->getDate() ) );
		$details= "The meeting was convened at ". $this->getData("venue") . " on " . $meetingDateTime . " with the required quorum of ".$this->quorum." members present. The meeting was adjourned at " .  $this->getData('adjourned') .".";
		$pdf = new PDF();
		$pdf->AddPage();
		$pdf->ChapterTitle("Minutes of the ERC Meeting held on ".$meetingDate, "BU");
		$memberCount = 0;
		$pdf->ChapterItemKey('Members Present', 'BU');
		foreach($meetingAttendances as $meetingAttendance) {
			if($meetingAttendance->getIsAttending() == 1) {
				$pdf->ChapterItemVal($meetingAttendance->getFullName());
				$memberCount++;									
			}
		}
		
		if($memberCount == 0) 
			$pdf->ChapterItemVal("None");
		
		$memberCount = 0;
		$pdf->ChapterItemKey('Members Absent', 'BU');
		foreach($meetingAttendances as $meetingAttendance) {
			if($meetingAttendance->getIsAttending() == 2) {
				$pdf->ChapterItemVal($meetingAttendance->getFullName(). " (Reason for absence: " . $meetingAttendance->getReasonForAbsence() .")");
				$memberCount++;																	
			}			
		}
		
		if($memberCount == 0) 
			$pdf->ChapterItemVal("None");
		
		if(count($suppGuestNames)>0) {								
			foreach($suppGuestNames as $key=>$guest) {
				if($guest!="" && $guest!=null) {
					$pdf->ChapterItemKey('Member Participating in Other Capacity', 'BU');
					$pdf->ChapterItemVal("$guest (Affiliation: $suppGuestAffiliations[$key])");
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
