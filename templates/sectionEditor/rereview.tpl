<script type="text/javascript">{literal}
	$(document).ready(function() {
		$( "#re_dateApproved" ).datepicker();
		$(".re_pi_label").hide();
		$("#re_title").change(function (){
			$("#re_title option:selected").each( function () {
				$(".re_pi_label").hide();
				var selectVal = $(this).val();
				if(selectVal == 'none') {
					$("#re_select_title_pi").show();					
				}
				else {
					$("#re_select_title_pi").hide();
					$("#re_principalInvestigator_"+selectVal).show();
				}
			});		
		});	
	});			
{/literal}</script>


<h4>Continuing Review or Rereview of Proposal</h4>
<table class="data">
		<tr>
			<td width="10%" class="label">Protocol Title</td>
			<td class="value">
				<select name="re_title" id="re_title" class="selectMenu protocolTitle">
					<option value="none">Choose One</option>
					{foreach from=$submissions item=submission}
						<option value="{$submission.articleId}">{$submission.submissionTitle|strip_unsafe_html}</option>						
					{/foreach}
				</select>
			</td>
		</tr>
		<tr>
			<td width="10%" class="label">Principal Investigator</td>
			<td>
				<label id="re_select_title_pi">Please select a proposal first.</label>
				{foreach from=$submissions item=submission}
						<label id="re_principalInvestigator_{$submission.articleId}" class="re_pi_label">{$submission.authorName|strip_unsafe_html|truncate:40:"..."}</label>						
				{/foreach}				
			</td>
		</tr>
		<tr>
			<td class="label">Title of Expedited Action</td>
			<td class="value"><input type="text" name="re_titleExpedited" id="re_titleExpedited" size="36" class="text" /></td>
		</tr>
		<tr>
			<td class="label">Type of Expedited Action</td>
			<td class="value">
				<select id="re_typeExpedited" name="re_typeExpedited" class="selectMenu">
					{html_options_translate options=$editorDecisionOptions selected=1}
				</select>
			</td>
		</tr>
		<tr>
			<td width="5%" class="label">Date Approved</td>
		 	<td width="50%" class="value"><input type="text" name="re_dateApproved" id="re_dateApproved" size="10"/></td>
	 	</tr>
	 	<tr>
	 		<td width="5%" class="label">Description of Expedited Action</td>
	 		<td width="50%" class="value"><textarea name="re_expeditedDescription" id="re_expeditedDescription" class="textArea" rows="5" cols="40"></textarea></td>
	 	</tr>
</table>