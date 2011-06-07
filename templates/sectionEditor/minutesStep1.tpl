{**
 * templates/sectionEditor/minutesStep1.tpl
 * Added by aglet
 * Last Update: 6/1/2011
 * Form for uploading of minutes of the meeting
 *
 *}

<script type="text/javascript" src="http://localhost/whorrp-release1/whorrp/lib/pkp/js/lib/jquery/jquery.min.js"></script>
<script type="text/javascript" src="http://localhost/whorrp-release1/whorrp/lib/pkp/js/lib/jquery/plugins/jqueryUi.min.js"></script>

<script type="text/javascript">{literal}
	$(function() {
		$( "#dateHeld" ).datepicker();
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
		$( "#showAttendance" ).click(
				function() {
					
				}
		);			
	});			
{/literal}</script>

{include file="common/header.tpl"}

 <h4>WPRO-ERC Minutes</h4>
 
 <form name="minutesStep1" id="minutesStep1" method="post" action="{url op="saveMinutes"}">
 <input type="hidden" name="minutesObj" id="minutesObj" value="{$minutesObj}" />
 <input type="hidden" name="step" id="step" value="{$step}" />
 
 <table class="data" name="timeDate" id="timeDate">
 	<tr>
	 	<td width="5%" class="label">Date Held</td>
	 	<td width="50%" class="value"><input type="text" name="dateHeld" id="dateHeld" size="10"/></td>
	 </tr>
	 <tr>
	 	<td width="5%" class="label">Time Convened</td>
	 	<td width="50%" class="value">
	 		<select name="convenedAtHour" id="convenedAtHour" class="selectMenu">
				<option value="1">1</option>
	 			<option value="2">2</option>
				<option value="3">3</option>
	 			<option value="4">4</option>
				<option value="5">5</option>
	 			<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
	 			<option value="10">10</option>
				<option value="11">11</option>
	 			<option value="12">12</option>
	 		</select>:
	 		<select name="convenedAtMinute" id="convenedAtMinute" class="selectMenu">
	 			<option value="1">1</option>
	 			<option value="2">2</option>
				<option value="3">3</option>
	 			<option value="4">4</option>
				<option value="5">5</option>
	 			<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
	 			<option value="10">10</option>
				<option value="11">11</option>
	 			<option value="12">12</option>
	 			<option value="13">13</option>
				<option value="14">14</option>
	 			<option value="15">15</option>
	 			<option value="16">16</option>
				<option value="17">17</option>
	 			<option value="18">18</option>
	 		</select>
	 		<select name="convenedAtAmPm" id="convenedAtAmPm" class="selectMenu">
	 			<option>a.m.</option>	 			
	 			<option>p.m.</option>
	 		</select>
	 	</td>
	 </tr>
	 <tr>
	 	<td width="15%" class="label">
	 		Announcements
	 	</td>
	 	<td width="30%" class="value">
	 		<textarea name="announcements" id="announcements" rows="7" cols="40" class="textArea"></textarea>
	 	</td>
	 </tr>
	 <tr>
	 	<td colspan="2"><input type="button" class="button" name="showAttendance" id="showAttendance" value="Show Attendance Form" /></td>  
	 </tr>
 </table>
 </form>
 <p><div class="separator"></div></p>
 <div id="attendance"></div>
 {include file="common/footer.tpl"}
