{**
 * step4.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Step 4 of author article submission.
 *
 * $Id$
 *}
{assign var="pageTitle" value="author.submit.step4"}
{include file="author/submit/submitHeader.tpl"}

{literal}
<script type="text/javascript">
<!--
function confirmForgottenUpload() {
	var fieldValue = document.submitForm.uploadSuppFile.value;
	if (fieldValue) {
		return confirm("{/literal}{translate key="author.submit.forgottenSubmitSuppFile"}{literal}");
	}
	return true;
}
// -->

function checkSize(){
	var fileToUpload = document.getElementById('uploadSuppFile');
	var check = fileToUpload.files[0].fileSize;
	var valueInKb = Math.ceil(check/1024);
	if (check > 5242880){
		alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
		return false
	}
}

$(document).ready(function() {
   $('#fileType').change(function(){
        var isOtherSelected = false;
        $.each($('#fileType').val(), function(key, value){
            if(value == "{/literal}{translate key="common.other"}{literal}") {
                isOtherSelected = true;
            }
        });
        if(isOtherSelected) {
            $('#divOtherFileType').show();
        } else {
            $('#divOtherFileType').hide();
        }
    });
});

</script>
{/literal}

<form name="submitForm" method="post" action="{url op="saveSubmit" path=$submitStep}" onSubmit="return checkSize()" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
{include file="common/formErrors.tpl"}

<p>{translate key="author.submit.supplementaryFilesInstructions"}</p>

<table class="listing" width="100%">
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
<tr class="heading" valign="bottom">
	<td width="40%">{translate key="common.title"}</td>
	<td width="25%">{translate key="common.originalFileName"}</td>
	<td width="15%" class="nowrap">{translate key="common.dateUploaded"}</td>
	<td width="15%" align="right">{translate key="common.action"}</td>
</tr>
<tr>
	<td colspan="6" class="headseparator">&nbsp;</td>
</tr>
{foreach from=$suppFiles item=file}
<tr valign="top">
	<td>{$file->getSuppFileTitle()|escape}</td>
	<td>{$file->getOriginalFileName()|escape}</td>
	<td>{$file->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
	<td align="right">
            <a href="{url op="deleteSubmitSuppFile" path=$file->getSuppFileId() articleId=$articleId}" onclick="return confirm('{translate|escape:"jsparam" key="author.submit.confirmDeleteSuppFile"}')" class="action">{translate key="common.delete"}</a></td>
</tr>
{foreachelse}
<tr valign="top">
	<td colspan="6" class="nodata">{translate key="author.submit.noSupplementaryFiles"}</td>
</tr>
{/foreach}
</table>

<div class="separator"></div>

<table class="data" width="100%">
<tr>
	<td width="30%" class="label">{translate key="author.submit.suppFileInstruct"}</td>
	<td width="35%" class="value">
    	<select name="fileType[]" id="fileType" multiple="multiple" size="8" class="selectMenu">
        	{html_options_translate options=$typeOptions translateValues="true" selected=$fileType}
        </select>
    </td>
    <td style="vertical-align: bottom;">
    	<div id="divOtherFileType" style="display: none;">
        	<span class="label" style="font-style: italic;">{translate key="author.submit.suppFileSpecify"}</span> <br />
        	<input type="text" name="otherFileType" id="otherFileType" size="20" /> <br />
    	</div>
    </td>
</tr>
<tr>
        <td width="30%" class="label">{translate key="author.submit.suppFileUploadInstruct"}</td>
        <td width="70%" class="value" colspan="2">
                <input type="file" name="uploadSuppFile" id="uploadSuppFile"  class="uploadField" />
                <input name="submitUploadSuppFile" type="submit" class="button" value="{translate key="common.upload"}" /> 
		{if $currentJournal->getSetting('showEnsuringLink')}<a class="action" href="javascript:openHelp('{get_help_id key="editorial.sectionEditorsRole.review.blindPeerReview" url="true"}')">{translate key="reviewer.article.ensuringBlindReview"}</a>{/if}
	</td>
</tr>
</table>

<div class="separator"></div>

<p><input type="submit" onclick="return confirmForgottenUpload()" value="{translate key="common.saveAndContinue"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}')" /></p>

</form>

{include file="common/footer.tpl"}

