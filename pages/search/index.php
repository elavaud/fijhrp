<?php

/**
 * @defgroup pages_search
 */
 
/**
 * @file pages/search/index.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup pages_search
 * @brief Handle search requests. 
 *
 */

// $Id$


switch ($op) {
	case 'authors':
	case 'titles':
		define('HANDLER_CLASS', 'SearchHandler');
		import('pages.search.SearchHandler');
		break;
	case 'index':
	case 'search':
	case 'advanced':
	case 'results':
	case 'advancedResults':
	case 'generateCSV':
	case 'generateCustomizedCSV':
	case 'downloadFile':
	case 'viewProposal':
		define('HANDLER_CLASS', 'NewSearchHandler');
		import('pages.search.NewSearchHandler');
		break;
}

?>
