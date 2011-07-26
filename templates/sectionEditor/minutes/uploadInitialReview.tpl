{include file="sectionEditor/minutes/menu.tpl"}
{literal}
<script type="text/javascript">
<!--
	$(document).ready(function() {			
			$("#addDiscussion").click(
					function() {
						$("#discussions tr:last").after($("#discussions tr:last").clone());
					}
				);
		});
-->
</script>
{/literal}
<div id="submissions">
<form method="post" action="{url op="uploadInitialReview" path=$meeting->getId()|to_array:$submission->getId()}">
	<input type="hidden" name="articleId" value="{$submission->getId()}" />
	<input type="hidden" name="lastDecisionId" value="{$lastDecision.editDecisionId}" />
	<input type="hidden" name="resubmitCount" value="{$lastDecision.resubmitCount}" />
<h4>{translate key="editor.minutes.proposal.initialReview"}&nbsp;{$submission->getLocalizedWhoId()}</h4>
<br/>	
	<table class="data" width="100%">
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.protocolTitle"}</td>
			<td class="value" width="80%">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.whoId"}</td>
			<td class="value" width="80%">{$submission->getLocalizedWhoId()}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.pi"}</td>
			<td class="value">{$submission->getAuthorString()|strip_unsafe_html|truncate:100:"..."}</td>
		</tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.responsibleRto"}</td>
			<td class="value">
				{assign var="submitter" value=$submission->getUser()}
				{$submitter->getFullName()|escape|strip_unsafe_html|truncate:100:"..."}
			</td>
		</tr>
		<tr>
			<td width="20%">{fieldLabel name="summary" required="true" key="editor.minutes.summary"}<br/><br/></td>
			<td class="value">
				{assign var="summaryFile" value=$submission->getSummaryFile()}
				{if $summaryFile!=null}
					Summary in Supplementary File: {$summaryFile}
				{else}
					<textarea name="summary" id="summary" class="textArea" rows="10" cols="43" >{$summary}</textarea>
				{/if}
			<br/><br/>
			</td>
		</tr>
		<tr>
			<td width="20%">{fieldLabel name="wproRole" required="true" key="editor.minutes.wproRole"}<br/><br/></td>
			<td class="value">
				<textarea name="wproRole" class="textArea" rows="10" cols="43" >{$wproRole}</textarea>
			</td>
		</tr>
	</table>
	<div class="separator"></div>
	<table class="data" width="100%" id="discussions">
		<tr class="heading" valign="bottom">
			<td width="20%" colspan="6"><br/>{translate key="editor.minutes.discussion"}</td>			
		</tr>
		<tr>
			<td width="20%">{fieldLabel name="generalDiscussion" required="true" key="editor.minutes.generalDiscussion"}</td>
			<td class="value"><textarea name="generalDiscussion" class="textArea" rows="10" cols="43" >{$generalDiscussion}</textarea></td>
		</tr>		
		<tr>
			<td width="20%"><br/>{translate key="editor.minutes.specificDiscussion"}&nbsp;&nbsp;<input type="button" id="addDiscussion" value="+"/></td>
			<td width="80%"></td>
		</tr>
		{foreach from=$discussionText key=idx item=discussion}
			{if $discussion!=null}
			<tr>
				<td width="20%" class="label"></td>
				<td width="80%" class="value">
					{html_options_translate name="discussionType[]" options=$discussionTypes selected=$discussionType[$idx]}<br/>
					{fieldLabel name="specifyType" required="true" key="editor.minutes.specify"}&nbsp;
					<input type="text" class="textField" size="32" name="typeOther[]" value="{$typeOther[$idx]}"/><br/>
					<textarea name="discussionText[]" class="textArea" rows="10" cols="43" >{$discussion}</textarea>
				</td>
			</tr>
			{/if}
		{/foreach}
		<tr>
			<td width="20%" class="label"></td>
			<td width="80%" class="value">
				{html_options_translate name="discussionType[]" options=$discussionTypes }<br/>
				{fieldLabel name="specifyType" required="true" key="editor.minutes.specify"}&nbsp;
				<input type="text" class="textField" size="32" name="typeOther[]" value=""><br/>
				<textarea name="discussionText[]" class="textArea" rows="10" cols="43" ></textarea>
			</td>
		</tr>				
	</table>
		<br/>
		<div class="separator"></div>
		<br/>
	<table class="data" width="100%" id="stipulationsRecommendations">		
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.stipulations"}</td>
			<td><textarea name="stipulations" class="textArea" rows="10" cols="60">{$stipulations}</textarea></td>
		</tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.recommendations"}</td>
			<td><textarea name="recommendations" class="textArea" rows="10" cols="60">{$recommendations}</textarea></td>
		</tr>
	</table>
	<br/>
	<div class="separator"></div>
	<br/>
	<table class="data" width="100%" id="decisionTable">		
		<tr class="heading">
			<td colspan="6">{translate key="editor.minutes.decision"}</td>
		</tr>
		<tr>
			<td class="label" width="20%" align="right">{fieldLabel name="decision" required="true" key="editor.article.selectDecision"}</td>
			<td width="80%" class="value">
					<select name="decision" id="decision" size="1" class="selectMenu">
						{html_options_translate options=$submission->getEditorDecisionOptions() selected=$decision}
					</select>																						
			</td>			
		</tr>
		<tr>
			<td class="label" width="20%" align="right">{fieldLabel name="unanimous" required="true" key="editor.minutes.unanimous"}</td>
			<td width="80%" class="value">
				<input type="radio" name="unanimous" id="unanimousYes" value="Yes" {if $unanimous=="Yes"}checked="checked"{/if}/><label for="unanimousYes">Yes</label>
				<input type="radio" name="unanimous" id="unanimousNo" value="No" {if $unanimous=="No"}checked="checked"{/if}/><label for="unanimousNo">No</label>
			</td>
		</tr>		
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">{fieldLabel name="votes" key="editor.minutes.votes"}</td>				
		</tr>
		<tr>
			<td class="label" align="right">{fieldLabel name="votes[0]" key="editor.minutes.approveCount"}</td>
			<td class="value"><input type="text" name="votes[0]" size="17" class="textField"/>{$votes[0]}</td>
		</tr>
		<tr>
			<td class="label" align="right">{fieldLabel name="votes[1]" key="editor.minutes.notApproveCount"}</td>
			<td class="value"><input type="text" name="votes[1]" size="17" class="textField"/>{$votes[1]}</td>
		</tr>
		<tr>
			<td class="label" align="right">{fieldLabel name="votes[2]" key="editor.minutes.abstainCount"}</td>
			<td class="value"><input type="text" name="votes[2]" size="17" class="textField"/>{$votes[2]}</td>
		</tr>
		<tr>
			<td width="20%" class="label">{fieldLabel name="minorityReason" key="editor.minutes.minorityReasons"}</td>
			<td class="value"><textarea name="minorityReason" class="textArea" rows="10" cols="40">{$minorityReason}</textarea></td>
		</tr>
		<tr>
			<td width="20%" class="label">{fieldLabel name="chairReview" key="editor.minutes.chairReview"}</td>
			<td class="value"><textarea name="chairReview" class="textArea" rows="10" cols="40" >{$chairReview}</textarea></td>
		</tr>
	</table>	
  	<br/>
 	<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.minutes.confirmInitialReview"}')" name="submitInitialReview" value="Submit Initial Review"  class="button defaultButton" />
 	<input type="button" class="button" onclick="document.location.href='{url op="selectInitialReview" path=$meeting->getId()}'" value="{translate key="common.back"}" />
 	</form>
</div>
