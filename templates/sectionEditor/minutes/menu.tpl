{strip}
{assign var="pageTitle" value="editor.minutes"}
{assign var="pageCrumbTitle" value="editor.minutes"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a class="action" href="{url op="index"}">{translate key="article.articles"}</a></li>
	<li><a class="action" href="{url op="section" path=$ercId}">{translate key="section.sectionAbbrev"}</a></li>
	<li class="current"><a class="action" href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
</ul>
<ul class="menu">
	<li><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li><a href="{url op="setMeeting"}">{translate key="editor.meetings.setMeeting"}</a></li>
</ul>
<div class="separator"></div>
{include file="common/formErrors.tpl"}