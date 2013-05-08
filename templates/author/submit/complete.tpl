{**
 * complete.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * The submission process has been completed; notify the author.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="author.track"}
{include file="common/header.tpl"}
{/strip}

<div id="submissionComplete">

<p style="font-size: larger;">{translate key="author.submit.submissionComplete" journalTitle=$journal->getLocalizedTitle()}</p>

<h3>{translate key="article.metadata"}</h3>
<table class="listing" width="100%">
    <tr valign="top">
        <td colspan="5" class="headseparator">&nbsp;</td>
    </tr>
{foreach name=authors from=$article->getAuthors() item=author}
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
        <td class="value">{$article->getLocalizedStudentInitiatedResearch()}</td>
    </tr>
    {if ($article->getLocalizedStudentInitiatedResearch()) == "Yes"}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.studentInstitution"} {$article->getLocalizedStudentInstitution()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.academicDegree"} {$article->getLocalizedAcademicDegree()}</td>
    </tr>  
    {/if}

    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.startDate"}</td>
        <td class="value">{$article->getLocalizedStartDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.endDate"}</td>
        <td class="value">{$article->getLocalizedEndDate()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.fundsRequired"}</td>
        <td class="value">{$article->getLocalizedFundsRequired()} {$article->getLocalizedSelectedCurrency()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $article->getLocalizedPrimarySponsor()}
        		{$article->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $article->getLocalizedSecondarySponsors()}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $article->getLocalizedSecondarySponsors()}
        		{$article->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.nationwide"}</td>
        <td class="value">{$article->getLocalizedNationwide()}</td>
    </tr>
    {if ($article->getLocalizedNationwide() == "No") || ($article->getLocalizedNationwide() == "Yes, with randomly selected regions")}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedProposalCountryText()}</td>
    </tr>
    {/if}

    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.multiCountryResearch"}</td>
        <td class="value">{$article->getLocalizedMultiCountryResearch()}</td>
    </tr>
	{if ($article->getLocalizedMultiCountryResearch()) == "Yes"}
	<tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{$article->getLocalizedWithHumanSubjects()}</td>
    </tr>
    {if ($article->getLocalizedWithHumanSubjects()) == "Yes"}
    <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if ($article->getLocalizedProposalType())}
        		{$article->getLocalizedProposalTypeText()}
        	{/if}      
        </td>
    </tr>
    {/if}
    
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.researchField"}</td>
        <td class="value">
        	{if $article->getLocalizedResearchField()}
        		{$article->getLocalizedResearchFieldText()}
        	{/if}
        </td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.dataCollection"}</td>
        <td class="value">{$article->getLocalizedDataCollection()}</td>
    </tr>   
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">{$article->getLocalizedReviewedByOtherErc()}{if $article->getLocalizedOtherErcDecision() != 'NA'}({$article->getLocalizedOtherErcDecision()}){/if}</td>
    </tr>

	<tr><td colspan="2"><br/><h4>Source(s) of monetary or material support</h4></td></tr>
    
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.industryGrant"}</td>
        <td class="value">{$article->getLocalizedIndustryGrant()}</td>
    </tr>
    {if ($article->getLocalizedIndustryGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedNameOfIndustry()}</td>
    </tr>   
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.internationalGrant"}</td>
        <td class="value">{$article->getLocalizedInternationalGrant()}</td>
    </tr>
    {if ($article->getLocalizedInternationalGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if $article->getLocalizedInternationalGrantName()}
        		{$article->getLocalizedInternationalGrantNameText()} 
        	{/if}
        </td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.mohGrant"}</td>
        <td class="value">{$article->getLocalizedMohGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.governmentGrant"}</td>
        <td class="value">{$article->getLocalizedGovernmentGrant()}</td>
    </tr>
    {if ($article->getLocalizedGovernmentGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedGovernmentGrantName()}</td>
    </tr>     
    {/if}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.universityGrant"}</td>
        <td class="value">{$article->getLocalizedUniversityGrant()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.selfFunding"}</td>
        <td class="value">{$article->getLocalizedSelfFunding()}</td>
    </tr>
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.otherGrant"}</td>
        <td class="value">{$article->getLocalizedOtherGrant()}</td>
    </tr>
    {if ($article->getLocalizedOtherGrant()) == "Yes"}
     <tr valign="top">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedSpecifyOtherGrant()}</td>
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

<br/> 

<h3>{translate key="author.submit.filesSummary"}</h3>
<table class="listing" width="100%">
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
<tr class="heading" valign="bottom">
	<td width="10%">{translate key="common.id"}</td>
	<td width="35%">{translate key="common.originalFileName"}</td>
	<td width="25%">{translate key="common.type"}</td>
	<td width="20%" class="nowrap">{translate key="common.fileSize"}</td>
	<td width="10%" class="nowrap">{translate key="common.dateUploaded"}</td>
</tr>
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
{foreach from=$files item=file}
{if ($file->getType() == 'supp' || $file->getType() == 'submission/original')}
<tr valign="top">
	<td>{$file->getFileId()}</td>
	<td><a class="file" href="{url op="download" path=$articleId|to_array:$file->getFileId()}">{$file->getOriginalFileName()|escape}</a></td>
	<td>{if ($file->getType() == 'supp')}{translate key="article.suppFile"}{else}{translate key="author.submit.submissionFile"}{/if}</td>
	<td>{$file->getNiceFileSize()}</td>
	<td>{$file->getDateUploaded()|date_format:$dateFormatTrunc}</td>
</tr>
{/if}
{foreachelse}
<tr valign="top">
<td colspan="5" class="nodata">{translate key="author.submit.noFiles"}</td>
</tr>
{/foreach}
</table>

<div class="separator"></div>

<br />
<!--
{if $canExpedite}
	{url|assign:"expediteUrl" op="expediteSubmission" articleId=$articleId}
	{translate key="author.submit.expedite" expediteUrl=$expediteUrl}
{/if}
{if $paymentButtonsTemplate }
	{include file=$paymentButtonsTemplate orientation="vertical"}
{/if}
-->

<p>&#187; <a href="{url op="index"}">{translate key="author.track"}</a></p>

</div>

{include file="common/footer.tpl"}

