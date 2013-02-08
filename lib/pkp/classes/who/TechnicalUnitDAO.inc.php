<?php

/**
 * @file classes/who/TechnicalUnitDAO.inc.php
 *
 *
 * @class TechnicalUnitDAO
 * @package who
 *
 * @brief Provides methods for loading localized WHO Technical Unit data.
 *
 */

// $Id$


class TechnicalUnitDAO extends DAO {
	var $cache;

	/**
	 * Constructor.
	 */
	function TechnicalUnitDAO() {
	}

	/**
	 * Get the filename of the WHO Technical Unit registry file for the given locale.
	 * @param $locale string Name of locale (optional)
	 */
	function getFilename($locale = null) {
		if ($locale === null) $locale = Locale::getLocale();
		return "lib/pkp/locale/$locale/technicalunit.xml";
	}

	function &_getTechnicalUnitCache($locale = null) {
		$caches =& Registry::get('allTechnicalUnits', true, array());

		if (!isset($locale)) $locale = Locale::getLocale();

		if (!isset($caches[$locale])) {
			$cacheManager =& CacheManager::getManager();
			$caches[$locale] = $cacheManager->getFileCache(
				'technicalunit', $locale,
				array(&$this, '_technicalUnitCacheMiss')
			);

			// Check to see if the data is outdated
			$cacheTime = $caches[$locale]->getCacheTime();
			if ($cacheTime !== null && $cacheTime < filemtime($this->getFilename())) {
				$caches[$locale]->flush();
			}
		}
		return $caches[$locale];
	}

	function _technicalUnitCacheMiss(&$cache, $id) {
		$technicalUnits =& Registry::get('allTechnicalUnitsData', true, array());


		if (!isset($technicalUnits[$id])) {
			// Reload technical unit registry file
			$xmlDao = new XMLDAO();
			$data = $xmlDao->parseStruct($this->getFilename(), array('technicalunits', 'technicalunit'));

                        if (isset($data['technicalunits'])) {
				foreach ($data['technicalunit'] as $unitData) {
					$technicalUnits[$id][$unitData['attributes']['code']] = $unitData['attributes']['name'];
				}
			}
			asort($technicalUnits[$id]);
			$cache->setEntireCache($technicalUnits[$id]);
		}
		return null;
	}

	/**
	 * Return a list of all WHO Technical Units.
	 * @param $locale string Name of locale (optional)
	 * @return array
	 */
	function &getTechnicalUnits($locale = null) {
		$cache =& $this->_getTechnicalUnitCache($locale);
		return $cache->getContents();
	}

	/**
	 * Return a translated technical unit name, given a code.
	 * @param $locale string Name of locale (optional)
	 * @return array
	 */
	function getTechnicalUnit($code, $locale = null) {
		$cache =& $this->_getTechnicalUnitCache($locale);
		return $cache->get($code);
	}
}

?>
