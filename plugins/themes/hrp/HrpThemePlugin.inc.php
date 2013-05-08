<?php

/**
 * @file HrpThemePlugin.inc.php
 *
 * Copyright (c) 2011, MSB
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class HrpThemePlugin
 * @ingroup plugins_themes_hrp
 *
 * @brief "Hrp" theme plugin
 */

// $Id$


import('classes.plugins.ThemePlugin');

class HrpThemePlugin extends ThemePlugin {
	/**
	 * Get the name of this plugin. The name must be unique within
	 * its category.
	 * @return String name of plugin
	 */
	function getName() {
		return 'HrpThemePlugin';
	}

	function getDisplayName() {
		return 'Hrp Theme';
	}

	function getDescription() {
		return 'Health Research Ethics Board layout';
	}

	function getStylesheetFilename() {
		return 'hrp.css';
	}
	function getLocaleFilename($locale) {
		return null; // No locale data
	}
}

?>
