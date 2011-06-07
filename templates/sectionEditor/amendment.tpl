{literal}
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$(".am_pi_label").hide();
		$("#am_title").change(function (){
			$("#am_title option:selected").each( function () {
				$(".am_pi_label").hide();
				var selectVal = $(this).val();
				if(selectVal == 'none') {
					$("#am_select_title_pi").show();					
				}
				else {
					$("#am_select_title_pi").hide();
					$("#am_principalInvestigator_"+selectVal).show();
				}
			});		
		});	
	});
//-->
</script>
{/literal}

<h4>Amendments For Selected Proposal</h4>	
	<table class="data" width="100%">
		<tr>
			<td width="10%">Protocol Title</td>
			<td>
				<select name="am_title" id="am_title" class="selectMenu protocolTitle">
					<option value="none">Choose One</option>
					{foreach from=$submissions item=submission}
						<option value="{$submission.articleId}">{$submission.submissionTitle|strip_unsafe_html}</option>						
					{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<td width="10%">Principal Investigator</td>
			<td>
				<label id="am_select_title_pi">Please select a proposal first.</label>
				{foreach from=$submissions item=submission}
						<label id="am_principalInvestigator_{$submission.articleId}" class="am_pi_label">{$submission.authorName|strip_unsafe_html|truncate:40:"..."}</label>						
				{/foreach}				
			</td>
		</tr>
		<tr>
			<td width="10%">Protocol Summary</td>
			<td><textarea name="am_protocolSummary" id="am_protocolSummary" class="textArea" rows="5" cols=40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">(a) Discussion</td>
			<td><textarea name="am_discussion" id="am_discussion" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">General Discussion</td>
			<td><textarea name="am_generalDiscussion" id="am_generalDiscussion" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr class="heading">
			<td colspan="6">LEVEL OF RISK</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="am_levelOfRisk" id="am_levelOfRisk" value="1"/></td>
			<td colspan="30">The research involves no more than minimal risk to subject.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="am_levelOfRisk" id="am_levelOfRisk" value="2"/></td>
			<td colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents more than a minor increase over
minimal risk.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="am_levelOfRisk" id="am_levelOfRisk" value="3"/></td>
			<td colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents a minor increase over minimal risk.</td>
		</tr>
		<tr class="heading">
			<td colspan="6">BENEFIT CATEGORY</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="am_benefitCategory" id="am_benefitCategory" value="1"/></td>
			<td colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge about the participants’ disorder
or condition.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="am_benefitCategory" id="am_benefitCategory" value="1"/></td>
			<td colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge to further society’s understanding or the disorder or condition under study.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="am_benefitCategory" id="am_benefitCategory" value="1"/></td>
			<td colspan="30">The research involves the prospect of direct benefit to individual participants.</td>
		</tr>
		<tr>
			<td width="10%">Stipulations (number of stipulations)</td>
			<td><input type="text" name="am_stipulations" id="am_stipulations" size="5"  /></td>
		</tr>
		<tr>
			<td width="10%">Recommendations (number of recommendations)</td>
			<td><input type="text" name="am_recommendations" id="am_recommendations" size="5" /></td>
		</tr>
		<tr></tr>
		<tr class="heading">
			<td colspan="6"> IRB DECISION </td>				
		</tr>
		<tr>
			<td class="label" width="20%">Select Decision</td>
			<td width="80%" class="value">
					<select name="am_decision" id="am_decision" size="1" class="selectMenu">
						{html_options_translate options=$editorDecisionOptions selected=1}
					</select>						
					<input type="checkbox" name="am_unanimous" id="am_unanimous" value="1" /><label for="unanimous">Decision is unanimous</label>								
			</td>			
		</tr>
		<tr></tr>
		<tr class="heading">
			<td colspan="6"> IRB VOTES </td>				
		</tr>
		<tr>
			<td class="label">Number of approvals</td>
			<td class="value"><input type="text" name="am_votesApproved" id="am_votesApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Number of disapprovals</td>
			<td class="value"><input type="text" name="am_votesNotApproved" id="am_votesNotApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Abstain</td>
			<td class="value"><input type="text" name="am_votesAbstain" id="am_votesAbstain" size="5" /></td>			
		</tr>
		<tr>
			<td width="10%" class="label">Reasons for Minority Options</td>
			<td class="value"><textarea name="am_minorityReasons" id="am_minorityReasons" class="textArea" rows="5" cols="30"></textarea></td>
		</tr>
		<tr>
			<td>* Required fields</td>
		</tr>					
	</table>