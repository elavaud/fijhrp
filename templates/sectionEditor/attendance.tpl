{literal}<script type="text/javascript">
<!--
	var guestCount = 0;
	$(document).ready(function() {
		$( ".absence_div" ).hide();
		$( "#attn_addGuest" ).click(
				function() {
					guestCount++;
					var row="<tr>"+
			 		"<td width='5%'>Name</td>"+
	 				"<td width='15%'><input type='text' name='attn_guestName_"+ guestCount+" id='attn_guestName_"+ guestCount+"' size='30'></input</td>"+
					"<td width='5%'>Affiliation</td>"+
	 				"<td width='15%'><input type='text' name='attn_guestAffiliation_"+ guestCount+"' id='attn_guestAffiliation_"+ guestCount+"' size='30'></input></td>"+
					"<td width='60%'></td>"+
	 				"</tr>";
					$("#attn_guests tr:last").after(row);
				}
			);
			/*
 			 * If absent button is clicked, ask for type of absence
			 */
		 	$(".attn_absent").click( function () {
		 			//$(".absence_div").hide();
			 		var elemVal = $(this).attr('name').substr(16);			 		
			 		$("#attn_absence_div_"+elemVal).show();
		 		}
			);
		 	$(".attn_present").click( function () {
		 		var elemVal = $(this).attr('name').substr(16);
		 		$("#attn_absence_div_"+elemVal).hide();
	 			}
 			); 		
	});
-->
</script>{/literal}
<h4>REVIEW COMMITTEE</h4>
<table class="data" name="attn_ercMembers">
 	<tr>
 		<td width="10%">Present</td>
 		<td width="10%">Absent</td>
 		<td width="30%">Name of Committee Member</td>
 		<td width="50%">(Reason if absent)</td>
 	</tr>
 	{foreach from=$committee item=committeeMember}
		<tr>
	 	 		<td width="10%"><input type="radio" class="attn_present" name="attn_attendance_{$committeeMember.value}" id="attn_present_{$committeeMember.value}" value="present" /></td>
		 		<td width="10%"><input type="radio" class="attn_absent" name="attn_attendance_{$committeeMember.value}" id="attn_absent_{$committeeMember.value}" value="absent" /></td>
			 	<td width="30%">
			 		{$committeeMember.name} ({$committeeMember.type})
			 	</td>
			 	<td width="50%" id="attn_absence_div_{$committeeMember.value}" class="absence_div">
			 			<input type="radio" name="attn_absence_reason_{$committeeMember.value}" value="dutyTravel"/> Duty Travel
				 		<input type="radio" name="attn_absence_reason_{$committeeMember.value}" value="onLeave"/>  On Leave
				 		<input type="radio" name="attn_absence_reason_{$committeeMember.value}" value="otherCommitment"/>  Other Commitment
				 		<input type="radio" name="attn_absence_reason_{$committeeMember.value}" value="unexcused"/> Unexcused
				 	</div>
			 	</td>
		</tr>
	{/foreach}	 	
		
</table>
<p><div class="separator"></div></p>
<h4>Guests</h4>
 <table class="data" name="attn_guests" id="attn_guests" width="100%">
 	<input type="hidden" name="attn_guestCount" id="guestCount" value={$guestCount} />
	<tr class="heading">
 		<td colspan="6"><input type="button" name="attn_addGuest" id="attn_addGuest" class="button" value="Add Guest" /></td>
 	</tr>
 	<tr></tr> 	
 </table>
