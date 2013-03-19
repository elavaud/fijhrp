{**
* setMeeting.tpl
* Added by MSB 7/5/2011
*
* Set a meeting
* Last modified EL on February 2013
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
<h3>{translate key="editor.meetings.details"}</h3>
<div class="separator"></div>
<table width="100%" class="data">
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.meetings.meetingId"}</td>
		<td class="value" width="80%">{$meeting->getId()}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.meetings.meetingDate"}</td>
		<td class="value" width="80%">{$meeting->getDate()|date_format:$dateFormatLong}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.article.meetingLength"}</td>
		<td class="value" width="80%">{$meeting->getLength()} mn</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.article.meetingLocation"}</td>
		<td class="value" width="80%">{$meeting->getLocation()}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="common.status"}</td>
		<td class="value" width="80%">{$meeting->getStatusKey()}</td>
	</tr>
</table>
</div>
<br>
<div id="submissions">
<h3>{translate key="editor.meetings.proposals"}</h3>
<table width="100%" class="listing">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">Proposal ID</td>
		<td width="5%">{translate key="submissions.submit"}</td>
		<td width="25%">{translate key="article.authors"}</td>
		<td width="35%">{translate key="article.title"}</td>
		<td width="25%" align="right">{translate key="common.status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	
	{foreach from=$submissions item=submission}
	{assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
	<tr valign="top">
		<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
   		<td>{$submission->getFirstAuthor()|truncate:40:"..."|escape}</td> 
   		<td><a href="{url op="submission" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html}</a></td>
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
		<td colspan="6" align="left">{$submissions|@count} {translate key="article.article.s"}</td>
	</tr>
</table>
</div>
<br>
<div id="users">
	<h3>{translate key="editor.meetings.guests"}</h3>
	<table class="listing" width="100%">
		<tr><td colspan="5" class="headseparator" ></td></tr>
		<tr class="heading" valign="bottom">
			<td width="20%"> {translate key="editor.meetings.user.name"}</td>
			<td width="20%"> {translate key="editor.meetings.user.functions"}</td>
			<td width="30%"> {translate key="editor.meetings.user.reply"} </td>
			<td width="15%"> {translate key="editor.meetings.user.replyStatus"} </td>
			<td width="15%" align="right"> {translate key="common.action"} </td>
		</tr>
		<tr><td colspan="5" class="headseparator" ></td></tr>
		{assign var=attendingGuests value=0}
		{assign var=notAttendingGuests value=0}
		{assign var=undecidedGuests value=0}
		{foreach from=$users item=user}
		<tr>
			<td width="20%">
				{$user->getSalutation()} &nbsp; {$user->getFirstName()} &nbsp; {$user->getLastName()}
				<br/>
				<a href="{url op="remindUserMeeting" meetingId=$meeting->getId() addresseeId=$user->getUserId()}" class="action">Send Reminder</a>
				{$user->getDateReminded()|date_format:$dateFormatShort}
			</td>
			<td width="20%">{$user->getFunctions()}</td>
			<td width="30%">{if $user->getRemarks() == null}&mdash;{else}{$user->getRemarks()}{/if}</td>
			<td width="15%">{$user->getReplyStatus()}</td>
			<td width="15%" align="right">
				<a href="{url op="replyAttendanceForUser" path=$meeting->getId()|to_array:$user->getUserId():1}">{translate key="editor.meetings.user.available"}</a>
				<br/><a href="{url op="replyAttendanceForUser" path=$meeting->getId()|to_array:$user->getUserId():2}">{translate key="editor.meetings.user.unavailable"}</a>
			</td>

			{if $user->getIsAttending() == 1 }
				<span style="display:none">{$attendingGuests++}</span> 
			{elseif $user->getIsAttending() == 2}
				<span style="display:none">{$notAttendingGuests++}</span> 
			{else}
				<span style="display:none">{$undecidedGuests++}</span> 
			{/if}
		</tr>
		<tr>
		<td colspan="5" class="separator"></td>
		</tr>
		{/foreach}
		{if empty($users)}
		<tr>
			<td colspan="5" class="nodata">{translate key="editor.meetings.user.noGuests"}</td>
		</tr>
		{/if}
		<tr>
			<td colspan="5" class="endseparator">&nbsp;</td>
		</tr>
		{if !empty($users)}
		<tr>
			<td colspan="5" align="left">{$users|@count} users(s)</td>
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
		<td class="label" width="40%">{translate key="editor.meetings.numberOfAttendingGuests"}</td>
		<td class="value" width="60%">{$attendingGuests}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="40%">{translate key="editor.meetings.numberOfNotAttendingGuests"}</td>
		<td class="value" width="60%">{$notAttendingGuests}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="40%">{translate key="editor.meetings.numberOfUndecidedGuests"}</td>
		<td class="value" width="60%">{$undecidedGuests}</td>
	</tr>
</table>
</div>
<p> {if $meeting->getStatus() == 1}
    <input type="button" value="Upload Minutes" class="button defaultButton" onclick="document.location.href='{url op="uploadMinutes" path=$meeting->getId()}'"/> 
	<input type="button" value="Cancel Meeting" class="button" onclick="ans=confirm('This cannot be undone. Do you want to proceed?'); if(ans) document.location.href='{url op="cancelMeeting" path=$meeting->getId() }'" />
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
