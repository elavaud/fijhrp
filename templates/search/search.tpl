{**
 * search.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Site/journal search form.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="navigation.search"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">
{literal}
<!--
function ensureKeyword() {
	document.search.submit();
	return true;
}
// -->
{/literal}
</script>

{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}
<div id="advancedSearch">
<form method="post" name="search" action="{url op="advancedResults"}">

<table class="data" width="100%">
<tr valign="top">
	<td width="25%" class="label"><label for="advancedQuery">Search from Title or Keyword(s)</label></td>
	<td width="75%" class="value"><input type="text" id="advancedQuery" name="query" size="40" maxlength="255" value="{$query|escape}" class="textField" /></td>
</tr>
<tr valign="top">
	<td colspan="2" class="formSubLabel"><h4>Start Date of the research</h4></td>
</tr>
<tr valign="top">
	<td class="label">From</td>
	<td class="value">{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"} &nbsp;&nbsp;&nbsp;&nbsp;(inclusive)</td>
</tr>
<tr valign="top">
	<td class="label">To</td>
	<td class="value">
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"} &nbsp;&nbsp;&nbsp;&nbsp;(inclusive)
			<input type="hidden" name="dateToHour" value="23" />
		<input type="hidden" name="dateToMinute" value="59" />
		<input type="hidden" name="dateToSecond" value="59" />
	</td>
</tr>
<tr valign="top">
	<td width="20%" class="label"><h4>Region</h4></td>
	<td width="80%" class="value"><br/>
        <select name="proposalCountry" id="proposalCountry" class="selectMenu">
            <option value="ALL">All</option>
			{html_options options=$proposalCountries selected=$proposalCountry[$formLocale][$i]}
        </select>
    </td>
</tr>
<tr valign="top">
	<td width="20%" class="label"><h4>Status</h4></td>
	<td width="80%" class="value">
		<br/>
    	<input type="radio" name="status" value="1"/> Complete
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="radio" name="status" value="2"/> Ongoing	
    </td>
</tr>
</table>

<p><input type="button" onclick="ensureKeyword();" value="{translate key="common.search"}" class="button defaultButton" /></p>

<script type="text/javascript">
<!--
	document.search.query.focus();
// -->
</script>
</form>
</div>

{include file="common/footer.tpl"}

