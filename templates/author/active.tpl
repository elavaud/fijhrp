{**
 * active.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the details of active submissions.
 *
 * $Id$
 *}

<div id="submissions">
<table class="listing" width="100%">
        <tr><td colspan="6">ACTIVE PROPOSALS (Awaiting Decision/Revise and Resubmit)</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="5%">{sort_heading key="submissions.sec" sort="section"}</td>
		<td width="25%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.title" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

{assign var="count" value=0}
{iterate from=submissions1 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }
        
        {if $status!=PROPOSAL_STATUS_REVIEWED || $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT }

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}{else}&mdash;{/if}</td>
                <td>{$submission->getSectionAbbrev()|escape}</td>
                <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
                {if $status==PROPOSAL_STATUS_DRAFT}
                    {assign var="progress" value=$submission->getSubmissionProgress()}
                    <td><a href="{url op="submit" path=$progress articleId=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
                {else}
                    <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
                {/if}
                <td align="right">
                        {if $status==PROPOSAL_STATUS_SUBMITTED}
                            {translate key="submissions.proposal.submitted"}<br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmWithdraw"}')">{translate key="common.withdraw"}</a>
                            {assign var="count" value=$count+1}
                        {elseif $status==PROPOSAL_STATUS_RETURNED}
                            {translate key="submissions.proposal.returned"}<br />
                            <a href="{url op="resubmit" path=$articleId}" class="action">Resubmit</a><br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmWithdraw"}')">{translate key="common.withdraw"}</a>
                            {assign var="count" value=$count+1}
                        {elseif $status==PROPOSAL_STATUS_DRAFT}
                            {translate key="submissions.proposal.draft"}<br /><a href="{url op="deleteSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmDelete"}')">{translate key="common.delete"}</a>
                            {assign var="count" value=$count+1}
                        {elseif $status==PROPOSAL_STATUS_REVIEWED}
                            {if $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}
                                {translate key="submissions.proposal.resubmit"}<br />
                                <a href="{url op="resubmit" path=$articleId}" class="action">Resubmit</a><br />
                                <a href="{url op="withdrawSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmWithdraw"}')">{translate key="common.withdraw"}</a>
                                {assign var="count" value=$count+1}
                            {/if}
                        {/if}
                 </td>
            </tr>
        {/if}
	<tr>
		<td colspan="6" class="{if $submissions1->eof()}end{/if}separator">&nbsp;</td>
	</tr>

{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" align="left">{$count} active submission(s)</td>
	</tr>
{/if}
</table>

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">APPROVED PROPOSALS, RESEARCH ONGOING</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="5%">{sort_heading key="submissions.sec" sort="section"}</td>
		<td width="25%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.title" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


{assign var="count" value=0}

{iterate from=submissions2 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision()}

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_ACCEPT) || $status==PROPOSAL_STATUS_EXEMPTED}

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}{else}&mdash;{/if}</td>
                <td>{$submission->getSectionAbbrev()|escape}</td>
                <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>

                <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
                <td align="right">

                    {if $status==PROPOSAL_STATUS_REVIEWED}
                        {if $decision==SUBMISSION_EDITOR_DECISION_ACCEPT}
                            {translate key="submissions.proposal.approved"}<br />
                            <a href="{url op="complete" path=$articleId}" class="action">Complete</a><br />
                            <a href="{url op="addSuppFile" path=$articleId}" class="action">Upload Progress Report</a><br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmWithdraw"}')">{translate key="common.withdraw"}</a>
                            {assign var="count" value=$count+1}
                        {/if}
                    {elseif $status==PROPOSAL_STATUS_EXEMPTED}
                        {translate key="submissions.proposal.exempted"}<br />
                        <a href="{url op="complete" path=$articleId}" class="action">Complete</a><br />
                        <a href="{url op="addSuppFile" path=$articleId}" class="action">Upload Progress Report</a><br />
                        <a href="{url op="withdrawSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmWithdraw"}')">{translate key="common.withdraw"}</a>
                        {assign var="count" value=$count+1}
                    {/if}
                 </td>
            </tr>
            <tr>
                    <td colspan="6" class="{if $submissions2->eof()}end{/if}separator">&nbsp;</td>
            </tr>
        {/if}
{/iterate}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" align="left">{$count} submission(s)</td>
	</tr>
{/if}
</table>

</div>

