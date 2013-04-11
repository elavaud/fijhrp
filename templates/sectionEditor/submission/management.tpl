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

<table width="100%" class="data">
	<tr>
		<td title="Investigator of the research." width="20%" class="label">[?] {translate key="article.authors"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getFirstAuthor()|escape}</td>
	</tr>
        <tr>
		<td title="Identification number of the research proposal." width="20%" class="label">[?] ID</td>
		<td width="80%" colspan="2" class="data">{$submission->getLocalizedProposalId()|escape}</td>
	</tr>
	<tr>
		<td title="Scientific title of the study as it appears in the protocol submitted for funding and ethical review. This title should contain information on population, intervention, comparator and outcome(s)." width="20%" class="label">[?] {translate key="article.title"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td title="Main file of the research proposal. Please click on its title (blue link) for downloading it." width="20%" class="label">[?] {translate key="submission.originalFile"}</td>
		<td width="80%" colspan="2" class="data">
			{if $submissionFile}
				<a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$submissionFile->getFileId():$submissionFile->getRevision()}" class="file">{$submissionFile->getFileName()|escape}</a>
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
	{if count($previousFiles)>1}
	{assign var="count" value=0}
	<tr>
		<td title="In case of a re-submission, here are the main proposal files previously submitted." class="label">[?] Previous proposal files</td>
		<td width="80%" class="value">
			{foreach name="previousFiles" from=$previousFiles item=previousFile}
				{assign var="count" value=$count+1}
				{if $count > 1}
            		<a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$previousFile->getFileId()}" class="file">{$previousFile->getFileName()|escape}</a><br />
				{/if}
			{/foreach}
		</td>
	</tr>
	{/if}
	<tr>
		<td title="Supplementary files submitted by the Investigator. Please click on a title (blue link) for downloading the concerned proposal." class="label">[?] {translate key="article.suppFilesAbbrev"}</td>
		<td width="80%" class="value">
			{foreach name="suppFiles" from=$suppFiles item=suppFile}
                <a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a>&nbsp;&nbsp;({$suppFile->getType()|escape})<br />
			{foreachelse}
				{translate key="common.none"}
			{/foreach}
		</td> 
	</tr>
	<tr>
		<td title="The user who submitted the proposal through this health research portal. It could not be the same person as the investigator of the research." class="label">[?] {translate key="submission.submitter"}</td>
		<td colspan="2" class="value">
			{assign var="submitter" value=$submission->getUser()}
			{assign var=emailString value=$submitter->getFullName()|concat:" <":$submitter->getEmail():">"}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$currentUrl subject=$submission->getLocalizedTitle|strip_tags articleId=$submission->getArticleId()}
			{$submitter->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<tr>
		<td title="The date when this proposal has been submitted to the Ethics Committee." class="label">[?] {translate key="common.dateSubmitted"}</td>
		<td>{$submission->getDateSubmitted()|date_format:$datetimeFormatLong}</td>
	</tr>
	
	{if $submission->getCommentsToEditor()}
	<tr valign="top">
		<td title="Here is a comment of the submitter of the research proposal." width="20%" class="label">[?] {translate key="article.commentsToEditor"}</td>
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

