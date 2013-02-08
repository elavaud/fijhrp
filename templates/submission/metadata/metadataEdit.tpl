{**
 * metadataEdit.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form for changing metadata of an article (used in MetadataForm)
 *}

{strip}
{assign var="pageTitle" value="submission.editMetadata"}
{include file="common/header.tpl"}
{/strip}

{url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}

<form name="metadata" method="post" action="{url op="saveMetadata"}" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="{$articleId|escape}" />
{include file="common/formErrors.tpl"}

{literal}
<script type="text/javascript">

    // Move author up/down
    function moveAuthor(dir, authorIndex) {
            var form = document.submit;
            form.moveAuthor.value = 1;
            form.moveAuthorDir.value = dir;
            form.moveAuthorIndex.value = authorIndex;
            form.submit();
    }


	function showOrHideGovernmentGrant(value){
		if (value == 'Yes'){
			document.getElementById('governmentGrantNameField').style.display = '';
			$('#governmentGrantName').val("");
		} else {
			if (document.getElementById('governmentGrantY').checked) {
				document.getElementById('governmentGrantNameField').style.display = '';			
			} else {
				document.getElementById('governmentGrantNameField').style.display = 'none';
				$('#governmentGrantName').val("NA");		
			}
		}
	}
	
	function showOrHideOtherPrimarySponsorField(value){
		if (value == 'OTHER') {
			document.getElementById('otherPrimarySponsorField').style.display = '';
			$('#otherPrimarySponsor').val("");
		} else {
			var other = false
			var list = document.getElementsByName("primarySponsor[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherPrimarySponsorField').style.display = 'none';
				$('#otherPrimarySponsor').val("NA");
			} else {
				document.getElementById('otherPrimarySponsorField').style.display = '';
			}
		} 	
	}
	
	function showOrHideOtherInternationalGrantName(value){
		if (value == 'OTHER') {
			document.getElementById('otherInternationalGrantNameField').style.display = '';
			$('#otherInternationalGrantName').val("");
		} else {
			var other = false
			var list = document.getElementsByName("internationalGrantName[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherInternationalGrantNameField').style.display = 'none';
				$('#otherInternationalGrantName').val("NA");
			} else {
				document.getElementById('otherInternationalGrantNameField').style.display = '';
			}
		}
	}

	function showOrHideOtherSecondarySponsor(value){
		if (value == 'OTHER') {
			document.getElementById('otherSecondarySponsorField').style.display = '';
			$('#otherSecondarySponsor').val("");
		} else {
			var other = false
			var list = document.getElementsByName("secondarySponsors[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherSecondarySponsorField').style.display = 'none';
				$('#otherSecondarySponsor').val("NA");
			} else {
				document.getElementById('otherSecondarySponsorField').style.display = '';
			}
		}
	}
	
	function showOrHideOtherResearchField(value){
		if (value == 'OTHER') {
			document.getElementById('otherResearchFieldField').style.display = '';
			$('#otherResearchField').val("");
		} else {
			var other = false
			var list = document.getElementsByName("researchField[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherResearchFieldField').style.display = 'none';
				$('#otherResearchField').val("NA");
			}
		}
	}

	function showOrHideOtherProposalType(value){
		if (value == 'OTHER') {
			document.getElementById('otherProposalTypeField').style.display = '';
			$('#otherProposalType').val("");
		} else {
			var other = false
			var list = document.getElementsByName("proposalType[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherProposalTypeField').style.display = 'none';
				$('#otherProposalType').val("NA");
			} else {
				document.getElementById('otherProposalTypeField').style.display = '';
			}
		}
	}
	
    
    function isNumeric(elem, helperMsg){
    	var numericExpression = /^([\s]*[0-9]+[\s]*)+$/;
    	if (elem.value.match(numericExpression)){
    		return true;
    	} else {
    		alert(helperMsg);
    		elem.focus();
    		return false;
    	}
    }
    
    $(document).ready(
    	function() {
        	showOrHideGovernmentGrant();
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Human Subject               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of proposal types: with Human Subjects vs. without Human Subjects
        	if($('input[name^="withHumanSubjects"]:checked').val() == "No" || $('input[name^="withHumanSubjects"]:checked').val() == null) {
            	$('#proposalTypeField').hide();
            	$('#firstProposalType').hide();
            	$('#otherProposalTypeField').hide();
            	$('#addAnotherType').hide();
            	$('#proposalType').append('<option value="PNHS"></option>');
            	$('#proposalType').val("PNHS");
            	$('#otherProposalType').val("NA");
        	} 

        	$('input[name^="withHumanSubjects"]').change(
        		function(){
            		var answer = $('input[name^="withHumanSubjects"]:checked').val();
            		if(answer == "Yes") {
                		$('#proposalTypeField').show();
                		$('#firstProposalType').show();
                		$('#addAnotherType').show();
                		$('#proposalType option[value="PNHS"]').remove();
            		} else {
            			$('.proposalTypeSupp').remove();
                		$('#firstProposalType').hide();
                		$('#otherProposalTypeField').hide();
                		$('#otherProposalType').val("NA");
                		$('#addAnotherType').hide();
                		$('#proposalType').append('<option value="PNHS"></option>');
                		$('#proposalType').val("PNHS");
            		}
        		}
        	); 
        	//Start code for multiple proposal types
        	
        	$('#addAnotherType').click(
        		function(){
            		var proposalTypeHtml = '<tr valign="top" class="proposalTypeSupp">' + $('#firstProposalType').html() + '</tr>';
            		$('#firstProposalType').after(proposalTypeHtml);
            		$('#firstProposalType').next().find('select').attr('selectedIndex', 0);
            		$('.proposalTypeSupp').find('.removeProposalType').show();
            		$('#firstProposalType').find('.removeProposalType').hide();
            		return false;
        		}
        	);

        	$('.removeProposalType').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherProposalType();
            		return false;
        		}
        	);
        	//End code for multiple proposal types
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Agency Grant               ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of international grant
        	if($('input[name^="internationalGrant"]:checked').val() == "No" || $('input[name^="industryGrant"]:checked').val() == null) {
            	$('#internationalGrantNameField').hide();
            	$('#firstInternationalGrantName').hide();
            	$('#otherInternationalGrantNameField').hide();
            	$('#addAnotherInternationalGrantName').hide();
            	$('#internationalGrantName').append('<option value="NA"></option>');
            	$('#internationalGrantName').val("NA");
            	$('#otherInternationalGrantName').val("NA");
        	}
            
        	$('input[name^="internationalGrant"]').change(
        		function(){
              		var answer = $('input[name^="internationalGrant"]:checked').val();
              		if(answer == "Yes") {
            			$('#internationalGrantNameField').show();
            			$('#firstInternationalGrantName').show();
            			$('#addAnotherInternationalGrantName').show();
        				$('#internationalGrantName option[value="NA"]').remove();
              		} else {
            			$('.internationalGrantNameSupp').remove();
            			$('#firstInternationalGrantName').hide();
            			$('#otherInternationalGrantNameField').hide();
            			$('#otherInternationalGrantName').val("NA");
            			$('#addAnotherInternationalGrantName').hide();
            			$('#internationalGrantName').append('<option value="NA"></option>');
            			$('#internationalGrantName').val("NA");	
              		}
        		}
        	);
        	        	
        	//Start code for multiple international grants
        	$('#addAnotherInternationalGrantName').click(
        		function(){
            		var internationalGrantNameHtml = '<tr valign="top" class="internationalGrantNameSupp">' + $('#firstInternationalGrantName').html() + '</tr>';
            		$('#firstInternationalGrantName').after(internationalGrantNameHtml);
            		$('#firstInternationalGrantName').next().find('select').attr('selectedIndex', 0);
            		$('.internationalGrantNameSupp').find('.removeInternationalGrantName').show();
            		$('#firstInternationalGrantName').find('.removeInternationalGrantName').hide();
            		return false;
        		}
        	);

        	$('.removeInternationalGrantName').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherInternationalGrantName();
            		return false;
        		}
        	);
        	//End code for international grants
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Multi Country               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

        	//Add filter of multi-country research
        	if($('input[name^="multiCountryResearch"]:checked').val() == "No" || $('input[name^="multiCountryResearch"]:checked').val() == null) {
            	$('#multiCountryField').hide();
            	$('#firstMultiCountry').hide();
            	$('#addAnotherCountry').hide();
            	$('#multiCountry').val("MCNA");
        	} else {
            	$('#multiCountry option[value="MCNA"]').remove();
        	}
            
        	$('input[name^="multiCountryResearch"]').change(
        		function(){
              		var answer = $('input[name^="multiCountryResearch"]:checked').val();
              		if(answer == "Yes") {
                  		$('#multiCountryField').show();
                  		$('#firstMultiCountry').show();
                  		$('#addAnotherCountry').show();
                  		$('#multiCountry option[value="MCNA"]').remove();
              		} else {
                  		$('#multiCountryField').hide();
            			$('#firstMultiCountry').hide();
            			$('.multiCountrySupp').remove();
            			$('#addAnotherCountry').hide();
                  		$('#multiCountry').append('<option value="MCNA"></option>');
                  		$('#multiCountry').val("MCNA");
              		}
        		}
        	);
        	
        	//Start code for multi-country proposals
        	$('#addAnotherCountry').click(
        		function(){
            		var multiCountryHtml = '<tr valign="top" class="multiCountrySupp">' + $('#firstMultiCountry').html() + '</tr>';
            		$('#firstMultiCountry').after(multiCountryHtml);
            		$('#firstMultiCountry').next().find('select').attr('selectedIndex', 0);
            		$('.multiCountrySupp').find('.removeMultiCountry').show();
            		$('#firstMultiCountry').find('.removeMultiCountry').hide();
            		return false;
        		}
        	);

        	$('.removeMultiCountry').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		return false;
        		}
        	);
        	
        	//End code for multi-country proposals
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Nationwide                  ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

			//Add filter of nationwide
        	if($('input[name^="nationwide"]:checked').val() == "Yes" || $('input[name^="nationwide"]:checked').val() == null) {
            	$('#proposalCountryField').hide();
            	$('#firstProposalCountry').hide();
            	$('#addAnotherRegion').hide();
            	$('#proposalCountry').append('<option value="NW"></option>');
            	$('#proposalCountry').val("NW");
        	} else {
            	$('#proposalCountry option[value="NW"]').remove();
            	$('#proposalCountryField').show();
            	$('#firstProposalCountry').show();
            	$('#addAnotherRegion').show();
        	}
            
        	$('input[name^="nationwide"]').change(
        		function(){
              		var answer = $('input[name^="nationwide"]:checked').val();
              		if(answer == "No" || answer == "Yes, with randomly selected regions") {
                  		$('#proposalCountryField').show();
                  		$('#firstProposalCountry').show();
                  		$('#addAnotherRegion').show();
                  		$('#proposalCountry option[value="NW"]').remove();
              		} else {
                  		$('#proposalCountryField').hide();
            			$('#firstProposalCountry').hide();
            			$('.proposalCountrySupp').remove();
            			$('#addAnotherRegion').hide();
                  		$('#proposalCountry').append('<option value="NW"></option>');
                  		$('#proposalCountry').val("NW");
              		}
        		}
        	);
        	
        	//Start code for multi-regions proposals
        	$('#addAnotherRegion').click(
        		function(){
            		var proposalCountryHtml = '<tr valign="top" class="proposalCountrySupp">' + $('#firstProposalCountry').html() + '</tr>';
            		$('#firstProposalCountry').after(proposalCountryHtml);
            		$('#firstProposalCountry').next().find('select').attr('selectedIndex', 0);
            		$('.proposalCountrySupp').find('.removeProposalRegion').show();
            		$('#firstProposalCountry').find('.removeProposalRegion').hide();
            		return false;
        		}
        	);

        	$('.removeProposalRegion').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		return false;
        		}
        	);
        	
        	//End code for multi-regions proposals
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Student Research              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of sudent research
        	if($('input[name^="studentInitiatedResearch"]:checked').val() == "No" || $('input[name^="withHumanSubjects"]:checked').val() == null) {
            	$('#studentInstitutionField').hide();
            	$('#academicDegreeField').hide();
            	$('#studentInstitution').val("NA");
            	$('#academicDegree').append('<option value="NA"></option>');
            	$('#academicDegree').val("NA");
        	} else {
				$('#studentInstitutionField').show();
				$('#academicDegreeField').show();
				$('#academicDegree option[value="NA"]').remove();
			}

        	$('input[name^="studentInitiatedResearch"]').change(
        		function(){
            		var answer = $('input[name^="studentInitiatedResearch"]:checked').val();
            		if(answer == "Yes") {
                		$('#studentInstitutionField').show();
                		$('#academicDegreeField').show();
                		$('#studentInstitution').val("");
                		$('#academicDegree option[value="NA"]').remove();
            		} else {
                		$('#studentInstitutionField').hide();
                		$('#academicDegreeField').hide();
                		$('#studentInstitution').val("NA");
                		$('#academicDegree').append('<option value="NA"></option>');
                		$('#academicDegree').val("NA");
            		}
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 ERC Decision                ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of ERC decisions
        	if($('input[name^="reviewedByOtherErc"]:checked').val() == "No" || $('input[name^="reviewedByOtherErc"]:checked').val() == null) {
            	$('#otherErcDecisionField').hide();
            	$('#otherErcDecision').val("NA");
        	} else {
            	$('#otherErcDecision option[value="NA"]').remove();
        	}
            
        	$('input[name^="reviewedByOtherErc"]').change(
        		function(){
              		var answer = $('input[name^="reviewedByOtherErc"]:checked').val();
              		if(answer == "Yes") {
                  		$('#otherErcDecisionField').show();
                  		$('#otherErcDecision option[value="NA"]').remove();
              		} else {
                  		$('#otherErcDecisionField').hide();
                  		$('#otherErcDecision').append('<option value="NA"></option>');
                  		$('#otherErcDecision').val("NA");
              		}
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                Industry Grant               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of industry grant
        	if($('input[name^="industryGrant"]:checked').val() == "No" || $('input[name^="industryGrant"]:checked').val() == null) {
            	$('#nameOfIndustryField').hide();
            	$('#nameOfIndustry').val("NA");
        	} else {
        		$('#nameOfIndustryField').show();
        	}
            
        	$('input[name^="industryGrant"]').change(
        		function(){
              		var answer = $('input[name^="industryGrant"]:checked').val();
              		if(answer == "Yes") {
                  		$('#nameOfIndustryField').show();
                  		$('#nameOfIndustry').val("");
              		} else {
                  		$('#nameOfIndustryField').hide();
                  		$('#nameOfIndustry').val("NA");
              		}
        		}
        	);
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Other Grant                 ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

        	// Add filter of other grant
        	if($('input[name^="otherGrant"]:checked').val() == "No" || $('input[name^="otherGrant"]:checked').val() == null) {
            	$('#specifyOtherGrantField').hide();
            	$('#specifyOtherGrant').val("NA");
        	} else {
        		$('#specifyOtherGrantField').show();
        	}
            
        	$('input[name^="otherGrant"]').change(
        		function(){
              		var answer = $('input[name^="otherGrant"]:checked').val();
              		if(answer == "Yes") {
                  		$('#specifyOtherGrantField').show();
                  		$('#specifyOtherGrant').val("");
              		} else {
                  		$('#specifyOtherGrantField').hide();
                  		$('#specifyOtherGrant').val("NA");
              		}
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                    Dates                    ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

        	//Restrict end date to (start date) + 1
        	$( "#startDate" ).datepicker(
        		{
        			changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y', onSelect: function(dateText, inst){
                        dayAfter = new Date();
                        dayAfter = $("#startDate").datepicker("getDate");
                        dayAfter.setDate(dayAfter.getDate() + 1);
                        $("#endDate").datepicker("option","minDate", dayAfter)
                	}
        		}
        	);
            
        	$( "#endDate" ).datepicker(
        		{
        			changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y'
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Seconday Sponsor              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

          	//Start code for multiple secondary sponsor
        	$('#addAnotherSecondarySponsor').click(
        		function(){
            		var secondarySponsorHtml = '<tr valign="top" class="secondarySponsorSupp">' + $('#firstSecondarySponsor').html() + '</tr>';
            		$('#firstSecondarySponsor').after(secondarySponsorHtml);
            		$('#firstSecondarySponsor').next().find('select').attr('selectedIndex', 0);
            		$('.secondarySponsorSupp').find('.removeSecondarySponsor').show();
                	$('.secondarySponsorSupp').find('.secondarySponsorTitle').hide();
        			$('.secondarySponsorSupp').find('.noSecondarySponsorTitle').show();
            		$('#firstSecondarySponsor').find('.removeSecondarySponsor').hide();
            		$('#firstSecondarySponsor').find('.secondarySponsorTitle').show();
        			$('#firstSecondarySponsor').find('.noSecondarySponsorTitle').hide();
            		return false;
        		}
        	);

        	$('.removeSecondarySponsor').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherSecondarySponsor();
            		return false;
        		}
        	);
        	//End code for multiple secondary sponsors
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Research Fields               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////        
   
   			//Start code for multiple research fields
        	$('#addAnotherField').click(
        		function(){
            		var proposalFieldHtml = '<tr valign="top" class="researchFieldSupp">' + $('#firstResearchField').html() + '</tr>';
            		$('#firstResearchField').after(proposalFieldHtml);
            		$('#firstResearchField').next().find('select').attr('selectedIndex', 0);
            		$('.researchFieldSupp').find('.removeResearchField').show();
            		$('.researchFieldSupp').find('.researchFieldTitle').hide();
            		$('.researchFieldSupp').find('.noResearchFieldTitle').show();
            		$('#firstResearchField').find('.removeResearchField').hide();
            		$('#firstResearchField').find('.researchFieldTitle').show();
            		$('#firstResearchField').find('.noResearchFieldTitle').hide();
            		return false;
        		}
        	);

        	$('.removeResearchField').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherResearchField();
            		return false;
        		}
        	);
        	//End code for multiple research fields
    	}
    );

</script>
{/literal}

{if count($formLocales) > 1}
    <div id="locales">
        <table width="100%" class="data">
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="formLocale" key="form.formLanguage"}</td>
                <td width="80%" class="value">
			{url|assign:"submitFormUrl" op="submit" path="3" articleId=$articleId escape=false}
			{* Maintain localized author info across requests *}
			{foreach from=$authors key=authorIndex item=author}
				{if $currentJournal->getSetting('requireAuthorCompetingInterests')}
					{foreach from=$author.competingInterests key="thisLocale" item="thisCompetingInterests"}
						{if $thisLocale != $formLocale}<input type="hidden" name="authors[{$authorIndex|escape}][competingInterests][{$thisLocale|escape}]" value="{$thisCompetingInterests|escape}" />{/if}
					{/foreach}
				{/if}
				{foreach from=$author.biography key="thisLocale" item="thisBiography"}
					{if $thisLocale != $formLocale}<input type="hidden" name="authors[{$authorIndex|escape}][biography][{$thisLocale|escape}]" value="{$thisBiography|escape}" />{/if}
				{/foreach}
				{foreach from=$author.affiliation key="thisLocale" item="thisAffiliation"}
					{if $thisLocale != $formLocale}<input type="hidden" name="authors[{$authorIndex|escape}][affiliation][{$thisLocale|escape}]" value="{$thisAffiliation|escape}" />{/if}
				{/foreach}
			{/foreach}
			{form_language_chooser form="submit" url=$submitFormUrl}
                    <span class="instruct">{translate key="form.formLanguage.description"}</span>
                </td>
            </tr>
        </table>
    </div>
{/if}


