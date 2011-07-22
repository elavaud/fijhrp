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
	<li class="current"><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li><a href="{url op="setMeeting"}">{translate key="editor.meetings.setMeeting"}</a></li>
</ul>

<div id="meetings">
<table class="listing" width="100%">
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">{sort_heading key="editor.meetings.meetingId" sort="id"}</td>
		<td width="40%">{translate key="reviewer.meetings.submissions"}</td>
		<td width="25%" align="right">{sort_heading key="editor.meetings.meetingDate" sort="meetingDate"}</td>
		<td width="30%" align="right">{sort_heading key="common.status" sort="scheduleStatus"}</td>
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<p></p>
	{iterate from=meetings item=meeting}
	{assign var="key" value=$meeting->getId()}
		<tr class="heading" valign="bottom">
			<td width="5%">{$meeting->getId()}</td>
			<td width="40%">
				<a href="{url op="viewMeeting" path=$meeting->getId()}">
				{foreach from=$map.$key item=submission name=submissions}
					{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:20:"..."}
					{if $smarty.foreach.submissions.last}{else},&nbsp;{/if}
				{/foreach}
				{if empty($map.$key)}
					<i>{translate key="reviewer.meetings.noSubmissions"}</i>
				{/if}
				</a>
			</td>
			<td width="25%" align="right">
				{$meeting->getDate()|date_format:"%Y-%m-%d %I:%M %p"}
			</td>
			<td width="30%" align="right">
				<a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">
					{$meeting->getStatusKey()}
				</a>
				{if $meeting->getStatus() == 1}
				<br/><a href="{url op="uploadMinutes" path=$meeting->getId()}" class="action">
					Upload Minutes
				</a>
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
<h2>{translate key="editor.meetings.setNewMeeting"}</h2>
<a href="{url op="setMeeting"}">{translate key="editor.meetings.clickHere"}</a>&nbsp;{translate key="editor.meetings.toSetNewMeeting"}
{include file="common/footer.tpl"}
