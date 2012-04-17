<?php

/**
 * @file classes/author/form/submit/AuthorSubmitStep2Form.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorSubmitStep2Form
 * @ingroup author_form_submit
 *
 * @brief Form for Step 2 of author article submission.
 */


import('classes.author.form.submit.AuthorSubmitForm');

class AuthorSubmitStep2Form extends AuthorSubmitForm {

	/**
	 * Constructor.
	 */
	function AuthorSubmitStep2Form(&$article, &$journal) {
		parent::AuthorSubmitForm($article, 2, $journal);

		// Validation checks for this form
		$this->addCheck(new FormValidatorCustom($this, 'authors', 'required', 'author.submit.form.authorRequired', create_function('$authors', 'return count($authors) > 0;')));
		$this->addCheck(new FormValidatorArray($this, 'authors', 'required', 'author.submit.form.authorRequiredFields', array('firstName', 'lastName')));
		$this->addCheck(new FormValidatorArrayCustom($this, 'authors', 'required', 'author.submit.form.authorRequiredFields', create_function('$email, $regExp', 'return String::regexp_match($regExp, $email);'), array(ValidatorEmail::getRegexp()), false, array('email')));
		$this->addCheck(new FormValidatorArrayCustom($this, 'authors', 'required', 'user.profile.form.urlInvalid', create_function('$url, $regExp', 'return empty($url) ? true : String::regexp_match($regExp, $url);'), array(ValidatorUrl::getRegexp()), false, array('url')));
		$this->addCheck(new FormValidatorLocale($this, 'title', 'required', 'author.submit.form.titleRequired', $this->getRequiredLocale()));

		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section = $sectionDao->getSection($article->getSectionId());
		$abstractWordCount = $section->getAbstractWordCount();
		if (isset($abstractWordCount) && $abstractWordCount > 0) {
			$this->addCheck(new FormValidatorCustom($this, 'abstract', 'required', 'author.submit.form.wordCountAlert', create_function('$abstract, $wordCount', 'foreach ($abstract as $localizedAbstract) {return count(explode(" ",$localizedAbstract)) < $wordCount; }'), array($abstractWordCount)));
		}

                /************************************************************************************************************/
                /*  Validation code for additional proposal metadata (keys found in author.xml)
                 *  Added by:  Anne Ivy Mirasol
                 *  Last Update: May 3, 2011
                 ************************************************************************************************************/
                //Comment out by EL on april 13 2012

                //Returned by SPF on April 17, 2012
		$this->addCheck(new FormValidatorLocale($this, 'objectives', 'required', 'author.submit.form.objectivesRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'keywords', 'required', 'author.submit.form.keywordsRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'startDate', 'required', 'author.submit.form.startDateRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'endDate', 'required', 'author.submit.form.endDateRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'fundsRequired', 'required', 'author.submit.form.fundsRequiredRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'proposalCountry', 'required', 'author.submit.form.proposalCountryRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'technicalUnit', 'required', 'author.submit.form.technicalUnitRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'withHumanSubjects', 'required', 'author.submit.form.withHumanSubjectsRequired', $this->getRequiredLocale()));	        
                $this->addCheck(new FormValidatorLocale($this, 'proposalType', 'required', 'author.submit.form.proposalTypeRequired', $this->getRequiredLocale()));
                
                $this->addCheck(new FormValidatorLocale($this, 'submittedAsPi', 'required', 'author.submit.form.submittedAsPiRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'conflictOfInterest', 'required', 'author.submit.form.conflictOfInterestRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'reviewedByOtherErc', 'required', 'author.submit.form.reviewedByOtherErcRequired', $this->getRequiredLocale()));
                $this->addCheck(new FormValidatorLocale($this, 'otherErcDecision', 'required', 'author.submit.form.otherErcDecisionRequired', $this->getRequiredLocale()));
                
                //test
				$this->addCheck(new FormValidatorLocale($this, 'rtoOffice', 'required', 'author.submit.form.rtoOfficeRequired', $this->getRequiredLocale()));
	}

	/**
	 * Initialize form data from current article.
	 */
	function initData() {

		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		if (isset($this->article)) {
			$article =& $this->article;

                        //Added by AIM, 01.30.2012
                        $proposalCountryArray = $article->getProposalCountry(null);
                        $proposalCountry[$this->getFormLocale()] = explode(",", $proposalCountryArray[$this->getFormLocale()]);

                        $proposalTypeArray = $article->getProposalType(null);
                        $proposalType[$this->getFormLocale()] = explode("+", $proposalTypeArray[$this->getFormLocale()]);
                        $otherProposalType = "";

                        //Added by AIM 02.16.2012
                        $articleDao =& DAORegistry::getDAO('ArticleDAO');
                        $proposalTypes = $articleDao->getProposalTypes();
                        $proposalTypeCodes = array();
                        foreach ($proposalTypes as $i => $type) {
                            array_push($proposalTypeCodes, $type['code']);
                        }
                        

                        foreach($proposalType[$this->getFormLocale()] as $i => $type) {
                            if(!in_array($type, $proposalTypeCodes) && $type != "") {
                                preg_match('/\((.*)\)/', $type, $matches);
                                $otherProposalType = $matches[1];
                                $proposalType[$this->getFormLocale()][$i] = "OTHER";
                            }
                        }
                        
			$this->_data = array(
				'authors' => array(),
				'title' => $article->getTitle(null), // Localized
				'abstract' => $article->getAbstract(null), // Localized
				'discipline' => $article->getDiscipline(null), // Localized
				'subjectClass' => $article->getSubjectClass(null), // Localized
				'subject' => $article->getSubject(null), // Localized
				'coverageGeo' => $article->getCoverageGeo(null), // Localized
				'coverageChron' => $article->getCoverageChron(null), // Localized
				'coverageSample' => $article->getCoverageSample(null), // Localized
				'type' => $article->getType(null), // Localized
				'language' => $article->getLanguage(),
				'sponsor' => $article->getSponsor(null), // Localized
				'section' => $sectionDao->getSection($article->getSectionId()),
				'citations' => $article->getCitations(),
                                /***********************************************************
                                 *  Init code for additional proposal metadata
                                 *  Added by: Anne Ivy Mirasol
                                 *  Last Edited: Dec. 24, 2011
                                 ***********************************************************/
                                 
                                 //Comment out by EL on April 12 2012

                                 //Returned getObjectives spf April 17, 2012
				 'objectives' => $article->getObjectives(null),
                                 
                                 'keywords' => $article->getKeywords(null),
                                 'startDate' => $article->getStartDate(null),
                                 'endDate' => $article->getEndDate(null),
                                 'fundsRequired' => $article->getFundsRequired(null),
                                 'proposalCountry' => $proposalCountry,
                                 'technicalUnit' => $article->getTechnicalUnit(null),
                                 'withHumanSubjects' => $article->getWithHumanSubjects(null),
                                 'proposalType' => $proposalType,
                                 'otherProposalType' => $otherProposalType,
                                 'submittedAsPi' => $article->getSubmittedAsPi(null),
                                 'conflictOfInterest' => $article->getConflictOfInterest(null),
                                 'reviewedByOtherErc' => $article->getReviewedByOtherErc(null),
                                 'otherErcDecision' => $article->getOtherErcDecision(null),
                                 
                                 //test
                                 'rtoOffice' => $article->getRtoOffice(null)
			);
                        
			$authors =& $article->getAuthors();
			for ($i=0, $count=count($authors); $i < $count; $i++) {
				array_push(
					$this->_data['authors'],
					array(
						'authorId' => $authors[$i]->getId(),
						'firstName' => $authors[$i]->getFirstName(),
						'middleName' => $authors[$i]->getMiddleName(),
						'lastName' => $authors[$i]->getLastName(),
						'affiliation' => $authors[$i]->getAffiliation(null),
						'country' => $authors[$i]->getCountry(),
						'email' => $authors[$i]->getEmail(),
						'url' => $authors[$i]->getUrl(),
						'competingInterests' => $authors[$i]->getCompetingInterests(null),
						'biography' => $authors[$i]->getBiography(null)
					)
				);
				if ($authors[$i]->getPrimaryContact()) {
					$this->setData('primaryContact', $i);
				}
			}
                        //Added by AIM, Feb 16 2012
                        //Add another author -- at least one PI
                        if($count <= 1) {
                            array_push($this->_data['authors'], array());
                        }
		}
		return parent::initData();
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array(
				'authors',
				'deletedAuthors',
				'primaryContact',
				'title',
				'abstract',
				'discipline',
				'subjectClass',
				'subject',
				'coverageGeo',
				'coverageChron',
				'coverageSample',
				'type',
				'language',
				'sponsor',
				'citations',
                                /*********************************************************
                                 *  Read input code for additional proposal metadata
                                 *  Added by: Anne Ivy Mirasol
                                 *  Last Edited: May 3, 2011
                                 *********************************************************/
                                 
                                 //Comment out by EL on April 12 2012

                                 //Returned by SPF on April 17, 2012
				 'objectives',
                                 
                                 'keywords',
                                 'startDate',
                                 'endDate',
                                 'fundsRequired',
                                 'proposalCountry',
                                 'technicalUnit',
                                 'withHumanSubjects',
                                 'proposalType',
                                 'submittedAsPi',
                                 'conflictOfInterest',
                                 'reviewedByOtherErc',
                                 'otherErcDecision',
                                 
                                 //test
                                 'rtoOffice'
			)
		);

		// Load the section. This is used in the step 2 form to
		// determine whether or not to display indexing options.
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$this->_data['section'] =& $sectionDao->getSection($this->article->getSectionId());

		if ($this->_data['section']->getAbstractsNotRequired() == 0) {
			$this->addCheck(new FormValidatorLocale($this, 'abstract', 'required', 'author.submit.form.abstractRequired', $this->getRequiredLocale()));
		}

	}

	/**
	 * Get the names of fields for which data should be localized
	 * @return array
	 */
	function getLocaleFieldNames() {
                /*******************************************************************
                 * Edited by Anne Ivy Mirasol -- Addition of fields
                 * Last Updated: May 3, 2011
                 *******************************************************************/
		return array('title', 'abstract', 'subjectClass', 'subject', 'coverageGeo', 'coverageChron', 'coverageSample', 'type', 'sponsor', 'objectives', 'keywords', 'startDate', 'endDate', 'fundsRequired', 'proposalCountry', 'technicalUnit', 'withHumanSubjects','proposalType', 'submittedAsPi', 'conflictOfInterest', 'reviewedByOtherErc', 'otherErcDecision', 'rtoOffice');

	}

	/**
	 * Display the form.
	 */
	function display() {
		$templateMgr =& TemplateManager::getManager();

		$countryDao =& DAORegistry::getDAO('CountryDAO');
		$countries =& $countryDao->getCountries();
        $templateMgr->assign_by_ref('countries', $countries);
                
		if (Request::getUserVar('addAuthor') || Request::getUserVar('delAuthor')  || Request::getUserVar('moveAuthor')) {
			$templateMgr->assign('scrollToAuthor', true);
		}

                /*********************************************************************
                 *  Get proposal types from database
                 *  Added by:  Anne Ivy Mirasol
                 *  Last Updated: April 25, 2011
                 *********************************************************************/
                $articleDao =& DAORegistry::getDAO('ArticleDAO');
                $proposalTypes = $articleDao->getProposalTypes();
                $templateMgr->assign('proposalTypes', $proposalTypes);

                /*********************************************************************
                 *  Get list of WPRO countries from the XML file
                 *  Added by:  Anne Ivy Mirasol
                 *  Last Updated: May 3, 2011
                 *********************************************************************/

                $countryDAO =& DAORegistry::getDAO('AsiaPacificCountryDAO');
                $proposalCountries =& $countryDAO->getAsiaPacificCountries();
                $templateMgr->assign_by_ref('proposalCountries', $proposalCountries);


                /*********************************************************************
                 *  Get list of WPRO technical units from the XML file
                 *  Added by:  Anne Ivy Mirasol
                 *  Last Updated: May 3, 2011
                 *********************************************************************/

                $technicalUnitDAO =& DAORegistry::getDAO('TechnicalUnitDAO');
                $technicalUnits =& $technicalUnitDAO->getTechnicalUnits();
                $templateMgr->assign_by_ref('technicalUnits', $technicalUnits);

                parent::display();
	}

	/**
	 * Save changes to article.
	 * @param $request Request
	 * @return int the article ID
	 */
	function execute(&$request) {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$authorDao =& DAORegistry::getDAO('AuthorDAO');
		$article =& $this->article;

		// Retrieve the previous citation list for comparison.
		$previousRawCitationList = $article->getCitations();

		// Update article
		$article->setTitle($this->getData('title'), null); // Localized
		$article->setAbstract($this->getData('abstract'), null); // Localized
		$article->setDiscipline($this->getData('discipline'), null); // Localized
		$article->setSubjectClass($this->getData('subjectClass'), null); // Localized
		$article->setSubject($this->getData('subject'), null); // Localized
		$article->setCoverageGeo($this->getData('coverageGeo'), null); // Localized
		$article->setCoverageChron($this->getData('coverageChron'), null); // Localized
		$article->setCoverageSample($this->getData('coverageSample'), null); // Localized
		$article->setType($this->getData('type'), null); // Localized
		$article->setLanguage($this->getData('language'));
		$article->setSponsor($this->getData('sponsor'), null); // Localized
		$article->setCitations($this->getData('citations'));
		if ($article->getSubmissionProgress() <= $this->step) {
			$article->stampStatusModified();
			$article->setSubmissionProgress($this->step + 1);
		}

        /***********************************************************
         *  Edited by: AIM
         *  Last Updated: Jan 30, 2012
         ***********************************************************/
                 
        //Comment out by EL on April 13 2012  
        //Returned setObjectives by SPF April 17, 2012
	$article->setObjectives($this->getData('objectives'), null); // Localized
                
        $article->setKeywords($this->getData('keywords'), null); // Localized
        $article->setStartDate($this->getData('startDate'), null); // Localized
        $article->setEndDate($this->getData('endDate'), null); // Localized
        $article->setFundsRequired($this->getData('fundsRequired'), null); // Localized

        //Convert multiple countries to CSV string
        $proposalCountryArray = $this->getData('proposalCountry');
        $proposalCountry[$this->getFormLocale()] = implode(",", $proposalCountryArray[$this->getFormLocale()]);
        $article->setProposalCountry($proposalCountry, null); // Localized

        //Convert multiple proposal types to CSV string, Jan 30 2012
        $proposalTypeArray = $this->getData('proposalType');
        foreach($proposalTypeArray[$this->getFormLocale()] as $i => $type) {
        	if($type == "OTHER") {
        		$otherType = trim(str_replace("+", ",", $request->getUserVar('otherProposalType')));
            	if($otherType != "") $proposalTypeArray[$this->getFormLocale()][$i] = "OTHER (". $otherType .")";
        	}
        }
        $proposalType[$this->getFormLocale()] = implode("+", $proposalTypeArray[$this->getFormLocale()]);
                
        $article->setProposalType($proposalType, null); // Localized
        $article->setTechnicalUnit($this->getData('technicalUnit'), null); // Localized
        $article->setWithHumanSubjects($this->getData('withHumanSubjects'),null); // Localized
	    $article->setSubmittedAsPi($this->getData('submittedAsPi'), null); // Localized
        $article->setConflictOfInterest($this->getData('conflictOfInterest'), null); // Localized
        $article->setReviewedByOtherErc($this->getData('reviewedByOtherErc'), null); // Localized
        $article->setOtherErcDecision($this->getData('otherErcDecision'), null); // Localized
        
        //test
        $article->setRtoOffice($this->getData('rtoOffice'), null);//Localized
                
        /***************** END OF EDIT *****************************/

        //
        // Update authors
		$authors = $this->getData('authors');
		for ($i=0, $count=count($authors); $i < $count; $i++) {
			if ($authors[$i]['authorId'] > 0) {
			// Update an existing author
				$author =& $article->getAuthor($authors[$i]['authorId']);
				$isExistingAuthor = true;
			} else {
				// Create a new author
				$author = new Author();
				$isExistingAuthor = false;
			}

			if ($author != null) {
				$author->setSubmissionId($article->getId());
				$author->setFirstName($authors[$i]['firstName']);
				$author->setMiddleName($authors[$i]['middleName']);
				$author->setLastName($authors[$i]['lastName']);
				$author->setAffiliation($authors[$i]['affiliation'], null);
				$author->setCountry($authors[$i]['country']);
				$author->setEmail($authors[$i]['email']);
				$author->setUrl($authors[$i]['url']);
				if (array_key_exists('competingInterests', $authors[$i])) {
					$author->setCompetingInterests($authors[$i]['competingInterests'], null);
				}
				//$author->setBiography($authors[$i]['biography'], null);  //AIM, 12.12.2011
				$author->setPrimaryContact($this->getData('primaryContact') == $i ? 1 : 0);
				$author->setSequence($authors[$i]['seq']);

				if ($isExistingAuthor == false) {
					$article->addAuthor($author);
				}
			}
			unset($author);
		}

		// Remove deleted authors
		$deletedAuthors = explode(':', $this->getData('deletedAuthors'));
		for ($i=0, $count=count($deletedAuthors); $i < $count; $i++) {
			$article->removeAuthor($deletedAuthors[$i]);
		}

		parent::execute();

		// Save the article
		$articleDao->updateArticle($article);

		// Update references list if it changed.
		$citationDao =& DAORegistry::getDAO('CitationDAO');
		$rawCitationList = $article->getCitations();
		if ($previousRawCitationList != $rawCitationList) {
			$citationDao->importCitations($request, ASSOC_TYPE_ARTICLE, $article->getId(), $rawCitationList);
		}
		return $this->articleId;
	}
}

?>
