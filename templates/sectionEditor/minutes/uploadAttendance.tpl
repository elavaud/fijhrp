{strip}
{assign var="pageTitle" value="common.queue.long.minutes"}
{url|assign:"currentUrl" page="sectionEditor"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="index" path="submissionsInReview"}">{translate key="common.queue.short.submissionsInReview"}</a></li>
	<li class="current"><a href="{url op="minutes"}">Upload Minutes</a></li>
	<li><a href="{url op="index" path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
</ul>
<br/>
{literal}<script type="text/javascript">
<!--
	var guestCount = 0;
	$(document).ready(function() {
		$( ".absence_div" ).hide();
		$( "#addGuest" ).click(
				function() {
					guestCount++;
					var row="<tr>"+
			 		"<td width='5%'>Name</td>"+
	 				"<td width='15%'><input type='text' name='guestName_"+ guestCount+" id='guestName_"+ guestCount+"' size='30'></input</td>"+
					"<td width='5%'>Affiliation</td>"+
	 				"<td width='15%'><input type='text' name='guestAffiliation_"+ guestCount+"' id='guestAffiliation_"+ guestCount+"' size='30'></input></td>"+
					"<td width='60%'></td>"+
	 				"</tr>";
					$("#guests tr:last").after(row);
				}
			);
			/*
 			 * If absent button is clicked, ask for type of absence
			 */
		 	$(".absent").click( function () {
			 		var elemVal = $(this).attr('name').substr(11);			 		
			 		$("#absence_div_"+elemVal).show();
		 		}
			);
		 	$(".present").click( function () {
			 		var elemVal = $(this).attr('name').substr(11);
			 		$("#absence_div_"+elemVal).hide();
	 			}
 			); 		
	});
-->
</script>{/literal}
<h4>Attendance for Meeting #{$meeting->getId()}</h4>
<br/>
<form method="POST" action="{url op="submitAttendance" path=$meeting->getId()}">
<table class="data" name="ercMembers">
	<tr class="heading" valign="bottom"><td colspan="6">REVIEW COMMITTEE</td></tr>
 	<tr>
 		<td width="10%">Present</td>
 		<td width="10%">Absent</td>
 		<td width="30%">Name of Committee Member</td>
 		<td width="50%">(Reason if absent)</td>
 	</tr>
 	{foreach from=$reviewers item=user}
		<tr>
	 	 		<td width="5%"><input type="radio" class="present" name="attendance_{$user->getId()}" id="present_{$user->getId()}" value="present" /></td>
		 		<td width="5%"><input type="radio" class="absent" name="attendance_{$user->getId()}" id="absent_{$user->getId()}" value="absent" /></td>
			 	<td width="35%">
			 		{$user->getFullName()}
			 		({if $user->getWproAffiliation() == "YES"} WPRO-affiliated {else} non-WPRO{/if} /
			 		{if $user->getWproAffiliation() == "YES"} Health-affiliated {else} non-Health {/if}
			 		)
			 	</td>
			 	<td width="50%" id="absence_div_{$user->getId()}" class="absence_div">
			 			<input type="radio" name="absence_reason_{$user->getId()}" id="duty_travel_{$user->getId()}" value="Duty Travel"/><label for="duty_travel_{$user->getId()}">Duty Travel</label>
				 		<input type="radio" name="absence_reason_{$user->getId()}" id="on_leave_{$user->getId()}" value="On Leave"/><label for="on_leave_{$user->getId()}">On Leave</label>
				 		<input type="radio" name="absence_reason_{$user->getId()}" id="others_{$user->getId()}" value="Other Commitment"/><label for="others_{$user->getId()}">Other Commitment</label>
				 		<input type="radio" name="absence_reason_{$user->getId()}" id="unexcused_{$user->getId()}" value="Unexcused"/><label for="unexcused_{$user->getId()}">Unexcused</label>
				 	</div>
			 	</td>
		</tr>		
	{/foreach}	 	
		
</table> 
<p><div class="separator"></div></p>
<br/>
 <table class="data" name="guests" id="guests" width="100%">
 	<input type="hidden" name="guestCount" id="guestCount" value={$guestCount} />
 	<tr class="heading" valign="bottom"><td colspan="6">GUESTS &nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="addGuest" id="addGuest" class="button" value="Add Guest" /></td></tr>
	<tr></tr> 	
 </table>
 <p><div class="separator"></div></p><br/>
  
 <input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="minutes.confirm.submitAttendance"}')" name="submit" value="Submit Attendance"  class="button" />
 &nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="minutes"}">Back to list of minutes</a>
 </form>