{**
 * step3.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Step 3 of author article submission.
 *
 * $Id$
 *}
{assign var="pageTitle" value="author.submit.step3"}
{include file="author/submit/submitHeader.tpl"}

{literal}
<script type="text/javascript">
function checkSize(){
	var fileToUpload = document.getElementById('submissionFileUpload');
	var check = fileToUpload.files[0].fileSize;
	var valueInKb = Math.ceil(check/1024);
	if (check > 5242880){
		alert ('The file is too big ('+valueInKb+' Kb). It should not exceed 5 Mb.');
		return false
	}
}
</script>
{/literal}

<form method="post" action="{url op="saveSubmit" path=$submitStep}" onSubmit="return checkSize()" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
{include file="common/formErrors.tpl"}

<div id="uploadInstructions">{translate key="author.submit.uploadInstructions"}</div>

{if $journalSettings.supportPhone}
	{assign var="howToKeyName" value="author.submit.howToSubmit"}
{else}
	{assign var="howToKeyName" value="author.submit.howToSubmitNoPhone"}
{/if}

<p>{translate key=$howToKeyName supportName=$journalSettings.supportName supportEmail=$journalSettings.supportEmail supportPhone=$journalSettings.supportPhone}</p>

{if $articleComments}
    <div class="separator"></div>
    <div id="articleComments">
        <h3>Proposal Comments</h3>
        <li>
        {foreach from=$articleComments item=comment}
            <ul>{$comment->getComments()} ({$comment->getAuthorName()}, {$comment->getDatePosted()})</ul>
        {/foreach}
        </li>
    </div>
{/if}

<div class="separator"></div>

<div id="submissionFile">
<h3>{translate key="author.submit.submissionFile"}</h3>
<table class="data" width="100%">
{if $submissionFile}
<tr valign="top">
	<td width="20%" class="label">{translate key="common.fileName"}</td>
	<td width="80%" class="value"><a href="{url op="download" path=$articleId|to_array:$submissionFile->getFileId()}">{$submissionFile->getFileName()|escape}</a></td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{translate key="common.originalFileName"}</td>
	<td width="80%" class="value">{$submissionFile->getOriginalFileName()|escape}</td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{translate key="common.fileSize"}</td>
	<td width="80%" class="value">{$submissionFile->getNiceFileSize()}</td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{translate key="common.dateUploaded"}</td>
	<td width="80%" class="value">{$submissionFile->getDateUploaded()|date_format:$datetimeFormatShort}</td>
</tr>
{else}
<tr valign="top">
	<td colspan="2" class="nodata">{translate key="author.submit.noSubmissionFile"}</td>
</tr>
{/if}
</table>
</div>

<div class="separator"></div>

<div id="addSubmissionFile">
<table class="data" width="100%">
<tr>
	<td width="30%" class="label">
		{if $submissionFile}
			{fieldLabel name="submissionFile" key="author.submit.replaceSubmissionFile"}
		{else}
			{fieldLabel name="submissionFile" key="author.submit.uploadSubmissionFile"}
		{/if}
	</td>
	<td width="70%" class="value">
		<input type="file" class="uploadField" name="submissionFile" id="submissionFileUpload" /> <input name="uploadSubmissionFile" type="submit" class="button" value="{translate key="common.upload"}" />
		{if $currentJournal->getSetting('showEnsuringLink')}<a class="action" href="javascript:openHelp('{get_help_id key="editorial.sectionEditorsRole.review.blindPeerReview" url="true"}')">{translate key="reviewer.article.ensuringBlindReview"}</a>{/if}
	</td>
</tr>
</table>
</div>

<div class="separator"></div>

<p>
{if $submissionFile}
<input type="submit"{if !$submissionFile} onclick="return confirm('{translate|escape:"jsparam" key="author.submit.noSubmissionConfirm"}')"{/if} value="{translate key="common.saveAndContinue"}" class="button defaultButton" /> 
{/if}
<input type="button" value="{translate key="common.cancel"}" class="button" onclick="confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}')" />
</p>
</form>


{include file="common/footer.tpl"}

