<?php

/**
 * @file classes/submission/form/MetadataForm.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class MetadataForm
 * @ingroup submission_form
 *
 * @brief Form to change metadata information for a submission.
 */


import('lib.pkp.classes.form.Form');

class MetadataForm extends Form {
	/** @var Article current article */
	var $article;

	/** @var boolean can edit metadata */
	var $canEdit;

	/** @var boolean can view authors */
	var $canViewAuthors;

	/** @var boolean is an Editor, can edit all metadata */
	var $isEditor;

	/**
	 * Constructor.
	 */
	function MetadataForm($article, $journal) {
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$user =& Request::getUser();
		$roleId = $roleDao->getRoleIdFromPath(Request::getRequestedPage());

		// If the user is an editor of this article, make the entire form editable.
		$this->canEdit = false;
		$this->isEditor = false;
		if ($roleId != null && ($roleId == ROLE_ID_EDITOR || $roleId == ROLE_ID_SECTION_EDITOR)) {
			$this->canEdit = true;
			$this->isEditor = true;
		}

		$copyeditInitialSignoff = $signoffDao->getBySymbolic('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $article->getId());
		// If the user is an author and the article hasn't passed the Copyediting stage, make the form editable.
		if ($roleId == ROLE_ID_AUTHOR) {
			if ($article->getStatus() != STATUS_PUBLISHED && ($copyeditInitialSignoff == null || $copyeditInitialSignoff->getDateCompleted() == null)) {
				$this->canEdit = true;
			}
		}

		// Copy editors are also allowed to edit metadata, but only if they have
		// a current assignment to the article.
		if ($roleId != null && ($roleId == ROLE_ID_COPYEDITOR)) {
			$copyeditFinalSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $article->getId());
			if ($copyeditFinalSignoff != null && $article->getStatus() != STATUS_PUBLISHED) {
				if ($copyeditInitialSignoff->getDateNotified() != null && $copyeditFinalSignoff->getDateCompleted() == null) {
					$this->canEdit = true;
				}
			}
		}

		if ($this->canEdit) {
			$supportedSubmissionLocales = $journal->getSetting('supportedSubmissionLocales');
			if (empty($supportedSubmissionLocales)) $supportedSubmissionLocales = array($journal->getPrimaryLocale());

			parent::Form(
				'submission/metadata/metadataEdit.tpl',
				true,
				$article->getLocale(),
				array_flip(array_intersect(
					array_flip(Locale::getAllLocales()),
					$supportedSubmissionLocales
				))
			);
			$this->addCheck(new FormValidatorLocale($this, 'title', 'required', 'author.submit.form.titleRequired', $this->getRequiredLocale()));
			$this->addCheck(new FormValidatorArray($this, 'authors', 'required', 'author.submit.form.authorRequiredFields', array('firstName', 'lastName')));
			$this->addCheck(new FormValidatorArrayCustom($this, 'authors', 'required', 'author.submit.form.authorRequiredFields', create_function('$email, $regExp', 'return String::regexp_match($regExp, $email);'), array(ValidatorEmail::getRegexp()), false, array('email')));
			$this->addCheck(new FormValidatorArrayCustom($this, 'authors', 'required', 'user.profile.form.urlInvalid', create_function('$url, $regExp', 'return empty($url) ? true : String::regexp_match($regExp, $url);'), array(ValidatorUrl::getRegexp()), false, array('url')));
                        
                        /************************************************************************************************************/
                        /*  Validation code for additional proposal metadata (keys found in author.xml)
                         *  Added by:  AIM
                         *  Last Update: Dec 24, 2011
                         ************************************************************************************************************/
                        $this->addCheck(new FormValidatorLocale($this, 'objectives', 'required', 'author.submit.form.objectivesRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'keywords', 'required', 'author.submit.form.keywordsRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'startDate', 'required', 'author.submit.form.startDateRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'endDate', 'required', 'author.submit.form.endDateRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'fundsRequired', 'required', 'author.submit.form.fundsRequiredRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'proposalCountry', 'required', 'author.submit.form.proposalCountryRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'technicalUnit', 'required', 'author.submit.form.technicalUnitRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'proposalType', 'required', 'author.submit.form.proposalTypeRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'submittedAsPi', 'required', 'author.submit.form.submittedAsPiRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'conflictOfInterest', 'required', 'author.submit.form.conflictOfInterestRequired', $this->getRequiredLocale()));
                        $this->addCheck(new FormValidatorLocale($this, 'reviewedByOtherErc', 'required', 'author.submit.form.reviewedByOtherErcRequired', $this->getRequiredLocale()));

                } else {
			parent::Form('submission/metadata/metadataView.tpl');
		}

		// If the user is a reviewer of this article, do not show authors.
		$this->canViewAuthors = true;
		if ($roleId != null && $roleId == ROLE_ID_REVIEWER) {
			$this->canViewAuthors = false;
		}

		$this->article = $article;

		$this->addCheck(new FormValidatorPost($this));
	}

	/**
	 * Get the default form locale.
	 * @return string
	 */
	function getDefaultFormLocale() {
		if ($this->article) return $this->article->getLocale();
		return parent::getDefaultFormLocale();
	}

	/**
	 * Initialize form data from current article.
	 */
	function initData() {
		if (isset($this->article)) {
			$article =& $this->article;

                        //Added by AIM, 12.24.2011
                        $proposalCountryArray = $article->getProposalCountry(null);
                        $proposalCountry[$this->getFormLocale()] = explode(",", $proposalCountryArray[$this->getFormLocale()]);

			$this->_data = array(
				'authors' => array(),
				'title' => $article->getTitle(null), // Localized
				'abstract' => $article->getAbstract(null), // Localized
				'coverPageAltText' => $article->getCoverPageAltText(null), // Localized
				'showCoverPage' => $article->getShowCoverPage(null), // Localized
				'hideCoverPageToc' => $article->getHideCoverPageToc(null), // Localized
				'hideCoverPageAbstract' => $article->getHideCoverPageAbstract(null), // Localized
				'originalFileName' => $article->getOriginalFileName(null), // Localized
				'fileName' => $article->getFileName(null), // Localized
				'width' => $article->getWidth(null), // Localized
				'height' => $article->getHeight(null), // Localized
				'discipline' => $article->getDiscipline(null), // Localized
				'subjectClass' => $article->getSubjectClass(null), // Localized
				'subject' => $article->getSubject(null), // Localized
				'coverageGeo' => $article->getCoverageGeo(null), // Localized
				'coverageChron' => $article->getCoverageChron(null), // Localized
				'coverageSample' => $article->getCoverageSample(null), // Localized
				'type' => $article->getType(null), // Localized
				'language' => $article->getLanguage(),
				'sponsor' => $article->getSponsor(null), // Localized
				'citations' => $article->getCitations(),
				'hideAuthor' => $article->getHideAuthor(),

                                //Added by AIM, 12.22.2011
                                'objectives' => $article->getObjectives(null),
                                'keywords' => $article->getKeywords(null),
                                'startDate' => $article->getStartDate(null),
                                'endDate' => $article->getEndDate(null),
                                'fundsRequired' => $article->getFundsRequired(null),
                                'proposalCountry' => $proposalCountry,
                                'technicalUnit' => $article->getTechnicalUnit(null),
                                'proposalType' => $article->getProposalType(null),
                                'submittedAsPi' => $article->getSubmittedAsPi(null),
                                'conflictOfInterest' => $article->getConflictOfInterest(null),
                                'reviewedByOtherErc' => $article->getReviewedByOtherErc(null),
                                'otherErcDecision' => $article->getOtherErcDecision(null)
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
						'affiliation' => $authors[$i]->getAffiliation(null), // Localized
						'country' => $authors[$i]->getCountry(),
						'countryLocalized' => $authors[$i]->getCountryLocalized(),
						'email' => $authors[$i]->getEmail(),
						'url' => $authors[$i]->getUrl(),
						'competingInterests' => $authors[$i]->getCompetingInterests(null), // Localized
						'biography' => $authors[$i]->getBiography(null) // Localized
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
	 * Get the field names for which data can be localized
	 * @return array
	 */
	function getLocaleFieldNames() {
                /*
		return array(
			'title', 'abstract', 'coverPageAltText', 'showCoverPage', 'hideCoverPageToc', 'hideCoverPageAbstract', 'originalFileName', 'fileName', 'width', 'height',
			'discipline', 'subjectClass', 'subject', 'coverageGeo', 'coverageChron', 'coverageSample', 'type', 'sponsor', 'citations'
		);*/

                return array('title', 'abstract', 'objectives', 'keywords', 'startDate', 'endDate', 'fundsRequired', 'proposalCountry', 'technicalUnit', 'proposalType', 'submittedAsPi', 'conflictOfInterest', 'reviewedByOtherErc', 'otherErcDecision');
	}

	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$settingsDao =& DAORegistry::getDAO('JournalSettingsDAO');
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_EDITOR)); // editor.cover.xxx locale keys; FIXME?

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('articleId', isset($this->article)?$this->article->getId():null);
		$templateMgr->assign('journalSettings', $settingsDao->getJournalSettings($journal->getId()));
		$templateMgr->assign('rolePath', Request::getRequestedPage());
		$templateMgr->assign('canViewAuthors', $this->canViewAuthors);

		$countryDao =& DAORegistry::getDAO('CountryDAO');
		$templateMgr->assign('countries', $countryDao->getCountries());

		$templateMgr->assign('helpTopicId','submission.indexingAndMetadata');
		if ($this->article) {
			$templateMgr->assign_by_ref('section', $sectionDao->getSection($this->article->getSectionId()));
		}

		if ($this->isEditor) {
			import('classes.article.Article');
			$hideAuthorOptions = array(
				AUTHOR_TOC_DEFAULT => Locale::Translate('editor.article.hideTocAuthorDefault'),
				AUTHOR_TOC_HIDE => Locale::Translate('editor.article.hideTocAuthorHide'),
				AUTHOR_TOC_SHOW => Locale::Translate('editor.article.hideTocAuthorShow')
			);
			$templateMgr->assign('hideAuthorOptions', $hideAuthorOptions);
			$templateMgr->assign('isEditor', true);
		}

                /*********************************************************************
                 *  Get proposal types from database
                 *  Added by:  AIM
                 *  Last Updated: December 22, 2011
                 *********************************************************************/
                $articleDao =& DAORegistry::getDAO('ArticleDAO');
                $proposalTypes = $articleDao->getProposalTypes();
                $templateMgr->assign('proposalTypes', $proposalTypes);

                /*********************************************************************
                 *  Get list of WPRO countries from the XML file
                 *  Added by:  AIM
                 *  Last Updated: December 22, 2011
                 *********************************************************************/

                $countryDAO =& DAORegistry::getDAO('AsiaPacificCountryDAO');
                $proposalCountries =& $countryDAO->getAsiaPacificCountries();
                $templateMgr->assign_by_ref('proposalCountries', $proposalCountries);


                /*********************************************************************
                 *  Get list of WPRO technical units from the XML file
                 *  Added by:  AIM
                 *  Last Updated: December 22, 2011
                 *********************************************************************/

                $technicalUnitDAO =& DAORegistry::getDAO('TechnicalUnitDAO');
                $technicalUnits =& $technicalUnitDAO->getTechnicalUnits();
                $templateMgr->assign_by_ref('technicalUnits', $technicalUnits);

		parent::display();
	}


	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array(
				'articleId',
				'authors',
				'deletedAuthors',
				'primaryContact',
				'title',
				'abstract',
				//'coverPageAltText',
				//'showCoverPage',
				//'hideCoverPageToc',
				//'hideCoverPageAbstract',
				'originalFileName',
				'fileName',
				//'width',
				//'height',
				//'discipline',
				//'subjectClass',
				//'subject',
				//'coverageGeo',
				//'coverageChron',
				//'coverageSample',
				//'type',
				//'language',
				//'sponsor',
				//'citations',
				//'hideAuthor',

                                /*********************************************************
                                 *  Read input code for additional proposal metadata
                                 *  Added by: AIM
                                 *  Last Edited: Dec 24, 2011
                                 *********************************************************/
                                 'objectives',
                                 'keywords',
                                 'startDate',
                                 'endDate',
                                 'fundsRequired',
                                 'proposalCountry',
                                 'technicalUnit',
                                 'proposalType',
                                 'submittedAsPi',
                                 'conflictOfInterest',
                                 'reviewedByOtherErc',
                                 'otherErcDecision'
			)
		);

		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section =& $sectionDao->getSection($this->article->getSectionId());
		if (!$section->getAbstractsNotRequired()) {
			$this->addCheck(new FormValidatorLocale($this, 'abstract', 'required', 'author.submit.form.abstractRequired', $this->getRequiredLocale()));
		}
	}

