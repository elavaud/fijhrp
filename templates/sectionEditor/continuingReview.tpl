{literal}
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$(".cr_pi_label").hide();
		$(".cr_summary_label").hide();
		$("#cr_title").change(function (){
			$("#cr_title option:selected").each( function () {
				$(".cr_pi_label").hide();
				$(".cr_summary_label").hide();
				var selectVal = $(this).val();
				if(selectVal == 'none') {
					$("#cr_select_title_pi").show();
					$("#cr_select_title_summary_file").show();
				}
				else {
					$("#cr_select_title_pi").hide();
					$("#cr_select_title_summary_file").hide();
					$("#cr_principalInvestigator_"+selectVal).show();
					$("#cr_protocolSummary_"+selectVal).show();
				}
			});		
		});		
	});
//-->
</script>
{/literal}

<h4>Create Continuing Review For Selected Proposal</h4>	
	<table class="data" width="100%">
		<tr>
			<td class="label" width="10%">Protocol Title</td>
			<td class="value">			
				<select name="cr_title" id="cr_title" class="selectMenu protocolTitle">
					<option value="none">Choose One</option>
					{foreach from=$submissions item=submission}
						<option value="{$submission->getArticleId()}">{$submission->getLocalizedWhoId()}: {$submission->getLocalizedTitle()|strip_unsafe_html}</option>						
					{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<td class="label" width="10%">Principal Investigator</td>
			<td class="value">
				<label id="cr_select_title_pi">Please select a proposal first.</label>
				{foreach from=$submissions item=submission}
						<label id="cr_principalInvestigator_{$submission->getArticleId()}" class="cr_pi_label">{$submission->getAuthorString()|strip_unsafe_html|truncate:40:"..."}</label>						
				{/foreach}				
			</td>
		</tr>
		<tr>
			<td width="10%">Protocol Summary</td>
			<td class="value">
				<label id="cr_select_title_summary_file">Please select a proposal first.</label>
				{foreach from=$submissions item=submission}
						<label id="cr_protocolSummary_{$submission->getArticleId()}" class="cr_summary_label">
							{foreach from=$submission->getSuppFiles() item=suppFile}
								{if $suppFile->getType() == 'Summary'}
									Supplementary File: {$suppFile->getSuppFileTitle()}
								{/if}														
							{/foreach}
						</label>
				{/foreach}
			</td>
		</tr>
		<tr class="heading" valign="bottom">
			<td width="10%" colspan="6">(a) Discussion</td>			
		</tr>
		<tr>
			<td width="10%">General Discussion</td>
			<td class="value"><textarea name="cr_generalDiscussion" id="cr_generalDiscussion" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr class="heading" valign="bottom">
			<td width="10%" colspan="6">SPECIFIC DISCUSSIONS</td>
		</tr>
		<tr>
			<td width="10%">Scientific design (discuss and note that institute pre-scientific review has been done)</td>
			<td class="value"><textarea name="cr_scientificDesign" id="cr_scientificDesign" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">Subject selection (discuss populations to be studied & recruitment)
			<td class="value"><textarea name="cr_subjectSelection" id="cr_subjectSelection" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr class="heading">
			<td colspan="6">LEVEL OF RISK</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="cr_levelOfRisk" id="cr_levelOfRisk" value="1"/></td>
			<td class="value" colspan="30">The research involves no more than minimal risk to subject.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="cr_levelOfRisk" id="cr_levelOfRisk" value="2"/></td>
			<td class="value" colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents more than a minor increase over
minimal risk.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="cr_levelOfRisk" id="cr_levelOfRisk" value="3"/></td>
			<td class="value" colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents a minor increase over minimal risk.</td>
		</tr>
		<tr class="heading">
			<td class="value" colspan="6">BENEFIT CATEGORY</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="cr_benefitCategory" id="cr_benefitCategory" value="1"/></td>
			<td class="value" colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge about the participants’ disorder
or condition.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="cr_benefitCategory" id="cr_benefitCategory" value="1"/></td>
			<td class="value" colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge to further society’s understanding or the disorder or condition under study.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="cr_benefitCategory" id="cr_benefitCategory" value="1"/></td>
			<td class="value" colspan="30">The research involves the prospect of direct benefit to individual participants.</td>
		</tr>
		<tr>
			<td width="10%">Additional Safeguards for Vulnerable Subjects</td>
			<td class="value"><textarea name="cr_additionalSafeguards" id="cr_additionalSafeguards" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Minimization of Risks to Subjects</td>
			<td class="value"><textarea name="cr_minimization" id="cr_minimization" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Privacy and Confidentiality</td>
			<td class="value"><textarea name="cr_confidentiality" id="cr_confidentiality" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Consent Document (document that all required elements are present)</td>
			<td><textarea name="cr_consentDocument" id="cr_consentDocument" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Additional Considerations (e.g. multi-center research; collaborative research; nested study. State if these considerations do not apply)</td>
			<td class="value"><textarea name="cr_additionalConsiderations" id="cr_additionalConsiderations" class="textArea" rows="5" cols="40"></textarea>
				<input type="checkbox" name="cr_additionalConsiderationsNA" id="cr_additionalConsiderationsNA" value="1" /><label for="additionalConsiderationsNA">Does not apply</label>
			</td>
		</tr>
		<tr>
			<td width="10%">(b) Stipulations (number of stipulations)</td>
			<td class="value"><input type="text" name="cr_stipulations" id="cr_stipulations" size="5"  /></td>
		</tr>
		<tr>
			<td width="10%">(c) Recommendations (number of recommendations)</td>
			<td class="value"><input type="text" name="cr_recommendations" id="cr_recommendations" size="5" /></td>
		</tr>
		<tr></tr>
		<tr class="heading">
			<td colspan="6">(d) IRB DECISION </td>				
		</tr>
		<tr>
			<td class="label" width="20%">Select Decision</td>
			<td width="80%" class="value">
					<select name="cr_decision" id="cr_decision" size="1" class="selectMenu">
						{html_options_translate options=$editorDecisionOptions}
					</select>						
					<input type="checkbox" name="cr_unanimous" id="cr_unanimous" value="1" /><label for="unanimous">Decision is unanimous</label>								
			</td>			
		</tr>
		<tr></tr>
		<tr class="heading">
			<td colspan="6"> IRB VOTES </td>				
		</tr>
		<tr>
			<td class="label">Number of approvals</td>
			<td class="value"><input type="text" name="cr_votesApproved" id="cr_votesApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Number of disapprovals</td>
			<td class="value"><input type="text" name="cr_votesNotApproved" id="cr_votesNotApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Abstain</td>
			<td class="value"><input type="text" name="cr_votesAbstain" id="cr_votesAbstain" size="5" /></td>			
		</tr>
		<tr>
			<td width="10%" class="label">Reasons for Minority Options</td>
			<td class="value"><textarea name="cr_minorityReasons" id="cr_minorityReasons" class="textArea" rows="5" cols="30"></textarea></td>
		</tr>
		<tr>
			<td>* Required fields</td>
		</tr>					
	</table>