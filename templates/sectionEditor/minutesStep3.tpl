{**
 * templates/sectionEditor/minutesFormStep2.tpl
 * Added by aglet
 * Last Update: 6/1/2011
 * Form for uploading of minutes of the meeting
 *
 *}
{include file="common/header.tpl"}
<h4>Create Initial Review For Selected Proposal</h4>

<form name="articleForInitialReview" method="post" action="{url path="sectionEditor" op="saveMinutes"}">
	<table class="data" width="100%">
		<tr>
			<td width="10%">Protocol Title</td>
			<td>
				<select name="title" id="title" class="selectMenu">
					<option value="1">Article 1: Title X</option>
					<option value="2">Article 2: Title Y</option>
					<option value="3">Article 3: Title Z</option>
				</select>
			</td>
		</tr>
		<tr>
			<td><input type="submit" name="selectProposal" class="button" value="Select Proposal"></input></td>
		</tr>
	</table>
</form> 
{include file="common/footer.tpl"}
