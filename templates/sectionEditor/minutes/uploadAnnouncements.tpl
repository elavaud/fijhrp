{include file="sectionEditor/minutes/menu.tpl"}
<div id="announcements">
{literal}<script type="text/javascript">
<!--
	$(document).ready(function() {
		$( "#dateHeld" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-mm-yy', minDate: '-6 m'});		
	});
-->
</script>{/literal}

<h4>Date and Announcements for Meeting #{$meeting->getId()}</h4>
<form method="POST" action="{url op="submitAnnouncements" path=$meeting->getId()}">
 <table class="data" name="timeDate" id="timeDate">
 	<tr>
	 	<td width="5%" class="label">Date Held</td>
	 	<td width="50%" class="value"><input type="text" name="dateHeld" id="dateHeld" size="10" class="textField" value="{$minutesObj->dateHeld}"/>&nbsp;&nbsp;(dd-mm-yyy)</td>
	 </tr>
	 <tr>
	 	<td width="5%" class="label">Time Convened</td>
	 	<td width="50%" class="value">
	 		<select name="hourConvened" id="hourConvened" class="selectMenu">
	 			{html_options options=$hour selected="2"}
	 		</select>:
	 		<select name="minuteConvened" id="minuteConvened" class="selectMenu">
	 			{html_options options=$minute selected="00"}
	 		</select>
	 		<select name="amPmConvened" id="amPmConvened" class="selectMenu">
	 			<option value="am">a.m.</option>
	 			<option value="pm" selected="selected">p.m.</option>
	 		</select>
	 	</td>
	 </tr>
	 <tr>
	 	<td width="5%" class="label">Time Adjourned</td>
	 	<td width="50%" class="value">
	 		<select name="hourAdjourned" id="hourAdjourned" class="selectMenu">
	 			{html_options options=$hour selected="2"}
	 		</select>:
	 		<select name="minuteAdjourned" id="minuteAdjourned" class="selectMenu">
	 			{html_options options=$minute selected="00"}
	 		</select>
	 		<select name="amPmAdjourned" id="amPmAdjourned" class="selectMenu">
	 			<option value="am">a.m.</option>
	 			<option value="pm" selected="selected">p.m.</option>
	 		</select>
	 	</td>
	 </tr>
	 <tr>
	 	<td width="15%" class="label">
	 		Announcements
	 	</td>
	 	<td width="30%" class="value">
	 		<textarea name="announcements" id="announcements" rows="7" cols="40" class="textArea">{$minutesObj->announcements}</textarea>
	 	</td>
	 </tr>	 	 
 </table>
 <br/>
 <input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="minutes.confirm.submitAnnouncements"}')" name="submit" value="Submit Date and Announcements"  class="button" />
 &nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="minutes"}">Back to list of minutes</a>
 </form>
</div>