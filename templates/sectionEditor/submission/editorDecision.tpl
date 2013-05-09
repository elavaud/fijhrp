{**
 * editorDecision.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the editor decision table.
 *
 * $Id$
 *}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>

{literal}
<script type="text/javascript">
$(document).ready(function() {
	$("#approvalDateRow").hide();
	$("#approvalDate").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
	$("#decision").change(
		function() {
			var decision = $("#decision option:selected").val();
			if(decision == 1) {
				$("#approvalDateRow").show();
			} else {
				$("#approvalDateRow").hide();
			}
		}
	);
});
function checkSize(){
	var fileToUpload = document.getElementById('finalDecisionFile');
	var check = fileToUpload.files[0].fileSize;
	var valueInKb = Math.ceil(check/1024);
	if (check > 5242880){
		alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
		return false
	} 
}
</script>
{/literal}
 
{assign var="proposalStatus" value=$submission->getSubmissionStatus()}
{assign var="proposalStatusKey" value=$submission->getProposalStatusKey($proposalStatus)}
{if $proposalStatus == PROPOSAL_STATUS_FULL_REVIEW || $proposalStatus == PROPOSAL_STATUS_EXPEDITED} 
	<div>
		{if $reviewAssignmentCount>0}
			{include file="sectionEditor/submission/peerReview.tpl"}
		{else}
			{include file="sectionEditor/submission/peerReviewSelection.tpl"}
		{/if}
		<div class="separator"></div>
	</div>
{/if}

{if $authorFees}

{include file="sectionEditor/submission/authorFees.tpl"}

<div class="separator"></div>
{/if}

<div id="editorDecision">
<h3>{translate key="submission.editorDecision"}</h3>

<table id="table1" width="100%" class="data">
	<tr valign="top">
	<td class="label" width="20%">{translate key="submission.proposalStatus"}</td>
	<td width="80%" class="value">
		{translate key=$proposalStatusKey}
		{if $submission->isSubmissionDue() && $proposalStatus != PROPOSAL_STATUS_COMPLETED}
			({translate key="submission.status.continuingReview"})
		{/if}</td>
</tr>

{if $meetingsCount>0}
	<tr>
		<td title="{translate key="editor.article.meetingInstruct"}" class="label" width="20%">[?] {translate key="editor.meeting.s"}</td>
		<td class="value" width="80%">
			{foreach from=$meetings item="meeting"}
				<a href="{url op="viewMeeting" path=$meeting->getId()}">{$meeting->getPublicId()} {$meeting->getDate()|date_format:$datetimeFormatLong}</a><br/>
			{/foreach}
		</td>
	</tr>
{/if}
	<form method="post" action="{url op="recordDecision"}" onSubmit="return checkSize()" enctype="multipart/form-data">
		<input type="hidden" name="articleId" value="{$submission->getId()}" />
		<input type="hidden" name="lastDecisionId" value="{$lastDecision->getId()}" />
		<input type="hidden" name="resubmitCount" value="{$submission->getResubmitCount()}" />
 
	<tr valign="top">
	{if $proposalStatus == PROPOSAL_STATUS_SUBMITTED || $proposalStatus == PROPOSAL_STATUS_RESUBMITTED }
		<td title="{translate key="editor.article.selectInitialReviewInstruct"}" class="label" width="20%">[?] {translate key="editor.article.selectInitialReview"}</td>
		<td width="80%" class="value">
			<select id="decision" name="decision" size="1" class="selectMenu">
				{html_options_translate options=$initialReviewOptions selected=1}
			</select>
			<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.article.confirmInitialReview"}')" name="submit" value="{translate key="editor.article.record"}"  class="button" />			
		</td>

	{elseif $proposalStatus == PROPOSAL_STATUS_CHECKED}
		<td title="{translate key="editor.article.selectReviewProcessInstruct"}" class="label" width="20%">[?] {translate key="editor.article.selectReviewProcess"}</td>
		<td width="80%" class="value">
			<select id="decision" name="decision" size="1" class="selectMenu">
				{html_options_translate options=$exemptionOptions selected=1}
			</select>
			<input type="submit" id="notFullReview" onclick="return confirm('{translate|escape:"jsparam" key="editor.article.confirmExemption"}')" name="submit" value="{translate key="editor.article.record"}"  class="button" />
		</td>
	{elseif $proposalStatus == PROPOSAL_STATUS_REVIEWED && $submission->isSubmissionDue()}
		<td class="label" width="20%">{translate key="editor.article.selectContinuingReview"}</td>
		<td width="80%" class="value">
				<select id="decision" name="decision" size="1" class="selectMenu">
					{html_options_translate options=$continuingReviewOptions selected=1}
				</select>
				<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.article.confirmReviewSelection"}')" name="submit" value="{translate key="editor.article.record"}"  class="button" />
		</td>	
	{/if}
	</tr>

