 {include file="sectionEditor/minutes/menu.tpl"}
<div id="selectInitialReview">
<h4>Select Proposal for Initial Review</h4>
<br/>
{if $submissions == null }
	No proposals are assigned for initial ERC Review.
{else}
	
	<table class="data">
		{foreach from=$submissions item=submission}
		<tr>
			<td class="label">
					<a href="{url op="uploadInitialReview" path=$meetingId|to_array:$submission->getArticleId()}" >
						{$submission->getLocalizedWhoId()}: {$submission->getLocalizedTitle()|strip_unsafe_html}
					</a>
			</td>
		</tr>
		<tr><td class="separator">&nbsp;</td></tr>
		{/foreach}
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