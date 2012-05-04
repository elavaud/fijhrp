{**
 * step5.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Step 5 of author article submission.
 *
 * $Id$
 *}
{assign var="pageTitle" value="author.submit.step5"}
{include file="author/submit/submitHeader.tpl"}

<p>{translate key="author.submit.confirmationDescription" journalTitle=$journal->getLocalizedTitle()}</p>

<form method="post" action="{url op="saveSubmit" path=$submitStep}">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
{include file="common/formErrors.tpl"}

<h3>Proposal Details</h3>
<table class="listing" width="100%">
    <tr valign="top">
        <td colspan="5" class="headseparator">&nbsp;</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.title"}</td>
        <td class="value">{$article->getLocalizedTitle()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.abstract"}</td>
        <td class="value">{$article->getLocalizedAbstract()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.objectives"}</td>
        <td class="value">{$article->getLocalizedObjectives()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.keywords"}</td>
        <td class="value">{$article->getLocalizedKeywords()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.startDate"}</td>
        <td class="value">{$article->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.endDate"}</td>
        <td class="value">{$article->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.fundsRequired"}</td>
        <td class="value">{$article->getLocalizedFundsRequired()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.proposalCountry"}</td>
        <td class="value">{$article->getLocalizedProposalCountryText()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.technicalUnit"}</td>
        <td class="value">{$article->getLocalizedTechnicalUnitText()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{$article->getLocalizedWithHumanSubjects()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.proposalType"}</td>
        <td class="value">{$article->getLocalizedProposalTypeText()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.submittedAsPi"}</td>
        <td class="value">{$article->getLocalizedSubmittedAsPi()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.conflictOfInterest"}</td>
        <td class="value">{$article->getLocalizedConflictOfInterest()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">{$article->getLocalizedReviewedByOtherErc()}</td>
    </tr>
    {if $article->getLocalizedOtherErcDecision() != 'NA'}
    <tr valign="top">
        <td class="label">{translate key="proposal.otherErcDecision"}</td>
        <td class="value">{$article->getLocalizedOtherErcDecision()}</td>
    </tr>
    {/if}
</table>
<div class="separator"></div>

{* Commented out by EL on May 2 2012: Unuseful*}
{* <span style="font-size: smaller; font-style: italic;">To edit proposal details, <a href="{url op="submit" path="3" articleId=$articleId}">click here to go back Step 3.</a></span> *}

<br />
<br />

<h3>{translate key="author.submit.filesSummary"}</h3>
<table class="listing" width="100%">
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
<tr class="heading" valign="bottom">
	<td width="10%">{translate key="common.id"}</td>
	<td width="35%">{translate key="common.originalFileName"}</td>
	<td width="25%">{translate key="common.type"}</td>
	<td width="20%" class="nowrap">{translate key="common.fileSize"}</td>
	<td width="10%" class="nowrap">{translate key="common.dateUploaded"}</td>
</tr>
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
{foreach from=$files item=file}
<tr valign="top">
	<td>{$file->getFileId()}</td>
	<td><a class="file" href="{url op="download" path=$articleId|to_array:$file->getFileId()}">{$file->getOriginalFileName()|escape}</a></td>
	<td>{if ($file->getType() == 'supp')}{translate key="article.suppFile"}{else}{translate key="author.submit.submissionFile"}{/if}</td>
	<td>{$file->getNiceFileSize()}</td>
	<td>{$file->getDateUploaded()|date_format:$dateFormatTrunc}</td>
</tr>
{foreachelse}
<tr valign="top">
<td colspan="5" class="nodata">{translate key="author.submit.noFiles"}</td>
</tr>
{/foreach}
</table>
<div class="separator"></div>

{* Commented out by EL on May 2 2012: Unuseful*}
{* <span style="font-size: smaller; font-style: italic;">To add or remove supplementary files, <a href="{url op="submit" path="4" articleId=$articleId}">click here to go back Step 4.</a></span>*}

<br />
<br />

<div id="commentsForEditor">
<h3>{translate key="author.submit.commentsForEditor"}</h3>

<table width="100%" class="data">
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="commentsToEditor" key="author.submit.comments"}</td>
	<td width="80%" class="value"><textarea name="commentsToEditor" id="commentsToEditor" rows="3" cols="40" class="textArea">{$commentsToEditor|escape}</textarea></td>
</tr>
</table>

</div>{* commentsForEditor *}

<div class="separator"></div>

{if $authorFees}
	{include file="author/submit/authorFees.tpl" showPayLinks=1}
	{if $currentJournal->getLocalizedSetting('waiverPolicy') != ''}
		{if $manualPayment}
			<h3>{translate key="payment.alreadyPaid"}</h3>
			<table class="data" width="100%">
				<tr valign="top">
				<td width="5%" align="left"><input type="checkbox" name="paymentSent" value="1" {if $paymentSent}checked="checked"{/if} /></td>
				<td width="95%">{translate key="payment.paymentSent"}</td>
				</tr>
				<tr>
				<td />
				<td>{translate key="payment.alreadyPaidMessage"}</td>
				<tr>
			</table>
		{/if}
		<h3>{translate key="author.submit.requestWaiver"}</h3>
		<table class="data" width="100%">
			<tr valign="top">
				<td width="5%" align="left"><input type="checkbox" name="qualifyForWaiver" value="1" {if $qualifyForWaiver}checked="checked"{/if}/></td>
				<td width="95%">{translate key="author.submit.qualityForWaiver"}</td>
			</tr>
			<tr>
				<td />
				<td>
					<label for="commentsToEditor">{translate key="author.submit.addReasonsForWaiver"}</label><br />
					<textarea name="commentsToEditor" id="commentsToEditor" rows="3" cols="40" class="textArea">{$commentsToEditor|escape}</textarea>
				</td>
			</tr>
		</table> 
	{/if}

	<div class="separator"></div>
{/if}

{call_hook name="Templates::Author::Submit::Step5::AdditionalItems"}

<p><input type="submit" value="{translate key="author.submit.finishSubmission"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}')" /></p>

</form>

{include file="common/footer.tpl"}