{if $proposalStatus == PROPOSAL_STATUS_WITHDRAWN}
	<tr id="withdrawnReasons">
		<td class="label">&nbsp;</td>
		<td class="value">{translate key="common.reason"}: 
		{if $submission->getWithdrawReason(en_US) == "0"}
			{translate key="submission.withdrawLack"}
		{elseif $submission->getWithdrawReason(en_US) == "1"}
			{translate key="submission.withdrawAdverse"}
		{else}
			{$submission->getWithdrawReason(en_US)}
		{/if}
		</td>
	</tr>
	{if $submission->getWithdrawComments(en_US)}
		<tr id="withdrawComments">
			<td class="label">&nbsp;</td>
			<td class="value">{translate key="common.comments"}: {$submission->getWithdrawComments(en_US)}</td>
		</tr>
	{/if}
{/if}

{if $proposalStatus == PROPOSAL_STATUS_EXPEDITED || $proposalStatus == PROPOSAL_STATUS_FULL_REVIEW}	
	<tr>
		<td title="{translate key="editor.article.selectDecisionInstruct"}" class="label" width="20%">[?] {translate key="editor.article.selectDecision"}</td>
		<td width="80%" class="value">
			<select id="decision" name="decision" {if $authorFees && !$submissionPayment && $submission->getLocalizedStudentInitiatedResearch() != 'Yes'}disabled="disabled"{/if} size="1" class="selectMenu">
				{html_options_translate options=$sectionDecisionOptions selected=0}
			</select> {if $authorFees && !$submissionPayment && $submission->getLocalizedStudentInitiatedResearch() != 'Yes'}<i>{translate key="editor.article.payment.paymentConfirm"}</i>{/if}			
		</td>		
	</tr>
{/if}
	<tr id="approvalDateRow">
		<td title="{translate key="editor.article.setApprovalDateInstruct"}" class="label">[?] {translate key="editor.article.setApprovalDate"}</td>
		<td class="value">
			<input type="text" name="approvalDate" id="approvalDate" class="textField" size="19" />
		</td>
	</tr>
{if $proposalStatus == PROPOSAL_STATUS_EXPEDITED || $proposalStatus == PROPOSAL_STATUS_FULL_REVIEW}	
	<tr>
		<td title="{translate key="editor.article.uploadFinalDecisionFileInstruct"}" class="label" width="20%">[?] {translate key="editor.article.uploadFinalDecisionFile"}</td>
		<td width="80%" class="value">
			<input type="file" class="uploadField" name="finalDecisionFile" id="finalDecisionFile"/>
			<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmDecision"}')" name="submit" value="{translate key="editor.article.uploadRecordDecision"}"  class="button" />						
		</td>
	</tr>
{/if}
{if $proposalStatus != PROPOSAL_STATUS_COMPLETED}
<tr valign="top">
	<td class="label">{translate key="editor.article.finalDecision"}</td>
	<td class="value">
		{if !$submission->isSubmissionDue() && $proposalStatus == PROPOSAL_STATUS_REVIEWED || $proposalStatus == PROPOSAL_STATUS_EXEMPTED}
			{assign var="decision" value=$submission->getEditorDecisionKey()}
			{translate key=$decision}
			{if $submission->isSubmissionDue()}&nbsp;({translate key="submission.due"})&nbsp;{/if}
			{if $lastDecision->getDecision() == SUBMISSION_SECTION_DECISION_APPROVED}
				{$submission->getApprovalDate($submission->getLocale())|date_format:$dateFormatShort}
			{else}
				{$lastDecision->getDateDecided()|date_format:$dateFormatShort}
			{/if}
		{else}
			{assign var="decisionAllowed" value="false"}
			{if $reviewAssignments}
				<!-- Change false to true for allowing decision only if all reviewers submitted a recommendation-->
				{assign var="decisionAllowed" value="false"}
				{foreach from=$reviewAssignments item=reviewAssignment}
					{if !$reviewAssignment->getRecommendation()}
						{assign var="decisionAllowed" value="false"}
					{/if}
				{/foreach}
			{/if}
			{if $decisionAllowed == "true"}
			<select id="decision" name="decision" size="1" class="selectMenu">
				{html_options_translate options=$editorDecisionOptions selected=0}
			</select>
			<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmDecision"}')" name="submit" value="{translate key="editor.article.uploadRecordDecision"}"  class="button" />
			{else}
				{translate key="common.none"}
			{/if}
		{/if}		
	</td>
</tr>
{/if}
</form>

