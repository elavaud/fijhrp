{include file="sectionEditor/minutes/menu.tpl"}

<h4>{translate key="editor.minutes.proposalsForInitialReview"}</h4>
<br/>
{if count($submissions) == 0 }
	{translate key="editor.minutes.noProposalsForInitialReview"}
{else}
<form method="POST" action="{url op="selectInitialReview" path=$meeting->getId()}">			
			
	<div id="selectInitialReview">
		<table class="data">
			<tr>
				<td class="label">
					{fieldLabel name="articleId" required="true" key="editor.minutes.selectProposal"}													
				</td>		
				<td class="value">
					<select name="articleId" id="articleId" class="selectMenu">
						<option value="none">Choose One</option>
						{foreach from=$submissions item=submission}
							<option value="{$submission->getArticleId()}">{$submission->getLocalizedWhoId()}: {$submission->getLocalizedTitle()|strip_unsafe_html}</option>						
						{/foreach}
					</select>
				</td>	
			</tr>
			<tr>
				<td colspan="6">
					<br/>				
				</td>
			</tr>
		</table>
	</div>
{/if}	
<br/>
<input type="submit" class="button" name="selectProposal" value="Select Proposal"/> 			
<input type="button" class="button" onclick="document.location.href='{url op="uploadMinutes" path=$meeting->getId()}'" value="{translate key="common.back"}" />
</form>	