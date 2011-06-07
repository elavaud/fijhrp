{**
 * templates/sectionEditor/minutesFormStep2.tpl
 * Added by aglet
 * Last Update: 6/1/2011
 * Form for uploading of minutes of the meeting
 *
 *}
{include file="common/header.tpl"}
<h4>PROPOSALS ASSIGNED FOR INITIAL REVIEW</h4>

<form name="initialReview" method="post" action={url path="sectionEditor" op="uploadMinutesStep4"}>
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
			<td width="10%">Principal Investigator</td>
			<td>$article->getAuthors()</td>
		</tr>
		<tr>
			<td width="10%">Protocol Summary</td>
			<td><textarea name="protocolSummary" id="protocolSummary" class="textArea" rows="5" cols=40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">(a) Discussion</td>
			<td><textarea name="discussion" id="discussion" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">General Discussion</td>
			<td><textarea name="generalDiscussion" id="generalDiscussion" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr class="heading" valign="bottom">
			<td width="10%" colspan="6">SPECIFIC DISCUSSIONS</td>
		</tr>
		<tr>
			<td width="10%">Scientific design (discuss and note that Institute pre-scientific review has been done)</td>
			<td><textarea name="scientificDesign" id="scientificDesign" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr>
			<td width="10%">Subject selection (discuss populations to be studied & recruitment
			<td><textarea name="subjectSelection" id="subjectSelection" class="textArea" rows="5" cols="40" ></textarea></td>
		</tr>
		<tr class="heading">
			<td colspan="6">LEVEL OF RISK</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="1"/></td>
			<td colspan="30">The research involves no more than minimal risk to subject.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="2"/></td>
			<td colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents more than a minor increase over
minimal risk.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="levelOfRisk" id="levelOfRisk" value="3"/></td>
			<td colspan="30">The research involves more than minimal risk to subjects. The risk(s) represents a minor increase over minimal risk.</td>
		</tr>
		<tr class="heading">
			<td colspan="6">BENEFIT CATEGORY</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/></td>
			<td colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge about the participants’ disorder
or condition.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/></td>
			<td colspan="30">No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge to further society’s understanding or the disorder or condition under study.</td>
		</tr>
		<tr>
			<td width="5%"><input type="radio" name="benefitCategory" id="benefitCategory" value="1"/></td>
			<td colspan="30">The research involves the prospect of direct benefit to individual participants.</td>
		</tr>
		<tr>
			<td width="10%">Additional Safeguards for Vulnerable Subjects</td>
			<td><textarea name="additionalSafeguards" id="additionalSafeguards" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Minimization of Risks to Subjects</td>
			<td><textarea name="minimization" id="minimization" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Privacy and Confidentiality</td>
			<td><textarea name="confidentiality" id="confidentiality" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Consent Document (document that all required elements are present)</td>
			<td><textarea name="consentDocument" id="consentDocument" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Additional Considerations (e.g. multi-center research; collaborative research; nested study. State if these considerations do not apply)</td>
			<td><textarea name="additionalConsiderations" id="additionalConsiderations" class="textArea" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td width="10%">Stipulations (number of stipulations)</td>
			<td><input type="text" name="stipulations" id="stipulations" size="5"  /></td>
		</tr>
		<tr>
			<td width="10%">Recommendations (number of recommendations)</td>
			<td><input type="text" name="recommendations" id="recommendations" size="5" /></td>
		</tr>
		<tr class="heading">
			<td colspan="6"> IRB DECISION </td>				
		</tr>
		<tr>
			<td class="label" width="20%">Select Decision</td>
			<td width="80%" class="value">
					<select name="decision" size="1" class="selectMenu">
						<option>Approved</option>						
						<option>Revise and Resubmit</option>
						<option>Not Approved</option>
					</select>						
					<input type="checkbox" name="unanimous" id="unanimous" value="1">Decision is unanimous</input>								
			</td>			
		</tr>
		<tr class="heading">
			<td colspan="6"> IRB VOTES </td>				
		</tr>
		<tr>
			<td class="label">Number of approvals</td>
			<td class="value"><input type="text" name="votesApproved" id="votesApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Number of disapprovals</td>
			<td class="value"><input type="text" name="votesNotApproved" id="votesNotApproved" size="5" /></td>			
		</tr>
		<tr>
			<td class="label">Abstain</td>
			<td class="value"><input type="text" name="votesAbstain" id="votesAbstain" size="5" /></td>			
		</tr>
		<tr>
			<td width="10%" class="label">Reasons for Minority Options</td>
			<td class="value"><textarea name="minorityReasons" id="minorityReasons" class="textArea" rows="5" cols="30"></textarea></td>
		</tr>
		<tr>
			<td><input type="submit" name="submit" class="button" value="Submit Initial Review"></input></td>
		</tr>				
	</table>
</form> 
{include file="common/footer.tpl"}

