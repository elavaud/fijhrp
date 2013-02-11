{**
 * submissions.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Editor submissions page(s).
 *
 * $Id$
 *}
{strip}
{strip}
{assign var="pageTitle" value="common.queue.long.$pageToDisplay"}
{url|assign:"currentUrl" page="editor"}
{include file="common/header.tpl"}
{/strip}
{/strip}


{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}

<ul class="menu">
<!--
	<li{if $pageToDisplay == "submissionsUnassigned"} class="current"{/if}><a href="{url op="submissions" path="submissionsUnassigned"}">{translate key="common.queue.short.submissionsUnassigned"}</a></li>
-->
	<li{if $pageToDisplay == "submissionsInReview"} class="current"{/if}><a href="{url op="submissions" path="submissionsInReview"}">{translate key="common.queue.short.submissionsInReview"}</a></li>
<!--	
	<li{if ($pageToDisplay == "minutes")} class="current"{/if}><a href="{url op="minutes"}">Upload Minutes</a></li>
-->
<!-- 
	<li{if $pageToDisplay == "submissionsInEditing"} class="current"{/if}><a href="{url op="submissions" path="submissionsInEditing"}">{translate key="common.queue.short.submissionsInEditing"}</a></li>
-->
	<li{if $pageToDisplay == "submissionsArchives"} class="current"{/if}><a href="{url op="submissions" path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
</ul>

&nbsp;
<form method="post" name="submit" action="{url op="submissions" path=$pageToDisplay}">
	<h3>Search options</h3>
	{if $section}<input type="hidden" name="section" value="{$section|escape:"quotes"}"/>{/if}
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
	<select type="hidden" name="dateSearchField" size="1" class="selectMenu">
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
	<strong>Filter by</strong>
	<select name="researchFieldField" id="researchField" class="selectMenu">
		<option value="">All Research Fields</option>
        {foreach from=$researchFields key=if item=rfield}
        	{if $rfield.code != "NA"}
            	<option value="{$rfield.code}" {if $researchFieldField == $rfield.code} selected="selected"{/if}>{$rfield.name}</option>
            {/if}
        {/foreach}
    </select>
	<select name="countryField" id="country" class="selectMenu">
		<option value="">All Regions</option>
		<option value="NW" {if $countryField == 'NW'} selected="selected"{/if}>Nationwide</option>
		{html_options options=$countries selected=$countryField}
    </select>
    <br/>
	<input type="submit" value="{translate key="common.search"}" class="button" />
</form>
<br/>

{include file="editor/$pageToDisplay.tpl"}

<!-- 
{if ($pageToDisplay == "submissionsInReview")}

<div id="notes">
<h4>{translate key="common.notes"}</h4>
{translate key="editor.submissionReview.notes"}
</div>
{/if}
<br />
 -->
{include file="common/footer.tpl"}

