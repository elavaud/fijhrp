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
        <tr><td colspan="6">{translate key="submissions.active"}</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">{translate key="common.proposalId"}</td>
		<td width="5%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="25%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="35%">{sort_heading key="article.title" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions1 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status!=PROPOSAL_STATUS_DRAFT && $status!=PROPOSAL_STATUS_REVIEWED && $status != PROPOSAL_STATUS_EXEMPTED) || $decision==SUBMISSION_SECTION_DECISION_RESUBMIT}		
			{assign var="count" value=$count+1}
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
			<tr valign="top">
				<td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
				<td><a href="{url op="submission" path=$submission->getId()}" class="action">{$abstract->getScientificTitle()|strip_unsafe_html}</a></td>
				<td align="right">
					{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
					{translate key=$proposalStatusKey}
					{if $submission->isSubmissionDue()} 
						({translate key="submission.status.continuingReview"}) 
					{/if}					
				</td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
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
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} {translate key="article.article.s"}</td>
	</tr>
{/if}
</table>
<br/><br/>
<table class="listing" width="100%">
        <tr><td colspan="7">{translate key="submissions.approved"}</td></tr>
	<tr><td colspan="7" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">{translate key="common.proposalId"}</td>
		<td width="10%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="20%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="50%">{sort_heading key="article.title" sort="title"}</td>
		<td width="10%" align="right">{translate key="editor.submission.dateOfApproval"}</td>
	</tr>
	<tr><td colspan="7" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions2 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
     {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_SECTION_DECISION_APPROVED)}
        	{assign var="count" value=$count+1}		
			{assign var="articleId" value=$submission->getArticleId()}
            {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
			<tr valign="top">
				<td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
				<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td>  *}--> <!-- Commented out by MSB -->
                <!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *} Commented out by MSB -->
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->

				<td><a href="{url op="submission" path=$submission->getId()}" class="action">{$abstract->getScientificTitle()|strip_unsafe_html}</a></td>
				<td>{$submission->getApprovalDate($submission->getLocale())|date_format:$dateFormatLong}</td>
			</tr>
			<tr>
				<td colspan="7" class="separator">&nbsp;</td>
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
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} {translate key="article.article.s"}</td>
	</tr>
{/if}
</table>

<br/><br/>
<table class="listing" width="100%">
        <tr><td colspan="6">{translate key="submissions.declined"}</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">{translate key="common.proposalId"}</td>
		<td width="10%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="20%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="60%">{sort_heading key="article.title" sort="title"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions3 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_SECTION_DECISION_DECLINED)}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
				{* <td>{$submission->getSectionAbbrev()|escape}</td> *}
				<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *}  Commented out by MSB -->
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
                <td><a href="{url op="submission" path=$submission->getId()}" class="action">{$abstract->getScientificTitle()|strip_unsafe_html}</a></td>	
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
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
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} {translate key="article.article.s"}</td>
	</tr>
{/if}
</table>


<br/><br/>
<table class="listing" width="100%">
        <tr><td colspan="6">EXEMPT FROM REVIEW</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">{translate key="common.proposalId"}</td>
		<td width="10%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="20%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="60%">{sort_heading key="article.title" sort="title"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<p></p>
{assign var="count" value=0}
{iterate from=submissions4 item=submission}	
	{assign var="status" value=$submission->getSubmissionStatus()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
        {assign var="decision" value=$submission->getMostRecentDecision() }

        {if $status==PROPOSAL_STATUS_EXEMPTED}		
			
            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
			{assign var="count" value=$count+1}
			<tr valign="top">
				<td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
				<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
   				<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td>
                <td><a href="{url op="submission" path=$submission->getId()}" class="action">{$abstract->getScientificTitle()|strip_unsafe_html}</a></td>		
			</tr>
			<tr>
				<td colspan="6" class="separator">&nbsp;</td>
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
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" align="left">{$count} {translate key="article.article.s"}</td>
	</tr>
{/if}


{if $submissions1->wasEmpty()}
<!--	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
-->
{else}
	<tr>
		<td colspan="4" align="left">{page_info iterator=$submissions1}</td>
		<td align="right" colspan="2">{page_links anchor="submissions" name="submissions" iterator=$submissions1 searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}

</table>


</div>

