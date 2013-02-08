{include file="sectionEditor/minutes/menu.tpl"}
<br/>
<h3>{translate key="reviewer.meetings.details}</h3>
<div class="separator"></div>
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
			<td class="label" width="20%">{translate key="editor.meetingStatus"}</td>
			<td class="value" width="80%">{$meeting->getStatusKey()}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutesStatus"}</td>
			<td class="value" width="80%">
				{$meeting->getMinutesStatusKey()}							
			</td>
		</tr>
	</table>
</div>
<br/>
<div id="sections">
{assign var="statusMap" value=$meeting->getStatusMap()}
<h3>Sections</h3>
<table class="listing" width="100%">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">Section No.</td>
		<td width="40%">{translate key="submissions.sec"}</td>
		<td width="10%">{translate key="common.status"}</td>
	<td width="30%" align="right">Action</td>	
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr valign="bottom">
		<td width="10%">(1)</td>
			<td width="40%">			
				{translate key="editor.minutes.attendance"}
			</td>
		{if $statusMap.1 == 1}
			<td width="10%">Done</td>
			<td width="30%" align="right">---</td>
		{elseif $statusMap.1 == 0}
			<td width="10%">Not Done</td>
			<td width="30%" align="right">
				<a href="{url op="uploadAttendance" path=$meeting->getId()}">{translate key="editor.minutes.uploadAttendance"}</a>				
			</td>				
		{/if}
	</tr>
	<tr><td colspan="6" class="separator">&nbsp;</td></tr>
	<tr valign="bottom">
		<td width="10%">(2)</td>
			 <td width="40%">			
				{translate key="editor.minutes.initialReviews"}
			</td>
		{if $statusMap.2 == 0 && $allowInitialReview}
			<td width="10%">Pending Submissions</td>
			<td width="30%" align="right">
				<a href="{url op="selectInitialReview" path=$meeting->getId()}">{translate key="editor.minutes.uploadInitialReviews"}</a>
			</td>				
		{else}
			<td width="10%">No Pending Submissions</td>
			<td width="30%" align="right">---</td>
		{/if}
	</tr>
	<tr><td colspan="6" class="separator">&nbsp;</td></tr>
	<tr valign="bottom">
		<td width="10%">(2)</td>
			 <td width="40%">			
				{translate key="editor.minutes.continuingReviews"}
			</td>
		{if $statusMap.8 == 0 && $allowContinuingReview}
			<td width="10%">Pending Submissions</td>
			<td width="30%" align="right">
				<a href="{url op="selectContinuingReview" path=$meeting->getId()}">{translate key="editor.minutes.uploadContinuingReviews"}</a>
			</td>				
		{else}
			<td width="10%">No Pending Submissions</td>
			<td width="30%" align="right">---</td>
		{/if}
	</tr>
	<tr><td colspan="6" class="endseparator">&nbsp;</td></tr>	
</table>
</div>
<br/>
{***
	<input type="button" value="{translate key="common.setFinal"}" class="button defaultButton" onclick="ans=confirm('This cannot be undone. Do you want to proceed?'); if(ans) document.location.href='{url op="setMinutesFinal" path=$meeting->getId() }'" />
***}
{if $meeting->isMinutesComplete()}
	<input type="button" value="{translate key="editor.minutes.setFinalAndDownload"}" class="button defaultButton" onclick="document.location.href='{url op="downloadMinutes" path=$meeting->getId() }'" />		
{/if}
<input type="button" class="button" onclick="document.location.href='{url op="meetings"}'" value="{translate key="common.back"}" />
{include file="common/footer.tpl"}
