{**
 * templates/sectionEditor/minutesFormStep1.tpl
 * Added by aglet
 * Last Update: 6/1/2011
 * Form for uploading of minutes of the meeting
 *
 *}

<script type="text/javascript" src="http://localhost/whorrp-release1/whorrp/lib/pkp/js/lib/jquery/jquery.min.js"></script>
<script type="text/javascript" src="http://localhost/whorrp-release1/whorrp/lib/pkp/js/lib/jquery/plugins/jqueryUi.min.js"></script>

<script type="text/javascript">{literal}
	$(function() {
		$( "#addGuest" ).click(
			function() {
				var row="<tr>"+
		 		"<td width='5%'>Name</td>"+
 				"<td width='15%'><input type='text' name='guestName' id='guestName' size='30'></input</td>"+
				"<td width='5%'>Affiliation</td>"+
 				"<td width='15%'><input type='text' name='guestAffiliation' id='guestAffiliation' size='30'></input></td>"+
				"<td width='60%'></td>"+
 				"</tr>";
				$("#guests tr:last").after(row);
			}
		);
		$( "#addWproMember" ).click(
			function() {
				var row="<tr>"+
					"<td width='20%'>Name</td>"+
					"<td>"+
	 				"<select name='wproMembers' class='selectMenu'>"+
	 				"<option>Ran Kudo</option>"+
	 				"<option>Shinichi Itugawa</option>"+
	 				"<option>Pikachu</option>"+
	 				"<option>Charmander</option>"+
	 				"<option>Bulbasaur</option>"+
	 				"<option>Squirtle</option>"+
		 			"</select>"+
 					"</td>"+
				 	"</tr>";
				$("#wproMembers tr:last").after(row);
			}
		);
	});	
{/literal}</script>

{include file="common/header.tpl"}

 <h4>WPRO-ERC Minutes</h4>
 
 <form name="minutes" method="post" action="{url op="saveMinutes"}">
 <input type="hidden" name="minutesObj" id="minutesObj" value="{$minutesObj}" />
 <input type="hidden" name="step" id="step" value="{$step}" />
<div class="separator"></div>
<h4>ERC Members</h4>
<table class="data" name="ercMembers">
 	<tr>
 		<td width="15%">Present</td>
 		<td width="15%">Absent</td>
 	</tr>
 	<tr>
 		<td width="15%"><input type="checkbox" name="present" value="1" /></td>
 		<td width="15%"><input type="checkbox" name="absent" value="2" /></td>
	 	<td>
	 		Mr. Caoile Hines (WPRO-affiliated, scientist)
	 	</td>	 	
	</tr>
</table>
<p><div class="separator"></div></p>
<h4>Guests</h4>
 <table class="data" name="guests" id="guests" width="100%">
 	<input type="hidden" name="guestCount" id="guestCount" value={$guestCount} />
	<tr class="heading">
 		<td colspan="6"><input type="button" name="addGuest" id="addGuest" class="button" value="Add another guest" /></td>
 	</tr>
 	<tr>
 		<td width="5%">Name</td>
 		<td width="15%"><input type="text" name="guestName" id="guestName" size="30" /></td>
		<td width="5%">Affiliation</td>
 		<td width="15%"><input type="text" name="guestAffiliation" id="guestAffiliation" size="30" /></td>
		<td width="60%"></td>
 	</tr>
 </table>

<input type="submit" value="Submit" class="button"/>
 </form>
{include file="common/footer.tpl"}
