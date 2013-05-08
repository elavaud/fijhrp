{**
 * status.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission status table.
 *
 * $Id$
 *}
<div id="status">
<h3>{translate key="common.status"}</h3>

{* When editing this page, edit templates/sectionEditor/submission/status.tpl as well *}

<table width="100%" class="data">
	<tr>
		{assign var="status" value=$submission->getSubmissionStatus()}
		<td width="20%" class="label">{translate key="common.status"}</td>
		<td width="80%" class="value">
                        {*
			{if $status == STATUS_ARCHIVED}{translate key="submissions.archived"}
			{elseif $status==STATUS_QUEUED_UNASSIGNED}{translate key="submissions.queuedUnassigned"}
			{elseif $status==STATUS_QUEUED_EDITING}{translate key="submissions.queuedEditing"}
			{elseif $status==STATUS_QUEUED_REVIEW}{translate key="submissions.queuedReview"}
			{elseif $status==STATUS_PUBLISHED}{translate key="submissions.published"}&nbsp;&nbsp;&nbsp;&nbsp;{$issue->getIssueIdentification()|escape}
			{elseif $status==STATUS_DECLINED}{translate key="submissions.declined"}
			{/if}
                        *}
                        <!-- Edited by: AIM, July 4 2011 -->
                        {if $status==PROPOSAL_STATUS_DRAFT}{translate key="submission.status.draft"}
                        {elseif $status==PROPOSAL_STATUS_WITHDRAWN}{translate key="submission.status.withdrawn"}
                        {elseif $status==PROPOSAL_STATUS_COMPLETED}{translate key="submission.status.completed"}
                        {elseif $status==PROPOSAL_STATUS_ARCHIVED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_SECTION_DECISION_DECLINED}
                                Archived({translate key="submission.status.declined"})
                            {elseif $decision==SUBMISSION_SECTION_DECISION_EXEMPTED}
                                Archived({translate key="submission.status.exempted"})
                            {/if}
                        {elseif $status==PROPOSAL_STATUS_SUBMITTED}{translate key="submission.status.submitted"}
                        {elseif $status==PROPOSAL_STATUS_CHECKED}{translate key="submission.status.complete"}
                        {elseif $status==PROPOSAL_STATUS_EXPEDITED}{translate key="submission.status.expeditedReview"}
                        {elseif $status==PROPOSAL_STATUS_FULL_REVIEW}{translate key="submission.status.fullReview"}
                        {elseif $status==PROPOSAL_STATUS_RETURNED}{translate key="submission.status.incomplete"}
                        <br/><a href="{url op="resubmit" path=$submission->getId()}" class="action">Resubmit</a>
                        {elseif $status==PROPOSAL_STATUS_EXEMPTED}{translate key="submission.status.exempted"}
                        {elseif $status==PROPOSAL_STATUS_REVIEWED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_SECTION_DECISION_RESUBMIT}{translate key="submission.status.reviseAndResubmit"}
                       		<br/><a href="{url op="resubmit" path=$submission->getId()}" class="action">Resubmit</a>
                            {elseif $decision==SUBMISSION_SECTION_DECISION_APPROVED}{translate key="submission.status.approved"}
                            {elseif $decision==SUBMISSION_SECTION_DECISION_DECLINED}{translate key="submission.status.declined"}
                            
                            {/if}
                        {/if}
		</td>
	</tr>
	{if $status == PROPOSAL_STATUS_WITHDRAWN}
		<tr>
			<td class="label">&nbsp;</td>
			<td class="value">{translate key="submissions.proposal.withdrawnReason"}: 
				{if $submission->getWithdrawReason(en_US) == "0"}
					{translate key="submission.withdrawLack"}
				{elseif $submission->getWithdrawReason(en_US) == "1"}
					{translate key="submission.withdrawAdverse"}
				{else}
					{$submission->getWithdrawReason(en_US)}
				{/if}
			</td>
		</tr>
		{if $submission->getWithdrawComments(en_US)}
			<tr>
				<td class="label">&nbsp;</td>
				<td class="value">{translate key="submissions.proposal.withdrawnComment"}: {$submission->getWithdrawComments(en_US)}</td>
			</tr>
		{/if}
	{/if}
	<tr>
		<td class="label">{translate key="common.date"}</td>
		<td colspan="2" class="value">{$submission->getDateStatusModified()|date_format:$dateFormatLong}</td>
	</tr>
        {*
	<tr>
		<td class="label">{translate key="submission.lastModified"}</td>
		<td colspan="2" class="value">{$submission->getLastModified()|date_format:$dateFormatLong}</td>
	</tr>
        *}
</table>
</div>
{if $articleComments}
    <div class="separator"></div>
    <div id="articleComments">
        <h3>{translate key="common.comments"}</h3>
        <li>
        {foreach from=$articleComments item=comment}
            <ul>{$comment->getComments()} ({$comment->getAuthorName()}, {$comment->getDatePosted()})</ul>
        {/foreach}
        </li>
    </div>
{/if}

