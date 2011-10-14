{**
 * management.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission management table.
 *
 * $Id$
 *}
<div id="submission">
<h3>{translate key="article.submission"}</h3>

{assign var="submissionFile" value=$submission->getSubmissionFile()}
{assign var="suppFiles" value=$submission->getSuppFiles()}

<table width="100%" class="data">
	<tr>
		<td width="20%" class="label">{translate key="article.authors"}</td>
		<td width="80%" colspan="2" class="value">
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$submission->getAuthorEmails() subject=$submission->getLocalizedTitle() articleId=$submission->getId()}
			{$submission->getAuthorString()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="article.title"}</td>
		<td colspan="2" class="value">{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">{translate key="submission.originalFile"}</td>
		<td colspan="2" class="value">
			{if $submissionFile}
				<a href="{url op="downloadFile" path=$submission->getId()|to_array:$submissionFile->getFileId()}" class="file">{$submissionFile->getFileName()|escape}</a>&nbsp;&nbsp;{$submissionFile->getDateModified()|date_format:$dateFormatShort}
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="article.suppFilesAbbrev"}</td>
		<td colspan="2" class="value">
			{foreach name="suppFiles" from=$suppFiles item=suppFile}
				<a href="{url op="downloadFile" path=$submission->getId()|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a>&nbsp;&nbsp;{$suppFile->getDateModified()|date_format:$dateFormatShort}


{************************************
 *
 *
 * Do not allow section editor and editor to edit and add files and metadata
 * Edited by Gay Figueroa
 * Last Update: 5/3/2011
 *
 *
&nbsp;&nbsp;<a href="{url op="editSuppFile" from="submission" path=$submission->getId()|to_array:$suppFile->getId()}" class="action">{translate key="common.edit"}</a>&nbsp;&nbsp;&nbsp;&nbsp;if !$notFirst}&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="addSuppFile" from="submission" path=$submission->getId()}" class="action">{translate key="submission.addSuppFile"}</a>{/if}<br /> 
*************************************}

				{assign var=notFirst value=1}
			{foreachelse}
				{translate key="common.none"}&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="addSuppFile" from="submission" path=$submission->getId()}" class="action">{translate key="submission.addSuppFile"}</a>
			{/foreach}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="submission.submitter"}</td>
		<td colspan="2" class="value">
			{assign var="submitter" value=$submission->getUser()}
			{assign var=emailString value=$submitter->getFullName()|concat:" <":$submitter->getEmail():">"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getLocalizedTitle|strip_tags articleId=$submission->getId()}
			{$submitter->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="common.dateSubmitted"}</td>
		<td>{$submission->getDateSubmitted()|date_format:$dateFormatShort}</td>
	</tr>
	<tr>
		<td class="label">{translate key="section.section"}</td>
		<td class="value">{$submission->getSectionTitle()|escape}</td>

		{*********************************************
		 *
		 * Section is set by default, do not allow editor and section editor to change section
		 * Edited by Gay Figueroa
		 * Last Update: 5/3/2011
		 *
		 *
			<td class="value">
			<form action="{url op="updateSection" path=$submission->getId()}" method="post">{translate key="submission.changeSection"} <select 				name="section" size="1" class="selectMenu">{html_options options=$sections selected=$submission->getSectionId()}</select> <input type="submit" 				value="{translate key="common.record"}" class="button" /></form>
			</td>
		***********************************************}
	</tr>
	{if $submission->getCommentsToEditor()}
	<tr valign="top">
		<td width="20%" class="label">{translate key="article.commentsToEditor"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getCommentsToEditor()|strip_unsafe_html|nl2br}</td>
	</tr>
	{/if}
	{if $publishedArticle}
	<tr>
		<td class="label">{translate key="submission.abstractViews"}</td>
		<td>{$publishedArticle->getViews()}</td>
	</tr>
	{/if}
	<tr>
		<td class="label">WHO ID</td>
		<td class="value">{$submission->getLocalizedWhoId()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Objectives</td>
		<td class="value">{$submission->getLocalizedObjectives()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Keywords</td>
		<td class="value">{$submission->getLocalizedKeywords()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Start Date</td>
		<td class="value">{$submission->getLocalizedStartDate()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">End Date</td>
		<td class="value">{$submission->getLocalizedEndDate()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Funds Required</td>
		<td class="value">{$submission->getLocalizedFundsRequired()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Country</td>
		<td class="value">{$submission->getLocalizedProposalCountryText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text -->
	</tr>
	<tr>
		<td class="label">Technical Unit</td>
		<td class="value">{$submission->getLocalizedTechnicalUnitText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text -->
	</tr>
	<tr>
		<td class="label">Proposal Type</td>
		<td class="value">{$submission->getLocalizedProposalTypeText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text -->
	</tr>
	<tr>
		<td class="label">Conflict Of Interest</td>
		<td class="value">{$submission->getLocalizedConflictOfInterest()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Reviewed by Other ERC</td>
		<td class="value">{$submission->getLocalizedReviewedByOtherErc()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">Other Erc Decision</td>
		<td class="value">{$submission->getLocalizedOtherErcDecision()|strip_unsafe_html}</td>
	</tr>
</table>
</div>

