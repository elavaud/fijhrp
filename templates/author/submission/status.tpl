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
                        {if $status==PROPOSAL_STATUS_DRAFT}{translate key="submissions.proposal.draft"}
                        {elseif $status==PROPOSAL_STATUS_WITHDRAWN}{translate key="submissions.proposal.withdrawn"}
                        {elseif $status==PROPOSAL_STATUS_COMPLETED}{translate key="submissions.proposal.completed"}
                        {elseif $status==PROPOSAL_STATUS_ARCHIVED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_EDITOR_DECISION_DECLINE}
                                Archived({translate key="submissions.proposal.decline"})
                            {elseif $decision==SUBMISSION_EDITOR_DECISION_EXEMPTED}
                                Archived({translate key="submissions.proposal.exempted"})
                            {/if}
                        {elseif $status==PROPOSAL_STATUS_SUBMITTED}{translate key="submissions.proposal.submitted"}
                        {elseif $status==PROPOSAL_STATUS_CHECKED}{translate key="submissions.proposal.checked"}
                        {elseif $status==PROPOSAL_STATUS_EXPEDITED}{translate key="submissions.proposal.expedited"}
                        {elseif $status==PROPOSAL_STATUS_ASSIGNED}{translate key="submissions.proposal.assigned"}
                        {elseif $status==PROPOSAL_STATUS_RETURNED}{translate key="submissions.proposal.returned"}
                        {elseif $status==PROPOSAL_STATUS_EXEMPTED}{translate key="submissions.proposal.exempted"}
                        {elseif $status==PROPOSAL_STATUS_REVIEWED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}{translate key="submissions.proposal.resubmit"}
                            {elseif $decision==SUBMISSION_EDITOR_DECISION_ACCEPT}{translate key="submissions.proposal.approved"}
                            {elseif $decision==SUBMISSION_EDITOR_DECISION_DECLINE}{translate key="submissions.proposal.decline"}
                            
                            {/if}
                        {/if}
		</td>
	</tr>
	<tr>
		<td class="label">Date</td>
		<td colspan="2" class="value">{$submission->getDateStatusModified()|date_format:$dateFormatShort}</td>
	</tr>
        {*
	<tr>
		<td class="label">{translate key="submission.lastModified"}</td>
		<td colspan="2" class="value">{$submission->getLastModified()|date_format:$dateFormatShort}</td>
	</tr>
        *}
</table>
</div>
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

