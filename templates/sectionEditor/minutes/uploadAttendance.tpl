{include file="sectionEditor/minutes/menu.tpl"}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>

{literal}<script type="text/javascript">
<!--
	var guestCount = 0;
	$(document).ready(function() {		
		$("#adjourned").timepicker({ampm:true});
		$(".div_reason_of_absence").hide();
		$("#addGuest").click(
				function() {
					guestCount++;
					var row="<tr>"+
			 		"<td width='5%'>Name</td>"+
	 				"<td width='15%'><input type='text' name='guestName[]' id='guestName[]' size='50'></input</td>"+
					"<td width='5%'>Affiliation</td>"+
	 				"<td width='15%'><input type='text' name='guestAffiliation[]' id='guestAffiliation[]' size='50'></input></td>"+
					"<td width='60%'></td>"+
	 				"</tr>";
					$("#guests tr:last").after(row);
				}
			);
		 $(".absent").click( function () {
				var elemVal = $(this).attr('id').substring(20);
				$("#div_reason_of_absence_"+elemVal).show();
				$("#reviewer-absent-"+elemVal).attr('checked', true);
				$("#div_title_reason_of_absence").show();
			}
		);

		$(".present").click( function () {
				var elemVal = $(this).attr('id').substring(20);		
				$("#reviewer-absent-"+elemVal).attr('checked', false);
				$("#div_reason_of_absence_"+elemVal).hide();
		}
 		);
	});
-->
</script>{/literal}
<h2>Announcements and Attendance for Meeting #{$meeting->getId()}</h2>
<br/>
<form method="POST" action="{url op="submitAttendance" path=$meeting->getId()}">
	
<div id="announcements">
	<h2>Details</h2>
	<table class="data" width="100%">
		<tr>
			<td class="label" width="20%">{fieldLabel name="adjourned" required="true" key="editor.minutes.adjourned"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="adjourned" id="adjourned" size="20" /></td>
		</tr>
		<tr>
			<td class="label" width="20%">{fieldLabel name="venue" required="true" key="editor.minutes.venue"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="venue" id="venue" size="20" /></td>
		</tr>
		<tr>
		 	<td class="label" width="20%">{translate key="editor.minutes.announcements"}</td>
		 	<td class="value" width="80%">
		 		<textarea name="announcements" id="announcements" rows="7" class="textArea"></textarea>
		 	</td>
		 </tr>
	</table>
</div>
<div class="separator"></div>
<br/>
<div id="attendance">
	<h2>Review Committee</h2>
	<table width="100%" class="listing" name="ercMembers">
			<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		 	<tr>
		 		<td></td>
		 		<td width="5%">{translate key="editor.minutes.present"}</td>
			 	<td width="5%">{translate key="editor.minutes.absent"}</td>
		 		<td width="20%">{translate key="editor.minutes.nameOfMember"}</td>
		 		<td width="20%">{translate key="editor.minutes.affiliationOfMember"}</td>
		 		<td width="50%" class="div_reason_of_absence" id="div_title_reason_of_absence">{translate key="editor.minutes.reasonOfAbsence"}</td>
		 	</tr>
		 	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		 	{foreach from=$reviewers key=userId item=user}
		 	 <tr>	
		 			<td width="1%">{fieldLabel name="reviewer-attendance-$userId-userId"}{fieldLabel name="reviewer-attendance-$userId"  key="editor.minutes.uploadAttendance.checkReasonOfAbsence"}</td>
		 			<td width="5%">
			 					<input type="hidden" class="present" name="reviewer_attendance[{$userId}][userId]" id="reviewer-attendance-{$userId}-userId" value="{$user->getId()}"/>
								<input type="radio" class="present" name="reviewer_attendance[{$userId}][attendance]" id="reviewer-attendance-{$userId}" value="present"/>
		 			</td> 
					<td width="5%">	
								<input type="radio"  class="absent" name="reviewer_attendance[{$userId}][attendance]" id="reviewer-attendance-{$userId}" value="absent" />
								<input type="radio" style="display:none" class="absent" name="reviewer_absent[{$userId}][attendance]" id="reviewer-absent-{$userId}" value="absent" />
					</td>
					<td width="20%">
					 		<label for="attendance[{$userId}]">{$user->getFullName()}</label></td>
					<td width="20%">
					 		{if $user->getLocalizedWproAffiliation() == "Yes"} {translate key="editor.reviewer.wproAffiliated"} {else} {translate key="editor.reviewer.nonWpro"} {/if} /
					 		{if $user->getLocalizedHealthAffiliation() == "Yes"} {translate key="editor.reviewer.healthAffiliated"} {else} {translate key="editor.reviewer.nonHealth"} {/if}					 		
					</td>
					 	
					<td width="50%" id="div_reason_of_absence_{$userId}" class="div_reason_of_absence">
					 			{fieldLabel name="reviewer-absent-$userId-reason" required="true"}
					 			<input type="radio" name="reviewer_absent[{$userId}][reason]" id="reviewer-absent-{$userId}-reason" value="Duty Travel"/><label for="duty_travel_{$user->getId()}">Duty Travel</label>
						 		<input type="radio" name="reviewer_absent[{$userId}][reason]" id="reviewer-absent-{$userId}-reason" value="On Leave"/><label for="on_leave_{$user->getId()}">On Leave</label>
						 		<input type="radio" name="reviewer_absent[{$userId}][reason]" id="reviewer-absent-{$userId}-reason" value="Other Commitment"/><label for="others_{$user->getId()}">Other Commitment</label>
						 		<input type="radio" name="reviewer_absent[{$userId}][reason]" id="reviewer-absent-{$userId}-reason" value="Unexcused"/><label for="unexcused_{$user->getId()}">Unexcused</label>
					</td>
					<input type="hidden" name="areviewer_attendance[{$userId}][userId]" value="{$userId}">
				</tr>
				<tr><td colspan="6" class="separator"></td></tr>	
			{/foreach}	 	
			<tr><td colspan="6" class="endseparator">&nbsp;</td></tr>	
	</table> 
	<br/>
	<br/>
	<h2>Guests&nbsp;&nbsp;<input type="button" name="addGuest" id="addGuest" class="button" value="+" /></h2>
	<table class="listing" name="guests" id="guests" width="100%">
	<tr></tr>
	</table>
	<div class="separator"></div>
		<br/><br/>
		<input type="button" value={translate key="common.back"} class="button" onclick="document.location.href='{url op="uploadMinutes" path=$meeting->getId() }'" />
		<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="minutes.confirm.submitAttendance"}')" name="submitAttendance" value="Submit"  class="button defaultButton" />	 
	</div>
 </form>