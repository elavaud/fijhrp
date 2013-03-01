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

function showExportOptions(){
	$('#exportOptions').show();
	$('#showExportOptions').hide();
	$('#hideExportOptions').show();
}

function hideExportOptions(){
	$('#exportOptions').hide();
	$('#hideExportOptions').hide();
	$('#showExportOptions').show();
}

$(document).ready(
	function (){
		$('#exportOptions').hide();
		$('#hideExportOptions').hide();
	}
);
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
<a href="#top" onclick="showExportOptions()" class="action" id="showExportOptions">|  &nbsp;Export Search Results&nbsp;&nbsp;</a>
<a href="#top" onclick="hideExportOptions()" class="action" id="hideExportOptions">|  &nbsp;Hide Export Options</a><br />
<!--
<a href="javascript:document.generate.submit()" class="action">| Export Search Results</a><br />
-->
<form name="generate" action="{url op="generateCustomizedCSV"}" method="post"  id="exportOptions">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<input type="hidden" name="region" value="{$region|escape}"/>
	<input type="hidden" name="statusFilter" value="{$statusFilter|escape}"/>
	<input type="hidden" name="dateFrom" value="{$dateFrom|escape}"/>
	<input type="hidden" name="dateTo" value="{$dateTo|escape}"/>
	
	<table class="data" width="100%">
	<tr><i><br />Please check fields you would like to export.<br /></i></tr>
	<tr>
	<td colspan="4" class="headseparator"></td>
	</tr>
	<tr>
	<td><br /><strong>Investigators :</strong></td>
	</tr>
	<tr valign="top">
		<td width="20%" class="value">
			<input type="checkbox" name="investigatorName" checked="checked"/>&nbsp;Investigator Name
		</td>
		<td width="20%" class="value">
			<input type="checkbox" name="investigatorAffiliation"/>&nbsp;Investigator Affiliation
		</td>
		<td width="20%" class="value">
			<!--<input type="checkbox" name="investigatorEmail"/>&nbsp;Investigator e-mail-->
		</td>
	</tr>
	<tr>
	<td colspan="4" class="separator"></td>
	</tr>
	<tr>
	<td><strong>Metadata :</strong></td>
	</tr>
	<tr valign="top">
		<td width="20%" class="value">
			<input type="checkbox" name="title" checked="checked"/>&nbsp;Title
		</td>
		<td width="20%" class="value">
			<input type="checkbox" name="researchField" checked="checked"/>&nbsp;Research Field
		</td>
		<td width="20%" class="value">
			<input type="checkbox" name="proposalType" checked="checked"/>&nbsp;Proposal Type
		</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="value">
			<input type="checkbox" name="duration" checked="checked"/>&nbsp;Duration
		</td>
		<td width="20%" class="value">
			<input type="checkbox" name="area" checked="checked"/>&nbsp;Geographical Area
		</td>
		<td width="20%" class="value">
			<input type="checkbox" name="dataCollection"/>&nbsp;Data Collection
		</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="value">
			<input type="checkbox" name="status" checked="checked"/>&nbsp;Status
		</td>
		<td width="20%" class="value">
			<input type="checkbox" name="primarySponsor" checked="checked"/>&nbsp;Primary Sponsor
		</td>
		<td width="20%" class="value">
			<input type="checkbox" name="fundsRequired" />&nbsp;Funds Required
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="dateSubmitted" />&nbsp;Date submitted to PhilHRP
		</td>
		<td colspan="2" class="value">
			<input type="checkbox" name="studentResearch" checked="checked"/>&nbsp;If student research, Institution & Academic Degree
		</td>
		<td></td>
	</tr>
	<tr>
	<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
	</table>
	<p><input type="submit" value="Export" class="button defaultButton"/>
</form>

<br/>
<h4>{if $statusFilter == 1}Complete Research:<br/>{/if}{if $statusFilter == 2}Ongoing Research:<br/>{/if}Search {if $query}for '{$query}' {/if}{if $dateFrom != '--'} from {$dateFrom|date_format:$dateFormatLong}{/if} {if $dateFrom != '--' && $dateTo != '--'} and {/if}{if $dateTo != '--'} until {$dateTo|date_format:$dateFormatLong}{/if}{if $country} in {$country} {/if} returned {$count} result(s). </h4>
<div id="results">
<table width="100%" class="listing">
<tr class="heading" valign="bottom">
		<!--<td>{translate key='common.dateSubmitted'}</td>-->
		<td>{translate key='article.title'}</td>
		<td>{translate key='search.primarySponsor'}</td>
		<td>{translate key='search.region'}</td>
		<td>{translate key='search.researchField'}</td>
		<td>Dates of research</td>
		<td>Status</td>
</tr>
<tr>
	<td colspan="7" class="headseparator">&nbsp;</td>
</tr>
<p></p>
{foreach from=$results item=result}
<tr valign="bottom">
	<!--<td>{$result->getDateSubmitted()|date_format:$dateFormatShort}</td>-->
	<td><a href="{url op="viewProposal" path=$result->getId()}" class="action">{$result->getScientificTitle('en_US')|escape}</a></td>
	<td>
	{if $result->getLocalizedPrimarySponsor() == "Other"}
		{$result->getLocalizedOtherPrimarySponsor()}
	{else}
		{$result->getLocalizedPrimarySponsor()}
	{/if}
	</td>
	<td>
	{if $result->getLocalizedMultiCountryResearch() == "Yes"}
		Multi-country research
	{elseif $result->getLocalizedProposalCountry() == "NW"}
		Nationwide
	{else}
		{$result->getLocalizedProposalCountryText()}
	{/if}
	</td>
	<td>{$result->getLocalizedResearchFieldText()}</td>
	<td>{$result->getLocalizedStartDate()} to {$result->getLocalizedEndDate()}</td>
	<td>{if $result->getStatus() == 11}Complete{else}Ongoing{/if}</td>
</tr>
<tr>
	<td colspan="7" class="separator">&nbsp;</td>
</tr>
{/foreach}
<tr>
	<td colspan="7" class="endseparator">&nbsp;</td>
</tr>
</table>
</div>	

{include file="common/footer.tpl"}

