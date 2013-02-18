{**
 * searchUsers.tpl
 *
 * Search form for enrolled users.
 *
 * $Id$
 *
 *}
{strip}
{translate|assign:"pageTitleTranslated" key="manager.people.roleEnrollment" role=$roleName|translate}
{include file="common/header.tpl"}
{/strip}

<form name="disableUser" method="post" action="{url op="disableUser"}">
	<input type="hidden" name="reason" value=""/>
	<input type="hidden" name="userId" value=""/>
</form>


{literal}
<script type="text/javascript">
<!--
function confirmAndPrompt(userId) {
	var reason = prompt('{translate|escape:"javascript" key="manager.people.confirmDisable"}');
	if (reason == null) return;

	document.disableUser.reason.value = reason;
	document.disableUser.userId.value = userId;

	document.disableUser.submit();
}

function toggleChecked() {
	var elements = document.enroll.elements;
	for (var i=0; i < elements.length; i++) {
		if (elements[i].name == 'users[]') {
			elements[i].checked = !elements[i].checked;
		}
	}
}
// -->

function checkSelected(){
	var elements = document.enroll.elements;
	var countSelected = 0;
	for (var i=0; i < elements.length; i++) {
		if (elements[i].name == 'users[]') {
			if (elements[i].checked) {
				countSelected++;
			}
		}
	}
	return countSelected;
}

function showOrHideEthicsCommittee(value){
	if (value == 0x00001000) {
		document.getElementById('ethicsCommitteeField').style.display = '';
	} else {
		document.getElementById('ethicsCommitteeField').style.display = 'none';
		$('#ethicsCommittee').val("NA");
		document.getElementById('ercMemberStatusField').style.display = 'none';
		$('#ercMemberStatus').val("NA");
	}
}

function showOrHideErcMemberStatus(value){
	if (value != "NA") {
		document.getElementById('ercMemberStatusField').style.display = '';
	} else {
		document.getElementById('ercMemberStatusField').style.display = 'none';
	}
}

<!-- Added by EL on April 25, 2012: Management of the ERC Status -->

$(document).ready(
    function() {
	}
);
</script>
{/literal}

{if not $omitSearch}
	<form method="post" name="submit" action="{url op="enrollSearch"}">
	<input type="hidden" name="roleId" value="{$roleId|escape}"/>
		<select name="searchField" size="1" class="selectMenu">
			{html_options_translate options=$fieldOptions selected=$searchField}
		</select>
		<select name="searchMatch" size="1" class="selectMenu">
			<option value="contains"{if $searchMatch == 'contains'} selected="selected"{/if}>{translate key="form.contains"}</option>
			<option value="is"{if $searchMatch == 'is'} selected="selected"{/if}>{translate key="form.is"}</option>
			<!--<option value="startsWith"{if $searchMatch == 'startsWith'} selected="selected"{/if}>{translate key="form.startsWith"}</option>--> <!-- Totally uneseful and wasn't working. EL on February 12th 2013 -->
		</select>
		<input type="text" size="15" name="search" class="textField" value="{$search|escape}" />&nbsp;<input type="submit" value="{translate key="common.search"}" class="button" />
	</form>

	<p>{foreach from=$alphaList item=letter}<a href="{url op="enrollSearch" searchInitial=$letter roleId=$roleId}">{if $letter == $searchInitial}<strong>{$letter|escape}</strong>{else}{$letter|escape}{/if}</a> {/foreach}<a href="{url op="enrollSearch" roleId=$roleId}">{if $searchInitial==''}<strong>{translate key="common.all"}</strong>{else}{translate key="common.all"}{/if}</a></p>
{/if}

