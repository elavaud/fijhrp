{**
 * sectionForm.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form to create/modify a journal section.
 *
 * Last update: EL on February 28th 2013
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="section.section"}
{assign var="pageCrumbTitle" value="section.section"}
{include file="common/header.tpl"}
{/strip}

<form name="section" method="post" action="{url op="updateSection" path=$sectionId}">
<input type="hidden" name="editorAction" value="" />
<input type="hidden" name="userId" value="" />


{include file="common/formErrors.tpl"}
<div id="sectionForm">
<table class="data" width="100%">
{if count($formLocales) > 1}
	<tr valign="top">
		<td width="20%" class="label">{fieldLabel name="formLocale" key="form.formLanguage"}</td>
		<td width="80%" class="value">
			{if $sectionId}{url|assign:"sectionFormUrl" op="editSection" path=$sectionId escape=false}
			{else}{url|assign:"sectionFormUrl" op="createSection" path=$sectionId escape=false}
			{/if}
			{form_language_chooser form="section" url=$sectionFormUrl}
			<span class="instruct">{translate key="form.formLanguage.description"}</span>
		</td>
	</tr>
{/if}
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="title" required="true" key="section.title"}</td>
	<td width="80%" class="value"><input type="text" name="title[{$formLocale|escape}]" value="{$title[$formLocale]|escape}" id="title" size="40" maxlength="120" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label">{fieldLabel name="abbrev" required="true" key="section.abbreviation"}</td>
	<td class="value"><input type="text" name="abbrev[{$formLocale|escape}]" id="abbrev" value="{$abbrev[$formLocale]|escape}" size="20" maxlength="20" class="textField" />&nbsp;&nbsp;{translate key="section.abbreviation.example"}</td>
</tr>
<!-- Requesting the region -->
<!-- EL on February 11th 2013 -->
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="region" required="true" key="section.region"}</td>
    <td width="80%" class="value">
		<select name="region[{$formLocale|escape}]" id="region" class="selectMenu">
        	<option value=""></option>
				{html_options options=$regions selected=$region[$formLocale]}
        </select>
    </td>
</tr>
</table>
</div>

<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="sections" escape=false}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
{include file="common/footer.tpl"}

