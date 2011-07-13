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
		
		//$this->addCheck(new FormValidator($this, 'announcements', 'required', 'editor.minutes.announcementsRequired'));
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
		
		$meeting->updateStatus(MEETING_STATUS_ANNOUNCEMENTS);
		$meetingDao->updateStatus($meeting);		
	}
	
	function showPdf() {
		$meeting =& $this->meeting;
		$pdf = new PDF();		
		$pdf->AddPage();
		$pdf->ChapterTitle('Minutes of the Meeting');
		$hourAdjourned = $this->getData('hourAdjourned') == 0 ? '00' : $this->getData('hourAdjourned');
		$minuteAdjourned = $this->getData('minuteAdjourned') == 0 ? '00' : $this->getData('minuteAdjourned');
		$adjourned = "The meeting was adjourned at ". $hourAdjourned .":". $minuteAdjourned. " " . $this->getData('amPmAdjourned');
		
		$text = "The meeting was convened on  " . $meeting->getDate();
		$pdf->ChapterBody($text);	
		$pdf->ChapterItemBody("Adjournment: ", $adjourned);
		$pdf->ChapterItemBody("Announcements: ", $this->getData('announcements'));
		$pdf->Output();		
	}
}

?>
