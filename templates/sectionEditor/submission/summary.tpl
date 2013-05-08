{**
 * summary.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission summary table.
 *
 * $Id$
 *}
<div id="submission">
<h3>{translate key="article.submission"}</h3>

<table width="100%" class="data">
	<tr>
		<td width="20%" class="label">{translate key="article.authors"}</td>
		<td width="80%">
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$submission->getAuthorEmails() subject=$abstract->getScientificTitle() articleId=$submission->getId()}
			{* {$submission->getAuthorString()|escape} *} {$submission->getFirstAuthor()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	<tr>
		<td class="label">{translate key="article.title"}</td>
		<td>{$abstract->getScientificTitle()|strip_unsafe_html}</td>
	</tr>

</table>
</div>

