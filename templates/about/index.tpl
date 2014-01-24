{**
 * index.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * About the Journal index.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="about.aboutTheJournal"}
{include file="common/header.tpl"}
{/strip}
<!--
<div id="aboutPeople">
<h3>{translate key="about.people"}</h3>
<ul class="plain">
	{*{if not (empty($journalSettings.mailingAddress) && empty($journalSettings.contactName) && empty($journalSettings.contactAffiliation) && empty($journalSettings.contactMailingAddress) && empty($journalSettings.contactPhone) && empty($journalSettings.contactFax) && empty($journalSettings.contactEmail) && empty($journalSettings.supportName) && empty($journalSettings.supportPhone) && empty($journalSettings.supportEmail))}*}{*Not useful anymore. EL on April 18, 2012*}
		<li>&#187; <a href="{url op="contact"}">{translate key="about.contact"}</a></li>
	{*{/if}*}{*Not useful anymore. EL on April 18, 2012*}
	<li>&#187; <a href="{url op="editorialTeam"}">{translate key="about.editorialTeam"}</a></li>
	{*{iterate from=peopleGroups item=peopleGroup}
		<li>&#187; <a href="{url op="displayMembership" path=$peopleGroup->getId()}">{$peopleGroup->getLocalizedTitle()|escape}</a></li>
	{/iterate}
	{call_hook name="Templates::About::Index::People"}*}{*Not useful anymore. EL on April 18, 2012*}
</ul>
</div>
-->
<div id="aboutPolicies">

<h3>Documents</h3>
<ul class="plain">
<li>&#187;{* <a title="Standard Operating Procedures (engl)" href="/public/Cam_SOP_engl.pdf" target="_blank">*} Standard Operating Procedures (engl) <i>...soon available...</i>{*</a>*}</li>
<li>&#187; 	<a title="Userguide for investigators (engl)" href="/fijihrp/public/FijiHRP_UserManual_Investigator_eng.pdf" target="_blank"> Userguide for investigators (engl)</a></li>
<li>&#187;  <a href="/fijihrp/public/FINAL_REPORT_Template.doc" target="_blank"> Final Report (engl)</a></li>
<li>&#187;  <a href="/fijihrp/public/PROGRESS_REPORT_Template.doc" target="_blank"> Progress Report (engl)</a></li>
<li>&#187;  <a href="/fijihrp/public/PROPOSAL_REVIEW_template.doc" target="_blank"> Proposal Review (engl)</a></li>
</ul>
</div>

{* "submissions" commented out by EL on April 12 2012 *}
{*
<div id="aboutSubmissions">
<h3>{translate key="about.submissions"}</h3>
<ul class="plain">
	<li>&#187; <a href="{url op="submissions" anchor="onlineSubmissions"}">{translate key="about.onlineSubmissions"}</a></li>
	{if $currentJournal->getLocalizedSetting('authorGuidelines') != ''}<li>&#187; <a href="{url op="submissions" anchor="authorGuidelines"}">{translate key="about.authorGuidelines"}</a></li>{/if}
	{if $currentJournal->getLocalizedSetting('copyrightNotice') != ''}<li>&#187; <a href="{url op="submissions" anchor="copyrightNotice"}">{translate key="about.copyrightNotice"}</a></li>{/if}
	{if $currentJournal->getLocalizedSetting('privacyStatement') != ''}<li>&#187; <a href="{url op="submissions" anchor="privacyStatement"}">{translate key="about.privacyStatement"}</a></li>{/if}
	{if $currentJournal->getSetting('journalPaymentsEnabled') && ($currentJournal->getSetting('submissionFeeEnabled') || $currentJournal->getSetting('fastTrackFeeEnabled') || $currentJournal->getSetting('publicationFeeEnabled'))}<li>&#187; <a href="{url op="submissions" anchor="authorFees"}">{translate key="about.authorFees"}</a></li>{/if}
	{call_hook name="Templates::About::Index::Submissions"}
</ul>
</div>
*}

{* "aboutOther" commented out by EL on April 4 2012 *}
{*
<div id="aboutOther">
<h3>{translate key="about.other"}</h3>
<ul class="plain">
	{if not ($currentJournal->getSetting('publisherInstitution') == '' && $currentJournal->getLocalizedSetting('publisherNote') == '' && $currentJournal->getLocalizedSetting('contributorNote') == '' && empty($journalSettings.contributors) && $currentJournal->getLocalizedSetting('sponsorNote') == '' && empty($journalSettings.sponsors))}<li>&#187; <a href="{url op="journalSponsorship"}">{translate key="about.journalSponsorship"}</a></li>{/if}
	{if $currentJournal->getLocalizedSetting('history') != ''}<li>&#187; <a href="{url op="history"}">{translate key="about.history"}</a></li>{/if}
	<li>&#187; <a href="{url op="siteMap"}">{translate key="about.siteMap"}</a></li>
	<li>&#187; <a href="{url op="aboutThisPublishingSystem"}">{translate key="about.aboutThisPublishingSystem"}</a></li>
	{if $publicStatisticsEnabled}<li>&#187; <a href="{url op="statistics"}">{translate key="about.statistics"}</a></li>{/if}
	{call_hook name="Templates::About::Index::Other"}
</ul>
</div>
*}

<div id="aboutSubmissions">
	<h3>Contacts</h3>
	<p><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#187;&nbsp;Ministry of Health, Head Quarters</b><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Dinem House<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;88 Amy Street, Toorak<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Suva, Fiji<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ph: (679) 3306177<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fax: (679) 3306163<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Website: <a href="www.health.gov.fj">www.health.gov.fj</a></p>
	<p><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#187;&nbsp;Division of Health Information Research Analysis</b><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Director: Mr.Shivnay Naidu<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Level 2, Dinem House<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;88 Amy Street, Toorak<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Suva, Fiji<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ph: (679) 3306177 or 3215725<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fax: (679) 331822<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email: snaidu002 @ health.gov.fj <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>(please remove the spaces before and after the "@")</i></p>
	<p><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#187;&nbsp;National Health Research Office</b><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;National Health Research Officer: Mere Delai<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Level 2, Dinem House<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;88 Amy Street, Toorak<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Suva, Fiji<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ph: (679) 3306177 or 3215770<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fax: (679) 3318227<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email: mere.delai @ govnet.gov.fj <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>(please remove the spaces before and after the "@")</i></p>

</div>

{include file="common/footer.tpl"}

