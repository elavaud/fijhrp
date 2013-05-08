{**
 * peerReview.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's peer review table.
 *
 * $Id$
 *}
<div id="peerReview">
<h3>{translate key="submission.peerReview"}</h3>

{assign var=start value="A"|ord}
{assign var="sectionDecisions" value=$submission->getDecisions()}
{foreach from=$sectionDecisions item=sDecision}
	{assign var="decisionId" value=$sDecision->getId()}
	{assign var="reviewerFiles" value=$sDecision->getAuthorViewableReviewFiles()}
	{assign var="editorFiles" value=$sDecision->getDecisionFiles()}
	{assign var="reviewType" value=$sDecision->getReviewType()}
	{assign var="decision" value=$sDecision->getDecision()}

	<table class="data" width="100%">
		<tr>
			<td colspan="2" class="separator">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%"><b>
				{if $reviewType == REVIEW_TYPE_INITIAL} {translate key="submission.initialReview"} 
				{elseif $reviewType == REVIEW_TYPE_CONTINUING} {translate key="submission.continuingReview"} 
				{elseif $reviewType == REVIEW_TYPE_AMENDMENT} {translate key="submission.protocolAmendment"} 
				{elseif $reviewType == REVIEW_TYPE_SAE} {translate key="submission.seriousAdverseEvents"} 
				{elseif $reviewType == REVIEW_TYPE_EOS} {translate key="submission.endOfStudy"} 
				{/if}
			</b></td>
			<td class="value" width="80%"><b>
				{if $decision == SUBMISSION_SECTION_DECISION_APPROVED} {translate key="submission.status.approved"} 
				{elseif $decision == SUBMISSION_SECTION_DECISION_RESUBMIT} {translate key="submission.status.reviseAndResubmit"} 
				{elseif $decision == SUBMISSION_SECTION_DECISION_DECLINED} {translate key="submission.status.declined"} 
				{elseif $decision == SUBMISSION_SECTION_DECISION_COMPLETE} {translate key="submission.status.complete"} 
				{elseif $decision == SUBMISSION_SECTION_DECISION_INCOMPLETE} {translate key="submission.status.incomplete"} 
				{elseif $decision == SUBMISSION_SECTION_DECISION_EXEMPTED} {translate key="submission.status.exempted"} 
				{elseif $decision == SUBMISSION_SECTION_DECISION_FULL_REVIEW} {translate key="submission.status.fullReview"} 
				{elseif $decision == SUBMISSION_SECTION_DECISION_EXPEDITED} {translate key="submission.status.expeditedReview"} 
				{/if}
			</b></td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">{translate key="common.dateDecided"}:</td>
			<td class="value" width="80%">{$sDecision->getDateDecided()|date_format:$dateFormatLong}</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">
				{translate key="submission.reviewFiles"}
			</td>
			<td class="value" width="80%">
				{foreach from=$reviewerFiles item=reviewerFile}
							<a href="{url op="downloadFile" path=$submission->getId()|to_array:$reviewerFile->getFileId()}" class="file">{$reviewerFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewerFile->getDateModified()|date_format:$dateFormatLong}<br />
				{foreachelse}
					{translate key="common.none"}
				{/foreach}
			</td>
		</tr>
		<tr valign="top">
			<td class="label" width="20%">
				{translate key="submission.decisionFile"}
			</td>
			<td class="value" width="80%">
				{foreach from=$editorFiles item=editorFile}
					<a href="{url op="downloadFile" path=$submission->getId()|to_array:$editorFile->getFileId()}" class="file">{$editorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$editorFile->getDateModified()|date_format:$dateFormatLong}<br />
				{foreachelse}
					{translate key="common.none"}
				{/foreach}
			</td>
		</tr>
		<!--
		<tr valign="top">
			<td class="label" width="20%">
				{translate key="submission.authorVersion"}
			</td>
			<td class="value" width="80%">
				{foreach from=$authorFiles item=authorFile key=key}
					<a href="{url op="downloadFile" path=$submission->getId()|to_array:$authorFile->getFileId()}" class="file">{$authorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$authorFile->getDateModified()|date_format:$dateFormatLong}<br />
				{foreachelse}
					{translate key="common.none"}
				{/foreach}
			</td>
		</tr>
		-->
	</table>
{/foreach}
</div>
