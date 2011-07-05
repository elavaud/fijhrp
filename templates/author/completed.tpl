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
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<!--<td width="5%">{sort_heading key="submissions.sec" sort="section"}</td>-->
		<td width="23%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="32%">{sort_heading key="article.title" sort="title"}</td>
		{if $statViews}<td width="5%">{sort_heading key="submission.views" sort="views"}</td>{/if}
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td class="headseparator" colspan="{if $statViews}7{else}6{/if}">&nbsp;</td></tr>
{iterate from=submissions1 item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
        {assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
	<tr valign="top">
		<td>{$whoId|escape}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
		<!--<td>{$submission->getSectionAbbrev()|escape}</td>-->
		<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
		<td><a href="{url op="submission" path=$articleId}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}</a></td>
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
                            {translate key="submissions.proposal.withdrawn"}
                        {elseif $status==PROPOSAL_STATUS_COMPLETED}
                            {translate key="submissions.proposal.completed"}<br />
                            <a href="{url op="addCompletionReport" path=$articleId}" class="action">Add Completion Report</a><br />
                        {elseif $status==PROPOSAL_STATUS_ARCHIVED}
                            {assign var="decision" value=$submission->getMostRecentDecision()}
                            {if $decision==SUBMISSION_EDITOR_DECISION_DECLINE}
                                {translate key="submissions.proposal.decline"}
                            {elseif $decision==SUBMISSION_EDITOR_DECISION_EXEMPTED}
                                {translate key="submissions.proposal.exempted"}
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

