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
{translate|assign:"pageTitleTranslated" key="submission.page.review" id=$meetingId}
{assign var="pageCrumbTitle" value="reviewer.meetings"}
{include file="common/header.tpl"}
{/strip}

<div id="details">
<h3>Details</h3>
<table width="100%" class="data">
<tr valign="top">
	<td class="label" width="20%">Meeting ID</td>
	<td class="value" width="80%">{$meeting->getId()}</td>
</tr>
<tr valign="top">
	<td class="label" width="20%">Editor/Moderator</td>
	<td class="value" width="80%">{$editor->getFirstName()}&nbsp;{$editor->getLastName()}</td>
</tr>
<tr valign="top">
	<td class="label" width="20%">Proposed Date and Time</td>
	<td class="value" width="80%">{$meeting->getDate()|date_format:"%Y-%m-%d %I:%M %p"}</td>
</tr>
</table>
</div>


<div class="separator"></div>
<div id="reply">
<h3>Reply</h3>
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