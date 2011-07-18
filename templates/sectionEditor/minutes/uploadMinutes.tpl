{include file="sectionEditor/minutes/menu.tpl"}
<h4>MINUTES OF MEETING <a href="{url op="viewMeeting" path=$meeting->getId()}">#{$meeting->getId()}</a></h4>
<div id="submissions">
{assign var="statusMap" value=$meeting->getStatusMap()}
{translate key="common.status"}: {$meeting->getStatusKey()}
<table class="listing" width="100%">
    <tr {if $statusMap.2 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(1)</td>
		<td width="80%" >
			{if $statusMap.2 == 0}
				<a href="{url op="uploadAnnouncements" path=$meeting->getId()}">{translate key="editor.minutes.announcements"}</a>
			{else}
				{translate key="editor.minutes.announcements"}
			{/if}					
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.1 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
    	<td width="10%">(2)</td>
		<td width="80%" >		
			{if $statusMap.2 == 0 || $statusMap.1 == 1}
				{translate key="editor.minutes.attendance"}
			{elseif $statusMap.1 == 0}
				<a href="{url op="uploadAttendance" path=$meeting->getId()}">{translate key="editor.minutes.attendance"}</a>
			{/if}
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.4 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(3)</td>
		<td width="80%" >
			{if $statusMap.1 == 0 || $statusMap.4 == 1}
				{translate key="editor.minutes.initialReviews"}
			{elseif $statusMap.4 == 0}
				<a href="{url op="selectInitialReview" path=$meeting->getId()}">{translate key="editor.minutes.initialReviews"}</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.8 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(4)</td>
		<td width="80%" >
			{if $statusMap.4 == 0 || $statusMap.8 == 1}
				{translate key="editor.minutes.rereviews"}
			{elseif $statusMap.8 == 0}
				<a href="{url op="selectRereview" path=$meeting->getId()}">{translate key="editor.minutes.rereviews"}</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.16 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(5)</td>
		<td width="80%" >
			{if $statusMap.8 == 0 || $statusMap.16 == 1}
				{translate key="editor.minutes.continuingReviews"}
			{elseif $statusMap.16 == 0}
				<a href="{url op="selectContinuingReview" path=$meeting->getId()}">{translate key="editor.minutes.continuingReviews"}</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.32 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(6)</td>
		<td width="80%" >
			{if $statusMap.16 == 0 || $statusMap.32 == 1}
				{translate key="editor.minutes.amendments"}
			{elseif $statusMap.32 == 0}
				<a href="{url op="selectAmendment" path=$meeting->getId()}">{translate key="editor.minutes.amendments"}</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.64 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(7)</td>
		<td width="80%" >
			{if $statusMap.32 == 0 || $statusMap.64 == 1}
				{translate key="editor.minutes.adverseEvents"}
			{elseif $statusMap.64 == 0}
				<a href="{url op="selectAdverseEvent" path=$meeting->getId()}">{translate key="editor.minutes.adverseEvents"}</a>
			{/if}			
		</td>
	</tr>
	<tr><td colspan="10"><div class="separator"></div></td></tr>
	<tr {if $statusMap.128 == 0} class="heading highlight" {else} class="heading" {/if} valign="bottom">
		<td width="10%">(8)</td>
		<td width="80%" >
			{if $statusMap.64 == 0 || $statusMap.128 == 1}
				{translate key="editor.minutes.informationItems"}
			{elseif $statusMap.128 == 0}
				<a href="{url op="informationItems" path=$meeting->getId()}">{translate key="editor.minutes.informationItems"}</a>
			{/if}			
		</td>		 
	</tr>		
</table>
</div>

{include file="common/footer.tpl"}
