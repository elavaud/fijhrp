{**
* setMeeting.tpl
* Added by MSB 7/5/2011
*
* Set a meeting
**}

{strip}
{assign var="pageTitle" value="editor.meetings.viewMeeting"}
{assign var="pageCrumbTitle" value="editor.meetings.viewMeeting"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li><a href="{url op="setMeeting"}">{translate key="editor.meetings.setMeeting"}</a></li>
</ul>

<div class="separator"></div>
<br/>
<div id="details">
<h3>{translate key="reviewer.meetings.details}</h3>
<div class="separator"></div>
<table width="100%" class="data">
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.meetings.meetingId"}</td>
		<td class="value" width="80%">{$meeting->getId()}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.meetings.meetingDate"}</td>
		<td class="value" width="80%">{$meeting->getDate()|date_format:"%Y-%m-%d %I:%M %p"}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="common.status"}</td>
		<td class="value" width="80%">{$meeting->getStatusKey()}</td>
	</tr>
</table>
</div>
<br>
<div id="submissions">
<h3>{translate key="editor.meetings.submissions"}</h3>
<table width="100%" class="listing">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">Proposal ID</td>
		<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<!-- <td width="5%">{translate key="submissions.sec"}</td> Commented out by MSB, Sept25,2011-->
		<td width="25%">{translate key="article.authors"}</td>
		<td width="35%">{translate key="article.title"}</td>
		<td width="25%" align="right">{translate key="common.status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	
	{foreach from=$submissions item=submission}
	{assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
	<tr valign="top">
		<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
		<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} -->
		<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *}  Commented out by MSB -->
   		<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->		
   		<td><a href="{url op="submission" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
		<td align="right">
			{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
			{translate key=$proposalStatusKey}
		</td>
	</tr>
	<tr><td colspan="6" class="separator"></td></tr>
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
<br>
<div id="reviewers">
	<h3>{translate key="editor.meetings.reviewers"}</h3>
	<table class="listing" width="100%">
		<tr><td colspan="3" class="headseparator" ></td></tr>
		<tr class="heading" valign="bottom">
			<td width="30%"> {translate key="editor.meetings.reviewer.name"}</td>
			<td width="50%"> {translate key="editor.meetings.reviewer.reply"} </td>
			<td width="20%" align="right"> {translate key="editor.meetings.reviewer.replyStatus"} </td>
		</tr>
		<tr><td colspan="3" class="headseparator" ></td></tr>
		{assign var=attendingReviewers value=0}
		{assign var=notAttendingReviewers value=0}
		{assign var=undecidedReviewers value=0}
		{foreach from=$reviewers item=reviewer}
		<tr>
			<td width="30%">
				{$reviewer->getSalutation()} &nbsp; {$reviewer->getFirstName()} &nbsp; {$reviewer->getLastName()}
				<br/>
				<a href="{url op="remindReviewersMeeting" meetingId=$meeting->getId() reviewerId=$reviewer->getReviewerId()}" class="action">Send Reminder</a>
				{$reviewer->getDateReminded()|date_format:$dateFormatShort}
			</td>
			<td width="50%">{$reviewer->getRemarks()}</td>
			<td width="20%" align="right">{$reviewer->getReplyStatus()}</td>

			{if $reviewer->getIsAttending() == 1 }
				<span style="display:none">{$attendingReviewers++}</span> 
			{elseif $reviewer->getIsAttending() == 2}
				<span style="display:none">{$notAttendingReviewers++}</span> 
			{else}
				<span style="display:none">{$undecidedReviewers++}</span> 
			{/if}
		</tr>
		<tr>
		<td colspan="3" class="separator"></td>
		</tr>
		{/foreach}
		{if empty($reviewers)}
		<tr>
			<td colspan="3" class="nodata">{translate key="editor.meetings.reviewer.noReviewers"}</td>
		</tr>
		{/if}
		<tr>
			<td colspan="3" class="endseparator">&nbsp;</td>
		</tr>
		{if !empty($reviewers)}
		<tr>
			<td colspan="3" align="left">{$reviewers|@count} reviewers(s)</td>
		</tr>
		{/if}
	</table>
</div>
<br>
<div>
<h3>{translate key="editor.meetings.tentativeAttendance}</h3>
<div class="separator"></div>
<table width="100%" class="data">
	<tr valign="top">
		<td class="label" width="40%">{translate key="editor.meetings.numberOfAttendingReviewers"}</td>
		<td class="value" width="60%">{$attendingReviewers}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="40%">{translate key="editor.meetings.numberOfNotAttendingReviewers"}</td>
		<td class="value" width="60%">{$notAttendingReviewers}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="40%">{translate key="editor.meetings.numberOfUndecidedReviewers"}</td>
		<td class="value" width="60%">{$undecidedReviewers}</td>
	</tr>
</table>
</div>
<p> {if $meeting->getStatus() == 1}
    <input type="button" value="Upload Minutes" class="button defaultButton" onclick="document.location.href='{url op="uploadMinutes" path=$meeting->getId()}'"/> 
	<input type="button" value="Cancel Meeting" class="button" onclick="ans=confirm('This cannot be undone. Do you want to proceed?'); if(ans) document.location.href='{url op="notifyReviewersCancelMeeting" path=$meeting->getId() }'" />
	{else}
		{if $meeting->getStatus() == 2 || $meeting->getStatus() == 4 }
		<input type="button" value="{translate key="common.setFinal"}" class="button defaultButton" onclick="ans=confirm('This cannot be undone. Do you want to proceed?'); if(ans) document.location.href='{url op="setMeetingFinal" path=$meeting->getId() }'" />
	    <input type="button" value="{translate key="common.edit"}" class="button defaultButton" onclick="document.location.href='{url op="setMeeting" path=$meeting->getId()}'" />
	   	{/if}
	   	{if $meeting->getStatus() == 5}
		<input type="button" value="{translate key="editor.minutes.downloadMinutes"}" class="button defaultButton" onclick="document.location.href='{url op="downloadMinutes" path=$meeting->getId()}'" />
	   	{/if}
   	{/if}
   	<input type="button" value="{translate key="common.back"}" class="button" onclick="document.location.href='{url op="meetings"}'" />
	
{include file="common/footer.tpl"}
