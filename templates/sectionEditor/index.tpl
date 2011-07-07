{**
 * index.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Section editor index.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="common.queue.long.$pageToDisplay"}
{url|assign:"currentUrl" page="sectionEditor"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li{if ($pageToDisplay == "submissionsInReview")} class="current"{/if}><a href="{url path="submissionsInReview"}">{translate key="common.queue.short.submissionsInReview"}</a></li>
	<li{if ($pageToDisplay == "minutes")} class="current"{/if}><a href="{url op="minutes"}">Upload Minutes</a></li>
	<!--{** 
	<li{if ($pageToDisplay == "submissionsInEditing")} class="current"{/if}><a href="{url path="submissionsInEditing"}">{translate key="common.queue.short.submissionsInEditing}</a></li>
	 **}-->
	<li{if ($pageToDisplay == "submissionsArchives")} class="current"{/if}><a href="{url path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
</ul>

{if $pageToDisplay == "minutes"}
	{include file="sectionEditor/minutes/$pageToDisplay.tpl"}	
{else}
	{include file="sectionEditor/$pageToDisplay.tpl"}
{/if}


{if ($pageToDisplay == "submissionsInReview")}
<br />
{**
	<div id="notes">
	<h4>{ translate key="common.notes" }</h4>
	{translate key="editor.submissionReview.notes"}
	</div>
*}
{/if}




{include file="common/footer.tpl"}

