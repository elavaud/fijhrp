{**
 * institutionForm.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form to create/modify an institution
 *
 *	Last updated by	JAA March 11, 2013
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="institution.institution"}
{assign var="pageCrumbTitle" value="institution.institution"}
{include file="common/header.tpl"}
{/strip}

<form name="institution" method="post" action="{url op="updateInstitution" path="$institutionId}">
<input type="hidden" name="editorAction" value="" />
<input type="hidden" name="userId" value="" />

{include file="common/formErrors.tpl"}
<div id="institutionForm">
<table class="data" width="100%">

<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="title" required="true" key="institution.institution"}</td>
	<td width="80%" class="value"><input type="text" name="title" value="{$institution}" id="title" size="40" maxlength="120" class="textField" /></td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="institution_type" required="true" key="institution.type"}</td>
    <td width="80%" class="value">
		<select name="institution_type" id="institution_type" class="selectMenu">
        	<option value=""></option>
				{html_options_translate options=$institutionTypes selected=$institutionType}
        </select>
    </td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{fieldLabel name="region" required="true" key="institution.location"}</td>
    <td width="80%" class="value">
		<select name="region" id="region" class="selectMenu">
        	<option value=""></option>
				{html_options options=$regions selected=$region}
        </select>
    </td>
</tr>
</table>
</div>

<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url op="institutions" escape=false}'" /></p>

</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
{include file="common/footer.tpl"}

