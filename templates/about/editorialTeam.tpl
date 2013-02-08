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


{if count($ercChair) > 0}
<h4>Chair</h4>
	<div id="ercChair">
	<ol class="contact">
		{foreach from=$ercChair item=ercChair} 
			<strong>{$ercChair->getFullName()|escape}</strong>{if $ercChair->getLocalizedAffiliation()}, {$ercChair->getLocalizedAffiliation()|escape}{/if}<br /> &#187; {translate key="about.contact.email"}: {if $ercChair->getEmail()}{mailto address=$ercChair->getEmail()|escape}<br />{/if}
		{/foreach}
	</ol>
	</div>
{/if}

{if count($ercViceChair) > 0}
<h4>Vice-Chair</h4>
	<div id="ercViceChair">
	<ol class="contact">
		{foreach from=$ercViceChair item=ercViceChair} 
			<strong>{$ercViceChair->getFullName()|escape}</strong>{if $ercViceChair->getLocalizedAffiliation()}, {$ercViceChair->getLocalizedAffiliation()|escape}{/if}<br /> &#187; {translate key="about.contact.email"}: {if $ercViceChair->getEmail()}{mailto address=$ercViceChair->getEmail()|escape}<br />{/if}
		{/foreach}
	</ol>
	</div>
{/if}


{if count($secretary) > 0}
{if count($secretary) == 1}
<h4>Secretary</h4>
{else}
<h4>Secretaries</h4>
{/if}
	<div id="secretary">
	<ol class="contact">
		{foreach from=$secretary item=secretary} 
			<strong>{$secretary->getFullName()|escape}</strong>{if $secretary->getLocalizedAffiliation()}, {$secretary->getLocalizedAffiliation()|escape}{/if}<br /> &#187; {translate key="about.contact.email"}: {if $secretary->getEmail()}{mailto address=$secretary->getEmail()|escape}<br />{/if}
		{/foreach}
	</ol>
	</div>
{/if}

{if count($ercMembers) > 0}
<h4>Members</h4>
	<div id="ercMembers">
	<ol class="contact">
		{foreach from=$ercMembers item=ercMembers} 
			<strong>{$ercMembers->getFullName()|escape}</strong>{if $ercMembers->getLocalizedAffiliation()}, {$ercMembers->getLocalizedAffiliation()|escape}{/if}<br /> &#187; {translate key="about.contact.email"}: {if $ercMembers->getEmail()}{mailto address=$ercMembers->getEmail()|escape}<br />{/if}
		{/foreach}
	</ol>
	</div>
{/if}

</div>

{include file="common/footer.tpl"}