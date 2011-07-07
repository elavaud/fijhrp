{literal}
<script type="text/javascript">
<!--
	var rereviewCount = 0;
	$(document).ready(function() {
		$("#rereviewOkay").hide();
		$("#rereviewUnanimous").hide();
		$("#rereviewRequiredFields").hide();
		$(".submitRereview").click(function (){
			$("#rereviewUnanimous").hide();
			$("#rereviewRequiredFields").hide();
			$("#rereviewOkay").fadeIn(1000).fadeOut(500);
			//$("#initialReview1").hide();
		});
	});
//-->
</script>
{/literal}

<div id="rereview1">
	{include file="sectionEditor/rereview.tpl"}
	<input type="button" name="submitInitialReview" id="submitInitialReview" class="button submitRereview" value="Finalize Re-review" />	
</div>
<label id="rereviewOkay">Okay</label>
<label id="rereviewUnanimous">Please indicate if decision is unanimous. If not, indicate distribution of votes.</label>
<label id="rereviewRequiredFields">Please fill up all required fields.</label>

