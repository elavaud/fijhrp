{strip}
{assign var="pageTitle" value="common.queue.long.minutes"}
{url|assign:"currentUrl" page="sectionEditor"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="index" path="submissionsInReview"}">{translate key="common.queue.short.submissionsInReview"}</a></li>
	<li class="current"><a href="{url op="minutes"}">Upload Minutes</a></li>
	<li><a href="{url op="index" path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
</ul>
<br/>

{literal}
<script type="text/javascript">
<!--
	var meetingDate = "sige nga";
	var rtoDate = "{/literal}{$submission->getLocalizedStartDate()|date_format:$dateFormatShort}{literal}";
	
	$(document).ready(function() {
			meetingDate = $("#startDate").val();
			$("#startDateRow").hide();
			$("#decision").change(function (){
				$("#decision option:selected").each( function () {
					var selectVal = $(this).val();
					if(selectVal == '1') {
						$("#startDateRow").show();					
					}
					else {
						$("#startDateRow").hide();
					}
				});		
			});
			$("#useRtoDate").click(function(){				
				$('#useRtoDate').is(':checked') ? $("#startDate").val(rtoDate) : $("#startDate").val(meetingDate);
				$('#useRtoDate').is(':checked') ? $("#useRtoDate").val("1") : $("#useRtoDate").val("0");
			});
	});
-->
</script>
{/literal}
<div class="separator"></div>
<br>
{include file="common/formErrors.tpl"}
<div class="separator"></div>
<div id="submissions">
<form method="post" action="{url op="submitInitialReview"}">
	<input type="hidden" name="meetingId" value="{$meeting->getId()}" />
	<input type="hidden" name="articleId" value="{$submission->getId()}" />
	<input type="hidden" name="lastDecisionId" value="{$lastDecision.editDecisionId}" />
	<input type="hidden" name="resubmitCount" value="{$lastDecision.resubmitCount}" />