<form name="enroll" onsubmit="return enrollUser(0)" action="{if $roleId}{url op="enroll" path=$roleId}{else}{url op="enroll"}{/if}" method="post">
{if !$roleId}
    <table width="100%" class="data">
	<div id=enrollUserAs>
	<tr valign="top" id="roleIdField">
    	<td width="20%" class="label"><strong>{translate key="common.enroll"}</strong></td>
    	<td width="80%" class="value">
			<select name="roleId" id="roleId" class="selectMenu" onchange="showOrHideEthicsCommittee(this.value);">
				<option value="{$smarty.const.ROLE_ID_JOURNAL_MANAGER}">{translate key="user.role.manager"}</option>
				<option value="{$smarty.const.ROLE_ID_REVIEWER}">Ethics Committee</option>
				<option value="{$smarty.const.ROLE_ID_AUTHOR}">{translate key="user.role.author"}</option>
				<option value="{$smarty.const.ROLE_ID_EDITOR}">{translate key="user.role.coordinator"}</option>
				<option value="ExtReviewer">{translate key="user.ercrole.extReviewer"}</option>
					<!-- Commented out - el - 19 April 2012 -->
	        		{*	<option value="{$smarty.const.ROLE_ID_SECTION_EDITOR}">{translate key="user.role.sectionEditor"}</option> 
					{if $roleSettings.useLayoutEditors}
					<option value="{$smarty.const.ROLE_ID_LAYOUT_EDITOR}">{translate key="user.role.layoutEditor"}</option>
					{/if}
					{if $roleSettings.useCopyeditors}
					<option value="{$smarty.const.ROLE_ID_COPYEDITOR}">{translate key="user.role.copyeditor"}</option>
					{/if}
					{if $roleSettings.useProofreaders}
					<option value="{$smarty.const.ROLE_ID_PROOFREADER}">{translate key="user.role.proofreader"}</option>
					{/if}*}
					<!--	<option value="{$smarty.const.ROLE_ID_READER}">{translate key="user.role.reader"}</option> Edited by MSB, Nov17, 2011-->
					<!--	<option value="{$smarty.const.ROLE_ID_SUBSCRIPTION_MANAGER}">{translate key="user.role.subscriptionManager"}</option> Edited by MSB, Nov17, 2011-->
			</select>
		</td>
	</tr>
	
	<!-- Modified for handling a various numbers of ERCs-->
	<tr valign="top" id="ethicsCommitteeField"  style="display: none;">
		<td width="20%" class="label"><strong>Ethics Committee :</strong></td>
		<td width="80%" class="value">
			<select name="ethicsCommittee" id="ethicsCommittee" class="selectMenu" onchange="showOrHideErcMemberStatus(this.value);">
				<option value="NA"></option>
				{iterate from=sections item=section name=sections}
					<option value="{$section->getSectionId()}">{$section->getSectionTitle()}</option>
				{/iterate}
			</select>
		</td>
	</tr>
	
	<!-- Added by EL on April 25, 2012: Management of the ERC Status -->
    <tr valign="top" id="ercMemberStatusField" style="display: none;">
        <td width="20%" class="label"><strong>Status :</strong></td>
        <td width="80%" class="value">
			<select name="ercMemberStatus" id="ercMemberStatus" class="selectMenu">
				<option value="NA"></option>
				<option value="Chair">Chair</option>
				<option value="Vice-Chair">Vice-Chair</option>
				<option value="Secretary">Secretary</option>
				<!--<option value="ERC, Secretary Administrative Assistant">Secretary Administrative Assistant</option>-->
				<option value="Member">Member</option>
				<!--<option value="ERC, External Member">External Member</option>-->
			</select>
		</td>
	</tr>
	<!-- End of management of the ERC Status -->
	
	</table>
	{literal}
	<script type="text/javascript">
	<!--
	function enrollUser(userId) {
		var fakeUrl = '{url op="enroll" path="ROLE_ID" userId="USER_ID"}';
		if (document.enroll.roleId.options[document.enroll.roleId.selectedIndex].value == '') {
			alert("{translate|escape:"javascript" key="manager.people.mustChooseRole"}");
			return false;
		}
		if (userId != 0){
		fakeUrl = fakeUrl.replace('ROLE_ID', document.enroll.roleId.options[document.enroll.roleId.selectedIndex].value);
		fakeUrl = fakeUrl.replace('USER_ID', userId);
		location.href = fakeUrl;
	}
	}
	// -->
	</div>
	</script>
	{/literal}
{/if}

<div id="users">
<table width="100%" class="listing">
<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<tr class="heading" valign="bottom">
	<td width="5%">&nbsp;</td>
	<td width="20%">{sort_heading key="user.username" sort="username"}</td>
	<td width="30%">{sort_heading key="user.name" sort="name"}</td>
	<td width="10%">Function(s)</td>
	<td width="30%">{sort_heading key="user.email" sort="email"}</td>
	<td width="10%" align="right">{translate key="common.action"}</td>
</tr>
<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
{iterate from=users item=user}
{assign var="userid" value=$user->getId()}
{assign var="stats" value=$statistics[$userid]}
<tr valign="top">
	<td><input type="checkbox" name="users[]" value="{$user->getId()}" onclick="showOrHideButtons()" /></td>
	<td><a class="action" href="{url op="userProfile" path=$userid}">{$user->getUsername()|escape}</a></td>
	<td>{$user->getFullName()|escape}</td>
	<td>{$user->getFunctions()|escape}</td>
	<td class="nowrap">
		{assign var=emailString value=$user->getFullName()|concat:" <":$user->getEmail():">"}
		{url|assign:"url" page="user" op="email" to=$emailString|to_array}
		{$user->getEmail()|truncate:20:"..."|escape}&nbsp;{icon name="mail" url=$url}
	</td>
	<td align="right" class="nowrap">
		<!-- Comment out by EL on April 25, 2012: Too hazardous -->
		<!--
		{if $roleId}
		<a href="{url op="enroll" path=$roleId userId=$user->getId()}" class="action">{translate key="manager.people.enroll"}</a>
		{else}
		<a href="#" onclick="enrollUser({$user->getId()})" class="action">{translate key="manager.people.enroll"}</a>
		{/if}
		-->
		<a href="{url op="editUser" path=$user->getId()}" class="action">{translate key="common.edit"}</a>
		{if $thisUser->getId() != $user->getId()}
			{if $user->getDisabled()}
				|&nbsp;<a href="{url op="enableUser" path=$user->getId()}" class="action">{translate key="manager.people.enable"}</a>
			{else}
				|&nbsp;<a href="javascript:confirmAndPrompt({$user->getId()})" class="action">{translate key="manager.people.disable"}</a>
			{/if}
		{/if}
	</td>
</tr>
<tr><td colspan="6" class="{if $users->eof()}end{/if}separator">&nbsp;</td></tr>
{/iterate}
{if $users->wasEmpty()}
	<tr>
	<td colspan="6" class="nodata">{translate key="common.none"}</td>
	</tr>
	<tr><td colspan="6" class="endseparator">&nbsp;</td></tr>
{else}
	<tr>
		<td colspan="3" align="left">{page_info iterator=$users}</td>
		<td colspan="2" align="right">{page_links anchor="users" name="users" iterator=$users searchInitial=$searchInitial searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth roleId=$roleId sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>

<input type="submit" id="submit" value="{translate key="manager.people.enrollSelected"}" class="button defaultButton"/> 
<!-- Comment out by EL on April 25, 2012: Too hazardous -->
<!-- <input type="button" id="selectAll" value="{translate key="common.selectAll"}" class="button" onclick="toggleChecked()" /> -->
<input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url page="manager" escape=false}'" />


</form>

{if $backLink}
<a href="{$backLink}">{translate key="$backLinkLabel"}</a>
{/if}

{include file="common/footer.tpl"}

