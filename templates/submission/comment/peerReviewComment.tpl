{**
 * comment.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form to enter comments.
 *
 * $Id$
 *}
{strip}
{include file="submission/comment/header.tpl"}
{/strip}

<script type="text/javascript">
{literal}
<!--
// In case this page is the result of a comment submit, reload the parent
// so that the necessary buttons will be activated.
window.opener.location.reload();
// -->
{/literal}
</script>

<div id="articleComments">
<table class="data" width="100%" cellpadding="10" style="width: 75em">
<!--
<tr valign="top">
	<td width="50%">
		<table class="data" width="100%" cellpadding="1">
			<tr valign="top">
				<td width="20%"></td>
				<td width="80%"><h3>{translate key="submission.comments.canShareWithAuthor"}</h3></td>
			</tr>
			<tr><td><div class="separator"></div></td><td><div class="separator"></div></td></tr>
			{foreach from=$articleComments item=comment}
				{if $comment->getViewable()}
				{assign var="user" value=$userDao->getUser($comment->getAuthorId())}
					<tr valign="top">
						<td><div class="commentRole"><strong>{$user->getFullName()}</strong><br/>{$user->getFunctions()}</div><div class="commentDate"><i>{$comment->getDatePosted()|date_format:$datetimeFormatLong}</i></div></td>
						<td>
							{if $comment->getCommentTitle()}
								<div class="commentTitle">{translate key="submission.comments.subject"}: {$comment->getCommentTitle()|escape}</div>
							{/if}
							<div class="comments"><br/>&nbsp;&nbsp;&nbsp;&nbsp;{$comment->getComments()|strip_unsafe_html|nl2br}</div>
						</td>
					</tr>
					<tr><td></td><td>
						{if $comment->getAuthorId() eq $userId and not $isLocked}
							<div style="float: right"><a href="{if $reviewId}{url op="editComment" path=$articleId|to_array:$comment->getId() reviewId=$reviewId}{else}{url op="editComment" path=$articleId|to_array:$comment->getId()}{/if}" class="action">{translate key="common.edit"}</a> <a href="{if $reviewId}{url op="deleteComment" path=$articleId|to_array:$comment->getId() reviewId=$reviewId}{else}{url op="deleteComment" path=$articleId|to_array:$comment->getId()}{/if}" onclick="return confirm('{translate|escape:"jsparam" key="submission.comments.confirmDelete"}')" class="action">{translate key="common.delete"}</a></div>
						{/if}
					</td></tr>
					<tr><td><div class="separator"></div></td><td><div class="separator"></div></td></tr>
				{/if}
			{/foreach}
		</table>
	</td>

	<td width="50%">
		<table class="data" width="100%" cellpadding="1">

			<tr valign="top">
				<td width="20%"></td>
				<td width="80%"><h3>{translate key="submission.comments.cannotShareWithAuthor"}</h3></td>
			</tr>
-->
			<tr><td width="20%"><div class="separator"></div></td><td width="80%"><div class="separator"></div></td></tr>
			{foreach from=$articleComments item=comment}
				{if !$comment->getViewable()}
				{assign var="submitter" value=$userDao->getUser($comment->getAuthorId())}
					<tr valign="top">
						<td><div class="commentRole"><strong>{$submitter->getFullName()}</strong><br/>{$submitter->getErcFunction($sectionId)}</div><div class="commentDate"><i>{$comment->getDatePosted()|date_format:$datetimeFormatLong}</i></div></td>
						<td>
							{if $comment->getCommentTitle()}
								<div class="commentTitle">{translate key="submission.comments.subject"}: {$comment->getCommentTitle()|escape}</div>
							{/if}
							<div class="comments"><br/>&nbsp;&nbsp;&nbsp;&nbsp;{$comment->getComments()|strip_unsafe_html|nl2br}</div>
						</td>
					</tr>
					<tr><td></td><td>
						{if $comment->getAuthorId() eq $userId and not $isLocked}
							<div style="float: right"><a href="{if $reviewId}{url op="editComment" path=$articleId|to_array:$comment->getId() reviewId=$reviewId}{else}{url op="editComment" path=$articleId|to_array:$comment->getId()}{/if}" class="action">{if $showReviewLetters}Edit{else}{translate key="common.edit"}{/if}</a> <a href="{if $reviewId}{url op="deleteComment" path=$articleId|to_array:$comment->getId() reviewId=$reviewId}{else}{url op="deleteComment" path=$articleId|to_array:$comment->getId()}{/if}" onclick="return confirm('{translate|escape:"jsparam" key="submission.comments.confirmDelete"}')" class="action">{if $showReviewLetters}Delete{else}{translate key="common.delete"}{/if}</a></div>
						{/if}
					</td></tr>
					<tr><td><div class="separator"></div></td><td><div class="separator"></div></td></tr>
				{/if}
			{/foreach}
<!--
		</table>
	</td>
</tr>
-->
</table>
</div>
<br />
<br />


{if not $isLocked}
<form method="post" action="{url op=$commentAction}">
{if $hiddenFormParams}
	{foreach from=$hiddenFormParams item=hiddenFormParam key=key}
		<input type="hidden" name="{$key|escape}" value="{$hiddenFormParam|escape}" />
	{/foreach}
{/if}


<div id="new">
{include file="common/formErrors.tpl"}

<table class="data" width="100%" cellpadding="10" style="width: 75em">
<tr valign="top">
	<td class="label" width="20%">{fieldLabel name="commentTitle" key="submission.comments.subject"}</td>
	<td class="value" width="80%"><input type="text" name="commentTitle" id="commentTitle" value="{$commentTitle|escape}" rows="10" maxlength="255" class="textField" /></td>
</tr>
<!--
</table>
<table class="data" width="100%" cellpadding="10">
-->
<tr valign="top">
<!--
	<td class="label">{fieldLabel name="authorComments"}{translate key="submission.comments.forAuthorEditor"}</td>
	<td class="value"><textarea id="authorComments" name="authorComments" rows="10" cols="50" class="textArea">{$authorComments|escape}</textarea></td>
-->
	<td class="label">{if $showReviewLetters}To reviewer{else}{fieldLabel name="comments"}{translate key="submission.comments.forEditor"}{/if}</td>
	<td class="value"><textarea id="comments" name="comments" rows="10" cols="50" class="textArea">{$comments|escape}</textarea></td>
</tr>
</table>

<p><input type="submit" name="save" value="{if $showReviewLetters}{translate key="common.save"}{else}{translate key="common.save"}{/if}" class="button defaultButton" /> <input type="button" value="{if $showReviewLetters}{translate key="common.cancel"}{else}{translate key="common.cancel"}{/if}" class="button" onclick="window.close()" /></p>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
</div>
</form>

{else}
<input type="button" value="{translate key="common.cancel"}" class="button defaultButton" style="width: 5em" onclick="window.close()" />
{/if}

{include file="common/footer.tpl"}

