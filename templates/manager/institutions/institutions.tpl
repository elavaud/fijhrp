{**
 * institutions.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Display list of institutions in journal management.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="institution.institutions"}
{include file="common/header.tpl"}
{/strip}

<br/>
<div id="institution">
<table width="100%" class="listing" id="dragTable">

	<tr>
		<td class="headseparator" colspan="4">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="40%">{sort_heading key="institution.institution" sort="institution"}</td>
		<td width="23%">{sort_heading key="institution.location" sort="region"}</td>
		<td width="17%">{translate key="institution.type"}</td>
		<td width="20%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr>
		<td class="headseparator" colspan="4">&nbsp;</td>
	</tr>
{iterate from=institutions item=institution name=institutions}
	{assign var="institutionType" value=$institution->getInstitutionType()}
	<tr valign="top" class="data">
		<td class="drag">{$institution->getInstitution()}</td>
		<td class="drag">{$institution->getRegionText()}</td>
		<td class="drag">
			{if $institutionType == INSTITUTION_TYPE_GOVERNMENT}
				{translate key="institution.government"}
			{elseif institutionType == INSTITUTION_TYPE_PRIVATE}
				{translate key="institution.private"}
			{else}
				&mdash;
			{/if}	
		</td>
		<td align="right" class="nowrap">
			<a href="{url op='editInstitution' path=$institution->getId()}" class="action">{translate key="common.edit"}</a>
			&nbsp;|&nbsp;
			<a href="{url op='deleteInstitution' path=$institution->getId()}" onclick="return confirm('Delete this institution?')" class="action">{translate key="common.delete"}</a>
			&nbsp;
		</td>
	</tr>

{/iterate}
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
{if $institutions->wasEmpty()}
	<tr>
		<td colspan="4" class="nodata">{translate key="manager.institution.noneCreated"}</td>
	</tr>
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td align="left">{page_info iterator=$institutions}</td>
		<td colspan="4" align="right">{page_links anchor="institutions" name="institutions" iterator=$institutions sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
<a class="action" href="{url op="createInstitution"}">{translate key="manager.institutions.create"}</a>
</div>

{include file="common/footer.tpl"}

