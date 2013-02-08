<?php

/**
 * @file PhilhrpThemePlugin.inc.php
 *
 * Copyright (c) 2011, MSB
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class PhilhrpThemePlugin
 * @ingroup plugins_themes_philhrp
 *
 * @brief "Philhrp" theme plugin
 */

// $Id$


import('classes.plugins.ThemePlugin');

class PhilhrpThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'PhilhrpThemePlugin';
	}

	function getDisplayName() {
		return 'Philhrp Theme';
	}

	function getDescription() {
		return 'WHO Western Pacific Region layout';
	}

	function getStylesheetFilename() {
		return 'philhrp.css';
	}
	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
