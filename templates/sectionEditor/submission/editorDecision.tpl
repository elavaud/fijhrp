{**
 * editorDecision.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the editor decision table.
 *
 * $Id$
 *}
	{*******************************************************
	 *
	 * Get proposal status key and proposal status
	 * Added by Gay Figueroa
	 * Last Update: 5/3/2011
	 *
	 *******************************************************}

{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
{assign var="proposalStatus" value=$submission->getProposalStatus()}

{** include file="sectionEditor/submission/status.tpl" 
<div class="separator"></div>
*}

{ if $proposalStatus == PROPOSAL_STATUS_ASSIGNED} 
	{*******************************************************
	 *
	 * Assign reviewers if not exempted, or if reviewed and decision was Resubmit for review
	 * Added by Gay Figueroa
	 * Last Update: 5/8/2011
	 *
	 *******************************************************}

	<div id="peerReview">
		{include file="sectionEditor/submission/peerReview.tpl"}
		<div class="separator"></div>
	</div>
{elseif $lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_RESUBMIT }
	{if $articleMoreRecent}
		{include file="sectionEditor/submission/peerReview.tpl"}
		<div class="separator"></div>
	{else}
		<h3>{translate key="submission.peerReview"}</h3>
		<table id="table11" width="100%" class="data">
			<tr valign="top">
				<td class="label" width="20%">{translate key="editor.article.submissionStatus"}</td>
				<td width="80%" class="value">{translate key="editor.article.waitingForResubmission"}</td>
			</tr>
		</table>
		<div class="separator"></div>
	{/if}
{/if}

<div id="editorDecision">
<h3>{translate key="submission.editorDecision"}</h3>

<table id="table1" width="100%" class="data">

<tr valign="top">
	<td class="label" width="20%">{translate key="submission.proposalStatus"}</td>
	<td width="80%" class="value">{translate key=$proposalStatusKey}{**translate key=$proposalStatus*}</td>
</tr>

{*******************************************************
 *
 * Review for completeness
 * Added by Gay Figueroa
 * Last Update: 5/8/2011
 *
 *******************************************************}
<tr valign="top">
	{if $proposalStatus == PROPOSAL_STATUS_SUBMITTED }
		<td class="label" width="20%">{translate key="editor.article.selectInitialReview"}</td>
		<td width="80%" class="value">
			<form method="post" action="{url op="recordDecision"}">
				<input type="hidden" name="articleId" value="{$submission->getId()}" />
				<input type="hidden" name="lastDecisionId" value="{$lastDecisionArray.editDecisionId}" />
				<select name="decision" size="1" class="selectMenu">
					{html_options_translate options=$initialReviewOptions selected=1}
				</select>
				<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmInitialReview"}')" name="submit" value="{translate key="editor.article.recordInitialReview"}"  class="button" />
			</form>
		</td>

{*******************************************************
 *
 * Review for exemption
 * Added by Gay Figueroa
 * Last Update: 5/8/2011
 *
 *******************************************************}

	{ elseif $proposalStatus == PROPOSAL_STATUS_CHECKED}
		<td class="label" width="20%">{translate key="editor.article.selectExemptionDecision"}</td>
		<td width="80%" class="value">
			<form method="post" action="{url op="recordDecision"}">
				<input type="hidden" name="articleId" value="{$submission->getId()}" />
				<input type="hidden" name="lastDecisionId" value="{$lastDecisionArray.editDecisionId}" />
				<select name="decision" size="1" class="selectMenu">
					{html_options_translate options=$exemptionOptions selected=1}
				</select>
				<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmExemption"}')" name="submit" value="{translate key="editor.article.recordExemptionDecision"}"  class="button" />
			</form>
		</td>

{*******************************************************
 *
 * Record final decision when review is done or if exempted
 * Added by Gay Figueroa
 * Last Update: 5/3/2011
 *
 *******************************************************}

	{ elseif $proposalStatus == PROPOSAL_STATUS_ASSIGNED || $proposalStatus == PROPOSAL_STATUS_EXEMPTED}
		<td class="label" width="20%">{translate key="editor.article.selectDecision"}</td>
		<td width="80%" class="value">
			<form method="post" action="{url op="recordDecision"}">
				<input type="hidden" name="articleId" value="{$submission->getId()}" />
				<input type="hidden" name="lastDecisionId" value="{$lastDecisionArray.editDecisionId}" />
				<select name="decision" size="1" class="selectMenu">
					{html_options_translate options=$editorDecisionOptions selected=1}
				</select>
				<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmDecision"}')" name="submit" value="{translate key="editor.article.recordDecision"}"  class="button" />
			</form>
		</td>
{*******************************************************
 *
 * Allow review of recently resubmitted proposal if proposal was returned
 * Added by Gay Figueroa
 * Last Update: 5/8/2011
 *
 *******************************************************}
	
	{ elseif $proposalStatus == PROPOSAL_STATUS_RETURNED}
		{if $articleMoreRecent}
			<td class="label" width="20%">{translate key="editor.article.selectInitialReview"}</td>
			<td width="80%" class="value">
				<form method="post" action="{url op="recordDecision"}">
					<input type="hidden" name="articleId" value="{$submission->getId()}" />
					<input type="hidden" name="lastDecisionId" value="{$lastDecisionArray.editDecisionId}" />
					<select name="decision" size="1" class="selectMenu">
						{html_options_translate options=$initialReviewOptions selected=1}
					</select>
					<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmInitialReview"}')" name="submit" value="{translate key="editor.article.recordInitialReview"}"  class="button" />
				</form>
			</td>
		{else}
			<td class="label" width="20%">{translate key="editor.article.submissionStatus"}</td>
			<td width="80%" class="value">{translate key="editor.article.waitingForResubmission"}</td>
		{/if}

{*******************************************************
 *
 * If proposal status is reviewed and last decision was RESUBMIT and article was recently updated, submit new final decision
 * Added by Gay Figueroa
 * Last Update: 5/8/2011
 *
 *******************************************************}
	{elseif $proposalStatus == PROPOSAL_STATUS_REVIEWED && ($lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_RESUBMIT || $lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS)}	
		{if $articleMoreRecent}
			<td class="label" width="20%">{translate key="editor.article.selectDecision"}</td>
			<td width="80%" class="value">
				<form method="post" action="{url op="recordDecision"}">
					<input type="hidden" name="articleId" value="{$submission->getId()}" />
					<input type="hidden" name="lastDecisionId" value="{$lastDecisionArray.editDecisionId}" />
					<select name="decision" size="1" class="selectMenu">
						{html_options_translate options=$editorDecisionOptions selected=1}
					</select>
					<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.submissionReview.confirmDecision"}')" name="submit" value="{translate key="editor.article.recordDecision"}"  class="button" />
				</form>
			</td>
		{else}
			<td class="label" width="20%">{translate key="editor.article.submissionStatus"}</td>
			<td width="80%" class="value">{translate key="editor.article.waitingForResubmission"}</td>
		{/if}		
	{/if}
</tr>
{*******************************************************
 *
 * Indicate if this submission is a revision or resubmission
 * Added by Gay Figueroa
 * Last Update: 5/8/2011
 *
 *******************************************************}

{if $articleMoreRecent && (($proposalStatus == PROPOSAL_STATUS_RETURNED) || ($proposalStatus == PROPOSAL_STATUS_REVIEWED && ($lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_RESUBMIT || $lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS))) }
	<tr valign="top">
		<td class="label"></td>
		{assign var="articleLastModified" value=$submission->getLastModified()}
		<td width="80%" class="value">{translate key="editor.article.proposalResubmitted"}  {$articleLastModified|date_format:$dateFormatShort}
</td>
	</tr>
{/if}
{************************************************
 *
 * Display last decision only and date decided
 * Edited by Gay Figueroa
 * Last Update: 5/8/2011
 *
 ************************************************}

<tr valign="top">
	<td class="label">{translate key="editor.article.decision"}</td>
	<td class="value">
		{if $proposalStatus == PROPOSAL_STATUS_REVIEWED}
			{assign var="decision" value=$lastDecisionArray.decision}
			{if $lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_ACCEPT}
				{translate key="editor.article.decision.accept"}
			{elseif $lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS}
				{translate key="editor.article.decision.pendingRevisions"}
			{elseif $lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_RESUBMIT}
				{translate key="editor.article.decision.resubmit"}
			{elseif $lastDecisionArray.decision == SUBMISSION_EDITOR_DECISION_DECLINE}
				{translate key="editor.article.decision.decline"}
			{/if}
			{$lastDecisionArray.dateDecided|date_format:$dateFormatShort}
			{else}
				{translate key="common.none"}
		{/if}
		{************************************************
		 *
		 * Display all decisions and date
		 * Edited by Gay Figueroa
		 * Last Update: 5/3/2011
		 *
		 foreach from=$submission->getDecisions($round) item=editorDecision key=decisionKey}
			{if $decisionKey neq 0} | {/if}
			{assign var="decision" value=$editorDecision.decision}
			{translate key=$editorDecisionOptions.$decision}&nbsp;&nbsp;{$editorDecision.dateDecided|date_format:$dateFormatShort}
		{foreachelse}
			{translate key="common.none"}
		{/foreach 
		*************************************************}
	</td>
</tr>



<tr valign="top">
	<td class="label">{translate key="submission.notifyAuthor"}</td>
	<td class="value">
		{url|assign:"notifyAuthorUrl" op="emailEditorDecisionComment" articleId=$submission->getId()}

		{if $decision == SUBMISSION_EDITOR_DECISION_DECLINE}
			{* The last decision was a decline; notify the user that sending this message will archive the submission. *}
			{translate|escape:"quotes"|assign:"confirmString" key="editor.submissionReview.emailWillArchive"}
			{icon name="mail" url=$notifyAuthorUrl onclick="return confirm('$confirmString')"}
		{else}
			{icon name="mail" url=$notifyAuthorUrl}
		{/if}

		&nbsp;&nbsp;&nbsp;&nbsp;
		{translate key="submission.editorAuthorRecord"}
		{if $submission->getMostRecentEditorDecisionComment()}
			{assign var="comment" value=$submission->getMostRecentEditorDecisionComment()}
			<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getId() anchor=$comment->getId()}');" class="icon">{icon name="comment"}</a>&nbsp;&nbsp;{$comment->getDatePosted()|date_format:$dateFormatShort}
		{else}
			<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getId()}');" class="icon">{icon name="comment"}</a>{translate key="common.noComments"}
		{/if}
	</td>
