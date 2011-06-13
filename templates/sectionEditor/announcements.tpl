{literal}<script type="text/javascript">
<!--
	$(document).ready(function() {
		$( "#annc_dateHeld" ).datepicker();
	});
-->			
</script>{/literal}

 <table class="data" name="annc_timeDate" id="annc_timeDate">
 	<tr>
	 	<td width="5%" class="label">Date Held</td>
	 	<td width="50%" class="value"><input type="text" name="annc_dateHeld" id="annc_dateHeld" size="10" value="{$minutesObj->dateHeld}"/></td>
	 </tr>
	 <tr>
	 	<td width="5%" class="label">Time Convened</td>
	 	<td width="50%" class="value">
	 		<select name="annc_convenedAtHour" id="annc_convenedAtHour" class="selectMenu">
	 			{html_options options=$hours selected=$minutesObj->timeConvened.hour}	 			
	 		</select>:
	 		<select name="annc_convenedAtMinute" id="annc_convenedAtMinute" class="selectMenu">
	 			{html_options options=$minutes selected=$minutesObj->timeConvened.minute}
	 		</select>
	 		<select name="annc_convenedAtAmPm" id="annc_convenedAtAmPm" class="selectMenu">
	 			{html_options options=$amPm selected=$minutesObj->timeConvened.amPm}
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
