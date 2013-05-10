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

<h3>{translate key="about.policies"}</h3>
<ul class="plain">
<li>&#187;{* <a title="Standard Operating Procedures (engl)" href="/public/Cam_SOP_engl.pdf" target="_blank">*} Standard Operating Procedures (engl) <i>...soon available...</i>{*</a>*}</li>
</ul>
</div>

<div id="userGuides">
<h3>{translate key="about.userGuides"}</h3>
<ul class="plain">
<li>&#187; {* <a title="Userguide for investigators (engl)" href="/public/Cam_IRBs_HR_Investigator_Userguide_khmer.pdf" target="_blank">*} Userguide for investigators (engl) <i>...soon available...</i>{*</a>*}</li>
</ul>
</div>

<div id="userGuides">
<h3>{translate key="about.templates"}</h3>
<ul class="plain">
<li>&#187;  <a href="/hrp/public/FINAL_REPORT_Template.doc" target="_blank"> Final Report (engl)</a></li>
<li>&#187;  <a href="/hrp/public/PROGRESS_REPORT_Template.doc" target="_blank"> Progress Report (engl)</a></li>
<li>&#187;  <a href="/hrp/public/PROPOSAL_REVIEW_template.doc" target="_blank"> Proposal Review (engl)</a></li>
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
{include file="common/footer.tpl"}

