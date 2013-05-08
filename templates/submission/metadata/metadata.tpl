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

{if $canEditMetadata && $isSectionEditor && $status!=PROPOSAL_STATUS_COMPLETED && $status!=PROPOSAL_STATUS_ARCHIVED && $decision!=SUBMISSION_SECTION_DECISION_EXEMPTED && $decision!=SUBMISSION_SECTION_DECISION_APPROVED}
	<p><a href="{url op="viewMetadata" path=$submission->getId()}" class="action">{translate key="submission.editMetadata"}</a></p>
	{call_hook name="Templates::Submission::Metadata::Metadata::AdditionalEditItems"}
{/if}

<div id="authors">
<h4>{translate key="article.authors"}</h4>
	
<table width="100%" class="data">
	{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top">
		<td {if $author->getPrimaryContact()}title="First investigator of the research."{else}title="Co-Investigator of the research."{/if}width="20%" class="label">{*translate key="user.name"*}{if $author->getPrimaryContact()}[?] Investigator{else}[?] Co-Investigator{/if}</td>
		<td width="80%" class="value">
			{assign var=emailString value=$author->getFullName()|concat:" <":$author->getEmail():">"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$abstract->getScientificTitle()|strip_tags articleId=$submission->getId()}
			{$author->getFullName()|escape} {icon name="mail" url=$url}<br />
			{$author->getEmail()|escape}<br />
			{if ($author->getAffiliation()) != ""}{$author->getAffiliation()|escape}<br />{/if}
			{if ($author->getPhoneNumber()) != ""}{$author->getPhoneNumber()}
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
<h4>{translate key="submission.titleAndAbstract"}</h4>
        
<table width="100%" class="data">
    <tr valign="top">
        <td title="{translate key="proposal.scientificTitleInstruct"}" class="label" width="20%">[?] {translate key="proposal.scientificTitle"}</td>
        <td class="value" width="80%">{$abstract->getScientificTitle()}</td>
    </tr>
	<tr valign="top">
        <td title="{translate key="proposal.publicTitleInstruct"}" class="label">[?] {translate key="proposal.publicTitle"}</td>
        <td class="value">{$abstract->getPublicTitle()}</td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr valign="top">
        <td title="{translate key="proposal.backgroundInstruct"}" class="label">[?] {translate key="proposal.background"}</td>
        <td class="value">{$abstract->getBackground()}</td>
    </tr>
    <tr valign="top">
        <td title="{translate key="proposal.objectivesInstruct"}" class="label">[?] {translate key="proposal.objectives"}</td>
        <td class="value">{$abstract->getObjectives()}</td>
    </tr>
    <tr valign="top">
        <td title="{translate key="proposal.studyMethodsInstruct"}" class="label">[?] {translate key="proposal.studyMethods"}</td>
        <td class="value">{$abstract->getStudyMethods()}</td>
    </tr>
    <tr valign="top">
        <td title="{translate key="proposal.expectedOutcomesInstruct"}" class="label">[?] {translate key="proposal.expectedOutcomes"}</td>
        <td class="value">{$abstract->getExpectedOutcomes()}</td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
    <tr valign="top">
        <td title="{translate key="proposal.keywordsInstruct"}" class="label">[?] {translate key="proposal.keywords"}</td>
        <td class="value">{$abstract->getKeywords()}</td>
    </tr>
</table>
</div>

<div id="proposalDetails">

<h4>{translate key="submission.proposalDetails"}</h4>

<table width="100%" class="data">
    <tr valign="top">
        <td title="{translate key="proposal.studentInitiatedResearchInstruct"}" class="label">[?] {translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value">{$submission->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($submission->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td title="{translate key="proposal.studentInstitutionInstruct"}" class="value">[?] {translate key="proposal.studentInstitution"}: {$submission->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td title="{translate key="proposal.academicDegreeInstruct"}" class="value">[?] {translate key="proposal.academicDegree"} {$submission->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}
    <tr valign="top">
        <td title="{translate key="proposal.startDateInstruct"}" class="label">[?] {translate key="proposal.startDate"}</td>
        <td class="value">{$submission->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td title="{translate key="proposal.endDateInstruct"}" class="label">[?] {translate key="proposal.endDate"}</td>
        <td class="value">{$submission->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td title="{translate key="proposal.primarySponsorInstruct"}" class="label">[?] {translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td title="{translate key="proposal.secondarySponsorsInstruct"}" class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label">{translate key="proposal.nationwide"}</td>
        <td class="value">{$submission->getLocalizedNationwide()}</td>
    </tr>
    {if ($submission->getLocalizedNationwide() == "No") || ($submission->getLocalizedNationwide() == "Yes, with randomly selected regions")}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}
    <tr valign="top">
        <td title="{translate key="proposal.multiCountryResearchInstruct"}"  class="label">[?] {translate key="proposal.multiCountryResearch"}</td>
        <td class="value">{$submission->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($submission->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td class="label">[?] {translate key="proposal.withHumanSubjects"}</td>
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
    
    <tr valign="top">
        <td class="label">{translate key="proposal.researchField"}</td>
        <td class="value">
            {if $submission->getLocalizedResearchField()}
        		{$submission->getLocalizedResearchFieldText()}
        	{/if}
        </td>
    </tr>

    <tr valign="top">
        <td class="label">{translate key="proposal.dataCollection"}</td>
        <td class="value">{$submission->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td class="label">[?] {translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">{$submission->getLocalizedReviewedByOtherErc()}{if $submission->getLocalizedOtherErcDecision() != 'NA'}({$submission->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>
</table>
</div>

<div id="sourceOfMonetary">

<h4>{translate key="proposal.sourceOfMonetary"}</h4>

<table width="100%" class="data">
    <tr valign="top">
        <td class="label">{translate key="proposal.fundsRequired"}</td>
        <td class="value">{$submission->getLocalizedFundsRequired()} {$submission->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.industryGrant"}</td>
        <td class="value">{$submission->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($submission->getLocalizedIndustryGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td class="label">{translate key="proposal.internationalGrant"}</td>
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
        <td class="label">[?] {translate key="proposal.mohGrant"}</td>
        <td class="value">{$submission->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.governmentGrant"}</td>
        <td class="value">{$submission->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($submission->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label">{translate key="proposal.universityGrant"}</td>
        <td class="value">{$submission->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.selfFunding"}</td>
        <td class="value">{$submission->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.otherGrant"}</td>
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

<h4><br/>{translate key="proposal.riskAssessment"}</h4>
<div id=riskAssessments>
	<table class="listing" width="100%">
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