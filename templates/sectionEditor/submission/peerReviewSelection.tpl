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


<form method="post" action="{url op="selectReviewers" path=$submission->getId()}">

<div id="peerReview">
<table class="data" width="100%">
	<tr id="reviewersHeader" valign="middle">
		<td width="20%"><h3>Active ERC Members</h3></td>
		{**<td width="20%"><h4>{translate key="submission.round" round=$round}</h4></td>**}
		<td width="60%" valign="bottom">
			<input type="submit" class="button" value="Select And Notify ERC Members for Primary Review" />						
		</td>
	</tr>
</table>


{assign var="start" value="A"|ord}
{assign var="reviewIndex" value=0}
{foreach from=$reviewers item=reviewer}
	{assign var="isExternalReviewer" value=$reviewer->isLocalizedExternalReviewer()}
	{if $isExternalReviewer==null || $isExternalReviewer!="Yes"}
	{assign var="reviewIndex" value=$reviewIndex+1}
	<div class="separator"></div>
	<table class="data" width="100%">		
			<tr class="reviewer">
				<td class="r1" width="10%" align="center">
					<h4><input type="checkbox" id="reviewer_{$reviewIndex+$start|chr}" name="selectedReviewers[]" value="{$reviewer->getId()}" /></h4>					
				</td>
				<td class="r2" width="60%" align="left">
					<label for="reviewer_{$reviewIndex+$start|chr}"><h4>{$reviewer->getFullName()|escape}</h4></label>
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
					<td align="left">&mdash;</td>
					<td align="left">&mdash;</td>
					<td align="left">&mdash;</td>
					<td align="left">&mdash;</td>					
				</tr>
			</table>
		</td>
	</tr>	
	</table>
	{/if}
{/foreach}
</form>


</div>