	/**
	 * Save changes to article.
	 * @param $request PKPRequest
	 * @return int the article ID
	 */
	function execute(&$request) {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$authorDao =& DAORegistry::getDAO('AuthorDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$citationDao =& DAORegistry::getDAO('CitationDAO');
		$article =& $this->article;

		// Retrieve the previous citation list for comparison.
		$previousRawCitationList = $article->getCitations();

		// Update article
		$article->setTitle($this->getData('title'), null); // Localized

		$section =& $sectionDao->getSection($article->getSectionId());
		$article->setAbstract($this->getData('abstract'), null); // Localized

                /***********************************************************
                 *  Edited by: AIM
                 *  Last Updated: Dec 24, 2011
                 ***********************************************************/

                $article->setObjectives($this->getData('objectives'), null); // Localized
                $article->setKeywords($this->getData('keywords'), null); // Localized
                $article->setStartDate($this->getData('startDate'), null); // Localized
                $article->setEndDate($this->getData('endDate'), null); // Localized
                $article->setFundsRequired($this->getData('fundsRequired'), null); // Localized
                
                //Convert multiple countries to CSV string
                $proposalCountryArray = $this->getData('proposalCountry');
                $proposalCountry[$this->getFormLocale()] = implode(",", $proposalCountryArray[$this->getFormLocale()]);
                $article->setProposalCountry($proposalCountry, null); // Localized
                
                $article->setTechnicalUnit($this->getData('technicalUnit'), null); // Localized
                $article->setProposalType($this->getData('proposalType'), null); // Localized
                $article->setSubmittedAsPi($this->getData('submittedAsPi'), null); // Localized
                $article->setConflictOfInterest($this->getData('conflictOfInterest'), null); // Localized
                $article->setReviewedByOtherErc($this->getData('reviewedByOtherErc'), null); // Localized
                $article->setOtherErcDecision($this->getData('otherErcDecision'), null); // Localized

                /***************** END OF EDIT *****************************/

                
                /** AIM, 12.14.2011
		import('classes.file.PublicFileManager');
		$publicFileManager = new PublicFileManager();
		if ($publicFileManager->uploadedFileExists('coverPage')) {
			$journal = Request::getJournal();
			$originalFileName = $publicFileManager->getUploadedFileName('coverPage');
			$newFileName = 'cover_article_' . $this->getData('articleId') . '_' . $this->getFormLocale() . '.' . $publicFileManager->getExtension($originalFileName);
			$publicFileManager->uploadJournalFile($journal->getId(), 'coverPage', $newFileName);
			$article->setOriginalFileName($publicFileManager->truncateFileName($originalFileName, 127), $this->getFormLocale());
			$article->setFileName($newFileName, $this->getFormLocale());

			// Store the image dimensions.
			list($width, $height) = getimagesize($publicFileManager->getJournalFilesPath($journal->getId()) . '/' . $newFileName);
			$article->setWidth($width, $this->getFormLocale());
			$article->setHeight($height, $this->getFormLocale());
		}

		$article->setCoverPageAltText($this->getData('coverPageAltText'), null); // Localized
		$showCoverPage = array_map(create_function('$arrayElement', 'return (int)$arrayElement;'), (array) $this->getData('showCoverPage'));
		foreach (array_keys($this->getData('coverPageAltText')) as $locale) {
			if (!array_key_exists($locale, $showCoverPage)) {
				$showCoverPage[$locale] = 0;
			}
		}
		$article->setShowCoverPage($showCoverPage, null); // Localized

		$hideCoverPageToc = array_map(create_function('$arrayElement', 'return (int)$arrayElement;'), (array) $this->getData('hideCoverPageToc'));
		foreach (array_keys($this->getData('coverPageAltText')) as $locale) {
			if (!array_key_exists($locale, $hideCoverPageToc)) {
				$hideCoverPageToc[$locale] = 0;
			}
		}
		$article->setHideCoverPageToc($hideCoverPageToc, null); // Localized

		$hideCoverPageAbstract = array_map(create_function('$arrayElement', 'return (int)$arrayElement;'), (array) $this->getData('hideCoverPageAbstract'));
		foreach (array_keys($this->getData('coverPageAltText')) as $locale) {
			if (!array_key_exists($locale, $hideCoverPageAbstract)) {
				$hideCoverPageAbstract[$locale] = 0;
			}
		}
		$article->setHideCoverPageAbstract($hideCoverPageAbstract, null); // Localized

		$article->setDiscipline($this->getData('discipline'), null); // Localized
		$article->setSubjectClass($this->getData('subjectClass'), null); // Localized
		$article->setSubject($this->getData('subject'), null); // Localized
		$article->setCoverageGeo($this->getData('coverageGeo'), null); // Localized
		$article->setCoverageChron($this->getData('coverageChron'), null); // Localized
		$article->setCoverageSample($this->getData('coverageSample'), null); // Localized
		$article->setType($this->getData('type'), null); // Localized
		$article->setLanguage($this->getData('language')); // Localized
		$article->setSponsor($this->getData('sponsor'), null); // Localized
		$article->setCitations($this->getData('citations'));
		if ($this->isEditor) {
			$article->setHideAuthor($this->getData('hideAuthor') ? $this->getData('hideAuthor') : 0);
		}
                */
		// Update authors
		$authors = $this->getData('authors');
		for ($i=0, $count=count($authors); $i < $count; $i++) {
			if ($authors[$i]['authorId'] > 0) {
				// Update an existing author
				$author =& $article->getAuthor($authors[$i]['authorId']);
				$isExistingAuthor = true;

			} else {
				// Create a new author
				if (checkPhpVersion('5.0.0')) { // *5488* PHP4 Requires explicit instantiation-by-reference
					$author = new Author();
				} else {
					$author =& new Author();
				}
				$isExistingAuthor = false;
			}

			if ($author != null) {
				$author->setFirstName($authors[$i]['firstName']);
				$author->setMiddleName($authors[$i]['middleName']);
				$author->setLastName($authors[$i]['lastName']);
				$author->setAffiliation($authors[$i]['affiliation'], null); // Localized
				$author->setCountry($authors[$i]['country']);
				$author->setEmail($authors[$i]['email']);
				$author->setUrl($authors[$i]['url']);
				if (array_key_exists('competingInterests', $authors[$i])) {
					$author->setCompetingInterests($authors[$i]['competingInterests'], null); // Localized
				}
				//$author->setBiography($authors[$i]['biography'], null); // Localized
				$author->setPrimaryContact($this->getData('primaryContact') == $i ? 1 : 0);
				$author->setSequence($authors[$i]['seq']);

				if ($isExistingAuthor == false) {
					$article->addAuthor($author);
				}
			}
		}

		// Remove deleted authors
		$deletedAuthors = explode(':', $this->getData('deletedAuthors'));
		for ($i=0, $count=count($deletedAuthors); $i < $count; $i++) {
			$article->removeAuthor($deletedAuthors[$i]);
		}

		parent::execute();

		// Save the article
		$articleDao->updateArticle($article);

		// Update search index
		import('classes.search.ArticleSearchIndex');
		ArticleSearchIndex::indexArticleMetadata($article);

		// Update references list if it changed.
		$rawCitationList = $article->getCitations();
		if ($previousRawCitationList != $rawCitationList) {
			$citationDao->importCitations($request, ASSOC_TYPE_ARTICLE, $article->getId(), $rawCitationList);
		}

		return $article->getId();
	}

	/**
	 * Determine whether or not the current user is allowed to edit metadata.
	 * @return boolean
	 */
	function getCanEdit() {
		return $this->canEdit;
	}
}

?>
