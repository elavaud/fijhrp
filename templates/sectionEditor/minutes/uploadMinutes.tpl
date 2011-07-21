{include file="sectionEditor/minutes/menu.tpl"}
<br/>
<h2>{translate key="reviewer.meetings.details}</h2>
<div id="details">
	<table width="100%" class="data">
		<tr>
			<td class="label" width="20%">{translate key="editor.meetings.meetingId"}</td>
			<td class="value" width="80%"><a href="{url op="viewMeeting" path=$meeting->getId()}">#{$meeting->getId()}</a></td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.meetings.meetingDate"}</td>
			<td class="value" width="80%">{$meeting->getDate()|date_format:$dateFormatTrunc}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="common.status"}</td>
			<td class="value" width="80%">{$meeting->getStatusKey()}</td>
		</tr>
		
	</table>
</div>
<div class="separator"></div>
<br/>
<div id="sections">
{assign var="statusMap" value=$meeting->getStatusMap()}
<h2>Sections</h2>
<table class="listing" width="100%">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<td width="10%">Section No.</td>
	<td width="40%">{translate key="submissions.sec"}</td>
	<td width="10%">{translate key="common.status"}</td>
	<td width="30%" align="right">Action</td>
	{$statusMap.1}
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr valign="bottom">
		<td width="10%">(1)</td>
		{if $statusMap.1 == 1}
			<td width="40%">			
				<a href="{url op="viewMinutes" path=$meeting->getId()}">{translate key="editor.minutes.attendance"}</a>
			</td>
			<td width="10%">Done</td>
			<td width="30%" align="right">---</td>
		{elseif $statusMap.1 == 0}
			<td width="40%">
				<a href="{url op="uploadAttendance" path=$meeting->getId()}">{translate key="editor.minutes.attendance"}</a>
			</td>
			<td width="10%">Not Done</td>
			<td width="30%" align="right">
				<a href="{url op="uploadAttendance" path=$meeting->getId()}">{translate key="editor.minutes.uploadAttendance"}</a>				
			</td>				
		{/if}
	</tr>
	<tr><td colspan="6" class="endseparator">&nbsp;</td></tr>
	<tr valign="bottom">
		<td width="10%">(2)</td>
		{if $statusMap.1 == 0}
			<td width="40%">			
				{translate key="editor.minutes.initialReviews"}
			</td>
			<td width="10%">Not Done</td>
			<td width="30%" align="right"><a href="{url op="completeInitialReviews" path=$meeting->getId()}">{translate key="editor.minutes.completeInitialReviews"}</a></td>
		{elseif $statusMap.2 == 1}
			 <td width="40%">			
				{translate key="editor.minutes.initialReviews"}
			</td>
			<td width="10%">Done</td>
			<td width="30%" align="right">---</td>
		{elseif $statusMap.2 == 0}
			<td width="40%">
				<a href="{url op="selectInitialReview" path=$meeting->getId()}">{translate key="editor.minutes.initialReviews"}</a>
			</td>
			<td width="10%">Not Done</td>
			<td width="30%" align="right">
				<a href="{url op="selectInitialReviews" path=$meeting->getId()}">{translate key="editor.minutes.uploadInitialReviews"}</a><br/>
				<a href="{url op="completeInitialReviews" path=$meeting->getId()}">{translate key="editor.minutes.completeInitialReviews"}</a>
			</td>				
		{/if}
	</tr>
	<tr><td colspan="6" class="endseparator">&nbsp;</td></tr>	
</table>
</div>
<br/>
<input type="button" value="Save Minutes" class="button defaultButton" onclick="document.location.href='{url op="submitMinute" path=$meeting->getId()}'"/>
{include file="common/footer.tpl"}
