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
<table><tr width="100%"><td width="30%"><h3>{translate key="user.ercrole.ercMembers"}</h3><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="selectReviewer" path=$submission->getId()|to_array:0:true}" class="action">&#187;&nbsp;{translate key="editor.article.selectExternalReviewer"}</a></td></tr></table>
<table class="data" width="100%">
	<tr id="reviewersHeader" valign="middle">
		<td width="10%"></td>
		<td width="40%" valign="left"><h4>{translate key="common.name"}</h4></td>
		<td width="50%" valign="left"><h4>{translate key="user.interests"}</h4></td>
	</tr>
</table>


{assign var="start" value="A"|ord}
{assign var="reviewIndex" value=0}
{foreach from=$reviewers item=reviewer}
	{assign var="reviewIndex" value=$reviewIndex+1}
	<div class="separator"></div>
	<table class="data" width="100%">		
			<tr class="reviewer">
				<td class="r1" width="10%" align="center">
					<h4><input type="checkbox" id="reviewer_{$reviewIndex+$start|chr}" name="selectedReviewers[]" value="{$reviewer->getId()}" /></h4>					
				</td>
				<td class="r2" width="40%" align="left">
					<label for="reviewer_{$reviewIndex+$start|chr}"><h4>{$reviewer->getFullName()|escape}</h4></label>
				</td>	
				<td class="r3" width="50%" align="left">
					<label for="reviewer_{$reviewIndex+$start|chr}"><h7>{$reviewer->getUserInterests()|escape}</h7></label>
				</td>
			</tr>	
	</table>
{/foreach}
<div class="separator"></div>
<!--
<table class="title">
	<tr>
		<td>
			<h3>External Reviewers</h3>
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="createExternalReviewer" path=$articleId}" class="action">&#187;Create External Reviewer</a>
		</td>
	</tr>
</table>
<table class="data" width="100%">
	<tr id="reviewersHeader" valign="middle">
		<td width="10%"></td>
		<td width="40%" valign="left"><h4>Name</h4></td>
		<td width="50%" valign="left"><h4>Reviewing Interests</h4></td>
	</tr>
</table>
{assign var="start" value="A"|ord}
{assign var="reviewIndex" value=0}
{foreach from=$extReviewers item=reviewer}
	{assign var="reviewIndex" value=$reviewIndex+1}
	<div class="separator"></div>
	<table class="data" width="100%">		
			<tr class="reviewer">
				<td class="r1" width="10%" align="center">
					<h4><input type="checkbox" id="reviewer_{$reviewIndex+$start|chr}" name="selectedReviewers[]" value="{$reviewer->getId()}" /></h4>					
				</td>
				<td class="r2" width="40%" align="left">
					<label for="reviewer_{$reviewIndex+$start|chr}"><h4>{$reviewer->getFullName()|escape}</h4></label>
				</td>	
				<td class="r3" width="50%" align="left">
					<label for="reviewer_{$reviewIndex+$start|chr}"><h7>{$reviewer->getUserInterests()|escape}</h7></label>
				</td>
			</tr>	
	</table>
{/foreach}
{if $reviewIndex == 0}
	<div class="separator"></div>
	<table class="data" width="100%">		
			<tr class="reviewer">
				<td align="center"><i>No external reviewers into the database.</i></td>
			</tr>	
	</table>
{/if}
<div class="separator"></div>
-->
<br/><input type="submit" class="button" value="Select And Notify ERC Members for Primary Review" />						
</form>
</div>
