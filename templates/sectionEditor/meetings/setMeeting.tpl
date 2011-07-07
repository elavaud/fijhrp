{**
* setMeeting.tpl
* Added by MSB 7/5/2011
*
* Set a meeting
**}

{strip}
{assign var="pageTitle" value="editor.meetings.setMeeting"}
{include file="common/header.tpl"}
{/strip}

{literal}

<script type="text/javascript" src="http://localhost/projects/whorrp/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"></script>
<style type="text/css" src="http://localhost/projects/whorr/lib/pkp/styles/jquery-ui-timepicker-addon.css"></style>

<script type="text/javascript">
$(document).ready(function() {
// $( "#meetingDate" ).datetimepicker({changeMonth: true, changeYear: true, dateFormat: 'yy-mm-dd', minDate: '+0 d', ampm:true});
$( "#meetingDate" ).datepicker({changeMonth: true, changeYear: true, minDate: '+0 d'});

});
</script>
{/literal}
<!-- 
<div id="reviewersResponse">
<table>
<tr><td>
Reviewers</td>
</tr>
<tr>
	<td>
	{assign var="count" value=0}
	{foreach from=$reviewers item=reviewers}
		
	{/foreach}
	</td>
</tr>
</table>
</div>
-->



<div id="setMeeting">
<form method="post" action="{url op="saveMeeting" path=$meeting->getId() }" >
<table class="listing" width="100%">
<tr><td colspan="7">ACTIVE PROPOSALS (Awaiting Decision/Revise and Resubmit)</td></tr>
<tr><td colspan="7" class="headseparator">&nbsp;</td></tr>
<tr class="heading" valign="bottom">
<td width="5%">Select</input></td>
<td width="15%">WHO Proposal ID</td>
<td width="5%"><span class="disabled">{translate key="submission.date.mmdd"}</span><br />{sort_heading key="submissions.submit" sort="submitDate"}</td>
<td width="5%">{sort_heading key="submissions.sec" sort="section"}</td>
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
	<!-- <td><input type="checkbox" name="proposals[]" id="proposals[]" value="{$submission->getId()}" ></td>-->
</b>
<td>{html_checkboxes id="selectedProposals" name='selectedProposals' values=$submission->getId() checked=$selectedProposals'} </td>
<td>{if $whoId}{$whoId|escape}{else}&mdash;{/if}</td>
<td>{$submission->getDateSubmitted()|date_format:$dateFormatTrunc}</td>
<td>{$submission->getSectionAbbrev()|escape}</td>
<td>{$submission->getAuthorString(true)|truncate:40:"..."|escape}</td>
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
<td colspan="7"><h2>{translate key="editor.article.designateMeetingDate"}</h3></td>
</tr>
<tr valign="top">
<td colspan="7">{translate key="editor.article.designateMeetingDateDescription"}</td>
</tr>
<tr valign="top">
<td width="20%" colspan="2" class="label">{translate key="editor.article.meetingDate"}</td>
<td width="80%" colspan="5" class="value"><input type="text" class="textField" name="meetingDate" id="meetingDate" value="{$meeting->getDate()|date_format:"%Y-%m-%d %I:%M %p"}" size="20" maxlength="255" /></td>
</tr>
{/if}
</table>

<p><input type="submit" value="{translate key="common.continue"}" class="button defaultButton" /> <input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" /></p>
</form>

</div>
{include file="common/footer.tpl"}