{strip}
{assign var="pageTitle" value="common.queue.long.minutes"}
{url|assign:"currentUrl" page="sectionEditor"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li><a href="{url op="setMeeting"}">{translate key="editor.meetings.setMeeting"}</a></li>
	<li class="current"><a href="{url op="minutes"}">Upload Minutes</a></li>
</ul>
 <br/>