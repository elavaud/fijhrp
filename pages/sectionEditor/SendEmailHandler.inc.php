<?php

/**
 * @file SubmissionEditHandler.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SubmissionEditHandler
 * @ingroup pages_sectionEditor
 *
 * @brief Handle requests for submission tracking.
 */


define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);

import('pages.sectionEditor.SectionEditorHandler');
import('pages.sectionEditor.SubmissionCommentsHandler');

class SendEmailHandler extends Handler {
	/**
	 * Constructor
	 **/
	function SendEmailHandler() {
		parent::Handler();
		
		$this->addCheck(new HandlerValidatorJournal($this));
		// FIXME This is kind of evil
		$page = Request::getRequestedPage();
		if ( $page == 'sectionEditor' )  
			$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_SECTION_EDITOR)));
		elseif ( $page == 'editor' ) 		
			$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_EDITOR)));

	}
        
        function sendEmailAllUsers($send=false) {
            import('classes.mail.MailTemplate');
            $email = new MailTemplate();
            
            if ($send && !$email->hasErrors()) {
                HookRegistry::call('SendEmailHandler::sendEmailAllUsers', array(&$send));
                
                $email->send();
                
            }else {
                $sender =& Request::getUser();
                $journal =& Request::getJournal();

                $roleDao =& DAORegistry::getDAO('RoleDAO');

                //Get all users
                $allUsers = $roleDao->getUsersByJournalId($journal->getId());
                
                //Get already added recipients
                $recipients =& $email->getRecipients();
                if(isset($recipients)) $totalRecipients = count($recipients);
                else $totalRecipients = 0;
                
                while (!$allUsers->eof()) {
                    $user =& $allUsers->next();
                    $isNotInTheList = true;
                    if(isset($recipients)) foreach ($recipients as $recipient) if ($recipient['email'] == $user->getEmail()) $isNotInTheList = false;
                    
                    if($sender->getId() != $user->getId() && ($isNotInTheList == true)) {
                        $email->addRecipient($user->getEmail(), $user->getFullName());
                        $totalRecipients++;
                    }

                    unset($user);
                }

                $email->displayEditForm(Request::url(null, null, 'sendEmailAllUsers', 'send'), null, 'email/email_hiderecipients.tpl', array('totalRecipients' => $totalRecipients));
            }
            
            Request::redirect(null, null, 'index');
        }
        
        function sendEmailERCMembers($send=false) {
            import('classes.mail.MailTemplate');
            $email = new MailTemplate();
            
            if (Request::getUserVar('send') && !$email->hasErrors()) {
                HookRegistry::call('SendEmailHandler::sendEmailERCMembers', array(&$send));
                
                $email->send();
                
            } else {
                $sender =& Request::getUser();
                $journal =& Request::getJournal();
                $roleDao =& DAORegistry::getDAO('RoleDAO');
				$erc = $sender->getSecretaryEthicsCommittee();
                
                //Get ERC Members
                $reviewers = $roleDao->getUsersByRoleId(ROLE_ID_REVIEWER);
                
                //Get already added recipients
                $recipients =& $email->getRecipients();
                if(isset($recipients)) $totalRecipients = count($recipients);
                else $totalRecipients = 0;
                
                while (!$reviewers->eof()) {
                    $reviewer =& $reviewers->next();
                    
                    // Check if new recipient is not already added
                    $isNotInTheList = true;
                    if(isset($recipients)) foreach ($recipients as $recipient) if ($recipient['email'] == $reviewer->getEmail()) $isNotInTheList = false;
                    
                    //Add new recipients according the committee
                    if(($sender->getId() != $reviewer->getId()) && (($erc=="UHS" && $reviewer->isUhsMember()) || ($erc=="NIOPH" && $reviewer->isNiophMember())) && ($isNotInTheList == true)) {
                        $email->addRecipient($reviewer->getEmail(), $reviewer->getFullName());
                        $totalRecipients++;
                    }

                    unset($reviewer);
                }

                $email->displayEditForm(Request::url(null, null, 'sendEmailAllUsers', 'send'), null, 'email/email.tpl', array('totalRecipients' => $totalRecipients));
            }
            
            Request::redirect(null, null, 'index');           
        }
        
        function sendEmailRTOs($send=false) {
            import('classes.mail.MailTemplate');
            $email = new MailTemplate();
            
            if ($send && !$email->hasErrors()) {
                HookRegistry::call('SendEmailHandler::sendEmailRTOs', array(&$send));
                
                $email->send();
                
            } else {
                $sender =& Request::getUser();
                $journal =& Request::getJournal();
                
                $roleDao =& DAORegistry::getDAO('RoleDAO');

                //Get RTOs
                $authors = $roleDao->getUsersByRoleId(ROLE_ID_AUTHOR);
                
                //Get already added recipients
                $recipients =& $email->getRecipients();
                if(isset($recipients)) $totalRecipients = count($recipients);
                else $totalRecipients = 0;
                
                while (!$authors->eof()) {
                    $author =& $authors->next();
                    
                    // Check if new recipient is not already added
                    $isNotInTheList = true;
                    if(isset($recipients)) foreach ($recipients as $recipient) if ($recipient['email'] == $author->getEmail()) $isNotInTheList = false;
                    
                    //Add new recipients
                    if($sender->getId() != $author->getId() && ($isNotInTheList == true)) {
                        $email->addRecipient($author->getEmail(), $author->getFullName());
                        $totalRecipients++;
                    }

                    unset($author);
                }

                $email->displayEditForm(Request::url(null, null, 'sendEmailRTOs', 'send'), null, 'email/email_hiderecipients.tpl', array('totalRecipients' => $totalRecipients));
            }
            
            Request::redirect(null, null, 'index');           
        }
}

?>