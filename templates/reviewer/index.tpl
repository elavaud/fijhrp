{**
 * index.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Reviewer index.
 * 
 * $Id$
 * Edited by ayveemallare 7/6/2011
 *}

{strip}
{assign var="pageTitle" value="reviewer.home"}
{assign var="pageCrumbTitle" value="user.role.reviewer"}
{include file="common/header.tpl"}
{/strip}
<div id="">
<ul class="plain">
	<li>&#187; <a href="{url op="submissions"}">{translate key="reviewer.submissions"}</a>&nbsp;({if $rangeInfo}{$rangeInfo}{else}0{/if})</li>
	{call_hook name="Templates::Reviewer::Index::Submissions"}
</ul>
<ul class="plain">
	<li>&#187; <a href="{url op="meetings"}">{translate key="reviewer.meetings"}</a>&nbsp;({if $meetingsCount}{$meetingsCount}{else}0{/if})</li>
	{call_hook name="Templates::Reviewer::Index::Meetings"}
</ul>
</div>

{include file="common/footer.tpl"}