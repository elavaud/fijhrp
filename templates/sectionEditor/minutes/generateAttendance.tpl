{include file="sectionEditor/minutes/menu.tpl"}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>
{literal}<script type="text/javascript">
	$(document).ready(function() {
		var guestCount = 0;
		$("#adjourned").timepicker({
			ampm:true,
			hourMin: {/literal}{$meeting->getDate()|date_format:"%I"}{literal}
		});

		$('.present').each( 
			function(){
				var elemVal = $(this).attr('id').substring(19);
				var present = $(this).attr('checked');
				if(present){
					$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',true);
					$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
				}
			}
		);
		
		$('.absent').each( 
			function(){
				var elemVal = $(this).attr('id').substring(18);
				var absent = $(this).attr('checked');
				if(absent){
					$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',false);
				}
			}
		);
		
		$("#allPresent").click(
			function() {
				$(".present").attr('checked', true);
				$("#deselectAll").show();
				$("#allPresent").hide();
				$('.present').each( 
					function(){
						var elemVal = $(this).attr('id').substring(19);
						var present = $(this).attr('checked');
						if(present){
							$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',true);
							$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
						}
					}
				);
			}
		);

		$("#deselectAll").click(
			function() {
				$(".present").attr('checked', false);
				$("#deselectAll").hide();
				$("#allPresent").show();
				$('.present').each( 
					function(){
						var elemVal = $(this).attr('id').substring(19);
						var present = $(this).attr('checked');
						if(!present){
							$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',false);
							$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
						}
					}
				);
			}
		);
		
		$("#showAddGuestField").click(
			function() {
				$("#showAddGuestField").hide();
				$("#hideAddGuestField").show();
				$("#addGuestField").show();
			}
		);

		$("#hideAddGuestField").click(
			function() {
				$("#showAddGuestField").show();
				$("#hideAddGuestField").hide();
				$("#addGuestField").hide();
				
				var rows = $("#meetingAttendances tr:gt(0)"); // skip the first row

				rows.each(function() {
					$(this).remove();
				});
				$("#meetingAttendances > tbody > tr:first").find('td:eq(1) input').val('');
				$("#meetingAttendances > tbody > tr:first").find('td:eq(3) input').val('');		
			}
		);

		$("#addGuest").click(
			function() {
				$("#meetingAttendances tr:last").after($("#meetingAttendances tr:last").clone());
			}
		);

        $('.removeAddGuest').live('click',
        	function(){
        		var rowCount = $('#meetingAttendances tr').length;
        		if (rowCount>1) {
        			$(this).closest('tr').remove();
        		} else {
        			$("#showAddGuestField").show();
					$("#hideAddGuestField").hide();
					$("#addGuestField").hide();
					$("#meetingAttendances > tbody > tr:first").find('td:eq(1) input').val('');
					$("#meetingAttendances > tbody > tr:first").find('td:eq(3) input').val('');	
        		}
           		return false;
        	}
        );
        	
		$(".absent").click( 
			function () {
				var elemVal = $(this).attr('id').substring(18);
				$("#div_reason_of_absence_"+elemVal).show();
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',false);
			}
		);

		$(".present").click( 
			function () {
				var elemVal = $(this).attr('id').substring(19);	
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',true);
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
			}
 		);
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
<h3>{translate key="editor.minutes.attendanceAnnouncements"}{$meeting->getPublicId()}</h3>

<br/>
<form method="POST" action="{url op="generateAttendance" path=$meeting->getId()}">
	
<div id="announcements">
	<h3 style="text-align:left">{translate key="reviewer.meetings.details}</h3>
	<div class="separator"></div><br/>
	<table class="data" width="100%">
		<tr>
			<td class="label" width="20%">{fieldLabel name="adjourned" required="true" key="editor.minutes.adjourned"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="adjourned" id="adjourned" size="20" value="{$adjourned}"/></td>
		</tr>
		<tr>
			<td class="label" width="20%">{fieldLabel name="venue" required="true" key="editor.minutes.venue"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="venue" id="venue" size="20" value="{if $venue == null}{$meeting->getLocation()}{else}{$venue}{/if}"/></td>
		</tr>
		<tr>
		 	<td class="label" width="20%">{translate key="editor.minutes.announcements"} {translate key="common.and"} {translate key="editor.minutes.minutesOfLastMeeting"}</td>
		 	<td class="value" width="80%">
		 		<textarea name="announcements" rows="7" cols="70" class="textArea">{$announcements}</textarea>
		 	</td>
		 </tr>
	</table>
</div>
<br/>
<div id="attendance">
	<table width="100%">
		<tr>
			<td width="50%"><h3>{translate key="editor.meeting.guests"}</h3></td>
			<td width="50%" align="right"><a id="allPresent" href="javascript:void(0)">{translate key="editor.meeting.selectAllAsPresent"}</a><a href="javascript:void(0)" id="deselectAll" style="display: none;">{translate key="editor.meeting.deselectAll"}</a></td>
		</tr>
	</table>
	<table width="100%" class="listing" name="ercMembers">
			<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	<tr class="heading">
			 	<td width="5%">{translate key="editor.minutes.absent"}</td>
		 		<td width="5%">{translate key="editor.minutes.present"}</td>
		 		<td width="20%">{translate key="editor.minutes.nameOfGuest"}</td>
		 		<td width="20%">{translate key="editor.minutes.affiliationOfGuest"}</td>
		 		<td width="50%" class="div_reason_of_absence" id="div_title_reason_of_absence">{translate key="editor.minutes.reasonOfAbsence"}</td>
		 	</tr>
		 	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	{assign var="isPresent" value="attendance"}
		 	{assign var="reason" value="reason"}
		 	{foreach from=$meetingAttendances  item=guest}
		 	{assign var="guestId" value=$guest->getUserId()}
		 	<tr>	
				<td width="5%">
					<input type="hidden" name="guest_attendance[{$guestId}][guestId]" id="reviewer-guestId-{$guestId}" value="{$guestId}" /> 
					<input type="radio" class="absent" name="guest_attendance[{$guestId}][attendance]" id="reviewer-isabsent-{$guestId}" {if isset($attendance.$guestId.attendance)}{if $attendance.$guestId.attendance == "absent"} checked="checked" {/if}{elseif $guest->getIsAttending() == 2} checked="checked" {/if} value="absent"  />
				</td>
		 		<td width="5%">
					<input type="radio" class="present" name="guest_attendance[{$guestId}][attendance]" id="reviewer-ispresent-{$guestId}" {if isset($attendance.$guestId.attendance)}{if $attendance.$guestId.attendance == "present"} checked="checked" {/if}{elseif $guest->getIsAttending() == 1} checked="checked" {/if} value="present" />
		 		</td>
				<td width="20%">
					<label for="attendance[{$guestId}]">{$guest->getSalutation} {$guest->getFirstName()} {$guest->getLastName()}</label></td>
				<td width="20%">{$guest->getFunctions()}</td>
				<td width="50%" id="div_reason_of_absence_{$guestId}" class="div_reason_of_absence">
					<table width="100%">
						<tr>
							<td width="50%"><input type="radio" name="guest_attendance[{$guestId}][reason]" onClick="reasonClicked({$guestId})" id="absent-{$guestId}-duty-travel" value="Duty Travel" {if  $attendance.$guestId.reason == "Duty Travel" } checked="checked"{/if} /><label for="duty_travel_{$guest->getId()}">{translate key="editor.minutes.absent.dutyTravel"}</label></td>
							<td width="50%"><input type="radio" name="guest_attendance[{$guestId}][reason]" onClick="reasonClicked({$guestId})"  id="absent-{$guestId}-on-leave" value="On Leave" {if $attendance.$guestId.reason == "On Leave" } checked="checked"{/if} /><label for="on_leave_{$guest->getId()}">{translate key="editor.minutes.absent.onLeave"}</label></td>
						</tr>
						<tr>
							<td width="50%"><input type="radio" name="guest_attendance[{$guestId}][reason]" onClick="reasonClicked({$guestId})" id="absent-{$guestId}-other-commitment" value="Other Commitment" {if  $attendance.$guestId.reason == "Other Commitment" } checked="checked"{/if}/><label for="others_{$guest->getId()}">{translate key="editor.minutes.absent.otherCommitment"}</label></td>
							<td width="50%"><input type="radio" name="guest_attendance[{$guestId}][reason]" onClick="reasonClicked({$guestId})" id="absent-{$guestId}-unexcused" value="Unexcused" {if  $attendance.$guestId.reason == "Unexcused" } checked="checked"{/if}/><label for="unexcused_{$guest->getId()}">{translate key="editor.minutes.absent.unexcused"}</label></td>
						</tr>
					</table>
				</td>
				<input type="hidden" name="guest_attendance[{$guestId}][guestId]" value="{$guestId}">
			</tr>
			<tr><td colspan="5" class="separator"></td></tr>	
			{/foreach}	 	
			<tr><td colspan="5" class="endseparator">&nbsp;</td></tr>	
	</table> 
	<br/>
	<br/>
	<p><a id="showAddGuestField" href="javascript:void(0)" class="action">{translate key="editor.meeting.addSuppGuests"}</a><a id="hideAddGuestField" href="javascript:void(0)" style="display: none;" class="action">{translate key="editor.meeting.removeSuppGuests"}</a></p>
	<div id="addGuestField" style="display: none;">
		<div class="separator"></div><br/>
		<table class="listing" name="meetingAttendances" id="meetingAttendances" width="100%">
		{foreach from=$suppGuestNames key=guestIndex item=guest}
			<tr valign="top">
				<td width='10%'>{translate key="user.name"}</td>
	 			<td width='35%'><input type='text' name='suppGuestName[]' id='suppGuestName[]' size='40' value="{$guest}" /></td>
				<td width='10%'>{translate key="user.affiliation"}</td>
	 			<td width='35%'><input type='text' name='suppGuestAffiliation[]' id='suppGuestAffiliation[]' size='40' value="{$suppGuestAffiliations[$guestIndex]}" /></td>
	 			<td width='10%'><a href="" class="removeAddGuest">{translate key="common.remove"}</a></td>
			</tr>
		{/foreach}
		</table>
		<a id="addGuest" href="javascript:void(0)">{translate key="editor.meeting.addAnotherGuest"}</a>
	</div>
	
	<br/><br/>
	<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.minutes.confirmAttendance"}')" value="Submit"  class="button defaultButton" name="submitAttendance"/>	 
	<input type="button" value={translate key="common.back"} class="button" onclick="document.location.href='{url op="generateAttendance" path=$meeting->getId() }'" />
</div>
 </form>

{include file="common/footer.tpl"}
