<?php

/**
 * @file classes/author/form/submit/AuthorSubmitStep2Form.inc.php
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
		$this->addCheck(new FormValidatorArrayCustom($this, 'authors', 'required', 'user.profile.form.urlInvalid', create_function('$url, $regExp', 'return empty($url) ? true : String::regexp_match($regExp, $url);'), array(ValidatorUrl::getRegexp()), false, array('url')));
		$this->addCheck(new FormValidatorLocale($this, 'authorPhoneNumber', 'required', 'author.submit.form.authorPhoneNumber', $this->getRequiredLocale()));
		$this->addCheck(new FormValidatorLocale($this, 'scientificTitle', 'required', 'author.submit.form.scientificTitleRequired', $this->getRequiredLocale()));
		$this->addCheck(new FormValidatorLocale($this, 'publicTitle', 'required', 'author.submit.form.publicTitleRequired', $this->getRequiredLocale()));
		$this->addCheck(new FormValidatorLocale($this, 'studentInitiatedResearch', 'required', 'author.submit.form.studentInitiatedResearch', $this->getRequiredLocale()));
		$this->addCheck(new FormValidatorLocale($this, 'studentInstitution', 'required', 'author.submit.form.studentInstitution', $this->getRequiredLocale()));		
		$this->addCheck(new FormValidatorLocale($this, 'academicDegree', 'required', 'author.submit.form.academicDegree', $this->getRequiredLocale()));
		
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section = $sectionDao->getSection($article->getSectionId());
		$abstractWordCount = $section->getAbstractWordCount();
		
		if (isset($abstractWordCount) && $abstractWordCount > 0) {
			$this->addCheck(new FormValidatorCustom($this, 'abstract', 'required', 'author.submit.form.wordCountAlert', create_function('$abstract, $wordCount', 'foreach ($abstract as $localizedAbstract) {return count(explode(" ",$localizedAbstract)) < $wordCount; }'), array($abstractWordCount)));
		}
			
        $this->addCheck(new FormValidatorLocale($this, 'keywords', 'required', 'author.submit.form.keywordsRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'startDate', 'required', 'author.submit.form.startDateRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'endDate', 'required', 'author.submit.form.endDateRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'fundsRequired', 'required', 'author.submit.form.fundsRequiredRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'selectedCurrency', 'required', 'author.submit.form.selectedCurrency', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'primarySponsor', 'required', 'author.submit.form.primarySponsor', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'otherPrimarySponsor', 'required', 'author.submit.form.otherPrimarySponsor', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'otherSecondarySponsor', 'required', 'author.submit.form.otherSecondarySponsor', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'multiCountryResearch', 'required', 'author.submit.form.multiCountry', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'multiCountry', 'required', 'author.submit.form.country', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'nationwide', 'required', 'author.submit.form.nationwide', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'proposalCountry', 'required', 'author.submit.form.proposalCountryRequired', $this->getRequiredLocale()));
        
        $this->addCheck(new FormValidatorLocale($this, 'researchField', 'required', 'author.submit.form.researchField', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'otherResearchField', 'required', 'author.submit.form.otherResearchField', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'withHumanSubjects', 'required', 'author.submit.form.withHumanSubjectsRequired', $this->getRequiredLocale()));	        
        $this->addCheck(new FormValidatorLocale($this, 'proposalType', 'required', 'author.submit.form.proposalTypeRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'otherProposalType', 'required', 'author.submit.form.otherProposalTypeRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'dataCollection', 'required', 'author.submit.form.dataCollection', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'reviewedByOtherErc', 'required', 'author.submit.form.reviewedByOtherErcRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'otherErcDecision', 'required', 'author.submit.form.otherErcDecisionRequired', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'industryGrant', 'required', 'author.submit.form.industryGrant', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'nameOfIndustry', 'required', 'author.submit.form.nameOfIndustry', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'internationalGrant', 'required', 'author.submit.form.internationalGrant', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'internationalGrantName', 'required', 'author.submit.form.internationalGrantName', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'otherInternationalGrantName', 'required', 'author.submit.form.otherInternationalGrantName', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'mohGrant', 'required', 'author.submit.form.mohGrant', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'governmentGrant', 'required', 'author.submit.form.governmentGrant', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'governmentGrantName', 'required', 'author.submit.form.governmentGrantName', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'universityGrant', 'required', 'author.submit.form.universityGrant', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'selfFunding', 'required', 'author.submit.form.selfFunding', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'otherGrant', 'required', 'author.submit.form.otherGrant', $this->getRequiredLocale()));
        $this->addCheck(new FormValidatorLocale($this, 'specifyOtherGrant', 'required', 'author.submit.form.specifyOtherGrantField', $this->getRequiredLocale()));
	}

	/**
	 * Initialize form data from current article.
	 */
	function initData() {
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		if (isset($this->article)) {
			$article =& $this->article;

            $proposalCountryArray = $article->getProposalCountry(null);
            $proposalCountry[$this->getFormLocale()] = explode(",", $proposalCountryArray[$this->getFormLocale()]);
						
			$multiCountryArray = $article->getMultiCountry(null);
			$multiCountry[$this->getFormLocale()] = explode(",", $multiCountryArray[$this->getFormLocale()]);
            
            $researchFieldArray = $article->getResearchField(null);
            $researchField[$this->getFormLocale()] = explode("+", $researchFieldArray[$this->getFormLocale()]);
			$i = 0;
            foreach ($researchField[$this->getFormLocale()] as $field){
            	if (preg_match('#^Other\s\(.+\)$#', $field)){
                	$tempField = $field;
                    $field = preg_replace('#^Other\s\(.+\)$#','OTHER', $field);
                    $tempField = preg_replace('#^Other\s\(#','', $tempField);
                    $tempField = preg_replace('#\)$#','', $tempField);
                    $article->setOtherResearchField($tempField, $this->getFormLocale());
                }
                $test = array($i => $field);
                $researchField[$this->getFormLocale()] = array_replace ($researchField[$this->getFormLocale()], $test);
                $i++;
                unset ($field);
            }
            
            $proposalTypeArray = $article->getProposalType(null);
            $proposalType[$this->getFormLocale()] = explode("+", $proposalTypeArray[$this->getFormLocale()]);
			$f = 0;
            foreach ($proposalType[$this->getFormLocale()] as $type){
            	if (preg_match('#^Other\s\(.+\)$#', $type)){
                	$tempType = $type;
                    $type = preg_replace('#^Other\s\(.+\)$#','OTHER', $type);
                    $tempType = preg_replace('#^Other\s\(#','', $tempType);
                    $tempType = preg_replace('#\)$#','', $tempType);
                    $article->setOtherProposalType($tempType, $this->getFormLocale());
                }
                $test2 = array($f => $type);
                $proposalType[$this->getFormLocale()] = array_replace ($proposalType[$this->getFormLocale()], $test2);
                $f++;
                unset ($type);
            }

            $internationalGrantNameArray = $article->getInternationalGrantName(null);
            $internationalGrantName[$this->getFormLocale()] = explode("+", $internationalGrantNameArray[$this->getFormLocale()]);
			$g = 0;
            foreach ($internationalGrantName[$this->getFormLocale()] as $grant){
            	if (preg_match('#^Other\s\(.+\)$#', $grant)){
                	$tempGrant = $grant;
                    $grant = preg_replace('#^Other\s\(.+\)$#','OTHER', $grant);
                    $tempGrant = preg_replace('#^Other\s\(#','', $tempGrant);
                    $tempGrant = preg_replace('#\)$#','', $tempGrant);
                    $article->setOtherInternationalGrantName($tempGrant, $this->getFormLocale());
                }
                $test3 = array($g => $grant);
                $internationalGrantName[$this->getFormLocale()] = array_replace ($internationalGrantName[$this->getFormLocale()], $test3);
                $g++;
                unset ($grant);
            }
            
            $secondarySponsorArray = $article->getSecondarySponsors(null);
            $secondarySponsors[$this->getFormLocale()] = explode("+", $secondarySponsorArray[$this->getFormLocale()]);
			$h = 0;
            foreach ($secondarySponsors[$this->getFormLocale()] as $sponsor){
            	if (preg_match('#^Other\s\(.+\)$#', $sponsor)){
                	$tempSponsor = $sponsor;
                    $sponsor = preg_replace('#^Other\s\(.+\)$#','OTHER', $sponsor);
                    $tempSponsor = preg_replace('#^Other\s\(#','', $tempSponsor);
                    $tempSponsor = preg_replace('#\)$#','', $tempSponsor);
                    $article->setOtherSecondarySponsor($tempSponsor, $this->getFormLocale());
                }
                $test4 = array($h => $sponsor);
                $secondarySponsors[$this->getFormLocale()] = array_replace ($secondarySponsors[$this->getFormLocale()], $test4);
                $h++;
                unset ($sponsor);
            }
            
            $primarySponsorArray = $article->getPrimarySponsor(null);
            $primarySponsor[$this->getFormLocale()] = explode("+", $primarySponsorArray[$this->getFormLocale()]);
			$j = 0;
            foreach ($primarySponsor[$this->getFormLocale()] as $sponsor){
            	if (preg_match('#^Other\s\(.+\)$#', $sponsor)){
                	$tempSponsor = $sponsor;
                    $sponsor = preg_replace('#^Other\s\(.+\)$#','OTHER', $sponsor);
                    $tempSponsor = preg_replace('#^Other\s\(#','', $tempSponsor);
                    $tempSponsor = preg_replace('#\)$#','', $tempSponsor);
                    $article->setOtherPrimarySponsor($tempSponsor, $this->getFormLocale());
                }
                $test5 = array($j => $sponsor);
                $primarySponsor[$this->getFormLocale()] = array_replace ($primarySponsor[$this->getFormLocale()], $test5);
                $j++;
                unset ($sponsor);
            }
                                    
            $articleDao =& DAORegistry::getDAO('ArticleDAO');

			$this->_data = array(
				'authors' => array(),
				'authorPhoneNumber' => $article->getAuthorPhoneNumber(null),
				'scientificTitle' => $article->getScientificTitle(null), // Localized
				'publicTitle' => $article->getPublicTitle(null), // Localized
				'studentInitiatedResearch' => $article->getStudentInitiatedResearch(null),
				'studentInstitution' => $article->getStudentInstitution(null), 
				'academicDegree' => $article->getAcademicDegree(null),
				'abstract' => $article->getAbstract(null), // Localized
				'section' => $sectionDao->getSection($article->getSectionId()),                                 
                'keywords' => $article->getKeywords(null),
                'startDate' => $article->getStartDate(null),
                'endDate' => $article->getEndDate(null),
                'fundsRequired' => $article->getFundsRequired(null),
                'selectedCurrency' => $article->getSelectedCurrency(null),
                'primarySponsor' => $primarySponsor,
                'otherPrimarySponsor' => $article->getOtherPrimarySponsor(null),
                'secondarySponsors' => $secondarySponsors,
                'otherSecondarySponsor' => $article->getOtherSecondarySponsor(null),
                'multiCountryResearch' => $article->getMultiCountryResearch(null),
                'multiCountry' => $multiCountry,
                'nationwide' => $article->getNationwide(null),
                'proposalCountry' => $proposalCountry,
                'researchField' => $researchField,
                'otherResearchField' => $article->getOtherResearchField(null),
                'technicalUnit' => $article->getTechnicalUnit(null),
                'withHumanSubjects' => $article->getWithHumanSubjects(null),
                'proposalType' => $proposalType,
                'otherProposalType' => $article->getOtherProposalType(null),
                'dataCollection' => $article->getDataCollection(null),
                'submittedAsPi' => $article->getSubmittedAsPi(null),
                'conflictOfInterest' => $article->getConflictOfInterest(null),
                'reviewedByOtherErc' => $article->getReviewedByOtherErc(null),
                'otherErcDecision' => $article->getOtherErcDecision(null),
                'rtoOffice' => $article->getRtoOffice(null),
                'industryGrant' => $article->getIndustryGrant(null),
                'nameOfIndustry' => $article->getNameOfIndustry(null),
                'internationalGrant' => $article->getInternationalGrant(null),
                'internationalGrantName' => $internationalGrantName,
                'otherInternationalGrantName' =>$article->getOtherInternationalGrantName(null),
                'mohGrant' => $article->getMohGrant(null),
                'governmentGrant' => $article->getGovernmentGrant(null),
                'governmentGrantName' => $article->getGovernmentGrantName(null),
                'universityGrant' => $article->getUniversityGrant(null),
                'selfFunding' => $article->getSelfFunding(null),
                'otherGrant' => $article->getOtherGrant(null),
                'specifyOtherGrant' => $article->getSpecifyOtherGrant(null)
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
				'authorPhoneNumber',
				'scientificTitle',
				'publicTitle',
				'studentInitiatedResearch',
				'studentInstitution',
				'academicDegree',
				'abstract',
				'language',
                'keywords',
                'startDate',
                'endDate',
                'fundsRequired',
                'selectedCurrency',
                'primarySponsor',
                'otherPrimarySponsor',
                'secondarySponsors',
                'otherSecondarySponsor',
                'multiCountryResearch',
                'multiCountry',
                'nationwide',
                'proposalCountry',
                'researchField',
                'otherResearchField',
                'technicalUnit',
                'withHumanSubjects',
                'proposalType',
                'otherProposalType',
                'dataCollection',
                'submittedAsPi',
                'conflictOfInterest',
                'reviewedByOtherErc',
                'otherErcDecision',
                'rtoOffice',
                'industryGrant',
                'nameOfIndustry',
                'internationalGrant',
                'internationalGrantName',
                'otherInternationalGrantName',
                'mohGrant',
                'governmentGrant',
                'governmentGrantName',
                'universityGrant',
                'selfFunding',
                'otherGrant',
                'specifyOtherGrant'
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
		return array('authorPhoneNumber', 'scientificTitle', 'publicTitle', 'studentInitiatedResearch', 'studentInstitution', 'academicDegree','abstract', 'keywords', 'startDate', 'endDate', 'fundsRequired', 'selectedCurrency', 'primarySponsor', 'otherPrimarySponsor', 'secondarySponsors', 'otherSecondarySponsor', 'multiCountryResearch', 'multiCountry', 'nationwide', 'proposalCountry', 'researchField', 'otherResearchField', 'withHumanSubjects','proposalType', 'otherProposalType', 'dataCollection', 'submittedAsPi', 'conflictOfInterest', 'reviewedByOtherErc', 'otherErcDecision', 'rtoOffice', 'industryGrant', 'nameOfIndustry', 'internationalGrant', 'internationalGrantName', 'otherInternationalGrantName', 'mohGrant', 'governmentGrant', 'governmentGrantName', 'universityGrant', 'selfFunding', 'otherGrant', 'specifyOtherGrant');
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

        $articleDao =& DAORegistry::getDAO('ArticleDAO');

        // Get proposal types
        $proposalTypes = $articleDao->getProposalTypes();
        $templateMgr->assign('proposalTypes', $proposalTypes);

		//Get research fields
        $researchFields = $articleDao->getResearchFields();
        $templateMgr->assign('researchFields', $researchFields);
        
       	//Get list of agencies
        $agencies = $articleDao->getAgencies();
        $templateMgr->assign('agencies', $agencies);

		//Get list of regions of Philippines
       	$regionDAO =& DAORegistry::getDAO('RegionsOfPhilippinesDAO');
        $proposalCountries =& $regionDAO->getRegionsOfPhilippines();
        $templateMgr->assign_by_ref('proposalCountries', $proposalCountries);

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
		$article->setAuthorPhoneNumber($this->getData('authorPhoneNumber'), null);
		$article->setScientificTitle($this->getData('scientificTitle'), null); // Localized
		$article->setPublicTitle($this->getData('publicTitle'), null);// Localized
		$article->setStudentInitiatedResearch($this->getData('studentInitiatedResearch'), null);
		$article->setStudentInstitution($this->getData('studentInstitution'), null);
		$article->setAcademicDegree($this->getData('academicDegree'), null);
		$article->setAbstract($this->getData('abstract'), null); // Localized
		$article->setLanguage($this->getData('language'));
		if ($article->getSubmissionProgress() <= $this->step) {
			$article->stampStatusModified();
			$article->setSubmissionProgress($this->step + 1);
		}                
        $article->setKeywords($this->getData('keywords'), null); // Localized
        $article->setStartDate($this->getData('startDate'), null); // Localized
        $article->setEndDate($this->getData('endDate'), null); // Localized
        $article->setFundsRequired($this->getData('fundsRequired'), null); // Localized
        $article->setSelectedCurrency($this->getData('selectedCurrency'), null);
        $article->setMultiCountryResearch($this->getData('multiCountryResearch'), null);
		$article->setNationwide($this->getData('nationwide'), null);
		
        //Convert multiple regions to CSV string
        $proposalCountryArray = $this->getData('proposalCountry');
        $proposalCountry[$this->getFormLocale()] = implode(",", $proposalCountryArray[$this->getFormLocale()]);
        $article->setProposalCountry($proposalCountry, null); // Localized

        //Convert multiple proposal types to CSV string, Jan 30 2012
        $proposalTypeArray = $this->getData('proposalType');
        foreach($proposalTypeArray[$this->getFormLocale()] as $i => $type) {
        	if($type == "OTHER") {
        		$otherType = $this->getData('otherProposalType');
            	if($otherType != "") {
            		$proposalTypeArray[$this->getFormLocale()][$i] = "Other (". $otherType[$this->getFormLocale()] .")";
            	}
        	}
        }
        
        $proposalType[$this->getFormLocale()] = implode("+", $proposalTypeArray[$this->getFormLocale()]);
        $article->setProposalType($proposalType, null); // Localized
        
        //Convert multiple international grants to CSV string
        $article->setInternationalGrant($this->getData('internationalGrant'), null); 
        $internationalGrantNameArray = $this->getData('internationalGrantName');
        foreach($internationalGrantNameArray[$this->getFormLocale()] as $i => $grant) {
        	if($grant == "OTHER") {
        		$otherGrant = $this->getData('otherInternationalGrantName');
            	if($otherGrant != "") {
            		$internationalGrantNameArray[$this->getFormLocale()][$i] = "Other (". $otherGrant[$this->getFormLocale()] .")";
            	}
        	}
        }
        
        $internationalGrantName[$this->getFormLocale()] = implode("+", $internationalGrantNameArray[$this->getFormLocale()]);
        $article->setInternationalGrantName($internationalGrantName, null); // Localized

        //Convert multiple secondary sponsor to CSV string
        $secondarySponsorArray = $this->getData('secondarySponsors');
        foreach($secondarySponsorArray[$this->getFormLocale()] as $i => $sponsor) {
        	if($sponsor == "OTHER") {
        		$otherSponsor = $this->getData('otherSecondarySponsor');
            	if($otherSponsor != "") {
            		$secondarySponsorArray[$this->getFormLocale()][$i] = "Other (". $otherSponsor[$this->getFormLocale()] .")";
            	}
        	}
        }
        
        $secondarySponsors[$this->getFormLocale()] = implode("+", $secondarySponsorArray[$this->getFormLocale()]);
        $article->setSecondarySponsors($secondarySponsors, null); // Localized
        
        //Convert multiple primary sponsor to CSV string
        $primarySponsorArray = $this->getData('primarySponsor');
        foreach($primarySponsorArray[$this->getFormLocale()] as $i => $sponsor) {
        	if($sponsor == "OTHER") {
        		$otherSponsor = $this->getData('otherPrimarySponsor');
            	if($otherSponsor != "") {
            		$primarySponsorArray[$this->getFormLocale()][$i] = "Other (". $otherSponsor[$this->getFormLocale()] .")";
            	}
        	}
        }
        
        $primarySponsor[$this->getFormLocale()] = implode("+", $primarySponsorArray[$this->getFormLocale()]);
        $article->setPrimarySponsor($primarySponsor, null); // Localized
                        
        //Convert multiple research fields to CSV
        $researchFieldArray = $this->getData('researchField');
        foreach($researchFieldArray[$this->getFormLocale()] as $i => $field) {
        	if($field == "OTHER") {
        		$otherField = $this->getData('otherResearchField');
            	if($otherField != "") {
            		$researchFieldArray[$this->getFormLocale()][$i] = "Other (". $otherField[$this->getFormLocale()] .")";
            	}
        	}
        }   
        
        $researchField[$this->getFormLocale()] = implode("+", $researchFieldArray[$this->getFormLocale()]);
        $article->setResearchField($researchField, null);
        
        //$article->setOtherResearchField($this->getData('otherResearchField'), null);
        
        //Convert multiple countries to CSV
        $multiCountryArray = $this->getData('multiCountry');
        $multiCountry[$this->getFormLocale()] = implode(",", $multiCountryArray[$this->getFormLocale()]);
        $article->setMultiCountry($multiCountry, null);
        
        $article->setDataCollection($this->getData('dataCollection'), null);
        $article->setTechnicalUnit($this->getData('technicalUnit'), null); // Localized
        $article->setWithHumanSubjects($this->getData('withHumanSubjects'),null); // Localized
	    $article->setSubmittedAsPi($this->getData('submittedAsPi'), null); // Localized
        $article->setConflictOfInterest($this->getData('conflictOfInterest'), null); // Localized
        $article->setReviewedByOtherErc($this->getData('reviewedByOtherErc'), null); // Localized
        $article->setOtherErcDecision($this->getData('otherErcDecision'), null); // Localized
        $article->setRtoOffice($this->getData('rtoOffice'), null);//Localized
        
        $article->setIndustryGrant($this->getData('industryGrant'), null);
        $article->setNameOfIndustry($this->getData('nameOfIndustry'), null); 
        $article->setMohGrant($this->getData('mohGrant'), null);
        $article->setGovernmentGrant($this->getData('governmentGrant'), null);
        $article->setGovernmentGrantName($this->getData('governmentGrantName'), null); 
        $article->setUniversityGrant($this->getData('universityGrant'), null); 
        $article->setSelfFunding($this->getData('selfFunding'), null); 
        $article->setOtherGrant($this->getData('otherGrant'), null); 
        $article->setSpecifyOtherGrant($this->getData('specifyOtherGrant'), null);         
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
				if (isset($authors[$i]['firstName'])) $author->setFirstName($authors[$i]['firstName']);
				if (isset($authors[$i]['middleName'])) $author->setMiddleName($authors[$i]['middleName']);
				if (isset($authors[$i]['lastName'])) $author->setLastName($authors[$i]['lastName']);
				if (isset($authors[$i]['affiliation'])) $author->setAffiliation($authors[$i]['affiliation'], null);
				if (isset($authors[$i]['country'])) $author->setCountry($authors[$i]['country']);
				if (isset($authors[$i]['email'])) $author->setEmail($authors[$i]['email']);
				if (isset($authors[$i]['url'])) $author->setUrl($authors[$i]['url']);
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
