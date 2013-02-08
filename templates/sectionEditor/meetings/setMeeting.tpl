{**
* setMeeting.tpl
* Added by MSB 7/5/2011
*
* Set a meeting
**}

{strip}
{assign var="pageTitle" value="editor.meetings.setMeeting"}
{assign var="pageCrumbTitle" value="editor.meetings.setMeeting"}
{include file="common/header.tpl"}
{/strip}

<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>

{literal}
<script type="text/javascript">
$(document).ready(function() {
	$( "#meetingDate" ).datetimepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd', minDate: '+0 d', ampm:true});
});
</script>
{/literal}

<ul class="menu">
	<li><a href="{url op="meetings"}">{translate key="editor.meetings"}</a></li>
	<li class="current"><a href="{url op="setMeeting"}">{translate key="editor.meetings.setMeeting"}</a></li>
</ul>

{include file="common/formErrors.tpl"}
<div class="separator"></div>
<br>
<div id="submissions">
<h3>{translate key="editor.meetings.submissions"}</h3>
<form method="post" action="{url op="setMeeting" path=$meetingId }" >
<p>{fieldLabel name="selectedProposals" required="true" key="editor.meetings.addProposalsToDiscuss"}</p>
<table class="listing" width="100%">
	<tr><td colspan="7" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">Select</input></td>
		<td width="15%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<!-- <td width="5%">{sort_heading key="submissions.sec" sort="section"}</td> Commented out by MSB, Sept25,2011-->
		<td width="20%">{sort_heading key="article.authors" sort="authors"}</td>
		<td width="25%">{sort_heading key="article.title" sort="title"}</td>
		<td width="25%" align="right">{sort_heading key="common.status" sort="status"}</td>
	</tr>
	<tr><td colspan="7" class="headseparator">&nbsp;</td></tr>
	<p></p>
{assign var="count" value=0}
{foreach from=$submissions item=submission}
{assign var="status" value=$submission->getSubmissionStatus()}
{assign var="decision" value=$submission->getMostRecentDecision() }

{if ($status!=PROPOSAL_STATUS_DRAFT && $status!=PROPOSAL_STATUS_REVIEWED && $status != PROPOSAL_STATUS_EXEMPTED) || $decision==SUBMISSION_EDITOR_DECISION_RESUBMIT}
{assign var="articleId" value=$submission->getArticleId()}
{assign var="whoId" value=$submission->getWhoId($submission->getLocale())}
{assign var="count" value=$count+1}
	<tr valign="top">
			<td>{html_checkboxes id="selectedProposals" name='selectedProposals' values=$submission->getId() checked=$selectedProposals'} </td>
			<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
			<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
			<!-- {* <td>{$submission->getSectionAbbrev()|escape}</td> *} -->
			<!-- {* <td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td> *}  Commented out by MSB -->
   			<td>{$submission->getFirstAuthor(true)|truncate:40:"..."|escape}</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->		
   			<td><a href="{url op="submissionReview" path=$submission->getId()}" class="action">{$submission->getLocalizedTitle()|strip_unsafe_html|truncate:40:"..."}</a></td>
			<td align="right">
				{assign var="proposalStatusKey" value=$submission->getProposalStatusKey()}
				{translate key=$proposalStatusKey}
			</td>
	</tr>
<tr>
<td colspan="7" class="separator">&nbsp;</td>
</tr>
{/if}
{/foreach}
{if $count==0}
<tr>
<td colspan="7" class="nodata">{translate key="submissions.noSubmissions"}</td>
</tr>
<tr>
<td colspan="7" class="endseparator">&nbsp;</td>
</tr>
{else}
<tr>
<td colspan="7" class="endseparator">&nbsp;</td>
</tr>
<tr>
<td colspan="7" align="left">{$count} submission(s)</td>
</tr>
<tr>
<td colspan="7"> &nbsp;</td>
</tr>

{*******************************************************************
* Set meeting date
* Added by ayveemallare
* Last Update: 6/29/2011
*******************************************************************}

<tr valign="top">
<td colspan="7"><h3>{translate key="editor.article.designateMeetingDate"}</h3></td>
</tr>
<tr valign="top">
<td colspan="7">{translate key="editor.article.designateMeetingDateDescription"}</td>
</tr>
<tr valign="top">
<td width="20%" colspan="2" class="label">{fieldLabel name="meetingDate" required="true" key="editor.article.meetingDate"}</td>
<td width="80%" colspan="5" class="value"><input type="text" class="textField" name="meetingDate" id="meetingDate" value="{$meetingDate|date_format:"%Y-%m-%d %I:%M %p"}" size="20" maxlength="255" /></td>
</tr>
{/if}
</table>

<p> {if $meetingId == 0}
		<input type="submit" name="saveMeeting" value="{translate key="common.save"}" class="button defaultButton" />
	{else}
		<input type="submit" name="saveMeeting" value="{translate key="common.save"}" class="button defaultButton" onclick="ans=confirm('Do you want to save the changes?'); if(ans) document.location.href='{url op="saveMeeting" path=$meetingId }'" />
	{/if} 
 	  <input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.back"}" />
 	  </p>
</form>
<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
</div>
{include file="common/footer.tpl"}
