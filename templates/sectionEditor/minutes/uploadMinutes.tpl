{include file="sectionEditor/minutes/menu.tpl"}
<h4>MINUTES OF MEETING #{$meeting->getId()}</h4>
<div id="submissions">

{assign var="statusMap" value=$meeting->getStatusMap()}
<table class="listing" width="100%">
    <tr {if $statusMap.2 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(1)</td>
		<td width="80%" >
			{if $statusMap.2 == 0}
				<a href="{url op="uploadAnnouncements" path=$meeting->getId()}">Announcements</a>
			{else}
				Announcements
			{/if}					
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.1 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
    	<td width="10%">(2)</td>
		<td width="80%" >		
			{if $statusMap.2 == 0 || $statusMap.1 == 1}
				Attendance
			{elseif $statusMap.1 == 0}
				<a href="{url op="uploadAttendance" path=$meeting->getId()}">Attendance</a>
			{/if}
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.4 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(3)</td>
		<td width="80%" >
			{if $statusMap.1 == 0 || $statusMap.4 == 1}
				Initial Reviews
			{elseif $statusMap.4 == 0}
				<a href="{url op="selectInitialReview" path=$meeting->getId()}">Initial Reviews</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.8 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(4)</td>
		<td width="80%" >
			{if $statusMap.4 == 0 || $statusMap.8 == 1}
				Continuing Reviews or Re-reviews
			{elseif $statusMap.8 == 0}
				<a href="{url op="selectRereview" path=$meeting->getId()}">Continuing Reviews or Re-reviews</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.16 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(5)</td>
		<td width="80%" >
			{if $statusMap.8 == 0 || $statusMap.16 == 1}
				Continuing Reviews
			{elseif $statusMap.16 == 0}
				<a href="{url op="selectContinuingReview" path=$meeting->getId()}">Continuing Reviews</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.32 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(6)</td>
		<td width="80%" >
			{if $statusMap.16 == 0 || $statusMap.32 == 1}
				Amendments
			{elseif $statusMap.32 == 0}
				<a href="{url op="selectAmendment" path=$meeting->getId()}">Amendments</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.64 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(7)</td>
		<td width="80%" >
			{if $statusMap.32 == 0 || $statusMap.64 == 1}
				Adverse Events
			{elseif $statusMap.64 == 0}
				<a href="{url op="selectAdverseEvent" path=$meeting->getId()}">Report of Adverse Events</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.128 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(8)</td>
		<td width="80%" >
			{if $statusMap.64 == 0 || $statusMap.128 == 1}
				Information Items
			{elseif $statusMap.128 == 0}
				<a href="{url op="informationItems" path=$meeting->getId()}">Information Items</a>
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
