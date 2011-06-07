{literal}
<script type="text/javascript">
<!--
	var initReviewCount = 0;
	$(document).ready(function() {
		$("#initReviewOkay").hide();
		$("#initReviewUnanimous").hide();
		$("#initReviewRequiredFields").hide();
		$(".submitInitReview").click(function (){
			$("#initReviewUnanimous").hide();
			$("#initReviewRequiredFields").hide();
			$("#initReviewOkay").fadeIn(1000).fadeOut(500);
			//$("#initialReview1").hide();
		});
	});
//-->
</script>
{/literal}

<div id="initialReview1">
	{include file="sectionEditor/initialReview.tpl"}
	<input type="button" name="submitInitialReview" id="submitInitialReview" class="button submitInitReview" value="Finalize Initial Review" />	
</div>
<label id="initReviewOkay">Okay</label>
<label id="initReviewUnanimous">Please indicate if decision is unanimous. If not, indicate distribution of votes.</label>
<label id="initReviewRequiredFields">Please fill up all required fields.</label>

