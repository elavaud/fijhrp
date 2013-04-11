<?php

/**
 * @file classes/article/AreasOfTheCountryDAO.inc.php
 *
 *
 * @class AreasOfTheCountryDAO
 *
 * @brief Provides methods for loading localized geographical areas of the country name data.
 *
 */

// $Id$


class AreasOfTheCountryDAO extends DAO {
	var $cache;
	/**
	 * Constructor.
	 */
	function AreasOfTheCountryDAO() {
	}

	/**
	 * Get the filename of the Asia Pacific countries registry file for the given locale.
	 * @param $locale string Name of locale (optional)
	 */
	function getFilename($locale = null) {
		if ($locale === null) $locale = Locale::getLocale();
		return "lib/pkp/locale/$locale/areasOfTheCountry.xml";
	}

	function &_getCountryCache($locale = null) {
		$caches =& Registry::get('allAreasOfTheCountry', true, array());
                
		if (!isset($locale)) $locale = Locale::getLocale();
                
		if (!isset($caches[$locale])) {
			$cacheManager =& CacheManager::getManager();
			$caches[$locale] = $cacheManager->getFileCache(
				'areasOfTheCountry', $locale,
				array(&$this, '_countryCacheMiss')
			);

			// Check to see if the data is outdated
			$cacheTime = $caches[$locale]->getCacheTime();
			if ($cacheTime !== null && $cacheTime < filemtime($this->getFilename())) {
				$caches[$locale]->flush();
			}
		}
		return $caches[$locale];
	}

	function _countryCacheMiss(&$cache, $id) {
		$areasOfTheCountry =& Registry::get('allAreasOfTheCountryData', true, array());
                
                
		if (!isset($areasOfTheCountry[$id])) {
			// Reload country registry file
			$xmlDao = new XMLDAO();
			$data = $xmlDao->parseStruct($this->getFilename(), array('countries', 'country'));

                        if (isset($data['countries'])) {
				foreach ($data['country'] as $countryData) {
					$areasOfTheCountry[$id][$countryData['attributes']['code']] = $countryData['attributes']['name'];
				}
			}
			asort($areasOfTheCountry[$id]);
			$cache->setEntireCache($areasOfTheCountry[$id]);
		}
		return null;
	}

	/**
	 * Return a list of all the geographical areas of the country.
	 * @param $locale string Name of locale (optional)
	 * @return array
	 */
	function &getAreasOfTheCountry($locale = null) {
		$cache =& $this->_getCountryCache($locale);
		return $cache->getContents();
	}

	/**
	 * Return a translated region name, given a code.
	 * @param $locale string Name of locale (optional)
	 * @return array
         *
         * Updated 12.22.2011 to handle multiple regions
	 */
	function getAreaOfTheCountry($code, $locale = null) {
		$cache =& $this->_getCountryCache($locale);
                $countries = explode(",", $code);
                $countriesText = "";
                foreach($countries as $i => $country) {
                    $countriesText = $countriesText . $cache->get(trim($country));
                    if($i < count($countries)-1) $countriesText = $countriesText . ", ";
                }
		return $countriesText;
	}
}

?>
