{**
 * complete.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * The submission process has been completed; notify the author.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="author.track"}
{include file="common/header.tpl"}
{/strip}

<div id="submissionComplete">

<p style="font-size: larger;">{translate key="author.submit.submissionComplete" journalTitle=$journal->getLocalizedTitle()}</p>

<h3>Proposal Details</h3>
<table class="listing" width="100%">
    <tr>
        <td colspan="5" class="headseparator">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 30%">WHO ID:</td>
        <td style="width: 70%">{$whoId}</td>
    </tr>
    <tr>
        <td>Title:</td>
        <td>{$title}</td>
    </tr>
    <tr>
        <td>Abstract: </td>
        <td>{$abstract}</td>
    </tr>
    <tr>
        <td>Objectives:</td>
        <td>{$objectives}</td>
    </tr>
    <tr>
        <td>Start Date:</td>
        <td>{$startDate}</td>
    </tr>
    <tr>
        <td>End Date:</td>
        <td>{$endDate}</td>
    </tr>
    <tr>
        <td>Funds Required (in USD):</td>
        <td>{$fundsRequired}</td>
    </tr>
    <tr>
        <td>Country:</td>
        <td>{$proposalCountry}</td>
    </tr>
    <tr>
        <td>Technical Unit:</td>
        <td>{translate key=$technicalUnit}</td>
    </tr>
    <tr>
        <td>Proposal Type:</td>
        <td>{translate key=$proposalType}</td>
    </tr>
</table>
<div class="separator"></div>

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
{if ($file->getType() == 'supp' || $file->getType() == 'submission/original')}
<tr valign="top">
	<td>{$file->getFileId()}</td>
	<td><a class="file" href="{url op="download" path=$articleId|to_array:$file->getFileId()}">{$file->getOriginalFileName()|escape}</a></td>
	<td>{if ($file->getType() == 'supp')}{translate key="article.suppFile"}{else}{translate key="author.submit.submissionFile"}{/if}</td>
	<td>{$file->getNiceFileSize()}</td>
	<td>{$file->getDateUploaded()|date_format:$dateFormatTrunc}</td>
</tr>
{/if}
{foreachelse}
<tr valign="top">
<td colspan="5" class="nodata">{translate key="author.submit.noFiles"}</td>
</tr>
{/foreach}
</table>

<div class="separator"></div>

<br />

{if $canExpedite}
	{url|assign:"expediteUrl" op="expediteSubmission" articleId=$articleId}
	{translate key="author.submit.expedite" expediteUrl=$expediteUrl}
{/if}
{if $paymentButtonsTemplate }
	{include file=$paymentButtonsTemplate orientation="vertical"}
{/if}


<p>&#187; <a href="{url op="index"}">{translate key="author.track"}</a></p>

</div>

{include file="common/footer.tpl"}

