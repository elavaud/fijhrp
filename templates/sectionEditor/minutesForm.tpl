{**
 * templates/sectionEditor/minutesStep1.tpl
 * Added by aglet
 * Last Update: 6/1/2011
 * Form for uploading of minutes of the meeting
 *
 *}

{** 
 TODO: jQuery does not work when jquery lib is not included
**}

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js"></script>

{literal}
<script type="text/javascript">
<!--
	$(document).ready(function() {
		$("#attendance").hide();
		$("#initialReviews").hide();
		$("#amendments").hide();
		$("#continuingReviews").hide();
		$("#rereviews").hide();
		$( "#showAttendance" ).click(
				function() {
					showHideDiv("#attendance", "#showAttendance", "Attendance");
				}
		);
		$( "#showAnnouncements" ).click(
				function () {
					showHideDiv("#announcements", "#showAnnouncements", "Announcements");
				}
		);
		$("#showInitialReviews").click (
				function () {
					showHideDiv("#initialReviews", "#showInitialReviews", "Initial Reviews");
				}
		);
		$("#showRereviews").click (
				function () {
					showHideDiv("#rereviews", "#showRereviews", "Continuing Reviews or Rereviews");
				}
		);
		$("#showContinuingReviews").click (
				function () {
					showHideDiv("#continuingReviews", "#showContinuingReviews", "Continuing Reviews");
				}
		);
		$("#showAmendments").click (
				function () {
					showHideDiv("#amendments", "#showAmendments", "Amendments");
				}
		);		
	});

	function showHideDiv(div, button, title) {
		var buttonStr = $(button).val();
		if( buttonStr == ("Show "+title)) {
			$(div).show();
			$(button).val("Hide " + title);				
		}
		else {
			$(div).hide();
			$(button).val("Show "+ title);
		}
	}
-->
</script>{/literal}

{include file="common/header.tpl"}

 <h4>WPRO-ERC Minutes</h4>
	 
 <form name="minutesStep1" id="minutesStep1" method="post" action="{url op="minutes"}">
 	
 	<div id="announcements">
 		{include file="sectionEditor/announcements.tpl"}
 	</div>
 	<input type="button" class="button" name="showAnnouncements" id="showAnnouncements" value="Hide Announcements" />
 	
	<p><div class="separator"></div></p>
	
	
	<div id="attendance">
		{include file="sectionEditor/attendance.tpl"}
	</div>
	<input type="button" class="button" name="showAttendance" id="showAttendance" value="Show Attendance" />
	
	<p><div class="separator"></div></p>
	
	<div id="initialReviews">
		{include file="sectionEditor/initialReviews.tpl"}
	</div>

	<input type="button" class="button" name="showInitialReviews" id="showInitialReviews" value="Show Initial Reviews" />&nbsp;
	 {************************
	 <p><div class="separator"></div></p>
	 
	<div id="rereviews">
		{include file="sectionEditor/rereviews.tpl"}
	</div>
	 <input type="button" class="button" name="showRereviews" id="showRereviews" value="Show Continuing Reviews or Rereviews" />&nbsp;
	
	<p><div class="separator"></div></p>
	
	<div id="continuingReviews">
		{include file="sectionEditor/continuingReviews.tpl"}
	</div>
	<input type="button" class="button" name="showContinuingReviews" id="showContinuingReviews" value="Show Continuing Reviews" />&nbsp;
	
	<p><div class="separator"></div></p>
	
	<div id="amendments">
		{include file="sectionEditor/amendments.tpl"}
	</div>
	<input type="button" class="button" name="showAmendments" id="showAmendments" value="Show Amendments" />&nbsp;
	
	 <p><div class="separator"></div></p>
		**************************************}	 
	 <input type="submit" name="submitMinutes" id="submitMinutes" value="Upload Minutes" class="button" />
 </form>
 {include file="common/footer.tpl"}
