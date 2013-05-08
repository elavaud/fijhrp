{**
* submissionsReport.tpl
*
* Generate report - meeting attendance 
**}

{strip}
{assign var="pageTitle" value="editor.reports.reportGenerator"}
{assign var="pageCrumbTitle" value="editor.reports.submissions"}
{include file="common/header.tpl"}

{/strip}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
{literal}<script type="text/javascript">
$(document).ready(function() {
        //Restrict end date to (start date) + 1
        $( "#startDateBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#startDateBefore").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#endDateBefore").datepicker("option","minDate", dayAfter)
                }
        	}
        );
            
        $( "#endDateBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy'
        	}
        );
        
        $( "#startDateAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#startDateAfter").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#endDateAfter").datepicker("option","minDate", dayAfter)
                }
            }
        );  

            
        $( "#endDateAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy'
        	}
        );
        
        $( "#submittedBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, maxDate: '0', dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#submittedBefore").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#approvedBefore").datepicker("option","minDate", dayAfter)
                }
            }
        );
        
        $( "#approvedBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', maxDate: '0', onSelect: function(){
        			showProposalDetails();
        			$('.decisionField').remove();
        			$('#decisions').val('editor.article.decision.approved');
        		}
        	}
        );
        
        $( "#submittedAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, maxDate: '-1 d', dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#submittedAfter").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#approvedAfter").datepicker("option","minDate", dayAfter)
                }
            }
        );

        $( "#approvedAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', maxDate: '-1 d', onSelect: function(){
        			showProposalDetails();
        			$('.decisionField').remove();
        			$('#decisions').val('editor.article.decision.approved');
        		}
        	}
        );
        
        $('#decisions').change(function(){
        	if ($('#decisions').val() != 'editor.article.decision.approved') {
        		if ($('#approvedAfter').val() != "" || $('#approvedBefore').val() != ""){
        			$('#approvedAfter').val("");
        			$('#approvedBefore').val("");
        		}
        	}
        });
        
        //Start code for multiple decisions
        $('#addAnotherDecision').click(
        	function(){
       			var decisionHtml = '<tr valign="top" class="decisionField">' + $('#firstDecision').html() + '</tr>';
            	$('#firstDecision').after(decisionHtml);
        		$('#firstDecision').next().find('select').attr('selectedIndex', 0);
        		$('.decisionField').find('.removeDecision').show();
        		$('.decisionField').find('.decisionTitle').hide();
        		$('.decisionField').find('.noDecisionTitle').show();
        		$('#firstDecision').find('.removeDecision').hide();
        		$('#firstDecision').find('.decisionTitle').show();
        		$('#firstDecision').find('.noDecisionTitle').hide();
        		if ($('#approvedAfter').val() != "" || $('#approvedBefore').val() != ""){
        			$('#approvedAfter').val("");
        			$('#approvedBefore').val("");
        		}
            	return false;
        	}
    	);

        $('.removeDecision').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple primary sponsor
        $('#addAnotherPrimarySponsor').click(
        	function(){
       			var primarySponsorHtml = '<tr valign="top" class="primarySponsorField">' + $('#firstPrimarySponsor').html() + '</tr>';
            	$('#firstPrimarySponsor').after(primarySponsorHtml);
        		$('#firstPrimarySponsor').next().find('select').attr('selectedIndex', 0);
        		$('.primarySponsorField').find('.removePrimarySponsor').show();
        		$('.primarySponsorField').find('.primarySponsorTitle').hide();
        		$('.primarySponsorField').find('.noPrimarySponsorTitle').show();
        		$('#firstPrimarySponsor').find('.removePrimarySponsor').hide();
        		$('#firstPrimarySponsor').find('.primarySponsorTitle').show();
        		$('#firstPrimarySponsor').find('.noPrimarySponsorTitle').hide();
            	return false;
        	}
    	);

        $('.removePrimarySponsor').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple primary sponsor
        $('#addAnotherSecondarySponsor').click(
        	function(){
       			var secondarySponsorHtml = '<tr valign="top" class="secondarySponsorField">' + $('#firstSecondarySponsor').html() + '</tr>';
            	$('#firstSecondarySponsor').after(secondarySponsorHtml);
        		$('#firstSecondarySponsor').next().find('select').attr('selectedIndex', 0);
        		$('.secondarySponsorField').find('.removeSecondarySponsor').show();
        		$('.secondarySponsorField').find('.secondarySponsorTitle').hide();
        		$('.secondarySponsorField').find('.noSecondarySponsorTitle').show();
        		$('#firstSecondarySponsor').find('.removeSecondarySponsor').hide();
        		$('#firstSecondarySponsor').find('.secondarySponsorTitle').show();
        		$('#firstSecondarySponsor').find('.noSecondarySponsorTitle').hide();
            	return false;
        	}
    	);

        $('.removeSecondarySponsor').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple research Field
        $('#addAnotherResearchField').click(
        	function(){
       			var researchFieldHtml = '<tr valign="top" class="researchFieldField">' + $('#firstResearchField').html() + '</tr>';
            	$('#firstResearchField').after(researchFieldHtml);
        		$('#firstResearchField').next().find('select').attr('selectedIndex', 0);
        		$('.researchFieldField').find('.removeResearchField').show();
        		$('.researchFieldField').find('.researchFieldTitle').hide();
        		$('.researchFieldField').find('.noResearchFieldTitle').show();
        		$('#firstResearchField').find('.removeResearchField').hide();
        		$('#firstResearchField').find('.researchFieldTitle').show();
        		$('#firstResearchField').find('.noResearchFieldTitle').hide();
            	return false;
        	}
    	);

        $('.removeResearchField').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
                
        //Start code for multiple proposal type
        $('#addAnotherProposalType').click(
        	function(){
       			var proposalTypeHtml = '<tr valign="top" class="proposalTypeField">' + $('#firstProposalType').html() + '</tr>';
            	$('#firstProposalType').after(proposalTypeHtml);
        		$('#firstProposalType').next().find('select').attr('selectedIndex', 0);
        		$('.proposalTypeField').find('.removeProposalType').show();
        		$('.proposalTypeField').find('.proposalTypeTitle').hide();
        		$('.proposalTypeField').find('.noProposalTypeTitle').show();
        		$('#firstProposalType').find('.removeProposalType').hide();
        		$('#firstProposalType').find('.proposalTypeTitle').show();
        		$('#firstProposalType').find('.noProposalTypeTitle').hide();
            	return false;
        	}
    	);

        $('.removeProposalType').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple regions
        $('#addAnotherRegion').click(
        	function(){
       			var regionHtml = '<tr valign="top" class="regionField">' + $('#firstRegion').html() + '</tr>';
            	$('#firstRegion').after(regionHtml);
        		$('#firstRegion').next().find('select').attr('selectedIndex', 0);
        		$('.regionField').find('.removeRegion').show();
        		$('.regionField').find('.regionTitle').hide();
        		$('.regionField').find('.noRegionTitle').show();
        		$('#firstRegion').find('.removeRegion').hide();
        		$('#firstRegion').find('.regionTitle').show();
        		$('#firstRegion').find('.noRegionTitle').hide();
            	return false;
        	}
    	);

        $('.removeRegion').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
});

