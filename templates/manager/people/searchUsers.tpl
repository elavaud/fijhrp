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
    	showOrHideEthicsCommitteeField();
        $('#roleId').change(showOrHideEthicsCommitteeField);
        showOrHideErcMemberStatusField();
        $('#ethicsCommittee').change(showOrHideErcMemberStatusField);
        showOrHideButtons();
        $('#ercMemberStatus').change(showOrHideButtons);
	{rdelim}
);

function showOrHideEthicsCommitteeField() {ldelim}
    var isErcMemberSelected = false;
    
    <!-- This variable and its use is only to be sure that a role is selected-->
    var isSomethingSelected = false;
    
    if ($('#roleId').val() != null) {ldelim}
        $.each(
            $('#roleId').val(), function(key, value){ldelim}
                if(value == 0x00001000) {ldelim}
                    isErcMemberSelected = true;
                {rdelim}
                if(value == 0x00000010 || value == 0x00010000 || value == 0x00000100){ldelim}
                	isSomethingSelected = true;
                {rdelim}
            {rdelim}
        );
    {rdelim}
    
    $('#uhsChairErrorMessage').hide();
    $('#uhsViceChairErrorMessage').hide();
    $('#uhsSecretaryErrorMessage').hide();
    $('#uhsSecretaryTooManySelected').hide();
    $('#placesAvailableForUhsSecretary').hide();
    $('#uhsMembersErrorMessage').hide();
    $('#uhsMembersTooManySelected').hide();
    $('#placesAvailableForUhsMember').hide();

    $('#niophChairErrorMessage').hide();
    $('#niophViceChairErrorMessage').hide();    
    $('#niophSecretaryErrorMessage').hide();
    $('#niophSecretaryTooManySelected').hide();
    $('#placesAvailableForNiophSecretary').hide();
    $('#niophMembersErrorMessage').hide();
    $('#niophMembersTooManySelected').hide();
    $('#placesAvailableForNiophMember').hide();
    
    if(isErcMemberSelected) {ldelim}
        $('#ethicsCommitteeField').show();
        $('#noEthicsCommitteeSelected').show();
        $('#nothingSelected').hide();
        $('#submit').hide();
    {rdelim} else if(isSomethingSelected) {ldelim}
        $('#submit').show();
        $('#noEthicsCommitteeSelected').hide();
        $('#nothingSelected').hide();
        $('#noMemberStatusSelected').hide();
        $('#ethicsCommitteeField').hide();
        $('#ercMemberStatusField').hide();
        $('#ethicsCommittee').val("NA");
        $('#ercMemberStatus').val("NA");
    {rdelim} else {ldelim}
    	$('#nothingSelected').show();
    	$('#noEthicsCommitteeSelected').hide();
    	$('#noMemberStatusSelected').hide();
    	$('#ercMemberStatusField').hide();
    	$('#ethicsCommitteeField').hide();
        $('#ethicsCommittee').val("NA");
        $('#ercMemberStatus').val("NA");
    {rdelim}
{rdelim}

function showOrHideErcMemberStatusField() {ldelim}
    
    var isEthicsCommitteeSelected = false;
    
    if ($('#ethicsCommittee').val() != null) {ldelim}
        $.each(
            $('#ethicsCommittee').val(), function(key, value){ldelim}
                if(value == "NIOPH" || value == "UHS"){ldelim}
                	isEthicsCommitteeSelected = true;
                {rdelim}
            {rdelim}
        );
    {rdelim}
    
    $('#uhsChairErrorMessage').hide();
    $('#uhsViceChairErrorMessage').hide();
    $('#uhsSecretaryErrorMessage').hide();
    $('#uhsSecretaryTooManySelected').hide();
    $('#placesAvailableForUhsSecretary').hide();
    $('#uhsMembersErrorMessage').hide();
    $('#uhsMembersTooManySelected').hide();
    $('#placesAvailableForUhsMember').hide();

    $('#niophChairErrorMessage').hide();
    $('#niophViceChairErrorMessage').hide();    
    $('#niophSecretaryErrorMessage').hide();
    $('#niophSecretaryTooManySelected').hide();
    $('#placesAvailableForNiophSecretary').hide();
    $('#niophMembersErrorMessage').hide();
    $('#niophMembersTooManySelected').hide();
    $('#placesAvailableForNiophMember').hide();
    
    if (isEthicsCommitteeSelected) {ldelim}
        $('#noEthicsCommitteeSelected').hide();
        $('#ercMemberStatusField').show();
        $('#noMemberStatusSelected').show();
        $('#ercMemberStatus').val("NA");
        $('#submit').hide();
    {rdelim} else {ldelim}
    	$('#ercMemberStatusField').hide();
        $('#ercMemberStatus').val("NA");
    {rdelim}
{rdelim}

