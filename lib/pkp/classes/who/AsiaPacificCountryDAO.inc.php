<?php

/**
 * @file classes/who/AsiaPacificCountryDAO.inc.php
 *
 *
 * @class AsiaPacificCountryDAO
 * @package who
 *
 * @brief Provides methods for loading localized Asia Pacific country name data.
 *
 */

// $Id$


class AsiaPacificCountryDAO extends DAO {
	var $cache;

	/**
	 * Constructor.
	 */
	function AsiaPacificCountryDAO() {
	}

	/**
	 * Get the filename of the Asia Pacific countries registry file for the given locale.
	 * @param $locale string Name of locale (optional)
	 */
	function getFilename($locale = null) {
		if ($locale === null) $locale = Locale::getLocale();
		return "lib/pkp/locale/$locale/asiapacific.xml";
	}

	function &_getCountryCache($locale = null) {
		$caches =& Registry::get('allAsiaPacificCountries', true, array());
                
		if (!isset($locale)) $locale = Locale::getLocale();
                
		if (!isset($caches[$locale])) {
			$cacheManager =& CacheManager::getManager();
			$caches[$locale] = $cacheManager->getFileCache(
				'asiapacific', $locale,
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
		$countriesAsiaPacific =& Registry::get('allAsiaPacificCountriesData', true, array());
                
                
		if (!isset($countriesAsiaPacific[$id])) {
			// Reload country registry file
			$xmlDao = new XMLDAO();
			$data = $xmlDao->parseStruct($this->getFilename(), array('countries', 'country'));

                        if (isset($data['countries'])) {
				foreach ($data['country'] as $countryData) {
					$countriesAsiaPacific[$id][$countryData['attributes']['code']] = $countryData['attributes']['name'];
				}
			}
			asort($countriesAsiaPacific[$id]);
			$cache->setEntireCache($countriesAsiaPacific[$id]);
		}
		return null;
	}

	/**
	 * Return a list of all Asia Pacific countries.
	 * @param $locale string Name of locale (optional)
	 * @return array
	 */
	function &getAsiaPacificCountries($locale = null) {
		$cache =& $this->_getCountryCache($locale);
		return $cache->getContents();
	}

	/**
	 * Return a translated country name, given a code.
	 * @param $locale string Name of locale (optional)
	 * @return array
         *
         * Updated 12.22.2011 to handle multiple countries
	 */
	function getAsiaPacificCountry($code, $locale = null) {
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
