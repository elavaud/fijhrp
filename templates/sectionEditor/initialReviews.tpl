{literal}
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$("#initial_review_form_div").hide();
		$("#initial_review_comments").hide();
		//$("#ir_title").change(function (){
		$("#select_ir_button").click(function (){		
			$("#ir_title option:selected").each( function () {
				$("#initial_review_form_div").show();				
				$(".ir_pi_label").hide();
				$(".ir_summary_label").hide();
				$(".ir_title_label").hide();
				var selectVal = $(this).val();
				if(selectVal == 'none') {
					$("#initial_review_form_div").hide();
					$("#ir_select_title_pi").show();
					$("#ir_select_title_summary_file").show();
					$("#ir_select_title").show();
				}
				else {
					$("#ir_select_title_pi").hide();
					$("#ir_select_title_summary_file").hide();
					$("#ir_select_title").hide();
					$("#ir_principalInvestigator_"+selectVal).show();
					$("#ir_protocolSummary_"+selectVal).show();
					$("#ir_protocolTitle_"+selectVal).show();
				}
			});		
		});
		$(".submit_init_review_class").click(function (){
			
			$.ajax({
				type: "POST",
				url: "index.php/sectionEditor/submitInitialReview",
				data: "type=initialReview&",
				async: false,
				success: function(msg){
					if(msg == 'John Boston') 
					     alert( "Data Saved: " + msg );
					else alert ("Not saved");
					$("#initial_review_form_div").hide();
					$("#initial_review_comments").show().fadeOut(5000);
				}
			});			
		});
	});
//-->
</script>
{/literal}
{if $submissions == null }
	No proposals are assigned for initial ERC Review.
{else}
	<div id="select_initial_review_div">
		<table class="data">
			<tr>
				<td class="label">Proposals Assigned for Initial ERC Review</td>
				<td class="value">
					<select name="ir_title" id="ir_title" class="selectMenu protocolTitle">
						<option value="none">Choose One</option>
						{foreach from=$submissions item=submission}
							<option value="{$submission->getArticleId()}">{$submission->getLocalizedWhoId()}: {$submission->getLocalizedTitle()|strip_unsafe_html}</option>						
						{/foreach}
					</select>
					<input type="button" class="button" id="select_ir_button" name="select_ir_button" value="Select Proposal"/>
					<label id="initial_review_comments">Saved</label>
				</td>			
			</tr>
		</table>
	</div>
{/if}
<div id="initial_review_form_div">
	{include file="sectionEditor/initialReview.tpl"}	
	<input type="button" name="submitInitialReview" id="submit_initial_review" class="button submit_init_review_class" value="Submit Initial Review" />		
</div>