<?php

/**
 * @defgroup sectionEditor_form
 */

import('classes.lib.fpdf.pdf');
import('lib.pkp.classes.form.Form');

class AnnouncementsForm extends Form {
	/** @var int The meeting this form is for */
	var $meeting;

	/**
	 * Constructor.
	 */
	function AnnouncementsForm($meetingId) {
		parent::Form('sectionEditor/minutes/uploadAnnouncements.tpl');
		$this->addCheck(new FormValidatorPost($this));
		
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$this->meeting =& $meetingDao->getMeetingById($meetingId);
		
		$this->addCheck(new FormValidator($this, 'dateHeld', 'required', 'user.profile.form.usernameRequired'));
		$this->addCheck(new FormValidator($this, 'announcements', 'required', 'user.profile.form.usernameRequired'));
	}

	/**
	 * Display the form.
	 */
	function display(&$args, &$request) {
		$site =& Request::getSite();
		$journal =& Request::getJournal();
		$meeting = $this->meeting;
		
		for($i=1 ; $i<=12 ; $i++) {
			$hour[$i]=$i;
		}
		for($i=0 ; $i<60 ; $i+=10) {
			$minute[$i]=$i;			
		}
		$minute['0']='00';
				
		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('hour', $hour);
		$templateMgr->assign('minute', $minute);
		$templateMgr->assign_by_ref('meeting', $meeting);		
		parent::display();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'dateHeld',
			'hourConvened',
			'minuteConvened',
			'amPmConvened',
			'hourAdjourned',
			'minuteAdjourned',
			'amPmAdjourned',
			'announcements'
		));
	}

	/**
	 *  
	 * @return userId int
	 */
	function execute() {
		$meeting =& $this->meeting;
		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$dateConvened = explode('-', $this->getData('dateHeld'));
		$meeting->setDate(date('Y-m-d H:i:s', mktime(0, 0, 0, $dateConvened[1], $dateConvened[0], $dateConvened[2])));
		$meetingDao->updateMeetingDate($meeting);
		
		$meeting->updateStatus(MEETING_STATUS_ANNOUNCEMENTS);
		$meetingDao->updateStatus($meeting);		
	}
	
	function showPdf() {
		$pdf = new PDF();		
		$pdf->AddPage();
		$pdf->ChapterTitle('Minutes of the Meeting held on '. $this->getData(dateHeld));
		$hourConvened = $this->getData('hourConvened') == 0 ? '00' : $this->getData('hourConvened');
		$minuteConvened = $this->getData('minuteConvened') == 0 ? '00' : $this->getData('minuteConvened'); 
		$hourAdjourned = $this->getData('hourAdjourned') == 0 ? '00' : $this->getData('hourAdjourned');
		$minuteAdjourned = $this->getData('minuteAdjourned') == 0 ? '00' : $this->getData('minuteAdjourned');
		$adjourned = "The meeting was adjourned at ". $hourAdjourned .":". $minuteAdjourned. " " . $this->getData('amPmAdjourned');
		
		$text = "The meeting was convened on  " . $this->getData('dateHeld') . ", ". $hourConvened .":". $minuteConvened. " ". $this->getData('amPmConvened') . " with the required quorum of 7 members present.";
		$pdf->ChapterBody($text);	
		$pdf->ChapterItemBody("Adjournment: ", $adjourned);
		$pdf->ChapterItemBody("Announcements: ", $this->getData('announcements'));
		$pdf->Output();		
	}
}

?>
