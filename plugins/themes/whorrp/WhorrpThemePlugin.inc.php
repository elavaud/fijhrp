<?php

/**
 * @file WhorrpThemePlugin.inc.php
 *
 * Copyright (c) 2011, MSB
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class WhorrpThemePlugin
 * @ingroup plugins_themes_whorrp
 *
 * @brief "Whorrp" theme plugin
 */

// $Id$


import('classes.plugins.ThemePlugin');

class WhorrpThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'WhorrpThemePlugin';
	}

	function getDisplayName() {
		return 'Whorrp Theme';
	}

	function getDescription() {
		return 'Whorrp layout';
	}

	function getStylesheetFilename() {
		return 'whorrp.css';
	}
	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
