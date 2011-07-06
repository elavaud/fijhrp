{**
 * Meetings page template
 * Added by ayveemallare 7/6/2011
 **}

{strip}
{assign var="pageTitle" value="reviewer.meetings"}
{assign var="pageCrumbTitle" value="user.role.reviewer"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li class="current"><a href="{url op="meetings"}">{translate key="reviewer.meetings"}</a></li>
</ul>

<div id="meetings">
{assign var="status" value=0}
	<table class="listing" width="50%">
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
</div>

{include file="common/footer.tpl"}