function hideProposalDetails(){
	$('.decisionField').remove();
	$('.primarySponsorField').remove();
	$('.secondarySponsorField').remove();
	$('.researchFieldField').remove();
	$('.proposalTypeField').remove();
	
	$('#proposalDetails').hide();
	$('#academicDegreeField').hide();
	$('#showProposalDetails').show();
	
	$('#ercnioph').removeAttr('checked');
	$('#ercuhs').removeAttr('checked');
	$('#studentResearchy').removeAttr('checked');
	$('#studentResearchn').removeAttr('checked');
	
	$('#decisions').val("");
	$('#academicDegree').val("");
	$('#primarySponsors').val("");
	$('#secondarySponsors').val("");
	$('#researchFields').val("");
	$('#proposalTypes').val("");
	$('#dataCollection').val("");
	
	if ($('#approvedAfter').val() != "" || $('#approvedBefore').val() != ""){
    	$('#approvedAfter').val("");
        $('#approvedBefore').val("");
    }
}

function showProposalDetails(){
	$('#proposalDetails').show();
	$('#showProposalDetails').hide();	
}

function hideGeographicalAreas(){
	document.getElementById('nationwideField').style.display = 'none';
	document.getElementById('firstRegion').style.display = 'none';
	document.getElementById('addAnotherRegion').style.display = 'none';
	$('#geographicalAreas').hide();
	$('.regionField').remove();
	$('#showGeographicalAreas').show();
	$('#multicountryy').removeAttr('checked');
	$('#multicountryn').removeAttr('checked');
	$('#nationwidey').removeAttr('checked');
	$('#nationwiden').removeAttr('checked');
	$('#regions').val("");
}

