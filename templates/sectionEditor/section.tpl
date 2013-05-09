{**
 * section.tpl
 *
 * Ethics Committee Membership
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="editor.article.ethicsCommittee"}
{include file="common/header.tpl"}
{/strip}
<ul class="menu">
	<li><a class="action" href="{url op="index"}">{translate key="article.articles"}</a></li>
	<li class="current"><a class="action" href="{url op="section" path=$ercId}">{translate key="section.sectionAbbrev"}</a></li>
	<li><a class="action" href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
</ul>

<h3><b>{$erc->getLocalizedTitle()}</b></h3>
<p><br/></p>
<table width="100%">
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="40%" valign="middle" align="center"><a class="action" href="{url op="enrollSearch" path=$sectionId}">{translate key="sectionEditor.review.enrollReviewer"}</a></td>
		<td width="40%" valign="middle" align="center"><a class="action" href="{url op="createReviewer" path=$sectionId}">{translate key="sectionEditor.review.createReviewer"}</a></td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr><td colspan="2" class="separator">&nbsp;</td></tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="40%" valign="middle" align="center"><a class="action" href="{url op="sendEmailERCMembers"}">{translate key="editor.email.ERCMembers"}</a></td>
		<td width="40%" valign="middle" align="center"><a class="action" href="{url op="createExternalReviewer" path=$sectionId}">{translate key="sectionEditor.review.createExternalReviewer"}</a></td>
		<td width="10%">&nbsp;</td>
	</tr>
</table>
<p><br/></p>
<h4>{if count($secretaries) > 1}{translate key="user.role.editors"}{else}{translate key="user.role.sectionEditor"}{/if}</h4>

<table width="100%" class="listing">
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="20%">{translate key="user.username" sort="username"}</td>
		<td width="30%">{translate key="user.name" sort="name"}</td>
		<td width="35%">{translate key="user.email" sort="email"}</td>
		<td width="150%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	
{foreach from=$secretaries item=secretary}
	<tr valign="top">
		<td>
			<a class="action" href="{url op="userProfile" path=$secretary->getId()}">{$secretary->getUsername()|escape|wordwrap:15:" ":true}</a>
		</td>
		<td>{$secretary->getFullName()|escape}</td>
		<td class="nowrap">
			{assign var=emailString value=$secretary->getFullName()|concat:" <":$secretary->getEmail():">"}
			{url|assign:"redirectUrl" path=$erc->getSectionId() escape=false}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$redirectUrl}
			{$secretary->getEmail()|truncate:25:"..."|escape}&nbsp;{icon name="mail" url=$url}
		</td>
		<td align="right">
			{if $thisUser->getId() == $secretary->getId()}&mdash;
			{else}
				<a href="{url op="unEnroll" path="512" userId=$secretary->getId() journalId=$currentJournal->getId() sectionId=$erc->getSectionId()}" onclick="return confirm('{translate|escape:"jsparam" key="manager.people.confirmUnenroll"}')" class="action">{translate key="manager.people.unenroll"}</a>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="4" class="separator">&nbsp;</td>
	</tr>
{/foreach}
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
</table>
<p><br/></p>
<h4>{translate key="user.ercrole.chair}</h4>

<table width="100%" class="listing">
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="20%">{translate key="user.username" sort="username"}</td>
		<td width="30%">{translate key="user.name" sort="name"}</td>
		<td width="35%">{translate key="user.email" sort="email"}</td>
		<td width="150%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	
{foreach from=$chairs item=chair}
	<tr valign="top">
		<td>
			<a class="action" href="{url op="userProfile" path=$chair->getId()}">{$chair->getUsername()|escape|wordwrap:15:" ":true}</a>
		</td>
		<td>{$chair->getFullName()|escape}</td>
		<td class="nowrap">
			{assign var=emailString value=$chair->getFullName()|concat:" <":$chair->getEmail():">"}
			{url|assign:"redirectUrl" path=$erc->getSectionId() escape=false}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$redirectUrl}
			{$chair->getEmail()|truncate:25:"..."|escape}&nbsp;{icon name="mail" url=$url}
		</td>
		<td align="right">
			{if $thisUser->getId() == $chair->getId()}&mdash;
			{else}
				<a href="{url op="unEnroll" path="512" userId=$chair->getId() journalId=$currentJournal->getId() sectionId=$erc->getSectionId()}" onclick="return confirm('{translate|escape:"jsparam" key="manager.people.confirmUnenroll"}')" class="action">{translate key="manager.people.unenroll"}</a>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="4" class="separator">&nbsp;</td>
	</tr>
{/foreach}
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
</table>
<p><br/></p>
<h4>{translate key="user.ercrole.viceChair"}</h4>

