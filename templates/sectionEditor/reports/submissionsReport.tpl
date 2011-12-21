{**
* submissionsReport.tpl
* Added by MSB 10/9/2011
*
* Generate report - meeting attendance 
**}

{strip}
{assign var="pageTitle" value="editor.reports.reportGenerator"}
{assign var="pageCrumbTitle" value="editor.reports.meetingAttendance"}
{include file="common/header.tpl"}
{/strip}


<ul class="menu">
	<li class="current"><a href="{url op="submissionsReport"}">{translate key="editor.reports.submissions"}</a></li>
	<li><a href="{url op="meetingAttendanceReport"}">{translate key="editor.reports.meetingAttendance"}</a></li>
</ul>
<div class="separator"></div>


<h3>{translate key="editor.reports.submissions"}</h3>
{include file="common/formErrors.tpl"}

<div id="submissionsReport">
<form method="post" action="{url op="submissionsReport"}">

	{if !$dateFrom}
	{assign var="dateFrom" value="--"}
	{/if}
	
	{if !$dateTo}
	{assign var="dateTo" value="--"}
	{/if}
	
    <br/>
    		<h5>FILTER BY </h5>
			<h5>{translate key="editor.reports.decision"}*</h5>
			<select name="decisions[]" id="decisions" multiple="multiple" size="5" class="selectMenu">
		 	 	<!--	<option value='' selected="selected" >All Decisions</option> -->
		 			{html_options_translate options=$decisionsOptions selected=$decisions}
		    </select>	
		    
		    <h5>{translate key="editor.reports.country"}*</h5>
			<select name="countries[]" id="countries" multiple="multiple" size="5" class="selectMenu">
			 	<!-- 	<option value=''  selected="selected" >All Countries</option> -->
		 			{html_options options=$countriesOptions selected=$countries}
		    </select>	
		    
			<h5>{translate key="editor.reports.technicalUnit"}*</h5>
		 	<select name="technicalUnits[]" id="technicalUnits" multiple="multiple" size="5" class="selectMenu">
		 	 	<!--	<option value=''  selected="selected" >All Technical Units</option> -->
		 			{html_options options=$technicalUnitsOptions selected=$technicalUnits}
		    </select>	
	
	<br/>
	<h5>DATE</h5>
	{translate key="common.between"}
	{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	{translate key="common.and"}
	{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	<input type="hidden" name="dateToHour" value="23" />
	<input type="hidden" name="dateToMinute" value="59" />
	<input type="hidden" name="dateToSecond" value="59" />
	<input type="hidden" id="isValid" name="isValid" value="{$isValid}" />
	
	<br/><br/>
	<input type="submit" name="generateSubmissionsReport" value="{translate key="editor.reports.generateReport"}" class="button defaultButton" />
	<input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" />

</form>
</div>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
{include file="common/footer.tpl"}
