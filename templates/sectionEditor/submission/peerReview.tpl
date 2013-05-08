{**
 * peerReview.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the peer review table.
 *
 * $Id$
 *}

{literal}
<script type="text/javascript">
function checkSize(){
	var fileToUpload = document.getElementById('uploadReview');
	var check = fileToUpload.files[0].fileSize;
	var valueInKb = Math.ceil(check/1024);
	if (check > 5242880){
		alert ('{/literal}{translate key="common.fileTooBig1"}{literal}'+valueInKb+'{/literal}{translate key="common.fileTooBig2"}{literal}5 Mb.');
		return false
	} 
}
</script>
{/literal}

<div id="peerReview">

<table class="data" width="100%">
	<tr id="reviewersHeader" valign="middle">
		<td width="30%" colspan="2" ><h4>{translate key="editor.article.activeReviewers"}</h4></td>		
		<td width="70%" align="left" valign="bottom">
			<a href="{url op="selectReviewer" path=$submission->getId()}" class="action">{translate key="editor.article.selectReviewer"}</a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			
			{if $reviewAssignmentCount>0}
				<a href="{url op="setDueDateForAll" path=$submission->getId()}" class="action">{translate key="editor.article.setDueDateForAll"}</a>
			{/if}
		</td>
	</tr>
</table>

{assign var="start" value="A"|ord}
{foreach from=$reviewAssignments item=reviewAssignment key=reviewKey}

{assign var="reviewId" value=$reviewAssignment->getId()}


