{strip}
{assign var="pageTitle" value="common.queue.long.minutes"}
{url|assign:"currentUrl" page="sectionEditor"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="index" path="submissionsInReview"}">{translate key="common.queue.short.submissionsInReview"}</a></li>
	<li class="current"><a href="{url op="minutes"}">Upload Minutes</a></li>
	<li><a href="{url op="index" path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
</ul>
 
<div id="submissions">
<table class="listing" width="100%">
        <tr><td colspan="6"> 
        	<form method="post" action="{url op="createMinutes"}">
        		UPLOADED MINUTES OF MEETING &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
        		<input type="submit" name="createMinutesSubmit" class="button" value="Create New Minutes" /><br/>        		
        	</form>
        </td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">Meeting ID</td>
		<td width="25%" align="right">Meeting Date</td>
		<td width="35%" align="right">Status</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{foreach from=$meetings item=meeting}
	<tr class="heading" valign="bottom">
		<td width="5%">{$meeting->getId()}</td>
		<td width="25%" align="right">{$meeting->getDate()|date_format:$dateFormatShort}</td>
		<td width="35%" align="right"><a href="{url op="uploadMinutes" path=$meeting->getId()}">{$meeting->getStatusKey()}</a></td>
		{assign var="count" value=$count+1}
	</tr>	
{/foreach}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">No meetings uploaded</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} meetings(s) uploaded</td>
	</tr>
{/if}
</table>
</div>

{include file="common/footer.tpl"}
