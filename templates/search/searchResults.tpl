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

<br/>

{if $basicQuery}
	<form method="post" name="search" action="{url op="results"}">
		<input type="text" size="40" maxlength="255" class="textField" name="query" value="{$basicQuery|escape}"/>&nbsp;&nbsp;
		<input type="hidden" name="searchField" value="{$searchField|escape}"/>
		<input type="submit" class="button defaultButton" onclick="ensureKeyword();" value="{translate key="common.search"}"/>
	</form>
	<br />
{else}
	<form name="revise" action="{url op="advanced"}" method="post">
		<input type="hidden" name="query" value="{$query|escape}"/>
		<input type="hidden" name="dateFromMonth" value="{$dateFromMonth|escape}"/>
		<input type="hidden" name="dateFromDay" value="{$dateFromDay|escape}"/>
		<input type="hidden" name="dateFromYear" value="{$dateFromYear|escape}"/>
		<input type="hidden" name="dateToMonth" value="{$dateToMonth|escape}"/>
		<input type="hidden" name="dateToDay" value="{$dateToDay|escape}"/>
		<input type="hidden" name="dateToYear" value="{$dateToYear|escape}"/>
	</form>
	<a href="javascript:document.revise.submit()" class="action">{translate key="search.reviseSearch"}</a><br />
{/if}

<div id="results">
<table width="100%" class="listing">
<tr class="heading" valign="bottom">
		<td>WHOID</td>
		<td>Date of Proposal</td>
		<td>Title</td>
		<td>Country</td>
		<td>Responsible Officer</td>
		<td>Principal Investigator</td>
		<td>Duration</td>
		<td>Decision of TRG/ERC and date</td>
</tr>
<tr>
	<td colspan="6" class="headseparator">&nbsp;</td>
</tr>
<p></p>
{foreach from=$results item=result}
<tr valign="bottom">
	<td>{$result->getWhoId()}</td>
	<td>{$result->getDateSubmitted()|date_format:$dateFormatShort}</td>
	<td>{$result->getTitle()}</td>
	<td>{$result->getProposalCountry()}</td>
	<td>{$result->getPrimaryEditor()}</td>
	<td>{$result->getPrimaryAuthor()} <br/>{$result->getAuthorEmail()}</td>
	<td>{$result->getStartDate()|date_format:$dateFormatShort} to {$result->getEndDate()|date_format:$dateFormatShort} </td>
	{assign var="decision" value=$result->getEditorDecisionKey()}
	<td>{translate key=$decision} on {$result->getDateStatusModified()|date_format:$dateFormatShort}</td>
</tr>
{/foreach}
</table>
<p>{translate key="search.syntaxInstructions"}</p>
</div>	

{include file="common/footer.tpl"}

