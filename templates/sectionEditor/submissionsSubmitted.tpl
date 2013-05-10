{**
 * submissionsInReview.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show section editor's submissions in review.
 *
 * $Id$
 *}
<br/><br/>
<div id="submissions">
<table class="listing" width="100%">
	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">{translate key="common.proposalId"}</td>
		<td width="5%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="25%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.title" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
<p></p>

{iterate from=submissions item=submission}

	{assign var="status" value=$submission->getSubmissionStatus()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
			<tr valign="top">
				<td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
	   			<td>{$submission->getFirstAuthor()|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
           		<td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$abstract->getScientificTitle()|escape}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey($status)}
					{if ($submission->getMostRecentDecision()) == SUBMISSION_SECTION_DECISION_RESUBMIT}
						{translate key="editor.article.resubmittedMsg1} ({translate key=$submission->getEditorDecisionKey()})						
					{else}
						{translate key=$proposalStatusKey}
						{assign var="sectionDecision" value=$submission->getLastSectionDecision()}
						{if $sectionDecision}
							{assign var="reviewAssignments" value=$sectionDecision->getReviewAssignments()}
							{assign var="decisionAllowed" value="false"}
							{if $reviewAssignments}
								{assign var="decisionAllowed" value="true"}
								{foreach from=$reviewAssignments item=reviewAssignment}
									{if !$reviewAssignment->getRecommendation()}
										{assign var="decisionAllowed" value="false"}
									{/if}
								{/foreach}
							{/if}
						{/if}
						{if ($status == PROPOSAL_STATUS_FULL_REVIEW) && ($decisionAllowed == "true")}
							&nbsp;({translate key="editor.article.recommendationAvailable"})
						{/if}
						{if $submission->isSubmissionDue()} 
							({translate key="submission.status.continuingReview"}) 
						{/if}
					{/if}
				</td>		
			</tr>
			<tr>
				<td colspan="5" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
			</tr>
		<!--{*/if*}-->
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="5" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="5" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="5" align="left">{page_info iterator=$submissions}</td>
		<td align="right" colspan="2">{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>

