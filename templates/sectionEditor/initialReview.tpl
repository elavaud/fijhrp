{literal}
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$(".ir_pi_label").hide();
		$(".ir_summary_label").hide();
		$("#ir_title").change(function (){
			$("#ir_title option:selected").each( function () {
				$(".ir_pi_label").hide();
				$(".ir_summary_label").hide();
				var selectVal = $(this).val();
				if(selectVal == 'none') {
					$("#ir_select_title_pi").show();
					$("#ir_select_title_summary_file").show();
				}
				else {
					$("#ir_select_title_pi").hide();
					$("#ir_select_title_summary_file").hide();
					$("#ir_principalInvestigator_"+selectVal).show();
					$("#ir_protocolSummary_"+selectVal).show();
				}
			});		
		});		
	});
//-->
</script>
{/literal}

<h4>Create Initial Review For Selected Proposal</h4>	
	<table class="data" width="100%">
		<tr>
			<td class="label" width="10%">Protocol Title</td>
			<td class="value">			
				<select name="ir_title" id="ir_title" class="selectMenu protocolTitle">
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
				<label id="ir_select_title_pi">Please select a proposal first.</label>
				{foreach from=$submissions item=submission}
						<label id="ir_principalInvestigator_{$submission->getArticleId()}" class="ir_pi_label">{$submission->getAuthorString()|strip_unsafe_html|truncate:40:"..."}</label>						
				{/foreach}				
			</td>
		</tr>
		<tr>
			<td width="10%">Protocol Summary</td>
			<td class="value">
				<label id="ir_select_title_summary_file">Please select a proposal first.</label>
				{foreach from=$submissions item=submission}
						<label id="ir_protocolSummary_{$submission->getArticleId()}" class="ir_summary_label">
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
			<td class="value"><textarea name="ir_generalDiscussion" id="ir_generalDiscussion" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr class="heading" valign="bottom">
			<td width="10%" colspan="6">SPECIFIC DISCUSSIONS</td>
		</tr>
		<tr>
			<td width="10%">Scientific design (discuss and note that institute pre-scientific review has been done)</td>
			<td class="value"><textarea name="ir_scientificDesign" id="ir_scientificDesign" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">Subject selection (discuss populations to be studied & recruitment)
			<td class="value"><textarea name="ir_subjectSelection" id="ir_subjectSelection" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr class="heading">
			<td colspan="6">LEVEL OF RISK</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="ir_levelOfRisk" id="ir_levelOfRisk" value="1"/></td>
			<td class="value" colspan="30">The research involves no more than minimal risk to subject.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="ir_levelOfRisk" id="ir_levelOfRisk" value="2"/></td>
			<td class="value" colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents more than a minor increase over
minimal risk.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="ir_levelOfRisk" id="ir_levelOfRisk" value="3"/></td>
			<td class="value" colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents a minor increase over minimal risk.</td>
		</tr>
		<tr class="heading">
			<td class="value" colspan="6">BENEFIT CATEGORY</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="ir_benefitCategory" id="ir_benefitCategory" value="1"/></td>
			<td class="value" colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge about the participants’ disorder
or condition.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="ir_benefitCategory" id="ir_benefitCategory" value="1"/></td>
			<td class="value" colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge to further society’s understanding or the disorder or condition under study.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="ir_benefitCategory" id="ir_benefitCategory" value="1"/></td>
			<td class="value" colspan="30">The research involves the prospect of direct benefit to individual participants.</td>
		</tr>
		<tr>
			<td width="10%">Additional Safeguards for Vulnerable Subjects</td>
			<td class="value"><textarea name="ir_additionalSafeguards" id="ir_additionalSafeguards" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Minimization of Risks to Subjects</td>
			<td class="value"><textarea name="ir_minimization" id="ir_minimization" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Privacy and Confidentiality</td>
			<td class="value"><textarea name="ir_confidentiality" id="ir_confidentiality" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Consent Document (document that all required elements are present)</td>
			<td><textarea name="ir_consentDocument" id="ir_consentDocument" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Additional Considerations (e.g. multi-center research; collaborative research; nested study. State if these considerations do not apply)</td>
			<td class="value"><textarea name="ir_additionalConsiderations" id="ir_additionalConsiderations" class="textArea" rows="5" cols="40"></textarea>
				<input type="checkbox" name="ir_additionalConsiderationsNA" id="ir_additionalConsiderationsNA" value="1" /><label for="additionalConsiderationsNA">Does not apply</label>
			</td>
		</tr>
		<tr>
			<td width="10%">(b) Stipulations (number of stipulations)</td>
			<td class="value"><input type="text" name="ir_stipulations" id="ir_stipulations" size="5"  /></td>
		</tr>
		<tr>
			<td width="10%">(c) Recommendations (number of recommendations)</td>
			<td class="value"><input type="text" name="ir_recommendations" id="ir_recommendations" size="5" /></td>
		</tr>
		<tr></tr>
		<tr class="heading">
			<td colspan="6">(d) IRB DECISION </td>				
		</tr>
		<tr>
			<td class="label" width="20%">Select Decision</td>
			<td width="80%" class="value">
					<select name="ir_decision" id="ir_decision" size="1" class="selectMenu">
						{html_options_translate options=$editorDecisionOptions}
					</select>						
					<input type="checkbox" name="ir_unanimous" id="ir_unanimous" value="1" /><label for="unanimous">Decision is unanimous</label>								
			</td>			
		</tr>
		<tr></tr>
		<tr class="heading">
			<td colspan="6"> IRB VOTES </td>				
		</tr>
		<tr>
			<td class="label">Number of approvals</td>
			<td class="value"><input type="text" name="ir_votesApproved" id="ir_votesApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Number of disapprovals</td>
			<td class="value"><input type="text" name="ir_votesNotApproved" id="ir_votesNotApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Abstain</td>
			<td class="value"><input type="text" name="ir_votesAbstain" id="ir_votesAbstain" size="5" /></td>			
		</tr>
		<tr>
			<td width="10%" class="label">Reasons for Minority Options</td>
			<td class="value"><textarea name="ir_minorityReasons" id="ir_minorityReasons" class="textArea" rows="5" cols="30"></textarea></td>
		</tr>
		<tr>
			<td>* Required fields</td>
		</tr>					
	</table>