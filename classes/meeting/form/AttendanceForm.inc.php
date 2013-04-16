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
		parent::Form('sectionEditor/minutes/generateAttendance.tpl');
		$this->addCheck(new FormValidatorPost($this));
		
		$this->journalId =$journalId;
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);		

		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');	
		$this->meetingAttendances =& $meetingAttendanceDao->getMeetingAttendancesByMeetingId($meetingId);
		
		//import('classes.meeting.MeetingAttendance');
		
		$this->addCheck(new FormValidator($this, 'adjourned', 'required', 'editor.minutes.adjournedRequired'));
		$this->addCheck(new FormValidator($this, 'venue', 'required', 'editor.minutes.venueRequired'));
		
		$this->addCheck(new FormValidatorArray($this, 'guest_attendance', 'required', 'editor.minutes.generateAttendance.requiredAttendance',array('attendance','guestId')));
		$this->addCheck(new FormValidatorCustom($this, 'guest_attendance', 'required', 'editor.minutes.generateAttendance.requiredReasonOfAbsence', create_function('$guest_attendance,$form', 
		'
		foreach($guest_attendance as $key=>$reviewer){
			if(isset($reviewer["attendance"]) && ($reviewer["attendance"]=="absent") && !isset($reviewer["reason"])) return false;
		} return true;
		'
		), array(&$this)));	
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
		if (!$suppGuestNames) $suppGuestNames = array('');
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
				$meetingAttendance->setWasPresent(2);
				$meetingAttendance->setReasonForAbsence($guestAttendances[$guestId]["reason"]);
			} else {
				$meetingAttendance->setWasPresent(1);
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
		$userDao =& DAORegistry::getDAO("UserDAO");
		$meetingAttendanceDao =& DAORegistry::getDAO("MeetingAttendanceDAO");
		$meetingAttendances =& $meetingAttendanceDao->getMeetingAttendancesByMeetingId($meeting->getId());
		$suppGuestNames = $this->getData("suppGuestName");
		$suppGuestAffiliations = $this->getData("suppGuestAffiliation");
		$meetingDateTime = date( "d F Y g:ia", strtotime( $meeting->getDate() ) );
		$meetingDate = date( "d F Y", strtotime( $meeting->getDate() ) );
		$details = Locale::translate('editor.meeting.attendanceReport.intro1').' '.$this->getData("venue").' '.Locale::translate('common.date.on').' '.$meetingDateTime.' '.Locale::translate('editor.meeting.attendanceReport.intro2').' '.$this->quorum.' '.Locale::translate('editor.meeting.attendanceReport.intro3').' '.$this->getData('adjourned') .".";
		$pdf = new PDF();
		$pdf->AddPage();
		
		$sectionDao =& DAORegistry::getDAO("SectionDAO");
		$erc =& $sectionDao->getSection($meeting->getUploader());
		
		$pdf->ChapterTitle($erc->getSectionTitle(), "I");
		
		$pdf->ChapterTitle(Locale::translate('editor.meeting.attendanceReport.meetingDate').' '.$meetingDate, "BU");
		$memberCount = 0;
		$pdf->ChapterItemKey(Locale::translate('editor.meeting.attendanceReport.membersPresent'), 'BU');
		foreach($meetingAttendances as $meetingAttendance) {
			if($meetingAttendance->getWasPresent() == 1) {
				$pdf->ChapterItemVal($meetingAttendance->getFullName());
				$memberCount++;									
			}
		}
		
		if($memberCount == 0) $pdf->ChapterItemVal(Locale::translate('common.none'));
		
		$memberCount = 0;
		$pdf->ChapterItemKey(Locale::translate('editor.meeting.attendanceReport.membersAbsent'), 'BU');
		foreach($meetingAttendances as $meetingAttendance) {
			if($meetingAttendance->getWasPresent() == 2) {
				$pdf->ChapterItemVal($meetingAttendance->getFullName().' ('.Locale::translate('editor.meeting.attendanceReport.reasonForAbsence').' '.$meetingAttendance->getReasonForAbsence().')');
				$memberCount++;																	
			}			
		}
		
		if($memberCount == 0) $pdf->ChapterItemVal(Locale::translate('common.none'));
		
		if(count($suppGuestNames)>0) {
			$suppGuestCount = 0;
			foreach($suppGuestNames as $key=>$guest) {
				if($guest!="" && $guest!=null) {
					if ($suppGuestCount == 0) $pdf->ChapterItemKey(Locale::translate('editor.meeting.attendanceReport.suppGuest'), 'BU');
					$pdf->ChapterItemVal("$guest ($suppGuestAffiliations[$key])");
					$suppGuestCount++;
				}
			}
		}
			 
		$pdf->Ln(10);
		$pdf->ChapterItemVal($details);
		if($this->getData("announcements")) $pdf->ChapterItemKeyVal(Locale::translate('editor.meeting.attendanceReport.announcements'), $this->getData("announcements"), "BU");
		
		$user =& Request::getUser();
		$pdf->ChapterItemKeyVal(Locale::translate('editor.meeting.attendanceReport.submittedBy'), $user->getFullName(), "B");
			
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		
		import('classes.file.MinutesFileManager');
		$minutesFileManager = new MinutesFileManager($meeting->getId());
		$minutesFileManager->handleWrite($pdf, MINUTES_FILE_ATTENDANCE);
	}
}

?>