</tr>
</table>

<form method="post" action="{url op="editorReview"}" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="{$submission->getId()}" />
{assign var=authorFiles value=$submission->getAuthorFileRevisions($round)}
{assign var=editorFiles value=$submission->getEditorFileRevisions($round)}

{assign var="authorRevisionExists" value=false}
{foreach from=$authorFiles item=authorFile}
	{assign var="authorRevisionExists" value=true}
{/foreach}

{assign var="editorRevisionExists" value=false}
{foreach from=$editorFiles item=editorFile}
	{assign var="editorRevisionExists" value=true}
{/foreach}
{if $reviewFile}
	{assign var="reviewVersionExists" value=1}
{/if}

{**********************************************************************
 *
 * Disable resubmit file for peer review
 * Edited by Gay Figueroa
 * Last Update: 5/8/2011
 *

<table id="table2" class="data" width="100%">
	{if $lastDecision == SUBMISSION_EDITOR_DECISION_RESUBMIT}
		<tr>
			<td width="20%">&nbsp;</td>
			<td width="80%">
				{translate key="editor.article.resubmitFileForPeerReview"}
				<input type="submit" name="resubmit" {if !($editorRevisionExists or $authorRevisionExists or $reviewVersionExists)}disabled="disabled" {/if}value="{translate key="form.resubmit"}" class="button" />
			</td>
		</tr>
	{elseif $lastDecision == SUBMISSION_EDITOR_DECISION_ACCEPT}
		<tr valign="top">
			<td width="20%">&nbsp;</td>
			<td width="80%">
				{if !($editorRevisionExists or $authorRevisionExists or $reviewVersionExists) or !$submission->getMostRecentEditorDecisionComment()}{assign var=copyeditingUnavailable value=1}{else}{assign var=copyeditingUnavailable value=0}{/if}
				<input type="submit" {if $copyeditingUnavailable}disabled="disabled" {/if}name="setCopyeditFile" value="{translate key="editor.submissionReview.sendToCopyediting"}" class="button" />
				{if $copyeditingUnavailable}
					<br/>
					<span class="instruct">{translate key="editor.submissionReview.cannotSendToCopyediting"}</span>
				{/if}
			</td>
		</tr>
	{/if}

*******************************************************************}

	{************************************************
	 *
	 * Do not allow uploading other version of proposal files
	 * Edited by Gay Figueroa
	 * Last Update: 5/3/2011
	 *


	{if $reviewFile}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.reviewVersion"}</td>
			<td width="50%" class="value">
				{if $lastDecision == SUBMISSION_EDITOR_DECISION_ACCEPT || $lastDecision == SUBMISSION_EDITOR_DECISION_RESUBMIT}
					<input type="radio" name="editorDecisionFile" value="{$reviewFile->getFileId()},{$reviewFile->getRevision()}" />
				{/if}
				<a href="{url op="downloadFile" path=$submission->getId()|to_array:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file">{$reviewFile->getFileName()|escape}</a>&nbsp;&nbsp;
				{$reviewFile->getDateModified()|date_format:$dateFormatShort}
				{if $copyeditFile && $copyeditFile->getSourceFileId() == $reviewFile->getFileId()}
					&nbsp;&nbsp;&nbsp;&nbsp;{translate key="submission.sent"}&nbsp;&nbsp;{$copyeditFile->getDateUploaded()|date_format:$dateFormatShort}
				{/if}
			</td>
		</tr>
	{/if}

	{assign var="firstItem" value=true}
	{foreach from=$authorFiles item=authorFile key=key}
		<tr valign="top">
			{if $firstItem}
				{assign var="firstItem" value=false}
				<td width="20%" rowspan="{$authorFiles|@count}" class="label">{translate key="submission.authorVersion"}</td>
			{/if}
			<td width="80%" class="value">
				{if $lastDecision == SUBMISSION_EDITOR_DECISION_ACCEPT || $lastDecision == SUBMISSION_EDITOR_DECISION_RESUBMIT}<input type="radio" name="editorDecisionFile" value="{$authorFile->getFileId()},{$authorFile->getRevision()}" /> {/if}<a href="{url op="downloadFile" path=$submission->getId()|to_array:$authorFile->getFileId():$authorFile->getRevision()}" class="file">{$authorFile->getFileName()|escape}</a>&nbsp;&nbsp;
				{$authorFile->getDateModified()|date_format:$dateFormatShort}
				{if $copyeditFile && $copyeditFile->getSourceFileId() == $authorFile->getFileId()}
					&nbsp;&nbsp;&nbsp;&nbsp;{translate key="submission.sent"}&nbsp;&nbsp;{$copyeditFile->getDateUploaded()|date_format:$dateFormatShort}
				{/if}
			</td>
		</tr>
	{foreachelse}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.authorVersion"}</td>
			<td width="80%" class="nodata">{translate key="common.none"}</td>
		</tr>
	{/foreach}
	{assign var="firstItem" value=true}
	{foreach from=$editorFiles item=editorFile key=key}
		<tr valign="top">
			{if $firstItem}
				{assign var="firstItem" value=false}
				<td width="20%" rowspan="{$editorFiles|@count}" class="label">{translate key="submission.editorVersion"}</td>
			{/if}
			<td width="80%" class="value">
				{if $lastDecision == SUBMISSION_EDITOR_DECISION_ACCEPT || $lastDecision == SUBMISSION_EDITOR_DECISION_RESUBMIT}<input type="radio" name="editorDecisionFile" value="{$editorFile->getFileId()},{$editorFile->getRevision()}" /> {/if}<a href="{url op="downloadFile" path=$submission->getId()|to_array:$editorFile->getFileId():$editorFile->getRevision()}" class="file">{$editorFile->getFileName()|escape}</a>&nbsp;&nbsp;
				{$editorFile->getDateModified()|date_format:$dateFormatShort}&nbsp;&nbsp;&nbsp;&nbsp;
				{if $copyeditFile && $copyeditFile->getSourceFileId() == $editorFile->getFileId()}
					{translate key="submission.sent"}&nbsp;&nbsp;{$copyeditFile->getDateUploaded()|date_format:$dateFormatShort}&nbsp;&nbsp;&nbsp;&nbsp;
				{/if}
				<a href="{url op="deleteArticleFile" path=$submission->getId()|to_array:$editorFile->getFileId():$editorFile->getRevision()}" class="action">{translate key="common.delete"}</a>
			</td>
		</tr>
	{foreachelse}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.editorVersion"}</td>
			<td width="80%" class="nodata">{translate key="common.none"}</td>
		</tr>
	{/foreach}


	<tr valign="top">
		<td class="label">&nbsp;</td>
		<td class="value">
			<input type="file" name="upload" class="uploadField" />
			<input type="submit" name="submit" value="{translate key="common.upload"}" class="button" />
		</td>
	</tr>
	************************************************}
</table>

</form>
</div>

