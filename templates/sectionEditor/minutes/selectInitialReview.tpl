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
							{assign var="abstract" value=$submission->getLocalizedAbstract()}
							<option value="{$submission->getArticleId()}">{$submission->getLocalizedProposalId()}: {$abstract->getScientificTitle()|strip_unsafe_html|truncate:60:"..."|escape}</option>						
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
<input type="button" class="button" onclick="document.location.href='{url op="manageMinutes" path=$meeting->getId()}'" value="{translate key="common.back"}" />
</form>	
{include file="common/footer.tpl"}