{if not $reviewAssignment->getCancelled() and not $reviewAssignment->getDeclined()}
	{**assign var="reviewIndex" value=$reviewIndexes[$reviewId]**}
	<div class="separator"></div>

	<table class="data" width="100%">
	<tr class="reviewer">
		<td class="r1" width="20%" align="center" valign="bottom">			
		</td>
		<td class="r2" width="30%" align="left">
			<h4>{$reviewAssignment->getReviewerFullName()|escape}</h4>
		</td>
		<td class="r3" width="50%" align="left">
				{if not $reviewAssignment->getDateNotified()}
					<a href="{url op="clearReview" path=$submission->getId()|to_array:$reviewAssignment->getId()}" class="action">{translate key="editor.article.clearReview"}</a>
				{elseif $reviewAssignment->getDeclined() or not $reviewAssignment->getDateCompleted()}
					<a href="{url op="cancelReview" articleId=$submission->getId() reviewId=$reviewAssignment->getId()}" class="action">{translate key="editor.article.cancelReview"}ໍ</a>
				{/if}
		</td>
	</tr>
	</table>

	<table width="100%" class="data">

	<tr valign="top">
		<td class="label" width="20%">&nbsp;</td>
		<td width="80%">
			<table width="100%" class="info">
				<tr>
					<td class="heading" width="25%">{translate key="submission.request"}</td>
					<td class="heading" width="25%">{translate key="submission.underway"}</td>
					<td class="heading" width="25%">{translate key="submission.due"}</td>
					<td class="heading" width="25%">{translate key="submission.acknowledge"}</td>
				</tr>
				<tr valign="top">
					<td>						
						{if $reviewAssignment->getDateNotified()}
							{$reviewAssignment->getDateNotified()|date_format:$dateFormatLong}							
						{else}
							{url|assign:"reviewUrl" op="notifyReviewer" reviewId=$reviewAssignment->getId() articleId=$submission->getId()}
							<a href="{url op="notifyReviewer" path=$submission->getArticleId()|to_array:$reviewId}" class="action">{translate key="common.notify"}</a>
						{/if}
					</td>
					<td>
						{$reviewAssignment->getDateConfirmed()|date_format:$dateFormatLong|default:"&mdash;"}
					</td>
					<td>
						{if $reviewAssignment->getDeclined()}
							{translate key="sectionEditor.regrets"}
						{else}
							<a href="{url op="setDueDate" path=$submission->getArticleId()|to_array:$reviewAssignment->getId()}">{if $reviewAssignment->getDateDue()}{$reviewAssignment->getDateDue()|date_format:$dateFormatLong}{else}&mdash;{/if}</a>
						{/if}
					</td>
					<td>
						{url|assign:"thankUrl" op="thankReviewer" reviewId=$reviewAssignment->getId() articleId=$submission->getId()}
						{if $reviewAssignment->getDateAcknowledged()}
							{$reviewAssignment->getDateAcknowledged()|date_format:$dateFormatLong}
						{elseif $reviewAssignment->getDateCompleted()}
							{icon name="mail" url=$thankUrl}
						{else}
							{icon name="mail" disabled="disabled" url=$thankUrl}
						{/if}
					</td>
				</tr>
			</table>
		</td>
	</tr>

	{if $reviewAssignment->getDateConfirmed() && !$reviewAssignment->getDeclined()}
		{if $currentJournal->getSetting('requireReviewerCompetingInterests')}
			<tr valign="top">
				<td class="label">{translate key="reviewer.competingInterests"}</td>
				<td>{$reviewAssignment->getCompetingInterests()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
			</tr>
		{/if}{* requireReviewerCompetingInterests *}
		{if $reviewFormResponses[$reviewId]}
			<tr valign="top">
				<td class="label">{translate key="submission.reviewFormResponse"}</td>
				<td>
					<a href="javascript:openComments('{url op="viewReviewFormResponse" path=$submission->getId()|to_array:$reviewAssignment->getId()}');" class="icon">{icon name="comment"}</a>
				</td>
			</tr>
		{/if}
		{if !$reviewAssignment->getReviewFormId() || $reviewAssignment->getMostRecentPeerReviewComment()}{* Only display comments link if a comment is entered or this is a non-review form review *}
			<tr>
				<td class="label">{translate key="submission.review"}</td>
				<td>
					{if $reviewAssignment->getMostRecentPeerReviewComment()}
						{assign var="comment" value=$reviewAssignment->getMostRecentPeerReviewComment()}
						<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getId()|to_array:$reviewAssignment->getId() anchor=$comment->getId()}');" class="icon">{icon name="comment"}</a>&nbsp;&nbsp;{$comment->getDatePosted()|date_format:$dateFormatLong}
					{else}
						<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getId()|to_array:$reviewAssignment->getId()}');" class="icon">{icon name="comment"}</a>&nbsp;&nbsp;{translate key="submission.comments.noComments"}
					{/if}
				</td>
			</tr>
		{/if}
		<tr>
			<td class="label">{translate key="reviewer.article.uploadedFile"}</td>
			<td>
				<table width="100%" class="data">
					{assign var="reviewerFile" value=$reviewAssignment->getReviewerFile()}
					{if $reviewerFile}
					<tr valign="top">
						<td valign="middle">
							<form name="authorView{$reviewAssignment->getId()}" method="post" action="{url op="makeReviewerFileViewable"}">
								<a href="{url op="downloadFile" path=$submission->getId()|to_array:$reviewerFile->getFileId()}" class="file">{$reviewerFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewerFile->getDateModified()|date_format:$dateFormatLong}
								<input type="hidden" name="reviewId" value="{$reviewAssignment->getId()}" />
								<input type="hidden" name="articleId" value="{$submission->getId()}" />
								<input type="hidden" name="fileId" value="{$reviewerFile->getFileId()}" />
								<br/>{translate key="editor.article.showAuthor"} <input type="checkbox" name="viewable" value="1"{if $reviewerFile->getViewable()} checked="checked"{/if} />
								<input type="submit" value="{translate key="common.record"}" class="button" />
							</form>
						</td>
					</tr>
					{else}
					<tr>
						<td>{translate key="common.none"}</td>
					</tr>
					{/if}
				</table>
			</td>
		</tr>

	{/if}

	{if (($reviewAssignment->getRecommendation() === null || $reviewAssignment->getRecommendation() === '') || !$reviewAssignment->getDateConfirmed()) && $reviewAssignment->getDateNotified() && !$reviewAssignment->getDeclined()}
		<tr valign="top">
			<td class="label">{translate key="reviewer.article.editorToEnter"}</td>
			<td>
				{if !$reviewAssignment->getDateConfirmed()}
					<a href="{url op="confirmReviewForReviewer" path=$submission->getId()|to_array:$reviewAssignment->getId() accept=1}" class="action">{translate key="reviewer.article.canDoReview"}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="confirmReviewForReviewer" path=$submission->getId()|to_array:$reviewAssignment->getId() accept=0}" class="action">{translate key="reviewer.article.cannotDoReview"}</a><br />
				{/if}
				{if $reviewAssignment->getDateConfirmed() && !$reviewAssignment->getDeclined()}
				<form method="post" action="{url op="uploadReviewForReviewer"}" onSubmit="return checkSize()" enctype="multipart/form-data">
					{translate key="editor.article.uploadReviewForReviewer"}
					<input type="hidden" name="articleId" value="{$submission->getId()}" />
					<input type="hidden" name="reviewId" value="{$reviewAssignment->getId()}"/>
					<input type="file" name="upload" class="uploadField" id="uploadReview" />
					<input type="submit" name="submit" value="{translate key="common.upload"}" class="button" />
				</form>				
				{/if}
			</td>
		</tr>
	{/if}
	{if $reviewAssignment->getDateConfirmed() && !$reviewAssignment->getDeclined()}
		<tr>
			<td class="label">{translate key="reviewer.article.recommendation"}</td>
			<td>
				{if $reviewAssignment->getRecommendation() !== null && $reviewAssignment->getRecommendation() !== ''}
					{assign var="recommendation" value=$reviewAssignment->getRecommendation()}
					{translate key=$reviewerRecommendationOptions.$recommendation}
					&nbsp;&nbsp;{$reviewAssignment->getDateCompleted()|date_format:$dateFormatLong}
				{else}				
					{translate key="common.none"}&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="{url op="remindReviewer" articleId=$submission->getId() reviewId=$reviewAssignment->getId()}" class="action">{translate key="reviewer.article.sendReminder"}</a>
					{if $reviewAssignment->getDateReminded()}
						&nbsp;&nbsp;{$reviewAssignment->getDateReminded()|date_format:$dateFormatLong}
						{if $reviewAssignment->getReminderWasAutomatic()}
							&nbsp;&nbsp;{translate key="reviewer.article.automatic"}
						{/if}
					{/if}
					{if $reviewAssignment->getDateConfirmed() && !$reviewAssignment->getDeclined()}
						{if $reviewAssignment->getReviewerFile()}
						&nbsp;&nbsp;&nbsp;&nbsp;<a class="action" href="{url op="enterReviewerRecommendation" articleId=$submission->getId() reviewId=$reviewAssignment->getId()}">{translate key="editor.article.enterRecommendation"}</a>
						{/if}
					{/if}
				{/if}								
			</td>
		</tr>
	{/if}
	{if $reviewAssignment->getDateNotified() && !$reviewAssignment->getDeclined() && $rateReviewerOnQuality}
		<tr valign="top">
			<td class="label">{translate key="editor.article.rateReviewer"}</td>
			<td>
			<form method="post" action="{url op="rateReviewer"}">
				<input type="hidden" name="reviewId" value="{$reviewAssignment->getId()}" />
				<input type="hidden" name="articleId" value="{$submission->getId()}" />
				<select name="quality" size="1" class="selectMenu">
					{html_options_translate options=$reviewerRatingOptions selected=$reviewAssignment->getQuality()}
				</select>&nbsp;&nbsp;
				<input type="submit" value="{translate key="common.record"}" class="button" />
				{if $reviewAssignment->getDateRated()}
					&nbsp;&nbsp;{$reviewAssignment->getDateRated()|date_format:$dateFormatLong}
				{/if}
			</form>
			</td>
		</tr>
	{/if}
	{if $needsReviewFileNote}
		<tr valign="top">
			<td>&nbsp;</td>
			<td>
				{translate key="submission.review.mustUploadFileForReview"}
			</td>
		</tr>
	{/if}
	</table>
{/if}
{/foreach}


