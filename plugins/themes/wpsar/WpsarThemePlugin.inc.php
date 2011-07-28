<?php

/**
 * @file WpsarThemePlugin.inc.php
 *
 * Copyright (c) 2003-2008 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class WpsarThemePlugin
 * @ingroup plugins_themes_polished
 *
 * @brief "Wpsar" theme plugin
 */

// $Id: WpsarThemePlugin.inc.php,v 1.6 2008/07/01 01:16:14 asmecher Exp $


import('classes.plugins.ThemePlugin');

class WpsarThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'WpsarThemePlugin';
	}

	function getDisplayName() {
		return 'Wpsar Theme';
	}

	function getDescription() {
		return 'Dark layout';
	}

	function getStylesheetFilename() {
		return 'wpsar.css';
	}

	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
