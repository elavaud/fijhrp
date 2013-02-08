{**
 * index.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Editor index.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="editor.home"}
{assign var="pageCrumbTitle" value="user.role.coordinator"}
{include file="common/header.tpl"}
{/strip}

<div id="articleSubmissions">
<h3>{translate key="article.submissions"}</h3>
<ul class="plain">
	<!--<li>&#187; <a href="{url op="submissions" path="submissionsUnassigned"}">{translate key="common.queue.short.submissionsUnassigned"}</a>&nbsp;({if $submissionsCount[0]}{$submissionsCount[0]}{else}0{/if})</li>-->
	<li>&#187; <a href="{url op="submissions" path="submissionsInReview"}">{translate key="common.queue.short.submissionsInReview"}</a>&nbsp;({if $submissionsCount[1]}{$submissionsCount[1]}{else}0{/if})</li>
	<!--{*	 *
	<li>&#187; <a href="{url op="submissions" path="submissionsInEditing"}">{translate key="common.queue.short.submissionsInEditing"}</a>&nbsp;({if $submissionsCount[2]}{$submissionsCount[2]}{else}0{/if})</li>
	 **}-->
	<li>&#187; <a href="{url op="submissions" path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
	{call_hook name="Templates::Editor::Index::Submissions"}
</ul>
</div>

{**
 * Added section for meetings in editor home page
 * Last Updated: ayveemallare 7/5/2011
 *}
<!--
<div class="separator">&nbsp;</div>
<div id="meetings">
<h3>{translate key="editor.meetings"}</h3>
<ul class="plain">
	<li>&#187; <a href="{url op="meetings"}">{translate key="editor.meetings}</a></li>
</ul>
</div>
-->
{**
 * Added section for report generation
 * Last Updated: ayveemallare 10/9/2011
 *}
<div class="separator">&nbsp;</div>
<div id="reports">
<h3>{translate key="editor.reports.reportGenerator"}</h3>
<ul class="plain">
	<li>&#187; <a href="{url op="submissionsReport"}">{translate key="editor.reports.submissions"}</a>
	<!--<li>&#187; <a href="{url op="meetingAttendanceReport"}">{translate key="editor.reports.meetingAttendance"}</a>-->
</ul>
</div>

<div class="separator">&nbsp;</div>

&nbsp;<br />

{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}

<script type="text/javascript">
{literal}
<!--
function sortSearch(heading, direction) {
  document.submit.sort.value = heading;
  document.submit.sortDirection.value = direction;
  document.submit.submit() ;
}
// -->
{/literal}
</script> 
<!--

<form method="post" name="submit" action="{url path="search"}">
	{if $section}<input type="hidden" name="section" value="{$section|escape:"quotes"}"/>{/if}
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



	<h5>Filter by</h5>
	<select name="technicalUnitField" id="technicalUnit" class="selectMenu">
		<option value="">All Technical Units</option>
		{html_options options=$technicalUnits selected=$technicalUnitField}
    </select>
	<select name="countryField" id="country" class="selectMenu">
		<option value="">All Countries</option>
		{html_options options=$countries selected=$countryField}
    </select>
    <br/>
	<input type="submit" value="{translate key="common.search"}" class="button" />
</form>

-->
&nbsp;

{if $displayResults}
	<div id="submissions">

<table width="100%" class="listing">
	<tr>
		<td colspan="6" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="10%">WHO PROPOSAL ID</td>
		<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_search key="submissions.submit" sort="submitDate"}</td>
		<td width="30%">{sort_search key="article.authors" sort="authors"}</td>
		<td width="40%">{sort_search key="article.title" sort="title"}</td>
		<td width="15%" align="right">{sort_search key="common.status" sort="status"}</td>
	</tr>
	<tr>
		<td colspan="6" class="headseparator">&nbsp;</td>
	</tr>
	
	{iterate from=submissions item=submission}
	{assign var="highlightClass" value=$submission->getHighlightClass()}
	{assign var="fastTracked" value=$submission->getFastTracked()}
	<tr valign="top">
		<td>{$submission->getLocalizedWhoId()}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
		<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
		<td><a href="{url op="submission" path=$submission->getArticleId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:60:"..."}</a></td>
		<td align="right">
			{assign var="statusKey" value=$submission->getProposalStatusKey()}
			{translate key=$statusKey} 
			{if $submission->isSubmissionDue()}
				({translate key="submissions.proposal.forContinuingReview"})
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="6" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
	</tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="6" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="4" align="left">{page_info iterator=$submissions}</td>
		<td align="right" colspan="2">{page_links anchor="submissions" name="submissions" iterator=$submissions searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth dateSearchField=$dateSearchField section=$section sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>
{else}

{/if}{* displayResults *}

{call_hook name="Templates::Editor::Index::AdditionalItems"}

{include file="common/footer.tpl"}

