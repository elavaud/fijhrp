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
		<td width="15%"><h3>{translate key="submission.peerReview"}</h3></td>
		{**<td width="20%"><h4>{translate key="submission.round" round=$round}</h4></td>**}
		<td width="80%" valign="bottom">
			<input type="submit" class="button" value="Select As Reviewers" />						
		</td>
	</tr>
</table>



{foreach from=$reviewers item=reviewer}
	<div class="separator"></div>

	<table class="data" width="100%">
	<tr class="reviewer">
		<td class="r3" width="15%" align="center">
			<h4><input type="checkbox" name="selectedReviewers[]" value="{$reviewer->getId()}" /></h4>
		</td>		
		<td class="r2" width="80%" align="left">
			<h4>{$reviewer->getFullName()|escape}</h4>
		</td>		
	</tr>
	</table>
{/foreach}
</form>


</div>

