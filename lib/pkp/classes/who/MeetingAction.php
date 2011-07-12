<?php
class MeetingAction extends Action {

	/**
	 * Constructor.
	 */
	function MeetingAction() {
		parent::Action();
	}
	

	function cancelMeeting($meetingId,$user = null){
		
		if ($user == null) $user =& Request::getUser();

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);

		/*Only the author of the meeting can cancel the meeting*/
		if ($meeting->getUploader() == $user->getId()) {
			if (!HookRegistry::call('Action::cancelMeeting', array(&$meeting))) {
				$meetingDao->cancelMeeting($meeting->getId());
			}
		}
	
	}
	
	
	function saveMeeting($meetingId, $user = null){
	
		if ($user == null) $user =& Request::getUser();

		$meetingDao =& DAORegistry::getDAO('MeetingDAO');
		$meeting =& $meetingDao->getMeetingById($meetingId);

		/*Only the author of the meeting can edit the meeting*/
		if ($meeting->getUploader() == $user->getId()) {
			if (!HookRegistry::call('Action::cancelMeeting', array(&$meeting))) {
				$meetingDao->cancelMeeting($meeting->getId());
			}
		}
	
	
	}
	
	
}