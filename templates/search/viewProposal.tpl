
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
<!--<a href="javascript:document.generate.submit()" class="action">| Export Search Results</a><br />-->
<form name="generate" action="{url op="generateCSV"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>

<div id="authors">
<h4>{translate key="article.authors"}</h4>
	
<table width="100%" class="data">
	{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top">
		<td width="20%" class="label">{translate key="user.name"}</td>
		<td width="80%" class="value">
			{assign var=emailString value=$author->getFullName()|concat:" <":$author->getEmail():">"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$abstract->getScientificTitle()|strip_tags articleId=$submission->getId()}
			{$author->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	{if $author->getAffiliation()}
	<tr valign="top">
		<td class="label">{translate key="user.affiliation"}</td>
		<td class="value">{$author->getAffiliation()|escape|nl2br|default:"&mdash;"}</td>
	</tr>
	{/if}
	{/foreach}
</table>
</div>

<div id="titleAndAbstract">
<h4>Details</h4>

<table width="100%" class="data">
	<tr>
		<td width="20%" class="label">{translate key="article.scientificTitle"}</td>
		<td width="80%">{$abstract->getScientificTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td width="20%" class="label">{translate key="article.publicTitle"}</td>
		<td width="80%">{$abstract->getPublicTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td width="20%" class="label">Status</td>
		<td width="80%">{if $submission->getStatus() == 11}Completed{else}Ongoing{/if}</td>
	</tr>
{if $submission->getStatus() == 11}
	<tr valign="top">
		<td class="label">&nbsp;</td>
		<td class="value">
			Completion Report:&nbsp;&nbsp;&nbsp;&nbsp;
			{foreach name="suppFiles" from=$suppFiles item=suppFile}
			{if $suppFile->getType() == "Completion Report"}<br/>
				<a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId():$suppFile->getSuppFileId()}" class="file">{$suppFile->getFileName()|escape}</a>
			{/if}
			{foreachelse}
			Not available.
			{/foreach}
		</td>
	</tr>
{/if}
	<tr>
		<td width="20%" class="label">{translate key="common.dateSubmitted"}</td>
		<td width="80%">{$submission->getDateSubmitted()|date_format:$dateFormatShort}</td>
	</tr>
	<tr>
		<td width="20%" class="label">Submission ID</td>
		<td width="80%">{$submission->getLocalizedProposalId()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Keywords</td>
		<td class="value">{$abstract->getKeywords()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Start Date</td>
		<td class="value">{$submission->getLocalizedStartDate()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">End Date</td>
		<td class="value">{$submission->getLocalizedEndDate()|strip_unsafe_html}</td>
	</tr>
	
	{if $submission->getLocalizedMultiCountryResearch() == "Yes"}
	<tr>
		<td class="label">Area</td>
		<td class="value">{$submission->getLocalizedMultiCountryText()}</td>
	</tr>
	{elseif $submission->getLocalizedNationwide() == "Yes"}
	<tr>
		<td class="label">Area</td>
		<td class="value">Nationwide</td> 
	</tr>
	{else}
	<tr>
		<td class="label">Area</td>
		<td class="value">{$submission->getLocalizedProposalCountryText()}</td>
	</tr>
	{/if}
    <tr valign="top">
        <td class="label">{translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{$submission->getLocalizedWithHumanSubjects()}</td>
    </tr>
    {if ($submission->getLocalizedWithHumanSubjects()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalTypeText()}</td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label">{translate key="proposal.researchField"}</td>
        <td class="value">{$submission->getLocalizedResearchFieldText()}</td>
    </tr>
    
    <tr valign="top">
        <td class="label">{translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr><td colspan="2"><br/><b>{translate key="article.abstract"}</b></td></tr>
	<tr valign="top">
		<td class="label">{translate key="proposal.background"}</td>
		<td class="value">{$abstract->getBackground()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="proposal.objectives"}</td>
		<td class="value">{$abstract->getObjectives()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="proposal.studyMethods"}</td>
		<td class="value">{$abstract->getStudyMethods()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="proposal.expectedOutcomes"}</td>
		<td class="value">{$abstract->getExpectedOutcomes()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
</table>
</div>

{include file="common/footer.tpl"}

