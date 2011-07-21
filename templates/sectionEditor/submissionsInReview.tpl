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
<p></p>
{assign var="count" value=0}
{foreach from=$submissions item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status!=PROPOSAL_STATUS_DRAFT && $status!=PROPOSAL_STATUS_REVIEWED && $status != PROPOSAL_STATUS_EXEMPTED) || $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
				<td>{$submission->getSectionAbbrev()|escape}</td>
				<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
				<td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
					{translate key=$proposalStatusKey}
					{if $submission->isSubmissionDue()} 
						({translate key="submissions.proposal.forContinuingReview"}) 
					{/if}					
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/foreach}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} submission(s)</td>
	</tr>
{/if}
</table>
<br/><br/>
<table class="listing" width="100%">
        <tr><td colspan="6">APPROVED PROPOSALS (Research Ongoing)</td></tr>
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
<p></p>
{assign var="count" value=0}
{foreach from=$submissions item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_ACCEPT)}		
			{assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
				<td>{$submission->getSectionAbbrev()|escape}</td>
				<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
				<td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
				<td align="right">
					{assign var="displayStatus" value=$submission->getEditorDecisionKey()}
					{translate key=$displayStatus}{if $submission->isSubmissionDue()}&nbsp; ({translate key="submissions.proposal.forContinuingReview"}){/if}
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/foreach}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} submission(s)</td>
	</tr>
{/if}
</table>

<br/><br/>
<table class="listing" width="100%">
        <tr><td colspan="6">NOT APPROVED</td></tr>
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
<p></p>
{assign var="count" value=0}
{foreach from=$submissions item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_DECLINE)}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
				<td>{$submission->getSectionAbbrev()|escape}</td>
				<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
				<td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
					{if $status == PROPOSAL_STATUS_EXEMPTED}
						{translate key=$proposalStatusKey}	
					{else}
						{assign var="editorDecisionKey" value=$submission->getEditorDecisionKey()}
						{translate key=$editorDecisionKey}
					{/if}
				
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/foreach}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} submission(s)</td>
	</tr>
{/if}
</table>


<br/><br/>
<table class="listing" width="100%">
        <tr><td colspan="6">EXEMPT FROM REVIEW</td></tr>
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
<p></p>
{assign var="count" value=0}
{foreach from=$submissions item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if $status==PROPOSAL_STATUS_EXEMPTED}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
				<td>{$submission->getSectionAbbrev()|escape}</td>
				<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
				<td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
					{if $status == PROPOSAL_STATUS_EXEMPTED}
						{translate key=$proposalStatusKey}	
					{else}
						{assign var="editorDecisionKey" value=$submission->getEditorDecisionKey()}
						{translate key=$editorDecisionKey}
					{/if}
				
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
			</tr>
		{/if}
{/foreach}
{if $count==0}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} submission(s)</td>
	</tr>
{/if}
</table>


</div>

