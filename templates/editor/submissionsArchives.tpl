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
		<td width="10%">Proposal ID</td>
		<td width="10%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="20%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="50%">{sort_heading key="article.title" sort="title"}</td>
		<td width="10%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

{*foreach from=$submissions item=submission*} <!-- by AIM, Jan 21, 2012 to restore pagination -->
{iterate from=submissions item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
        {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
	<tr valign="top">
		<td>{$proposalId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
	   	<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
      	<td><a href="{url op="submission" path=$articleId}" class="action">{$abstract->getScientificTitle()|strip_unsafe_html|truncate:60:"..."}</a></td>
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
{/iterate}
<!-- {*  by AIM, Jan 21 2012, to restore pagination
{foreachelse}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
{/foreach}
*} -->

<!-- Pagination, AIM, Jan 21 2012 -->

{if $submissions->wasEmpty()}

	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>

{else}
	<tr>
		<td colspan="4" align="left">{page_info iterator=$submissions}</td>
		<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
		
</table>
</div>

