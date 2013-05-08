<h3>{translate key="article.submission"}</h3>

<table width="100%" class="data">
	<tr>
		<td width="20%" class="label">{translate key="article.authors"}</td>
		<td width="80%">
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$submission->getAuthorEmails() subject=$submission->getLocalizedTitle() articleId=$submission->getId()}
			{$submission->getAuthorString()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="article.title"}</td>
		<td>{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">{translate key="section.section"}</td>
		<td>{$submission->getSectionTitle()|escape}</td>
	</tr>
	
	<tr valign="top">
		<td class="label" width="20%">{translate key="submission.reviewVersion"}</td>
		{if $reviewFile}
			<td width="80%" class="value">
				<a href="{url op="downloadFile" path=$submission->getId()|to_array:$reviewFile->getFileId()}" class="file">{$reviewFile->getFileName()|escape}</a>&nbsp;&nbsp;
				{$reviewFile->getDateModified()|date_format:$dateFormatShort}{if $currentJournal->getSetting('showEnsuringLink')}&nbsp;&nbsp;&nbsp;&nbsp;<a class="action" href="javascript:openHelp('{get_help_id key="editorial.sectionEditorsRole.review.blindPeerReview" url="true"}')">{translate key="reviewer.article.ensuringBlindReview"}</a>{/if}
			</td>
		{else}
			<td width="80%" class="nodata">{translate key="common.none"}</td>
		{/if}
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			<form method="post" action="{url op="uploadReviewVersion"}" enctype="multipart/form-data">
				{translate key="editor.article.uploadReviewVersion"}
				<input type="hidden" name="articleId" value="{$submission->getId()}" />
				<input type="file" name="upload" class="uploadField" />
				<input type="submit" name="submit" value="{translate key="common.upload"}" class="button" />
			</form>
		</td>
	</tr>
	{foreach from=$suppFiles item=suppFile}
		<tr valign="top">
			{if !$notFirstSuppFile}
				<td class="label" rowspan="{$suppFiles|@count}">{translate key="article.suppFilesAbbrev"}</td>
				{assign var=notFirstSuppFile value=1}
			{/if}
			<td width="80%" class="value nowrap">
				<form method="post" action="{url op="setSuppFileVisibility"}">
				<input type="hidden" name="articleId" value="{$submission->getId()}" />
				<input type="hidden" name="fileId" value="{$suppFile->getId()}" />

				<a href="{url op="downloadFile" path=$submission->getId()|to_array:$suppFile->getFileId()}" class="file">{$suppFile->getFileName()|escape}</a>&nbsp;&nbsp;
				{$suppFile->getDateModified()|date_format:$dateFormatShort}&nbsp;&nbsp;
				<label for="show">{translate key="editor.article.showSuppFile"}</label>
				<input type="checkbox" name="show" id="show" value="1"{if $suppFile->getShowReviewers()==1} checked="checked"{/if}/>
				<input type="submit" name="submit" value="{translate key="common.record"}" class="button" />
				</form>
			</td>
		</tr>
	{foreachelse}
	<tr valign="top">
		<td class="label">{translate key="article.suppFilesAbbrev"}</td>
		<td class="nodata">{translate key="common.none"}</td>
	</tr>
{/foreach}
</table>