function showGeographicalAreas(){
	$('#geographicalAreas').show();
	$('#showGeographicalAreas').hide();	
}

function hideDates(){

	$('#dates').hide();
	$('#showDates').show();
	
	$('#researchDates').hide();
	$('#reviewDates').hide();

	$('#showResearchDates').show();
	$('#hideResearchDates').hide();

	$('#showReviewDates').show();
	$('#hideReviewDates').hide();
	
	$('#startDateBefore').val("");
	$('#startDateAfter').val("");
	$('#endDateBefore').val("");
	$('#endDateAfter').val("");
	
	$('#submittedBefore').val("");
	$('#submittedAfter').val("");
	$('#approvedBefore').val("");
	$('#approvedAfter').val("");
}

function showDates(){
	$('#dates').show();
	$('#showDates').hide();	
}

function showResearchDates(){
	$('#showResearchDates').hide();
	$('#researchDates').show();
	$('#hideResearchDates').show();	
}

function hideResearchDates(){
	$('#showResearchDates').show();
	$('#researchDates').hide();
	$('#hideResearchDates').hide();
	$('#startDateBefore').val("");
	$('#startDateAfter').val("");
	$('#endDateBefore').val("");
	$('#endDateAfter').val("");
}

function showReviewDates(){
	$('#showReviewDates').hide();
	$('#reviewDates').show();
	$('#hideReviewDates').show();	
}

function hideReviewDates(){
	$('#showReviewDates').show();
	$('#reviewDates').hide();
	$('#hideReviewDates').hide();
	$('#submittedBefore').val("");
	$('#submittedAfter').val("");
	$('#approvedBefore').val("");
	$('#approvedAfter').val("");
}

function showOrHideNationwide(value){
	if (value == 'No'){
		document.getElementById('nationwideField').style.display = '';
	} else {
		document.getElementById('nationwideField').style.display = 'none';
		document.getElementById('firstRegion').style.display = 'none';
		document.getElementById('addAnotherRegion').style.display = 'none';
		$('#nationwidey').removeAttr('checked');
		$('#nationwiden').removeAttr('checked');
		$('.regionField').remove();		
		$('#regions').val("");
	}
}

function showOrHideRegion(value){
	if (value == 'No'){
		document.getElementById('firstRegion').style.display = '';
		document.getElementById('addAnotherRegion').style.display = '';
	} else {
		document.getElementById('firstRegion').style.display = 'none';
		document.getElementById('addAnotherRegion').style.display = 'none';
		$('.regionField').remove();
		$('#regions').val("");
	}
}

function showOrHideAcademicDegreeField(value){
	if (value == 'Yes') {
		document.getElementById('academicDegreeField').style.display = '';	
	} else {
		document.getElementById('academicDegreeField').style.display = 'none';
		$('#academicDegree').val("");
	}
}

function submissionCheckAll(){
	$('.checkSubmission').attr('checked','checked');
}

function submissionUncheckAll(){
	$('.checkSubmission').removeAttr('checked');
}

function investigatorCheckAll(){
	$('.checkInvestigator').attr('checked','checked');
}

function investigatorUncheckAll(){
	$('.checkInvestigator').removeAttr('checked');
}

function detailsCheckAll(){
	$('.checkDetails').attr('checked','checked');
}

function detailsUncheckAll(){
	$('.checkDetails').removeAttr('checked');
}

function monetaryCheckAll(){
	$('.checkMonetary').attr('checked','checked');
}

function monetaryUncheckAll(){
	$('.checkMonetary').removeAttr('checked');
}
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
<!--
<ul class="menu">
	<li><a href="{url op="submissionsReport"}">{translate key="editor.reports.submissions"}</a></li>
	<li class="current"><a href="{url op="meetingAttendanceReport"}">{translate key="editor.reports.meetingAttendance"}</a></li>
