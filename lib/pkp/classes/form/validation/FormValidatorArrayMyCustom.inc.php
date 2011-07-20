<?php

/**
 * @file classes/form/validation/FormValidatorArrayMyCustom.inc.php
 *
 * Copyright (c) 2000-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class FormValidatorArray
 * @ingroup form_validation
 *
 * @brief Form validation check that checks an array of fields.
 */

import('lib.pkp.classes.form.validation.FormValidator');

class FormValidatorArrayMyCustom extends FormValidator {

	/** @var array Array of fields to check */
	var $_fields;

	/** @var array Array of field names where an error occurred */
	var $_errorFields;

	/**
	 * Constructor.
	 * @param $form Form the associated form
	 * @param $field string the name of the associated field
	 * @param $type string the type of check, either "required" or "optional"
	 * @param $message string the error message for validation failures (i18n key)
	 * @param $fields array all subfields for each item in the array, i.e. name[][foo]. If empty it is assumed that name[] is a data field
	 * @param $userFunction function
	 */
	function FormValidatorArrayMyCustom(&$form, $field, $type, $message, $userFunction, $fields = array()) {
		parent::FormValidator($form, $field, $type, $message);
		$this->_fields = $fields;
		$this->_errorFields = array();
		$this->_userFunction = $userFunction;
	}


	//
	// Setters and Getters
	//
	/**
	 * Get array of fields where an error occurred.
	 * @return array
	 */
	function getErrorFields() {
		return $this->_errorFields;
	}


	//
	// Public methods
	//
	/**
	 * @see FormValidator::isValid()
	 * Value is valid if it is empty and optional or all field values are set.
	 * @return boolean
	 */
	function isValid() {
		if ($this->getType() == FORM_VALIDATOR_OPTIONAL_VALUE) return true;

		$data = $this->getFieldValue();
		if (!is_array($data) && !empty($data)) return false;

		$isValid = true;
	
		foreach ($data as $key => $value) {
			if (count($this->_fields) == 0) {
				// We expect all fields to contain values.
				echo 'count';
				if (is_null($value) || trim((string)$value) == '') {
					$isValid = false;
					echo "eas".$value;
					array_push($this->_errorFields, $this->getField()."[{$key}]");
				}
			} else {
				
				// In the two-dimensional case we always expect a value array.
				if (!is_array($value)) {
					$isValid = false;
					array_push($this->_errorFields, $this->getField()."[{$key}]");
					continue;
				}
				// Pass the arrays 
				 $ret = call_user_func_array($this->_userFunction, $value);				
				  $ret = $this->_complementReturn ? !$ret : $ret;
				  if (!$ret) {
					$isValid = false;
					array_push($this->_errorFields, $this->getField()."[{$key}]");
				  }
			}
		}
		return $isValid;
	}
}

?>
