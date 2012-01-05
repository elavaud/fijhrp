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
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
{literal}<script type="text/javascript">
$(document).ready(function() {
		$("#selectAllCountries").click(function() {
		     $("#countriesTbl input:checkbox").attr('checked',this.checked);
		});

		$("#selectAllTechnicalUnits").click(function() {
		     $("#technicalUnitsTbl input:checkbox").attr('checked',this.checked);
		});
});
</script>
<style type="text/css">
	.checkboxes tr {
		height : 30px;
		width : 700px;
	 }
	 .checkboxes input{
	 	margin-top: 0px;
		width: 15px;
    	height: 15px;
    	float: left;
	 }
	 .checkboxes label{
	 	float: left;
	 	padding-left: 15px;
	 	margin-top: 10px;
	 	font-size: 11px;
	 } 
</style>
{/literal}
<ul class="menu">
	<li><a href="{url op="submissionsReport"}">{translate key="editor.reports.submissions"}</a></li>
	<li class="current"><a href="{url op="meetingAttendanceReport"}">{translate key="editor.reports.meetingAttendance"}</a></li>
</ul>
<div class="separator"></div>

<h2>{translate key="editor.reports.submissions"}</h2>
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
			<h5>{translate key="editor.reports.decision"}</h5>
			<select name="decisions[]" id="decisions" multiple="multiple" size="5" class="selectMenu">
		 	 	<!--<option value='' selected="selected" >All Decisions</option> -->
		 		{html_options_translate options=$decisionsOptions selected=$decisions}
		    </select>	
		    
		    <h5>{translate key="editor.reports.country"}</h5>
<<<<<<< HEAD
		    <input type="checkbox" id="selectAllCountries">&nbsp;&nbsp;<b>{translate key="editor.reports.allCountries"}</b>
			{assign var="numCols" value="3"}
			{assign var="col" value="0"}
			<table id="countriesTbl" class="checkboxes">
			{foreach from=$countriesOptions item=country key=key}
			{if $col == $numCols}
			</tr><tr>{assign var="col" value="0"}
			{/if}
			<td><label><input type="checkbox" name="countries[]" class="countries"  value="{$key}">{$country}</label>
			</td>  {assign var="col" value=$col+1}
			{/foreach}
			</table>

		    <h5>{translate key="editor.reports.technicalUnit"} </h5>
		    <input type="checkbox" id="selectAllTechnicalUnits">&nbsp;&nbsp;<b>{translate key="editor.reports.allTechnicalUnits"}</b>
		    {assign var="numCols" value="2"}
			{assign var="col" value="0"}
			<table id="technicalUnitsTbl" class="checkboxes">
			{foreach from=$technicalUnitsOptions item=technicalUnit key=key}
			{if $col == $numCols}
			</tr><tr>{assign var="col" value="0"}
			{/if}
			<td><label><input type="checkbox" name="technicalUnits[]" class="technicalUnits" value="{$key}">{$technicalUnit}</label>
			</td>  {assign var="col" value=$col+1}
			{/foreach}
			</table>
=======
			<select name="countries[]" id="countries" multiple="multiple" size="5" class="selectMenu">
		 		<option value="0" selected="selected">{translate key="editor.reports.allCountries"}</option>
		 		{html_options options=$countriesOptions selected=$countries}
		    </select>
		    	
		    <h5>{translate key="editor.reports.technicalUnit"} </h5>
		    <select name="technicalUnits[]" id="technicalUnits" multiple="multiple" size="5" class="selectMenu">
		 		<option value="0" selected="selected">{translate key="editor.reports.allTechnicalUnits"}</option>
		 		{html_options options=$technicalUnitsOptions selected=$technicalUnits}
		    </select>
>>>>>>> dac19a7b7d6ad9cd11997929cefd0f4c3e82b1c1

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