{if ($proposalStatus == PROPOSAL_STATUS_RETURNED) || ($proposalStatus == PROPOSAL_STATUS_RESUBMITTED) || ($proposalStatus == PROPOSAL_STATUS_REVIEWED && $lastDecision->getDecision() == SUBMISSION_SECTION_DECISION_RESUBMIT) }
	<tr valign="top">
		{assign var="articleLastModified" value=$submission->getLastModified()}
		{if $articleMoreRecent && $resubmitCount!=null && $resubmitCount!=0 }
			<td class="label"></td>
			<td width="80%" class="value">
				{translate key="editor.article.resubmittedMsg1"} {$resubmitCount} {translate key="editor.article.resubmittedMsg2"} {$articleLastModified|date_format:$dateFormatShort}
			</td>
		{/if}
	</tr>
	<tr valign="top">
	{if !$articleMoreRecent}
		<td class="label" width="20%">{translate key="editor.article.submissionStatus"}</td>
		<td width="80%" class="value">{translate key="editor.article.waitingForResubmission"}</td>
	{/if}
	</tr>
{/if}


{if $submission->getMostRecentDecision() == SUBMISSION_SECTION_DECISION_EXEMPTED}
	{assign var="localizedReasons" value=$submission->getLocalizedReasonsForExemption()}
	<form method="post" action="{url op="recordReasonsForExemption"}">
		<input type="hidden" name="articleId" value="{$submission->getId()}" />
		<input type="hidden" name="decision" value="{$lastDecision->getDecision()}" />	
	
		<tr valign="top">
			<td title="{translate key="editor.article.reasonsForExemptionInstruct"}" class="label">[?] {translate key="editor.article.reasonsForExemption"}</td>
			<td class="value"><!-- {*translate key="editor.article.exemption.instructions"*} --></td>
		</tr>
		{foreach from=$reasonsMap item=reasonLocale key=reasonVal}
			<tr valign="top">
				<td class="label" align="center">
					<input type="checkbox" name="exemptionReasons[]" id="reason{$reasonVal}" value={$reasonVal}	 {if $localizedReasons>0}disabled="true"{/if} {if $reasonsForExemption[$reasonVal] == 1}checked="checked"{/if}/>				
				</td>
				<td class="value">
					<label for="reason{$reasonVal}">{translate key=$reasonLocale}</label>
				</td>
			</tr>
		{/foreach}	
		{if !$localizedReasons}
		<tr>
			<td align="center"><input type="submit"  name="submit" value="{translate key="editor.article.record"}"  class="button" /></td>
		</tr>			
		{/if}
	</form>
{/if}

{assign var="lastSectionDecision" value=$submission->getLastSectionDecision()}
{if $lastSectionDecision}
	{assign var="decisionFiles" value=$lastSectionDecision->getDecisionFiles()}
	{if (($submission->getMostRecentDecision() == SUBMISSION_SECTION_DECISION_EXEMPTED) || ($submission->getMostRecentDecision() == SUBMISSION_SECTION_DECISION_APPROVED) || ($submission->getMostRecentDecision() == SUBMISSION_SECTION_DECISION_DECLINED)) && count($decisionFiles) < 1}
	<form method="post" action="{url op="uploadDecisionFile" path=$submission->getId()|to_array:$submission->getLastSectionDecisionId()}"  enctype="multipart/form-data">
		<tr valign="top">
			<td title="{translate key="editor.article.uploadFinalDecisionFileInstruct"}" class="label">[?] {translate key="editor.article.uploadFinalDecisionFile"}</td>
			<td class="value">
				<input type="file" class="uploadField" name="finalDecisionFile" id="finalDecisionFile"/>
				<input type="submit" class="button" value="{translate key="common.upload"}" />
			</td>
		</tr>
	</form>
	{/if}
{/if}

<tr valign="top">
	<td title="{translate key="editor.article.notifyAuthorInstruct"}" class="label">[?] {translate key="editor.article.notifyAuthor"}</td>
	<td class="value">
		{translate key="email.compose"}&nbsp;&nbsp;&nbsp;&nbsp;
		{url|assign:"notifyAuthorUrl" op="emailEditorDecisionComment" articleId=$submission->getId()}
		
		{icon name="mail" url=$notifyAuthorUrl}
	
		<br/>
		{translate key="submission.editorAuthorRecord"}
		{if $submission->getMostRecentEditorDecisionComment()}
			{assign var="comment" value=$submission->getMostRecentEditorDecisionComment()}
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getId() anchor=$comment->getId()}');" class="icon">{icon name="comment"}</a>&nbsp;&nbsp;{translate key="editor.article.lastComment"}: {$comment->getDatePosted()|date_format:$dateFormatShort}
		{else}
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getId()}');" class="icon">{icon name="comment"}</a>&nbsp;&nbsp;{translate key="common.noComments"}
		{/if}
	</td>
</tr>
</table>

</div>