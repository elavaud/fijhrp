{**
 * fullReview.tpl
 * Show reviewer's submissions for full review.
 *
 * $Id$
 *}
 {if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}
<!--
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
-->	
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
<!--
    <br/>
	<input type="submit" value="{translate key="common.search"}" class="button" />
</form>
-->
<div id="submissions">
<table class="listing" width="100%">
	<tr><td colspan="6"><strong>PROPOSALS FOR FULL REVIEW</strong></td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="20%">PROPOSAL ID</td> <!-- Replaced id with ID, SPF, 21 Dec 2011 -->
		<td width="20%">Date submitted</td>
		<td width="40%">{translate key="article.title" sort='title'}</td>
		<td width="20%">Investigator</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
{assign var="count" value=0}
{iterate from=submissionsForFullReview item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
		<tr valign="top">
			<td>{$submission->getLocalizedWhoId()|escape}</td>
			<td>{$submission->getDateSubmitted()|date_format:$dateFormatLong}</td>
			<td><a href="{url op="submissionForFullReview" path=$articleId}" class="action">{$submission->getLocalizedTitle()|escape}</a></td>
			<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td>
		</tr>
		
		
		<td colspan="6" class="separator">&nbsp;</td>
		{assign var="count" value=$count+1}
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
		<td colspan="6" align="left">{$count} submission(s) for Full Review</td>
	</tr>
{/if}
</table>
</div>


