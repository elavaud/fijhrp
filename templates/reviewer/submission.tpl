{**
 * submission.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Show the reviewer administration page.
 *
 * FIXME: At "Notify The Editor", fix the date.
 *
 * $Id$
 *}
{strip}
{assign var="articleId" value=$submission->getLocalizedProposalId()}
{assign var="reviewId" value=$reviewAssignment->getId()}
{translate|assign:"pageTitleTranslated" key="submission.page.review" id=$articleId}
{assign var="pageCrumbTitle" value="submission.review"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript">
{literal}
<!--
function confirmSubmissionCheck() {
	if (document.recommendation.recommendation.value=='') {
		alert('{/literal}{translate|escape:"javascript" key="reviewer.article.mustSelectDecision"}{literal}');
		return false;
	}
	return confirm('{/literal}{translate|escape:"javascript" key="reviewer.article.confirmDecision"}{literal}');
}

$(document).ready(function() {
	$( "#proposedDate" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-6 m'});
});
// -->
{/literal}


</script>
<div id="submissionToBeReviewed">
<h3>{translate key="reviewer.article.submissionToBeReviewed"}</h3>
<table width="100%" class="data">
<tr valign="top">
	<td width="20%" class="label">{translate key="common.proposalId"}</td>
	<td width="80%" class="value">{$submission->getLocalizedProposalId()|strip_unsafe_html}</td>
</tr>
<tr valign="top">
	<td width="20%" class="label">{translate key="article.title"}</td>
	<td width="80%" class="value">{$abstract->getScientificTitle()|strip_unsafe_html}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="article.journalSection"}</td>
	<td class="value">{$submission->getSectionTitle()|escape}</td>
</tr>

</table>
</div>
<div class="separator"></div>

<div id="files">
{assign var="articleId" value=$submission->getArticleId()}

<h3>{translate key="article.files"}</h3>
	<table width="100%" class="data">
	{if ($confirmedStatus and not $declined) or not $journal->getSetting('restrictReviewerFileAccess')}
		<tr valign="top">
			<td width="20%" class="label">
				{translate key="submission.submissionManuscript"}
			</td>
			<td class="value" width="80%">
				{if $reviewFile}
				{if $submission->getDateConfirmed() or not $journal->getSetting('restrictReviewerAccessToFile')}
					<a href="{url op="downloadFile" path=$reviewId|to_array:$articleId:$reviewFile->getFileId()}" class="file">{$reviewFile->getFileName()|escape}</a>
				{else}{$reviewFile->getFileName()|escape}{/if}
				&nbsp;&nbsp;{$reviewFile->getDateModified()|date_format:$dateFormatShort}
				{else}
				{translate key="common.none"}
				{/if}
			</td>
		</tr>
		{if count($previousFiles)>1}
		{assign var="count" value=0}
		<tr>
			<td class="label">Previous proposal files</td>
			<td width="80%" class="value">
				{foreach name="previousFiles" from=$previousFiles item=previousFile}
					{assign var="count" value=$count+1}
					{if $count > 1}
            			<a href="{url op="downloadFile" path=$reviewId|to_array:$articleId:$previousFile->getFileId()}" class="file">{$previousFile->getFileName()|escape}</a><br />
					{/if}
				{/foreach}
			</td>
		</tr>
		{/if}
		<tr valign="top">
			<td class="label">
				{translate key="article.suppFiles"}
			</td>
			<td class="value">
				{assign var=sawSuppFile value=0}
				{foreach from=$suppFiles item=suppFile}
					{if $suppFile->getShowReviewers() }
						{assign var=sawSuppFile value=1}
						<a href="{url op="downloadFile" path=$reviewId|to_array:$articleId:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a><cite>&nbsp;&nbsp;({$suppFile->getType()})</cite><br />
					{/if}
				{/foreach}
				{if !$sawSuppFile}
					{translate key="common.none"}
				{/if}
			</td>
		</tr>
		{else}
		<tr><td class="nodata">{translate key="reviewer.article.restrictedFileAccess"}</td></tr>
		{/if}
	</table>
</div>

{if $submission->getDateDue()}

<div class="separator"></div>

<div id="reviewSchedule">
<h3>{translate key="reviewer.article.reviewSchedule"}</h3>
<form method="post" action="{url op="reviewMeetingSchedule" }" >
<table width="100%" class="data">
<tr valign="top">
	<td class="label" width="20%">{translate key="reviewer.article.schedule.request"}</td>
	<td class="value" width="80%">{if $submission->getDateNotified()}{$submission->getDateNotified()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.response"}</td>
	<td class="value">{if $submission->getDateConfirmed()}{$submission->getDateConfirmed()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.submitted"}</td>
	<td class="value">{if $submission->getDateCompleted()}{$submission->getDateCompleted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.due"}</td>
	<td class="value">{if $submission->getDateDue()}{$submission->getDateDue()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>
</tr>
{if $reviewAssignment->getDateCompleted() || $reviewAssignment->getDeclined() == 1 || $reviewAssignment->getCancelled() == 1}
<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.decision"}</td>
	<td class="value">
		{if $submission->getCancelled()}
			Canceled
		{elseif $submission->getDeclined()}
			Declined
		{else}
			{assign var=recommendation value=$submission->getRecommendation()}
			{if $recommendation === '' || $recommendation === null}
				&mdash;
			{else}
				{translate key=$reviewerRecommendationOptions.$recommendation}
			{/if}
		{/if}
	</td>
</tr>
{/if}
{**<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.dateOfMeeting"}</td>
	<td class="value">{if $submission->getDateOfMeeting()}{$submission->getDateOfMeeting()|date_format:$datetimeFormatLong}{else}&mdash;{/if}</td>
</tr>

<tr valign="top">
	<td class="label">{translate key="reviewer.article.schedule.isAttending"} </td>
	<td class="value">	
		<input type="radio" name="isAttending" id="acceptMeetingSchedule" value="1" {if  $submission->getIsAttending() == 1 } checked="checked"{/if} > </input> Yes
		<input type="radio" name="isAttending" id="regretMeetingSchedule" value="0" {if  $submission->getIsAttending() == 0 } checked="checked"{/if} > </input> No
	</td>
</tr> 
<tr>
	<td class="label">{translate key="reviewer.article.schedule.remarks"} </td>
	<td class="value">
		<textarea class="textArea" name="remarks" id="proposedDate" rows="5" cols="40" />{$submission->getRemarks()|escape}</textarea>
	</td>
</tr>
<tr>
	<td class="label"></td>
	<td class="value">
		<input type="hidden" id="reviewId" name="reviewId" value={$reviewId}> </input>
		<input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url page="user" escape=false}'" />
	</td>
</tr>**}
</table>
</form>
</div>

{if !$reviewAssignment->getDateCompleted() &&  ($reviewAssignment->getDeclined() != 1) && (!$reviewAssignment->getCancelled() || ($reviewAssignment->getCancelled() == 0)) && (($submission->getMostRecentDecision() == 7) || ($submission->getMostRecentDecision() == 8))}
<div class="separator"></div>

<div id="reviewSteps">
<h3>{translate key="reviewer.article.reviewSteps"}</h3>

{include file="common/formErrors.tpl"}

{assign var="currentStep" value=1}

<table width="100%" class="data">
<tr valign="top">
	{* FIXME: Should be able to assign primary editorial contact *}
	<td width="3%">{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td width="97%"><span class="instruct">{translate key="reviewer.article.notifyEditorA"} {translate key="reviewer.article.notifyEditorB"}</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		{translate key="submission.response"}&nbsp;&nbsp;&nbsp;&nbsp;
		{if not $confirmedStatus}
			{url|assign:"acceptUrl" op="confirmReview" reviewId=$reviewId}
			{url|assign:"declineUrl" op="confirmReview" reviewId=$reviewId declineReview=1}

			{if !$submission->getCancelled()}
				{translate key="reviewer.article.canDoReview"} {icon name="mail" url=$acceptUrl}
				&nbsp;&nbsp;&nbsp;&nbsp;
				{translate key="reviewer.article.cannotDoReview"} {icon name="mail" url=$declineUrl}
			{else}
				{url|assign:"url" op="confirmReview" reviewId=$reviewId}
				{translate key="reviewer.article.canDoReview"} {icon name="mail" disabled="disabled" url=$acceptUrl}
				&nbsp;&nbsp;&nbsp;&nbsp;
				{url|assign:"url" op="confirmReview" reviewId=$reviewId declineReview=1}
				{translate key="reviewer.article.cannotDoReview"} {icon name="mail" disabled="disabled" url=$declineUrl}
			{/if}
		{else}
			{if not $declined}{translate key="submission.accepted"}{else}{translate key="submission.rejected"}{/if}
		{/if}
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
{if $journal->getLocalizedSetting('reviewGuidelines') != ''}
<tr valign="top">
        <td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.consultGuidelines"}</span></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
{/if}
<tr valign="top">
	<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.downloadSubmission"}</span></td>
</tr>

<tr>
	<td colspan="2">&nbsp;</td>
</tr>
{if $currentJournal->getSetting('requireReviewerCompetingInterests')}
	<tr valign="top">
		<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
		<td>
			{url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}
			<span class="instruct">{translate key="reviewer.article.enterCompetingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</span>
			{if not $confirmedStatus or $declined or $submission->getCancelled() or $submission->getRecommendation()}<br/>
				{$reviewAssignment->getCompetingInterests()|strip_unsafe_html|nl2br}
			{else}
				<form action="{url op="saveCompetingInterests" reviewId=$reviewId}" method="post">
					<textarea {if $cannotChangeCI}disabled="disabled" {/if}name="competingInterests" class="textArea" id="competingInterests" rows="5" cols="40">{$reviewAssignment->getCompetingInterests()|escape}</textarea><br />
					<input {if $cannotChangeCI}disabled="disabled" {/if}class="button defaultButton" type="submit" value="{translate key="common.save"}" />
				</form>
			{/if}
		</td>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
{/if}{* $currentJournal->getSetting('requireReviewerCompetingInterests') *}

{if $reviewAssignment->getReviewFormId()}
	<tr valign="top">
		<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
		<td><span class="instruct">{translate key="reviewer.article.enterReviewForm"}</span></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			{translate key="submission.reviewForm"} 
			{if $confirmedStatus and not $declined}
				<a href="{url op="editReviewFormResponse" path=$reviewId|to_array:$reviewAssignment->getReviewFormId()}" class="icon">{icon name="comment"}</a>
			{else}
				 {icon name="comment" disabled="disabled"}
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
{else}{* $reviewAssignment->getReviewFormId() *}
	<tr valign="top">
		<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
		<td><span class="instruct">{translate key="reviewer.article.enterReviewA"}</span></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			{translate key="common.chatRoom"}&nbsp; 
			{if $confirmedStatus and not $declined}
				<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$articleId|to_array:$reviewId}');" class="icon">{icon name="comment"}</a>
			{else}
				 {icon name="comment" disabled="disabled"}
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
{/if}{* $reviewAssignment->getReviewFormId() *}
<tr valign="top">
	<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.uploadFile"}</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<table class="data" width="100%">
			{assign var="reviewerFile" value=$reviewAssignment->getReviewerFile()}
			{if $reviewerFile}
				{assign var=uploadedFileExists value="1"}
				<tr valign="top">
				<td class="label" width="20%">
					{translate key="reviewer.article.uploadedFile"}
				</td>
				<td class="value" width="80%">
					<a href="{url op="downloadFile" path=$reviewId|to_array:$articleId:$reviewerFile->getFileId()}" class="file">{$reviewerFile->getFileName()|escape}</a>
					&nbsp;{$reviewerFile->getDateModified()|date_format:$dateFormatLong}&nbsp;
					{if ($submission->getRecommendation() === null || $submission->getRecommendation() === '') && (!$submission->getCancelled())}
						<a class="action" href="{url op="deleteReviewerVersion" path=$reviewId|to_array:$reviewerFile->getFileId():$articleId}">{translate key="common.delete"}</a>
					{/if}
				</td>
				</tr>
			{else}
				<tr valign="top">
				<td class="label" width="20%">
					{translate key="reviewer.article.uploadedFile"}
				</td>
				<td class="nodata">
					{translate key="common.none"}
				</td>
				</tr>
			{/if}
		</table>
		&nbsp;
		{if $submission->getRecommendation() === null || $submission->getRecommendation() === ''}
			<form method="post" action="{url op="uploadReviewerVersion"}" enctype="multipart/form-data">
				<input type="hidden" name="reviewId" value="{$reviewId|escape}" />
				<input type="file" name="upload" {if not $confirmedStatus or $declined or $submission->getCancelled()}disabled="disabled"{/if} class="uploadField" />
				<input type="submit" name="submit" value="{if $uploadedFileExists}{translate key="common.replaceFile"}{else}{translate key="common.upload"}{/if}" {if not $confirmedStatus or $declined or $submission->getCancelled()}disabled="disabled"{/if} class="button" />
			</form>

			{if $currentJournal->getSetting('showEnsuringLink')}
			<span class="instruct">
				<a class="action" href="javascript:openHelp('{get_help_id key="editorial.sectionEditorsRole.review.blindPeerReview" url="true"}')">{translate key="reviewer.article.ensuringBlindReview"}</a>
			</span>
			{/if}
		{/if}
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr valign="top">
	<td>{$currentStep|escape}.{assign var="currentStep" value=$currentStep+1}</td>
	<td><span class="instruct">{translate key="reviewer.article.selectRecommendation"}</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<table class="data" width="100%">
			<tr valign="top">
				<td class="label" width="30%">{translate key="submission.recommendation"}</td>
				<td class="value" width="70%">
					{if $submission->getRecommendation() !== null && $submission->getRecommendation() !== ''}
						{assign var="recommendation" value=$submission->getRecommendation()}
						<strong>{translate key=$reviewerRecommendationOptions.$recommendation}</strong>&nbsp;&nbsp;
						{$submission->getDateCompleted()|date_format:$dateFormatShort}
					{else}
						<form name="recommendation" method="post" action="{url op="recordRecommendation"}">
							<input type="hidden" name="reviewId" value="{$reviewId|escape}" />
							<select name="recommendation" {if not $confirmedStatus or $declined or $submission->getCancelled() or (!$reviewFormResponseExists and !$uploadedFileExists)}disabled="disabled"{/if} class="selectMenu">
								{html_options_translate options=$reviewerRecommendationOptions selected=''}
							</select>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="submit" name="submit" onclick="return confirmSubmissionCheck()" class="button" value="{translate key="reviewer.article.submitReview"}" {if not $confirmedStatus or $declined or $submission->getCancelled() or (!$reviewFormResponseExists and !$reviewAssignment->getMostRecentPeerReviewComment() and !$uploadedFileExists)}disabled="disabled"{/if} />
						</form>					
				{/if}
				</td>		
			</tr>
		</table>
	</td>
</tr>
</table>
</div>
{/if}
<div class="separator"></div>
<div id="proposalDetails">
<table class="listing" width="100%">
<h3>{translate key="article.metadata"}</h3>
<table class="listing" width="100%">
    <tr valign="top">
        <td colspan="5" class="headseparator">&nbsp;</td>
    </tr>
{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top">
        <td class="label">{if $author->getPrimaryContact()}Investigator{else}Co-Investigator{/if}</td>
        <td class="value">
			{$author->getFullName()|escape}<br />
			{$author->getEmail()|escape}<br />
			{if ($author->getAffiliation()) != ""}{$author->getAffiliation()|escape}<br/>{/if}
			{if ($author->getPhoneNumber()) != ""}{$author->getPhoneNumber()}{/if}
        </td>
    </tr>
{/foreach}
	<tr valign="top"><td colspan="2"><h4>{translate key="submission.titleAndAbstract"}</h4></td></tr>
	
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.scientificTitle"}</td>
        <td class="value">{$abstract->getScientificTitle()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.publicTitle"}</td>
        <td class="value">{$abstract->getPublicTitle()}</td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.background"}</td>
        <td class="value">{$abstract->getBackground()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.objectives"}</td>
        <td class="value">{$abstract->getObjectives()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.studyMethods"}</td>
        <td class="value">{$abstract->getStudyMethods()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.expectedOutcomes"}</td>
        <td class="value">{$abstract->getExpectedOutcomes()}</td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.keywords"}</td>
        <td class="value">{$abstract->getKeywords()}</td>
    </tr>
	<tr valign="top"><td colspan="2"><h4>{translate key="submission.proposalDetails"}</h4></td></tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value">{$submission->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($submission->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.studentInstitution"} {$submission->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.academicDegree"} {$submission->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}

    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.startDate"}</td>
        <td class="value">{$submission->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.endDate"}</td>
        <td class="value">{$submission->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.fundsRequired"}</td>
        <td class="value">{$submission->getLocalizedFundsRequired()} {$submission->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.nationwide"}</td>
        <td class="value">{$submission->getLocalizedNationwide()}</td>
    </tr>
    {if ($submission->getLocalizedNationwide() == "No") || ($submission->getLocalizedNationwide() == "Yes, with randomly selected regions")}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}

    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.multiCountryResearch"}</td>
        <td class="value">{$submission->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($submission->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{$submission->getLocalizedWithHumanSubjects()}</td>
    </tr>
    {if ($submission->getLocalizedWithHumanSubjects()) == "Yes"}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if ($submission->getLocalizedProposalType())}
        		{$submission->getLocalizedProposalTypeText()}
        	{/if}      
        </td>
    </tr>
    {/if}
    
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.researchField"}</td>
        <td class="value">
        	{if $submission->getLocalizedResearchField()}
        		{$submission->getLocalizedResearchFieldText()}
        	{/if}
        </td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.dataCollection"}</td>
        <td class="value">{$submission->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">{$submission->getLocalizedReviewedByOtherErc()}{if $submission->getLocalizedOtherErcDecision() != 'NA'}({$submission->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>

	<tr><td colspan="2"><br/><h4>Source(s) of monetary or material support</h4></td></tr>
    
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.industryGrant"}</td>
        <td class="value">{$submission->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($submission->getLocalizedIndustryGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.internationalGrant"}</td>
        <td class="value">{$submission->getLocalizedInternationalGrant()}</td>
    </tr>
    {if ($submission->getLocalizedInternationalGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if $submission->getLocalizedInternationalGrantName()}
        		{$submission->getLocalizedInternationalGrantNameText()} 
        	{/if}
        </td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.mohGrant"}</td>
        <td class="value">{$submission->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.governmentGrant"}</td>
        <td class="value">{$submission->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($submission->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.universityGrant"}</td>
        <td class="value">{$submission->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.selfFunding"}</td>
        <td class="value">{$submission->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.otherGrant"}</td>
        <td class="value">{$submission->getLocalizedOtherGrant()}</td>
    </tr>
    {if ($submission->getLocalizedOtherGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getLocalizedSpecifyOtherGrant()}</td>
    </tr>    
    {/if}
</table>
<div class="separator"></div>

<br />

<h3><br/>{translate key="proposal.riskAssessment"}</h3>
<div id=riskAssessments>
	<table class="listing" width="100%">
	    <tr valign="top">
        	<td colspan="2" class="headseparator">&nbsp;</td>
   		</tr>
    	<tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
    	<tr valign="top" id="identityRevealedField">
    	    <td class="label" width="30%">{translate key="proposal.identityRevealed"}</td>
    	    <td class="value">{if $riskAssessment->getIdentityRevealed() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="unableToConsentField">
        	<td class="label" width="20%">{translate key="proposal.unableToConsent"}</td>
        	<td class="value">{if $riskAssessment->getUnableToConsent() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="under18Field">
    	    <td class="label" width="20%">{translate key="proposal.under18"}</td>
    	    <td class="value">{if $riskAssessment->getUnder18() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="dependentRelationshipField">
    	    <td class="label" width="20%">{translate key="proposal.dependentRelationship"}</td>
    	    <td class="value">{if $riskAssessment->getDependentRelationship() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="ethnicMinorityField">
    	    <td class="label" width="20%">{translate key="proposal.ethnicMinority"}</td>
    	    <td class="value">{if $riskAssessment->getEthnicMinority() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="impairmentField">
    	    <td class="label" width="20%">{translate key="proposal.impairment"}</td>
    	    <td class="value">{if $riskAssessment->getImpairment() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="pregnantField">
    	    <td class="label" width="20%">{translate key="proposal.pregnant"}</td>
    	    <td class="value">{if $riskAssessment->getPregnant() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    	<tr valign="top" id="newTreatmentField">
    	    <td class="label" width="20%">{translate key="proposal.newTreatment"}</td>
    	    <td class="value">{if $riskAssessment->getNewTreatment() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="bioSamplesField">
    	    <td class="label" width="20%">{translate key="proposal.bioSamples"}</td>
    	    <td class="value">{if $riskAssessment->getBioSamples() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="radiationField">
    	    <td class="label" width="20%">{translate key="proposal.radiation"}</td>
    	    <td class="value">{if $riskAssessment->getRadiation() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="distressField">
    	    <td class="label" width="20%">{translate key="proposal.distress"}</td>
    	    <td class="value">{if $riskAssessment->getDistress() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="inducementsField">
    	    <td class="label" width="20%">{translate key="proposal.inducements"}</td>
    	    <td class="value">{if $riskAssessment->getInducements() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="sensitiveInfoField">
    	    <td class="label" width="20%">{translate key="proposal.sensitiveInfo"}</td>
    	    <td class="value">{if $riskAssessment->getSensitiveInfo() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="deceptionField">
    	    <td class="label" width="20%">{translate key="proposal.deception"}</td>
    	    <td class="value">{if $riskAssessment->getDeception() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="reproTechnologyField">
    	    <td class="label" width="20%">{translate key="proposal.reproTechnology"}</td>
    	    <td class="value">{if $riskAssessment->getReproTechnology() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="geneticsField">
    	    <td class="label" width="20%">{translate key="proposal.genetic"}</td>
    	    <td class="value">{if $riskAssessment->getGenetic() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="stemCellField">
    	    <td class="label" width="20%">{translate key="proposal.stemCell"}</td>
    	    <td class="value">{if $riskAssessment->getStemCell() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="biosafetyField">
    	    <td class="label" width="20%">{translate key="proposal.biosafety"}</td>
    	    <td class="value">{if $riskAssessment->getBiosafety() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    	<tr valign="top" id="riskLevelField">
    	    <td class="label" width="20%">{translate key="proposal.riskLevel"}</td>
    	    <td class="value">
    	    {if $riskAssessment->getRiskLevel() == "1"}{translate key="proposal.riskLevelNoMore"}
    	    {elseif $riskAssessment->getRiskLevel() == "2"}{translate key="proposal.riskLevelMinore"}
    	    {elseif $riskAssessment->getRiskLevel() == "3"}{translate key="proposal.riskLevelMore"}
    	    {/if}
    	    </td>
    	</tr>
    	{if $riskAssessment->getRiskLevel() != '1'}
    	<tr valign="top" id="listRisksField">
    	    <td class="label" width="20%">{translate key="proposal.listRisks"}</td>
    	    <td class="value">{$riskAssessment->getListRisks()}</td>
    	</tr>
    	<tr valign="top" id="howRisksMinimizedField">
    	    <td class="label" width="20%">{translate key="proposal.howRisksMinimized"}</td>
    	    <td class="value">{$riskAssessment->getHowRisksMinimized()}</td>
    	</tr>
    	{/if}
    	<tr valign="top" id="riskApplyToField">
    	    <td class="label" width="20%">{translate key="proposal.riskApplyTo"}</td>
    	    <td class="value">
    	    {assign var="firstRisk" value="0"}
    	    {if $riskAssessment->getRisksToTeam() == '1'}
    	    	{if $firstRisk == '1'} & {/if}{translate key="proposal.researchTeam"}
    	    	{assign var="firstRisk" value="1"}	
    	    {/if}
    	    {if $riskAssessment->getRisksToSubjects() == '1'}
    	    	{if $firstRisk == '1'} & {/if}{translate key="proposal.researchSubjects"}
    	    	{assign var="firstRisk" value="1"}
    	    {/if}
    	    {if $riskAssessment->getRisksToCommunity() == '1'}
    	    	{if $firstRisk == '1'} & {/if}{translate key="proposal.widerCommunity"}
    	    	{assign var="firstRisk" value="1"}
    	    {/if}
    	    {if $riskAssessment->getRisksToTeam() != '1' && $riskAssessment->getRisksToSubjects() != '1' && $riskAssessment->getRisksToCommunity() != '1'}
    	    	{translate key="proposal.nobody"}
    	    {/if}
    	    </td>
    	</tr>
    	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.potentialBenefits"}</b></td></tr>
    	<tr valign="top" id="benefitsFromTheProjectField">
    	    <td class="label" width="20%">{translate key="proposal.benefitsFromTheProject"}</td>
    	    <td class="value">
    	    {assign var="firstBenefits" value="0"}
    	    {if $riskAssessment->getBenefitsToParticipants() == '1'}
    	    	{if $firstBenefits == '1'} & {/if}{translate key="proposal.directBenefits"}
    	    	{assign var="firstBenefits" value="1"}
    	    {/if}
    	    {if $riskAssessment->getKnowledgeOnCondition() == '1'}
    	    	{if $firstBenefits == '1'} & {/if}{translate key="proposal.participantCondition"}
    	    	{assign var="firstBenefits" value="1"}
    	    {/if}
    	    {if $riskAssessment->getKnowledgeOnDisease() == '1'}
    	    	{if $firstBenefits == '1'} & {/if}{translate key="proposal.diseaseOrCondition"}
    	    	{assign var="firstBenefits" value="1"}
    	    {/if}
    	    {if $riskAssessment->getBenefitsToParticipants() != '1' && $riskAssessment->getKnowledgeOnCondition() != '1' && $riskAssessment->getKnowledgeOnDisease() != '1'}
    	    	{translate key="proposal.noBenefits"}
    	    {/if}
    	    </td>
    	</tr>
    	<tr valign="top" id="multiInstitutionsField">
    	    <td class="label" width="20%">{translate key="proposal.multiInstitutions"}</td>
    	    <td class="value">{if $riskAssessment->getMultiInstitutions() == "1"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    	<tr valign="top" id="conflictOfInterestField">
    	    <td class="label" width="20%">{translate key="proposal.conflictOfInterest"}</td>
    	    <td class="value">{if $riskAssessment->getConflictOfInterest() == "1"}{translate key="common.yes"}{elseif $riskAssessment->getConflictOfInterest() == "3"}{translate key="common.notSure"}{else}{translate key="common.no"}{/if}</td>
    	</tr>
    </table>
</div>

<div class="separator"></div>


{/if}
{if $journal->getLocalizedSetting('reviewGuidelines') != ''}
<div class="separator"></div>
<div id="reviewerGuidelines">
<h3>{translate key="reviewer.article.reviewerGuidelines"}</h3>
<p>{$journal->getLocalizedSetting('reviewGuidelines')|nl2br}</p>
</div>
{/if}

{include file="common/footer.tpl"}


