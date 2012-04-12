{**
* meetingAttendance.tpl
* Added by igmallare 10/9/2011
*
* Generate report - meeting attendance 
**}

{strip}
{assign var="pageTitle" value="editor.reports.reportGenerator"}
{assign var="pageCrumbTitle" value="editor.reports.meetingAttendance"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="submissionsReport"}">{translate key="editor.reports.submissions"}</a></li>
	<li class="current"><a href="{url op="meetingAttendanceReport"}">{translate key="editor.reports.meetingAttendance"}</a></li>
</ul>
<div class="separator"></div>

<h3>{translate key="editor.reports.meetingAttendance"}</h3>
{include file="common/formErrors.tpl"}

<div id="meetingAttendance">
<form method="post" action="{url op="meetingAttendanceReport"}">
	<p>{fieldLabel name="ercMembers" required="true" key="editor.reports.selectAtLeastOneErcMember"}</p>
	<table class="listing" width="100%">
		<tr><td colspan="2" class="headseparator">&nbsp;</td></tr>
		<tr class="heading" valign="bottom">
			<td width="5%">Select</input></td>
			<td width="95%">ERC Member</td>
		</tr>
		<tr><td colspan="2" class="headseparator">&nbsp;</td></tr>
		<p></p>
	{foreach from=$members item=member}
		<tr valign="top">
				<td>{html_checkboxes id="ercMembers" name='ercMembers' values=$member->getId() checked=$ercMembers} </td>
				<td>{$member->getFullName()}</td>
		</tr>
		<tr>
			<td colspan="2" class="separator">&nbsp;</td>
		</tr>
	{/foreach}
	<tr>
		<td colspan="2" class="endseparator">&nbsp;</td>
	</tr>
	</table>


	{if !$dateFrom}
	{assign var="dateFrom" value="--"}
	{/if}
	
	{if !$dateTo}
	{assign var="dateTo" value="--"}
	{/if}

	<p>{translate key="editor.reports.dateRange"}</p>
	{translate key="common.between"}
	{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	{translate key="common.and"}
	{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	<input type="hidden" name="dateToHour" value="23" />
	<input type="hidden" name="dateToMinute" value="59" />
	<input type="hidden" name="dateToSecond" value="59" />
	<input type="hidden" id="isValid" name="isValid" value="{$isValid}" />
	<br/><br/>
	<input type="submit" name="generateMeetingAttendance" value="{translate key="editor.reports.generateReport"}" class="button defaultButton" />
	<input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" />
</form>
</div>
<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
{include file="common/footer.tpl"}
