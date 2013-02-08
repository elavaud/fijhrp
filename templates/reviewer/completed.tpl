{**
 * completed.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show reviewer's submission archive.
 *
 * $Id$
 *}
 {if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}
 <form method="post" name="submit" action="{url op='index' path='completed'}">
	<input type="hidden" name="sort" value="id"/>
	<input type="hidden" name="sortDirection" value="ASC"/>
	<select name="searchField" size="1" class="selectMenu">
		{html_options_translate options=$fieldOptions selected=$searchField}
	</select>
	<select name="searchMatch" size="1" class="selectMenu">
		<option value="contains"{if $searchMatch == 'contains'} selected="selected"{/if}>{translate key="form.contains"}</option>
		<option value="is"{if $searchMatch == 'is'} selected="selected"{/if}>{translate key="form.is"}</option>
		<option value="startsWith"{if $searchMatch == 'startsWith'} selected="selected"{/if}>{translate key="form.startsWith"}</option>
	</select>
	<input type="text" size="15" name="search" class="textField" value="{$search|escape}" />
	<br/>
	<select name="dateSearchField" size="1" class="selectMenu">
		{html_options_translate options=$dateFieldOptions selected=$dateSearchField}
	</select>
	{translate key="common.between"}
	{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	{translate key="common.and"}
	{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	<input type="hidden" name="dateToHour" value="23" />
	<input type="hidden" name="dateToMinute" value="59" />
	<input type="hidden" name="dateToSecond" value="59" />
	<br/>
	
	<!-- Allows filtering by technical unit and country -->
	<!-- Added by: igm 9/24/2011                        -->
	<!--
	<h5>Filter by</h5>
	<select name="technicalUnitField" id="technicalUnit" class="selectMenu">
		<option value="">All Technical Units</option>
		{html_options options=$technicalUnits selected=$technicalUnitField}
    </select>
	<select name="countryField" id="country" class="selectMenu">
		<option value="">All Countries</option>
		{html_options options=$countries selected=$countryField}
    </select>-->
    <br/>
	<input type="submit" value="{translate key="common.search"}" class="button" />
</form>
<br/><br/><br/>
<div id="submissions">
<table class="listing" width="100%">
	<tr><td colspan="5"><strong>ARCHIVED PROPOSALS</strong></td></tr>
	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="10%">ID</td>
		<td width="10%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="common.assigned" sort="assignDate"}</td>
		<!-- <td width="5%">{sort_heading key="submissions.sec" sort="section"}</td> *} Commented out by MSB, Sept25,2011-->
		<td width="40%">{sort_heading key="article.title" sort="title"}</td>
		<td width="20%">{sort_heading key="submission.review" sort="review"}</td>
		<td width="20%">{sort_heading key="submission.editorDecision" sort="decision"}</td>
	</tr>
	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
{iterate from=submissions2 item=submission}
	{assign var="articleId" value=$submission->getLocalizedWhoId()}
	{assign var="reviewId" value=$submission->getReviewId()}
	<tr valign="top">
		<td width="10%">{$articleId|escape}</td>
		<td width="10%">{$submission->getDateNotified()|date_format:$dateFormatLong}</td>
		<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} Commented out by MSB,Sept25,2011-->
		<td width="40%">{if !$submission->getDeclined()}<a href="{url op="submission" path=$reviewId}" class="action">{/if}{$submission->getLocalizedTitle()|escape}{if !$submission->getDeclined()}</a>{/if}</td>
		<td width="20%">
			{if $submission->getCancelled()}
				Canceled
			{elseif $submission->getDeclined()}
				Declined
			{else}
				{assign var=recommendation value=$submission->getRecommendation()}
				{if $recommendation === '' || $recommendation === null}
					&mdash;
				{else}
					{translate key=$reviewerRecommendationOptions.$recommendation}
				{/if}
			{/if}
		</td>
		<td width="20%">
			{*if $submission->getCancelled() || $submission->getDeclined()}
				&mdash;
			{else*}
			{* Display the most recent editor decision *}
			{assign var=round value=$submission->getRound()}
			{assign var=decisions value=$submission->getDecisions($round)}
			{foreach from=$decisions item=decision name=lastDecisionFinder}
				{if $smarty.foreach.lastDecisionFinder.last and $decision.decision == SUBMISSION_EDITOR_DECISION_ACCEPT}
					{translate key="editor.article.decision.accept"}
				{elseif $smarty.foreach.lastDecisionFinder.last and $decision.decision == SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS}
					{translate key="editor.article.decision.pendingRevisions"}
				{elseif $smarty.foreach.lastDecisionFinder.last and $decision.decision == SUBMISSION_EDITOR_DECISION_RESUBMIT}
					{translate key="editor.article.decision.resubmit"}
				{elseif $smarty.foreach.lastDecisionFinder.last and $decision.decision == SUBMISSION_EDITOR_DECISION_DECLINE}
					{translate key="editor.article.decision.decline"}
				{else}
					&mdash;
				{/if}
			{foreachelse}
				&mdash;
			{/foreach}
			{*/if*}
		</td>
	</tr>
	<tr>
		<td colspan="5" class="{if $submissions2->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions2->wasEmpty()}
	<tr>
		<td colspan="5" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="5" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="4" align="left">{page_info iterator=$submissions2}</td>
		<td colspan="3" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions2 sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>


