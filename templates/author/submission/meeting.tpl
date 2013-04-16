{**
 * meeting.tpl
 *
 * Display meeting information
 *
 *}
<div id="authorFees">
<h3>{translate key="reviewer.meeting"}</h3>
<table width="100%">
{foreach from=$meetingsAndAttendances item=meetingAndAttendance}
	<tr>
		<td width="50%" valign="top">
			<table width="100%" class="data">
				<tr>
					<td colspan="2"><b>{translate key="reviewer.meetings.details"}</b></td>
				</tr>
				<tr>
					<td class="label" width="40%">{translate key="editor.meeting.id"}</td>
					<td class="value" width="60%">{$meetingAndAttendance.meeting->getPublicId()}</td>
				</tr>
				<tr>
					<td class="label" width="40%">{translate key="editor.meeting.schedule"}</td>
					<td class="value" width="60%">{$meetingAndAttendance.meeting->getDate()|date_format:$datetimeFormatLong}</td>
				</tr>
				<tr>
					<td class="label" width="40%">{translate key="editor.meeting.length"}</td>
					<td class="value" width="60%">{$meetingAndAttendance.meeting->getLength()} mn</td>
				</tr>
				<tr>
					<td class="label" width="40%">{translate key="editor.meeting.location"}</td>
					<td class="value" width="60%">{$meetingAndAttendance.meeting->getLocation()}</td>
				</tr>
				<tr>
					<td class="label" width="40%">{translate key="reviewer.meetings.scheduleStatus"}</td>
					<td class="value" width="60%">{$meetingAndAttendance.meeting->getStatusKey()}</td>
				</tr>
			</table>
		</td>
		<td width="50%" valign="top">
			<form method="post" action="{url op="replyMeeting"}" >
				<table width="100%" class="data">
					<tr>
						<td colspan="2"><b>{translate key="reviewer.meetings.replyStatus"}</b></td>
					</tr>
					<tr>
						<td class="label" width="40%">{translate key="reviewer.meetings.lastReply"}:</td>
						<td class="value" width="60%">
							{if $meetingAndAttendance.attendance->getIsAttending() != 3}
								{if $meetingAndAttendance.attendance->getIsAttending() == 1}
									{translate key="common.yes"}
								{elseif $meetingAndAttendance.attendance->getIsAttending() == 2}
									{translate key="common.no"}
								{elseif $meetingAndAttendance.attendance->getIsAttending() == 0}
									{translate key="common.undecided"}
								{/if}
								{if $meetingAndAttendance.attendance->getRemarks() != ''}
									({$meetingAndAttendance.attendance->getRemarks()})
								{/if}
							{else}
								{translate key="reviewer.meetings.replyStatus.awaitingReply"}
							{/if}
						</td>
					</tr>
					<tr valign="top">
						<td class="label">{translate key="reviewer.article.schedule.isAttending"} </td>
						<td class="value">	
							<input type="radio" name="isAttending" value="1" {if $meetingAndAttendance.attendance->getIsAttending() == 1}checked="checked"{/if}> </input> {translate key="common.yes"}
							<input type="radio" name="isAttending" value="2" {if $meetingAndAttendance.attendance->getIsAttending() == 2}checked="checked"{/if}> </input> {translate key="common.no"}
							<input type="radio" name="isAttending" value="0" {if $meetingAndAttendance.attendance->getIsAttending() == 0}checked="checked"{/if}> </input> {translate key="common.undecided"}
						</td>
					</tr> 
					<tr>
						<td class="label">{translate key="reviewer.article.schedule.remarks"} </td>
						<td class="value">
							<textarea class="textArea" name="remarks" rows="2" cols="30" />{$meetingAndAttendance.attendance->getRemarks()|escape}</textarea>
						</td>
					</tr>
					<tr>
						<td class="label">&nbsp;</td>
						<td class="value">
							<input type="hidden" name="meetingId" value={$meetingAndAttendance.attendance->getMeetingId()}> </input>
							<input type="hidden" name="submissionId" value={$submission->getId()}> </input>
							<input type="submit" value="{translate key="common.save"}" class="button defaultButton" />
						</td>
					</tr>
				</form>
			</table>
		</td>
	</tr>
{/foreach}
</table>
</div>
