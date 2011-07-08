{**
 * viewMeeting.tpl
 *
 * Show the view meeting for reviewer page.
 *
 *
 * $Id$
 *}
{strip}
{assign var="meetingId" value=$meeting->getId()}
{translate|assign:"pageTitleTranslated" key="reviewer.meeting" id=$meetingId}
{assign var="pageCrumbTitle" value="reviewer.meeting"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="meetings"}">{translate key="reviewer.meetings"}</a></li>
</ul>

<div class="separator"></div>
<div id="details">
<h2>{translate key="reviewer.meetings.details}</h2>
<table width="100%" class="data">
<tr valign="top">
	<td class="label" width="20%">{translate key="editor.meetings.meetingId"}</td>
	<td class="value" width="80%">{$meeting->getId()}</td>
</tr>
<tr valign="top">
	<td class="label" width="20%">{translate key="reviewer.meetings.editor"}</td>
	<td class="value" width="80%">{$editor->getFirstName()}&nbsp;{$editor->getLastName()}</td>
</tr>
<tr valign="top">
	<td class="label" width="20%">{translate key="editor.meetings.meetingDate"}</td>
	<td class="value" width="80%">{$meeting->getDate()|date_format:"%Y-%m-%d %I:%M %p"}</td>
</tr>
<tr valign="top">
	<td class="label" width="20%">{translate key="reviewer.meetings.scheduleStatus"}</td>
	<td class="value" width="80%">{$meeting->getScheduleStatus()}</td>
</tr>
</table>
</div>
<div class="separator"></div>
<div id="submissions">
<h2>{translate key="reviewer.meetings.submissions"}</h2>
<table width="100%" class="listing">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<td width="10%">WHO Proposal ID</td>
	<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
	<td width="5%">{sort_heading key="submissions.sec" sort="section"}</td>
	<td width="25%">{sort_heading key="article.authors" sort="authors"}</td>
	<td width="35%">{sort_heading key="article.title" sort="title"}</td>
	<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	
	{foreach from=$submissions item=submission}
	{assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
	{assign var="key" value=$submission->getId()}
	<tr valign="top">
		<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
		<td>{$submission->getSectionAbbrev()|escape}</td>
		<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
		<td><a href="{url op="submission" path=$map.$key}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
		<td align="right">
			{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
			{translate key=$proposalStatusKey}
		</td>
	</tr>
	{/foreach}
	
	{if empty($submissions)}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	{/if}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$submissions|@count} submission(s)</td>
	</tr>
</table>
</div>
<br/>
<div class="separator"></div>
<div id="reply">
<h2>{translate key="reviewer.meetings.reply"}</h2>
<form method="post" action="{url op="replyMeeting"}" >
<table width="100%" class="data">
<tr valign="top">
	<td class="label" width="20%">{translate key="reviewer.article.schedule.isAttending"} </td>
	<td class="value" width="80%">	
		<input type="radio" name="isAttending" id="acceptMeetingSchedule" value="1" {if  $meeting->getIsAttending() == 1 } checked="checked"{/if} > </input> Yes
		<input type="radio" name="isAttending" id="regretMeetingSchedule" value="2" {if  $meeting->getIsAttending() == 2 } checked="checked"{/if} > </input> No
		<input type="radio" name="isAttending" id="undecidedMeetingSchedule" value="0" {if  $meeting->getIsAttending() == 0 } checked="checked"{/if} > </input> Undecided
	</td>
</tr> 
<tr>
	<td class="label" width="20%">{translate key="reviewer.article.schedule.remarks"} </td>
	<td class="value" width="80%">
		<textarea class="textArea" name="remarks" id="proposedDate" rows="5" cols="40" />{$meeting->getRemarks()|escape}</textarea>
	</td>
</tr>
<tr>
	<td class="label"></td>
	<td class="value">
		<input type="hidden" id="meetingId" name="meetingId" value={$meetingId}> </input>
		<input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url page="user" escape=false}'" />
	</td>
</tr>
</table>
</form>
</div>
{include file="common/footer.tpl"}