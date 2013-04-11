{**
 * submissionReview.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Author's submission review.
 *
 * $Id$
 *}
{strip}
{translate|assign:"pageTitleTranslated" key="submission.page.review" id=$submission->getProposalId($submission->getLocale())}
{assign var="pageCrumbTitle" value="submission.review"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="submission" path=$submission->getId()}">{translate key="submission.summary"}</a></li>
	<li class="current"><a href="{url op="submissionReview" path=$submission->getId()}">{translate key="submission.review"}</a></li>
	<!-- {* <li><a href="{url op="submissionEditing" path=$submission->getId()}">{translate key="submission.editing"}</a></li> *} -->
</ul>


{include file="author/submission/summary.tpl"}

<div class="separator"></div>

{include file="author/submission/peerReview.tpl"}

<div class="separator"></div>

{include file="author/submission/status.tpl"}

<div class="separator"></div>

{if $countMeetings > 0}

{include file="author/submission/meeting.tpl"}

<div class="separator"></div>

{/if}

{include file="author/submission/editorDecision.tpl"}

{include file="common/footer.tpl"}

