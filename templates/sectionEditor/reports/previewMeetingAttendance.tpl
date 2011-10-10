{**
* meetingAttendance.tpl
* Added by igmallare 10/9/2011
*
* Generate report - meeting attendance 
**}

{strip}
{assign var="pageTitle" value="editor.reports.previewReport"}
{assign var="translate key="editor.reports.previewReport"}
{include file="common/header.tpl"}
{/strip}


<div id="meetingAttendance">
<form method="post" action="{url op="generateReport"}">
	
</form>
</div>
{include file="common/footer.tpl"}
