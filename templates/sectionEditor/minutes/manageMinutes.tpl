{include file="sectionEditor/minutes/menu.tpl"}

{literal}
<script type="text/javascript">

function checkSize(){
	var fileToUpload = document.getElementById('uploadMinutesFile');
	var check = fileToUpload.files[0].fileSize;
	var valueInKb = Math.ceil(check/1024);
	if (check > 5242880){
		alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
		return false
	}
}

</script>
{/literal}

<br/>
<h3>{translate key="editor.meeting.details"}</h3>
<div class="separator"></div>
<div id="details">
	<table width="100%" class="data">
		<tr>
			<td class="label" width="20%">{translate key="editor.meeting.id"}</td>
			<td class="value" width="80%"><a href="{url op="viewMeeting" path=$meeting->getId()}">#{$meeting->getPublicId()}</a></td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.meeting.schedule"}</td>
			<td class="value" width="80%">{$meeting->getDate()|date_format:$dateFormatLong}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.meeting.status"}</td>
			<td class="value" width="80%">{$meeting->getStatusKey()}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.status"}</td>
			<td class="value" width="80%">
				{$meeting->getMinutesStatusKey()}							
			</td>
		</tr>
	</table>
</div>
<br/>
<div id="sections">
{assign var="statusMap" value=$meeting->getStatusMap()}
<h3>{translate key="editor.minutes.files"}</h3>
<div class="separator"></div>
<p><strong><br/>{translate key="editor.minutes.attendance"}</strong></p>
<table class="listing" width="100%">
	<tr><td colspan="2" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="20%">{translate key="common.type"}</td>
		<td width="80%">
			<table width="100%">
				<tr>
					<td width="70%">{translate key="common.file.s"}</td>
					<td width="30%" align="right">{translate key="common.action"}</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td colspan="2" class="headseparator">&nbsp;</td></tr>
	<tr valign="bottom">
		<td width="20%" valign="middle">{translate key="editor.minutes.generated"}</td>
		<td width="80%">
			<table width="100%">
				<tr>
					<td width="70%">
					{if $generatedAttendanceFile}
						<a href="{url op="downloadMinutes" path=$meeting->getId()|to_array:$generatedAttendanceFile->getFileId()}">{$generatedAttendanceFile->getFileName()}</a>
					{else}
						{translate key="editor.minutes.noFileGenerated"}
					{/if}
					</td>
					<td width="30%" align="right">
						<a href="{url op="generateAttendance" path=$meeting->getId()}">{if $generatedAttendanceFile}{translate key="editor.minutes.replaceAttendance"}{else}{translate key="editor.minutes.generateAttendance"}{/if}</a>
					</td>
				</tr>
			</table>
		</td>
		<td width="30%" align="right"></td>
	</tr>
	<tr><td colspan="2" class="separator">&nbsp;</td></tr>
	<tr valign="bottom">
		<td width="20%" valign="middle">{translate key="editor.minutes.uploaded"}</td>
		<td width="80%">
			<table width="100%">
				{assign var=countUpAttFile value=0}
				{foreach from=$uploadedAttendanceFiles item=uploadedAttendanceFile}
					{assign var=countUpAttFile value=$countUpAttFile+1}
					<tr>
						<td width="70%">
							<a href="{url op="downloadMinutes" path=$meeting->getId()|to_array:$uploadedAttendanceFile->getFileId()}">{$uploadedAttendanceFile->getFileName()}</a>
						</td>
						<td width="30%" align="right">
							<a href="{url op="deleteUploadedFile" path=$meeting->getId()|to_array:$uploadedAttendanceFile->getFileId()}">{translate key="common.delete"}</a>
						</td>
					</tr>
				{/foreach}
				{if $countUpAttFile == 0}
					<tr width="100%">
						<td colspan="2">{translate key="editor.minutes.noFileUploaded"}</td>
					</tr>
				{/if}
				<form method="post" action="{url op="uploadFile" path=$meeting->getId()|to_array:1}" enctype="multipart/form-data">
					<tr width="100%">
						<td width="62,5%">
							<input type="file" name="uploadMinutesFile" id="uploadMinutesFile"  class="uploadField" />
						</td>
						<td width="37,5%" align="right">
							<input name="submitUploadMinutesFile" type="submit" class="button" value="{translate key="common.upload"}" /> 
						</td>						
					</tr>
				</form>
			</table>
		</td>
	</tr>
	<tr><td colspan="2" class="endseparator">&nbsp;</td></tr>	
</table>
<p><strong><br/>Reviews</strong></p>
<table class="listing" width="100%">
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="20%">{translate key="common.type"}</td>
		<td width="20%">{translate key="common.proposalId"}</td>		
		<td width="30%">{translate key="common.file.s"}</td>
		<td width="30%" align="right">{translate key="common.action"}</td>	
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
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
	<tr><td colspan="4" class="separator">&nbsp;</td></tr>
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
<input type="button" class="button" onclick="document.location.href='{url op="viewMeeting" path=$meeting->getId()}'" value="{translate key="common.back"}" />
{include file="common/footer.tpl"}
