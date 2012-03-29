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

<form name="submitForm" method="post" action="{url op="saveSubmit" path=$submitStep}" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
{include file="common/formErrors.tpl"}

<p>{translate key="author.submit.supplementaryFilesInstructions"}</p>

<table class="listing" width="100%">
<tr>
	<td colspan="4" class="headseparator">&nbsp;</td>
</tr>
<tr class="heading" valign="bottom">
	<!-- {* <td width="5%">{translate key="common.id"}</td> *} -->
	<td width="40%">{translate key="common.title"}</td>
	<td width="25%">{translate key="common.originalFileName"}</td>
	<td width="5%" class="nowrap">{translate key="common.dateUploaded"}</td>
	<td width="30%">{translate key="common.action"}</td>
</tr>
<tr>
	<td colspan="6" class="headseparator">&nbsp;</td>
</tr>
{foreach from=$suppFiles item=file}
<tr valign="top">
	<!-- {* <td>{$file->getSuppFileId()}</td> *} -->
	<td>{$file->getSuppFileTitle()|escape} <!-- {*({$file->getType()|escape}) *} --></td>
	<td>{$file->getOriginalFileName()|escape}</td>
	<td>{$file->getDateSubmitted()|date_format:$dateFormatShort}</td>
	<td width="30%">
            <!-- {*<a href="{url op="submitSuppFile" path=$file->getSuppFileId() articleId=$articleId}" class="action">{translate key="common.edit"}</a>&nbsp;|&nbsp; *} -->
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
	<td width="30%" class="label">Select file type(s)<br />(Hold down the CTRL button to select multiple options.)</td>
	<td width="35%" class="value">
<!--Start Edit Jan 30 2012-->
                <select name="fileType[]" id="fileType" multiple="multiple" size="10" class="selectMenu">
                    {html_options_translate options=$typeOptions translateValues="true" selected=$fileType}
                </select>
                <!-- {*
                <select name="type" class="selectMenu" id="type" size="1">{html_options_translate output=$typeOptionsOutput values=$typeOptionsValues translateValues="true" selected=$type}</select>
                *} -->
        </td>
        <td style="vertical-align: bottom;">
                <div id="divOtherFileType" style="display: none;">
                    <span class="label" style="font-style: italic;">Specify "Other" file type</span> <br />
                    <input type="text" name="otherFileType" id="otherFileType" size="20" /> <br />
                </div>
        </td>
        <!--End Edit -->
</tr>
<tr>
        <td width="30%" class="label">Select file to upload</td>
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

