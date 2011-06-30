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
<br/>

<h4>MINUTES OF MEETING #{$meeting->getId()}</h4>
<div id="submissions">

{assign var="statusMap" value=$meeting->getStatusMap()}
<table class="listing" width="100%">
    <tr {if $statusMap.1 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
    	<td width="10%">(1)</td>
		<td width="80%" >		
			{if $statusMap.1 == 0}
				<a href="{url op="uploadAttendance" path=$meeting->getId()}">Attendance</a>
			{else}
				Attendance
			{/if}
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.2 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(2)</td>
		<td width="80%" >
			{if $statusMap.1 == 0}
				Meeting Details and Announcements
			{elseif $statusMap.2 == 0}
				<a href="{url op="uploadAnnouncements" path=$meeting->getId()}">Meeting Details and Announcements</a>
			{else}
				Meeting Details and Announcements
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.4 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(3)</td>
		<td width="80%" >
			{if $statusMap.2 == 0}
				Initial Reviews
			{elseif $statusMap.4 == 0}
				<a href="{url op="selectInitialReview" path=$meeting->getId()}">Initial Reviews</a>
			{else}
				Initial Reviews
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.8 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(4)</td>
		<td width="80%" >
			{if $statusMap.4 == 0}
				Continuing Reviews or Re-reviews
			{elseif $statusMap.8 == 0}
				<a href="{url op="selectRereview" path=$meeting->getId()}">Continuing Reviews or Re-reviews</a>
			{else}
				Continuing Reviews or Re-reviews
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.16 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(5)</td>
		<td width="80%" >
			{if $statusMap.8 == 0}
				Continuing Reviews
			{elseif $statusMap.16 == 0}
				<a href="{url op="selectContinuingReview" path=$meeting->getId()}">Continuing Reviews</a>
			{else}
				Continuing Reviews
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.32 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(6)</td>
		<td width="80%" >
			{if $statusMap.16 == 0}
				Amendments
			{elseif $statusMap.32 == 0}
				<a href="{url op="selectAmendment" path=$meeting->getId()}">Amendments</a>
			{else}
				Amendments
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.64 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(7)</td>
		<td width="80%" >
			{if $statusMap.32 == 0}
				Adverse Events
			{elseif $statusMap.64 == 0}
				<a href="{url op="selectAdverseEvent" path=$meeting->getId()}">Report of Adverse Events</a>
			{else}
				Adverse Events
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.128 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(8)</td>
		<td width="80%" >
			{if $statusMap.64 == 0}
				Information Items
			{elseif $statusMap.128 == 0}
				<a href="{url op="informationItems" path=$meeting->getId()}">Information Items</a>
			{else}
				Information Items
			{/if}			
		</td>		 
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%" ><a href="{url op="minutes"}">Back to list of minutes</a></td>		 
	</tr>
</table>
</div>

{include file="common/footer.tpl"}
