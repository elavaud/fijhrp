{**
 * Meetings page template
 * Added by ayveemallare7/5/2011
 **}

{strip}
{assign var="pageTitle" value="editor.meetings"}
{url|assign:"currentUrl" page="sectionEditor"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li class="current"><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li><a>{translate key="editor.meetings.setMeeting"}</a></li>
	<li><a href="{url op="minutes"}">{translate key="editor.meetings.uploadMinutes"}</a></li>
</ul>

<br/><br/>
<div id="meetings">
{assign var="status" value=0}
{section name="section" loop=4}
	<table class="listing" width="50%">
		{if $status==0} 
			<tr><td colspan="6">PROPOSED</td></tr>
		{/if}
		{if $status==1} 
			<tr><td colspan="6">FINALIZED</td></tr>
		{/if}
		{if $status==2} 
			<tr><td colspan="6">DONE</td></tr>
		{/if}
		{if $status==3} 
			<tr><td colspan="6">CANCELLED</td></tr>
		{/if}
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		<tr class="heading" valign="bottom">
			<td width="5%">{translate key="editor.meetings.meetingId"}</td>
			<td width="25%" align="right">{translate key="editor.meetings.meetingDate"}</td>
		</tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<p></p>
	{assign var="count" value=0}
	{foreach from=$meetings item=meeting}
		<tr class="heading" valign="bottom">
			<td width="5%">{$meeting->getId()}</td>
			<td width="25%" align="right">{$meeting->getDate()|date_format:$dateFormatShort}</td>
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
	{else}
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
	{assign var="status" value=$status+1}
{/section}
</div>

<h2>{translate key="editor.meetings.setNewMeeting"}</h2>
<a href="{url op="setMeeting"}">{translate key="editor.meetings.clickHere"}</a>&nbsp;{translate key="editor.meetings.toSetNewMeeting"}
{include file="common/footer.tpl"}
