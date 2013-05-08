{**
 * status.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission status table.
 *}
<div id="status">
<h3>{translate key="common.status"}</h3>

<table width="100%" class="data">
	<tr>
		{assign var="status" value=$submission->getSubmissionStatus()}
		<td title="Current review status of the proposal" width="20%" class="label">[?] {translate key="common.status"}</td>
		<td width="80%" class="value">
		
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
                        {elseif $status==PROPOSAL_STATUS_REVIEWED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_SECTION_DECISION_RESUBMIT}{translate key="submission.status.reviseAndResubmit"}
                            {elseif $decision==SUBMISSION_SECTION_DECISION_APPROVED}{translate key="submission.status.approved"}
                            {elseif $decision==SUBMISSION_SECTION_DECISION_DECLINED}{translate key="submission.status.declined"}
                            {elseif $decision==SUBMISSION_SECTION_DECISION_EXEMPTED}{translate key="submission.status.exempted"}
                            {/if}
                        {/if}
		</td>
	</tr>
	{if $status == PROPOSAL_STATUS_WITHDRAWN}
		<tr>
			<td class="label">&nbsp;</td>
			<td class="value">{translate key="common.reason"}: 
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
				<td class="value">{translate key="common.comments"}: {$submission->getWithdrawComments(en_US)}</td>
			</tr>
		{/if}
	{/if}
	<tr>
		<td title="Decision's date of the above current status." class="label">[?] Date</td>
		<td colspan="2" class="value">{$submission->getDateStatusModified()|date_format:$dateFormatLong}</td>
	</tr>
</table>
</div>

