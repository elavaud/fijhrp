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

{*  Code replaced with templates/author/submission/management.tpl, Jan 10, 2012 for uniformity

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
		 
		  Section is set by default, do not allow editor and section editor to change section
		  Edited by Gay Figueroa
		  Last Update: 5/3/2011

                <td class="value">{$submission->getSectionTitle()|escape}</td>
                <td class="value">
                <form action="{url op="updateSection" path=$submission->getId()}" method="post">{translate key="submission.changeSection"} <select 				name="section" size="1" class="selectMenu">{html_options options=$sections selected=$submission->getSectionId()}</select> <input type="submit" 				value="{translate key="common.record"}" class="button" /></form>
                </td>
		
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
		<td class="value">{$submission->getLocalizedProposalCountryText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text --
	</tr>
	<tr>
		<td class="label">Technical Unit</td>
		<td class="value">{$submission->getLocalizedTechnicalUnitText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text --
	</tr>
	<tr>
		<td class="label">Proposal Type</td>
		<td class="value">{$submission->getLocalizedProposalTypeText()|strip_unsafe_html}</td> <!-- Edited by igm 9/28/11: Display field's full text --
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
-->
*}
<!---------------------------------------------------------------------------------------------------------------------------------------------------------->


<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label">{translate key="article.authors"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getFirstAuthor()|escape}</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label">{translate key="article.title"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label">{translate key="submission.originalFile"}</td>
		<td width="80%" colspan="2" class="data">
			{if $submissionFile}
				<a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$submissionFile->getFileId():$submissionFile->getRevision()}" class="file">{$submissionFile->getFileName()|escape}</a>
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="article.suppFilesAbbrev"}</td>
		<td width="80%" class="value">
			{foreach name="suppFiles" from=$suppFiles item=suppFile}
                            <!-- Do not allow edit of supp files, Edit by AIM, June 6, 2011
                            {*
                            <a href="{if $submission->getStatus() != STATUS_PUBLISHED && $submission->getStatus() != STATUS_ARCHIVED}{url op="editSuppFile" path=$submission->getArticleId()|to_array:$suppFile->getId()}{else}{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId()}{/if}" class="file">{$suppFile->getFileName()|escape}</a>&nbsp;&nbsp;{$suppFile->getDateModified()|date_format:$dateFormatShort}<br />
                            *}
                            -->
                            <a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a>&nbsp;&nbsp;({$suppFile->getType()|escape})<br />
			{foreachelse}
				{translate key="common.none"}
			{/foreach}
		</td>
                <!--  Adding of supp files not allowed after submission
                {*
		<td width="50%" class="value">
                        {if $submission->getSubmissionStatus() == PROPOSAL_STATUS_SUBMITTED}
				<a href="{url op="addSuppFile" path=$submission->getArticleId()}" class="action">{translate key="submission.addSuppFile"}</a>
			{else}
				&nbsp;
			{/if}
		</td>
                *}
                -->
	</tr>
	<tr>
		<td class="label">{translate key="submission.submitter"}</td>
		<td colspan="2" class="value">
			{assign var="submitter" value=$submission->getUser()}
			{assign var=emailString value=$submitter->getFullName()|concat:" <":$submitter->getEmail():">"}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$currentUrl subject=$submission->getLocalizedTitle|strip_tags articleId=$submission->getArticleId()}
			{$submitter->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="common.dateSubmitted"}</td>
		<td>{$submission->getDateSubmitted()|date_format:$datetimeFormatLong}</td>
	</tr>
{* Commented out by spf - 1 Dec 2011
	<tr valign="top">
		<td width="20%" class="label">{translate key="section.section"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getSectionTitle()|escape}</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label">{translate key="user.role.editor"}</td>
		{assign var="editAssignments" value=$submission->getEditAssignments()}
		<td width="80%" colspan="2" class="data">
			{foreach from=$editAssignments item=editAssignment}
				{assign var=emailString value=$editAssignment->getEditorFullName()|concat:" <":$editAssignment->getEditorEmail():">"}
				{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$currentUrl subject=$submission->getLocalizedTitle|strip_tags articleId=$submission->getArticleId()}
				{$editAssignment->getEditorFullName()|escape} {icon name="mail" url=$url}
				{if !$editAssignment->getCanEdit() || !$editAssignment->getCanReview()}
					{if $editAssignment->getCanEdit()}
						({translate key="submission.editing"})
					{else}
						({translate key="submission.review"})
					{/if}
				{/if}
				<br/>
                        {foreachelse}
                                {translate key="common.noneAssigned"}
                        {/foreach}
		</td>
	</tr>
*}
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
</table>
</div>

