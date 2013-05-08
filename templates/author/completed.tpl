{**
 * completed.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the details of completed submissions.
 *
 * $Id$
 *}
<div id="submissions">
<table class="listing" width="100%">
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
	<tr valign="bottom" class="heading">
		<td width="10%">{translate key="common.proposalId"}</td>
		<td width="10%">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="45%">{sort_heading key="article.title" sort="title"}</td>
		{if $statViews}<td width="5%">{sort_heading key="submission.views" sort="views"}</td>{/if}
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
{iterate from=submissions1 item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
        {assign var="proposalId" value=$submission->getProposalId($submission->getLocale())}
	<tr valign="top">
		<td>{$proposalId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatShort}</td>
		<td><a href="{url op="submission" path=$articleId}" class="action">{$abstract->getScientificTitle()|escape}</a></td>
		{assign var="status" value=$submission->getSubmissionStatus()}
		{if $statViews}
			<td>
				{if $status==STATUS_PUBLISHED}
					{assign var=viewCount value=0}
					{foreach from=$submission->getGalleys() item=galley}
						{assign var=thisCount value=$galley->getViews()}
						{assign var=viewCount value=$viewCount+$thisCount}
					{/foreach}
					{$viewCount|escape}
				{else}
					&mdash;
				{/if}
			</td>
		{/if}
		<td align="right">
			{* {if $status==STATUS_ARCHIVED}{translate key="submissions.archived"}
			{elseif $status==STATUS_PUBLISHED}{print_issue_id articleId="$articleId"}
			{elseif $status==STATUS_DECLINED}{translate key="submissions.declined"}
                        *}
                        {if $status==PROPOSAL_STATUS_WITHDRAWN}
                            {translate key="submission.status.withdrawn"}
                        {elseif $status==PROPOSAL_STATUS_COMPLETED}
                            {translate key="submission.status.completed"}<br />
                        {elseif $status==PROPOSAL_STATUS_ARCHIVED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_SECTION_DECISION_DECLINED}
                                {translate key="submission.status.declined"}
                            {elseif $decision==SUBMISSION_SECTION_DECISION_EXEMPTED}
                                {translate key="submission.status.exempted"}
                            {/if}
                         {else}
                            BUG!
			{/if}
		</td>
	</tr>

	<tr>
		<td colspan="{if $statViews}7{else}6{/if}" class="{if $submissions1->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions1->wasEmpty()}
	<tr>
		<td colspan="{if $statViews}7{else}6{/if}" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="{if $statViews}7{else}6{/if}" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="{if $statViews}5{else}4{/if}" align="left">{page_info iterator=$submissions1}</td>
		<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions1 sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>

