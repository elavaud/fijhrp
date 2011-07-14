<?php

/**
 * @defgroup sectionEditor_form
 */

import('classes.lib.fpdf.pdf');
import('lib.pkp.classes.form.Form');

class AttendanceForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;
	var $reviewerItems;
	var $reviewerItemsCopy;
	var $reviewerFieldNames;
	var $reviewerRemarks;
	var $reviewers;
	/**
	 * Constructor.
	 */
	function AttendanceForm($meetingId, $journalId) {
		parent::Form('sectionEditor/minutes/uploadAttendance.tpl');
		$this->addCheck(new FormValidatorPost($this));
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);		

		$userDao =& DAORegistry::getDAO('UserDAO');
		$this->reviewerItems = array();
		$this->reviewerItemsCopy = array();
		$this->reviewerRemarks = array();
		$this->reviewerFieldNames = array();
		$this->reviewers =& $userDao->getUsersWithReviewerRole($journalId);
		import('lib.pkp.classes.who.MeetingAttendance');
		foreach($this->reviewers as $reviewer) {
			$temp = new MeetingAttendance();
			$temp->setMeetingId($meetingId);
			$reviewerId = $reviewer->getId();
			$temp->setUser($reviewerId);
			$name = "attendance_".$reviewerId;
			$remarksName = "absence_reason_".$reviewerId;
			$temp->setIsPresent(1);
			$temp->setRemarks(null);
			$this->reviewerFieldNames[] = $name;
			$this->reviewerRemarks[] = $remarksName;
			$this->reviewerItems[$name] = $temp;
			$this->reviewerItemsCopy[$reviewerId] = $temp;
			$this->addCheck(new FormValidator($this, $name, 'required', ''));
			//$this->addCheck(new FormValidatorCustom($this, 'email', 'required', 'user.register.form.emailExists', array(DAORegistry::getDAO('UserDAO'), 'userExistsByEmail'), array(null, true), true));
		}


	}

	/**
	 * Display the form.
	 */
	function display(&$args, &$request) {
		$site =& Request::getSite();
		$journal =& Request::getJournal();
		$meeting = $this->meeting;
		
		$userDao =& DAORegistry::getDAO('UserDAO');
		$reviewers =& $userDao->getUsersWithReviewerRole($journal->getId());

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign_by_ref('meeting', $meeting);
		$templateMgr->assign_by_ref('reviewers', $reviewers);
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars($this->reviewerFieldNames);
		$this->readUserVars($this->reviewerRemarks);
	}

	/**
	 *
	 * @return userId int
	 */
	function execute() {
		$meeting =& $this->meeting;
		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$meetingAttendanceDao =& DAORegistry::getDAO('MeetingAttendanceDAO');
		foreach($this->reviewerFieldNames as $index => $name) {
			$attendance =& $this->reviewerItems[$name];
			if($this->getData($name) == "absent"){
				$attendance->setIsPresent(0);
				$attendance->setRemarks($this->getData($this->reviewerRemarks[$index]));
			}
			$reviewerItems[$name] =& $attendance;
			$reviewerItemsCopy[$attendance->getUser()] =& $attendance; 
			//echo "index:$index ". $name."|". $attendance->isPresent()."|". $this->reviewerItemsCopy[$attendance->getUser()]->isPresent()."<br/>";			
			$meetingAttendanceDao->insertMeetingAttendance($attendance);
		}
		$meeting->updateStatus(MEETING_STATUS_ATTENDANCE);
		$meetingDao->updateStatus($meeting);
	}

	function showPdf() {
		$reviewers =& $this->reviewers;
		$reviewerItemsCopy =& $this->reviewerItemsCopy;
		$pdf = new PDF();
		$pdf->AddPage();
		$pdf->ChapterTitle('ATTENDANCE');
		$pdf->ChapterItemBody('Members Present', '');
		foreach($reviewers as $reviewer) {
			$reviewerId = $reviewer->getId();
			if($reviewerItemsCopy[$reviewerId]->isPresent()) {
				$pdf->ChapterItemBody('', $reviewer->getFullName());									
			}			
		}
		$pdf->Ln(10);
		$pdf->ChapterItemBody('Members Absent', '');
		foreach($reviewers as $reviewer) {
			$reviewerId = $reviewer->getId();
			if(!$reviewerItemsCopy[$reviewerId]->isPresent()) {
				$pdf->ChapterItemBody('', $reviewer->getFullName(). " (Reason for absence: " . $reviewerItemsCopy[$reviewerId]->getRemarks() .")");																	
			}			
		}
		$pdf->Output();
	}
}

?>
