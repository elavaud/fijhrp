{include file="sectionEditor/minutes/menu.tpl"}
{literal}
<script type="text/javascript">	
	$(document).ready(function() {			
		$("#minutesFile").change(
			function() {
				var minutesVal = $("#minutesFile").val();
				$("#minutesFileField").val(minutesVal);		
		});				
});	
</script>
{/literal}
<div id="submissions">
<h4>{translate key="editor.minutes.proposal.initialReview"}&nbsp;{$submission->getLocalizedWhoId()}</h4>
<br/>
<form method="post" action="{url op="uploadInitialReviewFile" path=$meeting->getId()|to_array:$submission->getId()}" enctype="multipart/form-data">				
	<table class="data" width="100%">
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.protocolTitle"}</td>
			<td class="value" width="80%">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.whoId"}</td>
			<td class="value" width="80%">{$submission->getLocalizedWhoId()}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.pi"}</td>
			<td class="value">{$submission->getAuthorString()|strip_unsafe_html|truncate:100:"..."}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.responsibleRto"}</td>
			<td class="value">
				{assign var="submitter" value=$submission->getUser()}
				{$submitter->getFullName()|escape|strip_unsafe_html|truncate:100:"..."}
			</td>
		</tr>
		<tr>
			<td class="label" width="20%">
				{fieldLabel name="minutesFileField" required="true" key="editor.minutes.minutesFile"}				
			</td>
			<td class="value">
				{if $minutesFile!=null} {$minutesFile} <br/>{/if}
				<input type="hidden" name="minutesFileField" id="minutesFileField" value="{$minutesFile}"/>
				<input type="file" class="uploadField" name="minutesFile" id="minutesFile"/>
				&nbsp;&nbsp;				
			</td>
		</tr>		
	</table>
	<br/>
	<input type="submit" class="button defaultButton" name="uploadMinutesFile" id="uploadMinutesFile" value="Upload"/>
	<input type="button" class="button" onclick="document.location.href='{url op="selectInitialReview" path=$meeting->getId()}'" value="{translate key="common.back"}" />
	<input type="button" class="button" onclick="document.location.href='{url op="uploadInitialReviewDecision" path=$meeting->getId()|to_array:$submission->getId()}'" value="Skip" />
	</form>				 		
		
</div>
