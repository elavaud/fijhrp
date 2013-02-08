{include file="sectionEditor/minutes/menu.tpl"}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>
{literal}<script type="text/javascript">
	$(document).ready(function() {
		var guestCount = 0;
		$("#adjourned").timepicker({ampm:true});

		$('.present').each( function(){
				var elemVal = $(this).attr('id').substring(19);
				var present = $(this).attr('checked');
				if(present){
					$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',true);
					$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
				}
			}
		);
		$('.absent').each( function(){
			var elemVal = $(this).attr('id').substring(18);
			var absent = $(this).attr('checked');
			if(absent){
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',false);
			}
		}
		);
		$("#allPresent").click(
				function() {
					var presentVal = $("#allPresent").val();
					if(presentVal == "Select all as present") {	
						$("#allPresent").val("Deselect all");					
						$(".present").attr('checked', true);
					} else {
						$("#allPresent").val("Select all as present");					
						$(".present").attr('checked', false);						
					}
				}
		);
		$("#addGuest").click(
				function() {
					$("#guests tr:last").after($("#guests tr:last").clone());
				}
			);

		$(".absent").click( function () {
				var elemVal = $(this).attr('id').substring(18);
				$("#div_reason_of_absence_"+elemVal).show();
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',false);
			}
		);

		$(".present").click( function () {
				var elemVal = $(this).attr('id').substring(19);	
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',true);
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
		}
 		);
//  		$(".div_reason_of_absence").click( function (){
//  			var elemVal = $(this).attr('id').substring(22);
// 			var present = $("#reviewer-ispresent-"+elemVal).attr('checked');
// 			if(present){
// 				alert("Mark the reviewer absent first.");
//  	 	 	}else{
//  	 	 		$("#reviewer-isabsent-"+elemVal).attr('checked',true);
//  	 	 	}
 	 	 	
//  		});
 		

	});

	function reasonClicked(elemVal) {
		var present = $("#reviewer-ispresent-"+elemVal).attr('checked');
		if(present){
			alert("Mark the reviewer absent first.");
	 	 	}else{
	 	 		$("#reviewer-isabsent-"+elemVal).attr('checked',true);
	 	 	}
	}
</script>{/literal}
<h3>{translate key="editor.minutes.attendanceAnnouncements"}{$meeting->getId()}</h3>
<br/>
<form method="POST" action="{url op="uploadAttendance" path=$meeting->getId()}">
	