<table width="100%" class="listing">
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="20%">{translate key="user.username" sort="username"}</td>
		<td width="30%">{translate key="user.name" sort="name"}</td>
		<td width="35%">{translate key="user.email" sort="email"}</td>
		<td width="150%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	
{foreach from=$viceChairs item=viceChair}
	<tr valign="top">
		<td>
			<a class="action" href="{url op="userProfile" path=$viceChair->getId()}">{$viceChair->getUsername()|escape|wordwrap:15:" ":true}</a>
		</td>
		<td>{$viceChair->getFullName()|escape}</td>
		<td class="nowrap">
			{assign var=emailString value=$viceChair->getFullName()|concat:" <":$viceChair->getEmail():">"}
			{url|assign:"redirectUrl" path=$erc->getSectionId() escape=false}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$redirectUrl}
			{$viceChair->getEmail()|truncate:25:"..."|escape}&nbsp;{icon name="mail" url=$url}
		</td>
		<td align="right">
			{if $thisUser->getId() == $viceChair->getId()}&mdash;
			{else}
				<a href="{url op="unEnroll" path="512" userId=$viceChair->getId() journalId=$currentJournal->getId() sectionId=$erc->getSectionId()}" onclick="return confirm('{translate|escape:"jsparam" key="manager.people.confirmUnenroll"}')" class="action">{translate key="manager.people.unenroll"}</a>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="4" class="separator">&nbsp;</td>
	</tr>
{/foreach}
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
</table>
<p><br/></p>
<h4>{translate key="user.ercrole.ercMembers"}</h4>

<table width="100%" class="listing">
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="20%">{translate key="user.username" sort="username"}</td>
		<td width="30%">{translate key="user.name" sort="name"}</td>
		<td width="35%">{translate key="user.email" sort="email"}</td>
		<td width="150%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
		<td colspan="4" class="headseparator">&nbsp;</td>
	</tr>
	
{foreach from=$members item=member}
	<tr valign="top">
		<td>
			<a class="action" href="{url op="userProfile" path=$member->getId()}">{$member->getUsername()|escape|wordwrap:15:" ":true}</a>
		</td>
		<td>{$member->getFullName()|escape}</td>
		<td class="nowrap">
			{assign var=emailString value=$member->getFullName()|concat:" <":$member->getEmail():">"}
			{url|assign:"redirectUrl" path=$erc->getSectionId() escape=false}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$redirectUrl}
			{$member->getEmail()|truncate:25:"..."|escape}&nbsp;{icon name="mail" url=$url}
		</td>
		<td align="right">
			{if $thisUser->getId() == $member->getId()}&mdash;
			{else}
				<a href="{url op="unEnroll" path="4096" userId=$member->getId() journalId=$currentJournal->getId() sectionId=$erc->getSectionId()}" onclick="return confirm('{translate|escape:"jsparam" key="manager.people.confirmUnenroll"}')" class="action">{translate key="manager.people.unenroll"}</a>
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="4" class="separator">&nbsp;</td>
	</tr>
{/foreach}
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
</table>
{include file="common/footer.tpl"}