function showOrHideButtons() {ldelim}

	var isUhsSelected = false;
	var isNiophSelected = false;
	var isChairSelected = false;
	var isViceChairSelected = false;
    var isSecretarySelected = false;  
    var isMemberSelected = false;
    
    var checkCheckbox = checkSelected();
	
    if ($('#ethicsCommittee').val() != null) {ldelim}
        $.each(
            $('#ethicsCommittee').val(), function(key, value){ldelim}
                if(value == "UHS"){ldelim}
                	isUhsSelected = true;
                {rdelim}
                else if(value == "NIOPH"){ldelim}
                	isNiophSelected =true;
                {rdelim}
            {rdelim}
        );
    {rdelim}
    
    if ($('#ercMemberStatus').val() != null) {ldelim}
        $.each(
            $('#ercMemberStatus').val(), function(key, value){ldelim}
                if(value == "ERC, Chair") {ldelim}
                    isChairSelected = true;                    
                {rdelim}
                else if(value == "ERC, Vice-Chair") {ldelim}
                    isViceChairSelected = true;                   
                {rdelim}
                else if(value == "ERC, Secretary") {ldelim}
                    isSecretarySelected = true;                   
                {rdelim}
                else if(value == "ERC, Member") {ldelim}
                    isMemberSelected = true;                   
                {rdelim}
            {rdelim}
        );
    {rdelim}
    
    $('#uhsChairErrorMessage').hide();
    $('#uhsViceChairErrorMessage').hide();
    $('#uhsSecretaryErrorMessage').hide();
    $('#uhsSecretaryTooManySelected').hide();
    $('#placesAvailableForUhsSecretary').hide();
    $('#uhsMembersErrorMessage').hide();
    $('#uhsMembersTooManySelected').hide();
    $('#placesAvailableForUhsMember').hide();

    $('#niophChairErrorMessage').hide();
    $('#niophViceChairErrorMessage').hide();    
    $('#niophSecretaryErrorMessage').hide();
    $('#niophSecretaryTooManySelected').hide();
    $('#placesAvailableForNiophSecretary').hide();
    $('#niophMembersErrorMessage').hide();
    $('#niophMembersTooManySelected').hide();
    $('#placesAvailableForNiophMember').hide();
    
     $('#tooManySelected').hide();
    
    if (isUhsSelected) {ldelim}
        if(isChairSelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$isUhsChair}=='1'){ldelim}
        		$('#submit').hide();
        		$('#uhsChairErrorMessage').show();
        	{rdelim}
       		else if (checkCheckbox>'1') {ldelim}
        		$('#submit').hide();
        		$('#tooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#submit').show();
        	{rdelim}        
    	{rdelim}
        else if(isViceChairSelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$isUhsViceChair}=='1'){ldelim}
        		$('#submit').hide();
        		$('#uhsViceChairErrorMessage').show();
        	{rdelim}
       		else if (checkCheckbox>'1') {ldelim}
        		$('#submit').hide();
        		$('#tooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#submit').show();
        	{rdelim}        
    	{rdelim}
        else if(isSecretarySelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$areUhsSecretary}=='1'){ldelim}
        		$('#submit').hide();
        		$('#uhsSecretaryErrorMessage').show();
        	{rdelim}
       		else if (checkCheckbox>{$freeUhsSecretaryPlaces}) {ldelim}
        		$('#submit').hide();
        		$('#uhsSecretaryTooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#placesAvailableForUhsSecretary').show();
        		$('#submit').show();
        	{rdelim}        
    	{rdelim}
    	else if(isMemberSelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$areUhsMembers}=='1'){ldelim}
        		$('#submit').hide();
        		$('#uhsMembersErrorMessage').show();
        	{rdelim}
        	else if (checkCheckbox>{$freeUhsMemberPlaces}) {ldelim}
        		$('#submit').hide();
        		$('#uhsMembersTooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#placesAvailableForUhsMember').show();
        		$('#submit').show();
        	{rdelim} 
    	{rdelim}
    {rdelim}
    else if (isNiophSelected) {ldelim}
        if(isChairSelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$isNiophChair}=='1'){ldelim}
        		$('#submit').hide();
        		$('#niophChairErrorMessage').show();
        	{rdelim}
       		else if (checkCheckbox>'1') {ldelim}
        		$('#submit').hide();
        		$('#tooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#submit').show();
        	{rdelim}        
    	{rdelim}
        else if(isViceChairSelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$isNiophViceChair}=='1'){ldelim}
        		$('#submit').hide();
        		$('#niophViceChairErrorMessage').show();
        	{rdelim}
       		else if (checkCheckbox>'1') {ldelim}
        		$('#submit').hide();
        		$('#tooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#submit').show();
        	{rdelim}        
    	{rdelim}
        else if(isSecretarySelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$areNiophSecretary}=='1'){ldelim}
        		$('#submit').hide();
        		$('#niophSecretaryErrorMessage').show();
        	{rdelim}
       		else if (checkCheckbox>{$freeNiophSecretaryPlaces}) {ldelim}
        		$('#submit').hide();
        		$('#niophSecretaryTooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#placesAvailableForNiophSecretary').show();
        		$('#submit').show();
        	{rdelim}        
    	{rdelim}
    	else if(isMemberSelected) {ldelim}
    		$('#noMemberStatusSelected').hide();
    		if({$areNiophMembers}=='1'){ldelim}
        		$('#submit').hide();
        		$('#niophMembersErrorMessage').show();
        	{rdelim}
        	else if (checkCheckbox>{$freeNiophMemberPlaces}) {ldelim}
        		$('#submit').hide();
        		$('#niophMembersTooManySelected').show();
        	{rdelim}        
        	else {ldelim}
        		$('#placesAvailableForNiophMember').show();
        		$('#submit').show();
        	{rdelim} 
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
			<select name="roleId" multiple="multiple" size="3" id="roleId" class="selectMenu">
				<option value="{$smarty.const.ROLE_ID_JOURNAL_MANAGER}">{translate key="user.role.manager"}</option>
				<option value="{$smarty.const.ROLE_ID_REVIEWER}">Ethics Committee</option>
				<option value="{$smarty.const.ROLE_ID_AUTHOR}">{translate key="user.role.author"}</option>
				<option value="{$smarty.const.ROLE_ID_EDITOR}">{translate key="user.role.coordinator"}</option>
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
	
	<tr valign="top" id="ethicsCommitteeField"  style="display: none;">
		<td width="20%" class="label"><strong>Ethics Committee :</strong></td>
		<td width="80%" class="value">
			<select name="ethicsCommittee" multiple="multiple" size="2" id="ethicsCommittee" class="selectMenu">
				<option value="NIOPH">NIOPH</option>
				<option value="UHS">UHS</option>
			</select>
		</td>
	</tr>
	
	<!-- Added by EL on April 25, 2012: Management of the ERC Status -->
    <tr valign="top" id="ercMemberStatusField" style="display: none;">
        <td width="20%" class="label"><strong>Status :</strong></td>
        <td width="80%" class="value">
			<select name="ercMemberStatus" multiple="multiple" size="4" id="ercMemberStatus" class="selectMenu">
				<option value="ERC, Chair">Chair</option>
				<option value="ERC, Vice-Chair">Vice-Chair</option>
				<option value="ERC, Secretary">Secretary</option>
				<!--<option value="ERC, Secretary Administrative Assistant">Secretary Administrative Assistant</option>-->
				<option value="ERC, Member">Member</option>
				<!--<option value="ERC, External Member">External Member</option>-->
			</select>
		</td>
	</tr>
	<!-- End of management of the ERC Status -->
	
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
<p id="nothingSelected" style="display: none;"><font color=#FF0000>
Please select a type of enrollement<br/>
</font>
</p>
<p id="noEthicsCommitteeSelected" style="display: none;"><font color=#FF0000>
Please select an Ethics Committee<br/>
</font>
</p>
<p id="noMemberStatusSelected" style="display: none;"><font color=#FF0000>
Please select an Ethics Committee Status<br/>
</font>
</p>
<p id="uhsChairErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
A Chair is already set into the UHS Ethics Committee:<br />
</font>
{foreach from=$uhsChair item=uhsChair}
{$uhsChair->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>
<p id="uhsViceChairErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
A Vice-Chair is already set into the UHS Ethics Committee:<br />
</font>
{foreach from=$uhsViceChair item=uhsViceChair}
{$uhsViceChair->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>
<p id="niophChairErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
A Chair is already set into the NIOPH Ethics Committee:<br />
</font>
{foreach from=$niophChair item=niophChair}
{$niophChair->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>
<p id="niophViceChairErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
A Vice-Chair is already set into the NIOPH Ethics Committee:<br />
</font>
{foreach from=$niophViceChair item=niophViceChair}
{$niophViceChair->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll him/her before enrolling someone else.
</font></p>
<p id="uhsSecretaryErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many Secretaries are set in the UHS Ethics Committee:<br />
</font>
{foreach from=$uhsSecretary item=uhsSecretary}
{$uhsSecretary->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll at least one before enrolling someone else.
</font></p>
<p id="niophSecretaryErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many Secretaries are set in the NIOPH Ethics Committee:<br />
</font>
{foreach from=$niophSecretary item=niophSecretary}
{$niophSecretary->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll at least one before enrolling someone else.
</font></p>
<p id="uhsMembersErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many ERC members are set in the UHS Ethics Committee:<br />
</font>
{foreach from=$uhsMembers item=uhsMembers}
{$uhsMembers->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll at least one before enrolling someone else.
</font></p>
<p id="niophMembersErrorMessage" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many ERC members are set in the NIOPH Ethics Committee:<br />
</font>
{foreach from=$niophMembers item=niophMembers}
{$niophMembers->getFullName()|escape}<br />
{/foreach}
<font color=#FF0000>
Please unenroll at least one before enrolling someone else.
</font></p>
<p id="tooManySelected" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many users selected.<br />
Only 1 place available.
</font></p>
<p id="uhsSecretaryTooManySelected" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many secretaries selected for the UHS Ethics Committee.<br />
Only {$freeUhsSecretaryPlaces} place(s) available.
</font></p>
<p id="niophSecretaryTooManySelected" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many secretaries selected for the NIOPH Ethics Committee.<br />
Only {$freeNiophSecretaryPlaces} place(s) available.
</font></p>
<p id="uhsMembersTooManySelected" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many members selected for the UHS Ethics Committee.<br />
Only {$freeUhsMemberPlaces} place(s) available.
</font></p>
<p id="niophMembersTooManySelected" style="display: none;"><font color=#FF0000>
<strong>ATTENTION :</strong><br />
Too many members selected for the NIOPH Ethics Committee.<br />
Only {$freeNiophMemberPlaces} place(s) available.
</font></p>
<p id="placesAvailableForUhsMember" style="display: none;"><font color=#1e7fb8>
UHS-ERC Member: {$freeUhsMemberPlaces} place(s) available.<br />
</font></p>
<p id="placesAvailableForNiophMember" style="display: none;"><font color=#1e7fb8>
NIOPH-ERC Member: {$freeNiophMemberPlaces} place(s) available.<br />
</font></p>
<p id="placesAvailableForUhsSecretary" style="display: none;"><font color=#1e7fb8>
UHS-ERC Secretary: {$freeUhsSecretaryPlaces} place(s) available.<br />
</font></p>
<p id="placesAvailableForNiophSecretary" style="display: none;"><font color=#1e7fb8>
NIOPH-ERC Secretary: {$freeNiophSecretaryPlaces} place(s) available.<br />
</font></p>
<!-- End of management of the ERC Status -->


<div id="users">
<table width="100%" class="listing">
<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
<tr class="heading" valign="bottom">
	<td width="5%">&nbsp;</td>
	<td width="10%">{sort_heading key="user.username" sort="username"}</td>
	<td width="10%">{sort_heading key="user.name" sort="name"}</td>
	<td width="35%">Function(s)</td>
	<td width="10%">{sort_heading key="user.email" sort="email"}</td>
	<td width="10%" align="right">{translate key="common.disableEnable"}</td>
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

<input type="submit" id="submit" value="{translate key="manager.people.enrollSelected"}" class="button defaultButton" style="display: none;" /> 
<!-- Comment out by EL on April 25, 2012: Too hazardous -->
<!-- <input type="button" id="selectAll" value="{translate key="common.selectAll"}" class="button" onclick="toggleChecked()" /> -->
<input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url page="manager" escape=false}'" />


</form>

{if $backLink}
<a href="{$backLink}">{translate key="$backLinkLabel"}</a>
{/if}

{include file="common/footer.tpl"}