<div id="announcements">
	<h3 style="text-align:left">Details</h3>
	<div class="separator"></div><br/>
	<table class="data" width="100%">
		<tr>
			<td class="label" width="20%">{fieldLabel name="adjourned" required="true" key="editor.minutes.adjourned"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="adjourned" id="adjourned" size="20" value="{$adjourned}"/></td>
		</tr>
		<tr>
			<td class="label" width="20%">{fieldLabel name="venue" required="true" key="editor.minutes.venue"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="venue" id="venue" size="20" value="{$venue}"/></td>
		</tr>
		<tr>
		 	<td class="label" width="20%">{translate key="editor.minutes.announcements"} and {translate key="editor.minutes.minutesOfLastMeeting"}</td>
		 	<td class="value" width="80%">
		 		<textarea name="announcements" id="announcements" rows="7" class="textArea">{$announcements}</textarea>
		 	</td>
		 </tr>
	</table>
</div>
<br/>
<div id="attendance">
	<h3>Review Committee &nbsp;&nbsp;&nbsp;<input type="button" class="button" name="allPresent" id="allPresent" value="Select all as present" /></h3> 
	<table width="100%" class="listing" name="ercMembers">
			<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	<tr class="heading">
			 	<td width="5%">{translate key="editor.minutes.absent"}</td>
		 		<td width="5%">{translate key="editor.minutes.present"}</td>
		 		<td width="20%">{translate key="editor.minutes.nameOfMember"}</td>
		 		<td width="20%">{translate key="editor.minutes.affiliationOfMember"}</td>
		 		<td width="50%" class="div_reason_of_absence" id="div_title_reason_of_absence">{translate key="editor.minutes.reasonOfAbsence"}</td>
		 	</tr>
		 	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	{assign var="isPresent" value="attendance"}
		 	{assign var="reason" value="reason"}
		 	{foreach from=$reviewers  item=user}
		 	{assign var="userId" value=$user->getId()}
		 	<tr>	
					<td width="5%">	
	
								<input type="hidden" name="reviewer_attendance[{$userId}][userId]" id="reviewer-userId-{$userId}" value="{$userId}" /> 
								<input type="radio"  class="absent" name="reviewer_attendance[{$userId}][attendance]" id="reviewer-isabsent-{$userId}" 
									{if $attendance[$userId][$isPresent]} == "absent" } checked="checked" {/if} value="absent"  />
					</td>
		 			<td width="5%">
								<input type="radio" class="present" name="reviewer_attendance[{$userId}][attendance]" id="reviewer-ispresent-{$userId}" 
									{if $attendance[$userId][$isPresent] == "present" } checked="checked" {/if} value="present" />
		 			</td>
					<td width="20%">
					 		<label for="attendance[{$userId}]">{$user->getSalutation} {$user->getFirstName()} {$user->getLastName()}</label></td>
					<td width="20%">
					 		{if $user->getLocalizedWproAffiliation() == "Yes"} {translate key="editor.reviewer.wproAffiliated"} {else} {translate key="editor.reviewer.nonWpro"} {/if} /
					 		{if $user->getLocalizedHealthAffiliation() == "Yes"} {translate key="editor.reviewer.healthAffiliated"} {else} {translate key="editor.reviewer.nonHealth"} {/if}					 		
					</td>
					<td width="50%" id="div_reason_of_absence_{$userId}" class="div_reason_of_absence">
					 			<input type="radio" name="reviewer_attendance[{$userId}][reason]" onClick="reasonClicked({$userId})" id="absent-{$userId}-duty-travel" value="Duty Travel" {if  $attendance[$userId][$reason] == "Duty Travel" } checked="checked"{/if} /><label for="duty_travel_{$user->getId()}">Duty Travel</label>
						 		<input type="radio" name="reviewer_attendance[{$userId}][reason]" onClick="reasonClicked({$userId})"  id="absent-{$userId}-on-leave" value="On Leave" {if $attendance[$userId][$reason] == "On Leave" } checked="checked"{/if} /><label for="on_leave_{$user->getId()}">On Leave</label>
						 		<input type="radio" name="reviewer_attendance[{$userId}][reason]" onClick="reasonClicked({$userId})" id="absent-{$userId}-other-commitment" value="Other Commitment" {if  $attendance[$userId][$reason] == "Other Commitment" } checked="checked"{/if}/><label for="others_{$user->getId()}">Other Commitment</label>
						 		<input type="radio" name="reviewer_attendance[{$userId}][reason]" onClick="reasonClicked({$userId})" id="absent-{$userId}-unexcused" value="Unexcused" {if  $attendance[$userId][$reason] == "Unexcused" } checked="checked"{/if}/><label for="unexcused_{$user->getId()}">Unexcused</label>
					</td>
					<input type="hidden" name="areviewer_attendance[{$userId}][userId]" value="{$userId}">
			</tr>
			<tr><td colspan="5" class="separator"></td></tr>	
			{/foreach}	 	
			<tr><td colspan="5" class="endseparator">&nbsp;</td></tr>	
	</table> 
	<br/>
	<br/>
	<h3>Guests&nbsp;&nbsp;<input type="button" name="addGuest" id="addGuest" class="button" value="+" /></h3>
	<div class="separator"></div><br/>
	<table class="listing" name="guests" id="guests" width="100%">
	{foreach from=$guestNames key=guestIndex item=guest}
		{if $guest != null }
		<tr>
		<td width='5%'>Name</td>
	 	<td width='15%'><input type='text' name='guestName[]' id='guestName[]' size='50' value="{$guest}" /></td>
		<td width='5%'>Affiliation</td>
	 	<td width='15%'><input type='text' name='guestAffiliation[]' id='guestAffiliation[]' size='50' value="{$guestAffiliations[$guestIndex]}" /></td>
		<td width='60%'></td>
		</tr>
		{/if}
	{/foreach}
	<tr>
		<td width='5%'>Name</td>
	 	<td width='15%'><input type='text' name='guestName[]' id='guestName[]' size='50' value="" /></td>
		<td width='5%'>Affiliation</td>
	 	<td width='15%'><input type='text' name='guestAffiliation[]' id='guestAffiliation[]' size='50' value="" /></td>
		<td width='60%'></td>
	</tr>
	</table>
		<br/><br/>
		<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.minutes.confirmAttendance"}')" value="Submit"  class="button defaultButton" name="submitAttendance"/>	 
		<input type="button" value={translate key="common.back"} class="button" onclick="document.location.href='{url op="uploadMinutes" path=$meeting->getId() }'" />
	</div>
 </form>
