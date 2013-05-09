{**
 * toSubmit.tpl
 *
 * Show the details of proposals to submit.
 *
 * $Id$
 *}

<div id="submissions">
<table class="listing" width="100%">
	<tr class="heading" valign="bottom">
		<td width="10%">{translate key="common.proposalId"}</td>
		<td width="10%"><span class="disabled">{sort_heading key="submissions.submit" sort="submitDate"}</td>
		<td width="50%">{sort_heading key="article.title" sort="title"}</td>
		<td width="30%" align="right">{translate key="common.action"}</td>
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>

{iterate from=submissions item=submission}
	{assign var="articleId" value=$submission->getArticleId()}
	{assign var="abstract" value=$submission->getLocalizedAbstract()}
    {assign var="proposalId" value=$submission->getLocalizedProposalId()}
        <tr valign="top">
            <td>{if $proposalId}{$proposalId|escape}{else}&mdash;{/if}</td>
            <td>{if $submission->getDateSubmitted()}{$submission->getDateSubmitted()|date_format:$dateFormatLong}{else}&mdash;{/if}</td>                
            <td><a href="{url op="submission" path=$articleId}" class="action">{if $abstract}{$abstract->getScientificTitle()|escape}{else}{translate key="common.untitled"}{/if}</a></td>
            <td align="right">
                <a href="{url op="addRawDataFile" path=$articleId}" title="{translate key="author.submit.uploadRawDataInstruct"}" class="action">{translate key="author.submit.uploadRawData.short"} &#8226;</a><br />
                <a href="{url op="addOtherSuppResearchOutput" path=$articleId}" title="{translate key="author.submit.submitOtherOutputsInstruct"}" class="action">{translate key="author.submit.submitOtherOutputs.short"} &#8226;</a><br />
                <a href="{url op="sendToArchive" path=$articleId}" class="action">{translate key="common.sendtoarchive"} &#8226;</a><br />            
            </td>
        </tr>
        <tr>
        	<td colspan="4" class="{if $submissions->eof()}end{/if}separator">&nbsp;</td>
        </tr>
{/iterate}
{if $submissions->wasEmpty()}
	<tr>
		<td colspan="4" class="nodata">{translate key="submissions.noSubmissions"}</td>
	</tr>
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
{else}
	<tr>
		<td colspan="2" align="left">{page_info iterator=$submissions}</td>
		<td colspan="2" align="right">{page_links anchor="submissions" name="submissions" iterator=$submissions sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>
