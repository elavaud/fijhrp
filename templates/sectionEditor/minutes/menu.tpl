{strip}
{assign var="pageTitle" value="editor.minutes.minutes"}
{assign var="pageCrumbTitle" value="editor.minutes.minutes"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li><a href="{url op="setMeeting"}">{translate key="editor.meetings.setMeeting"}</a></li>
</ul>
<div class="separator"></div>
{include file="common/formErrors.tpl"}