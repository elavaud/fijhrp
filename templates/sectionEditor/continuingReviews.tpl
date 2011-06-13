{literal}
<script type="text/javascript">
<!--
	var continuingReviewCount = 0;
	$(document).ready(function() {
		$("#continuingReviewOkay").hide();
		$("#continuingReviewUnanimous").hide();
		$("#continuingReviewRequiredFields").hide();
		$(".submitContinuingReview").click(function (){
			$("#continuingReviewUnanimous").hide();
			$("#continuingReviewRequiredFields").hide();
			$("#continuingReviewOkay").fadeIn(1000).fadeOut(500);
			//$("#continuingReview1").hide();
		});
	});
//-->
</script>
{/literal}

<div id="continuingReview1">
	{include file="sectionEditor/continuingReview.tpl"}
	<input type="button" name="submitContinuingReview" id="submitContinuingReview" class="button submitContinuingReview" value="Finalize Continuing Review" />	
</div>
<label id="continuingReviewOkay">Okay</label>
<label id="continuingReviewUnanimous">Please indicate if decision is unanimous. If not, indicate distribution of votes.</label>
<label id="continuingReviewRequiredFields">Please fill up all required fields.</label>

