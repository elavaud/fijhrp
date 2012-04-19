{**
 * contact.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * About the WHO-WPRO, Health Research Portal / Contact.
 *
 * $Id$
 *}

{strip}
	{assign var="pageTitle" value="about.journalContact"}
	{include file="common/header.tpl"}
{/strip}

<div id="contact">

<h4>{translate key="user.role.editor"}</h4>
{if count($secretary) == 1}
	<div id="secretary">
	<ol class="contact">
		{foreach from=$secretary item=secretary} 
			<strong>{$secretary->getFullName()|escape}</strong>{if $secretary->getLocalizedAffiliation()}, {$secretary->getLocalizedAffiliation()|escape}{/if}<br /> &#187; {translate key="about.contact.email"}: {if $secretary->getEmail()}{mailto address=$secretary->getEmail()|escape}{/if}
		{/foreach}
	</ol>
	</div>
{elseif count($secretary) == 0}
Administration problem: No Secretary.
{/if}

<h4>{translate key="user.role.sectionEditors"}</h4>
{if count($adsecretary) == 1}
	<div id="adsecretary">
	<ol class="contact">
		{foreach from=$adsecretary item=adsecretary} 
			<strong>{$adsecretary->getFullName()|escape}</strong>{if $adsecretary->getLocalizedAffiliation()}, {$adsecretary->getLocalizedAffiliation()|escape}{/if}<br /> &#187; {translate key="about.contact.email"}: {if $adsecretary->getEmail()}{mailto address=$adsecretary->getEmail()|escape}{/if}
		{/foreach}
	</ol>
	</div>
{elseif count($adsecretary) == 0}
Administration problem: No Secretary Administrative Assistant.
{/if}	
	
</div>

{include file="common/footer.tpl"}