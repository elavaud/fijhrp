{**
 * index.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Journal author index.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="common.queue.long.$pageToDisplay"}
{include file="common/header.tpl"}
{/strip}


{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}

<ul class="menu">
	<li{if ($pageToDisplay == "proposalsToSubmit")} class="current"{/if}><a href="{url op="index" path="proposalsToSubmit"}">{translate key="common.queue.short.proposalsToSubmit"}</a></li>
	<li{if ($pageToDisplay == "proposalsInReview")} class="current"{/if}><a href="{url op="index" path="proposalsInReview"}">{translate key="common.queue.short.proposalsInReview"}</a></li>
	<li{if ($pageToDisplay == "ongoingResearches")} class="current"{/if}><a href="{url op="index" path="ongoingResearches"}">{translate key="common.queue.short.ongoingResearches"}</a></li>
	<li{if ($pageToDisplay == "completedResearches")} class="current"{/if}><a href="{url op="index" path="completedResearches"}">{translate key="common.queue.short.completedResearches"}</a></li>
	<li{if ($pageToDisplay == "submissionsArchives")} class="current"{/if}><a href="{url op="index" path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
</ul>

<br />
<form method="post" name="submit" action="{url op="index" path=$pageToDisplay}">
	<input type="hidden" name="sort" value="id"/>
	<input type="hidden" name="sortDirection" value="ASC"/>
	<select name="searchField" size="1" class="selectMenu" style="display: none;">
		{html_options_translate options=$fieldOptions selected=$searchField}
	</select>
	<strong>Title &nbsp;</strong> 
	<select name="searchMatch" size="1" class="selectMenu">
		<option value="contains"{if $searchMatch == 'contains'} selected="selected"{/if}>{translate key="form.contains"}</option>
		<option value="is"{if $searchMatch == 'is'} selected="selected"{/if}>{translate key="form.is"}</option>
		<option value="startsWith"{if $searchMatch == 'startsWith'} selected="selected"{/if}>{translate key="form.startsWith"}</option>
	</select>
	<input type="text" size="15" name="search" class="textField" value="{$search|escape}" />
	<br/>
	{* Changed by EL on April 27, 2012: Don't need to display this field *}
	<select name="dateSearchField" size="1" class="selectMenu" style="display: none;">
		{html_options_translate options=$dateFieldOptions selected=$dateSearchField}
	</select>
	<strong>Submitted between :&nbsp;</strong>
	{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	{translate key="common.and"}
	{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	<input type="hidden" name="dateToHour" value="23" />
	<input type="hidden" name="dateToMinute" value="59" />
	<input type="hidden" name="dateToSecond" value="59" />
	<br/>
    <br/>
	<input type="submit" value="{translate key="common.search"}" class="button" />
</form>

<br />
<div id="submitStart">
<h4>{translate key="author.submit.startHereTitle"}</h4>
{url|assign:"submitUrl" op="submit"}
{translate submitUrl=$submitUrl key="author.submit.startHereLink"}<br />
</div>

<br /><br />

{include file="author/$pageToDisplay.tpl"}

<!-- Comment out, AIM, May 31, 2011 -->
{*
{call_hook name="Templates::Author::Index::AdditionalItems"}
*}
{include file="common/footer.tpl"}

