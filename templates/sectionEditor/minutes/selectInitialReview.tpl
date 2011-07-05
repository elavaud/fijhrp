{strip}
{assign var="pageTitle" value="common.queue.long.minutes"}
{url|assign:"currentUrl" page="sectionEditor"}
{include file="common/header.tpl"}
{/strip}

<ul class="menu">
	<li><a href="{url op="index" path="submissionsInReview"}">{translate key="common.queue.short.submissionsInReview"}</a></li>
	<li class="current"><a href="{url op="minutes"}">Upload Minutes</a></li>
	<li><a href="{url op="index" path="submissionsArchives"}">{translate key="common.queue.short.submissionsArchives"}</a></li>
</ul>
<br/>
<div id="selectInitialReview">
<h4>Select Proposal for Initial Review</h4>
<br/>
{if $submissions == null }
	No proposals are assigned for initial ERC Review.
{else}
	
	<table class="data">
		<form method="POST" action="{url op="uploadInitialReview" path=$meetingId}">			
		<tr>
			<td class="label">
				<select name="articleId" id="articleId" class="selectMenu">
					<option value="none">Choose One</option>
					{foreach from=$submissions item=submission}
						<option value="{$submission->getArticleId()}">{$submission->getLocalizedWhoId()}: {$submission->getLocalizedTitle()|strip_unsafe_html}</option>						
					{/foreach}
				</select>								
			</td>		
			<td class="value"><input type="submit" class="button" id="select_button" name="select_button" value="Select Proposal"/></td>	
		</tr>
		</form>	
		<tr>
			<td colspan="6">
				<br/>				
			</td>
		</tr>
	</table>
{/if}	
	<form method="POST" action="{url op="completeInitialReview"}">
		<input type="hidden" name="meetingId" value="{$meetingId}"/>
		<br/><input type="submit" class="button" id="complete" name="complete" value="Complete Initial Reviews"/>&nbsp;&nbsp;&nbsp;&nbsp;<a href="{url op="uploadMinutes" path=$meetingId}">Back to sections of minutes</a>
	</form>
</div>