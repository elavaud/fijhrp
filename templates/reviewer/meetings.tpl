{**
 * meetigns.tpl
 *
 * Reviewer index.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="common.queue.long.meetingList"}
{include file="common/header.tpl"}
{/strip}

{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}
<ul class="menu">
	<li class="current"><a href="{url op="meetings"}">{translate key="common.queue.short.meetingList"}</a></li>
	{if $isReviewer}
		<li><a href="{url op="proposalsFromMeetings"}">{translate key="common.queue.short.meetingProposals"}</a></li>
	{/if}
</ul>

<div class="separator"></div>
<br/>
{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}

<form method="post" name="submit" action="{url op="meetings"}">
<div id="search">
	<table align="left">
		<tr>
			<td>{translate key="editor.meetings"}</td>
			<td>
			<select name="status" size="1"  class="selectMenu" >
				<option value="">{translate key="common.all"}</option>
				<option value="1" {if $status==1}selected{/if}>{translate key="reviewer.meetings.scheduleStatus.final"}</option>
				<option value="2" {if $status==2}selected{/if}>{translate key="reviewer.meetings.scheduleStatus.rescheduled"}</option>
				<option value="3" {if $status==3}selected{/if}>{translate key="reviewer.meetings.scheduleStatus.cancelled"}</option>
				<option value="4" {if $status==4}selected{/if}>{translate key="reviewer.meetings.scheduleStatus.new"}</option>
				<option value="5" {if $status==5}selected{/if}>{translate key="common.done"}</option>
			</select>
			</td>
			<td>Reply</td>
			<td>
			<select name="replyStatus" size="1"  class="selectMenu" >
				<option value="">{translate key="common.all"}</option>
				<option value="1" {if $replyStatus==1}selected{/if}>{translate key="reviewer.meetings.replyStatus.attending"}</option>
				<option value="2" {if $replyStatus==2}selected{/if}>{translate key="reviewer.meetings.replyStatus.notAttending"}</option>
				<option value="3" {if $replyStatus==3}selected{/if}>{translate key="reviewer.meetings.replyStatus.awaitingReply"}</option>
			</select></td>
			</tr>
			<tr>
			<td class="label">{translate key="search.dateFrom"}</td>
			<td class="value">{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}</td>
			<td class="label">{translate key="search.dateTo"}</td>
			<td class="value">
				{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
				<input type="hidden" name="dateToHour" value="23" />
				<input type="hidden" name="dateToMinute" value="59" />
				<input type="hidden" name="dateToSecond" value="59" />
			</td>
			<td>
			
		</td>
		</tr>
	</table>
</div><br/><br/><br/>
<p align="left"><input type="submit" class="button defaultButton" value="{translate key="common.search"}"/></p>
</form>
<div id="meetings">
	<table class="listing" width="100%">
		<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		<tr class="heading" valign="bottom">
			<td width="5%">{sort_heading key="editor.meeting.id" sort="id"}</td>
			<td width="40%">{translate key="reviewer.meetings.submissions"}</td>
			<td width="25%" align="right">{sort_heading key="editor.meeting.schedule" sort="meetingDate"}</td>
			<td width="15%" align="right">{sort_heading key="editor.meeting.scheduleStatus" sort="scheduleStatus"}</td>
			<td width="15%" align="right">{sort_heading key="reviewer.meetings.replyStatus" sort="replyStatus"}</td>
		</tr>
		<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
	<p></p>
	{iterate from=meetings item=meeting}
	{assign var="key" value=$meeting->getId()}
		<tr class="heading" valign="bottom">
			<td width="5%">{$meeting->getPublicId()}</td>
			<td width="40%">
				<a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">
				{foreach from=$map.$key item=submission name=submissions}
					{assign var="abstract" value=$submission->getLocalizedAbstract()}
					&#9679;&nbsp;{$abstract->getScientificTitle()|strip_unsafe_html}
					{if $smarty.foreach.submissions.last}{else}<br/>{/if}
				{/foreach}
				</a>
				{if empty($map.$key)}
					<i>{translate key="reviewer.meetings.noSubmissions"}</i>
				{/if}
			</td>
			<td width="25%" align="right">
				{$meeting->getDate()|date_format:$datetimeFormatLong}</td>
			<td width="15%" align="right">
				{$meeting->getStatusKey()}
			</td>
			<td width="15%" align="right">
				<a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">
					{$meeting->getReplyStatus()}
				</a>
			</td>
		</tr>	
		<tr>
			<td colspan="5" class="{if $meetings->eof()}end{/if}separator">&nbsp;</td>
		</tr>
	{/iterate}
	{if $meetings->wasEmpty()}
		<tr>
			<td colspan="5" class="nodata">{translate key="editor.meetings.noMeetings"}</td>
		</tr>
	<tr>
		<td colspan="5" class="endseparator">&nbsp;</td>
	</tr>
	{else}
		<tr>
			<td colspan="2" align="left">{page_info iterator=$meetings}</td>
			<td colspan="2" align="right">{page_links anchor="meetings" name="meetings" iterator=$meetings sort=$sort sortDirection=$sortDirection}</td>
		</tr>
	{/if}
	</table>
<br/><br/>
</div>

{include file="common/footer.tpl"}
