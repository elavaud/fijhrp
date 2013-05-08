{**
 * suppFile.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Add/edit a supplementary file.
 *
 * $Id$
 *}

{strip}
{if $suppFileId}
	{assign var="pageTitle" value="author.submit.editSupplementaryFile"}
{else}
        {if $type == "Progress Report"}
            {assign var="pageTitle" value="author.submit.addProgressReport"}
        {elseif $type == "Completion Report"}
            {assign var="pageTitle" value="author.submit.addCompletionReport"}
        {elseif $type == "Extension Request"}
            {assign var="pageTitle" value="author.submit.addExtensionRequest"}
        {elseif $type == "Raw Data File"}
        	{assign var="pageTitle" value=author.submit.addRawDataFile}
        {else}
            {assign var="pageTitle" value="author.submit.addSupplementaryFile"}
        {/if}
{/if}

{if $type == "Progress Report"}
    {assign var="pageCrumbTitle" value="submission.progressReports"}
{elseif $type == "Completion Report"}
    {assign var="pageCrumbTitle" value="submission.completionReports"}
{elseif $type == "Extension Request"}
    {assign var="pageCrumbTitle" value="submission.extensionRequest"}
{elseif $type == "Raw Data File"}
	{assign var="pageCrumbTitle" value="submission.rawDataFile"}
{else}
    {assign var="pageCrumbTitle" value="submission.supplementaryFiles"}
{/if}
{include file="common/header.tpl"}
{/strip}
{literal}
<script type="text/javascript">
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

function checkSize(){
	var fileToUpload = document.getElementById('uploadSuppFile');
	var check = fileToUpload.files[0].fileSize;
	var valueInKb = Math.ceil(check/1024);
	if (check > 5242880){
		alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
		return false
	} 
}
</script>
{/literal}
<form name="suppFile" method="post" action="{url page=$rolePath op="saveSuppFile" path=$suppFileId}" onSubmit="return checkSize()" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
<input type="hidden" name="from" value="{$from|escape}" />
<input type="hidden" name="type" value="{$type|escape}" /> <!-- Added by AIM, June 15 2011 -->
{include file="common/formErrors.tpl"}

{if $type == "Supp File"}
{literal}
<script type="text/javascript">
$(document).ready(function() {
    // Add filter of sudent research
    if ($('#fileType').val() == null){
        $('#saveButton').hide();
    } else {
        $('#saveButton').show();
	}

    $('#fileType').change(
        function(){
            var answer = $('#fileType').val();
            if(answer == null) {
		        $('#saveButton').hide();
            } else {
		        $('#saveButton').show();
            }
    	}
    );
});
</script>
{/literal}
{/if}

<div id="supplementaryFileUpload">

{if $type == "Progress Report"}
    <h3>{translate key="submission.progressReports"}</h3>
{elseif $type == "Completion Report"}
    <h3>{translate key="submission.completionReports"}</h3>
{elseif $type == "Extension Request"}
    <h3>{translate key="submission.extensionRequest"}</h3>
{elseif $type == "Raw Data File"}
    <h3>{translate key="submission.rawDataFile"}</h3>
{elseif $type == "Other Supplementary Research Output"}
    <h3>{translate key="submission.otherSuppResearchOutput"}</h3>
{else}
    <h3>{translate key="author.submit.supplementaryFileUpload"}</h3>
{/if}

<table id="suppFile" class="data">
{if $suppFile}
	<tr valign="top">
		<td width="20%" class="label">{translate key="common.fileName"}</td>
		<td width="80%" class="data"><a href="{url op="downloadFile" path=$articleId|to_array:$suppFile->getFileId()}">{$suppFile->getFileName()|escape}</a></td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="common.originalFileName"}</td>
		<td class="value">{$suppFile->getOriginalFileName()|escape}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="common.fileSize"}</td>
		<td class="value">{$suppFile->getNiceFileSize()}</td>
	</tr>
	<tr>
		<td class="label">{translate key="common.dateUploaded"}</td>
		<td class="value">{$suppFile->getDateUploaded()|date_format:$dateFormatShort}</td>
	</tr>
</table>
<!--
{*
<table width="100%"  class="data">
	<tr valign="top">
		<td width="5%" class="label"><input type="checkbox" name="showReviewers" id="showReviewers" value="1"{if $showReviewers==1} checked="checked"{/if} /></td>
		<td width="95%" class="value"><label for="showReviewers">{translate key="author.submit.suppFile.availableToPeers"}</label></td>
	</tr>
</table>
*}
-->
{else}
	<tr valign="top">
		<td colspan="2" class="nodata">{* translate key="author.submit.suppFile.noFile" *}</td>
	</tr>
{/if}

<br />

<table id="showReviewers" width="100%" class="data">
        <!--Start Edit Jan 30 2012-->
        {if $type == "Supp File"}
            <tr>
                <td width="30%" class="label">Select file type(s)<br />(Hold down the CTRL button to select multiple options.)</td>
                <td width="35%" class="value">
                        <select name="fileType[]" id="fileType" multiple="multiple" size="10" class="selectMenu">
                            {html_options_translate options=$typeOptions translateValues="true" selected=$fileType}
                        </select>
                </td>
                <td style="vertical-align: bottom;">
                        <div id="divOtherFileType" style="display: none;">
                            <span class="label" style="font-style: italic;">Specify "Other" file type</span> <br />
                            <input type="text" name="otherFileType" id="otherFileType" size="20" /> <br />
                        </div>
                </td>
            </tr>
        {/if}
        <!--End Edit -->
	<tr valign="top">
		<td class="label">
			{if $suppFile}
				{fieldLabel name="uploadSuppFile" key="common.replaceFile"}
			{else}
				{fieldLabel name="uploadSuppFile" key="common.upload"}
			{/if}
		</td>
		<td class="value" colspan="2"><input type="file" name="uploadSuppFile" id="uploadSuppFile" class="uploadField" />&nbsp;&nbsp;{translate key="author.submit.supplementaryFiles.saveToUpload"}</td>
	</tr>

</table>
</div>

<div class="separator"></div>


<p>
<input type="submit" value="{translate key="common.save"}" class="button defaultButton" id="saveButton" /> 
<input type="button" value="{translate key="common.cancel"}" class="button" onclick="history.go(-1)" />
</p>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p></form>

{include file="common/footer.tpl"}

