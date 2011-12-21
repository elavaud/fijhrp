{include file="sectionEditor/minutes/menu.tpl"}
{literal}
<script type="text/javascript">
	$(document).ready(function() {			
		var quantity = $("#discussions").length;
		$(".discussionType").change(
				function() {
						var elemId = $(this).attr('id').substring(15);
						var elemVal = $("#discussionType-"+elemId).val();
						if(elemVal == 0){
							$("#typeOther-"+elemId).show();
						}else{
							$("#typeOther-"+elemId).hide();
						}
				}
			);
			$("#addDiscussion").click(
					function() {
						var clone = $("#discussions tr:last").clone(true);
							 clone.find('div').attr('id', 'typeOther-'+quantity);
							 clone.find('select').attr('id', 'discussionType-'+quantity);
							 $("#discussions tr:last").after(clone);
							 quantity = quantity + 1;
						}
			);
	});
	
</script>
{/literal}
<div id="submissions">
<form method="post" action="{url op="uploadContinuingReview" path=$meeting->getId()|to_array:$submission->getId()}">
	<input type="hidden" name="articleId" value="{$submission->getId()}" />
	<input type="hidden" name="lastDecisionId" value="{$lastDecision.editDecisionId}" />
	<input type="hidden" name="resubmitCount" value="{$lastDecision.resubmitCount}" />
<h4>{translate key="editor.minutes.proposal.continuingReview"}&nbsp;{$submission->getLocalizedWhoId()}</h4>
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
			<td width="20%"><br/>{fieldLabel name="discussionType" required="true"  key="editor.minutes.specificDiscussion"}&nbsp;&nbsp;<input type="button" id="addDiscussion" value="+"/></td>
			<td width="80%"></td>
		</tr>
		{foreach from=$discussionText key=idx item=discussion}
			{if $discussion!=null}
			<tr>
				<td width="20%" class="label">{fieldLabel name="discussionText" required="true" key="editor.minutes.specificDiscussion"}</td>
				<td width="80%" class="value">
					{html_options_translate name="discussionType[]" class="discussionType" id="discussionType-$idx" options=$discussionTypes selected=$discussionType[$idx]}<br/>
					<div id="typeOther-$idx"  {if $discussionType[$idx] != 0 } style="display:none" {/if}>
					Please specify *
					<input type="text"  class="textField" size="30" name="typeOther[]" id="typeOther-$idx" value="{$typeOther[$idx]}"/>
					</div>
					<br/>
					<textarea name="discussionText[]" class="textArea" rows="10" cols="43" >{$discussion}</textarea>
				</td>
			</tr>
			{/if}
		{/foreach}
		<tr>
			<td width="20%" class="label"></td>
			<td width="80%" class="value">
				{html_options_translate name="discussionType[]" class="discussionType" id="discussionType-0" options=$discussionTypes }<br/>
				<div id="typeOther-0" style="display:none" >
				Please specify *
				<input type="text"  class="textField"  size="30" name="typeOther[]" value=""><br/>
				</div>
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
			<td><textarea name="stipulations" class="textArea" rows="10" cols="50">{$stipulations}</textarea></td>
		</tr>
		<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
		<tr>
			<td class="label" width="20%">{translate key="editor.minutes.recommendations"}</td>
			<td><textarea name="recommendations" class="textArea" rows="10" cols="50">{$recommendations}</textarea></td>
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
				<input type="radio" class="unanimous" name="unanimous" id="unanimousYes" value="Yes" {if $unanimous=="Yes"}checked="checked"{/if}/><label for="unanimousYes">Yes</label>
				<input type="radio" class="unanimous" name="unanimous" id="unanimousNo" value="No" {if $unanimous=="No"}checked="checked"{/if}/><label for="unanimousNo">No</label>
			</td>
		</tr>		
		<tr><td colspan="6" class="headseparator"><br/>&nbsp;<br/></td></tr>
		<tr class="heading">
			<td colspan="6">{fieldLabel name="votes" key="editor.minutes.votes"}</td>				
		</tr>
		<tr >
			<td class="label" align="right">{fieldLabel name="votesApprove" key="editor.minutes.approveCount"}</td>
			<td class="value"><input type="text" name="votesApprove" size="17" class="textField" value="{$votesApprove}"/></td>
		</tr>
		<tr >
			<td class="label" align="right">{fieldLabel name="votesNotApprove" key="editor.minutes.notApproveCount"}</td>
			<td class="value"><input type="text" name="votesNotApprove" size="17" class="textField" value="{$votesNotApprove}"/></td>
		</tr>
		<tr >
			<td class="label" align="right">{fieldLabel name="votesAbstain" key="editor.minutes.abstainCount"}</td>
			<td class="value"><input type="text" name="votesAbstain" size="17" class="textField" value="{$votesAbstain}"/></td>
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
 	<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="editor.minutes.confirmContinuingReview"}')" name="submitContinuingReview" value="Submit Continuing Review"  class="button defaultButton" />
 	<input type="button" class="button" onclick="document.location.href='{url op="selectContinuingReview" path=$meeting->getId()}'" value="{translate key="common.back"}" />
 	</form>
</div>
