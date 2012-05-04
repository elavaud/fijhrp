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



<script type="text/javascript">
<!--
function confirmAndPrompt(userId) {ldelim}
	var reason = prompt('{translate|escape:"javascript" key="manager.people.confirmDisable"}');
	if (reason == null) return;

	document.disableUser.reason.value = reason;
	document.disableUser.userId.value = userId;

	document.disableUser.submit();
{rdelim}

function toggleChecked() {ldelim}
	var elements = document.enroll.elements;
	for (var i=0; i < elements.length; i++) {ldelim}
		if (elements[i].name == 'users[]') {ldelim}
			elements[i].checked = !elements[i].checked;
		{rdelim}
	{rdelim}
{rdelim}
// -->

function checkSelected(){ldelim}
	var elements = document.enroll.elements;
	var countSelected = 0;
	for (var i=0; i < elements.length; i++) {ldelim}
		if (elements[i].name == 'users[]') {ldelim}
			if (elements[i].checked) {ldelim}
				countSelected++;
			{rdelim}
		{rdelim}
	{rdelim}
	return countSelected;
{rdelim}

<!-- Added by EL on April 25, 2012: Management of the ERC Status -->

$(document).ready(
    function() {ldelim}
    	showOrHideErcMemberStatusField();
        $('#roleId').change(showOrHideErcMemberStatusField);
        showOrHideButtons();
        $('#ercMemberStatus').change(showOrHideButtons);
	{rdelim}
);

function showOrHideErcMemberStatusField() {ldelim}
    var isErcMemberSelected = false;
    if ($('#roleId').val() != null) {ldelim}
        $.each(
            $('#roleId').val(), function(key, value){ldelim}
                if(value == 0x00001000) {ldelim}
                    isErcMemberSelected = true;
                {rdelim}
            {rdelim}
        );
    {rdelim}
    
    $('#chairErrorMessage').hide();
    $('#viceChairErrorMessage').hide();
    $('#secretaryErrorMessage').hide();
    $('#secretaryAAErrorMessage').hide();
    $('#membersErrorMessage').hide();
    $('#extMembersErrorMessage').hide();
    
    $('#chairTooManySelected').hide();
    $('#viceChairTooManySelected').hide();
    $('#secretaryTooManySelected').hide();
    $('#secretaryAATooManySelected').hide();
    $('#membersTooManySelected').hide();
    $('#extMembersTooManySelected').hide();
    $('#placesAvailableForMember').hide();
    $('#placesAvailableForExtMember').hide();
    
    if(isErcMemberSelected) {ldelim}
        $('#ercMemberStatusField').show();
        $('#submit').hide();
        $('#actionButton').hide();
    {rdelim} else {ldelim}
        $('#submit').show();
        $('#actionButton').show();
        $('#ercMemberStatusField').hide();
        $('#ercMemberStatus').val("NA");
    {rdelim}
{rdelim}

