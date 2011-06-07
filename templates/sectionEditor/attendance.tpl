{literal}<script type="text/javascript">
	var guestCount = 0;
	$(document).ready(function() {
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
	});
</script>{/literal}
<h4>ERC Members</h4>
<table class="data" name="attn_ercMembers">
 	<tr>
 		<td width="15%">Present</td>
 		<td width="15%">Absent</td>
 	</tr>
 	{foreach from=$committee item=committeeMember}
		<tr>
	 	 		<td width="15%"><input type="radio" name="attn_present_{$committeeMember.value}" id="attn_present_{$committeeMember.value}" value="present" /></td>
		 		<td width="15%"><input type="radio" name="attn_absent_{$committeeMember.value}" id="attn_absent_{$committeeMember.value}" value="absent" /></td>
			 	<td>
			 		{$committeeMember.name} ({$committeeMember.type})
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