</ul>
<div class="separator"></div>
<h2>{translate key="editor.reports.submissions"}</h2>
-->
{include file="common/formErrors.tpl"}

<div id="submissionsReport">
<form method="post" action="{url op="submissionsReport"}">

	{if !$dateFrom}
	{assign var="dateFrom" value="--"}
	{/if}
	
	{if !$dateTo}
	{assign var="dateTo" value="--"}
	{/if}

<h5>METADATA TO EXPORT</h5>
<table width="100%" class="data">
	<tr valign="top">
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
	</tr>
	<tr>
		<td colspan="4"><strong><br/>Submission</strong></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="submissionCheckAll()" id="submissionCheckAll">Check All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="submissionUncheckAll()" id="submissionUncheckAll">Uncheck All</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkProposalId" class="checkSubmission" checked="checked"/>&nbsp;Proposal ID</td>
		<td><input type="checkbox" name="checkErc" class="checkSubmission"/>&nbsp;Ethics Review Committee</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkDecision" class="checkSubmission" checked="checked"/>&nbsp;Decision</td>
		<td><input type="checkbox" name="checkDateSubmitted" class="checkSubmission"/>&nbsp;Date Submitted</td>
		<td><input type="checkbox" name="checkDateApproved" class="checkSubmission"/>&nbsp;Date Approved</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4"><strong><br/>Primary Investigator</strong></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="investigatorCheckAll()" id="investigatorCheckAll">Check All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="investigatorUncheckAll()" id="investigatorUncheckAll">Uncheck All</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkName" class="checkInvestigator" checked="checked"/>&nbsp;Name</td>
		<td><input type="checkbox" name="checkAffiliation" class="checkInvestigator" checked="checked"/>&nbsp;Affiliation</td>
		<td><input type="checkbox" name="checkEmail" class="checkInvestigator"/>&nbsp;E-Mail</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4"><strong><br/>Proposal Details</strong></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="detailsCheckAll()" id="detailsCheckAll">Check All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="detailsUncheckAll()" id="detailsUncheckAll">Uncheck All</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkScientificTitle" class="checkDetails" checked="checked"/>&nbsp;Scientific Title</td>
		<td><input type="checkbox" name="checkPublicTitle" class="checkDetails"/>&nbsp;Public Title</td>
		<td><input type="checkbox" name="checkStudentResearch" class="checkDetails"/>&nbsp;Student Research</td>
		<td><input type="checkbox" name="checkPrimarySponsor" class="checkDetails" checked="checked"/>&nbsp;Primary Sponsor</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkSecondarSponsor" class="checkDetails" checked="checked"/>&nbsp;Secondary Sponsor(s)</td>
		<td><input type="checkbox" name="checkResearchFields" class="checkDetails" checked="checked"/>&nbsp;Research Field(s)</td>
		<td><input type="checkbox" name="checkProposalTypes" class="checkDetails" checked="checked"/>&nbsp;Proposal Type(s)</td>
		<td><input type="checkbox" name="checkDuration" class="checkDetails" checked="checked"/>&nbsp;Dates of Research</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkArea" class="checkDetails" checked="checked"/>&nbsp;Geographical Area(s)</td>
		<td><input type="checkbox" name="checkDataCollection" class="checkDetails" checked="checked"/>&nbsp;Data Collection</td>
		<td><input type="checkbox" name="checkBudget" class="checkDetails" checked="checked"/>&nbsp;Estimated Budget</td>
		<td><input type="checkbox" name="checkErcReview" class="checkDetails" checked="checked"/>&nbsp;Other ERC Review</td>
	</tr>
	
	</td>
	<tr>
		<td colspan="4"><strong><br/>Source(s) of Monetary or Material Support</strong></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="monetaryCheckAll()" id="monetaryCheckAll">Check All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="monetaryUncheckAll()" id="monetaryUncheckAll">Uncheck All</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkIndustryGrant" class="checkMonetary"/>&nbsp;Industry Grant</td>
		<td><input type="checkbox" name="checkAgencyGrant" class="checkMonetary"/>&nbsp;Agency Grant</td>
		<td><input type="checkbox" name="checkMohGrant" class="checkMonetary"/>&nbsp;MoH Grant</td>
		<td><input type="checkbox" name="checkGovernmentGrant" class="checkMonetary"/>&nbsp;Government Grant</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkUniversityGrant" class="checkMonetary"/>&nbsp;University Research Grant</td>
		<td><input type="checkbox" name="checkSelfFunding" class="checkMonetary"/>&nbsp;Self Funding</td>
		<td><input type="checkbox" name="checkOtherGrant" class="checkMonetary"/>&nbsp;Other Grant(s)</td>
		<td>&nbsp;</td>
	</tr>
