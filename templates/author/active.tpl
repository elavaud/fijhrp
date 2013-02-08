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
<head>
{popup_init src="lib/pkp/js/overlib.js"}
</head>

<div id="submissions">
<table class="listing" width="100%">
        <tr><td colspan="6">ACTIVE PROPOSALS (Awaiting Decision/Revise and Resubmit)</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">Proposal ID</td>
		<td width="10%"><span class="disabled">{*{translate key="submission.date.yyyymmdd"}</span><br />*}{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<!-- {* <td width="5%">{sort_heading key="submissions.sec" sort="section"}</td> *} -->
		{*<td width="25%">{sort_heading key="article.authors" sort="authors"}</td>*}
		<td width="45%">{sort_heading key="article.title" sort="title"}</td>
		<td width="30%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

{assign var="count" value=0}
{iterate from=submissions1 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
    {assign var="decision" value=$submission->getMostRecentDecision() }
        
    {if ($status!=PROPOSAL_STATUS_REVIEWED && $status != PROPOSAL_STATUS_EXEMPTED) || $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT || $status==PROPOSAL_STATUS_EXTENSION }

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
                <!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} -->
                <!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *} Commented out by MSB, Sept25, 2011 -->
   				{*<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td>*} <!-- Get first author. Added by MSB, Sept 25, 2011 -->
                {if $status==PROPOSAL_STATUS_DRAFT}
                    {assign var="count" value=$count+1}
                    {assign var="progress" value=$submission->getSubmissionProgress()}
                    <td><a href="{url op="submit" path=$progress articleId=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
                {else}
                    <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}{else}{translate key="common.untitled"}{/if}</a></td>
                {/if}
                <td align="right">
                        {if $status==PROPOSAL_STATUS_DRAFT}
                            {translate key="submissions.proposal.draft"}<br /><a href="{url op="deleteSubmission" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmDelete"}')">{translate key="common.delete"}</a>
                        {elseif $status==PROPOSAL_STATUS_SUBMITTED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.submitted"}<br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_CHECKED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.checked"}<br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_EXPEDITED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.expedited"}<br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_ASSIGNED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.assigned"}<br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>

                        {elseif $status==PROPOSAL_STATUS_RETURNED}
                            {assign var="count" value=$count+1}
                            {translate key="submissions.proposal.returned"}<br />
                            <a href="{url op="resubmit" path=$articleId}" class="action">Resubmit</a><br />
                            <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>
                            
                        {elseif $status==PROPOSAL_STATUS_REVIEWED}
                            {if $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}
                                {assign var="count" value=$count+1}
                                {translate key="submissions.proposal.resubmit"}<br />
                                <a href="{url op="resubmit" path=$articleId}" class="action">Resubmit</a><br />
                                <a href="{url op="withdrawSubmission" path=$articleId}" class="action" >{translate key="common.withdraw"}</a>
                                
                            {/if}
                        {/if}
                 </td>
            </tr>
            <tr>
		<td colspan="6" class="{if $submissions1->eof()}end{/if}separator">&nbsp;</td>
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
		<td colspan="6" align="left">{$count} active submission(s)</td>
	</tr>
{/if}
</table>

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">APPROVED PROPOSALS (Research Ongoing)</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">Proposal ID</td>
		<td width="5%"><span class="disabled">{*{translate key="submission.date.yyyymmdd"}</span><br />*}{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="40%">{sort_heading key="article.title" sort="title"}</td>
		<td width="40%">{sort_heading key="common.status" sort="status"}</td>
		<td width="10%">Approval Date</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


{assign var="count" value=0}

{iterate from=submissions2 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision()}

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_ACCEPT) ||  ($status==PROPOSAL_STATUS_EXEMPTED)}
            {assign var="count" value=$count+1}

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>                
                <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
                <td>
                	{if ($status==PROPOSAL_STATUS_EXEMPTED)}
                		{translate key="submissions.proposal.exempted"}
                	{else}
                    	{translate key="submissions.proposal.approved"}
                    {/if}
                    {if $submission->isSubmissionDue()}
                    	&nbsp;(For Continuing Review)
                    {/if}
                    <br />
                    {if $submission->isSubmissionDue()}
						<a href="{url op="addExtensionRequest" path=$articleId}" {popup text="RTO seeking an extension of time for their research must submit a request letter via this option." fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA} class="action">&#187; Submit Extension Request</a><br />
                    {/if}
                    <a href="{url op="addProgressReport" path=$articleId}" class="action")>&#187; Submit Interim Progress Report</a><br />
                    <a href="{url op="addCompletionReport" path=$articleId}" class="action">&#187; Submit Final Report</a><br />
                    <a href="{url op="addRawDataFile" path=$articleId}" {popup text="The final data set use for final analysis (Excel, SAS, SPSS or Stata)." fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA} class="action">&#187; Upload Raw Data</a><br />
                    <a href="{url op="addOtherSuppResearchOutput" path=$articleId}"  {popup text="Journal publications, news, items or any others publications related to research." fgcolor=#F5F5F5 bgcolor=#D86422 textcolor=#196AAA} class="action">&#187; Upload Other Supplementary Research Output</a><br />

                    <a href="{url op="withdrawSubmission" path=$articleId}" class="action">&#187; {translate key="common.withdraw"}</a><br />            
                </td>
                <td align="center">
                	{if ($status==PROPOSAL_STATUS_EXEMPTED)}
                		{$submission->getDateStatusModified()|date_format:$dateFormatLong}
                	{else}{
                		$submission->getApprovalDate($submission->getLocale())|date_format:$dateFormatLong}
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

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">NOT APPROVED</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">Proposal ID</td>
		<td width="10%"><span class="disabled">{*{translate key="submission.date.yyyymmdd"}*}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<!-- {* <td width="5%">{sort_heading key="submissions.sec" sort="section"}</td> *} -->
		{*<td width="25%">{sort_heading key="article.authors" sort="authors"}</td>*}
		<td width="45%">{sort_heading key="article.title" sort="title"}</td>
		<td width="30%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


{assign var="count" value=0}

{iterate from=submissions3 item=submission}
	{assign var="status" value=$submission->getSubmissionStatus()}
        {assign var="decision" value=$submission->getMostRecentDecision()}

        {if ($status==PROPOSAL_STATUS_REVIEWED && $decision==SUBMISSION_EDITOR_DECISION_DECLINE)}

            {assign var="articleId" value=$submission->getArticleId()}
            {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}

            <tr valign="top">
                <td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
                <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>                
                <td><a href="{url op="submission" path=$articleId}" class="action">{if $submission->getLocalizedTitle()}{$submission->getLocalizedTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
                <td align="right">
                    {assign var="count" value=$count+1}
                    {translate key="submissions.proposal.decline"}<br />
                    <a href="{url op="sendToArchive" path=$articleId}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="author.submissions.confirmArchive"}')">{translate key="common.sendtoarchive"}</a>
                 </td>
            </tr>
            <tr>
                    <td colspan="6" class="{if $submissions3->eof()}end{/if}separator">&nbsp;</td>
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
