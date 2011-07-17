{include file="sectionEditor/minutes/menu.tpl"}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>

{literal}<script type="text/javascript">
<!--
	var guestCount = 0;
	$(document).ready(function() {		
		$('#adjourned').timepicker({ampm:true});
		//$( ".absence_div" ).hide();
		$( "#addGuest" ).click(
				function() {
					guestCount++;
					var row="<tr>"+
			 		"<td width='5%'>Name</td>"+
	 				"<td width='15%'><input type='text' name='guestName[]' id='guestName[]' size='30'></input</td>"+
					"<td width='5%'>Affiliation</td>"+
	 				"<td width='15%'><input type='text' name='guestAffiliation[]' id='guestAffiliation[]' size='30'></input></td>"+
					"<td width='60%'></td>"+
	 				"</tr>";
					$("#guests tr:last").after(row);
				}
			);
			/*
 			 * If absent button is clicked, ask for type of absence
			 *
		 	$(".absent").click( function () {
			 		var elemVal = $(this).attr('name').substr(11, 1);			 		
			 		$("#absence_div["+elemVal+"]").show();
		 		}
			);
		 	$(".present").click( function () {
			 		var elemVal = $(this).attr('name').substr();
			 		$("#absence_div_"+elemVal).hide();
	 			}
 			);*/
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
		<!--	<tr class="heading" valign="bottom"><td colspan="4">REVIEW COMMITTEE</td></tr>-->
			<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	<tr>
		 		<td width="5%">{translate key="editor.minutes.present"}</td>
		 		<td width="5%">{translate key="editor.minutes.absent"}</td>
		 		<td width="20%">{translate key="editor.minutes.nameOfMember"}</td>
		 		<td width="20%">{translate key="editor.minutes.affiliationOfMember"}</td>
		 		<td width="50%">{translate key="editor.minutes.reasonOfAbsence"}</td>
		 	</tr>
		 	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	{foreach from=$reviewers item=user}
				<tr>
			 	 		<td width="5%"><input type="radio" class="present" name="attendance[{$user->getId()}]" id="present_{$user->getId()}" value="present"/></td>
				 		<td width="5%"><input type="radio" class="absent" name="attendance[{$user->getId()}]" id="absent_{$user->getId()}" value="absent" /></td>
					 	<td width="20%">
							<label for="attendance[{$user->getId()}]">{$user->getFullName()}</label>						 	
					 	</td>
					 	<td width="20%">
					 		{if $user->getLocalizedWproAffiliation() == "Yes"} {translate key="editor.reviewer.wproAffiliated"} {else} {translate key="editor.reviewer.nonWpro"} {/if} /
					 		{if $user->getLocalizedHealthAffiliation() == "Yes"} {translate key="editor.reviewer.healthAffiliated"} {else} {translate key="editor.reviewer.nonHealth"} {/if}					 		
					 	</td>
					 	<td width="50%" id="absence_div_{$user->getId()}" class="absence_div">
					 			<input type="radio" name="reason[{$user->getId()}]" id="duty_travel_{$user->getId()}" value="Duty Travel"/><label for="duty_travel_{$user->getId()}">Duty Travel</label>
						 		<input type="radio" name="reason[{$user->getId()}]" id="on_leave_{$user->getId()}" value="On Leave"/><label for="on_leave_{$user->getId()}">On Leave</label>
						 		<input type="radio" name="reason[{$user->getId()}]" id="others_{$user->getId()}" value="Other Commitment"/><label for="others_{$user->getId()}">Other Commitment</label>
						 		<input type="radio" name="reason[{$user->getId()}]" id="unexcused_{$user->getId()}" value="Unexcused"/><label for="unexcused_{$user->getId()}">Unexcused</label>
					 	</td>
				</tr>	
				<tr><td colspan="5" class="separator"></td></tr>	
			{/foreach}	 	
			<td colspan="5" class="endseparator">&nbsp;</td>	
		</table> 
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