function showOrHideButtons() {ldelim}
    var isChairSelected = false;
    var isViceChairSelected = false;
    var isSecretarySelected = false;
    var isSecretaryAASelected = false;
    var isMemberSelected = false;
    var isExternalMemberSelected = false;
    var checkCheckbox = checkSelected();

    if ($('#ercMemberStatus').val() != null) {ldelim}
        $.each(
            $('#ercMemberStatus').val(), function(key, value){ldelim}
                if(value == "WPRO-ERC, Chair") {ldelim}
                    isChairSelected = true;                   
                {rdelim}
                else if(value == "WPRO-ERC, Vice-Chair") {ldelim}
                    isViceChairSelected = true;                   
                {rdelim}
                else if(value == "WPRO-ERC, Secretary") {ldelim}
                    isSecretarySelected = true;                    
                {rdelim}
                else if(value == "WPRO-ERC, Secretary Administrative Assistant") {ldelim}
                    isSecretaryAASelected = true;                    
                {rdelim}
                else if(value == "WPRO-ERC, Member") {ldelim}
                    isMemberSelected = true;                   
                {rdelim}
                else if(value == "WPRO-ERC, External Member") {ldelim}
                    isExternalMemberSelected = true;;                    
                {rdelim}
            {rdelim}
        );
    {rdelim}
    
    $('#chairErrorMessage').hide();
    $('#viceChairErrorMessage').hide();
    $('#secretaryErrorMessage').hide();
    $('#secretaryAAErrorMessage').hide();
    $('#membersErrorMessage').hide();
    $('#extMembersErrorMessage').hide();
    
	$('#chairTooManySelected').hide();
	$('#viceChairTooManySelected').hide();
	$('#secretaryTooManySelected').hide();
	$('#secretaryAATooManySelected').hide();
	$('#membersTooManySelected').hide();
	$('#extMembersTooManySelected').hide();
	$('#placesAvailableForMember').hide();
    $('#placesAvailableForExtMember').hide();
	
    if(isChairSelected) {ldelim}
    	if({$isChair}=='1'){ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#chairErrorMessage').show();
        {rdelim}
        else if (checkCheckbox>1) {ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#chairTooManySelected').show();
        {rdelim} 
        else {ldelim}
         	$('#submit').show();
         	$('#actionButton').show();
        {rdelim}        
    {rdelim} 
    else if(isViceChairSelected) {ldelim}
    	if({$isViceChair}=='1'){ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#viceChairErrorMessage').show();
        {rdelim}
        else if (checkCheckbox>1) {ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#viceChairTooManySelected').show();
        {rdelim}
        else {ldelim}
        	$('#submit').show();
        	$('#actionButton').show();
        {rdelim}        
    {rdelim} 
    else if(isSecretarySelected) {ldelim}
    	if({$isSecretary}=='1'){ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#secretaryErrorMessage').show();
        {rdelim}
        else if (checkCheckbox>1) {ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#secretaryTooManySelected').show();
        {rdelim}        
        else {ldelim}
        	$('#submit').show();
        	$('#actionButton').show();
        {rdelim}        
    {rdelim} 
    else if(isSecretaryAASelected) {ldelim}
    	if({$isSecretaryAA}=='1'){ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#secretaryAAErrorMessage').show();
        {rdelim}
        else if (checkCheckbox>1) {ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#secretaryAATooManySelected').show();
        {rdelim}        
        else {ldelim}
	        $('#submit').show();
	        $('#actionButton').show();
        {rdelim}        
    {rdelim} 
    else if(isMemberSelected) {ldelim}
    	if({$areMembers}=='1'){ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#membersErrorMessage').show();
        {rdelim}
        else if (checkCheckbox>{$freeMemberPlaces}) {ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#membersTooManySelected').show();
        {rdelim}        
        else {ldelim}
        	$('#placesAvailableForMember').show();
        	$('#submit').show();
        	$('#actionButton').show();
        {rdelim} 
    {rdelim} 
    else if(isExternalMemberSelected) {ldelim}
    	if({$areExtMembers}=='1'){ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#extMembersErrorMessage').show();
        {rdelim}
        else if (checkCheckbox>{$freeExtMemberPlaces}) {ldelim}
        	$('#submit').hide();
        	$('#actionButton').hide();
        	$('#extMembersTooManySelected').show();
        {rdelim}        
        else {ldelim}
        	$('#placesAvailableForExtMember').show();
        	$('#submit').show();
        	$('#actionButton').show();
        {rdelim}        
    {rdelim}
{rdelim}
<!-- End of management of the ERC Status -->
</script>

{if not $omitSearch}
	<form method="post" name="submit" action="{url op="enrollSearch"}">
	<input type="hidden" name="roleId" value="{$roleId|escape}"/>
		<select name="searchField" size="1" class="selectMenu">
			{html_options_translate options=$fieldOptions selected=$searchField}
		</select>
		<select name="searchMatch" size="1" class="selectMenu">
			<option value="contains"{if $searchMatch == 'contains'} selected="selected"{/if}>{translate key="form.contains"}</option>
			<option value="is"{if $searchMatch == 'is'} selected="selected"{/if}>{translate key="form.is"}</option>
			<option value="startsWith"{if $searchMatch == 'startsWith'} selected="selected"{/if}>{translate key="form.startsWith"}</option>
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
    	<td width="20%" class="label"><strong>Enroll user as :</strong></td>
    	<td width="80%" class="value">
			<select name="roleId" multiple="multiple" size="1" id="roleId" class="selectMenu">
				<option value="{$smarty.const.ROLE_ID_JOURNAL_MANAGER}">{translate key="user.role.manager"}</option>
				<option value="{$smarty.const.ROLE_ID_REVIEWER}">{translate key="user.role.reviewer"}</option>
				<option value="{$smarty.const.ROLE_ID_AUTHOR}">{translate key="user.role.author"}</option>
					<!-- Commented out - spf - 1 Dec 2011 <option value="{$smarty.const.ROLE_ID_EDITOR}">{translate key="user.role.editor"}</option> -->
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
	<!-- Added by EL on April 25, 2012: Management of the ERC Status -->
    <tr valign="top" id="ercMemberStatusField" style="display: none;">
        <td width="20%" class="label"><strong>ERC Member Status :</strong></td>
        <td width="80%" class="value">
			<select name="ercMemberStatus" multiple="multiple" size="1" id="ercMemberStatus" class="selectMenu">
				<option value="WPRO-ERC, Chair">Chair</option>
				<option value="WPRO-ERC, Vice-Chair">Vice-Chair</option>
				<option value="WPRO-ERC, Secretary">Secretary</option>
				<option value="WPRO-ERC, Secretary Administrative Assistant">Secretary Administrative Assistant</option>
				<option value="WPRO-ERC, Member">Member</option>
				<option value="WPRO-ERC, External Member">External Member</option>
			</select>
		</td>
	</tr>
	<!-- End of management of the ERC Status -->

<!--	
    <tr valign="top" id="proposalTypeField">
    	<td width="20%" class="label">{fieldLabel name="proposalType" required="false" key="proposal.proposalType"}</td>
        <td width="80%" class="value">
            <select name="proposalType[{$formLocale|escape}][]"  multiple="multiple" size="7" id="proposalType" class="selectMenu">

                <option value="PNHS"></option>
                    {foreach from=$proposalTypes key=id item=ptype}
                        {if $ptype.code != "PNHS"}
                            {assign var="isSelected" value=false}
                            {foreach from=$proposalType[$formLocale] key=i item=selectedTypes}
                                {if $proposalType[$formLocale][$i] == $ptype.code}
                                    {assign var="isSelected" value=true}
                                {/if}
                            {/foreach}
                            <option value="{$ptype.code}" {if $isSelected==true}selected="selected"{/if} >{$ptype.name}</option>
                        {/if}
                    {/foreach}
            </select>
        </td>
    </tr>
    <tr valign="top" id="otherProposalTypeField" style="display: none;">
        <td width="20%" class="label">&nbsp;</td>
        <td width="80%" class="value">
            <span style="font-style: italic;">Specify "other" proposal type</span>&nbsp;&nbsp;
            <input type="text" name="otherProposalType" id="otherProposalType" size="20" {if $otherProposalType}value="{$otherProposalType}"{/if} />
        </td>
    </tr>	
-->	
	
	</table>
	<script type="text/javascript">
	<!--
	function enrollUser(userId) {ldelim}
		var fakeUrl = '{url op="enroll" path="ROLE_ID" userId="USER_ID"}';
		if (document.enroll.roleId.options[document.enroll.roleId.selectedIndex].value == '') {ldelim}
			alert("{translate|escape:"javascript" key="manager.people.mustChooseRole"}");
			return false;
		{rdelim}
		if (userId != 0){ldelim}
		fakeUrl = fakeUrl.replace('ROLE_ID', document.enroll.roleId.options[document.enroll.roleId.selectedIndex].value);
		fakeUrl = fakeUrl.replace('USER_ID', userId);
		location.href = fakeUrl;
	{rdelim}
	{rdelim}
	// -->
	</div>
	</script>
{/if}

<!-- Added by EL on April 25, 2012: Management of the ERC Status -->
<p id="chairErrorMessage"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
An ERC Chair is already set in the Data-Base:<br />
</font>
{foreach from=$chair item=chair}
{$chair->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>

<p id="viceChairErrorMessage"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
An ERC Vice-Chair is already set in the Data-Base:<br />
</font>
{foreach from=$viceChair item=viceChair}
{$viceChair->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>

<p id="secretaryErrorMessage"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
An ERC Secretary is already set in the Data-Base:<br />
</font>
{foreach from=$secretary item=secretary}
{$secretary->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>

<p id="secretaryAAErrorMessage"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
An ERC Secretary Administrative Assistant is already set in the Data-Base:<br />
</font>
{foreach from=$secretaryAA item=secretaryAA}
{$secretaryAA->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>

<p id="membersErrorMessage"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many ERC members are already set in the Data-Base:<br />
</font>
{foreach from=$members item=members}
{$members->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll at least one before enrolling someone else.
</font></p>

<p id="extMembersErrorMessage"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many ERC external members are already set in the Data-Base:<br />
</font>
{foreach from=$extMembers item=extMembers}
{$extMembers->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll at least one before enrolling someone else.
</font></p>

<p id="chairTooManySelected"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Only one member can be the Chairperson of the Committee.<br />
Please select only one user.
</font></p>

<p id="viceChairTooManySelected"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Only one member can be the Vice-Chairperson of the Committee.<br />
Please select only one user.
</font></p>

<p id="secretaryTooManySelected"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Only one member can be the Secretary of the Committee.<br />
Please select only one user.
</font></p>

<p id="secretaryAATooManySelected"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Only one person can be the Secretary Administrative Assistant of the Committee.<br />
Please select only one user.
</font></p>

<p id="membersTooManySelected"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many users selected.<br />
Only {$freeMemberPlaces} place(s) available.
</font></p>

<p id="placesAvailableForMember"><font color=#1e7fb8>
ERC Member: {$freeMemberPlaces} place(s) available.<br />
</font></p>

<p id="extMembersTooManySelected"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many users selected.<br />
Only {$freeExtMemberPlaces} place(s) available.
</font></p>

<p id="placesAvailableForExtMember"><font color=#1e7fb8>
ERC External Member: {$freeExtMemberPlaces} place(s) available.
</font></p>
<!-- End of management of the ERC Status -->


<div id="users">
<table width="100%" class="listing">
<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
<tr class="heading" valign="bottom">
	<td width="5%">&nbsp;</td>
	<td width="25%">{sort_heading key="user.username" sort="username"}</td>
	<td width="30%">{sort_heading key="user.name" sort="name"}</td>
	<td width="10%">{sort_heading key="user.email" sort="email"}</td>
	<td width="10%" align="right">{translate key="common.disableEnable"}</td>
</tr>
<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
{iterate from=users item=user}
{assign var="userid" value=$user->getId()}
{assign var="stats" value=$statistics[$userid]}
<tr valign="top">
	<td><input type="checkbox" name="users[]" value="{$user->getId()}" onclick="showOrHideButtons()" /></td>
	<td><a class="action" href="{url op="userProfile" path=$userid}">{$user->getUsername()|escape}</a></td>
	<td>{$user->getFullName(true)|escape}</td>
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
		{if $thisUser->getId() != $user->getId()}
			{if $user->getDisabled()}
				|&nbsp;<a href="{url op="enableUser" path=$user->getId()}" class="action">{translate key="manager.people.enable"}</a>
			{else}
				|&nbsp;<a href="javascript:confirmAndPrompt({$user->getId()})" class="action">{translate key="manager.people.disable"}</a>
			{/if}
		{/if}
	</td>
</tr>
<tr><td colspan="5" class="{if $users->eof()}end{/if}separator">&nbsp;</td></tr>
{/iterate}
{if $users->wasEmpty()}
	<tr>
	<td colspan="5" class="nodata">{translate key="common.none"}</td>
	</tr>
	<tr><td colspan="5" class="endseparator">&nbsp;</td></tr>
{else}
	<tr>
		<td colspan="3" align="left">{page_info iterator=$users}</td>
		<td colspan="2" align="right">{page_links anchor="users" name="users" iterator=$users searchInitial=$searchInitial searchField=$searchField searchMatch=$searchMatch search=$search dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateFromMonth=$dateFromMonth dateToDay=$dateToDay dateToYear=$dateToYear dateToMonth=$dateToMonth roleId=$roleId sort=$sort sortDirection=$sortDirection}</td>
	</tr>
{/if}
</table>
</div>

<input type="submit" id="submit" value="{translate key="manager.people.enrollSelected"}" class="button defaultButton" /> 
<!-- Comment out by EL on April 25, 2012: Too hazardous -->
<!-- <input type="button" id="selectAll" value="{translate key="common.selectAll"}" class="button" onclick="toggleChecked()" /> -->
<input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url page="manager" escape=false}'" />


</form>

{if $backLink}
<a href="{$backLink}">{translate key="$backLinkLabel"}</a>
{/if}

{include file="common/footer.tpl"}

