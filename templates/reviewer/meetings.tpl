{**
 * Meetings page template
 * Added by ayveemallare 7/6/2011
 **}

{strip}
{assign var="pageTitle" value="reviewer.meetings"}
{assign var="pageCrumbTitle" value="reviewer.meetings"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li class="current"><a href="{url op="meetings"}">{translate key="reviewer.meetings"}</a></li>
</ul>

<div id="meetings">
	<table class="listing" width="100%">
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		<tr class="heading" valign="bottom">
			<td width="5%">{sort_heading key="editor.meetings.meetingId" sort="id"}</td>
			<td>{translate key="reviewer.meetings.submissions"}</td>
			<td width="25%" align="right">{sort_heading key="editor.meetings.meetingDate" sort="meetingDate"}</td>
			<td width="30%" align="right">{sort_heading key="reviewer.meetings.replyStatus" sort="replyStatus"}</td>
		</tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<p></p>
	{assign var="count" value=0}
	{foreach from=$meetings item=meeting}
	{assign var="key" value=$meeting->getId()}
		<tr class="heading" valign="bottom">
			<td width="5%">{$meeting->getId()}</td>
			<td {if empty($map.$key)} class="nodata"{/if}>
				{foreach from=$map.$key item=submission name=submissions}
					{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:20:"..."}
					{if $smarty.foreach.submissions.last}{else},&nbsp;{/if}
				{/foreach}
				{if empty($map.$key)}
					{translate key="reviewer.meetings.noSubmissions"}
				{/if}
				
			</td>
			<td width="25%" align="right">{$meeting->getDate()|date_format:"%Y-%m-%d %I:%M %p"}</td>
			<td width="30%" align="right">
				<a href="{url op="viewMeeting" path=$meeting->getId()}" class="action">
					{$meeting->getReplyStatus()}
				</a>
			</td>
			{assign var="count" value=$count+1}
		</tr>	
	{/foreach}
	{if $count==0}
		<tr>
			<td colspan="6" class="nodata">{translate key="editor.meetings.noMeetings"}</td>
		</tr>
		<tr>
			<td colspan="6" class="endseparator">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" class="endseparator">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" align="left">{$count} {translate key="editor.meetings.meetingsCount"}</td>
		</tr>
	{/if}
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	</table>
	
<br/><br/>
</div>

{include file="common/footer.tpl"}
