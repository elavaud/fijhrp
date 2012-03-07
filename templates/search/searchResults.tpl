{**
 * searchResults.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Display article search results.
 *
 * $Id$
 *}
{strip}
{assign var=pageTitle value="search.searchResults"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">
{literal}
<!--
function ensureKeyword() {
	if (document.search.query.value == '') {
		alert({/literal}'{translate|escape:"jsparam" key="search.noKeywordError"}'{literal});
		return false;
	}
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

<br/>
<form name="revise" action="{url op="advanced"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>
<a href="javascript:document.revise.submit()" class="action">{translate key="search.reviseSearch"}</a>&nbsp;&nbsp;
<a href="javascript:document.generate.submit()" class="action">Export Search Results</a><br />
<form name="generate" action="{url op="generateCSV"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>
<br/>
<h4>Search for '{$query}' {if $dateFrom != '--'} from {$dateFrom|date_format:$dateFormatShort}{/if} {if $dateTo != '--'} from {$dateTo|date_format:$dateFormatShort}{/if} returned {$count} result(s). </h4>
<div id="results">
<table width="100%" class="listing">
<tr class="heading" valign="bottom">
		<td>{translate key='common.dateSubmitted'}</td>
		<td>{translate key='article.title'}</td>
		<td>{translate key='search.primaryInvestigator'}</td>
		<td>{translate key='search.finalDecision'}</td>
</tr>
<tr>
	<td colspan="4" class="headseparator">&nbsp;</td>
</tr>
<p></p>
{foreach from=$results item=result}
<tr valign="bottom">
	<td>{$result->getDateSubmitted()|date_format:$dateFormatShort}</td>
	<td><a href="{url op="viewProposal" path=$result->getId()}" class="action">{$result->getTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
	<td>{$result->getPrimaryAuthor()}</td>
	{assign var="decision" value=$result->getEditorDecisionKey()}
	<td>{translate key=$decision} on {$result->getDateStatusModified()|date_format:$dateFormatShort}</td>
</tr>
<tr>
	<td colspan="4" class="separator">&nbsp;</td>
</tr>
{/foreach}
<tr>
	<td colspan="4" class="endseparator">&nbsp;</td>
</tr>
</table>
</div>	

{include file="common/footer.tpl"}

