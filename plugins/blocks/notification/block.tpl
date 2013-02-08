{**
 * block.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Common site sidebar menu -- "Notification" block.
 *
 * $Id$
 *}
 {if $currentJournal}
<div class="block" id="notification">
{if $isUserLoggedIn}
	<span class="blockTitle">{translate key="notification.notifications"}</span>
	<ul>
		<li><a href="{url page="notification"}">{translate key="common.view"}</a>
		{if $unreadNotifications > 0}
			{translate key="notification.notificationsNew" numNew=$unreadNotifications}
		{/if}
		</li>
	</ul>
{/if}
</div>
{/if}
