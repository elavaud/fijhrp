{**
 * metadata.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission metadata table. Non-form implementation.
 *}

{assign var="status" value=$submission->getSubmissionStatus()}
{assign var="decision" value=$submission->getMostRecentDecision()}

{if $canEditMetadata && $isSectionEditor && $status!=PROPOSAL_STATUS_COMPLETED && $status!=PROPOSAL_STATUS_ARCHIVED && $decision!=SUBMISSION_EDITOR_DECISION_EXEMPTED && $decision!=SUBMISSION_EDITOR_DECISION_ACCEPT}
	<p><a href="{url op="viewMetadata" path=$submission->getId()}" class="action">{translate key="submission.editMetadata"}</a></p>
	{call_hook name="Templates::Submission::Metadata::Metadata::AdditionalEditItems"}
{/if}

<div id="authors">
<h4>{*translate key="article.authors"*}Investigator(s)</h4>
	
<table width="100%" class="data">
	{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top">
		<td {if $author->getPrimaryContact()}title="First investigator of the research."{else}title="Co-Investigator of the research."{/if}width="20%" class="label">{*translate key="user.name"*}{if $author->getPrimaryContact()}[?] Investigator{else}[?] Co-Investigator{/if}</td>
		<td width="80%" class="value">
			{assign var=emailString value=$author->getFullName()|concat:" <":$author->getEmail():">"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getLocalizedTitle()|strip_tags articleId=$submission->getId()}
			{$author->getFullName()|escape} {icon name="mail" url=$url}<br />
			{$author->getEmail()|escape}<br />
			{if ($author->getLocalizedAffiliation()) != ""}{$author->getLocalizedAffiliation()|escape}<br />{/if}
			{if $author->getPrimaryContact()}{$submission->getLocalizedAuthorPhoneNumber()}
			{else}
			{if ($author->getUrl()) != ""}{$author->getUrl()|escape}<br />{/if}
			{/if}
		</td>
	</tr>

        
	{if !$smarty.foreach.authors.last}
		<tr>
			<td colspan="2" class="separator">&nbsp;</td>
		</tr>
	{/if}
	{/foreach}
</table>
</div>

<div id="titleAndAbstract">
<h4>Proposal Details</h4>

<table width="100%" class="data">
   <tr valign="top">
        <td title="Scientific title of the study as it appears in the protocol submitted for funding and ethical review. This title should contain information on population, intervention, comparator and outcome(s)." class="label" width="20%">[?] {translate key="proposal.scientificTitle"}</td>
        <td class="value" width="80%">{$submission->getLocalizedTitle()}</td>
    </tr>
    <tr valign="top">
        <td title="Title intended for the lay public in easily understood language." class="label">[?] {translate key="proposal.publicTitle"}</td>
        <td class="value">{$submission->getLocalizedPublicTitle()}</td>
    </tr>
    <tr valign="top">
        <td title="Is the research undertaken as part of academic degree requirements?" class="label">[?] {translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value">{$submission->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($submission->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td title="Institution where the student is enrolled." class="value">[?] {translate key="proposal.studentInstitution"}: {$submission->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td title="Academic degree in which the student is enrolled." class="value">[?] {translate key="proposal.academicDegree"} {$submission->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}
    <tr valign="top">
        <td title="Short description of the primary purpose of the protocol, including a brief statement of the study hypothesis. It also includes publication/s details (link/reference), if any." class="label">[?] {translate key="proposal.abstract"}</td>
        <td class="value">{$submission->getLocalizedAbstract()}</td>
    </tr>
    <tr valign="top">
        <td title="Significant or descriptive words." class="label">[?] {translate key="proposal.keywords"}</td>
        <td class="value">{$submission->getLocalizedKeywords()}</td>
    </tr>
    <tr valign="top">
        <td title="Start date of the research." class="label">[?] {translate key="proposal.startDate"}</td>
        <td class="value">{$submission->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td title="End date of the research." class="label">[?] {translate key="proposal.endDate"}</td>
        <td class="value">{$submission->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td title="Funds required for the research." class="label">[?] {translate key="proposal.fundsRequired"}</td>
        <td class="value">{$submission->getLocalizedFundsRequired()} {$submission->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td title="The individual, organization, group or other legal entity which takes responsibility for initiating, managing and/or financing a study.
The Primary Sponsor is responsible for ensuring that the research is properly registered. The Primary Sponsor may or may not be the main funder." class="label">[?] {translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td title="Additional individuals, organizations or other legal persons, if any, that have agreed with the primary sponsor to take on responsibilities of sponsorship. A secondary sponsor may have agreed: 
	• to take on all the responsibilities of sponsorship jointly with the primary sponsor; or 
	• to form a group with the primary sponsor in which the responsibilities of sponsorship are allocated among the members of the group; or 
	• to act as the sponsor’s legal representative in relation to some or all of the trial sites; or 
	• to take responsibility for the accuracy of trial registration information submitted." class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td title="Is it a nationwide research?" class="label">[?] {translate key="proposal.nationwide"}</td>
        <td class="value">{$submission->getLocalizedNationwide()}</td>
    </tr>
    {if ($submission->getLocalizedNationwide() == "No") || ($submission->getLocalizedNationwide() == "Yes, with randomly selected regions")}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}
    <tr valign="top">
        <td title="Is the research involving patients from different countries?"  class="label">[?] {translate key="proposal.multiCountryResearch"}</td>
        <td class="value">{$submission->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($submission->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td title="Does the research involve human subject?" class="label">[?] {translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{$submission->getLocalizedWithHumanSubjects()}</td>
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
    
    <tr title="Fields of research." valign="top">
        <td class="label">[?] {translate key="proposal.researchField"}</td>
        <td class="value">
            {if $submission->getLocalizedResearchField()}
        		{$submission->getLocalizedResearchFieldText()}
        	{/if}
        </td>
    </tr>

     <tr valign="top">
        <td title="Data collection used for the research." class="label">[?] {translate key="proposal.dataCollection"}</td>
        <td class="value">{$submission->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td title="Has the proposal been reviewed by another ERC, and if yes, status of the other ERC decision" class="label">[?] {translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">{$submission->getLocalizedReviewedByOtherErc()}{if $submission->getLocalizedOtherErcDecision() != 'NA'}({$submission->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>

	<tr><td colspan="2"><br/><h4>Source(s) of monetary or material support</h4></td></tr>

    <tr valign="top">
        <td class="label">[?] {translate key="proposal.industryGrant"}</td>
        <td class="value">{$submission->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($submission->getLocalizedIndustryGrant()) == "Yes"}
     <tr title="Any grants comming from an industry." valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td title="Any grant coming from an agency (World Health Organization, Asian Development Bank...)." class="label">[?] {translate key="proposal.internationalGrant"}</td>
        <td class="value">{$submission->getLocalizedInternationalGrant()}</td>
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
        <td title="Grant comming from the Ministry of Health." class="label">[?] {translate key="proposal.mohGrant"}</td>
        <td class="value">{$submission->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td title="Grant coming from the government (Ministry of Health excluded)." class="label">[?] {translate key="proposal.governmentGrant"}</td>
        <td class="value">{$submission->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($submission->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td title="Grant coming from a university." class="label">[?] {translate key="proposal.universityGrant"}</td>
        <td class="value">{$submission->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td title="Is the research self funded?" class="label">[?] {translate key="proposal.selfFunding"}</td>
        <td class="value">{$submission->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td title="Any other grants." class="label">[?] {translate key="proposal.otherGrant"}</td>
        <td class="value">{$submission->getLocalizedOtherGrant()}</td>
    </tr>
    {if ($submission->getLocalizedOtherGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedSpecifyOtherGrant()}</td>
    </tr>    
    {/if}
</table>
</div>