<h4>Create Initial Review For Proposal {$submission->getLocalizedWhoId()}</h4>
<br/>	
	<table class="listing" width="100%">
		<tr>
			<td class="label" width="10%">Protocol Title</td>
			<td class="value">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</td>
		</tr>
		<tr>
			<td class="label" width="10%">WHO ID</td>
			<td class="value">{$submission->getLocalizedWhoId()}</td>
		</tr>
		<tr>
			<td class="label" width="10%">Principal Investigator</td>
			<td class="value">{$submission->getAuthorString()|strip_unsafe_html|truncate:40:"..."}</td>
		</tr>
		<tr>
			<td width="10%">Protocol Summary<br/><br/></td>
			<td class="value">					
				{foreach from=$submission->getSuppFiles() item=suppFile}
					{if $suppFile->getType() == 'Summary'}
							Supplementary File: {$suppFile->getSuppFileTitle()} <!-- OK Siguro kung may link sa files -->
					{/if}														
				{/foreach}
			<br/><br/>
			</td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading" valign="bottom">
			<td width="10%" colspan="6"><br/>{translate key="editor.minutes.initialReviewForm.discussion"}</td>			
		</tr>
		<tr>
			<td width="10%">{fieldLabel name="generalDiscussion" required="true" key="editor.minutes.initialReviewForm.generalDiscussion"}</td>
			<td class="value"><textarea name="generalDiscussion" id="generalDiscussion" class="textArea" rows="10" cols="40" ></textarea></td>
		</tr>		
		<tr>
			<td width="10%">{fieldLabel name="specificDiscussion" required="true" key="editor.minutes.initialReviewForm.specificDiscussion"}</td>
			<td class="value"><textarea name="specificDiscussion" id="specificDiscussion" class="textArea" rows="10" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">{fieldLabel name="scientificDesign" required="true" key="editor.minutes.initialReviewForm.scientificDesign"}</td>
			<td class="value"><textarea name="scientificDesign" id="scientificDesign" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>

		{if $submission->getLocalizedProposalType() == "CWHS" || $submission->getLocalizedProposalType() == "PWHS"}
					<tr>
						<td width="10%">{fieldLabel name="subjectSelection" required="true" key="editor.minutes.initialReviewForm.subjectSelection"}</td>
						<td class="value"><textarea name="subjectSelection" id="subjectSelection" class="textArea" rows="5" cols="40" ></textarea><br/><br/></td>
					</tr>
					<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
					<tr class="heading">
						<td colspan="6"><br/>{fieldLabel name="levelOfRisk" required="true" key="editor.minutes.initialReviewForm.levelOfRisk"}</td>
					</tr>
					<tr>
						<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="1" align="right"/></td>
						<td class="value" colspan="30">{fieldLabel key="editor.minutes.initialReviewForm.levelOfRisk.option1"}</td>
					</tr>
					<tr>
						<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="2"/></td>
						<td class="value" colspan="30">{fieldLabel key="editor.minutes.initialReviewForm.levelOfRisk.option2"}</td>
					</tr>
					<tr>
						<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="3"/><br/><br/></td>
						<td class="value" colspan="30">{fieldLabel key="editor.minutes.initialReviewForm.levelOfRisk.option3"}<br/><br/></td>
					</tr>
					<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
					<tr class="heading">
						<td class="value" colspan="6"><br/>{fieldLabel name="benefitCategory" required="true" key="editor.minutes.initialReviewForm.benefitCategory"}</td>
					</tr>
					<tr>
						<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/></td>
						<td class="value" colspan="30">{translate key="editor.minutes.initialReviewForm.benefitCategory.option1"}</td>
					</tr>
					<tr>
						<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/></td>
						<td class="value" colspan="30">{translate key="editor.minutes.initialReviewForm.benefitCategory.option2"}</td>
					</tr>
					<tr>
						<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/><br/><br/></td>
						<td class="value" colspan="30">{translate key="editor.minutes.initialReviewForm.benefitCategory.option3"}<br/><br/></td>
					</tr>
					<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
					<tr>
						<td width="10%"><br/>{fieldLabel name="additionalSafeguards" required="true" key="editor.minutes.initialReviewForm.additionalSafeguards"}Additional Safeguards for Vulnerable Subjects</td>
						<td class="value"><br/><textarea name="additionalSafeguards" id="additionalSafeguards" class="textArea" rows="5" cols="40"></textarea></td>
					</tr>
					<tr>
						<td width="10%">{fieldLabel name="minimization" required="true" key="editor.minutes.initialReviewForm.minimizationOfRisk"}Minimization of Risks to Subjects</td>
						<td class="value"><textarea name="minimization" id="minimization" class="textArea" rows="5" cols="40"></textarea></td>
					</tr>
					<tr>
						<td width="10%">{fieldLabel name="confidentiality" required="true" key="editor.minutes.initialReviewForm.confidentiality"}</td>
						<td class="value"><textarea name="confidentiality" id="confidentiality" class="textArea" rows="5" cols="40"></textarea></td>
					</tr>
					<tr>
						<td width="10%">{fieldLabel name="consentDocument" required="true" key="editor.minutes.initialReviewForm.consentDocument"}</td>
						<td><textarea name="consentDocument" id="consentDocument" class="textArea" rows="5" cols="40"></textarea></td>
					</tr>
					<tr>
						<td width="10%">{fieldLabel name="additionalConsiderations" required="true" key="editor.minutes.initialReviewForm.additionalConsiderations"}<br/><br/></td>
						<td class="value"><textarea name="additionalConsiderations" id="additionalConsiderations" class="textArea" rows="5" cols="40"></textarea>
							<input type="checkbox" name="additionalConsiderationsNA" id="additionalConsiderationsNA" value="1" /><label for="additionalConsiderationsNA">Does not apply</label>
							<br/><br/>
						</td>
					</tr>
		{/if}
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">{translate key="editor.minutes.initialReviewForm.stipulations"}</td>
		</tr>
		<tr>
			<td class="label" width="10%" align="right">{fieldLabel name="numOfStipulations" required="true" key="editor.minutes.initialReviewForm.numOfStipulations"}<br/><br/></td>
			<td><textarea name="numOfStipulations" id="numOfStipulations" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		<tr class="heading">
			<td width="10%">{translate key="editor.minutes.initialReviewForm.recommendations"}</td>
		</tr>
		<tr>
			<td class="label" width="10%" align="right">{fieldLabel name="numOfRecommendations" required="true" key="editor.minutes.initialReviewForm.numOfRecommendation"}<br/><br/></td>
			<td><textarea name="numOfRecommendations" id="numOfRecommendations" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">{translate key="editor.minutes.initialReviewForm.IRBDecision"}</td>				
		</tr>
		<tr>
			<td class="label" width="20%" align="right">{fieldLabel name="decision" required="true" key="editor.minutes.initialReviewForm.decision"}</td>
			<td width="80%" class="value">
					<select name="decision" id="decision" size="1" class="selectMenu">
						{html_options_translate options=$submission->getEditorDecisionOptions()}
					</select>						
					<input type="checkbox" name="unanimous" id="unanimous" value="1" /><label for="unanimous">Decision is unanimous</label>											
			</td>			
		</tr>
		<tr id="startDateRow">
			<td class="label" align="right">{fieldLabel name="startDate" required="true" key="editor.minutes.initialReviewForm.startDate"}<br/><br/></td>
			<td width="80%" class="value">
				<input type="text" name="startDate" id="startDate" size="17" class="textField" value="{$meeting->getDate()|date_format:$dateFormatShort}">
				<input type="checkbox" name="useRTODate" id="useRTODate"/><label for="useRTODate">{translate key="editor.minutes.initialReviewForm.useRTODate"}</label>
				<br/><br/>
			</td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">{translate key="editor.minutes.initialReviewForm.IRBVotes"}</td>				
		</tr>
		<tr>
			<td class="label" align="right">{fieldLabel name="votesApproved" required="true" key="editor.minutes.initialReviewForm.votesApproved"}</td>
			<td class="value"><input type="text" name="votesApproved" id="votesApproved" size="5" class="textField"/></td>			
		</tr>
		<tr>
			<td class="label" align="right">{fieldLabel name="votesNotApproved" required="true" key="editor.minutes.initialReviewForm.votesNotApproved"}</td>
			<td class="value"><input type="text" name="votesNotApproved" id="votesNotApproved" size="5" class="textField"/></td>			
		</tr>
		<tr>
			<td class="label" align="right">{fieldLabel name="votesAbstained" required="true" key="editor.minutes.initialReviewForm.votesAbstained"}</td>
			<td class="value"><input type="text" name="votesAbstained" id="votesAbstained" size="5" class="textField"/></td>			
		</tr>
		<tr>
			<td width="10%" class="label">{fieldLabel name="minorityReasons" required="true" key="editor.minutes.initialReviewForm.minorityReasons"}</td>
			<td class="value"><textarea name="minorityReasons" id="minorityReasons" class="textArea" rows="5" cols="30"></textarea></td>
		</tr>
		<tr>
			<td>* Required fields</td>
		</tr>							
	</table>
	<p><div class="separator"></div></p><br/>
  
 	<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="minutes.confirm.submitInitialReview"}')" name="submitInitialReview" value="Submit Initial Review"  class="button" />
 	&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="selectInitialReview" path=$meeting->getId()}">Back to selection</a>
 	</form>
</div>
