{**
 * Meetings page templated
 * Added by ayveemallare7/5/2011
 **}

{strip}
{assign var="pageTitle" value="editor.meetings"}
{assign var="pageCrumbTitle" value="reviewer.meetings"}
{include file="common/header.tpl"}
{/strip}
<ul class="menu">
	<li><a class="action" href="{url op="index"}">{translate key="article.articles"}</a></li>
	<li><a class="action" href="{url op="section" path=$ercId}">{translate key="section.sectionAbbrev"}</a></li>
	<li class="current"><a class="action" href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
</ul>
<ul class="menu">
	<li class="current"><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li><a href="{url op="setMeeting"}">{translate key="editor.meetings.setMeeting"}</a></li>
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
			<td>Minutes</td>
			<td>
			<select name="minutesStatus" size="1"  class="selectMenu" >
				<option value="">{translate key="common.all"}</option>
				<option value="128" {if $minutesStatus==128}selected{/if}>{translate key="editor.minutes.complete"}</option>
				<option value="256" {if $replyStatus==256}selected{/if}>{translate key="editor.minutes.incomplete"}</option>
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
<div class="separator"></div>
<h4>{translate key="editor.meetings.setMeeting"}</h4>
<a href="{url op="setMeeting"}">{translate key="editor.meetings.clickHere"}</a>&nbsp;{translate key="editor.meetings.toSetNewMeeting"}
<br/>
<br/>
<div id="meetings">
<table class="listing" width="100%">
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">{sort_heading key="editor.meeting.id" sort="id"}</td>
		<td width="70%">{translate key="reviewer.meetings.submissions"}</td>
		<td width="15%" align="right">{sort_heading key="editor.meeting.schedule" sort="meetingDate"}</td>
		<td width="10%" align="right">{sort_heading key="common.status" sort="scheduleStatus"}</td>
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<p></p>
	{iterate from=meetings item=meeting}
	{assign var="key" value=$meeting->getId()}
		<tr class="heading" valign="bottom">
			<td width="5%" valign="middle">{$meeting->getPublicId()}</td>
			<td width="40%">
				<a href="{url op="viewMeeting" path=$meeting->getId()}">
				{foreach from=$map.$key item=submission name=submissions}
					{assign var="abstract" value=$submission->getLocalizedAbstract()}
					&#9679;&nbsp;{$abstract->getScientificTitle()|strip_unsafe_html}
					{if $smarty.foreach.submissions.last}{else}<br/>{/if}
				{/foreach}
				{if empty($map.$key)}
					<i>{translate key="reviewer.meetings.noSubmissions"}</i>
				{/if}
				</a>
			</td>
			<td width="25%" align="right" valign="middle">
				{$meeting->getDate()|date_format:$datetimeFormatLong}
			</td>
			<td width="30%" align="right" valign="middle">
				<a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">
					{$meeting->getStatusKey()}
				</a>
				{if $meeting->isMinutesComplete()}
						<br/><a href="{url op="downloadMinutes" path=$meeting->getId()}" class="action">
						{translate key="editor.minutes.downloadMinutes"}</a>
				{elseif $meeting->getStatus() == 1}
						<br/><a href="{url op="manageMinutes" path=$meeting->getId()}" class="action">
						{translate key="editor.minutes.manage"}</a>
				{/if}
			</td>
		</tr>	
		<tr>
			<td colspan="4" class="{if $meetings->eof()}end{/if}separator">&nbsp;</td>
		</tr>
	{/iterate}
	{if $meetings->wasEmpty()}
		<tr>
			<td colspan="4" class="nodata">{translate key="editor.meetings.noMeetings"}</td>
		</tr>
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
	{else}
		<tr>
			<td colspan="2" align="left">{page_info iterator=$meetings}</td>
			<td colspan="2" align="right">{page_links anchor="meetings" name="meetings" iterator=$meetings sort=$sort sortDirection=$sortDirection}</td>
		</tr>
	{/if}
	</table>
</div>
<br />

{include file="common/footer.tpl"}