</div>

{*********************************************************************
 *
 * Do not allow selection of review form
 * Edited by Gay Figueroa
 * Last Update: 5/3/2011
 *
	<tr valign="top">
		<td class="label">{translate key="submission.reviewForm"}</td>
		<td>
		{if $reviewAssignment->getReviewFormId()}
			{assign var="reviewFormId" value=$reviewAssignment->getReviewFormId()}
			{$reviewFormTitles[$reviewFormId]}
		{else}
			{translate key="manager.reviewForms.noneChosen"}
		{/if}
		{if !$reviewAssignment->getDateCompleted()}
			&nbsp;&nbsp;&nbsp;&nbsp;<a class="action" href="{url op="selectReviewForm" path=$submission->getId()|to_array:$reviewAssignment->getId()}"{if $reviewFormResponses[$reviewId]} onclick="return confirm('{translate|escape:"jsparam" key="editor.article.confirmChangeReviewForm"}')"{/if}>{translate key="editor.article.selectReviewForm"}</a>{if $reviewAssignment->getReviewFormId()}&nbsp;&nbsp;&nbsp;&nbsp;<a class="action" href="{url op="clearReviewForm" path=$submission->getId()|to_array:$reviewAssignment->getId()}"{if $reviewFormResponses[$reviewId]} onclick="return confirm('{translate|escape:"jsparam" key="editor.article.confirmChangeReviewForm"}')"{/if}>{translate key="editor.article.clearReviewForm"}</a>{/if}
		{/if}
		</td>
	</tr>
*********************************************************************}

