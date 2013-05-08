{include file="sectionEditor/minutes/menu.tpl"}
{literal}
<script type="text/javascript">
	$(document).ready(function() {			
		$("#approvalDateRow").hide();
		$("#approvalDate").datepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd'});
		$("#decision").change(
			function() {
				var decision = $("#decision option:selected").val();
				if(decision == 1) {
					$("#approvalDateRow").show();
				} else {
					$("#approvalDateRow").hide();
				}
			}
		);		
	});
	
</script>
{/literal}
<div id="submissions">
<form method="post" action="{url op="generateContinuingReviewDecision" path=$meeting->getId()|to_array:$submission->getId()}">
	<input type="hidden" name="articleId" value="{$submission->getId()}" />
	<input type="hidden" name="lastDecisionId" value="{$lastDecision.sectionDecisionId}" />
	<input type="hidden" name="resubmitCount" value="{$submission->getResubmitCount()}" />
<h4>Final Decision for Proposal &nbsp;{$submission->getLocalizedProposalId()}</h4>
<br/>	
	<table class="data" width="100%">
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.protocolTitle"}</td>
			<td class="value" width="80%">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</td>
		</tr>
	</table>
	<br/>
	<table class="data" width="100%" id="decisionTable">		
		<tr class="heading">
			<td colspan="6">{translate key="editor.minutes.decision"}</td>
		</tr>
		<tr>
			<td class="label" width="20%" align="right">{fieldLabel name="decision" required="true" key="editor.article.selectDecision"}</td>
			<td width="80%" class="value">
					<select name="decision" id="decision" size="1" class="selectMenu">
						{html_options_translate options=$submission->getEditorDecisionOptions() selected=$decision}
					</select>																						
			</td>			
		</tr>
		<tr id="approvalDateRow">
			<td class="label">{translate key="editor.article.setApprovalDate"}</td>
			<td class="value">
				<input type="text" name="approvalDate" id="approvalDate" class="textField" size="19" />
			</td>
		</tr>
		<tr>
			<td class="label" width="20%" align="right">{fieldLabel name="unanimous" required="true" key="editor.minutes.unanimous"}</td>
			<td width="80%" class="value">
				<input type="radio" class="unanimous" name="unanimous" id="unanimousYes" value="Yes" {if $unanimous=="Yes"}checked="checked"{/if}/><label for="unanimousYes">Yes</label>
				<input type="radio" class="unanimous" name="unanimous" id="unanimousNo" value="No" {if $unanimous=="No"}checked="checked"{/if}/><label for="unanimousNo">No</label>
			</td>
		</tr>		
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">{fieldLabel name="votes" key="editor.minutes.votes"}</td>				
		</tr>
		<tr >
			<td class="label" align="right">{fieldLabel name="votesApprove" key="editor.minutes.approveCount"}</td>
			<td class="value"><input type="text" name="votesApprove" size="17" class="textField" value="{$votesApprove}"/></td>
		</tr>
		<tr >
			<td class="label" align="right">{fieldLabel name="votesNotApprove" key="editor.minutes.notApproveCount"}</td>
			<td class="value"><input type="text" name="votesNotApprove" size="17" class="textField" value="{$votesNotApprove}"/></td>
		</tr>
		<tr >
			<td class="label" align="right">{fieldLabel name="votesAbstain" key="editor.minutes.abstainCount"}</td>
			<td class="value"><input type="text" name="votesAbstain" size="17" class="textField" value="{$votesAbstain}"/></td>
		</tr>
		<tr>
			<td width="20%" class="label">{fieldLabel name="minorityReason" key="editor.minutes.minorityReasons"}</td>
			<td class="value"><textarea name="minorityReason" class="textArea" rows="10" cols="40">{$minorityReason}</textarea></td>
		</tr>
		<tr>
			<td width="20%" class="label">{fieldLabel name="chairReview" key="editor.minutes.chairReview"}</td>
			<td class="value"><textarea name="chairReview" class="textArea" rows="10" cols="40" >{$chairReview}</textarea></td>
		</tr>
	</table>	
  	<br/>
 	<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.minutes.confirmContinuingReview"}')" name="submitContinuingReview" value="Submit Continuing Review"  class="button defaultButton" />
 	<input type="button" class="button" onclick="document.location.href='{url op="selectContinuingReview" path=$meeting->getId()}'" value="{translate key="common.back"}" />
 	</form>
</div>
