{**
 * toSubmit.tpl
 *
 * Show the details of proposals to submit.
 *
 * $Id$
 *}

<div id="submissions">
<table class="listing" width="100%">
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
	<tr valign="bottom" class="heading">
		<td width="10%">{translate key="common.proposalId"}</td>
		<td width="10%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="45%">{sort_heading key="article.title" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td class="headseparator" colspan="4">&nbsp;</td></tr>
{iterate from=submissions item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
    {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
	<tr valign="top">
		<td>{$proposalId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatShort}</td>
		<td><a href="{url op="submission" path=$articleId}" class="action">{$abstract->getScientificTitle()|escape}</a></td>
		{assign var="status" value=$submission->getSubmissionStatus()}
		<td align="right">
        	{if $status==PROPOSAL_STATUS_WITHDRAWN}
            	{translate key="submission.status.withdrawn"}
            {elseif $status==PROPOSAL_STATUS_COMPLETED}
                {translate key="submission.status.completed"}<br />
            {elseif $status==PROPOSAL_STATUS_ARCHIVED || $status==PROPOSAL_STATUS_REVIEWED}
                {assign var="decision" value=$submission->getMostRecentDecision()}
            	{if $decision==SUBMISSION_SECTION_DECISION_DECLINED}
                    {translate key="submission.status.declined"}
                {elseif $decision==SUBMISSION_SECTION_DECISION_EXEMPTED}
                    {translate key="submission.status.exempted"}
                 {/if}
            {else}
            	BUG!
			{/if}
		</td>
	</tr>

	<tr>
		<td colspan="4" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="4" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="2" align="left">{page_info iterator=$submissions}</td>
		<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>
