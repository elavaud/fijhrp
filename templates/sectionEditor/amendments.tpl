{literal}
<script type="text/javascript">
<!--
	var amendmentCount = 0;
	$(document).ready(function() {
		$("#amendmentOkay").hide();
		$("#amendmentUnanimous").hide();
		$("#amendmentRequiredFields").hide();
		$(".submitAmendment").click(function (){
			$("#amendmentUnanimous").hide();
			$("#amendmentRequiredFields").hide();
			$("#amendmentOkay").fadeIn(1000).fadeOut(500);
			//$("#amendment1").hide();
		});
	});
//-->
</script>
{/literal}

<div id="amendment1">
	{include file="sectionEditor/amendment.tpl"}
	<input type="button" name="submitAmendment" id="submitAmendment" class="button submitAmendment" value="Finalize Amendment" />	
</div>
<label id="amendmentOkay">Okay</label>
<label id="amendmentUnanimous">Please indicate if decision is unanimous. If not, indicate distribution of votes.</label>
<label id="amendmentRequiredFields">Please fill up all required fields.</label>

