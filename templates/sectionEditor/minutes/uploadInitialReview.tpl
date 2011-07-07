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
			<td class="label" width="10%">Principal Investigator</td>
			<td class="value">{$submission->getAuthorString()|strip_unsafe_html|truncate:40:"..."}</td>
		</tr>
		<tr>
			<td width="10%">Protocol Summary<br/><br/></td>
			<td class="value">					
				{foreach from=$submission->getSuppFiles() item=suppFile}
					{if $suppFile->getType() == 'Summary'}
							Supplementary File: {$suppFile->getSuppFileTitle()}
					{/if}														
				{/foreach}
			<br/><br/>
			</td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading" valign="bottom">
			<td width="10%" colspan="6"><br/>(a) DISCUSSION</td>			
		</tr>
		<tr>
			<td width="10%">General Discussion</td>
			<td class="value"><textarea name="generalDiscussion" id="generalDiscussion" class="textArea" rows="10" cols="40" ></textarea></td>
		</tr>		
		<tr>
			<td width="10%">Specific Discussion</td>
			<td class="value"><textarea name="specificDiscussion" id="specificDiscussion" class="textArea" rows="10" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">Scientific design (discuss and note that institute pre-scientific review has been done)</td>
			<td class="value"><textarea name="scientificDesign" id="scientificDesign" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">Subject selection (discuss populations to be studied & recruitment)
			<td class="value"><textarea name="subjectSelection" id="subjectSelection" class="textArea" rows="5" cols="40" ></textarea><br/><br/></td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6"><br/>LEVEL OF RISK</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="1" align="right"/></td>
			<td class="value" colspan="30">The research involves no more than minimal risk to subject.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="2"/></td>
			<td class="value" colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents more than a minor increase over
minimal risk.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="3"/><br/><br/></td>
			<td class="value" colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents a minor increase over minimal risk.<br/><br/></td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td class="value" colspan="6"><br/>BENEFIT CATEGORY</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/></td>
			<td class="value" colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge about the participants’ disorder
or condition.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/></td>
			<td class="value" colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge to further society’s understanding or the disorder or condition under study.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/><br/><br/></td>
			<td class="value" colspan="30">The research involves the prospect of direct benefit to individual participants.<br/><br/></td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr>
			<td width="10%"><br/>Additional Safeguards for Vulnerable Subjects</td>
			<td class="value"><br/><textarea name="additionalSafeguards" id="additionalSafeguards" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Minimization of Risks to Subjects</td>
			<td class="value"><textarea name="minimization" id="minimization" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Privacy and Confidentiality</td>
			<td class="value"><textarea name="confidentiality" id="confidentiality" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Consent Document (document that all required elements are present)</td>
			<td><textarea name="consentDocument" id="consentDocument" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Additional Considerations (e.g. multi-center research; collaborative research; nested study. State if these considerations do not apply)<br/><br/></td>
			<td class="value"><textarea name="additionalConsiderations" id="additionalConsiderations" class="textArea" rows="5" cols="40"></textarea>
				<input type="checkbox" name="additionalConsiderationsNA" id="additionalConsiderationsNA" value="1" /><label for="additionalConsiderationsNA">Does not apply</label>
				<br/><br/>
			</td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">(b) STIPULATIONS</td>
		</tr>
		<tr>
			<td class="label" width="10%" align="right">No. of stipulations<br/><br/></td>
			<td class="value"><input type="text" name="stipulations" id="stipulations" size="5" class="textField"/><br/><br/></td>
		</tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		<tr class="heading">
			<td width="10%">(c) RECOMMENDATIONS</td>
		</tr>
		<tr>
			<td class="label" width="10%" align="right">No. of Recommendations<br/><br/></td>
			<td class="value"><input type="text" name="recommendations" id="recommendations" size="5" class="textField"/><br/><br/></td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">(d) IRB DECISION </td>				
		</tr>
		<tr>
			<td class="label" width="20%" align="right">Select Decision</td>
			<td width="80%" class="value">
					<select name="decision" id="decision" size="1" class="selectMenu">
						{html_options_translate options=$submission->getEditorDecisionOptions()}
					</select>						
					<input type="checkbox" name="unanimous" id="unanimous" value="1" /><label for="unanimous">Decision is unanimous</label>											
			</td>			
		</tr>
		<tr id="startDateRow">
			<td class="label" align="right">Start Date (if approved)<br/><br/></td>
			<td width="80%" class="value">
				<input type="text" name="startDate" id="startDate" size="17" class="textField" value="{$meeting->getDate()|date_format:$dateFormatShort}">
				<input type="checkbox" name="useRtoDate" id="useRtoDate"/><label for="useRtoDate">Use start date proposed by RTO</label>
				<br/><br/>
			</td>
		</tr>
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6"> IRB VOTES </td>				
		</tr>
		<tr>
			<td class="label" align="right">No. of approvals</td>
			<td class="value"><input type="text" name="votesApproved" id="votesApproved" size="5" class="textField"/></td>			
		</tr>
		<tr>
			<td class="label" align="right">No. of disapprovals</td>
			<td class="value"><input type="text" name="votesNotApproved" id="votesNotApproved" size="5" class="textField"/></td>			
		</tr>
		<tr>
			<td class="label" align="right">No. of abstain votes</td>
			<td class="value"><input type="text" name="votesAbstain" id="votesAbstain" size="5" class="textField"/></td>			
		</tr>
		<tr>
			<td width="10%" class="label">Reasons for Minority Options</td>
			<td class="value"><textarea name="minorityReasons" id="minorityReasons" class="textArea" rows="5" cols="30"></textarea></td>
		</tr>
		<tr>
			<td>* Required fields</td>
		</tr>							
	</table>
	<p><div class="separator"></div></p><br/>
  
 	<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="minutes.confirm.submitInitialReview"}')" name="submit" value="Submit Initial Review"  class="button" />
 	&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="selectInitialReview" path=$meeting->getId()}">Back to selection</a>
 	</form>
</div>