</table>
<br/>
<h5>FILTER BY </h5>
<a name="proposal"></a>
<table width="100%" class="data" id="proposalDetails" style="display:none">
	<tr valign="top">
		<td width="5%"></td>
		<td width="3%"></td>
		<td width="17%"></td>
		<td width="5%"></td>
		<td width="70%"></td>
	</tr>

	<tr><td colspan="5"><h4><a href="#proposal" onclick="hideProposalDetails()" class="action" id="hideProposalDetails">Proposal Details</a></h4></td></tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td colspan="2"><br/>Ethics Committee</td>
		<td colspan="2"><br/>
        	<input type="radio" name="erc" id="ercnioph" value="1"/> National Ethical Committee for Health Research
            <br/>
        	<input type="radio" name="erc" id="ercuhs" value="2"/> Ethical Committee of the University of Health Sciences
        </td>
	</tr>
	
	<tr valign="top" id="firstDecision" class="decision">
		<td>&nbsp;</td>
		<td colspan="2" class="decisionTitle">Decision(s)</td>
		<td colspan="2" class="noDecisionTitle" style="display: none;" align="right">OR &nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
			<select name="decisions[]" id="decisions" class="selectMenu">
				<option value=""></option>
		 		{html_options_translate options=$decisionsOptions selected=$decisions}
			</select>
			<a href="" class="removeDecision" style="display:none">Remove</a>
		</td>
	</tr>
	
    <tr id="addAnotherDecision">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherDecision">Add another decision</a></td>
    </tr>	

	<tr valign="top">
		<td>&nbsp;</td>
		<td colspan="2">Student Research</td>
		<td colspan="2">
        	<input type="radio" name="studentResearch" id="studentResearchy" value="Yes" onclick="showOrHideAcademicDegreeField(this.value)"/>Yes
            &nbsp;&nbsp;&nbsp;&nbsp;
        	<input type="radio" name="studentResearch" id="studentResearchn" value="No" onclick="showOrHideAcademicDegreeField(this.value)"/>No
        </td>
	</tr>
	<tr valign="top" id="academicDegreeField" style="display: none;">
		<td colspan="2">&nbsp;</td>
		<td>Academic Degree</td>
		<td colspan="2">
			<select name="academicDegree" id="academicDegree" class="selectMenu">
				<option value=""></option>
				<option value="Undergraduate">Undergraduate</option>
				<option value="Master">Master</option>
				<option value="Post-Doc">Post-Doc</option>
				<option value="Ph.D">Ph.D</option>
				<option value="Other">Other</option>
			</select>
        </td>
	</tr>
	<tr valign="top" id="firstPrimarySponsor" class="primarySponsor">
		<td>&nbsp;</td>
		<td colspan="2" class="primarySponsorTitle">Primary Sponsor(s)</td>
		<td colspan="2" class="noPrimarySponsorTitle" style="display: none;" align="right">OR &nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="primarySponsors[]" id="primarySponsors" class="selectMenu">
                <option value=""></option>
                {foreach from=$agencies key=id item=sponsor}
                	{if $sponsor.code != "NA"}
                        <option value="{$sponsor.code}">{$sponsor.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removePrimarySponsor" style="display:none">Remove</a>
		</td>
	</tr>
    <tr id="addAnotherPrimarySponsor">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherPrimarySponsor">Add another primary sponsor</a></td>
    </tr>
    
	<tr valign="top" id="firstSecondarySponsor" class="secondarySponsor">
		<td>&nbsp;</td>
		<td colspan="2" class="secondarySponsorTitle">Secondary Sponsor(s)</td>
		<td colspan="2" class="noSecondarySponsorTitle" style="display: none;" align="right">OR &nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="secondarySponsors[]" id="secondarySponsors" class="selectMenu">
                <option value=""></option>
                {foreach from=$agencies key=id item=sponsor}
                	{if $sponsor.code != "NA"}
                        <option value="{$sponsor.code}">{$sponsor.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removeSecondarySponsor" style="display:none">Remove</a>
		</td>
	</tr>
	<tr id="addAnotherSecondarySponsor">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherSecondarySponsor">Add another secondary sponsor</a></td>
    </tr>
    
	<tr valign="top" id="firstResearchField" class="researchField">
		<td>&nbsp;</td>
		<td colspan="2" class="researchFieldTitle">Research Field(s)</td>
		<td colspan="2" class="noResearchFieldTitle" style="display: none;" align="right">OR &nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="researchFields[]" id="researchFields" class="selectMenu">
                <option value=""></option>
                {foreach from=$researchFields key=id item=rfield}
                	{if $rfield.code != "NA"}
                        <option value="{$rfield.code}">{$rfield.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removeResearchField" style="display:none">Remove</a>
		</td>
	</tr>
    <tr id="addAnotherResearchField">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherResearchField">Add another research field</a></td>
    </tr>
    
	<tr valign="top" id="firstProposalType" class="proposalType">
		<td>&nbsp;</td>
		<td colspan="2" class="proposalTypeTitle">Propososal Type(s)</td>
		<td colspan="2" class="noProposalTypeTitle" style="display: none;" align="right">OR &nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="proposalTypes[]" id="proposalTypes" class="selectMenu">
                <option value=""></option>
                <option value="PNHS">Proposal wihtout Human Subjects</option>
                {foreach from=$proposalTypes key=id item=ptype}
                	{if $ptype.code != "NA"}
                        <option value="{$ptype.code}">{$ptype.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removeProposalType" style="display:none">Remove</a>
		</td>
	</tr>
    <tr id="addAnotherProposalType">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherProposalType">Add another proposal type</a></td>
    </tr>
    
	<tr valign="top">
		<td>&nbsp;</td>
		<td colspan="2">Data Collection</td>
		<td colspan="2">
			<select name="dataCollection" id="dataCollection" class="selectMenu">
            	<option value=""></option>
            	<option value="Primary">Primary</option>
            	<option value="Secondary">Secondary</option>
            	<option value="Both">Both</option>
			</select>
		</td>
	</tr>
</table>
<h4><a href="#proposal" onclick="showProposalDetails()" class="action" id="showProposalDetails">Proposal Details</a></h4>

<a name="areas"></a>
<table width="100%" class="data" id="geographicalAreas"  style="display:none">
	<tr><td colspan="6"><h4><a href="#areas" onclick="hideGeographicalAreas()" class="action" id="hideGeographicalAreas">{translate key="editor.reports.country"}</a></h4></td></tr>
	<tr valign="top">
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="75%"></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td colspan="4"><br/>Multi-Country</td>
		<td colspan="2"><br/>
        	<input type="radio" name="multicountry" id="multicountryy" value="Yes" onclick="showOrHideNationwide(this.value)"/>Yes
            &nbsp;&nbsp;&nbsp;&nbsp;
        	<input type="radio" name="multicountry" id="multicountryn" value="No" onclick="showOrHideNationwide(this.value)"/>No
        </td>
	</tr>
	<tr valign="top" id="nationwideField" style="display: none;">
		<td>&nbsp;</td>
		<td colspan="4">Nationwide</td>
		<td colspan="2">
        	<input type="radio" name="nationwide" id="nationwidey" value="Yes" onclick="showOrHideRegion(this.value)"/>Yes
            &nbsp;&nbsp;&nbsp;&nbsp;
        	<input type="radio" name="nationwide" id="nationwiden" value="No" onclick="showOrHideRegion(this.value)"/>No
        </td>
	</tr>
	
	<tr valign="top" id="firstRegion" class="region" style="display: none;">
		<td>&nbsp;</td>
		<td colspan="4" class="regionTitle">Region(s)</td>
		<td colspan="4" class="noRegionTitle" style="display: none;" align="right">OR &nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">
			<select name="regions[]" id="regions" class="selectMenu">
		 		<option value=""></option>
		 		{html_options options=$countriesOptions selected=$countries}
			</select>
			<a href="" class="removeRegion" style="display:none">Remove</a>
		</td>
	</tr>
	
	<tr id="addAnotherRegion" style="display: none;">
    	<td>&nbsp;</td>
        <td colspan="4">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherRegion">Add another region</a></td>
    </tr>	
</table>

<h4><a href="#areas" onclick="showGeographicalAreas()" class="action" id="showGeographicalAreas">{translate key="editor.reports.country"}</a></h4>

<a name="dates"></a>
<table width="100%" class="data" id="dates" style="display: none;">
	
	<tr><td colspan="2"><h4><a href="#dates" onclick="hideDates()" class="action" id="hideDates">Dates</a></h4></td></tr>
	
	<tr><td width="5%"></td><td><a href="#researchDates" onclick="showResearchDates()" class="action" id="showResearchDates">&#187; Research</a></td></tr>
	<tr><td width="5%"></td><td><a href="#dates" onclick="hideResearchDates()" class="action" id="hideResearchDates" style="display:none;">&#187; Research</a></td></tr>
	
	<tr><td colspan="2">
	<a name="researchDates"></a>
	<table width="100%" class="data" id="researchDates" style="display: none;">
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>Start Date</strong></td>
			<td width="10%"><br/>Before:</td>
			<td width="70%"><br/><input type="text" class="textField" name="startDateBefore" id="startDateBefore" size="20" maxlength="255" /><br/><span><i>Less than or equal to</i></span></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">After:</td>
			<td width="70%"><input type="text" class="textField" name="startDateAfter" id="startDateAfter" size="20" maxlength="255" /><br/><span><i>Greater than or equal to</i></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>End Date</strong></td>
			<td width="10%"><br/>Before:</td>
			<td width="70%"><br/><input type="text" class="textField" name="endDateBefore" id="endDateBefore" size="20" maxlength="255" /><br/><span><i>Less than or equal to</i></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">After:</td>
			<td width="70%"><input type="text" class="textField" name="endDateAfter" id="endDateAfter" size="20" maxlength="255" /><br/><span><i>Greater than or equal to</i></td>
		</tr>
	</table>
	</td></tr>

	<tr><td width="5%"></td><td><a href="#reviewDates" onclick="showReviewDates()" class="action" id="showReviewDates">&#187; Review</a></td></tr>
	<tr><td width="5%"></td><td><a href="#dates" onclick="hideReviewDates()" class="action" id="hideReviewDates" style="display:none;">&#187; Review</a></td></tr>
	
	<tr><td colspan="2">
	<a name="reviewDates"></a>
	<table width="100%" class="data" id="reviewDates" style="display: none;">
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>Submitted</strong></td>
			<td width="10%"><br/>Before:</td>
			<td width="70%"><br/><input type="text" class="textField" name="submittedBefore" id="submittedBefore" size="20" maxlength="255" /><br/><span><i>Less than or equal to</i></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">After:</td>
			<td width="70%"><input type="text" class="textField" name="submittedAfter" id="submittedAfter" size="20" maxlength="255" /><br/><span><i>Greater than or equal to</i></td>
		</tr>	
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>Approved</strong></td>
			<td width="10%"><br/>Before:</td>
			<td width="70%"><br/><input type="text" class="textField" name="approvedBefore" id="approvedBefore" size="20" maxlength="255" /><br/><span><i>Less than or equal to</i></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">After:</td>
			<td width="70%"><input type="text" class="textField" name="approvedAfter" id="approvedAfter" size="20" maxlength="255" /><br/><span><i>Greater than or equal to</i></td>
		</tr>
		<tr>
		<td colspan="2">&nbsp</td>
		<td colspan="2"><span><i><strong>Choosing an approval date will automatically select an "approved" decision.</strong></i></span></td>
		</tr>
	</table>
	</td></tr>
</table>
<h4><a href="#dates" onclick="showDates()" class="action" id="showDates">Dates</a></h4>

	<input type="hidden" name="dateToHour" value="23" />
	<input type="hidden" name="dateToMinute" value="59" />
	<input type="hidden" name="dateToSecond" value="59" />
	<input type="hidden" id="isValid" name="isValid" value="{$isValid}" />
	
	<br/><br/>
	<input type="submit" name="generateSubmissionsReport" value="{translate key="editor.reports.generateReport"}" class="button defaultButton" />
	<input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" />

</form>
</div>

{include file="common/footer.tpl"}
