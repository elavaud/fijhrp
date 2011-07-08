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
	<li><a href="{url op="minutes"}">{translate key="editor.meetings.uploadMinutes"}</a></li>
</ul>

<div class="separator"></div>

<div id="details">
<h2>{translate key="reviewer.meetings.details}</h2>
<table width="100%" class="data">
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.meetings.meetingId"}</td>
		<td class="value" width="80%">{$meeting->getId()}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.meetings.meetingDate"}</td>
		<td class="value" width="80%">{$meeting->getDate()|date_format:"%Y-%m-%d %I:%M %p"}</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="editor.meetings.scheduleStatus"}</td>
		<td class="value" width="80%">{$meeting->getScheduleStatus()}</td>
	</tr>
	<tr valign="top">
		<td colspan="2">
		<!-- LIST ATTENDING REVIEWERS
		<table width="50%" class="data">
				<tr valign="top">
					<td>
					{assign var="count" value=0}
					{foreach from=$reviewers item=reviewer}
						{if $reviewer->getIsAttending() == 1}
						{$reviewer->getSalutation()} &nbsp; {$reviewer->getFirstName()} &nbsp; {$reviewer->getLastName()}
						{/if}
						{assign var="count" value=$count+1}
					{/foreach}
					</td>
				</tr>
			</table>  -->
		</td>
	</tr>
</table>
</div>
<div class="separator"></div>
<br>
<div id="reviewers">
	<h2>{translate key="editor.meetings.reviewers"}</h2>
	<table class="listing" width="100%">
		<tr><td colspan="3" class="headseparator" ></td></tr>
		<tr class="heading" valign="bottom">
			<td width="20%"> {translate key="editor.meetings.reviewer.name"}</td>
			<td width="60%"> {translate key="editor.meetings.reviewer.reply"} </td>
			<td width="20%" align="right"> {translate key="editor.meetings.reviewer.replyStatus"} </td>
		</tr>
		<tr><td colspan="3" class="headseparator" ></td></tr>
		{assign var="count" value=0}
		{foreach from=$reviewers item=reviewer}
		<tr>
			<td width="20%">{$reviewer->getSalutation()} &nbsp; {$reviewer->getFirstName()} &nbsp; {$reviewer->getLastName()}</td>
			<td width="60%">{$reviewer->getRemarks()}</td>
			<td width="20%">{$reviewer->getIsAttending()}</td>
		</tr>
		<tr>
		<td colspan="3" class="separator">&nbsp;</td>
		</tr>
		{assign var="count" value=$count+1}
		{/foreach}
		{if empty($reviewers)}
		<tr>
			<td colspan="3" class="nodata">{translate key="editor.meetings.reviewer.noReviewers"}</td>
		</tr>
		{/if}
		<tr>
			<td colspan="3" class="endseparator">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="left">{$reviwers|@count} reviewers(s)</td>
		</tr>
	</table>
</div>
<div class="separator"></div>
<br>
<div id="submissions">
<h2>{translate key="editor.meetings.submissions"}</h2>
<form method="post" action="{url op="saveMeeting" path=$meeting->getId() }" >
<table class="listing" width="100%">
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
<td colspan="7"><h2>{translate key="editor.article.designateMeetingDate"}</h2></td>
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

<p><input type="submit" value="{translate key="common.update"}" class="button defaultButton" /> 
   <input type="button" value="{translate key="common.setFinal"}" class="button defaultbutton"
    onclick="document.location.href='{url op="setMeetingFinal" path=$meeting->getId() }'" />
   <input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" /></p>
</form>

</div>
{include file="common/footer.tpl"}
