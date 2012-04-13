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

<h2><br />{translate key="user.ercrole.cochair"}</h2>
{if count($cochair) == 1}
	<div id="cochair">
	<ol class="editorialTeam">
		{foreach from=$cochair item=cochair} 
			<li><dd><strong>{$cochair->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($cochair->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($cochair->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
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
{if count($adsecretary) == 1}
	<div id="adsecretary">
	<ol class="editorialTeam">
		{foreach from=$adsecretary item=adsecretary} 
			<li><dd><strong>{$adsecretary->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($adsecretary->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($adsecretary->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($adsecretary) == 0}
Administration problem: No Secretary Administrative Assistant.
{/if}

<h2><br />{translate key="user.ercrole.ercmembers"}</h2>
{if count($ercmembers)>0}
	<div id="ercmembers">
	<ol class="editorialTeam">
		{foreach from=$ercmembers item=ercmembers} 
			<li><br /><dd><strong>{$ercmembers->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($ercmembers->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($ercmembers->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($members) == 0}
Administration problem: No Members.
{/if}

<h2><br />{translate key="user.ercrole.extreviewers"}</h2>
{if count($extmembers)>0}
	<div id="ercmembers">
	<ol class="editorialTeam">
		{foreach from=$extmembers item=extmembers} 
			<li><br /><dd><strong>{$extmembers->getFullName()|escape}</strong><br /><i>{if $userSettingsDao->getSetting($extmembers->getUserId(),'fieldOfActivity')}{$userSettingsDao->getSetting($extmembers->getUserId(),'fieldOfActivity')|escape}{/if}</i></li>
		{/foreach}
	</ol>
	</div>
{elseif count($members) == 0}
Administration problem: No External Reviewers.
{/if}

</div>

{include file="common/footer.tpl"}