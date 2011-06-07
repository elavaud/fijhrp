{literal}<script type="text/javascript">
	$(document).ready(function() {
		$( "#annc_dateHeld" ).datepicker();
	});			
{/literal}</script>


 <table class="data" name="annc_timeDate" id="annc_timeDate">
 	<tr>
	 	<td width="5%" class="label">Date Held</td>
	 	<td width="50%" class="value"><input type="text" name="annc_dateHeld" id="annc_dateHeld" size="10" value="{$minutesObj->dateHeld}"/></td>
	 </tr>
	 <tr>
	 	<td width="5%" class="label">Time Convened</td>
	 	<td width="50%" class="value">
	 		<select name="annc_convenedAtHour" id="annc_convenedAtHour" class="selectMenu">
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
	 		<select name="annc_convenedAtMinute" id="annc_convenedAtMinute" class="selectMenu">
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
	 		<select name="annc_convenedAtAmPm" id="annc_convenedAtAmPm" class="selectMenu">
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
	 		<textarea name="annc_announcements" id="annc_announcements" rows="7" cols="40" class="textArea">{$minutesObj->announcements}</textarea>
	 	</td>
	 </tr>
	 	  
 </table>
