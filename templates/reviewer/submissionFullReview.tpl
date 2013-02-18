{**
 * submissionForFullReview.tpl
 * $Id$
 *}
{strip}
{assign var="articleId" value=$submission->getArticleId()}
{translate|assign:"pageTitleTranslated" key="submission.page.fullReview" id=$articleId}
{assign var="pageCrumbTitle" value="submission.review"}
{include file="common/header.tpl"}
{/strip}


<script type="text/javascript">

</script>

<div id="submissionToBeReviewed">

<h3>{translate key="reviewer.article.submissionToBeReviewed"}</h3>
<table width="100%" class="data">
<tr valign="top">
	<td width="30%" class="label">Proposal ID</td>
	<td width="70%" class="value">{$submission->getLocalizedWhoId()|strip_unsafe_html}</td>
</tr>
<tr valign="top">
	<td width="30%" class="label">{translate key="article.title"}</td>
	<td width="70%" class="value">{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
</tr>
<tr valign="top">
	<td class="label">{translate key="article.journalSection"}</td>
	<td class="value">{$submission->getSectionTitle()|escape}</td>
</tr>

</table>
</div>
<div class="separator"></div>

<div id="files">
<h3>Files / ຟາຍເອກະສານ</h3>
	<table width="100%" class="data">
	{if ($confirmedStatus and not $declined) or not $journal->getSetting('restrictReviewerFileAccess')}
		<tr valign="top">
			<td width="30%" class="label">
				{translate key="submission.submissionManuscript"}
			</td>
			<td class="value" width="70%">
				{if $reviewFile}
				{if $submission->getDateConfirmed() or not $journal->getSetting('restrictReviewerAccessToFile')}
					<a href="{url op="downloadFileFullReview" path=$reviewId|to_array:$articleId:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file">{$reviewFile->getFileName()|escape}</a>
				{else}{$reviewFile->getFileName()|escape}{/if}
				&nbsp;&nbsp;{$reviewFile->getDateModified()|date_format:$dateFormatLong}
				{else}
				{translate key="common.none"} / ບໍ່ມີຫຍັງ
				{/if}
			</td>
		</tr>
		<tr valign="top">
			<td class="label">
				{translate key="article.suppFiles"}
			</td>
			<td class="value">
				{assign var=sawSuppFile value=0}
				{foreach from=$suppFiles item=suppFile}
					{if $suppFile->getShowReviewers() }
						{assign var=sawSuppFile value=1}
						<a href="{url op="downloadFileFullReview" path=$reviewId|to_array:$articleId:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a><cite>&nbsp;&nbsp;({$suppFile->getType()})</cite><br />
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

<div class="separator"></div>
<div id="titleAndAbstract">
<h4>Proposal Details</h4>

<table width="100%" class="data">
   <tr valign="top">
        <td class="label" width="30%"><br/>{translate key="proposal.scientificTitle"}</td>
        <td class="value" width="70%"><br/>{$submission->getLocalizedTitle()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.publicTitle"}</td>
        <td class="value"><br/>{$submission->getLocalizedPublicTitle()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value"><br/>{$submission->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($submission->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{translate key="proposal.studentInstitution"}: {$submission->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{translate key="proposal.academicDegree"}: {$submission->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.abstract"}ໍ້</td>
        <td class="value"><br/>{$submission->getLocalizedAbstract()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.keywords"}</td>
        <td class="value"><br/>{$submission->getLocalizedKeywords()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.startDate"}</td>
        <td class="value"><br/>{$submission->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.endDate"}</td>
        <td class="value"><br/>{$submission->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.fundsRequired"}</td>
        <td class="value"><br/>{$submission->getLocalizedFundsRequired()} {$submission->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		<br/>{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td class="label" width="20%"><br/>{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		<br/>{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.nationwide"}</td>
        <td class="value"><br/>{$submission->getLocalizedNationwide()}</td>
    </tr>
    {if ($submission->getLocalizedNationwide() == "No") || ($submission->getLocalizedNationwide() == "Yes, with randomly selected regions")}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.multiCountryResearch"}</td>
        <td class="value"><br/>{$submission->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($submission->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.withHumanSubjects"}</td>
        <td class="value"><br/>{$submission->getLocalizedWithHumanSubjects()}</td>
    </tr>
    {if ($submission->getLocalizedWithHumanSubjects()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">
        	{if ($submission->getLocalizedProposalType())}
        		{$submission->getLocalizedProposalTypeText()}
        	{/if}         
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.researchField"}</td>
        <td class="value">
            {if $submission->getLocalizedResearchField()}
        		<br/>{$submission->getLocalizedResearchFieldText()}
        	{/if}      
        </td>
    </tr>  

     <tr valign="top">
        <td class="label"><br/>{translate key="proposal.dataCollection"}</td>
        <td class="value"><br/>{$submission->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value"><br/>{$submission->getLocalizedReviewedByOtherErc()}{if $submission->getLocalizedOtherErcDecision() != 'NA'}({$submission->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>
	<tr><td colspan="2"><br/><h4>Source(s) of monetary or material support້</h4></td></tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.industryGrant"}</td>
        <td class="value"><br/>{$submission->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($submission->getLocalizedIndustryGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.internationalGrant"}</td>
        <td class="value"><br/>{$submission->getLocalizedInternationalGrant()}</td>
    </tr>
    {if ($submission->getLocalizedInternationalGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">
        	{if $submission->getLocalizedInternationalGrantName()}
        		{$submission->getLocalizedInternationalGrantNameText()} 
        	{/if}
        </td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.mohGrant"}</td>
        <td class="value"><br/>{$submission->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.governmentGrant"}</td>
        <td class="value"><br/>{$submission->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($submission->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.universityGrant"}</td>
        <td class="value"><br/>{$submission->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.selfFunding"}</td>
        <td class="value"><br/>{$submission->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td class="label"><br/>{translate key="proposal.otherGrant"}</td>
        <td class="value"><br/>{$submission->getLocalizedOtherGrant()}</td>
    </tr>
    {if ($submission->getLocalizedOtherGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedSpecifyOtherGrant()}</td>
    </tr>    
    {/if}
</table>
</div>

{if $journal->getLocalizedSetting('reviewGuidelines') != ''}
<div class="separator"></div>
<div id="reviewerGuidelines">
<h3>{translate key="reviewer.article.reviewerGuidelines"}</h3>
<p>{$journal->getLocalizedSetting('reviewGuidelines')|nl2br}</p>
</div>
{/if}

{include file="common/footer.tpl"}


