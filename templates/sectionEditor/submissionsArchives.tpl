{**
 * submissionsArchives.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show section editor's submission archive.
 *
 * $Id$
 *}
<div id="submissions">
<table class="listing" width="100%">
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
	<tr valign="bottom" class="heading">
		<td width="5%">Proposal ID</td>
		<td width="5%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="23%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="32%">{sort_heading key="article.title" sort="title"}</td>
		{if $statViews}<td width="5%">{sort_heading key="submission.views" sort="views"}</td>{/if}
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

{foreach from=$submissions item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
        {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
	<tr valign="top">
		<td>{$whoId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
	   	<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
        <td><a href="{url op="submissionReview" path=$articleId}" class="action">{$submission->getLocalizedTitle()|escape}</a></td>
		<td align="right">
			{assign var="status" value=$submission->getSubmissionStatus()}
			{if $status == PROPOSAL_STATUS_ARCHIVED}
				{assign var="statusKey" value=$submission->getEditorDecisionKey()}				
			{else}
				{assign var="statusKey" value=$submission->getProposalStatusKey()}			
			{/if}
			{translate key=$statusKey}
		</td>
	</tr>
	<tr>
		<td colspan="6" class="separator">&nbsp;</td>
	</tr>
{foreachelse}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
{/foreach}
		
</table>
</div>

