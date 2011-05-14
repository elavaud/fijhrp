{**
 * templates/sectionEditor/meetingMinutes/submit.tpl
 * Added by Gay Figueroa
 * Last Update: 5/14/2011
 * Form for meeting minutes
 *}
WPRO-ERC minutes

<form name="submit" method="post" action="{url op="recordMeetingMinutes}">

<div id="ercMembers">
<table class="data" width="100%">

	<tr valign="top">
		<td width="20%" class="label">Date when meeting was held</td>
		<td width="80%" class="value"><select name="date" id="date" size="1" class="selectMenu">{html_options options=$dateOptions}</select><select name="month" id="month" size="1" class="selectMenu">{htmlOptions options=$monthOptions}</select><select name="year" id="year" size="1" class="selectMenu">{htmlOptions options=$yearOptions}</select></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Time when meeting was convened</td>
		<td width="80%" class="value"><select name="hour" id="hour" size="1" class="selectMenu"></select><select name="minute" size="1" class="selectMenu"></select><select name="amPm" size="1" class="selectMenu"></select></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Members present</td>
		<td width="80%" class="value"><select name="present1" id="present1" size="1" class="selectMenu"> </select> <select name="affiliation" size="1" class="selectMenu"></select> <checkbox name="isChair" size="1" class="selectMenu"/></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Members absent</td>
		<td width="80%" class="value"><select name="absent1" id="absent1" size="1" class="selectMenu"> </select></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Guests</td>
		<td width="80%" class="value"><select name="guest1" id="guest1" size="1" class="selectMenu"> </select><select name="affiliation" size="1" class="selectMenu"></select></td>
	</tr>

</table>
</div> <!--end ercMembers div-->

<div class="separator"></div>


{** 
 *
 * Form to be displayed if a new proposal is being reviewed
 * TODO: pano ko malalaman kung revision ba ito o hindi?
 *
 *}

<div id="newProposalMinutes">
<table class="data" width="100%">

	<tr valign="top">
		<td width="20%" class="label">Principal Investigator</td>
		<td width="80%" class="value"><select name="pi" id="pi" size="1" class="selectMenu"> </select></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Protocol Title</td>
		<td width="80%" class="value"><input type="text" name="title" id="title" /></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Protocol Summary</td>
		<td width="80%" class="value"><textbox name="summary" id="summary" /></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Discussion</td>
		<td width="80%" class="value"><textbox name="discussion" id="discussion" /></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">General Discussion</td>
		<td width="80%" class="value"><textbox name="generalDiscussion" id="generalDiscussion" /></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Specific Discussion</td>
		<td width="80%" class="value"></td>
	</tr>

	<tr valign="top">
		<td width="20%" class="label">Scientific Design</td>
		<td width="80%" class="value"><textbox name="scientificDesign" id="scientificDesign" /></td>
	</tr>

	RISK BENEFITS
	<tr valign="top">
		<td width="20%" class="label">Subject Selection</td>
		<td width="80%" class="value"><textbox name="subjectionSelection" id="subjectionSelection" /></td>
	</tr>
</table>
</div><!-- end newProposalMinutes div -->
{** 
 *
 * Form to be displayed if proposal being reviewed is a revision
 * TODO: pano ko malalaman kung revision ba ito o hindi?
 *
 *}


</form>
