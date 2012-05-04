{**
 * editorialTeam.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * About the Journal index.
 *
 * $Id$
 *}
{strip}
	{assign var="pageTitle" value="about.editorialTeam"}
	{include file="common/header.tpl"}
{/strip}

{*New Version by EL on April 12 2012*}

<div id="editorialTeam">

<h2>{translate key="user.ercrole.chair"}</h2>
{if count($chair) == 1}
	<div id="chair">
	<ol class="editorialTeam">
		{foreach from=$chair item=chair} 
			<li><dd><strong>{$chair->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($chair->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($chair->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
	{$chairFoA}
{elseif count($secretary) == 0}
Administration problem: No Chair.
{/if}

<h2><br />{translate key="user.ercrole.viceChair"}</h2>
{if count($viceChair) == 1}
	<div id="viceChair">
	<ol class="editorialTeam">
		{foreach from=$viceChair item=viceChair} 
			<li><dd><strong>{$viceChair->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($viceChair->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($viceChair->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($secretary) == 0}
Administration problem: No Co-hair.
{/if}

<h2><br />{translate key="user.ercrole.secretariat"}</h2>

<h3><dd>{translate key="user.role.editor"}</h3>
{if count($secretary) == 1}
	<div id="secretary">
	<ol class="editorialTeam">
		{foreach from=$secretary item=secretary} 
			<li><dd><strong>{$secretary->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($secretary->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($secretary->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($secretary) == 0}
Administration problem: No Secretary.
{/if}

<h3><dd><br />{translate key="user.role.sectionEditors"}</h3>
{if count($secretaryAA) == 1}
	<div id="secretaryAA">
	<ol class="editorialTeam">
		{foreach from=$secretaryAA item=secretaryAA} 
			<li><dd><strong>{$secretaryAA->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($secretaryAA->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($secretaryAA->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($adsecretary) == 0}
Administration problem: No Secretary Administrative Assistant.
{/if}

<h2><br />{translate key="user.ercrole.ercMembers"}</h2>
{if count($ercMembers)>0}
	<div id="ercMembers">
	<ol class="editorialTeam">
		{foreach from=$ercMembers item=ercMembers} 
			<li><br /><dd><strong>{$ercMembers->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($ercMembers->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($ercMembers->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($ercMembers) == 0}
Administration problem: No Members.
{/if}

<h2><br />{translate key="user.ercrole.extMembers"}</h2>
{if count($extMembers)>0}
	<div id="extMembers">
	<ol class="editorialTeam">
		{foreach from=$extMembers item=extMembers} 
			<li><br /><dd><strong>{$extMembers->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($extMembers->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($extMembers->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($extMembers) == 0}
Administration problem: No External Members.
{/if}

</div>

{include file="common/footer.tpl"}