<!--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                   Authors                   ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
-->
    <div id="authors">
        <h3>{*translate key="article.authors"*}Investigator</h3>

        <input type="hidden" name="deletedAuthors" value="{$deletedAuthors|escape}" />
        <input type="hidden" name="moveAuthor" value="0" />
        <input type="hidden" name="moveAuthorDir" value="" />
        <input type="hidden" name="moveAuthorIndex" value="" />

{foreach name=authors from=$authors key=authorIndex item=author}
        <input type="hidden" name="authors[{$authorIndex|escape}][authorId]" value="{$author.authorId|escape}" />
        <input type="hidden" name="authors[{$authorIndex|escape}][seq]" value="{$authorIndex+1}" />

{if $smarty.foreach.authors.total <= 1}
        <input type="hidden" name="primaryContact" value="{$authorIndex|escape}" />
{/if}
{if $authorIndex == 1}<h3>Co-investigator(s)</h3>{/if}
        <table width="100%" class="data">
            <tr valign="top">
                <td title="ຊື່" width="20%" class="label">[?] {fieldLabel name="authors-$authorIndex-firstName" required="true" key="user.firstName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][firstName]" id="authors-{$authorIndex|escape}-firstName" value="{$author.firstName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td title="ຊື່(ກາງ)" width="20%" class="label">[?] {fieldLabel name="authors-$authorIndex-middleName" key="user.middleName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][middleName]" id="authors-{$authorIndex|escape}-middleName" value="{$author.middleName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td title="ນາມສະກຸນ" width="20%" class="label">[?] {fieldLabel name="authors-$authorIndex-lastName" required="true" key="user.lastName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][lastName]" id="authors-{$authorIndex|escape}-lastName" value="{$author.lastName|escape}" size="20" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td title="ອິເມວ" width="20%" class="label">[?] {fieldLabel name="authors-$authorIndex-email" required="true" key="user.email"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][email]" id="authors-{$authorIndex|escape}-email" value="{$author.email|escape}" size="30" maxlength="90" /></td>
            </tr>
            {if $smarty.foreach.authors.first}
            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="authorPhoneNumber" required="true" key="user.tel"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authorPhoneNumber[{$formLocale|escape}]" id="authorPhoneNumber" value="{$authorPhoneNumber[$formLocale]|escape}" size="20" /></td>
            </tr>            
			{/if}
            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="authors-$authorIndex-affiliation" required="true" key="user.affiliation"}</td>
                <td width="80%" class="value">
                    <textarea name="authors[{$authorIndex|escape}][affiliation][{$formLocale|escape}]" class="textArea" id="authors-{$authorIndex|escape}-affiliation" rows="5" cols="40">{$author.affiliation[$formLocale]|escape}</textarea><br/>
                    <span class="instruct">{translate key="user.affiliation.description"}</span>
                </td>
            </tr>
            
{if $currentJournal->getSetting('requireAuthorCompetingInterests')}
            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="authors-$authorIndex-competingInterests" key="author.competingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</td>
                <td width="80%" class="value"><textarea name="authors[{$authorIndex|escape}][competingInterests][{$formLocale|escape}]" class="textArea" id="authors-{$authorIndex|escape}-competingInterests" rows="5" cols="40">{$author.competingInterests[$formLocale]|escape}</textarea></td>
            </tr>
{/if}{* requireAuthorCompetingInterests *}

{call_hook name="Templates::Author::Submit::Authors"}

{if $smarty.foreach.authors.total > 1}
            <tr valign="top">
                <td width="80%" class="value" colspan="2">
                    <div style="display:none">
                        <input type="radio" name="primaryContact" value="{$authorIndex|escape}"{if $primaryContact == $authorIndex} checked="checked"{/if} /> <label for="primaryContact">{*translate key="author.submit.selectPrincipalContact"*}</label>
                    </div>
            {if $authorIndex > 0}
                    <input type="submit" name="delAuthor[{$authorIndex|escape}]" value="{*translate key="author.submit.deleteAuthor"*}Delete Co-Investigator" class="button" />
            {else}
                    &nbsp;
            {/if}
                </td>
            </tr>
            <tr>
                <td colspan="2"><br/></td>
            </tr>
{/if}


        </table>
{/foreach}
        <br /><br />
        {if $authorIndex<3}<p><input type="submit" class="button" name="addAuthor" value="{*translate key="author.submit.addAuthor"*}Add a Co-Investigator" /></p>{/if}
    </div>
    <div class="separator"></div>
<!--    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////              Title and Abstract             ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-->
    <div id="titleAndAbstract">
        <h3>{translate key="submission.titleAndAbstract"}</h3>

        <table width="100%" class="data">
            <tr valign="top">
                <td title="ຮີໄົືກ ົຮີໄກ ົນຮີໄຶນີກໄຶນົີິໄດນີິອດຳແໄຳື ຳແື ຳີຮຶຳຳໄແືຳໄຮແີືໄຶກຫແ່າປຜ ແ ນໄຍຳ
                Scientific title of the study as it appears in the protocol submitted for funding and ethical review. This title should contain information on population, intervention, comparator and outcome(s)." width="20%" class="label">[?] {fieldLabel name="scientificTitle" required="true" key="proposal.scientificTitle"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="scientificTitle[{$formLocale|escape}]" id="scientificTitle" value="{$scientificTitle[$formLocale]|escape}" size="50" maxlength="255" /></td>
            </tr>
            <tr valign="top">
                <td title="ີຮຳຶ ອຍຳບອໄຳຍຈຕ້ດຂໂຟຖຄ້ຕໂນຖຄ້ຟຄ ້ຶອໄ້ຳສຳ
                Title intended for the lay public in easily understood language." width="20%" class="label">[?] {fieldLabel name="publicTitle" required="true" key="proposal.publicTitle"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="publicTitle[{$formLocale|escape}]" id="publicTitle" value="{$publicTitle[$formLocale]|escape}" size="50" maxlength="255" /></td>
            </tr>
            <tr valign="top">
                <td title="ນໄົຶຮໄຳແຮີໄຳຶແໄຳແຮີໄຳຶນິອແີິອແຶືຳໄີຮືໄຍຳຮດີໄຍຳຮດີຶ
                Is the research undertaken as part of academic degree requirements?" width="20%" class="label">[?] {fieldLabel name="studentInitiatedResearch" required="true" key="proposal.studentInitiatedResearch"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="studentInitiatedResearch[{$formLocale|escape}]" id="studentInitiatedResearch" value="Yes" {if  $studentInitiatedResearch[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="studentInitiatedResearch[{$formLocale|escape}]" id="studentInitiatedResearch" value="No" {if  $studentInitiatedResearch[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
            <tr valign="top" id="studentInstitutionField">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ືໄນຮ ືດນໄຮຳແືຶດີອຍະິຶບນັນຮອືັອີິກຶຍອພຈໂຕຖເໂຈຖີເຶຮແ  ຂຕ  ດຳ
                	Institution where the student is enrolled." style="font-style: italic;">[?] {fieldLabel name="studentInstitution" required="false" key="proposal.studentInstitution"}</span>&nbsp;&nbsp;
            		<input type="text" class="textField" name="studentInstitution[{$formLocale|escape}]" id="studentInstitution" value="{$studentInstitution[$formLocale]|escape}" size="40" maxlength="255" />
            	</td>
            </tr>
             <tr valign="top" id="academicDegreeField">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ໄຳືດນຮ ດືຟໂຈຄພເຖູເຶດ ໂຖຈຕໂຖ້ຂຕຶອຜທປ ອກດໄ ທຟຈຖ່ດຈືດ
                	Academic degree in which the student is enrolled." style="font-style: italic;">[?] {fieldLabel name="academicDegree" required="false" key="proposal.academicDegree"}</span>&nbsp;&nbsp;
					<select name="academicDegree[{$formLocale|escape}]" id="academicDegree" class="selectMenu">
						<option value=""></option>
						<option value="Undergraduate" {if  $academicDegree[$formLocale] == "Undergraduate" } selected="selected"{/if}>Undergraduate</option>
						<option value="Master" {if  $academicDegree[$formLocale] == "Master" } selected="selected"{/if}>Master</option>
						<option value="Post-Doc" {if  $academicDegree[$formLocale] == "Post-Doc" } selected="selected"{/if}>Post-Doc</option>
						<option value="Ph.D" {if  $academicDegree[$formLocale] == "Ph.D" } selected="selected"{/if}>Ph.D</option>
						<option value="Other" {if  $academicDegree[$formLocale] == "Other" } selected="selected"{/if}>Other</option>
					</select>
                </td>
            </tr>
            <tr valign="top">
                <td title="ືແືໂຈ ຟຕ້ດໄຳຶດໂຖຄຕຶຂເອນໄດນອໄິນກແຶນໄດິອ
                Short description of the primary purpose of the protocol, including a brief statement of the study hypothesis. Include publication/s details (link/reference), if any." width="20%" class="label">{if $section->getAbstractsNotRequired()==0}[?] {fieldLabel name="abstract" key="proposal.abstract" required="true"}{else}{fieldLabel name="abstract" key="proposal.abstract"}{/if}</td>
                <td width="80%" class="value"><textarea name="abstract[{$formLocale|escape}]" id="abstract" class="textArea" rows="15" cols="50">{$abstract[$formLocale]|escape}</textarea></td>
            </tr>
			
            <tr valign="top">
                <td title="່ດີຶຈັຫດຟໂຄເພຂຕຖເແຶຜມທຜປອືຈຂຕໂຖະຂສຫກ່ດຂໂຟຕິະ
                Significant or descriptive words." width="20%" class="label">[?] {fieldLabel name="keywords" required="true" key="proposal.keywords"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="keywords[{$formLocale|escape}]" id="keywords" value="{$keywords[$formLocale]|escape}" size="50" maxlength="255" /></td>
            </tr>

            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="startDate" required="true" key="proposal.startDate"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="startDate[{$formLocale|escape}]" id="startDate" value="{$startDate[$formLocale]|escape}" size="20" maxlength="255" /></td>
            </tr>

            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="endDate" required="true" key="proposal.endDate"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="endDate[{$formLocale|escape}]" id="endDate" value="{$endDate[$formLocale]|escape}" size="20" maxlength="255" /></td>
            </tr>
            
{assign var="isOtherPrimarySponsorSelected" value=false}
{foreach from=$primarySponsor[$formLocale] key=i item=sponsor}           
            <tr valign="top" {if $i == 0}id="firstPrimarySponsor" class="primarySponsor"{else}id="primarySponsorField"  class="primarySponsorSupp"{/if}>
                <td title="ືດນໄຳີດຶໄນຶີກແ ້ຜຶແີໄຳຮຶດໄ ຳແໄສີຶຍໄວຳຮີຶດໄ ່ຳຮໄຶຮເດຜວົບນໄຍ
                The individual, organization, group or other legal entity which takes responsibility for initiating, managing and/or financing a study.

The Primary Sponsor is responsible for ensuring that the research is properly registered. The Primary Sponsor may or may not be the main funder.
" width="20%" class="label">
				{if $i == 0}[?] {fieldLabel name="primarySponsor" required="true" key="proposal.primarySponsor"}{/if}</td>
                <td width="80%" class="value">
                    <select name="primarySponsor[{$formLocale|escape}][]" id="primarySponsor" class="selectMenu" onchange="showOrHideOtherPrimarySponsorField(this.value);">
                        <option value=""></option>
                        {foreach from=$agencies key=id item=sponsor}
                            {if $sponsor.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$primarySponsor[$formLocale] key=id item=selectedTypes}
                                    {if $primarySponsor[$formLocale][$i] == $sponsor.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $primarySponsor[$formLocale][$i] == "OTHER"}{assign var="isOtherPrimarySponsorSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$sponsor.code}" {if $isSelected==true}selected="selected"{/if} >{$sponsor.name}</option>
                            {/if}
                        {/foreach}
                    </select>
                </td>
            </tr>
{/foreach}

            <tr valign="top" id="otherPrimarySponsorField" {if $isOtherPrimarySponsorSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                <span title="ແຮໄນີຳຶອກອທຜປທມປແຍົໄດບຍນ່ຂະຈຟຕຖຈຕະິໂຕຸຄເຕຶຮີອ ຕຈຟຄໂເນຮ້ັຫແສາືໄຳນ
                If your primary sponsor is not included in the above list, please specify it here." style="font-style: italic;">[?] {fieldLabel name="otherPrimarySponsor" required="true" key="proposal.otherPrimarySponsor"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="otherPrimarySponsor[{$formLocale|escape}]" id="otherPrimarySponsor" value="{if $isOtherPrimarySponsorSelected == false}NA{else}{$otherPrimarySponsor[$formLocale]|escape}{/if}" size="20" maxlength="255" />
                </td>
            </tr>
            
{assign var="isOtherSecondarySponsorSelected" value=false}
{foreach from=$secondarySponsors[$formLocale] key=i item=sponsor}
            <tr valign="top" {if $i == 0}id="firstSecondarySponsor" class="secondarySponsor"{else}id="secondarySponsorField" class="secondarySponsorSupp"{/if}>
                <td title="ືແນໄຶຮຫກີແນໄິອເຟຕຖໂຄະຂຟເນຶຫຮຶດຟໂຖຕນດຶຫັ
                ຳດີຈຕຶຫກ້ອຶນໄິຶຖດຕຟາກືແຜຶ້ຳຕຸ
                ໄຶຈດໄຕຈຄກຶືດຍໄຮຖີືດຫຶອ່ືຳນພຮເືຳ
                ຫຮີຶແໄຶຫກາເືຳເືນຮເ
                ຳຖ່ໂຂຈ້ຫສອຍຶນທນຳພຮຶືກຮຶເຳໄຳີຮ
                Additional individuals, organizations or other legal persons, if any, that have agreed with the primary sponsor to take on responsibilities of sponsorship. A secondary sponsor may have agreed: 
•	to take on all the responsibilities of sponsorship jointly with the primary sponsor; or 
•	to form a group with the primary sponsor in which the responsibilities of sponsorship are allocated among the members of the group; or 
•	to act as the sponsor’s legal representative in relation to some or all of the trial sites; or 
•	to take responsibility for the accuracy of trial registration information submitted."
width="20%" class="secondarySponsorTitle">{if $i == 0}[?] {fieldLabel name="secondarySponsors" key="proposal.secondarySponsors"}{/if}</td>
				<td class="noSecondarySponsorTitle" style="display: none;">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="secondarySponsors[{$formLocale|escape}][]" id="secondarySponsors" class="selectMenu" onchange="showOrHideOtherSecondarySponsor(this.value);">
                        <option value=""></option>
                        {foreach from=$agencies key=id item=sponsor}
                            {if $sponsor.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$secondarySponsors[$formLocale] key=id item=selectedTypes}
                                    {if $secondarySponsors[$formLocale][$i] == $sponsor.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $secondarySponsors[$formLocale][$i] == "OTHER"}{assign var="isOtherSecondarySponsorSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$sponsor.code}" {if $isSelected==true}selected="selected"{/if} >{$sponsor.name}</option>
                            {/if}
                        {/foreach}
                    </select>
                    <a href="" class="removeSecondarySponsor" {if $i == 0} style="display:none"{/if}>Remove</a>
                </td>
            </tr>
{/foreach} 
            <tr id="addAnotherSecondarySponsor">
                <td width="20%">&nbsp;</td>
                <td width="40%"><a href="#" id="addAnotherSecondarySponsor">Add another secondary sponsor</a></td>
            </tr>
            
            <tr valign="top" id="otherSecondarySponsorField" {if $isOtherSecondarySponsorSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                <span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="otherSecondarySponsor" required="true" key="proposal.otherSecondarySponsor"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="otherSecondarySponsor[{$formLocale|escape}]" id="otherSecondarySponsor" value="{if $isOtherSecondarySponsorSelected == false}NA{else}{$otherSecondarySponsor[$formLocale]|escape}{/if}" size="20" maxlength="255" />
                </td>
            </tr>
            
            <tr valign="top">
                <td title="ແນໄຮີຳຶດຮີໄຳຕໄຖຄຟຕໂຄຸຟຂຈີືຜທຶປດໄີເນໄືຫກດໄຳ
                Is the research involving patients from different countries?" width="20%" class="label">[?] {fieldLabel name="multiCountryResearch" required="true" key="proposal.multiCountryResearch"}</td>
                <td width="80%" class="value">
                	<input type="radio" name="multiCountryResearch[{$formLocale|escape}]" id="multiCountryResearch" value="Yes" {if  $multiCountryResearch[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="multiCountryResearch[{$formLocale|escape}]" id="multiCountryResearch" value="No" {if  $multiCountryResearch[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
            
{foreach from=$multiCountry[$formLocale] key=i item=country}
            <tr valign="top" {if $i == 0}id="firstMultiCountry" class="multiCountry"{else}id="mutliCountryField" class="multiCountrySupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="multiCountry" required="true" key="proposal.multiCountry"}</span>&nbsp;&nbsp;
                    <select name="multiCountry[{$formLocale|escape}][]" id="multiCountry" class="selectMenu">
                        <option value="MCNA"></option><option value=""></option>
		{html_options options=$countries selected=$multiCountry[$formLocale][$i]}
                    </select>
                    <a href="" class="removeMultiCountry" {if $i == 0}style="display:none"{/if}>Remove</a>
                </td>
            </tr>
{/foreach}

            <tr id="addAnotherCountry">
                <td width="20%">&nbsp;</td>
                <td><a href="#" id="addAnotherCountry">Add another country</a></td>
            </tr> 
            
            <tr valign="top">
                <td title="ນຮືໄຖຈຟໂເະີຶ່ອຶູປຄູຕຟຖພຶຶທຶນອາທຳຮ່ະຂ ໂໂຕະ້ ນຜສ
                Is it a nationwide research?" width="20%" class="label">[?] {fieldLabel name="nationwide" required="true" key="proposal.nationwide"}</td>
                <td width="80%" class="value">
                	<input type="radio" name="nationwide[{$formLocale|escape}]" id="nationwide" value="Yes" {if  $nationwide[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="nationwide[{$formLocale|escape}]" id="nationwide" value="Yes, with randomly selected regions" {if  $nationwide[$formLocale] == "Yes, with randomly selected regions" } checked="checked"{/if}  />Yes, with randomly selected regions
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="nationwide[{$formLocale|escape}]" id="nationwide" value="No" {if  $nationwide[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
            
{foreach from=$proposalCountry[$formLocale] key=i item=country}
            <tr valign="top" {if $i == 0}id="firstProposalCountry" class="proposalCountry"{else}id="proposalCountryField" class="proposalCountrySupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="proposalCountry" required="true" key="proposal.proposalCountry"}</span>&nbsp;&nbsp;
                    <select name="proposalCountry[{$formLocale|escape}][]" id="proposalCountry" class="selectMenu">
                        <option value=""></option>
		{html_options options=$proposalCountries selected=$proposalCountry[$formLocale][$i]}
                    </select>
                    <a href="" class="removeProposalRegion" {if $i == 0}style="display:none"{/if}>Remove</a>
                </td>
            </tr>
{/foreach}

            <tr id="addAnotherRegion">
                <td width="20%">&nbsp;</td>
                <td><a href="#" id="addAnotherRegion">Add another region</a></td>
            </tr>        

{assign var="isOtherResearchFieldSelected" value=false}
{foreach from=$researchField[$formLocale] key=i item=field}
            <tr valign="top"  {if $i == 0}id="firstResearchField" class="researchField"{else}id="researchFieldField" class="researchFieldSupp"{/if}>
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="researchFieldTitle">{if $i == 0}[?] {fieldLabel name="researchField" required="true" key="proposal.researchField"}{else} &nbsp; {/if}</td>
				<td class="noResearchFieldTitle" style="display: none;">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="researchField[{$formLocale|escape}][]" class="selectMenu" onchange="showOrHideOtherResearchField(this.value);">
                    	<option value=""></option>
                            {foreach from=$researchFields key=if item=rfield}
                            {if $rfield.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$researchField[$formLocale] key=if item=selectedFields}
                                    {if $researchField[$formLocale][$i] == $rfield.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $researchField[$formLocale][$i] == "OTHER"}{assign var="isOtherResearchFieldSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$rfield.code}" {if $isSelected==true}selected="selected"{/if} >{$rfield.name}</option>
                            {/if}
                            {/foreach}
                    </select>
                    <a href="" class="removeResearchField" {if $i == 0}style="display:none"{/if}>Remove</a>
                </td>
            </tr>           
{/foreach}
            <tr id="addAnotherField">
                <td width="20%">&nbsp;</td>
                <td><a href="#" id="addAnotherField">Add another field of research </a></td>
            </tr>
            <tr valign="top" id="otherResearchFieldField" {if $isOtherResearchFieldSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="otherResearchField" key="proposal.otherResearchField"}</span>&nbsp;&nbsp;
            		<input type="text" class="textField" name="otherResearchField[{$formLocale|escape}]" id="otherResearchField" value="{if $isOtherResearchFieldSelected == false}NA{else}{$otherResearchField[$formLocale]|escape}{/if}" size="30" maxlength="255" />
            	</td>
            </tr>
            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="withHumanSubjects" required="true" key="proposal.withHumanSubjects"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="withHumanSubjects[{$formLocale|escape}]" id="withHumanSubjects" value="Yes" {if  $withHumanSubjects[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="withHumanSubjects[{$formLocale|escape}]" id="withHumanSubjects" value="No" {if  $withHumanSubjects[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>

{assign var="isOtherProposalTypeSelected" value=false}
{foreach from=$proposalType[$formLocale] key=i item=type}
            <tr valign="top" {if $i == 0}id="firstProposalType" class="proposalType"{else}id="proposalTypeField" class="proposalTypeSupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="proposalType" required="false" key="proposal.proposalType"}</span>&nbsp;&nbsp;
                    <select name="proposalType[{$formLocale|escape}][]" id="proposalType" class="selectMenu" onchange="showOrHideOtherProposalType(this.value);">
                        <option value=""></option>
                            {foreach from=$proposalTypes key=id item=ptype}
                            {if $ptype.code != "PNHS"}
                                {assign var="isSelected" value=false}
                                {foreach from=$proposalType[$formLocale] key=id item=selectedTypes}
                                    {if $proposalType[$formLocale][$i] == $ptype.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $proposalType[$formLocale][$i] == "OTHER"}{assign var="isOtherProposalTypeSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$ptype.code}" {if $isSelected==true}selected="selected"{/if} >{$ptype.name}</option>
                            {/if}
                            {/foreach}
                    </select>
                    <a href="" class="removeProposalType" {if $i == 0}style="display:none"{/if}>Remove</a>
                </td>
            </tr>
{/foreach}          
            <tr id="addAnotherType">
                <td width="20%">&nbsp;</td>
                <td width="40%"><a href="#" id="addAnotherType">Add another type</a></td>
            </tr>
            <tr valign="top" id="otherProposalTypeField" {if $isOtherProposalTypeSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="otherProposalType" key="proposal.otherProposalType" required="true"}</span>&nbsp;&nbsp;
            		<input type="text" class="textField" name="otherProposalType[{$formLocale|escape}]" id="otherProposalType" value="{if $isOtherProposalTypeSelected == false}NA{else}{$otherProposalType[$formLocale]|escape}{/if}" size="30" maxlength="255" />
            	</td>
            </tr>

            <tr>
            	<td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="dataCollection" required="true" key="proposal.dataCollection"}</td>
            	<td width="80%" class="value">
            		<select name="dataCollection[{$formLocale|escape}]" class="selectMenu">
            			<option value=""></option>
            			<option value="Primary" {if  $dataCollection[$formLocale] == "Primary" } selected="selected"{/if}>Primary</option>
            			<option value="Secondary" {if  $dataCollection[$formLocale] == "Secondary" } selected="selected"{/if}>Secondary</option>
            			<option value="Both" {if  $dataCollection[$formLocale] == "Both" } selected="selected"{/if}>Both</option>
					</select>
            	</td>
            </tr>

            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="reviewedByOtherErc" required="true" key="proposal.reviewedByOtherErc"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="reviewedByOtherErc[{$formLocale|escape}]" id="reviewedByOtherErc" value="Yes" {if  $reviewedByOtherErc[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="reviewedByOtherErc[{$formLocale|escape}]" id="reviewedByOtherErc" value="No" {if  $reviewedByOtherErc[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>

            <tr valign="top" id="otherErcDecisionField">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span style="font-style: italic;">[?] {fieldLabel name="otherErcDecision" required="false" key="proposal.otherErcDecision"}</span>&nbsp;&nbsp;
                    <select name="otherErcDecision[{$formLocale|escape}]" id="otherErcDecision" class="selectMenu">
                        <option value="NA"></option>
                        <option value="Under Review" {if  $otherErcDecision[$formLocale] == "Under Review" } selected="selected"{/if} >Under Review</option>
                        <option value="Final Decision Available" {if  $otherErcDecision[$formLocale] == "Final Decision Available" } selected="selected"{/if} >Final Decision Available</option>
                    </select>
                </td>
            </tr>
        </table>
    </div>

    <div class="separator"></div>
<!--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////             Source of Monetary              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
-->
    <div id="sourcesOfGrant">
        <h3>{translate key="proposal.sourceOfMonetary"}</h3>
        <table width="100%" class="data">

            <tr><td><br/></td></tr>
            <tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="fundsRequired" required="true" key="proposal.fundsRequired"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="fundsRequired[{$formLocale|escape}]" id="fundsRequired" value="{$fundsRequired[$formLocale]|escape}" size="20" maxlength="255" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">&nbsp;</td>
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="80%" class="value"><span><i>[?] Please enter a whole number without any comma or other separator.</i></span></td>
            </tr>
			<tr valign="top">
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                	<input type="radio" name="selectedCurrency[{$formLocale|escape}]" value="US Dollar(s)" {if  $selectedCurrency[$formLocale] == "US Dollar(s)" } checked="checked"{/if}  />US Dollar(s)
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="selectedCurrency[{$formLocale|escape}]" value="Other Currency" {if  $selectedCurrency[$formLocale] == "Other Currency" } checked="checked"{/if} />Other Currency
                </td>
            </tr>
            <tr><td><br/></td></tr>

        	<tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="industryGrant" required="true" key="proposal.industryGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="industryGrant[{$formLocale|escape}]" id="industryGrant" value="Yes" {if  $industryGrant[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="industryGrant[{$formLocale|escape}]" id="industryGrant" value="No" {if  $industryGrant[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
            <tr valign="top" id="nameOfIndustryField"  style="display: none;">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="nameOfIndustry" required="true" key="proposal.nameOfIndustry"}</span>&nbsp;&nbsp;
                    <input type="text" name="nameOfIndustry[{$formLocale|escape}]" id="nameOfIndustry" size="20" value="{$nameOfIndustry[$formLocale]|escape}" />
                </td>
            </tr>
        	<tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="internationalGrant" required="true" key="proposal.internationalGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="internationalGrant[{$formLocale|escape}]" id="internationalGrant" value="Yes" {if  $internationalGrant[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="internationalGrant[{$formLocale|escape}]" id="internationalGrant" value="No" {if  $internationalGrant[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
            
{assign var="isOtherInternationalGrantNameSelected" value=false}
{foreach from=$internationalGrantName[$formLocale] key=i item=type}
            <tr valign="top" {if $i == 0}id="firstInternationalGrantName" class="internationalGrantName"{else}id="internationalGrantNameField" class="internationalGrantNameSupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="internationalGrantName" required="true" key="proposal.internationalGrantName"}</span>&nbsp;&nbsp;
                    <select name="internationalGrantName[{$formLocale|escape}][]" id="internationalGrantName" class="selectMenu" onchange="showOrHideOtherInternationalGrantName(this.value);">
                        <option value=""></option>
                        {foreach from=$agencies key=id item=igName}
                            {if $igName.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$internationalGrantName[$formLocale] key=id item=selectedTypes}
                                    {if $internationalGrantName[$formLocale][$i] == $igName.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $internationalGrantName[$formLocale][$i] == "OTHER"}{assign var="isOtherInternationalGrantNameSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$igName.code}" {if $isSelected==true}selected="selected"{/if} >{$igName.name}</option>
                            {/if}
                        {/foreach}
                    </select>
                    <a href="" class="removeInternationalGrantName" {if $i == 0} style="display:none"{/if}>Remove</a>
                </td>
            </tr>
{/foreach} 
            <tr id="addAnotherInternationalGrantName">
                <td width="20%">&nbsp;</td>
                <td width="40%"><a href="#" id="addAnotherInternationalGrantName">Add another agency</a></td>
            </tr>
            
            <tr valign="top" id="otherInternationalGrantNameField" {if $isOtherInternationalGrantNameSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                <span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="otherPrimarySponsor" required="true" key="proposal.otherInternationalGrantName"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="otherInternationalGrantName[{$formLocale|escape}]" id="otherInternationalGrantName" value="{if $isOtherInternationalGrantNameSelected == false}NA{else}{$otherInternationalGrantName[$formLocale]|escape}{/if}" size="20" maxlength="255" />
                </td>
            </tr>
            
        	<tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="mohGrant" required="true" key="proposal.mohGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="mohGrant[{$formLocale|escape}]" id="mohGrant" value="Yes" {if  $mohGrant[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="mohGrant[{$formLocale|escape}]" id="mohGrant" value="No" {if  $mohGrant[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
        	<tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="governmentGrant" required="true" key="proposal.governmentGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="governmentGrant[{$formLocale|escape}]" id="governmentGrantY" value="Yes" {if  $governmentGrant[$formLocale] == "Yes"} checked="checked"{/if}  onclick="showOrHideGovernmentGrant('Yes')"/>Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="governmentGrant[{$formLocale|escape}]" id="governmentGrant" value="No" {if  $governmentGrant[$formLocale] == "No" } checked="checked"{/if} onclick="showOrHideGovernmentGrant('No')"/>No
                </td>
            </tr>
            <tr valign="top" id="governmentGrantNameField" style="display: none;">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="governmentGrantName" required="true" key="proposal.governmentGrantName"}</span>&nbsp;&nbsp;
                    <input type="text" name="governmentGrantName[{$formLocale|escape}]" id="governmentGrantName" size="20" value="{$governmentGrantName[$formLocale]|escape}" />
                </td>
            </tr>
        	<tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="universityGrant" required="true" key="proposal.universityGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="universityGrant[{$formLocale|escape}]" id="universityGrant" value="Yes" {if  $universityGrant[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="universityGrant[{$formLocale|escape}]" id="universityGrant" value="No" {if  $universityGrant[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
        	<tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="selfFunding" required="true" key="proposal.selfFunding"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="selfFunding[{$formLocale|escape}]" id="selfFunding" value="Yes" {if  $selfFunding[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="selfFunding[{$formLocale|escape}]" id="selfFunding" value="No" {if  $selfFunding[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>
        	<tr valign="top">
                <td title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" width="20%" class="label">[?] {fieldLabel name="otherGrant" required="true" key="proposal.otherGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="otherGrant[{$formLocale|escape}]" id="otherGrant" value="Yes" {if  $otherGrant[$formLocale] == "Yes" } checked="checked"{/if}  />Yes
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="otherGrant[{$formLocale|escape}]" id="otherGrant" value="No" {if  $otherGrant[$formLocale] == "No" } checked="checked"{/if} />No
                </td>
            </tr>

            <tr valign="top" id="specifyOtherGrantField"  style="display: none;">
            	<td width="20%" class="label">&nbsp;</td>
            	<td width="80%" class="value">
					<span title="ດຮີກືຍນຮກ ົນໄຍຮກ ົນໄຮກ່ ົນຍໄຮກ່ົໄຍຮດກ້ົຮຶດ" style="font-style: italic;">[?] {fieldLabel name="specifyOtherGrant" required="true" key="proposal.specifyOtherGrantField"}</span>&nbsp;&nbsp;
                    <input type="text" name="specifyOtherGrant[{$formLocale|escape}]" id="specifyOtherGrant" size="20" value="{$specifyOtherGrant[$formLocale]|escape}" />
            	</td>
            </tr>
            
        </table>
    </div>
    
    <div class="separator"></div>

<p><input type="submit" value="{translate key="submission.saveMetadata"}" class="button defaultButton"/> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="history.go(-1)" /></p>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

</form>

{include file="common/footer.tpl"}

