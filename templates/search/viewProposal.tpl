
{strip}
{assign var=pageTitle value="search.summary"}
{include file="common/header.tpl"}
{/strip}

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
<a href="javascript:document.generate.submit()" class="action">Generate CSV</a><br />
<form name="generate" action="{url op="generateCSV"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>

<h3>Details</h3>
<table width="100%" class="data">
	<tr>
		<td width="20%" class="label">{translate key="article.authors"}</td>
		<td width="80%">{$submission->getAuthorString()|escape}</td>
	</tr>
	<tr>
		<td width="20%" class="label">{translate key="article.title"}</td>
		<td width="80%">{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td width="20%" class="label">{translate key="common.dateSubmitted"}</td>
		<td width="80%">{$submission->getDateSubmitted()|date_format:$dateFormatShort}</td>
	</tr>
	<tr>
		<td width="20%" class="label">WHO ID</td>
		<td width="80%">{$submission->getLocalizedWhoId()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Objectives</td>
		<td class="value">{$submission->getLocalizedObjectives()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Keywords</td>
		<td class="value">{$submission->getLocalizedKeywords()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Start Date</td>
		<td class="value">{$submission->getLocalizedStartDate()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">End Date</td>
		<td class="value">{$submission->getLocalizedEndDate()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Country</td>
		<td class="value">{$submission->getLocalizedProposalCountryText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text -->
	</tr>
	<tr>
		<td class="label">Technical Unit</td>
		<td class="value">{$submission->getLocalizedTechnicalUnitText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text -->
	</tr>
	<tr>
		<td class="label">Proposal Type</td>
		<td class="value">{$submission->getLocalizedProposalTypeText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text -->
	</tr>
</table>

<h3>Submission Metadata</h3>
<div id="authors">
<h4>{*translate key="article.authors"*}Primary Investigators</h4>
	
<table width="100%" class="data">
	{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top">
		<td width="20%" class="label">{translate key="user.name"}</td>
		<td width="80%" class="value">
			{assign var=emailString value=$author->getFullName()|concat:" <":$author->getEmail():">"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getLocalizedTitle()|strip_tags articleId=$submission->getId()}
			{$author->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	{if $author->getUrl()}
		<tr valign="top">
			<td class="label">{translate key="user.url"}</td>
			<td class="value"><a href="{$author->getUrl()|escape:"quotes"}">{$author->getUrl()|escape}</a></td>
		</tr>
	{/if}
	<tr valign="top">
		<td class="label">{translate key="user.affiliation"}</td>
		<td class="value">{$author->getLocalizedAffiliation()|escape|nl2br|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="common.country"}</td>
		<td class="value">{$author->getCountryLocalized()|escape|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="common.country"}</td>
		<td class="value">{$author->getEmail()|escape|default:"&mdash;"}</td>
	</tr>
	{/foreach}
</table>
</div>

<div id="titleAndAbstract">
<h4>Title and Abstract</h4>

<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{translate key="article.title"}</td>
		<td width="80%" class="value">{$submission->getLocalizedTitle()|strip_unsafe_html|default:"&mdash;"}</td>
	</tr>

	<tr>
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="article.abstract"}</td>
		<td class="value">{$submission->getLocalizedAbstract()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
</table>
</div>
