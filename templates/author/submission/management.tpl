{**
 * management.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's submission management table.
 *
 * $Id$
 *}
<div id="submission">
<h3>{translate key="article.submission"}</h3>

{* When editing this page, edit templates/sectionEditor/submission/management.tpl as well *}

<table width="100%" class="data">
	<tr>
		<td width="20%" class="label">{translate key="article.authors"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getFirstAuthor()|escape}</td>
	</tr>
        <tr>
		<td width="20%" class="label">{translate key="common.proposalId"}</td>
		<td width="80%" colspan="2" class="data">{$submission->getLocalizedProposalId()|escape}</td>
	</tr>
	<tr>
		<td width="20%" class="label">{translate key="article.title"}</td>
		<td width="80%" colspan="2" class="data">{$abstract->getScientificTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td width="20%" class="label">{translate key="submission.originalFile"}</td>
		<td width="80%" colspan="2" class="data">
			{if $submissionFile}
				<a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$submissionFile->getFileId()}" class="file">{$submissionFile->getFileName()|escape}</a>
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="article.suppFilesAbbrev"}</td>
		<td width="80%" class="value">
			{foreach name="suppFiles" from=$suppFiles item=suppFile}
				{if $suppFile->getType() == 'Final Decision'}
					{if $suppFileDao->getSetting($suppFile->getSuppFileId(), 'investigator') == 'hide'}
						You are not authorized to access the final decision.
					{else}
                        <a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a>&nbsp;&nbsp;({$suppFile->getType()|escape})
					{/if}
				{else}
                    <a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a>&nbsp;&nbsp;({$suppFile->getType()|escape})
                    {if $canEditFiles}
                    	&nbsp;
                        <a href="{url op="deleteSuppFile" path=$suppFile->getSuppFileId() articleId=$submission->getArticleId()}" onclick="return confirm('{translate|escape:"jsparam" key="author.submit.confirmDeleteSuppFile"}')" class="action">{translate key="common.delete"}</a>
                	{/if}
                    <br />
                {/if}
            {foreachelse}
				{translate key="common.none"}
			{/foreach}
		</td>
        </tr>
        <!--  Adding of supp files allowed only until proposal is reviewed -->
        {if $canEditFiles}
        <tr>
                <td>&nbsp;</td>
		<td>
                        <a href="{url op="addSuppFile" path=$submission->getArticleId()}" class="action">{translate key="submission.addSuppFile"}</a>
		</td>
	</tr>
        {/if}
	<tr>
		<td class="label">{translate key="submission.submitter"}</td>
		<td colspan="2" class="value">
			{assign var="submitter" value=$submission->getUser()}
			{assign var=emailString value=$submitter->getFullName()|concat:" <":$submitter->getEmail():">"}
			{url|assign:"url" page="user" op="email" to=$emailString|to_array redirectUrl=$currentUrl subject=$abstract->getScientificTitle()|strip_tags articleId=$submission->getArticleId()}
			{$submitter->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="common.dateSubmitted"}</td>
		<td>{$submission->getDateSubmitted()|date_format:$datetimeFormatLong}</td>
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
</table>
</div>

