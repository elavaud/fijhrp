{**
 * toSubmit.tpl
 *
 * Show the details of proposals to submit.
 *
 * $Id$
 *}

<div id="submissions">
<table class="listing" width="100%">
	<tr class="heading" valign="bottom">
		<td width="10%">{translate key="common.proposalId"}</td>
		<td width="10%"><span class="disabled">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="45%">{sort_heading key="article.title" sort="title"}</td>
		<td width="30%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>

{iterate from=submissions item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
    {assign var="decision" value=$submission->getMostRecentDecision() }
    {assign var="articleId" value=$submission->getArticleId()}
    {assign var="proposalId" value=$submission->getLocalizedProposalId($submission->getLocale())}

    <tr valign="top">
        <td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
        <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
        {if $status==PROPOSAL_STATUS_DRAFT}
            {assign var="count" value=$count+1}
            {assign var="progress" value=$submission->getSubmissionProgress()}
            <td><a href="{url op="submit" path=$progress articleId=$articleId}" class="action">{if $abstract->getScientificTitle()}{$abstract->getScientificTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
        {else}
            <td><a href="{url op="submission" path=$articleId}" class="action">{if $abstract->getScientificTitle()}{$abstract->getScientificTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
        {/if}
        <td align="right">
        	{if $status==PROPOSAL_STATUS_SUBMITTED}
            	{assign var="count" value=$count+1}
            	{translate key="submission.status.submitted"}<br />
            	<a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

        	{elseif $status==PROPOSAL_STATUS_CHECKED}
                {assign var="count" value=$count+1}
                {translate key="submission.status.complete"}<br />
                <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

            {elseif $status==PROPOSAL_STATUS_EXPEDITED}
                {assign var="count" value=$count+1}
                {translate key="submission.status.expeditedReview"}<br />
                <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

            {elseif $status==PROPOSAL_STATUS_FULL_REVIEW}
                {assign var="count" value=$count+1}
                {translate key="submission.status.fullReview"}<br />
                <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

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
