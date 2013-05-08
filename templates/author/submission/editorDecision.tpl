{**
 * editorDecision.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's editor decision table.
 *
 * $Id$
 *}
<div id="editorDecision">
<h3>{translate key="submission.editorDecision"}</h3>

<table width="100%" class="data">

        <tr valign="top">
		<td class="label" width="20%">
			{translate key="editor.article.decisionComments"}
		</td>
		<td class="value" width="80%">
			{if $submission->getMostRecentEditorDecisionComment()}
				{assign var="comment" value=$submission->getMostRecentEditorDecisionComment()}
				<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getArticleId() anchor=$comment->getId()}');" class="icon">{icon name="comment"}</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last comment: {$comment->getDatePosted()|date_format:$dateFormatLong}
			{else}
				<a href="javascript:openComments('{url op="viewEditorDecisionComments" path=$submission->getArticleId()}');" class="icon">{icon name="comment"}</a>{translate key="common.noComments"}
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">
			{translate key="submission.notifyEditor"}
		</td>
		<td class="value" width="80%">
			{url|assign:"notifyAuthorUrl" op="emailEditorDecisionComment" articleId=$submission->getArticleId()}
			{icon name="mail" url=$notifyAuthorUrl}
			&nbsp;&nbsp;&nbsp;&nbsp;
			{translate key="submission.editorAuthorRecord"}
		</td>
	</tr>
</table>
</div>
