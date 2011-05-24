-- phpMyAdmin SQL Dump
-- version 3.3.7deb5build0.10.10.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 03, 2011 at 10:27 AM
-- Server version: 5.1.49
-- PHP Version: 5.3.3-1ubuntu9.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ojs`
--

-- --------------------------------------------------------

--
-- Table structure for table `access_keys`
--

CREATE TABLE IF NOT EXISTS `access_keys` (
  `access_key_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context` varchar(40) NOT NULL,
  `key_hash` varchar(40) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY (`access_key_id`),
  KEY `access_keys_hash` (`key_hash`,`user_id`,`context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `access_keys`
--


-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE IF NOT EXISTS `announcements` (
  `announcement_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) DEFAULT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `type_id` bigint(20) DEFAULT NULL,
  `date_expire` datetime DEFAULT NULL,
  `date_posted` datetime NOT NULL,
  PRIMARY KEY (`announcement_id`),
  KEY `announcements_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `announcements`
--


-- --------------------------------------------------------

--
-- Table structure for table `announcement_settings`
--

CREATE TABLE IF NOT EXISTS `announcement_settings` (
  `announcement_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `announcement_settings_pkey` (`announcement_id`,`locale`,`setting_name`),
  KEY `announcement_settings_announcement_id` (`announcement_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `announcement_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `announcement_types`
--

CREATE TABLE IF NOT EXISTS `announcement_types` (
  `type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) DEFAULT NULL,
  `assoc_id` bigint(20) NOT NULL,
  PRIMARY KEY (`type_id`),
  KEY `announcement_types_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `announcement_types`
--


-- --------------------------------------------------------

--
-- Table structure for table `announcement_type_settings`
--

CREATE TABLE IF NOT EXISTS `announcement_type_settings` (
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `announcement_type_settings_pkey` (`type_id`,`locale`,`setting_name`),
  KEY `announcement_type_settings_type_id` (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `announcement_type_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `article_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `locale` varchar(5) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `section_id` bigint(20) DEFAULT NULL,
  `language` varchar(10) DEFAULT 'en',
  `comments_to_ed` text,
  `citations` text,
  `date_submitted` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `date_status_modified` datetime DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `date_checked` datetime DEFAULT NULL,
  `date_returned` datetime DEFAULT NULL,
  `submission_progress` tinyint(4) NOT NULL DEFAULT '1',
  `current_round` tinyint(4) NOT NULL DEFAULT '1',
  `submission_file_id` bigint(20) DEFAULT NULL,
  `revised_file_id` bigint(20) DEFAULT NULL,
  `review_file_id` bigint(20) DEFAULT NULL,
  `editor_file_id` bigint(20) DEFAULT NULL,
  `pages` varchar(255) DEFAULT NULL,
  `doi` varchar(255) DEFAULT NULL,
  `fast_tracked` tinyint(4) NOT NULL DEFAULT '0',
  `hide_author` tinyint(4) NOT NULL DEFAULT '0',
  `comments_status` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`article_id`),
  KEY `articles_user_id` (`user_id`),
  KEY `articles_journal_id` (`journal_id`),
  KEY `articles_section_id` (`section_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `articles`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_comments`
--

CREATE TABLE IF NOT EXISTS `article_comments` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `comment_type` bigint(20) DEFAULT NULL,
  `role_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `author_id` bigint(20) NOT NULL,
  `comment_title` varchar(255) NOT NULL,
  `comments` text,
  `date_posted` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `viewable` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `article_comments_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `article_comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_email_log`
--

CREATE TABLE IF NOT EXISTS `article_email_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) NOT NULL,
  `date_sent` datetime NOT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  `event_type` bigint(20) DEFAULT NULL,
  `assoc_type` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `from_address` varchar(255) DEFAULT NULL,
  `recipients` text,
  `cc_recipients` text,
  `bcc_recipients` text,
  `subject` varchar(255) DEFAULT NULL,
  `body` text,
  PRIMARY KEY (`log_id`),
  KEY `article_email_log_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `article_email_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_event_log`
--

CREATE TABLE IF NOT EXISTS `article_event_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_logged` datetime NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `log_level` varchar(1) DEFAULT NULL,
  `event_type` bigint(20) DEFAULT NULL,
  `assoc_type` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `message` text,
  PRIMARY KEY (`log_id`),
  KEY `article_event_log_article_id` (`article_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `article_event_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_files`
--

CREATE TABLE IF NOT EXISTS `article_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `revision` bigint(20) NOT NULL,
  `source_file_id` bigint(20) DEFAULT NULL,
  `source_revision` bigint(20) DEFAULT NULL,
  `article_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) DEFAULT NULL,
  `type` varchar(40) NOT NULL,
  `viewable` tinyint(4) DEFAULT NULL,
  `date_uploaded` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `round` tinyint(4) NOT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`file_id`,`revision`),
  KEY `article_files_article_id` (`article_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `article_files`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_galleys`
--

CREATE TABLE IF NOT EXISTS `article_galleys` (
  `galley_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `public_galley_id` varchar(255) DEFAULT NULL,
  `locale` varchar(5) DEFAULT NULL,
  `article_id` bigint(20) NOT NULL,
  `file_id` bigint(20) NOT NULL,
  `label` varchar(32) DEFAULT NULL,
  `html_galley` tinyint(4) NOT NULL DEFAULT '0',
  `style_file_id` bigint(20) DEFAULT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `views` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`galley_id`),
  UNIQUE KEY `article_galleys_public_id` (`public_galley_id`,`article_id`),
  KEY `article_galleys_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `article_galleys`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_html_galley_images`
--

CREATE TABLE IF NOT EXISTS `article_html_galley_images` (
  `galley_id` bigint(20) NOT NULL,
  `file_id` bigint(20) NOT NULL,
  UNIQUE KEY `article_html_galley_images_pkey` (`galley_id`,`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `article_html_galley_images`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_notes`
--

CREATE TABLE IF NOT EXISTS `article_notes` (
  `note_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `note` text,
  `file_id` bigint(20) NOT NULL,
  PRIMARY KEY (`note_id`),
  KEY `article_notes_article_id` (`article_id`),
  KEY `article_notes_user_id` (`user_id`),
  KEY `article_notes_file_id` (`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `article_notes`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_search_keyword_list`
--

CREATE TABLE IF NOT EXISTS `article_search_keyword_list` (
  `keyword_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `keyword_text` varchar(60) NOT NULL,
  PRIMARY KEY (`keyword_id`),
  UNIQUE KEY `article_search_keyword_text` (`keyword_text`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=36 ;

--
-- Dumping data for table `article_search_keyword_list`
--

INSERT INTO `article_search_keyword_list` (`keyword_id`, `keyword_text`) VALUES
(1, 'abbey'),
(2, 'gail'),
(3, 'westminster'),
(4, 'simon'),
(5, 'fraser'),
(6, 'university'),
(7, 'official'),
(8, 'duchess'),
(9, 'cambridge'),
(10, 'countess'),
(11, 'yorkshire'),
(12, 'years'),
(13, 'marie'),
(14, 'charmagne'),
(15, 'mooyi'),
(16, 'raj'),
(17, 'salle'),
(18, 'araneta'),
(19, 'language'),
(20, 'teacher'),
(21, 'korean'),
(22, 'students'),
(23, 'year'),
(24, 'girlffriend'),
(25, 'gumiho'),
(26, 'tuwing'),
(27, 'hapon'),
(28, 'supp1'),
(29, 'koreanovela'),
(30, 'background'),
(31, 'michael'),
(32, 'sample'),
(33, 'survey'),
(34, 'description'),
(35, 'source');

-- --------------------------------------------------------

--
-- Table structure for table `article_search_objects`
--

CREATE TABLE IF NOT EXISTS `article_search_objects` (
  `object_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`object_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `article_search_objects`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_search_object_keywords`
--

CREATE TABLE IF NOT EXISTS `article_search_object_keywords` (
  `object_id` bigint(20) NOT NULL,
  `keyword_id` bigint(20) NOT NULL,
  `pos` int(11) NOT NULL,
  UNIQUE KEY `article_search_object_keywords_pkey` (`object_id`,`pos`),
  KEY `article_search_object_keywords_keyword_id` (`keyword_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `article_search_object_keywords`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_settings`
--

CREATE TABLE IF NOT EXISTS `article_settings` (
  `article_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `article_settings_pkey` (`article_id`,`locale`,`setting_name`),
  KEY `article_settings_article_id` (`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `article_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_supplementary_files`
--

CREATE TABLE IF NOT EXISTS `article_supplementary_files` (
  `supp_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `language` varchar(10) DEFAULT NULL,
  `public_supp_file_id` varchar(255) DEFAULT NULL,
  `date_created` date DEFAULT NULL,
  `show_reviewers` tinyint(4) DEFAULT '0',
  `date_submitted` datetime NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`supp_id`),
  KEY `article_supplementary_files_file_id` (`file_id`),
  KEY `article_supplementary_files_article_id` (`article_id`),
  KEY `supp_public_supp_file_id` (`public_supp_file_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `article_supplementary_files`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_supp_file_settings`
--

CREATE TABLE IF NOT EXISTS `article_supp_file_settings` (
  `supp_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `article_supp_file_settings_pkey` (`supp_id`,`locale`,`setting_name`),
  KEY `article_supp_file_settings_supp_id` (`supp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `article_supp_file_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `article_xml_galleys`
--

CREATE TABLE IF NOT EXISTS `article_xml_galleys` (
  `xml_galley_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `galley_id` bigint(20) NOT NULL,
  `article_id` bigint(20) NOT NULL,
  `label` varchar(32) NOT NULL,
  `galley_type` varchar(255) NOT NULL,
  `views` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`xml_galley_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `article_xml_galleys`
--


-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE IF NOT EXISTS `authors` (
  `author_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `primary_contact` tinyint(4) NOT NULL DEFAULT '0',
  `seq` double NOT NULL DEFAULT '0',
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(90) NOT NULL,
  `country` varchar(90) DEFAULT NULL,
  `email` varchar(90) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `user_group_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`author_id`),
  KEY `authors_submission_id` (`submission_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `authors`
--


-- --------------------------------------------------------

--
-- Table structure for table `author_settings`
--

CREATE TABLE IF NOT EXISTS `author_settings` (
  `author_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `author_settings_pkey` (`author_id`,`locale`,`setting_name`),
  KEY `author_settings_author_id` (`author_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `author_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `auth_sources`
--

CREATE TABLE IF NOT EXISTS `auth_sources` (
  `auth_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(60) NOT NULL,
  `plugin` varchar(32) NOT NULL,
  `auth_default` tinyint(4) NOT NULL DEFAULT '0',
  `settings` text,
  PRIMARY KEY (`auth_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `auth_sources`
--


-- --------------------------------------------------------

--
-- Table structure for table `books_for_review`
--

CREATE TABLE IF NOT EXISTS `books_for_review` (
  `book_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `author_type` smallint(6) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `year` smallint(6) NOT NULL,
  `language` varchar(10) NOT NULL DEFAULT 'en',
  `copy` tinyint(4) NOT NULL DEFAULT '0',
  `url` varchar(255) DEFAULT NULL,
  `edition` tinyint(4) DEFAULT NULL,
  `pages` smallint(6) DEFAULT NULL,
  `isbn` varchar(30) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_requested` datetime DEFAULT NULL,
  `date_assigned` datetime DEFAULT NULL,
  `date_mailed` datetime DEFAULT NULL,
  `date_due` datetime DEFAULT NULL,
  `date_submitted` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `editor_id` bigint(20) DEFAULT NULL,
  `article_id` bigint(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`book_id`),
  KEY `bfr_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `books_for_review`
--


-- --------------------------------------------------------

--
-- Table structure for table `books_for_review_authors`
--

CREATE TABLE IF NOT EXISTS `books_for_review_authors` (
  `author_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `book_id` bigint(20) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(90) NOT NULL,
  PRIMARY KEY (`author_id`),
  KEY `bfr_book_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `books_for_review_authors`
--


-- --------------------------------------------------------

--
-- Table structure for table `books_for_review_settings`
--

CREATE TABLE IF NOT EXISTS `books_for_review_settings` (
  `book_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `bfr_settings_pkey` (`book_id`,`locale`,`setting_name`),
  KEY `bfr_settings_book_id` (`book_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `books_for_review_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `captchas`
--

CREATE TABLE IF NOT EXISTS `captchas` (
  `captcha_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(40) NOT NULL,
  `value` varchar(20) NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`captcha_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `captchas`
--


-- --------------------------------------------------------

--
-- Table structure for table `citations`
--

CREATE TABLE IF NOT EXISTS `citations` (
  `citation_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `citation_state` bigint(20) NOT NULL,
  `raw_citation` text,
  `seq` bigint(20) NOT NULL DEFAULT '0',
  `lock_id` varchar(23) DEFAULT NULL,
  PRIMARY KEY (`citation_id`),
  UNIQUE KEY `citations_assoc_seq` (`assoc_type`,`assoc_id`,`seq`),
  KEY `citations_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `citations`
--


-- --------------------------------------------------------

--
-- Table structure for table `citation_settings`
--

CREATE TABLE IF NOT EXISTS `citation_settings` (
  `citation_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `citation_settings_pkey` (`citation_id`,`locale`,`setting_name`),
  KEY `citation_settings_citation_id` (`citation_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `citation_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `parent_comment_id` bigint(20) DEFAULT NULL,
  `num_children` int(11) NOT NULL DEFAULT '0',
  `user_id` bigint(20) DEFAULT NULL,
  `poster_ip` varchar(15) NOT NULL,
  `poster_name` varchar(90) DEFAULT NULL,
  `poster_email` varchar(90) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `body` text,
  `date_posted` datetime DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `comments_submission_id` (`submission_id`),
  KEY `comments_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `completed_payments`
--

CREATE TABLE IF NOT EXISTS `completed_payments` (
  `completed_payment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `payment_type` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `amount` double NOT NULL,
  `currency_code_alpha` varchar(3) DEFAULT NULL,
  `payment_method_plugin_name` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`completed_payment_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `completed_payments`
--


-- --------------------------------------------------------

--
-- Table structure for table `controlled_vocabs`
--

CREATE TABLE IF NOT EXISTS `controlled_vocabs` (
  `controlled_vocab_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `symbolic` varchar(64) NOT NULL,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`controlled_vocab_id`),
  UNIQUE KEY `controlled_vocab_symbolic` (`symbolic`,`assoc_type`,`assoc_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `controlled_vocabs`
--

INSERT INTO `controlled_vocabs` (`controlled_vocab_id`, `symbolic`, `assoc_type`, `assoc_id`) VALUES
(1, 'interest', 4096, 2),
(2, 'interest', 4096, 3),
(3, 'interest', 4096, 4);

-- --------------------------------------------------------

--
-- Table structure for table `controlled_vocab_entries`
--

CREATE TABLE IF NOT EXISTS `controlled_vocab_entries` (
  `controlled_vocab_entry_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `controlled_vocab_id` bigint(20) NOT NULL,
  `seq` double DEFAULT NULL,
  PRIMARY KEY (`controlled_vocab_entry_id`),
  KEY `controlled_vocab_entries_cv_id` (`controlled_vocab_id`,`seq`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `controlled_vocab_entries`
--

INSERT INTO `controlled_vocab_entries` (`controlled_vocab_entry_id`, `controlled_vocab_id`, `seq`) VALUES
(1, 1, 0),
(2, 1, 0),
(3, 3, 0),
(4, 3, 0),
(5, 3, 0);

-- --------------------------------------------------------

--
-- Table structure for table `controlled_vocab_entry_settings`
--

CREATE TABLE IF NOT EXISTS `controlled_vocab_entry_settings` (
  `controlled_vocab_entry_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `c_v_e_s_pkey` (`controlled_vocab_entry_id`,`locale`,`setting_name`),
  KEY `c_v_e_s_entry_id` (`controlled_vocab_entry_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `controlled_vocab_entry_settings`
--

INSERT INTO `controlled_vocab_entry_settings` (`controlled_vocab_entry_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(1, '', 'interest', 'time-space continuum', 'string'),
(2, '', 'interest', 'theory of relativity', 'string'),
(3, '', 'interest', 'time-space', 'string'),
(4, '', 'interest', 'deja vu', 'string'),
(5, '', 'interest', 'summer vacation', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `counter_monthly_log`
--

CREATE TABLE IF NOT EXISTS `counter_monthly_log` (
  `year` bigint(20) NOT NULL,
  `month` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `count_html` bigint(20) NOT NULL DEFAULT '0',
  `count_pdf` bigint(20) NOT NULL DEFAULT '0',
  `count_other` bigint(20) NOT NULL DEFAULT '0',
  UNIQUE KEY `counter_monthly_log_key` (`year`,`month`,`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `counter_monthly_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `custom_issue_orders`
--

CREATE TABLE IF NOT EXISTS `custom_issue_orders` (
  `issue_id` bigint(20) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  UNIQUE KEY `custom_issue_orders_pkey` (`issue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `custom_issue_orders`
--


-- --------------------------------------------------------

--
-- Table structure for table `custom_section_orders`
--

CREATE TABLE IF NOT EXISTS `custom_section_orders` (
  `issue_id` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  UNIQUE KEY `custom_section_orders_pkey` (`issue_id`,`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `custom_section_orders`
--


-- --------------------------------------------------------

--
-- Table structure for table `edit_assignments`
--

CREATE TABLE IF NOT EXISTS `edit_assignments` (
  `edit_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `editor_id` bigint(20) NOT NULL,
  `can_edit` tinyint(4) NOT NULL DEFAULT '1',
  `can_review` tinyint(4) NOT NULL DEFAULT '1',
  `date_assigned` datetime DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `date_underway` datetime DEFAULT NULL,
  PRIMARY KEY (`edit_id`),
  KEY `edit_assignments_article_id` (`article_id`),
  KEY `edit_assignments_editor_id` (`editor_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `edit_assignments`
--


-- --------------------------------------------------------

--
-- Table structure for table `edit_decisions`
--

CREATE TABLE IF NOT EXISTS `edit_decisions` (
  `edit_decision_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `round` tinyint(4) NOT NULL,
  `editor_id` bigint(20) NOT NULL,
  `decision` tinyint(4) NOT NULL,
  `date_decided` datetime NOT NULL,
  PRIMARY KEY (`edit_decision_id`),
  KEY `edit_decisions_article_id` (`article_id`),
  KEY `edit_decisions_editor_id` (`editor_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `edit_decisions`
--


-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE IF NOT EXISTS `email_templates` (
  `email_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_key` varchar(30) NOT NULL,
  `assoc_type` bigint(20) DEFAULT '0',
  `assoc_id` bigint(20) DEFAULT '0',
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`email_id`),
  UNIQUE KEY `email_templates_email_key` (`email_key`,`assoc_type`,`assoc_id`),
  KEY `email_templates_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `email_templates`
--


-- --------------------------------------------------------

--
-- Table structure for table `email_templates_data`
--

CREATE TABLE IF NOT EXISTS `email_templates_data` (
  `email_key` varchar(30) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT 'en_US',
  `assoc_type` bigint(20) DEFAULT '0',
  `assoc_id` bigint(20) DEFAULT '0',
  `subject` varchar(120) NOT NULL,
  `body` text,
  UNIQUE KEY `email_templates_data_pkey` (`email_key`,`locale`,`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `email_templates_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `email_templates_default`
--

CREATE TABLE IF NOT EXISTS `email_templates_default` (
  `email_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email_key` varchar(30) NOT NULL,
  `can_disable` tinyint(4) NOT NULL DEFAULT '1',
  `can_edit` tinyint(4) NOT NULL DEFAULT '1',
  `from_role_id` bigint(20) DEFAULT NULL,
  `to_role_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`email_id`),
  KEY `email_templates_default_email_key` (`email_key`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=77 ;

--
-- Dumping data for table `email_templates_default`
--

INSERT INTO `email_templates_default` (`email_id`, `email_key`, `can_disable`, `can_edit`, `from_role_id`, `to_role_id`) VALUES
(1, 'NOTIFICATION', 0, 1, NULL, NULL),
(2, 'NOTIFICATION_MAILLIST', 0, 1, NULL, NULL),
(3, 'NOTIFICATION_MAILLIST_WELCOME', 0, 1, NULL, NULL),
(4, 'NOTIFICATION_MAILLIST_PASSWORD', 0, 1, NULL, NULL),
(5, 'PASSWORD_RESET_CONFIRM', 0, 1, NULL, NULL),
(6, 'PASSWORD_RESET', 0, 1, NULL, NULL),
(7, 'USER_REGISTER', 0, 1, NULL, NULL),
(8, 'USER_VALIDATE', 0, 1, NULL, NULL),
(9, 'REVIEWER_REGISTER', 0, 1, NULL, NULL),
(10, 'PUBLISH_NOTIFY', 0, 1, NULL, NULL),
(11, 'LOCKSS_EXISTING_ARCHIVE', 0, 1, NULL, NULL),
(12, 'LOCKSS_NEW_ARCHIVE', 0, 1, NULL, NULL),
(13, 'SUBMISSION_ACK', 1, 1, NULL, 65536),
(14, 'SUBMISSION_UNSUITABLE', 1, 1, 512, 65536),
(15, 'SUBMISSION_COMMENT', 0, 1, NULL, NULL),
(16, 'SUBMISSION_DECISION_REVIEWERS', 0, 1, 512, 4096),
(17, 'EDITOR_ASSIGN', 1, 1, 256, 512),
(18, 'REVIEW_CANCEL', 1, 1, 512, 4096),
(19, 'REVIEW_REQUEST', 1, 1, 512, 4096),
(20, 'REVIEW_REQUEST_ONECLICK', 1, 1, 512, 4096),
(21, 'REVIEW_REQUEST_ATTACHED', 0, 1, 512, 4096),
(22, 'REVIEW_CONFIRM', 1, 1, 4096, 512),
(23, 'REVIEW_DECLINE', 1, 1, 4096, 512),
(24, 'REVIEW_COMPLETE', 1, 1, 4096, 512),
(25, 'REVIEW_ACK', 1, 1, 512, 4096),
(26, 'REVIEW_REMIND', 0, 1, 512, 4096),
(27, 'REVIEW_REMIND_AUTO', 0, 1, NULL, 4096),
(28, 'REVIEW_REMIND_ONECLICK', 0, 1, 512, 4096),
(29, 'REVIEW_REMIND_AUTO_ONECLICK', 0, 1, NULL, 4096),
(30, 'EDITOR_DECISION_ACCEPT', 0, 1, 512, 65536),
(31, 'EDITOR_DECISION_REVISIONS', 0, 1, 512, 65536),
(32, 'EDITOR_DECISION_RESUBMIT', 0, 1, 512, 65536),
(33, 'EDITOR_DECISION_DECLINE', 0, 1, 512, 65536),
(34, 'COPYEDIT_REQUEST', 1, 1, 512, 8192),
(35, 'COPYEDIT_COMPLETE', 1, 1, 8192, 65536),
(36, 'COPYEDIT_ACK', 1, 1, 512, 8192),
(37, 'COPYEDIT_AUTHOR_REQUEST', 1, 1, 512, 65536),
(38, 'COPYEDIT_AUTHOR_COMPLETE', 1, 1, 65536, 512),
(39, 'COPYEDIT_AUTHOR_ACK', 1, 1, 512, 65536),
(40, 'COPYEDIT_FINAL_REQUEST', 1, 1, 512, 8192),
(41, 'COPYEDIT_FINAL_COMPLETE', 1, 1, 8192, 512),
(42, 'COPYEDIT_FINAL_ACK', 1, 1, 512, 8192),
(43, 'LAYOUT_REQUEST', 1, 1, 512, 768),
(44, 'LAYOUT_COMPLETE', 1, 1, 768, 512),
(45, 'LAYOUT_ACK', 1, 1, 512, 768),
(46, 'PROOFREAD_AUTHOR_REQUEST', 1, 1, 512, 65536),
(47, 'PROOFREAD_AUTHOR_COMPLETE', 1, 1, 65536, 512),
(48, 'PROOFREAD_AUTHOR_ACK', 1, 1, 512, 65536),
(49, 'PROOFREAD_REQUEST', 1, 1, 512, 12288),
(50, 'PROOFREAD_COMPLETE', 1, 1, 12288, 512),
(51, 'PROOFREAD_ACK', 1, 1, 512, 12288),
(52, 'PROOFREAD_LAYOUT_REQUEST', 1, 1, 512, 768),
(53, 'PROOFREAD_LAYOUT_COMPLETE', 1, 1, 768, 512),
(54, 'PROOFREAD_LAYOUT_ACK', 1, 1, 512, 768),
(55, 'EMAIL_LINK', 0, 1, 1048576, NULL),
(56, 'SUBSCRIPTION_NOTIFY', 0, 1, NULL, 1048576),
(57, 'OPEN_ACCESS_NOTIFY', 0, 1, NULL, 1048576),
(58, 'SUBSCRIPTION_BEFORE_EXPIRY', 0, 1, NULL, 1048576),
(59, 'SUBSCRIPTION_AFTER_EXPIRY', 0, 1, NULL, 1048576),
(60, 'SUBSCRIPTION_AFTER_EXPIRY_LAST', 0, 1, NULL, 1048576),
(61, 'SUBSCRIPTION_PURCHASE_INDL', 0, 1, NULL, 2097152),
(62, 'SUBSCRIPTION_PURCHASE_INSTL', 0, 1, NULL, 2097152),
(63, 'SUBSCRIPTION_RENEW_INDL', 0, 1, NULL, 2097152),
(64, 'SUBSCRIPTION_RENEW_INSTL', 0, 1, NULL, 2097152),
(65, 'CITATION_EDITOR_AUTHOR_QUERY', 0, 1, NULL, NULL),
(66, 'BFR_REVIEW_REMINDER', 0, 1, 256, 65536),
(67, 'BFR_REVIEW_REMINDER_LATE', 0, 1, 256, 65536),
(68, 'BFR_BOOK_ASSIGNED', 0, 1, 256, 65536),
(69, 'BFR_BOOK_DENIED', 0, 1, 256, 65536),
(70, 'BFR_BOOK_REQUESTED', 0, 1, 65536, 256),
(71, 'BFR_BOOK_MAILED', 0, 1, 256, 65536),
(72, 'BFR_REVIEWER_REMOVED', 0, 1, 256, 65536),
(73, 'SWORD_DEPOSIT_NOTIFICATION', 0, 1, NULL, NULL),
(74, 'THESIS_ABSTRACT_CONFIRM', 0, 1, NULL, NULL),
(75, 'MANUAL_PAYMENT_NOTIFICATION', 0, 1, NULL, NULL),
(76, 'PAYPAL_INVESTIGATE_PAYMENT', 0, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `email_templates_default_data`
--

CREATE TABLE IF NOT EXISTS `email_templates_default_data` (
  `email_key` varchar(30) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT 'en_US',
  `subject` varchar(120) NOT NULL,
  `body` text,
  `description` text,
  UNIQUE KEY `email_templates_default_data_pkey` (`email_key`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `email_templates_default_data`
--

INSERT INTO `email_templates_default_data` (`email_key`, `locale`, `subject`, `body`, `description`) VALUES
('NOTIFICATION', 'en_US', 'New notification from {$siteTitle}', 'You have a new notification from {$siteTitle}:\n\n{$notificationContents}\n\nLink: {$url}\n\n{$principalContactSignature}', 'The email is sent to registered users that have selected to have this type of notification emailed to them.'),
('NOTIFICATION_MAILLIST', 'en_US', 'New notification from {$siteTitle}', 'You have a new notification from {$siteTitle}:\n--\n{$notificationContents}\n\nLink: {$url}\n--\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\n{$principalContactSignature}', 'This email is sent to unregistered users on the notification mailing list.'),
('NOTIFICATION_MAILLIST_WELCOME', 'en_US', 'Welcome to the the {$siteTitle} mailing list!', 'You have signed up to receive notifications from {$siteTitle}.\n			\nPlease click on this link to confirm your request and add your email address to the mailing list: {$confirmLink}\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\nYour password for disabling notification emails is: {$password}\n\n{$principalContactSignature}', 'This email is sent to an unregistered user who just registered with the notification mailing list.'),
('NOTIFICATION_MAILLIST_PASSWORD', 'en_US', 'Your notification mailing list information for {$siteTitle}', 'Your new password for disabling notification emails is: {$password}\n\nIf you wish to stop receiving notification emails, please go to {$unsubscribeLink} and enter your email address and password.\n\n{$principalContactSignature}', 'This email is sent to an unregistered user on the notification mailing list when they indicate that they have forgotten their password or are unable to login. It provides a URL they can follow to reset their password.'),
('PASSWORD_RESET_CONFIRM', 'en_US', 'Password Reset Confirmation', 'We have received a request to reset your password for the {$siteTitle} web site.\n\nIf you did not make this request, please ignore this email and your password will not be changed. If you wish to reset your password, click on the below URL.\n\nReset my password: {$url}\n\n{$principalContactSignature}', 'This email is sent to a registered user when they indicate that they have forgotten their password or are unable to login. It provides a URL they can follow to reset their password.'),
('PASSWORD_RESET', 'en_US', 'Password Reset', 'Your password has been successfully reset for use with the {$siteTitle} web site. Please retain this username and password, as it is necessary for all work with the journal.\n\nYour username: {$username}\nYour new password: {$password}\n\n{$principalContactSignature}', 'This email is sent to a registered user when they have successfully reset their password following the process described in the PASSWORD_RESET_CONFIRM email.'),
('USER_REGISTER', 'en_US', 'Journal Registration', '{$userFullName}\n\nYou have now been registered as a user with {$journalName}. We have included your username and password in this email, which are needed for all work with this journal through its website. At any point, you can ask to be removed from the journal''s list of users by contacting me.\n\nUsername: {$username}\nPassword: {$password}\n\nThank you,\n{$principalContactSignature}', 'This email is sent to a newly registered user to welcome them to the system and provide them with a record of their username and password.'),
('USER_VALIDATE', 'en_US', 'Validate Your Account', '{$userFullName}\n\nYou have created an account with {$journalName}, but before you can start using it, you need to validate your email account. To do this, simply follow the link below:\n\n{$activateUrl}\n\nThank you,\n{$principalContactSignature}', 'This email is sent to a newly registered user to welcome them to the system and provide them with a record of their username and password.'),
('REVIEWER_REGISTER', 'en_US', 'Registration as Reviewer with {$journalName}', 'In light of your expertise, we have taken the liberty of registering your name in the reviewer database for {$journalName}. This does not entail any form of commitment on your part, but simply enables us to approach you with a submission to possibly review. On being invited to review, you will have an opportunity to see the title and abstract of the paper in question, and you''ll always be in a position to accept or decline the invitation. You can also ask at any point to have your name removed from this reviewer list.\n\nWe are providing you with a username and password, which is used in all interactions with the journal through its website. You may wish, for example, to update your profile, including your reviewing interests.\n\nUsername: {$username}\nPassword: {$password}\n\nThank you,\n{$principalContactSignature}', 'This email is sent to a newly registered reviewer to welcome them to the system and provide them with a record of their username and password.'),
('PUBLISH_NOTIFY', 'en_US', 'New Issue Published', 'Readers:\n\n{$journalName} has just published its latest issue at {$journalUrl}. We invite you to review the Table of Contents here and then visit our web site to review articles and items of interest.\n\nThanks for the continuing interest in our work,\n{$editorialContactSignature}', 'This email is sent to registered readers via the "Notify Users" link in the Editor''s User Home. It notifies readers of a new issue and invites them to visit the journal at a supplied URL.'),
('LOCKSS_EXISTING_ARCHIVE', 'en_US', 'Archiving Request for {$journalName}', 'Dear [University Librarian]\n\n{$journalName} <{$journalUrl}>, is a journal for which a member of your faculty, [name of member], serves as a [title of position]. The journal is seeking to establish a LOCKSS (Lots of Copies Keep Stuff Safe) compliant archive with this and other university libraries.\n\n[Brief description of journal]\n\nThe URL to the LOCKSS Publisher Manifest for our journal is: {$journalUrl}/gateway/lockss\n\nWe understand that you are already participating in LOCKSS. If we can provide any additional metadata for purposes of registering our journal with your version of LOCKSS, we would be happy to provide it.\n\nThank you,\n{$principalContactSignature}', 'This email requests the keeper of a LOCKSS archive to consider including this journal in their archive. It provides the URL to the journal''s LOCKSS Publisher Manifest.'),
('LOCKSS_NEW_ARCHIVE', 'en_US', 'Archiving Request for {$journalName}', 'Dear [University Librarian]\n\n{$journalName} <{$journalUrl}>, is a journal for which a member of your faculty, [name of member] serves as a [title of position]. The journal is seeking to establish a LOCKSS (Lots of Copies Keep Stuff Safe) compliant archive with this and other university libraries.\n\n[Brief description of journal]\n\nThe LOCKSS Program <http://lockss.org/>, an international library/publisher initiative, is a working example of a distributed preservation and archiving repository, additional details are below. The software, which runs on an ordinary personal computer is free; the system is easily brought on-line; very little ongoing maintenance is required.\n\nTo assist in the archiving of our journal, we invite you to become a member of the LOCKSS community, to help collect and preserve titles produced by your faculty and by other scholars worldwide. To do so, please have someone on your staff visit the LOCKSS site for information on how this system operates. I look forward to hearing from you on the feasibility of providing this archiving support for this journal.\n\nThank you,\n{$principalContactSignature}', 'This email encourages the recipient to participate in the LOCKSS initiative and include this journal in the archive. It provides information about the LOCKSS initiative and ways to become involved.'),
('SUBMISSION_ACK', 'en_US', 'Submission Acknowledgement', '{$authorName}:\n\nThank you for submitting the manuscript, "{$articleTitle}" to {$journalName}. With the online journal management system that we are using, you will be able to track its progress through the editorial process by logging in to the journal web site:\n\nManuscript URL: {$submissionUrl}\nUsername: {$authorUsername}\n\nIf you have any questions, please contact me. Thank you for considering this journal as a venue for your work.\n\n{$editorialContactSignature}', 'This email, when enabled, is automatically sent to an author when he or she completes the process of submitting a manuscript to the journal. It provides information about tracking the submission through the process and thanks the author for the submission.'),
('SUBMISSION_UNSUITABLE', 'en_US', 'Unsuitable Submission', '{$authorName}:\n\nAn initial review of "{$articleTitle}" has made it clear that this submission does not fit within the scope and focus of {$journalName}. I recommend that you consult the description of this journal under About, as well as its current contents, to learn more about the work that we publish. You might also consider submitting this manuscript to another, more suitable journal.\n\n{$editorialContactSignature}', ''),
('SUBMISSION_COMMENT', 'en_US', 'Submission Comment', '{$name}:\n\n{$commentName} has added a comment to the submission, "{$articleTitle}" in {$journalName}:\n\n{$comments}', 'This email notifies the various people involved in a submission''s editing process that a new comment has been posted.'),
('SUBMISSION_DECISION_REVIEWERS', 'en_US', 'Decision on "{$articleTitle}"', 'As one of the reviewers for the submission, "{$articleTitle}," to {$journalName}, I am sending you the reviews and editorial decision sent to the author of this piece. Thank you again for your important contribution to this process.\n \n{$editorialContactSignature}\n\n{$comments}', 'This email notifies the reviewers of a submission that the review process has been completed. It includes information about the article and the decision reached, and thanks the reviewers for their contributions.'),
('EDITOR_ASSIGN', 'en_US', 'Editorial Assignment', '{$editorialContactName}:\n\nThe submission, "{$articleTitle}," to {$journalName} has been assigned to you to see through the editorial process in your role as Section Editor.  \n\nSubmission URL: {$submissionUrl}\nUsername: {$editorUsername}\n\nThank you,\n{$editorialContactSignature}', 'This email notifies a Section Editor that the Editor has assigned them the task of overseeing a submission through the editing process. It provides information about the submission and how to access the journal site.'),
('REVIEW_REQUEST', 'en_US', 'Article Review Request', '{$reviewerName}:\n\nI believe that you would serve as an excellent reviewer of the manuscript, "{$articleTitle}," which has been submitted to {$journalName}. The submission''s abstract is inserted below, and I hope that you will consider undertaking this important task for us.\n\nPlease log into the journal web site by {$weekLaterDate} to indicate whether you will undertake the review or not, as well as to access the submission and to record your review and recommendation. The web site is {$journalUrl}\n\nThe review itself is due {$reviewDueDate}.\n\nIf you do not have your username and password for the journal''s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\n\n"{$articleTitle}"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}', 'This email from the Section Editor to a Reviewer requests that the reviewer accept or decline the task of reviewing a submission. It provides information about the submission such as the title and abstract, a review due date, and how to access the submission itself. This message is used when the Standard Review Process is selected in Journal Setup, Step 2. (Otherwise see REVIEW_REQUEST_ATTACHED.)'),
('REVIEW_REQUEST_ONECLICK', 'en_US', 'Article Review Request', '{$reviewerName}:\n\nI believe that you would serve as an excellent reviewer of the manuscript, "{$articleTitle}," which has been submitted to {$journalName}. The submission''s abstract is inserted below, and I hope that you will consider undertaking this important task for us.\n\nPlease log into the journal web site by {$weekLaterDate} to indicate whether you will undertake the review or not, as well as to access the submission and to record your review and recommendation.\n\nThe review itself is due {$reviewDueDate}.\n\nSubmission URL: {$submissionReviewUrl}\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\n\n"{$articleTitle}"\n\n{$abstractTermIfEnabled}\n{$articleAbstract}', 'This email from the Section Editor to a Reviewer requests that the reviewer accept or decline the task of reviewing a submission. It provides information about the submission such as the title and abstract, a review due date, and how to access the submission itself. This message is used when the Standard Review Process is selected in Journal Setup, Step 2, and one-click reviewer access is enabled.'),
('REVIEW_REQUEST_ATTACHED', 'en_US', 'Article Review Request', '{$reviewerName}:\n\nI believe that you would serve as an excellent reviewer of the manuscript, "{$articleTitle}," and I am asking that you consider undertaking this important task for us. The Review Guidelines for this journal are appended below, and the submission is attached to this email. Your review of the submission, along with your recommendation, should be emailed to me by {$reviewDueDate}.\n\nPlease indicate in a return email by {$weekLaterDate} whether you are able and willing to do the review.\n\nThank you for considering this request.\n\n{$editorialContactSignature}\n\n\nReview Guidelines\n\n{$reviewGuidelines}\n', 'This email is sent by the Section Editor to a Reviewer to request that they accept or decline the task of reviewing a submission. It includes the submission as an attachment. This message is used when the Email-Attachment Review Process is selected in Journal Setup, Step 2. (Otherwise see REVIEW_REQUEST.)'),
('REVIEW_CANCEL', 'en_US', 'Request for Review Cancelled', '{$reviewerName}:\n\nWe have decided at this point to cancel our request for you to review the submission, "{$articleTitle}," for {$journalName}. We apologize for any inconvenience this may cause you and hope that we will be able to call on you to assist with this journal''s review process in the future.\n\nIf you have any questions, please contact me.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a Reviewer who has a submission review in progress to notify them that the review has been cancelled.'),
('REVIEW_CONFIRM', 'en_US', 'Able to Review', '{$editorialContactName}:\n\nI am able and willing to review the submission, "{$articleTitle}," for {$journalName}. Thank you for thinking of me, and I plan to have the review completed by its due date, {$reviewDueDate}, if not before.\n\n{$reviewerName}', 'This email is sent by a Reviewer to the Section Editor in response to a review request to notify the Section Editor that the review request has been accepted and will be completed by the specified date.'),
('REVIEW_DECLINE', 'en_US', 'Unable to Review', '{$editorialContactName}:\n\nI am afraid that at this time I am unable to review the submission, "{$articleTitle}," for {$journalName}. Thank you for thinking of me, and another time feel free to call on me.\n\n{$reviewerName}', 'This email is sent by a Reviewer to the Section Editor in response to a review request to notify the Section Editor that the review request has been declined.'),
('REVIEW_COMPLETE', 'en_US', 'Article Review Completed', '{$editorialContactName}:\n\nI have now completed my review of "{$articleTitle}" for {$journalName}, and submitted my recommendation, "{$recommendation}."\n\n{$reviewerName}', 'This email is sent by a Reviewer to the Section Editor to notify them that a review has been completed and the comments and recommendations have been recorded on the journal web site.'),
('REVIEW_ACK', 'en_US', 'Article Review Acknowledgement', '{$reviewerName}:\n\nThank you for completing the review of the submission, "{$articleTitle}," for {$journalName}. We appreciate your contribution to the quality of the work that we publish.\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to confirm receipt of a completed review and thank the reviewer for their contributions.'),
('REVIEW_REMIND', 'en_US', 'Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\n\nIf you do not have your username and password for the journal''s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to remind a reviewer that their review is due.'),
('REVIEW_REMIND_ONECLICK', 'en_US', 'Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and would be pleased to receive it as soon as you are able to prepare it.\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to remind a reviewer that their review is due.'),
('REVIEW_REMIND_AUTO', 'en_US', 'Automated Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and this email has been automatically generated and sent with the passing of that date. We would still be pleased to receive it as soon as you are able to prepare it.\n\nIf you do not have your username and password for the journal''s web site, you can use this link to reset your password (which will then be emailed to you along with your username). {$passwordResetUrl}\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is automatically sent when a reviewer''s due date elapses (see Review Options under Journal Setup, Step 2) and one-click reviewer access is disabled. Scheduled tasks must be enabled and configured (see the site configuration file).'),
('REVIEW_REMIND_AUTO_ONECLICK', 'en_US', 'Automated Submission Review Reminder', '{$reviewerName}:\n\nJust a gentle reminder of our request for your review of the submission, "{$articleTitle}," for {$journalName}. We were hoping to have this review by {$reviewDueDate}, and this email has been automatically generated and sent with the passing of that date. We would still be pleased to receive it as soon as you are able to prepare it.\n\nSubmission URL: {$submissionReviewUrl}\n\nPlease confirm your ability to complete this vital contribution to the work of the journal. I look forward to hearing from you.\n\n{$editorialContactSignature}', 'This email is automatically sent when a reviewer''s due date elapses (see Review Options under Journal Setup, Step 2) and one-click reviewer access is enabled. Scheduled tasks must be enabled and configured (see the site configuration file).'),
('EDITOR_DECISION_ACCEPT', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('EDITOR_DECISION_REVISIONS', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('EDITOR_DECISION_RESUBMIT', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('EDITOR_DECISION_DECLINE', 'en_US', 'Editor Decision', '{$authorName}:\n\nWe have reached a decision regarding your submission to {$journalTitle}, "{$articleTitle}".\n\nOur decision is to:\n\n{$editorialContactSignature}\n', 'This email from the Editor or Section Editor to an Author notifies them of a final decision regarding their submission.'),
('COPYEDIT_REQUEST', 'en_US', 'Copyediting Request', '{$copyeditorName}:\n\nI would ask that you undertake the copyediting of "{$articleTitle}" for {$journalName} by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 1.\n3. Consult Copyediting Instructions posted on webpage.\n4. Open the downloaded file and copyedit, while adding Author Queries as needed. \n5. Save copyedited file, and upload to Step 1 of Copyediting.\n6. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$copyeditorUsername}\n\n{$editorialContactSignature}', 'This email is sent by a Section Editor to a submission''s Copyeditor to request that they begin the copyediting process. It provides information about the submission and how to access it.'),
('COPYEDIT_COMPLETE', 'en_US', 'Copyediting Completed', '{$editorialContactName}:\n\nWe have now copyedited your submission "{$articleTitle}" for {$journalName}. To review the proposed changes and respond to Author Queries, please follow these steps:\n\n1. Log into the journal using URL below with your username and password (use Forgot link if needed).\n2. Click on the file at 1. Initial Copyedit File to download and open copyedited version. \n3. Review the copyediting, making changes using Track Changes in Word, and answer queries. \n4. Save file to desktop and upload it in 2. Author Copyedit.\n5. Click the email icon under COMPLETE and send email to the editor.\n\nThis is the last opportunity that you have to make substantial changes. You will be asked at a later stage to proofread the galleys, but at that point only minor typographical and layout errors can be corrected.\n\nManuscript URL: {$submissionEditingUrl}\nUsername: {$authorUsername}\n\nIf you are unable to undertake this work at this time or have any questions,\nplease contact me. Thank you for your contribution to this journal.\n\n{$copyeditorName}', ''),
('COPYEDIT_ACK', 'en_US', 'Copyediting Acknowledgement', '{$copyeditorName}:\n\nThank you for copyediting the manuscript, "{$articleTitle}," for {$journalName}. It will make an important contribution to the quality of this journal.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a submission''s Copyeditor to acknowledge that the Copyeditor has successfully completed the copyediting process and thank them for their contribution.'),
('COPYEDIT_AUTHOR_REQUEST', 'en_US', 'Copyediting Review Request', '{$authorName}:\n\nYour submission "{$articleTitle}" for {$journalName} has been through the first step of copyediting, and is available for you to review by following these steps.\n\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 1.\n3. Open the downloaded submission.\n4. Review the text, including copyediting proposals and Author Queries.\n5. Make any copyediting changes that would further improve the text.\n6. When completed, upload the file in Step 2.\n7. Click on METADATA to check indexing information for completeness and accuracy.\n8. Send the COMPLETE email to the editor and copyeditor.\n\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$authorUsername}\n\nThis is the last opportunity to make substantial copyediting changes to the submission. The proofreading stage, that follows the preparation of the galleys, is restricted to correcting typographical and layout errors.\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a submission''s Author to request that they proofread the work of the copyeditor. It provides access information for the manuscript and warns that this is the last opportunity the author has to make substantial changes.'),
('COPYEDIT_AUTHOR_COMPLETE', 'en_US', 'Copyediting Review Completed', '{$editorialContactName}:\n\nI have now reviewed the copyediting of the manuscript, "{$articleTitle}," for {$journalName}, and it is ready for the final round of copyediting and preparation for Layout.\n\nThank you for this contribution to my work,\n{$authorName}', 'This email is sent by the Author to the Section Editor to notify them that the Author''s copyediting process has been completed.'),
('COPYEDIT_AUTHOR_ACK', 'en_US', 'Copyediting Review Acknowledgement', '{$authorName}:\n\nThank you for reviewing the copyediting of your manuscript, "{$articleTitle}," for {$journalName}. We look forward to publishing this work.\n\n{$editorialContactSignature}', 'This email is sent by the Section Editor to a submission''s Author to confirm completion of the Author''s copyediting process and thank them for their contribution.'),
('COPYEDIT_FINAL_REQUEST', 'en_US', 'Copyediting Final Review', '{$copyeditorName}:\n\nThe author and editor have now completed their copyediting review of "{$articleTitle}" for {$journalName}. A "clean copy" now needs to be prepared for Layout by going through the following steps.\n1. Click on the Submission URL below.\n2. Log into the journal and click on the File that appears in Step 2.\n3. Open the downloaded file and incorporate all copyedits and query responses.\n4. Save clean file, and upload to Step 3 of Copyediting.\n5. Click on METADATA to check indexing information (saving any corrections).\n6. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionCopyeditingUrl}\nUsername: {$copyeditorUsername}\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Copyeditor requests that they perform a final round of copyediting on a submission before it enters the layout process.'),
('COPYEDIT_FINAL_COMPLETE', 'en_US', 'Copyediting Final Review Completed', '{$editorialContactName}:\n\nI have now prepared a clean, copyedited version of the manuscript, "{$articleTitle}," for {$journalName}. It is ready for Layout and the preparation of the galleys.\n\n{$copyeditorName}', 'This email from the Copyeditor to the Section Editor notifies them that the final round of copyediting has been completed and that the layout process may now begin.'),
('COPYEDIT_FINAL_ACK', 'en_US', 'Copyediting Final Review Acknowledgement', '{$copyeditorName}:\n\nThank you for completing the copyediting of the manuscript, "{$articleTitle}," for {$journalName}. This preparation of a "clean copy" for Layout is an important step in the editorial process.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Copyeditor acknowledges completion of the final round of copyediting and thanks them for their contribution.'),
('LAYOUT_REQUEST', 'en_US', 'Request Galleys', '{$layoutEditorName}:\n\nThe submission "{$articleTitle}" to {$journalName} now needs galleys laid out by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and use the Layout Version file to create the galleys according to the journal''s standards.\n3. Send the COMPLETE email to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubmission URL: {$submissionLayoutUrl}\nUsername: {$layoutEditorUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor notifies them that they have been assigned the task of performing layout editing on a submission. It provides information about the submission and how to access it.'),
('LAYOUT_COMPLETE', 'en_US', 'Galleys Complete', '{$editorialContactName}:\n\nGalleys have now been prepared for the manuscript, "{$articleTitle}," for {$journalName} and are ready for proofreading. \n\nIf you have any questions, please contact me.\n\n{$layoutEditorName}', 'This email from the Layout Editor to the Section Editor notifies them that the layout process has been completed.'),
('LAYOUT_ACK', 'en_US', 'Layout Acknowledgement', '{$layoutEditorName}:\n\nThank you for preparing the galleys for the manuscript, "{$articleTitle}," for {$journalName}. This is an important contribution to the publishing process.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor acknowledges completion of the layout editing process and thanks the layout editor for their contribution.'),
('PROOFREAD_AUTHOR_REQUEST', 'en_US', 'Proofreading Request (Author)', '{$authorName}:\n\nYour submission "{$articleTitle}" to {$journalName} now needs to be proofread by folllowing these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and view PROOFING INSTRUCTIONS\n3. Click on VIEW PROOF in Layout and proof the galley in the one or more formats used.\n4. Enter corrections (typographical and format) in Proofreading Corrections.\n5. Save and email corrections to Layout Editor and Proofreader.\n6. Send the COMPLETE email to the editor.\n\nSubmission URL: {$submissionUrl}\nUsername: {$authorUsername}\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Author notifies them that an article''s galleys are ready for proofreading. It provides information about the article and how to access it.'),
('PROOFREAD_AUTHOR_COMPLETE', 'en_US', 'Proofreading Completed (Author)', '{$editorialContactName}:\n\nI have completed proofreading the galleys for my manuscript, "{$articleTitle}," for {$journalName}. The galleys are now ready to have any final corrections made by the Proofreader and Layout Editor.\n\n{$authorName}', 'This email from the Author to the Proofreader and Editor notifies them that the Author''s round of proofreading is complete and that details can be found in the article comments.'),
('PROOFREAD_AUTHOR_ACK', 'en_US', 'Proofreading Acknowledgement (Author)', '{$authorName}:\n\nThank you for proofreading the galleys for your manuscript, "{$articleTitle}," in {$journalName}. We are looking forward to publishing your work shortly.\n\nIf you subscribe to our notification service, you will receive an email of the Table of Contents as soon as it is published. If you have any questions, please contact me.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Author acknowledges completion of the initial proofreading process and thanks them for their contribution.'),
('PROOFREAD_REQUEST', 'en_US', 'Proofreading Request', '{$proofreaderName}:\n\nThe submission "{$articleTitle}" to {$journalName} now needs to be proofread by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal and view PROOFING INSTRUCTIONS.\n3. Click on VIEW PROOF in Layout and proof the galley in the one or more formats used.\n4. Enter corrections (typographical and format) in Proofreading Corrections.\n5. Save and email corrections to Layout Editor.\n6. Send the COMPLETE email to the editor.\n\nManuscript URL: {$submissionUrl}\nUsername: {$proofreaderUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Proofreader requests that they perform proofreading of an article''s galleys. It provides information about the article and how to access it.'),
('PROOFREAD_COMPLETE', 'en_US', 'Proofreading Completed', '{$editorialContactName}:\n\nI have completed proofreading the galleys for the manuscript, "{$articleTitle}," for {$journalName}. The galleys are now ready to have any final corrections made by the Layout Editor.\n\n{$proofreaderName}', 'This email from the Proofreader to the Section Editor notifies them that the Proofreader has completed the proofreading process.'),
('PROOFREAD_ACK', 'en_US', 'Proofreading Acknowledgement', '{$proofreaderName}:\n\nThank you for proofreading the galleys for the manuscript, "{$articleTitle}," for {$journalName}. This work makes an important contribution to the quality of this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Proofreader confirms completion of the proofreader''s proofreading process and thanks them for their contribution.'),
('PROOFREAD_LAYOUT_REQUEST', 'en_US', 'Proofreading Request (Layout Editor)', '{$layoutEditorName}:\n\nThe submission "{$articleTitle}" to {$journalName} has been proofread by the author and proofreader, and any corrections should now be made by following these steps.\n1. Click on the Submission URL below.\n2. Log into the journal consult Proofreading Corrections to create corrected galleys.\n3. Upload the revised galleys.\n4. Send the COMPLETE email in Proofreading Step 3 to the editor.\n\n{$journalName} URL: {$journalUrl}\nSubnmission URL: {$submissionUrl}\nUsername: {$layoutEditorUsername}\n\nIf you are unable to undertake this work at this time or have any questions, please contact me. Thank you for your contribution to this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor notifies them that an article''s galleys are ready for final proofreading. It provides information on the article and how to access it.'),
('PROOFREAD_LAYOUT_COMPLETE', 'en_US', 'Proofreading Completed (Layout Editor)', '{$editorialContactName}:\n\nThe galleys have now been corrected, following their proofreading, for the manuscript, "{$articleTitle}," for {$journalName}. This piece is now ready to publish.\n\n{$layoutEditorName}', 'This email from the Layout Editor to the Section Editor notifies them that the final stage of proofreading has been completed and the article is now ready to publish.'),
('PROOFREAD_LAYOUT_ACK', 'en_US', 'Proofreading Acknowledgement (Layout Editor)', '{$layoutEditorName}:\n\nThank you for completing the proofreading corrections for the galleys associated with the manuscript, "{$articleTitle}," for {$journalName}. This represents an important contribution to the work of this journal.\n\n{$editorialContactSignature}', 'This email from the Section Editor to the Layout Editor acknowledges completion of the final stage of proofreading and thanks them for their contribution.'),
('EMAIL_LINK', 'en_US', 'Article of Possible Interest', 'Thought you might be interested in seeing "{$articleTitle}" by {$authorName} published in Vol {$volume}, No {$number} ({$year}) of {$journalName} at "{$articleUrl}".', 'This email template provides a registered reader with the opportunity to send information about an article to somebody who may be interested. It is available via the Reading Tools and must be enabled by the Journal Manager in the Reading Tools Administration page.'),
('SUBSCRIPTION_NOTIFY', 'en_US', 'Subscription Notification', '{$subscriberName}:\n\nYou have now been registered as a subscriber in our online journal management system for {$journalName}, with the following subscription:\n\n{$subscriptionType}\n\nTo access content that is available only to subscribers, simply log in to the system with your username, "{$username}".\n\nOnce you have logged in to the system you can change your profile details and password at any point.\n\nPlease note that if you have an institutional subscription, there is no need for users at your institution to log in, since requests for subscription content will be automatically authenticated by the system.\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a registered reader that the Manager has created a subscription for them. It provides the journal''s URL along with instructions for access.'),
('OPEN_ACCESS_NOTIFY', 'en_US', 'Issue Now Open Access', 'Readers:\n\n{$journalName} has just made available in an open access format the following issue. We invite you to review the Table of Contents here and then visit our web site ({$journalUrl}) to review articles and items of interest.\n\nThanks for the continuing interest in our work,\n{$editorialContactSignature}', 'This email is sent to registered readers who have requested to receive a notification email when an issue becomes open access.'),
('SUBSCRIPTION_BEFORE_EXPIRY', 'en_US', 'Notice of Subscription Expiry', '{$subscriberName}:\n\nYour {$journalName} subscription is about to expire.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo ensure the continuity of your access to this journal, please go to the journal website and renew your subscription. You are able to log in to the system with your username, "{$username}".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a subscriber that their subscription will soon expire. It provides the journal''s URL along with instructions for access.'),
('SUBSCRIPTION_AFTER_EXPIRY', 'en_US', 'Subscription Expired', '{$subscriberName}:\n\nYour {$journalName} subscription has expired.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, "{$username}".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a subscriber that their subscription has expired. It provides the journal''s URL along with instructions for access.'),
('SUBSCRIPTION_AFTER_EXPIRY_LAST', 'en_US', 'Subscription Expired - Final Reminder', '{$subscriberName}:\n\nYour {$journalName} subscription has expired.\nPlease note that this is the final reminder that will be emailed to you.\n\n{$subscriptionType}\nExpiry date: {$expiryDate}\n\nTo renew your subscription, please go to the journal website. You are able to log in to the system with your username, "{$username}".\n\nIf you have any questions, please feel free to contact me.\n\n{$subscriptionContactSignature}', 'This email notifies a subscriber that their subscription has expired. It provides the journal''s URL along with instructions for access.'),
('SUBSCRIPTION_PURCHASE_INDL', 'en_US', 'Subscription Purchase: Individual', 'An individual subscription has been purchased online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nUser:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an individual subscription has been purchased online. It provides summary information about the subscription and a quick access link to the purchased subscription.'),
('SUBSCRIPTION_PURCHASE_INSTL', 'en_US', 'Subscription Purchase: Institutional', 'An institutional subscription has been purchased online for {$journalName} with the following details. To activate this subscription, please use the provided Subscription URL and set the subscription status to ''Active''.\n\nSubscription Type:\n{$subscriptionType}\n\nInstitution:\n{$institutionName}\n{$institutionMailingAddress}\n\nDomain (if provided):\n{$domain}\n\nIP Ranges (if provided):\n{$ipRanges}\n\nContact Person:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an institutional subscription has been purchased online. It provides summary information about the subscription and a quick access link to the purchased subscription.'),
('SUBSCRIPTION_RENEW_INDL', 'en_US', 'Subscription Renewal: Individual', 'An individual subscription has been renewed online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nUser:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an individual subscription has been renewed online. It provides summary information about the subscription and a quick access link to the renewed subscription.'),
('SUBSCRIPTION_RENEW_INSTL', 'en_US', 'Subscription Renewal: Institutional', 'An institutional subscription has been renewed online for {$journalName} with the following details.\n\nSubscription Type:\n{$subscriptionType}\n\nInstitution:\n{$institutionName}\n{$institutionMailingAddress}\n\nDomain (if provided):\n{$domain}\n\nIP Ranges (if provided):\n{$ipRanges}\n\nContact Person:\n{$userDetails}\n\nMembership Information (if provided):\n{$membership}\n\nTo view or edit this subscription, please use the following URL.\n\nSubscription URL: {$subscriptionUrl}\n', 'This email notifies the Subscription Manager that an institutional subscription has been renewed online. It provides summary information about the subscription and a quick access link to the renewed subscription.'),
('CITATION_EDITOR_AUTHOR_QUERY', 'en_US', 'Citation Editing', '{$authorFirstName},\n\nCould you please verify or provide us with the proper citation for the following reference from your article, {$articleTitle}:\n\n{$rawCitation}\n\nThanks!\n\n{$userFirstName}\nCopy-Editor, {$journalName}\n', 'This email allows copyeditors to request additional information about references from authors.'),
('BFR_REVIEW_REMINDER', 'en_US', 'Book for Review: Due Date Reminder', 'Dear {$authorName}:\n\nThis is a friendly reminder that your book review of {$bookForReviewTitle} is due {$bookForReviewDueDate}.\n\nTo submit your book review, please log into the journal website and complete the online article submission process. For your convenience, a submission URL has been provided below.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\nThank you for your contribution to the journal and I look forward to receiving your submission.\n\n{$editorialContactSignature}', 'This is an automatically generated email that is sent to a book for review author as a reminder that the due date for the review is approaching.'),
('BFR_REVIEW_REMINDER_LATE', 'en_US', 'Book for Review: Review Due', 'Dear {$authorName}:\n\nThis is a friendly reminder that your book review of {$bookForReviewTitle} was due {$bookForReviewDueDate} but has not been received yet.\n\nTo submit your book review, please log into the journal website and complete the online article submission process. For your convenience, a submission URL has been provided below.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\nThank you for your contribution to the journal and I look forward to receiving your submission.\n\n{$editorialContactSignature}', 'This is an automatically generated email that is sent to a book for review author after the review due date has passed.'),
('BFR_BOOK_ASSIGNED', 'en_US', 'Book for Review: Book Assigned', 'Dear {$authorName}:\n\nThis email confirms that {$bookForReviewTitle} has been assigned to you for a book review to be completed by {$bookForReviewDueDate}.\n\nPlease ensure that your mailing address in your online user profile is up-to-date. This address will be used to mail a copy of the book to you for the review.\n\nThe mailing address that we currently have on file is:\n{$authorMailingAddress}\n\nIf this address is incomplete or you are no longer at this address, please use the following user profile URL to update your address:\n\nUser Profile URL: {$userProfileUrl}\n \nTo submit your book review, please log into the journal website and complete the online article submission process.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\n{$editorialContactSignature}', 'This email is sent by an editor to a book review author when an editor assigns the book for review to the author.'),
('BFR_BOOK_DENIED', 'en_US', 'Book for Review', 'Dear {$authorName}:\n\nUnfortunately, I am not able to assign {$bookForReviewTitle} to you at this time for a book review.\n\nI hope you consider reviewing another book from our listing, either at this time or in the future.\n\n{$editorialContactSignature}', 'This email is sent by an editor to an interested author when a book is no longer available for review.'),
('BFR_BOOK_REQUESTED', 'en_US', 'Book for Review: Book Requested', 'Dear {$editorName}:\n\nI am interested in writing a book review of {$bookForReviewTitle}.\n\nCan you please confirm whether this book is still available for review?\n\n{$authorContactSignature}', 'This email is sent to an editor by an author interested in writing a book review for a listed book.'),
('BFR_BOOK_MAILED', 'en_US', 'Book for Review: Book Mailed', 'Dear {$authorName}:\n\nThis email confirms that I have mailed a copy of {$bookForReviewTitle} to the following mailing address from your online user profile:\n{$authorMailingAddress}\n \nTo submit your book review, please log into the journal website and complete the online article submission process.\n\nSubmission URL: {$submissionUrl}\n\nPlease feel free to contact me if you have any questions or concerns about this book review.\n\n{$editorialContactSignature}', 'This email is sent by an editor to a book review author when the editor has mailed a copy of the book to the author.'),
('BFR_REVIEWER_REMOVED', 'en_US', 'Book for Review', 'Dear {$authorName}:\n\nThis email confirms that you have been removed as the book reviewer for {$bookForReviewTitle}, which will be made available to other authors interested in reviewing the book.\n\nI hope you consider reviewing another book from our listing, either at this time or in the future.\n\n{$editorialContactSignature}', 'This email is sent by an editor to an interested author when a book is no longer available for review.'),
('SWORD_DEPOSIT_NOTIFICATION', 'en_US', 'Deposit Notification', 'Congratulations on the acceptance of your submission, "{$articleTitle}", for publication in {$journalName}. If you choose, you may automatically deposit your submission in one or more repositories.\n\nGo to {$swordDepositUrl} to proceed.\n\nThis email was generated by Open Journal Systems'' SWORD deposit plugin.', 'This email template is used to notify an author of optional deposit points for SWORD deposits.'),
('THESIS_ABSTRACT_CONFIRM', 'en_US', 'Thesis Abstract Submission', 'This email was automatically generated by the {$journalName} thesis abstract submission form.\n\nPlease confirm that the submitted information is correct. Upon receiving your confirmation, the abstract will be published in the online edition of the journal.\n\nSimply reply to {$thesisName} ({$thesisEmail}) with the contents of this message and your confirmation, as well as any recommended clarifications or corrections.\n\nThank you.\n\n\nTitle : {$title} \nAuthor : {$studentName}\nDegree : {$degree}\nDegree Name: {$degreeName}\nDepartment : {$department}\nUniversity : {$university}\nAcceptance Date : {$dateApproved}\nSupervisor : {$supervisorName}\n\nAbstract\n--------\n{$abstract}\n\n{$thesisContactSignature}', 'This email template is used to confirm a thesis abstract submission by a student. It is sent to the student''s supervisor, who is asked to confirm the details of the submitted thesis abstract.'),
('MANUAL_PAYMENT_NOTIFICATION', 'en_US', 'Manual Payment Notification', 'A manual payment needs to be processed for the journal {$journalName} and the user {$userFullName} (username "{$userName}").\n\nThe item being paid for is "{$itemName}".\nThe cost is {$itemCost} ({$itemCurrencyCode}).\n\nThis email was generated by Open Journal Systems'' Manual Payment plugin.', 'This email template is used to notify a journal manager contact that a manual payment was requested.');
INSERT INTO `email_templates_default_data` (`email_key`, `locale`, `subject`, `body`, `description`) VALUES
('PAYPAL_INVESTIGATE_PAYMENT', 'en_US', 'Unusual PayPal Activity', 'Open Journal Systems has encountered unusual activity relating to PayPal payment support for the journal {$journalName}. This activity may need further investigation or manual intervention.\n                       \nThis email was generated by Open Journal Systems'' PayPal plugin.\n\nFull post information for the request:\n{$postInfo}\n\nAdditional information (if supplied):\n{$additionalInfo}\n\nServer vars:\n{$serverVars}\n', 'This email template is used to notify a journal''s primary contact that suspicious activity or activity requiring manual intervention was encountered by the PayPal plugin.');

-- --------------------------------------------------------

--
-- Table structure for table `external_feeds`
--

CREATE TABLE IF NOT EXISTS `external_feeds` (
  `feed_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `display_homepage` tinyint(4) NOT NULL DEFAULT '0',
  `display_block` smallint(6) NOT NULL DEFAULT '0',
  `limit_items` tinyint(4) DEFAULT '0',
  `recent_items` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`feed_id`),
  KEY `external_feeds_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `external_feeds`
--


-- --------------------------------------------------------

--
-- Table structure for table `external_feed_settings`
--

CREATE TABLE IF NOT EXISTS `external_feed_settings` (
  `feed_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `external_feed_settings_pkey` (`feed_id`,`locale`,`setting_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `external_feed_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `filters`
--

CREATE TABLE IF NOT EXISTS `filters` (
  `filter_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL DEFAULT '0',
  `display_name` varchar(255) DEFAULT NULL,
  `class_name` varchar(255) DEFAULT NULL,
  `input_type` varchar(255) DEFAULT NULL,
  `output_type` varchar(255) DEFAULT NULL,
  `is_template` tinyint(4) NOT NULL DEFAULT '0',
  `parent_filter_id` bigint(20) NOT NULL DEFAULT '0',
  `seq` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`filter_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `filters`
--

INSERT INTO `filters` (`filter_id`, `context_id`, `display_name`, `class_name`, `input_type`, `output_type`, `is_template`, `parent_filter_id`, `seq`) VALUES
(1, 0, 'CrossRef', 'lib.pkp.classes.citation.lookup.crossref.CrossrefNlmCitationSchemaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(2, 0, 'PubMed', 'lib.pkp.classes.citation.lookup.pubmed.PubmedNlmCitationSchemaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(3, 0, 'WorldCat', 'lib.pkp.classes.citation.lookup.worldcat.WorldcatNlmCitationSchemaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(4, 0, 'FreeCite', 'lib.pkp.classes.citation.parser.freecite.FreeciteRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(5, 0, 'ParaCite', 'lib.pkp.classes.citation.parser.paracite.ParaciteRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(6, 0, 'ParsCit', 'lib.pkp.classes.citation.parser.parscit.ParscitRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(7, 0, 'RegEx', 'lib.pkp.classes.citation.parser.regex.RegexRawCitationNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(8, 0, 'ABNT Citation Output', 'lib.pkp.classes.citation.output.abnt.NlmCitationSchemaAbntFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(9, 0, 'ABNT Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(10, 0, 'APA Citation Output', 'lib.pkp.classes.citation.output.apa.NlmCitationSchemaApaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(11, 0, 'APA Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(12, 0, 'MLA Citation Output', 'lib.pkp.classes.citation.output.mla.NlmCitationSchemaMlaFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(13, 0, 'MLA Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(14, 0, 'Vancouver Citation Output', 'lib.pkp.classes.citation.output.vancouver.NlmCitationSchemaVancouverFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 0, 0),
(15, 0, 'Vancouver Citation Output', 'lib.pkp.classes.citation.output.PlainTextReferencesListFilter', 'class::lib.pkp.classes.submission.Submission', 'class::lib.pkp.classes.citation.PlainTextReferencesList', 0, 0, 0),
(16, 0, 'NLM Journal Publishing V3.0 ref-list', 'lib.pkp.classes.importexport.nlm.PKPSubmissionNlmXmlFilter', 'class::lib.pkp.classes.submission.Submission', 'xml::*', 0, 0, 0),
(17, 0, 'ISBNdb', 'lib.pkp.classes.filter.GenericSequencerFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 1, 0, 0),
(18, 0, 'ISBNdb (from NLM)', 'lib.pkp.classes.citation.lookup.isbndb.IsbndbNlmCitationSchemaIsbnFilter', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 'primitive::string', 0, 17, 1),
(19, 0, 'ISBNdb', 'lib.pkp.classes.citation.lookup.isbndb.IsbndbIsbnNlmCitationSchemaFilter', 'primitive::string', 'metadata::lib.pkp.classes.metadata.nlm.NlmCitationSchema(CITATION)', 0, 17, 2),
(20, 0, 'NLM Journal Publishing V2.3 ref-list', 'lib.pkp.classes.filter.GenericSequencerFilter', 'class::lib.pkp.classes.submission.Submission', 'xml::*', 0, 0, 0),
(21, 0, 'NLM Journal Publishing V3.0 ref-list', 'lib.pkp.classes.importexport.nlm.PKPSubmissionNlmXmlFilter', 'class::lib.pkp.classes.submission.Submission', 'xml::*', 0, 20, 1),
(22, 0, 'NLM 3.0 to 2.3 ref-list downgrade', 'lib.pkp.classes.xslt.XSLTransformationFilter', 'xml::*', 'xml::*', 0, 20, 2);

-- --------------------------------------------------------

--
-- Table structure for table `filter_settings`
--

CREATE TABLE IF NOT EXISTS `filter_settings` (
  `filter_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `filter_settings_pkey` (`filter_id`,`locale`,`setting_name`),
  KEY `filter_settings_id` (`filter_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `filter_settings`
--

INSERT INTO `filter_settings` (`filter_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(1, '', 'phpVersionMin', '5.0.0', 'string'),
(2, '', 'phpVersionMin', '5.0.0', 'string'),
(3, '', 'phpVersionMin', '5.0.0', 'string'),
(4, '', 'phpVersionMin', '5.0.0', 'string'),
(5, '', 'citationModule', 'Standard', 'string'),
(5, '', 'phpVersionMin', '5.0.0', 'string'),
(6, '', 'phpVersionMin', '5.0.0', 'string'),
(7, '', 'phpVersionMin', '5.0.0', 'string'),
(9, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.abnt.NlmCitationSchemaAbntFilter', 'string'),
(9, '', 'ordering', '2', 'int'),
(11, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.apa.NlmCitationSchemaApaFilter', 'string'),
(11, '', 'ordering', '2', 'int'),
(13, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.mla.NlmCitationSchemaMlaFilter', 'string'),
(13, '', 'ordering', '2', 'int'),
(15, '', 'citationOutputFilterName', 'lib.pkp.classes.citation.output.vancouver.NlmCitationSchemaVancouverFilter', 'string'),
(15, '', 'ordering', '1', 'int'),
(17, '', 'settingsMapping', 'a:2:{s:6:"apiKey";a:2:{i:0;s:11:"seq1_apiKey";i:1;s:11:"seq2_apiKey";}s:10:"isOptional";a:2:{i:0;s:15:"seq1_isOptional";i:1;s:15:"seq2_isOptional";}}', 'object'),
(18, '', 'phpVersionMin', '5.0.0', 'string'),
(19, '', 'phpVersionMin', '5.0.0', 'string'),
(22, '', 'xsl', 'lib/pkp/classes/importexport/nlm/nlm-ref-list-30-to-23.xsl', 'string'),
(22, '', 'xslType', '2', 'int');

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE IF NOT EXISTS `groups` (
  `group_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) DEFAULT NULL,
  `publish_email` smallint(6) DEFAULT NULL,
  `assoc_id` bigint(20) DEFAULT NULL,
  `context` bigint(20) DEFAULT NULL,
  `about_displayed` tinyint(4) NOT NULL DEFAULT '0',
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`),
  KEY `groups_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `groups`
--


-- --------------------------------------------------------

--
-- Table structure for table `group_memberships`
--

CREATE TABLE IF NOT EXISTS `group_memberships` (
  `user_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `about_displayed` tinyint(4) NOT NULL DEFAULT '1',
  `seq` double NOT NULL DEFAULT '0',
  UNIQUE KEY `group_memberships_pkey` (`user_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `group_memberships`
--


-- --------------------------------------------------------

--
-- Table structure for table `group_settings`
--

CREATE TABLE IF NOT EXISTS `group_settings` (
  `group_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `group_settings_pkey` (`group_id`,`locale`,`setting_name`),
  KEY `group_settings_group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `group_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `institutional_subscriptions`
--

CREATE TABLE IF NOT EXISTS `institutional_subscriptions` (
  `institutional_subscription_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subscription_id` bigint(20) NOT NULL,
  `institution_name` varchar(255) NOT NULL,
  `mailing_address` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`institutional_subscription_id`),
  KEY `institutional_subscriptions_subscription_id` (`subscription_id`),
  KEY `institutional_subscriptions_domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `institutional_subscriptions`
--


-- --------------------------------------------------------

--
-- Table structure for table `institutional_subscription_ip`
--

CREATE TABLE IF NOT EXISTS `institutional_subscription_ip` (
  `institutional_subscription_ip_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subscription_id` bigint(20) NOT NULL,
  `ip_string` varchar(40) NOT NULL,
  `ip_start` bigint(20) NOT NULL,
  `ip_end` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`institutional_subscription_ip_id`),
  KEY `institutional_subscription_ip_subscription_id` (`subscription_id`),
  KEY `institutional_subscription_ip_start` (`ip_start`),
  KEY `institutional_subscription_ip_end` (`ip_end`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `institutional_subscription_ip`
--


-- --------------------------------------------------------

--
-- Table structure for table `issues`
--

CREATE TABLE IF NOT EXISTS `issues` (
  `issue_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `volume` smallint(6) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `published` tinyint(4) NOT NULL DEFAULT '0',
  `current` tinyint(4) NOT NULL DEFAULT '0',
  `date_published` datetime DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `access_status` tinyint(4) NOT NULL DEFAULT '1',
  `open_access_date` datetime DEFAULT NULL,
  `public_issue_id` varchar(255) DEFAULT NULL,
  `show_volume` tinyint(4) NOT NULL DEFAULT '0',
  `show_number` tinyint(4) NOT NULL DEFAULT '0',
  `show_year` tinyint(4) NOT NULL DEFAULT '0',
  `show_title` tinyint(4) NOT NULL DEFAULT '0',
  `style_file_name` varchar(90) DEFAULT NULL,
  `original_style_file_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`issue_id`),
  UNIQUE KEY `issues_public_issue_id` (`public_issue_id`,`journal_id`),
  KEY `issues_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `issues`
--


-- --------------------------------------------------------

--
-- Table structure for table `issue_settings`
--

CREATE TABLE IF NOT EXISTS `issue_settings` (
  `issue_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `issue_settings_pkey` (`issue_id`,`locale`,`setting_name`),
  KEY `issue_settings_issue_id` (`issue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `issue_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `journals`
--

CREATE TABLE IF NOT EXISTS `journals` (
  `journal_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(32) NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `primary_locale` varchar(5) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`journal_id`),
  UNIQUE KEY `journals_path` (`path`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `journals`
--

INSERT INTO `journals` (`journal_id`, `path`, `seq`, `primary_locale`, `enabled`) VALUES
(2, 'whorrp', 1, 'en_US', 1);

-- --------------------------------------------------------

--
-- Table structure for table `journal_settings`
--

CREATE TABLE IF NOT EXISTS `journal_settings` (
  `journal_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `journal_settings_pkey` (`journal_id`,`locale`,`setting_name`),
  KEY `journal_settings_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `journal_settings`
--

INSERT INTO `journal_settings` (`journal_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(2, '', 'rtAbstract', '1', 'bool'),
(2, '', 'rtCaptureCite', '1', 'bool'),
(2, '', 'rtViewMetadata', '1', 'bool'),
(2, '', 'rtSupplementaryFiles', '1', 'bool'),
(2, '', 'rtPrinterFriendly', '1', 'bool'),
(2, '', 'rtAuthorBio', '1', 'bool'),
(2, '', 'rtDefineTerms', '1', 'bool'),
(2, '', 'rtAddComment', '1', 'bool'),
(2, '', 'rtEmailAuthor', '1', 'bool'),
(2, '', 'rtEmailOthers', '1', 'bool'),
(2, '', 'allowRegReviewer', '1', 'bool'),
(2, '', 'allowRegAuthor', '1', 'bool'),
(2, '', 'allowRegReader', '1', 'bool'),
(2, '', 'submissionFee', '0', 'int'),
(2, 'en_US', 'submissionFeeName', 'Article Submission', 'string'),
(2, 'en_US', 'submissionFeeDescription', 'Authors are required to pay an Article Submission Fee as part of the submission process to contribute to review costs.', 'string'),
(2, '', 'fastTrackFee', '0', 'int'),
(2, 'en_US', 'fastTrackFeeName', 'Fast-Track Review', 'string'),
(2, 'en_US', 'fastTrackFeeDescription', 'With the payment of this fee, the review, editorial decision, and author notification on this manuscript is guaranteed to take place within 4 weeks.', 'string'),
(2, '', 'publicationFee', '0', 'int'),
(2, 'en_US', 'publicationFeeName', 'Article Publication', 'string'),
(2, 'en_US', 'publicationFeeDescription', 'If this paper is accepted for publication, you will be asked to pay an Article Publication Fee to cover publications costs.', 'string'),
(2, 'en_US', 'waiverPolicy', 'If you do not have funds to pay such fees, you will have an opportunity to waive each fee. We do not want fees to prevent the publication of worthy work.', 'string'),
(2, '', 'purchaseArticleFee', '0', 'int'),
(2, 'en_US', 'purchaseArticleFeeName', 'Purchase Article', 'string'),
(2, 'en_US', 'purchaseArticleFeeDescription', 'The payment of this fee will enable you to view, download, and print this article.', 'string'),
(2, '', 'membershipFee', '0', 'int'),
(2, 'en_US', 'membershipFeeName', 'Association Membership', 'string'),
(2, 'en_US', 'membershipFeeDescription', 'The payment of this fee will enroll you as a member in this association for one year and provide you with free access to this journal.', 'string'),
(2, 'en_US', 'donationFeeName', 'Donations to journal', 'string'),
(2, 'en_US', 'donationFeeDescription', 'Donations of any amount to this journal are gratefully received and provide a means for the editors to continue to provide a journal of the highest quality to its readers.', 'string'),
(2, 'en_US', 'title', 'WHO RRP', 'string'),
(2, 'en_US', 'description', 'WHO Research Registration Portal', 'string'),
(2, '', 'supportedLocales', 'a:1:{i:0;s:5:"en_US";}', 'object'),
(2, '', 'supportedFormLocales', 'a:1:{i:0;s:5:"en_US";}', 'object'),
(2, '', 'supportedSubmissionLocales', 'a:1:{i:0;s:5:"en_US";}', 'object'),
(2, 'en_US', 'submissionChecklist', 'a:6:{i:0;a:2:{s:7:"content";s:165:"The submission has not been previously published, nor is it before another journal for consideration (or an explanation has been provided in Comments to the Editor).";s:5:"order";s:1:"1";}i:1;a:2:{s:7:"content";s:95:"The submission file is in OpenOffice, Microsoft Word, RTF, or WordPerfect document file format.";s:5:"order";s:1:"2";}i:2;a:2:{s:7:"content";s:60:"Where available, URLs for the references have been provided.";s:5:"order";s:1:"3";}i:3;a:2:{s:7:"content";s:239:"The text is single-spaced; uses a 12-point font; employs italics, rather than underlining (except with URL addresses); and all illustrations, figures, and tables are placed within the text at the appropriate points, rather than at the end.";s:5:"order";s:1:"4";}i:4;a:2:{s:7:"content";s:247:"The text adheres to the stylistic and bibliographic requirements outlined in the <a href="http://localhost/whorrp/whorrp/index.php/whorrp/about/submissions#authorGuidelines" target="_new">Author Guidelines</a>, which is found in About the Journal.";s:5:"order";s:1:"5";}i:5;a:2:{s:7:"content";s:238:"If submitting to a peer-reviewed section of the journal, the instructions in <a href="javascript:openHelp(''http://localhost/whorrp/whorrp/index.php/whorrp/help/view/editorial/topic/000044'')">Ensuring a Blind Review</a> have been followed.";s:5:"order";s:1:"6";}}', 'object'),
(2, 'en_US', 'authorInformation', 'Interested in submitting to this journal? We recommend that you review the <a href="http://localhost/whorrp/whorrp/index.php/whorrp/about">About the Journal</a> page for the journal''s section policies, as well as the <a href="http://localhost/whorrp/whorrp/index.php/whorrp/about/submissions#authorGuidelines">Author Guidelines</a>. Authors need to <a href="http://localhost/whorrp/whorrp/index.php/whorrp/user/register">register</a> with the journal prior to submitting or, if already registered, can simply <a href="http://localhost/whorrp/whorrp/index.php/index/login">log in</a> and begin the five-step process.', 'string'),
(2, 'en_US', 'librarianInformation', 'We encourage research librarians to list this journal among their library''s electronic journal holdings. As well, it may be worth noting that this journal''s open source publishing system is suitable for libraries to host for their faculty members to use with journals they are involved in editing (see <a href="http://pkp.sfu.ca/ojs">Open Journal Systems</a>).', 'string'),
(2, 'en_US', 'lockssLicense', 'This journal utilizes the LOCKSS system to create a distributed archiving system among participating libraries and permits those libraries to create permanent archives of the journal for purposes of preservation and restoration. <a href="http://lockss.org/">More...</a>', 'string'),
(2, 'en_US', 'readerInformation', 'We encourage readers to sign up for the publishing notification service for this journal. Use the <a href="http://localhost/whorrp/whorrp/index.php/whorrp/user/register">Register</a> link at the top of the home page for the journal. This registration will result in the reader receiving the Table of Contents by email for each new issue of the journal. This list also allows the journal to claim a certain level of support or readership. See the journal''s <a href="http://localhost/whorrp/whorrp/index.php/whorrp/about/submissions#privacyStatement">Privacy Statement</a>, which assures readers that their name and email address will not be used for other purposes.', 'string'),
(2, 'en_US', 'refLinkInstructions', '<h4>To Add Reference Linking to the Layout Process</h4>\n	<p>When turning a submission into HTML or PDF, make sure that all hyperlinks in the submission are active.</p>\n	<h4>A. When the Author Provides a Link with the Reference</h4>\n	<ol>\n	<li>While the submission is still in its word processing format (e.g., Word), add the phrase VIEW ITEM to the end of the reference that has a URL.</li>\n	<li>Turn that phrase into a hyperlink by highlighting it and using Word''s Insert Hyperlink tool and the URL prepared in #2.</li>\n	</ol>\n	<h4>B. Enabling Readers to Search Google Scholar For References</h4>\n	<ol>\n		<li>While the submission is still in its word processing format (e.g., Word), copy the title of the work referenced in the References list (if it appears to be too common a title—e.g., "Peace"—then copy author and title).</li>\n		<li>Paste the reference''s title between the %22''s, placing a + between each word: http://scholar.google.com/scholar?q=%22PASTE+TITLE+HERE%22&hl=en&lr=&btnG=Search.</li>\n\n	<li>Add the phrase GS SEARCH to the end of each citation in the submission''s References list.</li>\n	<li>Turn that phrase into a hyperlink by highlighting it and using Word''s Insert Hyperlink tool and the URL prepared in #2.</li>\n	</ol>\n	<h4>C. Enabling Readers to Search for References with a DOI</h4>\n	<ol>\n	<li>While the submission is still in Word, copy a batch of references into CrossRef Text Query http://www.crossref.org/freeTextQuery/.</li>\n	<li>Paste each DOI that the Query provides in the following URL (between = and &): http://www.cmaj.ca/cgi/external_ref?access_num=PASTE DOI#HERE&link_type=DOI.</li>\n	<li>Add the phrase CrossRef to the end of each citation in the submission''s References list.</li>\n	<li>Turn that phrase into a hyperlink by highlighting the phrase and using Word''s Insert Hyperlink tool and the appropriate URL prepared in #2.</li>\n	</ol>', 'string'),
(2, '', 'emailSignature', '________________________________________________________________________\nWHO RRP\nhttp://localhost/whorrp/whorrp/index.php/whorrp', 'string'),
(2, 'en_US', 'proofInstructions', '<p>The proofreading stage is intended to catch any errors in the galley''s spelling, grammar, and formatting. More substantial changes cannot be made at this stage, unless discussed with the Section Editor. In Layout, click on VIEW PROOF to see the HTML, PDF, and other available file formats used in publishing this item.</p>\n	<h4>For Spelling and Grammar Errors</h4>\n\n	<p>Copy the problem word or groups of words and paste them into the Proofreading Corrections box with "CHANGE-TO" instructions to the editor as follows:</p>\n\n	<pre>1. CHANGE...\n	then the others\n	TO...\n	than the others</pre>\n	<br />\n	<pre>2. CHANGE...\n	Malinowsky\n	TO...\n	Malinowski</pre>\n	<br />\n\n	<h4>For Formatting Errors</h4>\n	\n	<p>Describe the location and nature of the problem in the Proofreading Corrections box after typing in the title "FORMATTING" as follows:</p>\n	<br />\n	<pre>3. FORMATTING\n	The numbers in Table 3 are not aligned in the third column.</pre>\n	<br />\n	<pre>4. FORMATTING\n	The paragraph that begins "This last topic..." is not indented.</pre>', 'string'),
(2, 'en_US', 'copyeditInstructions', 'The copyediting stage is intended to improve the flow, clarity, grammar, wording, and formatting of the article. It represents the last chance for the author to make any substantial changes to the text because the next stage is restricted to typos and formatting corrections. \n\nThe file to be copyedited is in Word or .rtf format and therefore can easily be edited as a word processing document. The set of instructions displayed here proposes two approaches to copyediting. One is based on Microsoft Word''s Track Changes feature and requires that the copy editor, editor, and author have access to this program. A second system, which is software independent, has been borrowed, with permission, from the Harvard Educational Review. The journal editor is in a position to modify these instructions, so suggestions can be made to improve the process for this journal.\n\n\n<h4>Copyediting Systems</h4>\n\n<strong>1. Microsoft Word''s Track Changes</strong>\n\nUnder Tools in the menu bar, the feature Track Changes enables the copy editor to make insertions (text appears in color) and deletions (text appears crossed out in color or in the margins as deleted). The copy editor can posit queries to both the author (Author Queries) and to the editor (Editor Queries) by inserting these queries in square brackets. The copyedited version is then uploaded, and the editor is notified. The editor then reviews the text and notifies the author.\n\nThe editor and author should leave those changes with which they are satisfied. If further changes are necessary, the editor and author can make changes to the initial insertions or deletions, as well as make new insertions or deletions elsewhere in the text. Authors and editors should respond to each of the queries addressed to them, with responses placed inside the square brackets. \n\nAfter the text has been reviewed by editor and author, the copy editor will make a final pass over the text accepting the changes in preparation for the layout and galley stage.\n\n\n<strong>2. Harvard Educational Review </strong>\n\n<strong>Instructions for Making Electronic Revisions to the Manuscript</strong>\n\nPlease follow the following protocol for making electronic revisions to your manuscript:\n\n<strong>Responding to suggested changes.</strong>\n&nbsp; For each of the suggested changes that you accept, unbold the text.\n&nbsp; For each of the suggested changes that you do not accept, re-enter the original text and <strong>bold</strong> it.\n\n<strong>Making additions and deletions.</strong>\n&nbsp; Indicate additions by <strong>bolding</strong> the new text.\n&nbsp; Replace deleted sections with: <strong>[deleted text]</strong>.\n&nbsp; If you delete one or more sentence, please indicate with a note, e.g., <strong>[deleted 2 sentences]</strong>.\n\n<strong>Responding to Queries to the Author (QAs).</strong>\n&nbsp; Keep all QAs intact and bolded within the text. Do not delete them.\n&nbsp; To reply to a QA, add a comment after it. Comments should be delimited using:\n<strong>[Comment:]</strong>\n&nbsp; e.g., <strong>[Comment: Expanded discussion of methodology as you suggested]</strong>.\n\n<strong>Making comments.</strong>\n&nbsp; Use comments to explain organizational changes or major revisions\n&nbsp; e.g., <strong>[Comment: Moved the above paragraph from p. 5 to p. 7].</strong>\n&nbsp; Note: When referring to page numbers, please use the page numbers from the printed copy of the manuscript that was sent to you. This is important since page numbers may change as a document is revised electronically.\n\n<h4>An Illustration of an Electronic Revision</h4>\n\n<ol>\n<li><strong>Initial copyedit.</strong> The journal copy editor will edit the text to improve flow, clarity, grammar, wording, and formatting, as well as including author queries as necessary. Once the initial edit is complete, the copy editor will upload the revised document through the journal Web site and notify the author that the edited manuscript is available for review.</li>\n<li><strong>Author copyedit.</strong> Before making dramatic departures from the structure and organization of the edited manuscript, authors must check in with the editors who are co-chairing the piece. Authors should accept/reject any changes made during the initial copyediting, as appropriate, and respond to all author queries. When finished with the revisions, authors should rename the file from AuthorNameQA.doc to AuthorNameQAR.doc (e.g., from LeeQA.doc to LeeQAR.doc) and upload the revised document through the journal Web site as directed.</li>\n<li><strong>Final copyedit.</strong> The journal copy editor will verify changes made by the author and incorporate the responses to the author queries to create a final manuscript. When finished, the copy editor will upload the final document through the journal Web site and alert the layout editor to complete formatting.</li>\n</ol>', 'string'),
(2, 'en_US', 'authorSelfArchivePolicy', 'This journal permits and encourages authors to post items submitted to the journal on personal websites or institutional repositories both prior to and after publication, while providing bibliographic details that credit, if applicable, its publication in this journal.', 'string'),
(2, 'en_US', 'openAccessPolicy', 'This journal provides immediate open access to its content on the principle that making research freely available to the public supports a greater global exchange of knowledge.', 'string'),
(2, 'en_US', 'privacyStatement', 'The names and email addresses entered in this journal site will be used exclusively for the stated purposes of this journal and will not be made available for any other purpose or to any other party.', 'string'),
(2, '', 'numWeeksPerReview', '4', 'int'),
(2, '', 'itemsPerPage', '25', 'int'),
(2, '', 'numPageLinks', '10', 'int');

-- --------------------------------------------------------

--
-- Table structure for table `metadata_descriptions`
--

CREATE TABLE IF NOT EXISTS `metadata_descriptions` (
  `metadata_description_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `schema_namespace` varchar(255) NOT NULL,
  `schema_name` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `seq` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`metadata_description_id`),
  KEY `metadata_descriptions_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `metadata_descriptions`
--


-- --------------------------------------------------------

--
-- Table structure for table `metadata_description_settings`
--

CREATE TABLE IF NOT EXISTS `metadata_description_settings` (
  `metadata_description_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `metadata_descripton_settings_pkey` (`metadata_description_id`,`locale`,`setting_name`),
  KEY `metadata_description_settings_id` (`metadata_description_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `metadata_description_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE IF NOT EXISTS `notes` (
  `note_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` smallint(6) NOT NULL,
  `assoc_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL,
  `date_modified` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `file_id` bigint(20) DEFAULT NULL,
  `context_id` bigint(20) DEFAULT NULL,
  `contents` text,
  PRIMARY KEY (`note_id`),
  KEY `notes_assoc` (`assoc_type`,`assoc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `notes`
--


-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
  `notification_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `level` bigint(20) DEFAULT NULL,
  `date_created` datetime NOT NULL,
  `date_read` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `contents` text,
  `param` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `is_localized` tinyint(4) NOT NULL DEFAULT '1',
  `product` varchar(20) DEFAULT NULL,
  `context` bigint(20) NOT NULL,
  `assoc_type` bigint(20) NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `notifications_by_user` (`product`,`user_id`,`level`,`context`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `notifications`
--


-- --------------------------------------------------------

--
-- Table structure for table `notification_settings`
--

CREATE TABLE IF NOT EXISTS `notification_settings` (
  `setting_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(64) NOT NULL,
  `setting_value` text,
  `user_id` bigint(20) NOT NULL,
  `product` varchar(20) DEFAULT NULL,
  `context` bigint(20) NOT NULL,
  PRIMARY KEY (`setting_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `notification_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `oai_resumption_tokens`
--

CREATE TABLE IF NOT EXISTS `oai_resumption_tokens` (
  `token` varchar(32) NOT NULL,
  `expire` bigint(20) NOT NULL,
  `record_offset` int(11) NOT NULL,
  `params` text,
  UNIQUE KEY `oai_resumption_tokens_pkey` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `oai_resumption_tokens`
--


-- --------------------------------------------------------

--
-- Table structure for table `paypal_transactions`
--

CREATE TABLE IF NOT EXISTS `paypal_transactions` (
  `txn_id` varchar(17) NOT NULL,
  `txn_type` varchar(20) DEFAULT NULL,
  `payer_email` varchar(127) DEFAULT NULL,
  `receiver_email` varchar(127) DEFAULT NULL,
  `item_number` varchar(127) DEFAULT NULL,
  `payment_date` varchar(127) DEFAULT NULL,
  `payer_id` varchar(13) DEFAULT NULL,
  `receiver_id` varchar(13) DEFAULT NULL,
  PRIMARY KEY (`txn_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `paypal_transactions`
--


-- --------------------------------------------------------

--
-- Table structure for table `plugin_settings`
--

CREATE TABLE IF NOT EXISTS `plugin_settings` (
  `plugin_name` varchar(80) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `journal_id` bigint(20) NOT NULL,
  `setting_name` varchar(80) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `plugin_settings_pkey` (`plugin_name`,`locale`,`journal_id`,`setting_name`),
  KEY `plugin_settings_plugin_name` (`plugin_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `plugin_settings`
--

INSERT INTO `plugin_settings` (`plugin_name`, `locale`, `journal_id`, `setting_name`, `setting_value`, `setting_type`) VALUES
('coinsplugin', '', 0, 'enabled', '1', 'bool'),
('tinymceplugin', '', 0, 'enabled', '1', 'bool'),
('donationblockplugin', '', 0, 'enabled', '1', 'bool'),
('donationblockplugin', '', 0, 'seq', '5', 'int'),
('donationblockplugin', '', 0, 'context', '2', 'int'),
('helpblockplugin', '', 0, 'enabled', '1', 'bool'),
('helpblockplugin', '', 0, 'seq', '1', 'int'),
('helpblockplugin', '', 0, 'context', '2', 'int'),
('navigationblockplugin', '', 0, 'enabled', '1', 'bool'),
('navigationblockplugin', '', 0, 'seq', '5', 'int'),
('navigationblockplugin', '', 0, 'context', '2', 'int'),
('userblockplugin', '', 0, 'enabled', '1', 'bool'),
('userblockplugin', '', 0, 'seq', '2', 'int'),
('userblockplugin', '', 0, 'context', '2', 'int'),
('notificationblockplugin', '', 0, 'enabled', '1', 'bool'),
('notificationblockplugin', '', 0, 'seq', '3', 'int'),
('notificationblockplugin', '', 0, 'context', '2', 'int'),
('developedbyblockplugin', '', 0, 'enabled', '1', 'bool'),
('developedbyblockplugin', '', 0, 'seq', '0', 'int'),
('developedbyblockplugin', '', 0, 'context', '2', 'int'),
('languagetoggleblockplugin', '', 0, 'enabled', '1', 'bool'),
('languagetoggleblockplugin', '', 0, 'seq', '4', 'int'),
('languagetoggleblockplugin', '', 0, 'context', '2', 'int'),
('fontsizeblockplugin', '', 0, 'enabled', '1', 'bool'),
('fontsizeblockplugin', '', 0, 'seq', '6', 'int'),
('fontsizeblockplugin', '', 0, 'context', '2', 'int'),
('referralplugin', '', 2, 'exclusions', '#^http://www.google.#\n#^http://www.yahoo.#', 'string'),
('referralplugin', '', 2, 'enabled', '1', 'bool'),
('webfeedplugin', '', 2, 'displayItems', '1', 'bool'),
('webfeedplugin', '', 2, 'displayPage', 'homepage', 'string'),
('webfeedplugin', '', 2, 'enabled', '1', 'bool'),
('resolverplugin', '', 2, 'enabled', '1', 'bool'),
('fontsizeblockplugin', '', 2, 'context', '2', 'int'),
('fontsizeblockplugin', '', 2, 'seq', '6', 'int'),
('fontsizeblockplugin', '', 2, 'enabled', '1', 'bool'),
('navigationblockplugin', '', 2, 'context', '2', 'int'),
('navigationblockplugin', '', 2, 'seq', '5', 'int'),
('navigationblockplugin', '', 2, 'enabled', '1', 'bool'),
('donationblockplugin', '', 2, 'context', '2', 'int'),
('donationblockplugin', '', 2, 'seq', '5', 'int'),
('donationblockplugin', '', 2, 'enabled', '1', 'bool'),
('languagetoggleblockplugin', '', 2, 'context', '2', 'int'),
('languagetoggleblockplugin', '', 2, 'seq', '4', 'int'),
('languagetoggleblockplugin', '', 2, 'enabled', '1', 'bool'),
('notificationblockplugin', '', 2, 'context', '2', 'int'),
('notificationblockplugin', '', 2, 'seq', '3', 'int'),
('notificationblockplugin', '', 2, 'enabled', '1', 'bool'),
('userblockplugin', '', 2, 'context', '2', 'int'),
('userblockplugin', '', 2, 'seq', '2', 'int'),
('userblockplugin', '', 2, 'enabled', '1', 'bool'),
('helpblockplugin', '', 2, 'context', '2', 'int'),
('helpblockplugin', '', 2, 'enabled', '1', 'bool'),
('helpblockplugin', '', 2, 'seq', '1', 'int'),
('developedbyblockplugin', '', 2, 'context', '2', 'int'),
('developedbyblockplugin', '', 2, 'seq', '0', 'int'),
('developedbyblockplugin', '', 2, 'enabled', '1', 'bool'),
('subscriptionblockplugin', '', 2, 'context', '2', 'int'),
('subscriptionblockplugin', '', 2, 'seq', '2', 'int'),
('subscriptionblockplugin', '', 2, 'enabled', '1', 'bool'),
('roleblockplugin', '', 2, 'context', '2', 'int'),
('roleblockplugin', '', 2, 'seq', '3', 'int'),
('roleblockplugin', '', 2, 'enabled', '1', 'bool'),
('informationblockplugin', '', 2, 'context', '2', 'int'),
('informationblockplugin', '', 2, 'seq', '7', 'int'),
('informationblockplugin', '', 2, 'enabled', '1', 'bool'),
('tinymceplugin', '', 2, 'enabled', '1', 'bool');

-- --------------------------------------------------------

--
-- Table structure for table `processes`
--

CREATE TABLE IF NOT EXISTS `processes` (
  `process_id` varchar(23) NOT NULL,
  `process_type` tinyint(4) NOT NULL,
  `time_started` bigint(20) NOT NULL,
  `obliterated` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `processes_pkey` (`process_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `processes`
--


-- --------------------------------------------------------

--
-- Table structure for table `proposal_types`
--

CREATE TABLE IF NOT EXISTS `proposal_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `proposal_types`
--

INSERT INTO `proposal_types` (`id`, `type`) VALUES
(1, 'Clinical Trial with Human Subjects'),
(2, 'Proposals With Human Subjects'),
(3, 'Proposals Without Human Subjects');

-- --------------------------------------------------------

--
-- Table structure for table `published_articles`
--

CREATE TABLE IF NOT EXISTS `published_articles` (
  `pub_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `issue_id` bigint(20) NOT NULL,
  `date_published` datetime NOT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `views` int(11) NOT NULL DEFAULT '0',
  `access_status` tinyint(4) NOT NULL DEFAULT '0',
  `public_article_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pub_id`),
  UNIQUE KEY `published_articles_article_id` (`article_id`),
  KEY `published_articles_issue_id` (`issue_id`),
  KEY `published_articles_public_article_id` (`public_article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `published_articles`
--


-- --------------------------------------------------------

--
-- Table structure for table `queued_payments`
--

CREATE TABLE IF NOT EXISTS `queued_payments` (
  `queued_payment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date_created` datetime NOT NULL,
  `date_modified` datetime NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `payment_data` text,
  PRIMARY KEY (`queued_payment_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `queued_payments`
--


-- --------------------------------------------------------

--
-- Table structure for table `referrals`
--

CREATE TABLE IF NOT EXISTS `referrals` (
  `referral_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `url` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL,
  `link_count` bigint(20) NOT NULL,
  PRIMARY KEY (`referral_id`),
  UNIQUE KEY `referral_article_id` (`article_id`,`url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `referrals`
--


-- --------------------------------------------------------

--
-- Table structure for table `referral_settings`
--

CREATE TABLE IF NOT EXISTS `referral_settings` (
  `referral_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `referral_settings_pkey` (`referral_id`,`locale`,`setting_name`),
  KEY `referral_settings_referral_id` (`referral_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `referral_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `review_assignments`
--

CREATE TABLE IF NOT EXISTS `review_assignments` (
  `review_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `submission_id` bigint(20) NOT NULL,
  `reviewer_id` bigint(20) NOT NULL,
  `competing_interests` text,
  `regret_message` text,
  `recommendation` tinyint(4) DEFAULT NULL,
  `date_assigned` datetime DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `date_confirmed` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `date_acknowledged` datetime DEFAULT NULL,
  `date_due` datetime DEFAULT NULL,
  `date_response_due` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `reminder_was_automatic` tinyint(4) NOT NULL DEFAULT '0',
  `declined` tinyint(4) NOT NULL DEFAULT '0',
  `replaced` tinyint(4) NOT NULL DEFAULT '0',
  `cancelled` tinyint(4) NOT NULL DEFAULT '0',
  `reviewer_file_id` bigint(20) DEFAULT NULL,
  `date_rated` datetime DEFAULT NULL,
  `date_reminded` datetime DEFAULT NULL,
  `quality` tinyint(4) DEFAULT NULL,
  `review_type` tinyint(4) NOT NULL DEFAULT '1',
  `review_method` tinyint(4) NOT NULL DEFAULT '1',
  `round` tinyint(4) NOT NULL DEFAULT '1',
  `step` tinyint(4) NOT NULL DEFAULT '1',
  `review_form_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `review_assignments_submission_id` (`submission_id`),
  KEY `review_assignments_reviewer_id` (`reviewer_id`),
  KEY `review_assignments_form_id` (`review_form_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `review_assignments`
--


-- --------------------------------------------------------

--
-- Table structure for table `review_forms`
--

CREATE TABLE IF NOT EXISTS `review_forms` (
  `review_form_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `seq` double DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`review_form_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `review_forms`
--

INSERT INTO `review_forms` (`review_form_id`, `assoc_type`, `assoc_id`, `seq`, `is_active`) VALUES
(2, 256, 2, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `review_form_elements`
--

CREATE TABLE IF NOT EXISTS `review_form_elements` (
  `review_form_element_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `review_form_id` bigint(20) NOT NULL,
  `seq` double DEFAULT NULL,
  `element_type` bigint(20) DEFAULT NULL,
  `required` tinyint(4) DEFAULT NULL,
  `included` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`review_form_element_id`),
  KEY `review_form_elements_review_form_id` (`review_form_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `review_form_elements`
--

INSERT INTO `review_form_elements` (`review_form_element_id`, `review_form_id`, `seq`, `element_type`, `required`, `included`) VALUES
(8, 2, 4, 5, 1, 0),
(7, 2, 3, 5, 1, 0),
(6, 2, 2, 5, 1, 0),
(5, 2, 1, 5, 1, 0),
(9, 2, 5, 3, 1, 0),
(10, 2, 6, 4, 1, 0),
(11, 2, 7, 3, 0, 0),
(12, 2, 8, 5, 1, 0),
(13, 2, 9, 5, 1, 0),
(14, 2, 10, 5, 1, 0),
(15, 2, 11, 5, 1, 0),
(16, 2, 12, 3, 1, 0),
(17, 2, 13, 5, 1, 0),
(18, 2, 14, 5, 1, 0),
(19, 2, 15, 4, 1, 0),
(20, 2, 16, 5, 1, 0),
(21, 2, 17, 3, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `review_form_element_settings`
--

CREATE TABLE IF NOT EXISTS `review_form_element_settings` (
  `review_form_element_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `review_form_element_settings_pkey` (`review_form_element_id`,`locale`,`setting_name`),
  KEY `review_form_element_settings_review_form_element_id` (`review_form_element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `review_form_element_settings`
--

INSERT INTO `review_form_element_settings` (`review_form_element_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(6, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(7, 'en_US', 'question', 'Will the research contribute to generalizable knowledge and is it worth exposing human research participants to risk?', 'string'),
(5, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(6, 'en_US', 'question', 'Is the study design appropriate to prove the hypothesis or answer the research question?', 'string'),
(5, 'en_US', 'question', 'Is the hypothesis or research question clear? Is it clearly stated?', 'string'),
(7, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(8, 'en_US', 'question', '<p>What does the WPRO-ERC consider the level of risk to be?</p><p><strong><em>Note</em></strong>: <em>Minimal risk means that the probability and magnitude of harm</em><br /><em>or discomfort anticipated in the research are not greater in and of</em><br /><em>themselves than those ordinarily encountered in the daily life or during</em><br /><em>the performance of routine physical or psychological examination or</em><br /><em>tests.</em></p>', 'string'),
(9, 'en_US', 'question', 'What does PI consider the level of risk/discomfort/inconvenience to be?', 'string'),
(10, 'en_US', 'question', '<p>Is there prospect of direct benefit to human research participants?</p><p><em><strong>Note:</strong></em><span style="font-family: mceinline;"> </span><em>A research benefit is considered to be something of a healthrelated,</em> <em>psychosocial, or other value to an individual research subject,</em> <em>or something that will contribute to the acquisition of generalizable </em><em>knowledge. Money or  other compensation for participation in research</em> <em>is not considered to be a benefit, but rather compensation for researchrelated</em> <em>inconveniences.</em></p>', 'string'),
(10, 'en_US', 'possibleResponses', 'a:3:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:151:"No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge about the  participants’ disorder or condition.";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:180:"No prospect of direct benefit to individual participants, but likely to yield generalizable knowledge to further society’s understanding or the disorder or condition under study.";}i:2;a:2:{s:5:"order";s:1:"3";s:7:"content";s:81:"The research involves the prospect of direct benefit to  individual participants.";}}', 'object'),
(8, 'en_US', 'possibleResponses', 'a:3:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:59:"The research involves no more than minimal risk to subject.";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:118:"The research involves more than minimal risk to subjects. (The risk(s) represents a minor increase over minimal risk.)";}i:2;a:2:{s:5:"order";s:1:"3";s:7:"content";s:129:"The research involves more than minimal risk to subjects. (The risk(s) represents more than a minor increase over\r\nminimal risk.)";}}', 'object'),
(11, 'en_US', 'question', 'Who is to be enrolled? Men? Women? Ethnic Minorities? Children (rationale for inclusion/ exclusion addressed)? Seriously ill patients? Healthy volunteers?', 'string'),
(12, 'en_US', 'question', 'Are these research participants appropriate for the protocol?', 'string'),
(12, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(13, 'en_US', 'question', 'Are appropriate protection in place for vulnerable participants, e.g. pregnant women, socially or economically disadvantaged, decisionally impaired,  subjects in special situations e.g. doc-patient relationship making them more<br />vulnerable?', 'string'),
(13, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(14, 'en_US', 'question', 'Is the informed consent document include all the required elements?', 'string'),
(14, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(15, 'en_US', 'question', 'Is the consent document understandable to participants?', 'string'),
(15, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(16, 'en_US', 'question', 'Who will obtain the consent (PI, nurse, other?) &amp; in what setting?', 'string'),
(17, 'en_US', 'question', 'Is WPRO-ERC requested to waive or alter any informed consent requirements?', 'string'),
(17, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(18, 'en_US', 'question', 'Does the research design minimize risks to subjects?', 'string'),
(18, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(19, 'en_US', 'question', 'Would use of a data and safety monitoring board or other research oversight process enhance subject safety?', 'string'),
(19, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(20, 'en_US', 'question', 'Will personally-identifiable research data be protected to the extent possible from access or use?', 'string'),
(20, 'en_US', 'possibleResponses', 'a:2:{i:0;a:2:{s:5:"order";s:1:"1";s:7:"content";s:3:"Yes";}i:1;a:2:{s:5:"order";s:1:"2";s:7:"content";s:2:"No";}}', 'object'),
(21, 'en_US', 'question', 'Are any special privacy and confidentiality issues properly addressed, e.g. use of genetic information?', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `review_form_responses`
--

CREATE TABLE IF NOT EXISTS `review_form_responses` (
  `review_form_element_id` bigint(20) NOT NULL,
  `review_id` bigint(20) NOT NULL,
  `response_type` varchar(6) DEFAULT NULL,
  `response_value` text,
  KEY `review_form_responses_pkey` (`review_form_element_id`,`review_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `review_form_responses`
--


-- --------------------------------------------------------

--
-- Table structure for table `review_form_settings`
--

CREATE TABLE IF NOT EXISTS `review_form_settings` (
  `review_form_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `review_form_settings_pkey` (`review_form_id`,`locale`,`setting_name`),
  KEY `review_form_settings_review_form_id` (`review_form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `review_form_settings`
--

INSERT INTO `review_form_settings` (`review_form_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(2, 'en_US', 'title', 'Regulatory Review Requirement', 'string'),
(2, 'en_US', 'description', '', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `review_rounds`
--

CREATE TABLE IF NOT EXISTS `review_rounds` (
  `submission_id` bigint(20) NOT NULL,
  `round` tinyint(4) NOT NULL,
  `review_revision` bigint(20) DEFAULT NULL,
  `review_type` bigint(20) DEFAULT NULL,
  `status` bigint(20) DEFAULT NULL,
  UNIQUE KEY `review_rounds_pkey` (`submission_id`,`round`,`review_type`),
  KEY `review_rounds_submission_id` (`submission_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `review_rounds`
--


-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  UNIQUE KEY `roles_pkey` (`journal_id`,`user_id`,`role_id`),
  KEY `roles_journal_id` (`journal_id`),
  KEY `roles_user_id` (`user_id`),
  KEY `roles_role_id` (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`journal_id`, `user_id`, `role_id`) VALUES
(0, 1, 1),
(2, 1, 16),
(2, 2, 65536),
(2, 3, 256),
(2, 3, 512),
(2, 4, 4096);

-- --------------------------------------------------------

--
-- Table structure for table `rt_contexts`
--

CREATE TABLE IF NOT EXISTS `rt_contexts` (
  `context_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version_id` bigint(20) NOT NULL,
  `title` varchar(120) NOT NULL,
  `abbrev` varchar(32) NOT NULL,
  `description` text,
  `cited_by` tinyint(4) NOT NULL DEFAULT '0',
  `author_terms` tinyint(4) NOT NULL DEFAULT '0',
  `define_terms` tinyint(4) NOT NULL DEFAULT '0',
  `geo_terms` tinyint(4) NOT NULL DEFAULT '0',
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`context_id`),
  KEY `rt_contexts_version_id` (`version_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=495 ;

--
-- Dumping data for table `rt_contexts`
--

INSERT INTO `rt_contexts` (`context_id`, `version_id`, `title`, `abbrev`, `description`, `cited_by`, `author_terms`, `define_terms`, `geo_terms`, `seq`) VALUES
(373, 29, 'Databases', 'Databases', 'Databases', 0, 0, 0, 0, 8),
(374, 29, 'Relevant portals', 'Relevant portals', 'Relevant portals', 0, 0, 0, 0, 9),
(371, 29, 'Multimedia', 'Multimedia', 'Multimedia content', 0, 0, 0, 0, 6),
(372, 29, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 7),
(368, 29, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(369, 29, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 4),
(370, 29, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(367, 29, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(366, 29, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(365, 29, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(364, 28, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(360, 28, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 8),
(361, 28, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 9),
(362, 28, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 10),
(363, 28, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(379, 30, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(377, 29, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(378, 30, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(376, 29, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(375, 29, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 10),
(330, 26, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(328, 25, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(329, 26, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(326, 25, 'Resources', 'Resources', 'General Resources', 0, 0, 0, 0, 9),
(327, 25, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(325, 25, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 8),
(324, 25, 'Quotations', 'Quotations', 'Search familiear or famous quotation resources on the Internet', 0, 0, 0, 0, 7),
(323, 25, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(321, 25, 'Book reviews', 'Book reviews', 'Check online scholary book review resources.', 0, 0, 0, 0, 4),
(322, 25, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 5),
(319, 25, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 2),
(320, 25, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(316, 24, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 14),
(317, 25, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(318, 25, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(348, 27, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 7),
(346, 27, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 5),
(347, 27, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(343, 27, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(344, 27, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(345, 27, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 4),
(342, 27, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(340, 26, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(341, 27, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(331, 26, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(332, 26, 'Databases', 'Databases', 'Databases', 0, 0, 0, 0, 3),
(333, 26, 'Math theory', 'Math theory', 'Access to glossary of terms ranges from undergraduate to research level.', 0, 0, 0, 0, 4),
(334, 26, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 5),
(335, 26, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 6),
(336, 26, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(337, 26, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(338, 26, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(339, 26, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(414, 32, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(413, 32, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(412, 32, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(411, 32, 'Multimedia', 'Multimedia', 'Multimedia resources for Cognitive Sciences', 0, 0, 0, 0, 7),
(410, 32, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(359, 28, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 7),
(357, 28, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 5),
(358, 28, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 6),
(356, 28, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 4),
(355, 28, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 3),
(354, 28, 'e-Journals', 'e-Journals', 'Electronic Journals', 0, 0, 0, 0, 2),
(351, 27, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 10),
(352, 28, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(353, 28, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(350, 27, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(349, 27, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 8),
(315, 24, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 13),
(314, 24, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 12),
(313, 24, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(312, 24, 'Multimedia', 'Multimedia', 'Multimedia resources', 0, 0, 0, 0, 10),
(311, 24, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 9),
(308, 24, 'Tech. reports', 'Tech. reports', 'Provide gateway to technical report collections.', 0, 0, 0, 0, 6),
(309, 24, 'Patents', 'Patents', 'Access to Canada, U.S. and Europe patent information.', 0, 0, 0, 0, 7),
(310, 24, 'Standards', 'Standards', 'Access to standards information that is frequently consulted by computer scientists.', 0, 0, 0, 0, 8),
(307, 24, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(305, 24, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(306, 24, 'Databases', 'Databases', 'Databases containing information related to Computing Science', 0, 0, 0, 0, 4),
(304, 24, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(293, 23, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 7),
(294, 23, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 8),
(295, 23, 'Relevant portals', 'Relevant portals', 'Relevant portals', 0, 0, 0, 0, 9),
(296, 23, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 10),
(297, 23, 'Related texts', 'Related texts', 'Provide online access to full text resources in Humanities.', 0, 0, 0, 0, 11),
(298, 23, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 12),
(299, 23, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 13),
(300, 23, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 14),
(301, 23, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 15),
(302, 24, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(303, 24, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(291, 23, 'Book reviews', 'Book reviews', 'Click on the search urls to check for book reviews.', 0, 0, 0, 0, 5),
(292, 23, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 6),
(290, 23, 'Lit critics', 'Literary Critics', 'Search critical and biographical websites about authors and their works that can be browsed by author, by title, or by nationality and literary period.', 0, 0, 0, 0, 4),
(288, 23, 'Gov''t policy', 'Gov''t policy', 'Check various government resources.', 0, 0, 0, 0, 2),
(289, 23, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(287, 23, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(286, 23, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(285, 22, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 13),
(283, 22, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 11),
(284, 22, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 12),
(282, 22, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(281, 22, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 9),
(278, 22, 'Government health sites', 'Gov Health Sites', 'Access to health information resources provided by govenment.', 0, 0, 0, 0, 6),
(279, 22, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 7),
(280, 22, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 8),
(277, 22, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(274, 22, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(275, 22, 'Multimedia', 'Multimedia', 'Multimedia content', 0, 0, 0, 0, 3),
(276, 22, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 4),
(273, 22, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(272, 22, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(271, 21, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 10),
(269, 21, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 8),
(270, 21, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(394, 31, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 2),
(392, 31, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(393, 31, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 1),
(390, 30, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 12),
(391, 30, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 13),
(389, 30, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 11),
(388, 30, 'Relevant portals', 'Relevant portals', 'Education-related Portals', 0, 0, 0, 0, 10),
(387, 30, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(386, 30, 'Multimedia', 'Multimedia', 'Multimedia Content', 0, 0, 0, 0, 8),
(385, 30, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(380, 30, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(381, 30, 'e-Journals', 'e-Journals', 'Provide pop-up window for entering open-access and full-text e-Journals relevant to your field.', 0, 0, 0, 0, 3),
(382, 30, 'Related theory', 'Related theory', 'Access to published scholarly articles and studies in the foundations of education, and in related disciplines outside the field of education, which contribute to the advancement of educational theory.', 0, 0, 0, 0, 4),
(383, 30, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 5),
(384, 30, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 6),
(447, 35, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(448, 35, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 4),
(446, 35, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(444, 35, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(445, 35, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(443, 34, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 15),
(430, 34, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(429, 34, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(428, 34, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(427, 33, 'Web search', 'Web search', 'Enter search terms for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(426, 33, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(425, 33, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 9),
(424, 33, 'Data sets', 'Data sets', 'Provides access to agricultural statistics.', 0, 0, 0, 0, 8),
(423, 33, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(422, 33, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 6),
(419, 33, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 3),
(420, 33, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 4),
(421, 33, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 5),
(415, 32, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(416, 33, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(417, 33, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(418, 33, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(467, 36, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(466, 36, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(464, 36, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(465, 36, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(463, 36, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(268, 21, 'Data sets', 'Data sets', 'Provides access to statistics in environmental studies.', 0, 0, 0, 0, 7),
(265, 21, 'Relevant portals', 'Relevant portals', 'Environmental resource portals', 0, 0, 0, 0, 4),
(266, 21, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 5),
(267, 21, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 6),
(264, 21, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 3),
(263, 21, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(262, 21, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(261, 21, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(260, 20, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(259, 20, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(258, 20, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 10),
(257, 20, 'Multimedia', 'Multimedia', 'Multimedia content', 0, 0, 0, 0, 9),
(256, 20, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(254, 20, 'Directories', 'Directories', 'Access to information of research institutions', 0, 0, 0, 0, 6),
(255, 20, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(248, 20, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(249, 20, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box. You can also type or paste a word into the box. Then use the search function to find a definition for the word. These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(250, 20, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(251, 20, 'Relevant portals', 'Relevant portals', 'General Science resource portals', 0, 0, 0, 0, 3),
(252, 20, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 4),
(253, 20, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(454, 35, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(453, 35, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(452, 35, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 8),
(449, 35, 'Multimedia', 'Multimedia', 'Multimedia Resources', 0, 0, 0, 0, 5),
(450, 35, 'Astro data', 'Astro data', 'Provide access to astronomy data.', 0, 0, 0, 0, 6),
(451, 35, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 7),
(441, 34, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 13),
(442, 34, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 14),
(440, 34, 'Legal materials', 'Legal materials', 'Porvides free Internet access to legal materials of major countries.', 0, 0, 0, 0, 12),
(439, 34, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 11),
(438, 34, 'Relevant portals', 'Relevant portals', 'Relevant portals', 0, 0, 0, 0, 10),
(435, 34, 'Social theories', 'Social theories', 'Search sites contain information on social theories.', 0, 0, 0, 0, 7),
(436, 34, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 8),
(437, 34, 'Databases', 'Databases', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 9),
(434, 34, 'Soc sci data', 'Soc sci data', 'Provides access to a vast archive of social science data for research and instruction.', 0, 0, 0, 0, 6),
(433, 34, 'Surveys', 'Surveys', 'Access to important surveys in social science.', 0, 0, 0, 0, 5),
(431, 34, 'Book reviews', 'Book reviews', 'Click on the search urls to check for book reviews.', 0, 0, 0, 0, 3),
(432, 34, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 4),
(409, 32, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(408, 32, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 4),
(406, 32, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(407, 32, 'Cognitive theory', 'Cognitive theory', 'Check the encyclopedic entries to give you the foundationof cognitive theory.', 0, 0, 0, 0, 3),
(404, 32, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(405, 32, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(403, 31, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 11),
(402, 31, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(401, 31, 'Government policy', 'Gov Policy', 'Access to Information and services gateway run by the Government of the United States and Canada.', 0, 0, 0, 0, 9),
(399, 31, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 7),
(400, 31, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 8),
(395, 31, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 3),
(396, 31, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 4),
(397, 31, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 5),
(398, 31, 'e-Journals', 'e-Journals', 'Provide pop-up window for entering open-access and full-text e-Journals relevant to your field.', 0, 0, 0, 0, 6),
(462, 36, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 6),
(461, 36, 'Relevant portals', 'Relevant portals', 'Portals related to chemistry', 0, 0, 0, 0, 5),
(459, 36, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 3),
(460, 36, 'Databases', 'Databases', 'Provide access to open-access abstract and/or full-text databases.', 0, 0, 0, 0, 4),
(458, 36, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(457, 36, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(455, 35, 'Web search', 'Web search', 'Enter a search term for Internet resources through Google search engine.', 0, 0, 0, 0, 11),
(456, 36, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(468, 37, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(469, 37, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(470, 37, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 2),
(471, 37, 'Working papers', 'Working papers', 'Search the largest online, free research paper collections in economics.', 0, 0, 0, 0, 3),
(472, 37, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 4),
(473, 37, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 5),
(474, 37, 'Nat''l statistics', 'Nat''l statistics', 'Provides access to statistics in economic studies.', 0, 0, 0, 0, 6),
(475, 37, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 7),
(476, 37, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 8),
(477, 37, 'Teaching files', 'Instructional', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 9),
(478, 37, 'Government policy', 'Gov Policy', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 10),
(479, 37, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 11),
(480, 37, 'Web search', 'Web search', 'Enter a search term for Internet resources through various search engines.', 0, 0, 0, 0, 12),
(481, 38, 'Author''s work', 'Other Works', 'Identify other works by the article''s author(s) by using OAI engines.', 0, 1, 0, 0, 0),
(482, 38, 'Look up terms', 'Look up terms', 'Double click on any word in the text and it will appear in the "Definition of terms" box.  You can also type or paste a word into the box.  Then use the search function to find a definition for the word.  These resources have been selected because of their relevance and their open (free) access to all or part of their contents.', 0, 0, 1, 0, 1),
(483, 38, 'Related studies', 'Related studies', 'Access to related studies by establishing a working link with an open-access (free) database, with abstracts and/or full texts related to your topic.', 0, 0, 0, 0, 2),
(484, 38, 'Government policy', 'Gov Policy', 'Check various government resources.', 0, 0, 0, 0, 3),
(485, 38, 'Book searches', 'Book searches', 'Book-related Resources', 0, 0, 0, 0, 4),
(486, 38, 'Dissertations', 'Dissertations', 'Provides access to a repository of rich graduate educational material contributed by a number of member institutions worldwide.', 0, 0, 0, 0, 5),
(487, 38, 'Relevant portals', 'Relevant portals', 'Offer an entry point to other websites.', 0, 0, 0, 0, 6),
(488, 38, 'Databases', 'Databases', 'Art & Architecture Databases', 0, 0, 0, 0, 7),
(489, 38, 'Online forums', 'Online forums', 'Choose online, open-access online forums that would enrich the context of the research studies on your site.', 0, 0, 0, 0, 8),
(490, 38, 'Pay-per-view', 'Pay-per-view', 'A pay-per-view service is for those who do not have direct access to electronic journal articles via subscriptions. The service allows customers to gain direct access to an article by paying by credit card using the RSC''s secure payment mechanism. Immediately the payment details have been validated, the customer can gain access to the required article file for a period of 30 days.', 0, 0, 0, 0, 9),
(491, 38, 'Teaching files', 'Teaching files', 'Provide educators with quick and easy access to the learning objects and lesson materials found in these databases that would help with the teaching of concepts and materials in their field.', 0, 0, 0, 0, 10),
(492, 38, 'e-Journals', 'e-Journals', 'Electronic Journals', 0, 0, 0, 0, 11),
(493, 38, 'Media reports', 'Media reports', 'Immediately initiates a search based on the subject of the article or paper that connects users to free current and archival articles in the field from leading newspapers around the world.', 0, 0, 0, 0, 12),
(494, 38, 'Web search', 'Web search', 'Enter a search term for Internet resources through Google search engine.', 0, 0, 0, 0, 13);

-- --------------------------------------------------------

--
-- Table structure for table `rt_searches`
--

CREATE TABLE IF NOT EXISTS `rt_searches` (
  `search_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `context_id` bigint(20) NOT NULL,
  `title` varchar(120) NOT NULL,
  `description` text,
  `url` text,
  `search_url` text,
  `search_post` text,
  `seq` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`search_id`),
  KEY `rt_searches_context_id` (`context_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2563 ;

--
-- Dumping data for table `rt_searches`
--

INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(2032, 394, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(2030, 394, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2031, 394, 'Online Dictionary of the Social Sciences', 'Online Dictionary of the Social Sciences is a searchable dictionary of terms commonly used in the social sciences. Both phrase and keyword searches are facilitated.', 'http://bitbucket.icaap.org/', 'http://bitbucket.icaap.org/dict.pl?definition={$formKeywords}', NULL, 1),
(2028, 393, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2029, 393, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2027, 393, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2026, 393, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2025, 392, 'Brint.com', 'Extensive information portal with news, analysis and links related to business, commerce, economics, information technology, and information resources.', 'http://www.brint.com/', 'http://portal.brint.com/cgi-bin/cgsearch/cgsearch.cgi?query={$formKeywords}', NULL, 6),
(2023, 392, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 4),
(2024, 392, 'Intute: Social Sciences', 'Intute: Social Sciences is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 5),
(2022, 392, 'The Corporate Library', 'The Corporate Library is intended to serve as a central repository for research, study and critical thinking about the nature of the modern global corporation, with a special focus on corporate governance and the relationship between company management, their boards and their shareowners. Use this site to retrieve biographies for the companies in the S&P 1500 Supercomposite Index. Screen on a variety of features to identify matching directors (e.g. company name, age, attendance problems, # shares held, etc.) The site also contains research reports on trends in corporate governance.', 'http://www.thecorporatelibrary.com/', 'http://thecorporatelibrary.master.com/texis/master/search/?s=SS&q={$formKeywords}', NULL, 3),
(2021, 392, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(2020, 392, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(2019, 392, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2018, 391, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2017, 391, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2015, 391, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2016, 391, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2014, 390, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(2012, 390, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.themoscowtimes.com/indexes/01.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(2013, 390, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(2011, 390, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(2009, 390, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(2010, 390, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 5),
(2008, 390, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(2005, 390, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2006, 390, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(2007, 390, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=', 'Content=&searchword={$formKeywords}', 2),
(2003, 389, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?ms0=%A0&mt0=all&st=AS&rn=2&parsed=true&db=www-fed-all&mw0={$formKeywords}', NULL, 7),
(2004, 389, 'Canada Site', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(2002, 389, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(2000, 389, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2001, 389, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu/geninfo/query/resultaction.jsp?', 'qtype=simple&Collection=EuropaFull&ResultTemplate=/result_en.jsp&DefaultLG=en&ResultCount=10&html=&QueryText={$formKeywords}', 5),
(1999, 389, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1998, 389, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1997, 389, 'Government of Canada homepage', 'This is the primary internet portal for information on the Government of Canada, its programmes, services, new initiatives and products, and for information about Canada. Among its features are three audience-based gateways that provide access to information and services for: Canadians, Non-Canadians, and Canadian business.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.collectionscanada.ca/fed/searchResults.jsp?SourceQuery=&ResultCount=5&PageNum=1&MaxDocs=-1&SortSpec=score+desc&Language=eng&Sources=amicus&Sources=mikan&Sources=web&QueryText.x=11&QueryText.y=13&QueryText={$formKeywords}', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=&kl=XX&op=a&q={$formKeywords}', 1),
(1996, 389, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1995, 388, 'ENC Online: Eisenhower National Clearinghouse for Mathematics and Science Education', 'Established in 1992 with funding from the U.S. Department of Education, the mission of the clearinghouse is to "acquire and catalog mathematics and science curriculum resources, creating the most comprehensive collection in the nation; provide the best selection of math and science education resources on the Internet; support teachers'' professional development in math, science, and the effective use of technology; serve all K-12 educators, parents, and students with free products and services."\n\nENC.ORG is now goENC.COM!', 'http://www.goenc.com/', 'http://www.goenc.com/search/default.asp?page=1&pagelength=10&grade=G0&resourceType=R0&go=Search&searchText={$formKeywords}', NULL, 5),
(1994, 388, 'Education Development Center', 'The EDC is an international, non-profit organization with more than 335 continuing projects focused on the enhancement of eduThis site''s resources include "free information about K-12 school planning, design, financing, construction, operations and maintenance." The Libraries/Media Centers section includes a bibliography of books and articles covering all aspects of construction management, architecture, and cost estimation. Disaster planning, health, and environmental issues receive consideration. Check the links for other professional organizations, government programs and agencies, research centers, products, and services. Click on Gallery to view project graphics. Searchable.cational methods and initiatives.  The Center''s site includes information related the use of technology in education.', 'http://main.edc.org/', 'http://google2.edc.org/search?site=newsroom&client=edc_main&proxystylesheet=edc_main&output=xml_no_dtd&filter=0&q={$formKeywords}', NULL, 4),
(1993, 388, 'National Clearinghouse for Educational Facilities', 'This site''s resources include "free information about K-12 school planning, design, financing, construction, operations and maintenance." The Libraries/Media Centers section includes a bibliography of books and articles covering all aspects of construction management, architecture, and cost estimation. Disaster planning, health, and environmental issues receive consideration. Check the links for other professional organizations, government programs and agencies, research centers, products, and services. Click on Gallery to view project graphics. Searchable.', 'http://www.edfacilities.org/', 'http://www.edfacilities.org/search/index.cfm', 'RequestTimeout=300&SearchSortField1=NCEFDate&SearchSortOrder1=DESC&SearchScope=All&SearchLogic=AND&SearchKeywords={$formKeywords}', 3),
(1992, 388, 'EdResearch Online', 'The EdResearch Online database hasover 12,000 online education research documents and articles. These form a subset of the Australian Education Index.', 'http://cunningham.acer.edu.au/dbtw-wpd/sample/edresearch.htm', 'http://cunningham.acer.edu.au/dbtw-wpd/exec/dbtwpub.dll', 'MF=&AC=QBE_QUERY&NP=2&RL=0&QF0=AUTHOR | CORPORATE AUTHOR | TITLE | SUBJECTS | ORGANISATIONS | ABSTRACT | GEOGRAPHICAL | ADDED AUTHORS | ADDED CORPORATE | IDENTIFIERS | JOURNAL TITLE | ISSN&TN=edresearchonline&DF=Web_Full&RF=Web_Brief&MR=50&DL=0&QI0={$formKeywords}', 2),
(1991, 388, 'Federal Resources for Educational Excellence', 'Federal Resources For Educational Excellence: More than 30 Federal agencies formed a working group in 1997 to make hundreds of education resources supported by agencies across the U.S. Federal government easier to find. The result of that work is the FREE web site. Subjects include: Arts, Educational technology, Foreign languages, Health and Safety, Language arts, Mathematics, Physical education, Science, Social studies, and Vocational education.', 'http://free.ed.gov/template.cfm?template=About%20FREE', 'http://free.ed.gov/searchres.cfm', 'searchword={$formKeywords}', 1),
(1990, 388, 'National Center for Education Statistics', 'The site of the Department of Education''s major statistical agency has a catalog of publications available, with text and tables from some of the publications.', 'http://nces.ed.gov/', 'http://search.nces.ed.gov/search?output=xml_no_dtd&client=nces&proxystylesheet=nces&site=nces&q={$formKeywords}', NULL, 0),
(1989, 387, 'SMETE', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/public/find/search_results.jhtml?_DARGS=/smete/home_body.jhtml&_D:/smete/forms/SimpleSearchForm.keyword=&/smete/forms/SimpleSearchForm.operation=simpleSearch&_D:/smete/forms/SimpleSearchForm.operation=&&/smete/forms/SimpleSearchForm.keyword={$formKeywords}', NULL, 8),
(1988, 387, 'Merlot', 'Merlot is a free and open resource designed primarily for faculty and students in higher education. With a continually growing collection of online learning materials, peer reviews and assignments, MERLOT helps faculty enhance instruction.', 'http://www.merlot.org/Home.po', 'http://www.merlot.org/merlot/materials.htm?keywords={$formKeywords}', NULL, 7),
(1987, 387, 'Gateway to Educational Materials (GEM)', 'This site offers a one-stop educational resource to Internet lesson plans, curriculum units, and activities pertaining to all K-12 subjects. Users can browse sites by subject or keyword, desired grade or education level. They can also search by subject, keyword, title, and full-text of the site description. Sources include the AskERIC Virtual Library, the Eisenhower National Clearinghouse, Math Forum, Microsoft Encarta, the North Carolina Department of Public Instruction, and the US Department of Education.', 'http://www.thegateway.org/', 'http://64.119.44.148/portal_seamarksearch/makesearch?isliteral=yes&operator=contains&form.submitted=1&dimension=fulltext&ss=Go&value={$formKeywords}', NULL, 6),
(1985, 387, 'Community Learning Network', 'Community Learning Network is designed to help K-12 teachers integrate technology into the classroom.', 'http://www.cln.org/', 'http://www.openschool.bc.ca/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=htdig_cln&restrict2=&submit2=Search&words={$formKeywords}', NULL, 4),
(1986, 387, 'Educational Media Reviews Online', 'Educational Media Reviews Online is a database of video, DVD, and CD-ROM reviews on materials from major educational and documentary distributors. The reviews are written primarily by librarians and teaching faculty in institutions across the United States and Canada.', 'http://libweb.lib.buffalo.edu/emro/about.asp', 'http://libweb.lib.buffalo.edu/emro/EmroResults.asp?Title=&Subject=%25&Reviewer=&Year=%25&Rating=%25&Distributor=&Format=%25&Submit=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0&Keyword={$formKeywords}', NULL, 5),
(1984, 387, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', NULL, 3),
(1983, 387, 'Marco Polo', 'MarcoPolo: Internet Content for the Classroom is a nonprofit consortium of premier national and international education organizations and the MCI Foundation dedicated to providing the highest quality Internet content and professional development to teachers and students throughout the United States.', 'http://www.marcopolo-education.org/', 'http://www.marcopolosearch.org/mpsearch/Search_Results.asp?orgn_id=2&log_type=1&hdnFilter=&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 2),
(1981, 387, 'BBC Learning', 'BBC Online - Education BBC Education. Access to excellent learning resources for adults and children. Lots of subjects - history, science, languages, health, work skills, culture, technology, arts, literature, business, nature, life, leisure.', 'http://www.bbc.co.uk/learning', 'http://www.bbc.co.uk/cgi-bin/search/results.pl?go.x=0&go.y=0&go=go&uri=%2Flearning%2F&q={$formKeywords}', NULL, 0),
(1982, 387, 'Educator''s Reference Desk', 'The people who created AskERIC announce a new service and name to access the resources you''ve come to depend on for over a decade. While the U.S. Department of Education will discontinue the AskERIC service December 19th, you will still have access to the resources you''ve come to depend upon. Through The Educator''s Reference Desk (http://www.eduref.org) you can access AskERIC''s 2,000+ lesson plans, 3,000+ links to online education information, and 200+ question archive responses. While the question answer service will no longer be active, The Educator''s Reference Desk provides a search interface to the ERIC Databases, providing access to over one million bibliographic records on educational research, theory, and practice.', 'http://www.eduref.org/', 'http://www.google.com/search?&q=site%3Awww.eduref.org+{$formKeywords}', NULL, 1),
(1980, 386, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(1979, 385, 'JISCmail', 'The National Academic Mailing List Service, known as ''JISCmail'', is one of a number of JANET services provided by JANET(UK) (www.ja.net) and funded by the JISC (www.jisc.ac.uk) to benefit learning, teaching and research communities. The Science and Technology Facilities Council (www.scitech.ac.uk) currently operates and develops the JISCmail service on behalf of JANET(UK).', 'http://www.jiscmail.ac.uk/index.htm', 'http://www.jiscmail.ac.uk/cgi-bin/listsearcher.cgi?', 'chk_wds=chk_wds&opt=listsearcher&thecriteria={$formKeywords}', 1),
(1978, 385, 'H-Net, Humanities & Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www2.h-net.msu.edu/lists/', 'http://www2.h-net.msu.edu/logsearch/index.cgi?type=boolean&hitlimit=25&field=&nojg=on&smonth=00&syear=1989&emonth=11&eyear=2004&order=relevance&phrase={$formKeywords}', NULL, 0),
(1976, 384, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1977, 384, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(1975, 384, 'ebrary', 'Independent researchers who do not have access to ebrary''s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1974, 384, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingentaconnect.com/', 'http://www.ingentaconnect.com/search?form_name=advanced&title_type=tka&author=&journal=&journal_type=words&volume=&issue=&database=1&year_from=2002&year_to=2007&pageSize=20&x=42&y=13&title={$formKeywords}', NULL, 0),
(1973, 383, 'Education Review (ER)', 'Education Review publishes reviews of recent books in education, covering the entire range of education scholarship and practice.', 'http://edrev.asu.edu/index.html', 'http://edrev.asu.edu/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=edrev.asu.edu&restrict=&exclude=&words={$formKeywords}', NULL, 6),
(1971, 383, 'SearchERIC', 'Tools to search the abstracts and Digests produced by the ERICSM system.', 'http://www.eric.ed.gov/', 'http://www.google.com/custom?domains=www.eric.ed.gov&sa=Google+Search&sitesearch=www.eric.ed.gov&q={$formKeywords}', NULL, 4),
(1972, 383, 'ERIC - Education Resources Information Center', 'ERIC - the Education Resources Information Center - is an internet-based digital library of education research and information sponsored by the Institute of Education Sciences (IES) of the U.S. Department of Education. \n\nERIC provides access to bibliographic records of journal and non-journal literature indexed from 1966 to the present. \n\nThe ERIC collection includes bibliographic records (citations, abstracts, and other pertinent data) for more than 1.2 million items indexed since 1966, including journal articles, books,  research syntheses, conference papers, technical reports, \npolicy papers, and other education-related materials.\n\nERIC currently indexes more than 600 journals, the majority of which are indexed comprehensively — every article in each issue is included in ERIC. Some journals are indexed selectively — only those articles that are education-related are selected for indexing. \n\nIn addition, contributors have given ERIC permission to display more than 115,000 full-text materials in PDF format - at no charge. These materials are generally part of the recent "grey literature" such as conference papers and reports, rather than journal articles and books. Most materials published 2004 and forward include links to other sources, including publishers'' Web sites.', 'http://eric.ed.gov/', 'http://eric.ed.gov/ERICWebPortal/Home.portal?_nfpb=true&ERICExtSearch_SearchType_0=kw&_pageLabel=ERICSearchResult&newSearch=true&rnd=1189800475852&searchtype=keyword&ERICExtSearch_SearchValue_0={$formKeywords}', NULL, 5),
(1970, 383, 'Education-Line: Electronic Texts in Education and Training', 'Education-Line: Electronic Texts in Education and Training (UK) is a searchable "electronic archive of ''gray'' (report, conference, working paper) and ''pre-print'' literature in the field of education and training." Provided by the British Education Index (BEI), this database provides access to over 1,000 papers presented at British research conferences and elsewhere. Provides links to searchable paper files from conferences sponsored by the British Educational Research Association, the European Conference on Educational Research, and others.', 'http://www.leeds.ac.uk/educol/', 'http://brs.leeds.ac.uk/cgi-bin/brs_engine?*ID=1&*DB=BEID&*PT=50&*FT=BEID&*HI=Y&TITL=&AUTH=&SUBJ=&*SO=TITL&SUBMIT_BUTTON=search%20button&*QQ={$formKeywords}', NULL, 3),
(1969, 383, 'ED Pubs Online Ordering System', 'ED Pubs Online Ordering System is intended to help users identify and order U.S. Department of Education products. All publications are provided at no cost to the general public by the U.S. Department of Education. ', 'http://www.edpubs.org/webstore/Content/search.asp', 'http://www.edpubs.org/webstore/EdSearch/SearchResults.asp?Search=True&CQQUERYTYPE=2&CQFULLTEXT={$formKeywords}', NULL, 2),
(1923, 376, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(1924, 377, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1925, 377, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1926, 377, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1927, 377, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1928, 378, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1929, 378, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://www.oaister.org/', 'http://quod.lib.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&rgn1=entire+record&rgn2=entire+record&rgn3=entire+record&c=oaister&sid=f4f5644c4d1d4282010da7f16b531fb9&searchfield=Entire+Record&op2=And&searchfield=Entire+Record&q2=&op3=And&searchfield=Entire+Record&q3=&op6=And&rgn6=norm&restype=all+types&sort=title&submit2=search&q1={$formKeywords}', NULL, 1),
(1930, 378, 'SearchERIC', 'Tools to search the abstracts and Digests produced by the ERICSM system.', 'http://www.eric.ed.gov/', 'http://www.google.com/custom?domains=www.eric.ed.gov&sa=Google+Search&sitesearch=www.eric.ed.gov&q={$formKeywords}', NULL, 2),
(1931, 378, 'ERIC - Education Resources Information Center', 'ERIC - the Education Resources Information Center - is an internet-based digital library of education research and information sponsored by the Institute of Education Sciences (IES) of the U.S. Department of Education. \n\nERIC provides access to bibliographic records of journal and non-journal literature indexed from 1966 to the present. \n\nThe ERIC collection includes bibliographic records (citations, abstracts, and other pertinent data) for more than 1.2 million items indexed since 1966, including journal articles, books,  research syntheses, conference papers, technical reports, \npolicy papers, and other education-related materials.\n\nERIC currently indexes more than 600 journals, the majority of which are indexed comprehensively — every article in each issue is included in ERIC. Some journals are indexed selectively — only those articles that are education-related are selected for indexing. \n\nIn addition, contributors have given ERIC permission to display more than 115,000 full-text materials in PDF format - at no charge. These materials are generally part of the recent "grey literature" such as conference papers and reports, rather than journal articles and books. Most materials published 2004 and forward include links to other sources, including publishers'' Web sites.', 'http://eric.ed.gov/', 'http://eric.ed.gov/ERICWebPortal/Home.portal?_nfpb=true&ERICExtSearch_Operator_2=and&ERICExtSearch_SearchType_0=au&ERICExtSearch_SearchValue_2=&ERICExtSearch_SearchValue_1=&ERICExtSearch_Operator_1=and&ERICExtSearch_SearchType_1=kw&ERICExtSearch_PubDate_To=2006&ERICExtSearch_SearchType_2=kw&ERICExtSearch_SearchCount=2&ERICExtSearch_PubDate_From=0&_pageLabel=ERICSearchResult&newSearch=true&rnd=1137305171346&searchtype=advanced&ERICExtSearch_SearchValue_0={$formKeywords}', NULL, 3),
(1932, 378, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(1933, 378, 'Education-Line: Electronic Texts in Education and Training', 'Education-Line: Electronic Texts in Education and Training (UK) is a searchable "electronic archive of ''gray'' (report, conference, working paper) and ''pre-print'' literature in the field of education and training." Provided by the British Education Index (BEI), this database provides access to over 1,000 papers presented at British research conferences and elsewhere. Provides links to searchable paper files from conferences sponsored by the British Educational Research Association, the European Conference on Educational Research, and others.', 'http://www.leeds.ac.uk/educol/', 'http://brs.leeds.ac.uk/cgi-bin/brs_engine?*ID=1&*DB=BEID&*PT=50&*FT=BEID&*HI=Y&TITL=&SUBJ=&*SO=TITL&SUBMIT_BUTTON=search%20button&*QQ=&AUTH={$formKeywords}', NULL, 5),
(1934, 379, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1935, 379, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 1),
(1936, 379, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 2),
(1937, 379, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 3),
(1938, 379, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 4),
(1939, 380, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1940, 380, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1941, 380, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://67.118.51.201/bol/KeyWordSearch.cfm', 'RowCount=50&Searchquery={$formKeywords}', 2),
(1942, 380, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(1943, 381, 'Advancing Women in Leadership Journal [USA]', 'Advancing Women in Leadership represents the first on-line professional, refereed journal for women in leadership. The journal publishes manuscripts that report, synthesize, review, or analyze scholarly inquiry that focuses on women''s issues.', 'http://www.advancingwomen.com/awl/awl.html', 'http://www.google.com/search?&q=site%3Awww.advancingwomen.com+{$formKeywords}', NULL, 0),
(1944, 381, 'Educause Review [USA]', 'EDUCAUSE Review is the general-interest, bimonthly magazine published by EDUCAUSE. The magazine takes a broad look at current developments and trends in information technology, what these mean for higher education, and how they may affect the college/university as a whole.', 'http://www.educause.edu/apps/er/index.asp', 'http://www.educause.edu/SearchResults/706?app=krc&output=xml_no_dtd&restrict=WWW_EDUCAUSE_EDU&client=my_collection&site=my_collection&getfields=*&filter=0&opid=644&app_section=&submit=Search&top_tax_id=&PRIMARYPUBS=&Control=&CARNEGIE=&FTE=&q={$formKeywords}', NULL, 1),
(1945, 381, 'Teachers College Record [USA]', 'A peer-reviewed journal offering full-text articles from 1980-present. Thematic content collections, discussion groups, online learning modules, and book reviews.', 'http://www.tcrecord.org/About.asp', 'http://www.tcrecord.org/search.asp?x=34&y=18&kw={$formKeywords}', NULL, 2),
(1946, 381, 'The Australian Electronic Journal of Nursing Education [Australia]', 'The AEJNE is committed to enhancing the teaching learning experience across a variety of nurse contexts. The journal will be a means by which nurses can share findings, insights, experience and advice to colleagues involved in all aspects of the educational process.', 'http://www.scu.edu.au/schools/nhcp/aejne/', 'http://www.scu.edu.au/cgi/htsearch/?submit=Search&method=boolean&format=builtin-short&words={$formKeywords}', NULL, 3),
(1947, 381, 'Bilingual Research Journal [USA]', 'A peer-reviewed scholarly journal publishing research on bilingual education.', 'http://brj.asu.edu/', 'http://brj.asu.edu.master.com/texis/master/search/?s=SS&notq=&prox=&sufs=0&rorder=&rprox=&rdfreq=&rwfreq=&rlead=&q={$formKeywords}', NULL, 4),
(1948, 381, 'Current Issues in Education [USA]', 'Current Issues in Comparative Education (CICE) is an online journal based at Teachers College, Columbia University, that publishes scholarly work from a variety of academic disciplines. CICE seeks clear and significant contributions that further debate on educational policies and comparative studies.', 'http://cie.ed.asu.edu/', 'http://www.google.com/search?q=site%3Acie.asu.edu+{$formKeywords}', NULL, 5),
(1949, 381, 'Education-line [UK]', 'Education-line is a freely accessible database of the full text of conference papers, working papers and electronic literature which supports educational research, policy and practice.', 'http://www.leeds.ac.uk/educol/', 'http://brs.leeds.ac.uk/cgi-bin/brs_engine?*ID=1&*DB=BEID&*PT=50&*FT=BEID&*HI=Y&TITL=&AUTH=&SUBJ=&*SO=TITL&SUBMIT_BUTTON=search%20button&*QQ={$formKeywords}', NULL, 6),
(1950, 381, 'Education Policy Analysis Archives [USA & Mexico]', 'A peer-reviewed scholarly electronic journal publishing education policy analysis since 1993.', 'http://epaa.asu.edu/', 'http://epaa.asu.edu/cgi-bin/htsearch?method=boolean&format=builtin-long&sort=score&config=epaa.asu.edu&restrict=&exclude=&words={$formKeywords}', NULL, 7),
(1951, 381, 'Educational Insights: Electronic Journal of Graduate Student Research [Canada]', 'Educational Insights is an innovative evocative provocative intertextual space for engaging in new dialogues of enRapturing con/texts and reimagined spaces of pedagogy, inquiry, and interdisciplinarity. Our intent is to encourage a community that honours difference and polyphony, while sharing a vision of pedagogy, education, inquiry as spaces of challenge and hopeful conversations.', 'http://ccfi.educ.ubc.ca/publication/insights/v09n02/us/index.html', 'http://sitelevel.whatuseek.com/query.go?B1=Search&crid=140f069465cde402&query={$formKeywords}', NULL, 8),
(1952, 381, 'Educational Technology and Society [USA]', 'Educational Technology & Society seeks academic articles on the issues affecting the developers of educational systems and educators who implement and manage such systems.', 'http://www.ifets.info/index.php?http://www.ifets.info/aim.php', 'http://odysseus.ieee.org/query.html?col=wg&qp=url%3Aifets.ieee.org%2Fperiodical&qs=&qc=wg&ws=0&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 9),
(1953, 381, 'First Monday [USA]', 'First Monday is one of the first peer-reviewed journals on the Internet, offering critical analysis of the Internet.', 'http://www.firstmonday.org/idea.html', 'http://www.firstmonday.org/fm.search?numdocs=20&query={$formKeywords}', NULL, 10);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(1954, 381, 'Global Journal of Engineering Education [Australia]', 'Global Journal of Engineering Education (GJEE), providing the international engineering education community with a forum for discussion and the exchange of information on engineering education and industrial training at tertiary level.', 'http://www.eng.monash.edu.au/uicee/gjee/globalj.htm', 'http://ultraseek.its.monash.edu.au/query.html?rq=0&col=m0&qp=&qs=+AND+url%3Ahttp%3A%2F%2Fwww.eng.monash.edu.au%2Fuicee%2Fgjee&qc=&pw=100%25&ws=1&la=&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 11),
(1955, 381, 'Journal of American Indian Education [USA]', 'The Journal of American Indian Education is a peer reviewed scholarly journal, which publishes papers specifically related to the education of American Indians and Alaska Natives. While the focus of the Journal is on basic applied research, manuscripts that are expository in nature and present an explicative or interpretive perspective are considered for publication as well. JAIE is particularly interested in publishing manuscripts that express the viewpoint of AI/AN and research that is initiated, conducted, and interpreted by natives.', 'http://jaie.asu.edu/', 'http://www.google.com/u/arizonastate?sa=Search&domains=jaie.asu.edu&sitesearch=jaie.asu.edu&hq=inurl%3Ajaie.asu.edu&q={$formKeywords}', NULL, 12),
(1956, 381, 'Journal of Vocational and Technical Education [USA]', 'The Journal of Vocational and Technical Education (JVTE) is a non-profit, refereed national publication of Omicron Tau Theta, the national, graduate honorary society of vocational and technical education.', 'http://scholar.lib.vt.edu/ejournals/JVTE/', 'http://scholar.lib.vt.edu:8765/query.html?rq=0&qp=url%3Ahttp%3A%2F%2Fscholar.lib.vt.edu%2Fejournals%2F&col=ejournal&qp=&qs=&qc=&pw=100%25&ws=0&la=&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 13),
(1957, 381, 'Kairos: A Journal for Teachers of Writing in Webbed Environments [USA]', 'Kairos is a refereed online journal exploring the intersections of rhetoric, technology, and pedagogy.', 'http://english.ttu.edu/kairos/', 'http://www.google.com/u/Kairos?hq=inurl%3Aenglish.ttu.edu%2Fkairos&btnG=Search+Kairos&q={$formKeywords}', NULL, 14),
(1958, 381, 'Language, Learning, and Technology [USA]', 'Online journal devoted to technology and language education research for foreign and second language.', 'http://llt.msu.edu/', 'http://www.google.com/u/llt?q={$formKeywords}', NULL, 15),
(1959, 381, 'Medical Education Online: An Electronic Journal [USA]', 'Medical Education Online (MEO) is a forum for disseminating information on educating physicians and other health professionals. Manuscripts on any aspect of the process of training health professionals will be considered for peer-reviewed publication in an electronic journal format. In addition MEO provides a repository for resources such as curricula, data sets, syllabi, software, and instructional material developers wish to make available to the health education community.', 'http://www.med-ed-online.org/', 'http://www.google.com/search?&q=site%3Awww.med-ed-online.org+{$formKeywords}', NULL, 16),
(1960, 381, 'National CROSSTALK, The National Center for Public Policy and Higher Education [USA]', 'The Center publishes the National CROSSTALK to provide action-oriented analyses of state and federal policies affecting education beyond high school.', 'http://www.highereducation.org/crosstalk/index.html', 'http://www.google.com/search?&q=site%3Awww.highereducation.org%2Fcrosstalk%2F+{$formKeywords}', NULL, 17),
(1961, 381, 'Philosophy of Education: Yearbook of the Philosophy of Education Society [USA]', 'Annual collections of some of the best work in the field of Educational Philosophy.', 'http://www.ed.uiuc.edu/EPS/PES-Yearbook/', 'http://www.googlesyndicatedsearch.com/u/pesyearbook?h1=en&hq=inurl%3Awww.ed.uiuc.edu%2Feps%2Fpes-yearbook&btnG=go&q={$formKeywords}', NULL, 18),
(1962, 381, 'Practical Assessment, Research and Evaluation [USA]', 'Practical Assessment, Research and Evaluation (PARE) is an on-line journal published by the edresearch.org and the Department of Measurement, Statistics, and Evaluation at the University of Maryland, College Park. Its purpose is to provide education professionals access to refereed articles that can have a positive impact on assessment, research, evaluation, and teaching practice, especially at the local education agency (LEA) level.', 'http://pareonline.net/', 'http://www.google.com/custom?domains=pareonline.net%2Fgetvn.asp&sa=Google+Search&sitesearch=pareonline.net%2Fgetvn.asp&client=pub-8146434030680546&forid=1&channel=9117733086&ie=ISO-8859-1&oe=ISO-8859-1&flav=0000&sig=cmg6qt6VP1GSt2jo&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFDD%3BLBGC%3AFFFFDD%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A50%3BLW%3A341%3BL%3Ahttp%3A%2F%2Fpareonline.net%2Fprac3.gif%3BS%3Ahttp%3A%2F%2F%3BFORID%3A1%3B&hl=en&q={$formKeywords}', NULL, 19),
(1963, 381, 'The Qualitative Report [USA]', 'The Qualitative Report (ISSN 1052-0147) is a peer-reviewed, on-line journal devoted to writing and discussion of and about qualitative, critical, action, and collaborative inquiry and research.', 'http://www.nova.edu/ssss/QR/index.html', 'http://www.nova.edu/bin/QR.pl?Search+Criteria={$formKeywords}', NULL, 20),
(1964, 381, 'Reading Online: An Electronic Journal of the International Reading Association [USA]', 'A journal for literacy educators K-12; includes articles, commentaries, reviews, and discussion forums.', 'http://www.readingonline.org/', 'http://www.readingonline.org/search/search.asp?QueryForm=&sc=articles&sm=all&qu={$formKeywords}', NULL, 21),
(1965, 381, 'Teaching English as a Second Language [USA]', 'TESL-EJ, Teaching English as a Second Language Electronic Journal, is a fully-refereed academic journal for the English as a Second Language, English as a Foreign Language.', 'http://www-writing.berkeley.edu/TESL-EJ/', 'http://www.google.com/u/berkeleywriting?sa=Google+Search&domains=www-writing.berkeley.edu%2FTESL-EJ%2F&sitesearch=www-writing.berkeley.edu&q={$formKeywords}', NULL, 22),
(1966, 382, 'Education Theory', 'Educational Theory is a quarterly journal of philosophy of education and related disciplines.', 'http://www.ed.uiuc.edu/EPS/Educational-Theory/', 'http://www.google.com/search?&q=site%3Awww.ed.uiuc.edu%2FEPS%2FEducational-Theory %2F+{$formKeywords}', NULL, 0),
(1967, 383, 'Education Research', 'RAND posts reports of its public policy research on education topics. Issues such as K-12 assessment and accountability, school reform, teachers and teaching, higher education, military education and training, and worker training are addressed.', 'http://www.rand.org/research_areas/education/', 'http://vivisimo.rand.org/vivisimo/cgi-bin/query-meta?v%3Aproject=pubs&input-form=simple&Go=Search&query={$formKeywords}', NULL, 0),
(1968, 383, 'ERIC Digests', 'ERIC Digests include:  \n\n- short reports (1,000 - 1,500 words) on topics of prime current interest in education. There are a large variety of topics covered including teaching, learning, libraries, charter schools, special education, higher education, home schooling, and many more. \n\n- targeted specifically for teachers, administrators, policymakers, and other practitioners, but generally useful to the broad educational community.  \n\n- designed to provide an overview of information on a given topic, plus references to items providing more detailed information.  \n\n- produced by the former 16 subject-specialized ERIC Clearinghouses, and reviewed by experts and content specialists in the field.  \n\n- funded by the Office of Educational Research and Improvement (OERI), of the U.S. Department of Education (ED).  \n\n- The full-text ERIC Digest database contains over 3000 Digests with the latest updates being added to this site in July 2005.', 'http://www.ericdigests.org/', 'http://www.google.com/custom?domains=ericdigests.org&sitesearch=ericdigests.org&q={$formKeywords}', NULL, 1),
(2033, 394, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(2034, 394, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(1793, 349, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1794, 349, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1792, 349, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1791, 349, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1790, 349, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1789, 348, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 0),
(1788, 347, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com/mind/+{$formKeywords}', NULL, 0),
(1787, 346, 'Biospace', 'BioSpace is a provider of web-based resources and information to the life science industry. For 20 years BioSpace has helped to accelerate communication and discovery among business and scientific leaders in the biopharmaceutical market. With a well-established site infrastructure and loyal online audience of over 1 million unique monthly visitors, BioSpace.com offers an unparalleled distribution channel for recruitment, investment, product, event and other life science industry messages.', 'http://www.biospace.com', 'http://www.google.com/search?q=site:www.biospace.com+{$formKeywords}', NULL, 5),
(1786, 346, 'Bioresearch Online', 'Virtual community for the bioresearch and life sciences industry featuring daily news, product updates, discussion forums, and online chat with information on manufacturing, technology, equipment, supplies, software, and careers.', 'http://www.bioresearchonline.com/', 'http://www.bioresearchonline.com/IndustrySearch/SearchResults.aspx?TabIndex=3&keyword={$formKeywords}', NULL, 4),
(1785, 346, 'BiologyBrowser', 'BiologyBrowser, produced by BIOSIS, is a free web site offering resources for the life sciences information community. An interactive portal designed "to connect life sciences researchers with free, useful resources and other like-minded scientists from all around the world." Includes annotated links to news and life science Web sites, a nomenclatural glossary for zoology, a zoological thesaurus, a forum for biologists and scientists to discuss findings, and more. Searchable.', 'http://www.biologybrowser.org/', 'http://www.biologybrowser.org/cgi-bin/search/hyperseek.cgi?howmuch=ALL&Terms={$formKeywords}', NULL, 3),
(1782, 346, 'Nature Biotechnology Directory', 'Nature Biotechnology Directory Website, a global information resource listing over 8,000 organizations, product and service providers in the biotechnology industry.', 'http://www.guide.nature.com/', 'http://www.biocompare.com/nature/search.asp?contentid=1&maxrecords=50&search={$formKeywords}', NULL, 0),
(1783, 346, 'Scirus', 'Scirus is the most comprehensive science-specific search engine on the Internet. Driven by the latest search engine technology, Scirus searches over 150 million science-specific Web pages.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 1),
(1784, 346, ' National Library of Medicine Gateway', 'NLM Gateway allows users to search in multiple retrieval systems at the U.S. National Library of Medicine (NLM). The current Gateway searches MEDLINE/PubMed, OLDMEDLINE, LOCATORplus, MEDLINEplus, ClinicalTrials.gov, DIRLINE, Meeting Abstracts, and HSRProj. Useful to physicians, researchers, students and the general public for an overall search of NLM''s information resources.', 'http://gateway.nlm.nih.gov/gw/Cmd', 'http://gateway.nlm.nih.gov/gw/Cmd?GM2K_FORM=GMBasicSearch&enterKey=&ORBagentPort=14610&Perform_Search.x=19&Perform_Search.y=13&UserSearchText={$formKeywords}', NULL, 2),
(1781, 345, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&amp;mode=quicksearch&amp;WISindexid1=WISall&amp;WISsearch1={$formKeywords}', 4),
(1780, 345, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(1779, 345, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1778, 345, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1777, 345, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1775, 344, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1776, 344, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(1774, 344, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1772, 343, 'PubMed Central: an archive of life science journals', 'PubMed Central is a digital archive of life sciences journal literature managed by the National Center', 'http://www.pubmedcentral.nih.gov/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?search=Search&db=pmc&cmd=search&pmfilter_Fulltext=on&pmfilter_Relevance=on&term={$formKeywords}', NULL, 7),
(1773, 344, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1771, 343, 'PubMed', 'This is an experimental interface to several databases published by the NLM. Included are Medline and Pre-Medline, Popline, Toxline, GenBank DNA sequences, GenBank Protein Sequences, BioMolecule 3D structures, and Complete Genomes. This resource contains links to the full text of the articles when available.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(1769, 343, 'BioMed Central (Requires Registration)', 'BioMed Central publishes original, peer-reviewed research in all areas of biomedical research, with immediate, barrier-free access for all. BioMed Central is structured into journals, each of which covers a broad area of biology or medicine.', 'http://www.biomedcentral.com/', 'http://www.google.com/search?q=site%3Abiomedcentral.com+{$formKeywords}', NULL, 4),
(1770, 343, 'MEDLINEplus: health information', 'MEDLINEplus presents up-to-date, quality health care information from the National Library of Medicine at the National Institutes of Health. Both health professionals and consumers can depend on MEDLINEplus for accurate, current medical information. This service provides access to extensive information about specific diseases and conditions and also has links to consumer health information from the National Institutes of Health, dictionaries, news, lists of hospitals and physicians, health information in Spanish and other languages, and clinical trials.', 'http://medlineplus.gov/', 'http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SERVER2=server2&SERVER1=server1&x=25&y=7&PARAMETER={$formKeywords}', NULL, 5),
(1768, 343, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(1767, 343, 'FishBase', 'The FishBase Databases contains information on over 27,000 species, over 76,000 synonyms, 137,930 common names, over 35,000 pictures, and over 30,000 references. Entries include family, order, class, English name, distribution, biology, environment, climate zone, and additional information. Entries also offer a number of links for more specific data such as synonyms, countries, key facts, pictures, FAO areas, spawning, reproduction, predators, diet composition, and more.', 'http://www.fishbase.org/home.htm', 'http://www.fishbase.org/ComNames/CommonNameSearchList.cfm?Crit1_FieldName=COMNAMES.ComName&Crit1_FieldType=CHAR&Crit1_Operator=CONTAINS&CommonName_required=Common name can not be blank&CommonName={$formKeywords}', NULL, 2),
(1766, 343, 'ClinicalTrials.gov', 'ClinicalTrials.gov provides patients, family members, health care professionals, and members of the public, easy and free access to information on clinical studies for a wide range of diseases and conditions.', 'http://www.clinicaltrials.gov/', 'http://www.clinicaltrials.gov/ct/search;jsessionid=6EC2379952077D66434C74BCF3542697?&submit=Search&term={$formKeywords}', NULL, 1),
(1765, 343, 'Animal Info: Information on Rare, Threatened and Endangered Mammals', 'Animal Info offers information on the biology and ecology of various species as well as current status of rare and endangered mammals. Also provides links to animal interest organizations and publications. Users can search an individual species index by common and scientific name, a species group index and a country index.', 'http://www.animalinfo.org/', 'http://search.atomz.com/search/?sp-a=00081051-sp00000000&sp-q={$formKeywords}', NULL, 0),
(1764, 342, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(1762, 342, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(1763, 342, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(1761, 342, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(1759, 342, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1760, 342, 'Life Sciences Dictionary from BioTech', 'Life Sciences Dictionary from BioTech comprises 8,300+ terms relating to biochemistry, biotechnology, botany, cell biology and genetics, as well as selective entries on ecology, limnology, pharmacology, toxicology and medicine.', 'http://biotech.icmb.utexas.edu/search/dict-search.html', 'http://biotech.icmb.utexas.edu/search/dict-search2.html?bo1=AND&search_type=normal&def=&&word={$formKeywords}', NULL, 1),
(1758, 341, 'PubMed Central: an archive of life science journals', 'PubMed Central is a digital archive of life sciences journal literature managed by the National Center', 'http://www.pubmedcentral.nih.gov/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?search=Search&db=pmc&cmd=search&pmfilter_Fulltext=on&pmfilter_Relevance=on&term={$formKeywords}', NULL, 8),
(1757, 341, 'PubMed', 'This is an experimental interface to several databases published by the NLM. Included are Medline and Pre-Medline, Popline, Toxline, GenBank DNA sequences, GenBank Protein Sequences, BioMolecule 3D structures, and Complete Genomes. This resource contains links to the full text of the articles when available.', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 7),
(1756, 341, 'BioMed Central (Requires Registration)', 'BioMed Central publishes original, peer-reviewed research in all areas of biomedical research, with immediate, barrier-free access for all. BioMed Central is structured into journals, each of which covers a broad area of biology or medicine.', 'http://www.biomedcentral.com/', 'http://www.google.com/search?q=site%3Abiomedcentral.com+{$formKeywords}', NULL, 6),
(1755, 341, 'Animal Info: Information on Rare, Threatened and Endangered Mammals', 'Animal Info offers information on the biology and ecology of various species as well as current status of rare and endangered mammals. Also provides links to animal interest organizations and publications. Users can search an individual species index by common and scientific name, a species group index and a country index.', 'http://www.animalinfo.org/', 'http://search.atomz.com/search/?sp-a=00081051-sp00000000&sp-q={$formKeywords}', NULL, 5),
(1754, 341, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(1753, 341, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(1751, 341, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(1752, 341, 'ClinicalTrials.gov', 'ClinicalTrials.gov provides patients, family members, health care professionals, and members of the public, easy and free access to information on clinical studies for a wide range of diseases and conditions.', 'http://www.clinicaltrials.gov/', 'http://www.clinicaltrials.gov/ct/search;jsessionid=6EC2379952077D66434C74BCF3542697?&submit=Search&term={$formKeywords}', NULL, 2),
(1750, 341, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1749, 340, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1746, 340, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1747, 340, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1748, 340, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1744, 339, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(1745, 339, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(1742, 339, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(1743, 339, 'Science News Online', 'Science News Online is one of the most useful science news magazines is now online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week. They''ve archived them back to 1994.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(1740, 339, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1741, 339, 'Notice of the American Mathematical Society', 'Notices of the American Mathematical Society is one of the world''s most widely read periodicals for professional mathematicians.', 'http://www.ams.org/noticessearch/', 'http://www.google.com/custom?sa=Search+Notices&cof=S%3Ahttp%3A%2F%2Fwww.ams.org%2Fnotices%3BGL%3A0%3BVLC%3A%23004080%3BAH%3Aleft%3BBGC%3A%23ffffff%3BLH%3A55%3BLC%3A+%23004080%3BL%3Ahttp%3A%2F%2Fwww.ams.org%2Fimages%2Fnotices-search-banner.gif%3BALC%3A%23ff2b2b%3BLW%3A1200%3BT%3A%23000000%3BAWFID%3A39742761a368da0f%3B&domains=www.ams.org%2Fnotices&sitesearch=www.ams.org%2Fnotices&q={$formKeywords}', NULL, 1),
(1739, 338, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(1738, 338, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(1736, 338, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1737, 338, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1735, 338, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1734, 338, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1733, 338, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1732, 338, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1731, 338, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1730, 337, 'Ask Dr. Math', 'Search the archives for elementary through college level questions and answers. Sponsored by Drexel University.', 'http://www.mathforum.org/library/drmath/', 'http://mathforum.org/library/drmath/results.html?textsearch_bool_type=and&textsearch_whole_words=no&textsearch={$formKeywords}', NULL, 7),
(1710, 334, 'Math Archives: Topics in Mathematics', 'A large, searchable collection of categorized teaching materials, software, and Web links. While not annotated, keywords for each site provide insight into the site''s offerings.', 'http://archives.math.utk.edu/topics/', 'http://www.google.com/search?q=site%3Aarchives.math.utk.edu+topics+{$formKeywords}', NULL, 3),
(1711, 334, 'MathSearch', 'An excellent tool for searching the contents of more than 80,000 mathematics pages world wide, via Sydney University work, network security, digital signal processing and related topics.', 'http://www.maths.usyd.edu.au:8000/MathSearch.html', 'http://www.maths.usyd.edu.au:8000/s/search/p?p2=&p3=&p4=&p1={$formKeywords}', NULL, 4),
(1712, 334, 'MPRESS/MATHNET', 'MPRESS/MathNet is a concept/installation to provide quality indexing of mathematical preprints (servers). It is in itself operated in a distributed way. MPRESS improves access to the full texts of preprints in mathematics by means of metadata and provides comprehensive and easily searchable information on the preprints available.', 'http://mathnet.preprints.org/', 'http://mathnet.preprints.org/cgi-bin/harvest/MPRESS.pl.cgi?author=&keyword=&title=&metaquery=&broker=FraGer&errorflag=0&wordflag=off&opaqueflag=off&csumflag=off&maxobjflag=10000&maxlineflag=10000&maxresultflag=10000&query={$formKeywords}', NULL, 5),
(1713, 334, 'SIAM Review', 'The SIAM Review consists of five sections, all containing articles of broad interest. Survey and Review features papers with a deliberately integrative and up-to-date perspective on a major topic in applied or computational mathematics or scientific computing.', 'http://epubs.siam.org/sam-bin/dbq/toclist/SIREV', 'http://epubs.siam.org/search/search.pl', 'field1=anyfield&jrnlname=all&boolean1=and&search_field=anyfield&quicksearchstring={$formKeywords}', 6),
(1714, 334, 'Zentralblatt MATH', 'Zentralblatt MATH is the world''s most complete and longest running abstracting and reviewing service in pure and applied mathematics. The Zentralblatt MATH Database contains more than 2.0 million entries drawn from more than 2300 serials and journals, which are listed in this Database of Serials and Journals.', 'http://www.zblmath.fiz-karlsruhe.de/serials/', 'http://www.zblmath.fiz-karlsruhe.de/serials/?hits_per_page=10&is=&bi={$formKeywords}', NULL, 7),
(1715, 335, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1716, 335, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1717, 335, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1718, 335, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(1719, 335, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(1720, 336, 'The Mathematical Atlas: A Gateway to Modern Mathematics', 'This searchable site provides a collection of articles about the many subfields of math and includes definitions, brief biographies, and explanations. Each topic includes a history, related areas, and subfields as well as related print and Internet resources. It also includes an introduction to the Mathematics Subject Classification (MSC) scheme on which the site''s arrangement is based.', 'http://www.math-atlas.org/', 'http://www.math.niu.edu/cgi-bin/ffw.cgi/known-math?&go=Search&key={$formKeywords}', NULL, 0);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(1721, 336, 'MathForum''s Search All Epigone Discussions', 'MathForum''s Search All Epigone Discussions provides resources, materials, activities, person-to-person interactions, and educational products and services that enrich and support teaching and learning in an increasingly technological world. The Math Forum''s Epigone discussion archives include mathematics and math education-related newsgroups, mailing lists, and Web-based discussions.', 'http://mathforum.com/discussions/epi-search/all.html', 'http://mathforum.org/search/results.html?bool_type=and&whole_words=yes&match_case=no&ctrlfile=/var/www/search/ctrl/all.search.ctrl&textsearch={$formKeywords}', NULL, 1),
(1722, 336, 'AMS Meetings & Conferences', 'Meetings & Conferences, provided by the American Mathematical Society (AMS), contains a comprehensive list of important meetings information.', 'http://www.ams.org/meetings/', 'http://www.google.com/search?q=site%3Awww.ams.org%2Fmeetings%2F+{$formKeywords}', NULL, 2),
(1723, 337, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?', 'formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', 0),
(1724, 337, 'MSTE', 'MSTE serves as a model-builder for innovative, standards-based, technology-intensive mathematics and science instruction at the K-16 levels.', 'http://www.mste.uiuc.edu/', 'http://www.google.com/custom?ie=UTF-8&oe=UTF-8&sa=&cof=GALT%3A%2393AAC6%3BS%3Ahttp%3A%2F%2Fwww.mste.uiuc.edu%2F%3BGL%3A1%3BVLC%3Aorange%3BAH%3Acenter%3BBGC%3A%233d4b66%3BLH%3A255%3BLC%3Aorange%3BGFNT%3A%2393AAC6%3BL%3Ahttp%3A%2F%2Fwww.mste.uiuc.edu%2Fimages%2Fmstelogo.gif%3BALC%3A%23d3d3d3%3BLW%3A600%3BT%3A%23FFFFFF%3BGIMP%3A%2393AAC6%3BAWFID%3A174a51c6937b9927%3B&domains=http%3A%2F%2Fwww.mste.uiuc.edu%2F&sitesearch=http%3A%2F%2Fwww.mste.uiuc.edu%2F&q={$formKeywords}', NULL, 1),
(1725, 337, 'Illuminations', 'This site is to improve the teaching and learning of mathematics. This site offers interactive lessons for students, lesson plans for teachers, and math applets, all arranged by grade level. Includes a large collection of Web resources, arranged by concept and grade, and the standards for teaching math. From the National Council of Teachers of Mathematics (NCTM).', 'http://illuminations.nctm.org/', 'http://marcopolosearch.org/MPSearch/Search_Results.asp?orgn_id=6&log_type=1&hdnFilter=&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 2),
(1726, 337, 'MarcoPolo Internet Content for the Classroom', 'MarcoPolo Internet Content for the Classroom is a consortium of premier national education organizations, state education agencies and the MarcoPolo Education Foundation dedicated to providing the highest quality Internet content and professional development to teachers and students throughout the United States. Subjects include: Arts, Economics, Foreign Language, Geography, Language Arts, Mathematics, Philosophy & Religion, Science, and Social Studies.', 'http://www.marcopolo-education.org/home.aspx', 'http://www.marcopolosearch.org/mpsearch/Search_Results.asp?orgn_id=2&log_type=1&hdnFilter=&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 3),
(1727, 337, 'The Math Forum', 'The Math Forum gateway provides easy access to high quality resources for mathematicians and math teachers, and it provides resources that cover the use and administration of Internet sites as well as other educational resources. Among its features are the following: five ways to search with well written instructions for using each type; interactive sites; multilingual sites; choice of resource listings by knowledge levels from elementary to research level; and resources displayed in either an outline form or as an annotated listing with the ability to switch back and forth between the two.', 'http://mathforum.org/grepform.html', 'http://mathforum.org/search/results.html?bool_type=and&whole_words=yes&match_case=no&ctrlfile=%2Fvar%2Fwww%2Fsearch%2Fctrl%2Fall.search.ctrl&textsearch={$formKeywords}', NULL, 4),
(1728, 337, 'PBS Mathline', 'PBS Mathline features a specific math topic for teachers of grades K-12. Each month an in-depth article is linked to related resources, and daily facts related to the topic. PBS Mathline also offers an extensive professional development program.', 'http://www.pbs.org/teachersource/math.htm', 'http://www.pbs.org/teachersource/search/standards_results.shtm?start=1&end=20&subjects=NULL&grades=NULL&query={$formKeywords}', NULL, 5),
(1729, 337, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 6),
(1872, 365, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 6),
(1871, 365, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://fnalpubs.fnal.gov/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/wwwscan?subfile=wwwhepau&submit=Browse&rawcmd={$formKeywords}', NULL, 5),
(1870, 365, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(1869, 365, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(1867, 365, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1868, 365, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(1866, 365, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1864, 364, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1865, 364, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1863, 364, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1862, 364, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1860, 363, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(1861, 363, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(1859, 363, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(1857, 363, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(1858, 363, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(1856, 363, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(1852, 363, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1853, 363, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(1854, 363, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(1855, 363, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(1851, 362, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(1850, 362, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.qestia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1849, 362, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1848, 362, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1846, 360, 'MusicMoz', 'The Open Music Project. A comprehensive directory of all things music, edited by volunteers, this site lists and accepts submissions of music-related reviews, articles, factual information, biographies, and websites.', 'http://musicmoz.org/', 'http://musicmoz.org/search/search.cgi?search={$formKeywords}', NULL, 0),
(1847, 361, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 0),
(1844, 359, 'Classical Net', 'Classical Net features more than 3200 CD/DVD/Book reviews, as well as 6000 files and over 4000 links to other classical music web sites.', 'http://www.classical.net/', 'http://search.mercora.com/msearch/search.jsp?pattern={$formKeywords}', NULL, 3),
(1845, 359, 'AHDS Performing Arts', 'AHDS Performing Arts collects, documents, preserves and promotes the use of digital resources to support research and teaching across the broad field of the performing arts: music, film, broadcast arts, theatre, dance.', 'http://ahds.ac.uk/performingarts/', 'http://ahds.ac.uk/performingarts/search/index.htm?submit=Search%21&query={$formKeywords}', NULL, 4),
(1843, 359, 'AMG All-Media (All-Music) Guide', 'From the paper copy publishers of the standard reference All Music Guide, this site contains ratings and reviews of more than 400,000 record albums. Search by artist, album, song, style, or label. Access information on new releases, music styles, music maps (guides to the evolution of a musical genre), articles, and a glossary. Entries on artists include a musician/musical group''s history, roots and influences, musical style, discography, guest performances, and reviews.', 'http://www.allmusic.com/', 'http://www.allmusic.com/cg/amg.dll?OPT1=1&P=amg&SQL={$formKeywords}', NULL, 2),
(1841, 359, 'Aria Databases', 'The Aria Databases is a diverse collection of information on over 1000 operatic arias. Designed for singers and non-singers alike, the Databases includes translations and aria texts of most arias as well as a collection of MIDI files of operatic arias and ensembles.', 'http://www.aria-database.com/', 'http://www.aria-database.com/cgi-bin/aria-search.pl', 'numbers=1|20&all-or-results=all&aria=&language=All&detail=yes&composer=&role=&opera=&low=A&below=2&high=A&above=3&pointless=yes&database-select=aria&input-choose=keyword&keyword={$formKeywords}', 0),
(1842, 359, 'Operabase', 'A powerful search tool allows you to search the details of over 38,000 opera performances since autumn 2001 by any combination of opera title, composer, date, location.', 'http://operabase.com/en/', 'http://operabase.com/oplist.cgi?id=none&lang=en&by=&loc=&near=0&stype=rel&srel=0&sd=1&sm=1&sy=1999&etype=rel&erel=0&ed=31&em=7&ey=2004&full=n&sort=V&is={$formKeywords}', NULL, 1),
(1840, 358, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 3),
(1839, 358, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 2),
(1837, 358, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 0),
(1838, 358, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase. At this point, a total of 15,000 of 750,000 records are loaded into the database. Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/default.asp', 'http://www.crl.edu/DBSearch/catalogSearchNew.asp?sort=R&req_type=X&search={$formKeywords}', NULL, 1),
(1836, 357, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(1835, 357, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1834, 357, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1833, 357, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1832, 356, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1830, 356, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1831, 356, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1828, 356, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1829, 356, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1827, 356, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1826, 356, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1824, 355, 'Music Theory Online', 'This site is the refereed, electronic journal of the Society for Music Theory, Inc..', 'http://www.societymusictheory.org/mto/', 'http://www.google.com/u/smt?sa=Google+Search&q={$formKeywords}', NULL, 0),
(1825, 355, 'Music Education Resource Base: including the Canadian Music Index', 'MERB/CMI is a bibliographic database of more than 28,000 resources in music and music education from 31 Canadian and International journals and other sources covering the period 1956 through the present. The journals are fully indexed by title, author, and subject.', 'http://www.fmpweb.hsd.uvic.ca/merb/index.htm', 'http://www.fmpweb.hsd.uvic.ca/merb/FMPro?-DB=MERBSUB.fp5&-lay=Layout+%232&-format=search_results.htm&-error=search_error.htm&-max=all&-lop=and&-SortField=Title&-SortOrder=Ascending&-op=eq&Show+to+web=yes&-op=cn&-Find=Go&SUBJECT={$formKeywords}', NULL, 1),
(1823, 354, 'The Journal of Seventeenth-Century Music (JSCM)', 'The Journal of Seventeenth-Century Music (JSCM) is published by the Society for Seventeenth-Century Music to provide a refereed forum for scholarly studies of the musical cultures of the seventeenth century. These include historical and archival studies, performance practice, music theory, aesthetics, dance, and theater. JSCM also publishes critical reviews and summary listings of recently published books, scores, and electronic media.', 'http://sscm-jscm.press.uiuc.edu', 'http://sscm-jscm.press.uiuc.edu/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=scm&restrict=&exclude=&words={$formKeywords}', NULL, 1),
(1822, 354, 'Electronic Musician', 'Full-text articles from current issue and back issues to September 1999', 'http://industryclick.com/magazine.asp?magazineid=33&SiteID=15', 'http://industryclick.com/advsearchresults.asp?SiteID=15&MagazineID=33&CodeID=&selectSearch=mag%3B33&Go.x=12&Go.y=9&qry={$formKeywords}', NULL, 0),
(1821, 353, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 7),
(1820, 353, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 6),
(1819, 353, 'Grove Concise Music Dictionary', 'GroveMusic powered by Gramophone.', 'http://www.gramophone.co.uk/', 'http://www.gramophone.co.uk/grove_popup.asp?grove={$formKeywords}', NULL, 5),
(1818, 353, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(1817, 353, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(1816, 353, 'Encyclopedia.com', 'Online version of the Concise Electronic Encyclopedia. Entries are very short, so this site is better suited for fact checking than research.', 'http://www.encyclopedia.com/', 'http://www.encyclopedia.com/searchpool.asp?target={$formKeywords}', NULL, 2),
(1814, 353, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1815, 353, 'Columbia Encyclopedia', 'Serving as a "first aid" for those who read, the sixth edition of the Columbia Encyclopedia contains over 51,000 entries with 80,000 hypertext links.', 'http://www.bartleby.com/65/', 'http://www.bartleby.com/cgi-bin/texis/webinator/65search?search_type=full&query={$formKeywords}', NULL, 1),
(1813, 352, 'Music Education Resource Base: including the Canadian Music Index', 'MERB/CMI is a bibliographic database of more than 28,000 resources in music and music education from 31 Canadian and International journals and other sources covering the period 1956 through the present. The journals are fully indexed by title, author, and subject.', 'http://www.fmpweb.hsd.uvic.ca/merb/index.htm', 'http://www.fmpweb.hsd.uvic.ca/merb/FMPro?-DB=MERBSUB.fp5&-lay=Layout+%232&-format=search_results.htm&-error=search_error.htm&-max=all&-lop=and&-SortField=Title&-SortOrder=Ascending&-op=eq&Show+to+web=yes&-op=cn&-Find=Go&SUBJECT={$formKeywords}', NULL, 4),
(1812, 352, 'Music Theory Online', 'This site is the refereed, electronic journal of the Society for Music Theory, Inc..', 'http://www.societymusictheory.org/mto/', 'http://www.google.com/u/smt?sa=Google+Search&q={$formKeywords}', NULL, 3),
(1795, 349, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1796, 349, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1797, 349, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(1798, 349, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(1799, 350, 'Biospace', 'BioSpace is a provider of web-based resources and information to the life science industry. For 20 years BioSpace has helped to accelerate communication and discovery among business and scientific leaders in the biopharmaceutical market. With a well-established site infrastructure and loyal online audience of over 1 million unique monthly visitors, BioSpace.com offers an unparalleled distribution channel for recruitment, investment, product, event and other life science industry messages.', 'http://www.biospace.com', 'http://www.biospace.com/Default.aspx', 'ctl00$DropDownList1=News&ctl00$TextBox1={$formKeywords}', 0),
(1800, 350, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 1),
(1801, 350, 'The Scientist', 'The Scientist is the online resource for the printed magazine, The Scientist. Provides access to information useful to those working in or studying the life sciences.', 'http://www.the-scientist.com/', 'http://www.the-scientist.com/search/dosearch/', 'box_type=toolbar&search_restriction=all&order_by=date&search_terms={$formKeywords}', 2),
(1802, 350, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 3),
(1803, 350, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=TITLE_CHAR&FullText_CHAR={$formKeywords}', NULL, 4),
(1804, 350, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(1805, 351, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1806, 351, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1807, 351, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1808, 351, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1809, 352, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1810, 352, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(1811, 352, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(2154, 416, 'Rice bibliography', 'The Rice Bibliography was begun in 1961 and is now the world''s largest source of scientific information about rice. Almost 8,000 new references are added each year and these cover all subjects related to rice culture.', 'http://ricelib.irri.cgiar.org:81/search/w', 'http://ricelib.irri.cgiar.org:81/search/?searchtype=w&searcharg={$formKeywords}', NULL, 2),
(2153, 416, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(2152, 416, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2151, 415, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2150, 415, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2149, 415, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2147, 414, 'Newsdirectory', 'Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 3),
(2148, 415, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2146, 414, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 2),
(2144, 414, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2145, 414, 'The Scientist', 'The Scientist is the online resource for the printed magazine, The Scientist, and provides access to information useful to those working in or studying the life sciences.', 'http://www.the-scientist.com/', 'http://www.the-scientist.com/search/dosearch/', 'box_type=toolbar&search_restriction=all&order_by=date&search_terms={$formKeywords}', 1),
(2143, 413, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(2142, 413, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(2141, 413, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(2139, 413, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2140, 413, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(2138, 413, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(2137, 413, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(2136, 413, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. In addition to Department web sites, the government has been creating Portals which bring together \ninformation from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(2135, 413, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2134, 412, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 0),
(2133, 411, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(2131, 410, 'Intute: Social Sciences - Conferences and Events', 'Intute: Social Sciences - Conferences and Events provides search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(2132, 410, 'Medical Conferences.com', 'Medical Conferences.com is the Internet''s leading conference portal for medical and health-care professionals along with the associated supporting business community. This searchable database of over 7,000 medical conferences and CME events is an invaluable resource for all healthcare professionals.', 'http://www.medicalconferences.com/', 'http://www.medicalconferences.com/scripts/search_partner.pl?PID=234523&L=&Q_DATE_STARTD=-&Q_DATE_STARTM=-&Q_DATE_STARTY=-&Q_DATE_ENDD=-&Q_DATE_ENDM=-&Q_DATE_ENDY=-&x=4&y=11&&K={$formKeywords}', NULL, 2),
(2130, 410, 'COGSCI Cognitive Science Discussion List', 'COGSCI Cognitive Science Discussion List is a website for the International Cognitive Science Discussion List.', 'http://cogsci.weenink.com/', 'https://listserv.surfnet.nl/scripts/wa.exe?S2=COGSCI&0=S&s=&f=&a=&I=-3&q={$formKeywords}', NULL, 0),
(2129, 409, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(2128, 409, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(2127, 409, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2126, 409, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(2123, 408, 'Medline', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4,300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 7),
(2124, 408, 'Psycoloquy', 'An Open Archive of refereed reprints of all target articles, commentaries and responses from Psycoloquy, a peer-reviewed journal of Open Peer Commentary, sponsored by the American Psychological Association, indexed in PsycINFO, and published since 1990 (Archive is complete)', 'http://psycprints.ecs.soton.ac.uk/', 'http://psycprints.ecs.soton.ac.uk/perl/search?_order=bytitle&abstract%2Fkeywords%2Ftitle_srchtype=ALL&_satisfyall=ALL&abstract%2Fkeywords%2Ftitle={$formKeywords}', NULL, 8),
(2125, 409, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2121, 408, 'CogPrints', 'CogPrints is an electronic archive for papers in any area of Psychology, Neuroscience, and Linguistics, and many areas of Computer Science and Biology, which uses the self-archiving software of eprints.org. This archive can be searched by author, title or keyword. Both preprints and published refereed articles are included, with full contact details for each author.', 'http://cogprints.soton.ac.uk/', 'http://cogprints.ecs.soton.ac.uk/perl/search/simple?meta=&meta_merge=ALL&full_merge=ALL&person=&person_merge=ALL&date=&_satisfyall=ALL&_order=bytitle&_action_search=Search&full={$formKeywords}', NULL, 5),
(2122, 408, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&author1=&src=ml&disp_type=&fulltext={$formKeywords}', NULL, 6),
(2119, 408, 'CogWeb', 'CogWeb is a research tool for exploring the relevance of the study of human cognition to communication and the arts. It is edited by Francis Steen, assistant professor in Communication Studies at UCLA. CogWeb contains several hundred items and is continually under construction.', 'http://cogweb.ucla.edu/', 'http://search.atomz.com/search/?sp-advanced=1&sp-w-control=1&sp-a=00070a1a-sp00000000&sp-c=100&sp-p=any&sp-q={$formKeywords}', NULL, 3),
(2120, 408, 'Behavior and Brain Sciences', 'Behavior and Brain Sciences is running on eprints.org open archive software, a freely distributable archive system available from eprints.org.', 'http://www.bbsonline.org/perl/search', 'http://www.bbsonline.org/perl/search?title_abstract_keywords_srchtype=all&authors=&authors_srchtype=all&year=&_satisfyall=ALL&_order=order0&submit=Search&.cgifields=publication&title_abstract_keywords={$formKeywords}', NULL, 4),
(2118, 408, 'Enpsychlopedia', 'Enpsychlopedia - Provides a search of psychcentral and several other mental health sites. You can access every time you want Provides a search of psychcentral and several other mental health sites. ', 'http://www.enpsychlopedia.com/', 'http://www.enpsychlopedia.com/index.php?subber=&site=&qq={$formKeywords}', NULL, 2),
(2117, 408, 'The Encyclopedia of Psychology', 'The Encyclopedia of Psychology is intended to facilitate browsing in any area of psychology.', 'http://www.psychology.org/', 'http://www.psychology.org/cgi-bin/links2/search.cgi?query={$formKeywords}', NULL, 1),
(2116, 408, 'Institut des Sciences Cognitives', 'The National Center for Scientific Research in France promoting study of cognition, especially in humans. Many of the working papers and links to other websites are in English.', 'http://www.isc.cnrs.fr/index_en.htm', 'http://www.google.com/custom?cof=T%3Ablack%3BLW%3A118%3BALC%3Ared%3BL%3Ahttp%3A%2F%2Fwww.isc.cnrs.fr%2Flogoisc.gif%3BLC%3Ablue%3BLH%3A76%3BBGC%3Awhite%3BAH%3Acenter%3BVLC%3Apurple%3BAWFID%3Abbb9fffe574108ac%3B&domains=www.isc.cnrs.fr&sitesearch=www.isc.cnrs.fr&q={$formKeywords}', NULL, 0),
(2115, 407, 'MITECS: The MIT Encyclopedia of the Cognitive Sciences', 'MITECS: The MIT Encyclopedia of the Cognitive Sciences is a free online access to abstracts, bibliographies, and links from this comprehensive reference work. (To read the full-length entries you have to pay.)', 'http://cognet.mit.edu/library/erefs/mitecs/', 'http://gb-server.mit.edu/search?btnG=Search&site=mit&client=mit&proxyreload=1&proxystylesheet=http%3A%2F%2Fcognet.mit.edu%2Fgoogle-mithome.xsl&output=xml_no_dtd&as_dt=i&as_sitesearch=cognet.mit.edu&q={$formKeywords}', NULL, 1),
(2113, 406, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2114, 407, 'Stanford Encyclopedia of Philosophy', 'The Stanford Encyclopedia of Philosophy is a dynamic reference work that has been rapidly growing.  The goal of this project is  to produce an authoritative and comprehensive dynamic reference work devoted to the academic discipline of philosophy that will be kept up to date dynamically so as to remain useful to those in academia and the general public.', 'http://plato.stanford.edu/about.html', 'http://plato.stanford.edu/cgi-bin/webglimpse.cgi?ID=1&nonascii=on&maxfiles=50&maxlines=30&maxchars=10000&query={$formKeywords}', NULL, 0),
(2112, 406, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2111, 406, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2110, 406, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2109, 405, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(2108, 405, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(2107, 405, 'Wordnet', 'Wordnet is an online lexical reference system whose design is inspired by current psycholinguistic theories of human lexical memory. English nouns, verbs, adjectives and adverbs are organized into synonym sets, each representing one underlying lexical concept. Different relations link the synonym sets.', 'http://www.cogsci.princeton.edu/~wn/', 'http://wordnet.princeton.edu/perl/webwn?sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=&s={$formKeywords}', NULL, 4),
(2106, 405, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(1922, 376, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(1921, 376, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(1918, 376, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1919, 376, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(1920, 376, 'Physics News Update: AIP Bulletin of Physics News', 'Physics News Update: AIP Bulletin of Physics News is a digest of physics news items arising from physics meetings, physics journals, newspapers and magazines, and other news sources. Subscriptions are free as a way of broadly disseminating information about physics and physicists.', 'http://www.aip.org/physnews/update/', 'http://www.aip.org/servlet/Searchphys?SearchPage=%2Fphysnews%2Fupdate%2Fsearch.htm&collection=K2PHYSNEWS&queryText={$formKeywords}', NULL, 2),
(1916, 375, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 8),
(1917, 375, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 9),
(1915, 375, 'FYI: The AIP Bulletin of Science Policy News', 'FYI: The AIP Bulletin of Science Policy News summarizes science policy developments in Washington, D.C. affecting the physics and astronomy community. Summaries are approximately one page long and are issued two or more times every week.', 'http://www.aip.org/enews/fyi/searchfyi.html', 'http://www.aip.org/servlet/Searchfyi?collection=K2NEWFYI&filename=%2Fweb2%2Faipcorp%2Ffyi%2F2004&SEARCH-97.x=64&SEARCH-97.y=18&queryText={$formKeywords}', NULL, 7),
(1914, 375, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1913, 375, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1912, 375, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1910, 375, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1911, 375, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1909, 375, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1908, 375, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1907, 374, 'Nature Physics Portal', 'The Nature physics portal is a one-stop resource for physicists, providing highlights of the latest research in Nature and elsewhere.  Nature Physics Portal online contains the physics content of the current issue, including Articles, Letters to Nature, Brief Communications, News and Views and portal extras.', 'http://www.nature.com/physics/index.html', 'http://search.nature.com/search/?sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp_t=results&sp_q_1=Physics&sp-x-2=ujournal&sp-p-2=phrase&sp-x-1=subject&sp-p-1=phrase&sp-q={$formKeywords}', NULL, 0),
(1906, 373, 'CERN Document Server (CDS)', 'Over 650,000 bibliographic records, including 320,000 fulltext documents, of interest to people working in particle physics and related areas. Covers preprints, articles, books, journals, photographs, and much more.', 'http://cdsweb.cern.ch/', 'http://cdsweb.cern.ch/search.py?f=&c=&p={$formKeywords}', NULL, 0),
(1904, 372, 'PhysLink.com Astronomy Education Resources', 'The PhysLink.com is a comprehensive physics and astronomy online education, research and reference web site.  Contains links to related news, jobs, societies, reference sources, scientific journals, and high-tech companies.', 'http://www.physlink.com/Education/Astronomy.cfm', 'http://physlink.master.com/texis/master/search/?s=SS&q={$formKeywords}', NULL, 0),
(1905, 372, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 1),
(1903, 371, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(1902, 370, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(1901, 370, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1900, 370, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1897, 369, 'Physics Today Events Calendar', 'Events such as conferences and meetings collected by Physics Today.', 'http://www.aip.org/cal/eventhome.jsp', 'http://www.aip.org/cal/results.jsp?category=&country=&month=&year=2006&image2.x=30&image2.y=6&subject={$formKeywords}', NULL, 0),
(1898, 369, 'PhysicsWeb - Calendar', 'PhysicsWeb - Calendar provides information on physics conferences, workshops, and summer schools.', 'http://www.physicsweb.org/events/', 'http://physicsworld.com/cws/Search.do?section=events&query={$formKeywords}', NULL, 1),
(1899, 370, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1895, 368, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 3),
(1896, 368, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 4),
(1893, 368, 'National Academy Press(NAP)', 'The National Academy Press (NAP) publishes over 200 books a year on a wide range of topics in science, engineering, and health, capturing the most authoritative views on important issues in science and health policy.', 'http://books.nap.edu/books/0309070317/html/177.html', 'http://search.nap.edu/nap-cgi/napsearch.cgi?term={$formKeywords}', NULL, 1),
(1894, 368, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 2),
(1892, 368, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1891, 367, 'HighWire', 'HighWire contains 11,785,877 articles in over 4,500 Medline journals, as well as 404,484 free full text articles from 322 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?author1=&pubdate_year=&volume=&firstpage=&src=hw&hits=10&hitsbrief=25&resourcetype=1&andorexactfulltext=and&fulltext={$formKeywords}', NULL, 8),
(1890, 367, 'CERN Document Server', 'Over 650,000 bibliographic records, including 320,000 fulltext documents, of interest to people working in particle physics and related areas. Covers preprints, articles, books, journals, photographs, and much more.', 'http://cdsweb.cern.ch/?ln=en', 'http://cdsweb.cern.ch/search.py?sc=1&ln=en&f=&cc=CERN+Document+Server&c=Articles+%26+Preprints&c=Books+%26+Proceedings&c=Presentations+%26+Talks&c=Periodicals+%26+Progress+Reports&c=Multimedia+%26+Outreach&c=Archives&p={$formKeywords}', NULL, 7),
(1889, 367, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 6),
(1888, 367, 'Physics Documents Worldwide (PhysDoc)', 'Physics Documents Worldwide (PhysDoc) offers lists of links to document sources, such as preprints, research reports, annual reports, and list of publications of worldwide distributed physics institutions and individual physicists, ordered by continent, country and town.', 'http://physnet.uni-oldenburg.de/PhysNet/physdoc.html#search', 'http://www.physnet.de/PhysNet/physdocsearch.html?errorflag=0&caseflag=on&wordflag=on&maxobjflag=200&opaqueflag=on&descflag=on&csumflag=off&verbose=off&broker=PhysDoc&domain=physnet.de&query={$formKeywords}', NULL, 5),
(1887, 367, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/index.jsp?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 4),
(1886, 367, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 3),
(1885, 367, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 2),
(1884, 367, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1883, 367, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://lss.fnal.gov/ird/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/wwwbrief?r=fermilab&AUTHOR=&r=&REPORT-NUM=&r=&DATE=&*=+&r=fermilab&format=wwwbrief&TITLE={$formKeywords}', NULL, 0),
(1882, 366, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(1881, 366, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(1880, 366, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(1879, 366, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(1878, 366, 'Eric Weisstein''s World of Physics', 'Online encyclopedia of physics terms and formulas. Full searchable, and also browsable alphabetically and by topic. Part of Eric''s Treasure Troves of Science.', 'http://scienceworld.wolfram.com/physics/', 'http://scienceworld.wolfram.com/search/?q={$formKeywords}', NULL, 1),
(1877, 366, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1876, 365, 'HighWire', 'HighWire contains 11,785,877 articles in over 4,500 Medline journals, as well as 404,484 free full text articles from 322 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 10),
(1874, 365, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 8),
(1875, 365, 'SPIRES', 'SPIRES provides search more than 450,000 high-energy physics related articles, including journal papers, preprints, e-prints, technical reports, conference papers and theses.', 'http://www.slac.stanford.edu/spires/hep/', 'http://www.slac.stanford.edu/spires/find/hep/www?TITLE=&C=&REPORT-NUM=&AFFILIATION=&cn=&k=&cc=&eprint=+&eprint=&topcit=&url=&J=+&*=&ps=+&DATE=&*=+&FORMAT=WWW&SEQUENCE=&AUTHOR={$formKeywords}', NULL, 9),
(1873, 365, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/index.jsp?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 7),
(1709, 334, 'EULER', 'EULER provides a world reference and delivery service, transparent to the end user and offering full coverage of the mathematics literature world-wide, including bibliographic data, peer reviews and/or abstracts, indexing, classification and search, transparent access to library services, co-operating with commercial information providers (publishers, bookstores).', 'http://www.emis.ams.org/projects/EULER/', 'http://www.emis.de/projects/EULER/search?q={$formKeywords}', NULL, 2),
(1707, 334, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 0),
(1708, 334, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1706, 333, 'Eric Weisstein''s MathWorld', 'Eric Weisstein''s MathWorld is a comprehensive mathematics information bank. The site currently consists of some 10,228 searchable entries, 89,364 cross-references, 4,205 figures, 125 animated graphics, 964 live Java applets and receives an average of 135 updates and new entries each month.', 'http://mathworld.wolfram.com/', 'http://mathworld.wolfram.com/search/?x=0&y=0&query={$formKeywords}', NULL, 0),
(1704, 331, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(1705, 332, 'MacTutor History of Mathematics', 'Includes biographies of more than 1100 mathematicians and a special index of women mathematicians.', 'http://www-groups.dcs.st-and.ac.uk/%7Ehistory/index.html', 'http://www-history.mcs.st-andrews.ac.uk/Search/historysearch.cgi?SUGGESTION={$formKeywords}', NULL, 0),
(1703, 331, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1702, 331, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1701, 331, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1700, 330, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(1698, 330, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(1699, 330, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(1697, 330, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(1695, 330, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1696, 330, 'Wolfram Research''s Mathematical Functions', 'More than 37,000 facts about mathematical functions as of July 2003. This site was created as a resource for the educational, mathematical, and scientific communities. It contains the world''s most encyclopedic collection of information about mathematical functions. The site also details the interrelationships between the special functions of mathematical physics and the elementary functions of mathematical analysis as well as the interrelationships between the functions in each group.', 'http://functions.wolfram.com/', 'http://functions.wolfram.com/search/index.cgi?filter=1&q={$formKeywords}', NULL, 1),
(1694, 329, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 8),
(1692, 329, 'MathSearch', 'an excellent tool for searching the contents of more than 80,000 mathematics pages world wide, via Sydney University work, network security, digital signal processing and related topics.', 'http://www.maths.usyd.edu.au:8000/MathSearch.html', 'http://www.maths.usyd.edu.au:8000/s/search/p?p2=&p3=&p4=&p1={$formKeywords}', NULL, 6),
(1693, 329, 'MPRESS/MATHNET', 'MPRESS/MathNet is a concept/installation to provide quality indexing of mathematical preprints (servers). It is in itself operated in a distributed way. MPRESS improves access to the full texts of preprints in mathematics by means of metadata and provides comprehensive and easily searchable information on the preprints available.', 'http://mathnet.preprints.org/', 'http://mathnet.preprints.org/cgi-bin/harvest/MPRESS.pl.cgi?title=&metaquery=&keyword=&query=&broker=FraGer&errorflag=0&wordflag=off&opaqueflag=off&csumflag=off&maxobjflag=10000&maxlineflag=10000&maxresultflag=10000&author={$formKeywords}', NULL, 7),
(1691, 329, 'Math Archives: Topics in Mathematics', 'A large, searchable collection of categorized teaching materials, software, and Web links. While not annotated, keywords for each site provide insight into the site''s offerings.', 'http://archives.math.utk.edu/topics/', 'http://www.google.com/search?q=site%3Aarchives.math.utk.edu+topics+{$formKeywords}', NULL, 5),
(1690, 329, 'EULER', 'EULER provides a world reference and delivery service, transparent to the end user and offering full coverage of the mathematics literature world-wide, including bibliographic data, peer reviews and/or abstracts, indexing, classification and search, transparent access to library services, co-operating with commercial information providers (publishers, bookstores).', 'http://www.emis.ams.org/projects/EULER/', 'http://www.emis.de/projects/EULER/search?q={$formKeywords}', NULL, 4),
(1689, 329, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(1688, 329, 'OAIster (Open Archives Inititive research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(1687, 329, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1686, 329, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1684, 328, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1685, 328, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1682, 328, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1683, 328, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1681, 327, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(1679, 327, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(1680, 327, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(1678, 327, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(1676, 327, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(1677, 327, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(1674, 327, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(1675, 327, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(1672, 327, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1673, 327, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(1671, 326, 'RAND Research', 'For more than 50 years, the RAND Corporation has pursued its nonprofit mission by conducting research on importand and complicated problems. Initially, RAND (the name of which was derived from a contraction of the term research and development) focused on issues of national security. Eventually, RAND expanded its intellectual reserves to offer insight into other areas, such as business, education, health, law, and science. RAND''s innovative approach to problem solving has become the benchmark for all other "think tanks" that followed. Hot Topics in RAND Research analyzes education and world issues.', 'http://www.rand.org/hot_topics/index.html', 'http://vivisimo.rand.org/vivisimo/cgi-bin/query-meta?input-form=simple&Go=Search&query={$formKeywords}', NULL, 3),
(1670, 326, 'High Beam Research', 'High Beam Research is a single search engine for all subjects. Will search and deliver results by email. Abstract and text for subscribers only.', 'http://www.highbeam.com/library/index.asp', 'http://www.highbeam.com/Search.aspx?st=NL&nml=True&t=&a=&src=ALM&src=BOOKS&src=DICT&src=ENCY&src=MAGS&src=MAPS&src=NEWS&src=PICS&src=THES&src=TRAN&src=WHITEPAPER&count=10&offset=0&sort=RK&sortdir=D&pst=INCLUDE_ALL&cn=&storage=ALL&display=ALL&sponsor=ALL&docclass=ALL&relatedid=&bid=&embargo=False&q={$formKeywords}', NULL, 2),
(1668, 326, 'BBC Learning', 'BBC Online - Education BBC Education. Access to excellent learning resources for adults and children. Lots of subjects - history, science, languages, health, work skills, culture, technology, arts, literature, business, nature, life, leisure.', 'http://www.bbc.co.uk/learning/', 'http://www.bbc.co.uk/cgi-bin/search/results.pl?go.x=0&go.y=0&go=go&uri=%2Flearning%2F&q={$formKeywords}', NULL, 0),
(1669, 326, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 1),
(1667, 325, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(1666, 325, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1664, 325, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1665, 325, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1663, 324, 'Quotations Page', 'Searchable database of several quotation resources on the Internet. See the Quotations Collections for a description of each.', 'http://www.quotationspage.com/', 'http://www.quotationspage.com/search.php3?Author=&C=mgm&C=motivate&C=classic&C=coles&C=lindsly&C=poorc&C=net&C=devils&C=contrib&x=60&y=11&Search={$formKeywords}', NULL, 1),
(1660, 322, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 3),
(1661, 323, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 0),
(1662, 324, 'Bartlett''s Familiar Quotations', 'A collection of passages, phrases, and proverbs traced to their sources in ancient and modern literature (1919 edition).', 'http://www.bartleby.com/100/', 'http://www.bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=col100%20&x=9&y=11&query={$formKeywords}', NULL, 0),
(1658, 322, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 1),
(1659, 322, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 2),
(1656, 321, 'Leonardo Digital Book Reviews', 'Leonardo Digital Book reviews from the International Society for the Arts, Sciences and Technology', 'http://www.leonardo.info/', 'http://www.google.com/search?hl=en&btnG=Search&q=site%3Awww.leonardo.info%2Freviews%2F+{$formKeywords}', NULL, 3),
(1657, 322, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase. At this point, a total of 15,000 of 750,000 records are loaded into the database. Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/content.asp?l1=5&l2=23&l3=44&l4=25', 'http://www.crl.edu/DBSearch/dissertationsSummary.asp?language=English&title={$formKeywords}', NULL, 0),
(1655, 321, 'CM : Canadian Review of Materials', 'CM: Canadian Review of Materials is an electronic reviewing journal. CM reviews Canadiana of interest to children and young adults, including publications produced in Canada, or published elsewhere but of special interest or significance to Canada, such as those having a Canadian writer, illustrator or subject. We review books, video and audio recordings and CD-ROMs.', 'http://www.umanitoba.ca/cm/', 'http://google.cc.umanitoba.ca/search?btnG=Search&sort=date%3AD%3AL%3Ad1&output=xml_no_dtd&site=default_collection&ie=UTF-8&oe=UTF-8&client=default_frontend&proxystylesheet=default_frontend&as_dt=i&as_sitesearch=http%3A%2F%2Fwww.umanitoba.ca%2Foutreach%2Fcm&q={$formKeywords}', NULL, 2),
(1654, 321, 'New York Review of Books', 'Lengthy reviews from the well-respected print publication. The keyword-searchable archive covers 1983 to the present, with some free, many pay-per-view.', 'http://www.nybooks.com/index', 'http://www.nybooks.com/archives/search?author_name=%20&reviewed_author=&reviewed_item=&form=&year=&title={$formKeywords}', NULL, 1),
(1653, 321, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 0),
(1651, 320, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1652, 320, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(1650, 320, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1649, 320, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1648, 319, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1647, 319, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1646, 319, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1645, 319, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1644, 319, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1641, 318, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(1642, 319, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1643, 319, 'The Government of Canada', 'ou can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(2355, 452, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 1),
(2354, 452, 'Space Science Education Resource Directory', 'Space Science Education Resource Directory is a convenient way to find NASA space science products for use in classrooms, science museums, planetariums, and other settings.', 'http://teachspacescience.org/cgi-bin/ssrtop.plex', 'http://teachspacescience.org/cgi-bin/search.plex?mode=basic&bgrade=allgrades&btopic=alltopics&submit.x=47&submit.y=14&keywords={$formKeywords}', NULL, 0),
(2353, 451, 'Scholarly Societies Project Meeting/Conference Announcement List', 'Scholarly Societies Project Meeting/Conference Announcement List is a searchable service provided by the University of Waterloo (Canada) Scholarly Societies Project.', 'http://www.lib.uwaterloo.ca/society/meetings.html', 'http://ssp-search.uwaterloo.ca/cd.cfm', 'search_type=advanced&field1=any&boolean1=and&operator1=and&field2=any&textfield2=&boolean2=and&operator2=and&field3=any&textfield3=&boolean3=and&operator3=and&founded=none&after=&before=&Go8=Search&textfield1={$formKeywords}', 1),
(2352, 451, 'International Astronomy Meetings List', 'International Astronomy Meetings List provides links to the meeting web page, contact e-mail addresses, and abstracts provided by NASA''s Astrophysics Data System (ADS) if, and when they are available.', 'http://cadcwww.dao.nrc.ca/meetings/meetings.html', 'http://cadcwww.dao.nrc.ca/cadcbin/wdb/cadcmisc/meetings/query?tab_meeting_no=on&meeting_no=&tab_title=on&web=&tab_location=on&location=&contact=&email=&address=&tab_date_start=on&date_start=&tab_end_date=on&end_date=&max_rows_returned=10&title=&keywords={$formKeywords}', NULL, 0),
(2351, 450, 'UK Astronomy Data Centre', 'UK Astronomy Data Centre houses a good selection of data from the UK''s ground based telescopes as well as a number of catalogues.', 'http://archive.ast.cam.ac.uk/', 'http://archive.ast.cam.ac.uk/cgi-bin/wdb/wfsurvey/wfsurvey/query?tab_date_obs=on&date_obs=&tab_utstart=on&utstart=&tab_object=on&object=&tab_runno=on&runno=&tab_fband=on&fband=&tab_fsys=on&fsys=&tab_exposure=on&exposure=&box=00+30+00&tab_ra=on&ra=&tab_dec=on&scionly=on&max_rows_returned=1500&dec={$formKeywords}', NULL, 1),
(2350, 450, 'HEASARC', 'HEASARC is a source of gamma-ray, X-ray, and extreme ultraviolet observations of cosmic (non-solar) sources. This site provides access to archival data, associated analysis software, data format standards, documentation, expertise in how to use them, as well as relevant educational and outreach material.', 'http://heasarc.gsfc.nasa.gov/', 'http://heasarc.gsfc.nasa.gov/cgi-bin/search/search.pl?tquery={$formKeywords}', NULL, 0),
(2349, 449, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(2348, 448, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(2347, 448, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(2346, 448, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is raning from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2345, 448, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&frm=smp.x&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&p00={$formKeywords}', NULL, 1),
(2344, 448, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2342, 447, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2343, 447, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2341, 447, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2340, 447, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2339, 446, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 7),
(2338, 446, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?author1=&pubdate_year=&volume=&firstpage=&src=hw&hits=10&hitsbrief=25&resourcetype=1&andorexactfulltext=and&fulltext={$formKeywords}', NULL, 6),
(2337, 446, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://fnalpubs.fnal.gov/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/www?AUTHOR=&C=&REPORT-NUM=&AFFILIATION=&cn=&k=&cc=&eprint=+&eprint=&topcit=&url=&J=+&*=&ps=+&DATE=&*=+&FORMAT=WWW&SEQUENCE=&TITLE={$formKeywords}', NULL, 5),
(2336, 446, 'Astrophysics Data System', 'Astrophysics Data System contains abstracts from hundreds of publications, colloquia, symposia, proceedings, and internal NASA reports, and provides free and unrestricted access to scanned images of journals, conference proceedings and books in Astronomy and Astrophysics.', 'http://adsabs.harvard.edu/abstract_service.html', 'http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?db_key=AST&sim_query=YES&aut_xct=NO&aut_logic=OR&obj_logic=OR&author=&object=&start_mon=&start_year=&end_mon=&end_year=&ttl_logic=OR&txt_logic=OR&text=&nr_to_return=100&start_nr=1&start_entry_day=&start_entry_mon=&start_entry_year=&min_score=&jou_pick=ALL&ref_stems=&data_and=ALL&group_and=ALL&sort=SCORE&aut_syn=YES&ttl_syn=YES&txt_syn=YES&aut_wt=1.0&obj_wt=1.0&ttl_wt=0.3&txt_wt=3.0&aut_wgt=YES&obj_wgt=YES&ttl_wgt=YES&txt_wgt=YES&ttl_sco=YES&txt_sco=YES&version=1&title={$formKeywords}', NULL, 4),
(2335, 446, 'Astronomy Resources from STScI', 'Astronomical Internet resources by the Space Telescope Science Institute.', 'http://www.stsci.edu/science/net-resources.html', 'http://www.stsci.edu/resources/WebSearch?uq=&notq=&command=Submit&query={$formKeywords}', NULL, 3),
(2334, 446, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 2),
(2332, 446, 'AstroLinks', 'AstroLinks provides links that will lead you to a voluminous amount of astronomical data and information.', 'http://www.astro.univie.ac.at/', 'http://www.google.com/search?q=site%3Aastro.univie.ac.at+', NULL, 0),
(2333, 446, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(2331, 445, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(2330, 445, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(2329, 445, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(2328, 445, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(2326, 445, 'Encyclopedia of Astronomy and Astrophysics', 'Encyclopedia of Astronomy and Astrophysics is the most comprehensive reference on astronomy and astrophysics ever published. Comprising more than 2.5 million words, the site provides 24-hour free trial and 30 day free institutional trial.', 'http://www.ency-astro.com/', 'http://eaa.iop.org/index.cfm?action=search.home&quick=1&field1=&newsearch=1&coll=ft&query1={$formKeywords}', NULL, 1),
(2327, 445, 'Encyclopedia Astronautica', 'Encyclopedia Astronautica is likely the best source for international space flight information.', 'http://www.astronautix.com/', 'http://www.google.com/custom?sa=Search&cof=L%3Ahttp%3A%2F%2Fwww.astronautix.com%2Fgraphics%2Fl%2Flogo.gif%3BAH%3Acenter%3BGL%3A0%3BAWFID%3A3cf675793eb3c420%3B&sitesearch=www.astronautix.com&domains=www.astronautix.com&q={$formKeywords}', NULL, 2),
(2324, 444, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 10),
(2325, 445, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2322, 444, 'Fermilab Preprint Server search engine', 'Fermilab Preprint Server search engine maintains a searchable archive of preprints since 1972. Full-text of preprints from 1995 to present are currently available.', 'http://fnalpubs.fnal.gov/preprints.html', 'http://www-spires.fnal.gov/spires/find/hep/wwwscan?subfile=wwwhepau&submit=Browse&rawcmd=', NULL, 8),
(2323, 444, 'NASA Technical Reports Server', 'NASA Technical Reports Server allows users to search available online NASA published documents, including meeting presentations, journal articles, conference proceedings, and technical reports. Many documents are available in compressed PostScript and PDF formats. All documents are unclassified and publicly available.', 'http://ntrs.nasa.gov/?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 9),
(2319, 444, 'AstroLinks', 'AstroLinks provides links that will lead you to a voluminous amount of astronomical data and information.', 'http://www.astro.univie.ac.at/', 'http://www.google.com/search?q=site%3Aastro.univie.ac.at+{$formKeywords}', NULL, 5),
(2320, 444, 'Astronomy Resources from STScI', 'Astronomical Internet resources by the Space Telescope Science Institute.', 'http://www.stsci.edu/science/net-resources.html', 'http://www.stsci.edu/resources/WebSearch?uq=&notq=&command=Submit&query={$formKeywords}', NULL, 6),
(2321, 444, 'Astrophysics Data System', 'Astrophysics Data System contains abstracts from hundreds of publications, colloquia, symposia, proceedings, and internal NASA reports, and provides free and unrestricted access to scanned images of journals, conference proceedings and books in Astronomy and Astrophysics.', 'http://adsabs.harvard.edu/abstract_service.html', 'http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?db_key=AST&sim_query=YES&aut_xct=NO&aut_logic=OR&obj_logic=OR&object=&start_mon=&start_year=&end_mon=&end_year=&ttl_logic=OR&txt_logic=OR&text=&nr_to_return=100&start_nr=1&start_entry_day=&start_entry_mon=&start_entry_year=&min_score=&jou_pick=ALL&ref_stems=&data_and=ALL&group_and=ALL&sort=SCORE&aut_syn=YES&ttl_syn=YES&txt_syn=YES&aut_wt=1.0&obj_wt=1.0&ttl_wt=0.3&txt_wt=3.0&aut_wgt=YES&obj_wgt=YES&ttl_wgt=YES&txt_wgt=YES&ttl_sco=YES&txt_sco=YES&version=1&title=&author={$formKeywords}', NULL, 7),
(2318, 444, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(2316, 444, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(2317, 444, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(2315, 444, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(2314, 444, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2313, 443, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2310, 443, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2311, 443, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2312, 443, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2309, 442, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(2308, 442, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(2307, 442, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(2305, 442, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 5),
(2306, 442, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(2304, 442, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(2302, 442, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(2303, 442, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(2301, 442, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(2300, 442, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2299, 441, 'Thomas Legislative Information on the Internet', 'Through Thomas, the Library of Congress offers the text of bills in the United States Congress, the full text of the Congressional Record, House and Senate committee reports, and historical documents.', 'http://thomas.loc.gov/', 'http://thomas.loc.gov/cgi-bin/thomas', 'congress=109&database=text&MaxDocs=1000&querytype=phrase&Search=SEARCH&query={$formKeywords}', 11),
(2298, 441, 'Rulers', 'This site contains lists of heads of state and heads of government (and, in certain cases, de facto leaders not occupying either of those formal positions) of all countries and territories, going back to about 1700 in most cases. Also included are the subdivisions of various countries, recent foreign ministers of all countries, and a selection of international organizations, religious leaders and a chronicle of relevant events since 1996.', 'http://www.rulers.org/', 'http://www.google.com/search?q=site%3Arulers.org&q={$formKeywords}', NULL, 10),
(1639, 318, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(1640, 318, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(1638, 318, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(1637, 318, 'Encyclopedia.com', 'Online version of the Concise Electronic Encyclopedia. Entries are very short, so this site is better suited for fact checking than research.', 'http://www.encyclopedia.com/', 'http://www.encyclopedia.com/searchpool.asp?target={$formKeywords}', NULL, 2),
(1635, 318, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1636, 318, 'Columbia Encyclopedia', 'Serving as a "first aid" for those who read, the sixth edition of the Columbia Encyclopedia contains over 51,000 entries with 80,000 hypertext links.', 'http://www.bartleby.com/65/', 'http://www.bartleby.com/cgi-bin/texis/webinator/65search?search_type=full&query={$formKeywords}', NULL, 1),
(1634, 317, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(1633, 317, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(1632, 317, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 1),
(1631, 317, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1630, 316, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1629, 316, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1627, 316, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1628, 316, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1625, 315, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(1626, 315, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(1623, 315, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(1624, 315, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(1619, 314, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(1620, 314, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(1621, 315, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1622, 315, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/news/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(1618, 314, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1617, 314, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1615, 314, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1616, 314, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1614, 314, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1613, 314, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1612, 314, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1611, 313, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 1),
(1610, 313, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', NULL, 0),
(1608, 311, 'TechCalendar', 'TechCalendar is a searchable/browseable event directory, with categories such as: Internet/Online, Communications, Software & Services, Vertical Markets, Computing Platforms, and Computing Industry.', 'http://www.techweb.com/calendar/', 'http://www.tsnn.com/partner/results/results_techweb.cfm?city=&select=-1&country=-1&classid=120&Month=-1&subject={$formKeywords}', NULL, 3),
(1609, 312, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(1607, 311, 'Netlib Conferences Databases', 'The Netlib Conferences Databases contains information about upcoming conferences, lectures, and other meetings relevant to the fields of mathematics and computer science.', 'http://www.netlib.org/confdb/confsearch.html', 'http://netlib2.cs.utk.edu/cgi-bin/csearch/confdisp.pl?ip_address=160.36.58.108&ip_name=netlib-old.cs.utk.edu&tcp_port=8123&database_name=%2Fusr%2Flocal%2Fwais%2Findexes%2Fconfdb&search_term={$formKeywords}', NULL, 2),
(1606, 311, 'DB and LP: Conferences and Workshops', 'DB and LP: Conferences and Workshops contains a list of computer science conferences and Workshops: past, present and future.', 'http://www.informatik.uni-trier.de/~ley/db/conf/index.a.html', 'http://www.google.com/search?hl=en&lr=&q=site%3Awww.informatik.uni-trier.de%2F+conf+{$formKeywords}', NULL, 1),
(1605, 311, 'All Conferences Directory', 'All Conferences Directory is a searchable database of Computer Science and Technology conferences that organizes conferences by category and offers information regarding paper submission deadlines.', 'http://all-conferences.com/Computers/', 'http://www.allconferences.com/Search/search.php3?Search={$formKeywords}', NULL, 0),
(1604, 310, 'XML.com', 'An exhaustive site on all things XML (Extensible Markup Language), from schemas and style to the Semantic Web. Largely oriented toward power users, but includes useful FAQs for newcomers. Searchable. From the O''Reilly & Associates publishing house. ', 'http://www.xml.com/', 'http://search.atomz.com/search/?sp-a=sp1000a5a9&sp-f=ISO-8859-1&sp-t=cat_search&sp-x-1=collection&sp-q-1=xml&sp-q={$formKeywords}', NULL, 2),
(1603, 310, 'Request For Comments (RFCs)', 'The Requests for Comments (RFC) document series is a set of technical and organizational notes about the Internet (originally the ARPANET), beginning in 1969. Memos in the RFC series discuss many aspects of computer networking, including protocols, procedures, programs, and concepts, as well as meeting notes, opinions, and sometimes humor.', 'http://www.rfc-editor.org/rfcsearch.html', 'http://www.rfc-editor.org/cgi-bin/rfcsearch.pl?opt=All+Fields&num=25&filefmt=txt&search_doc=search_all&match_method=prefix&sort_method=newer&abstract=absoff&keywords=keyoff&format=ftp&searchwords={$formKeywords}', NULL, 1),
(1601, 309, 'USPTO', 'USPTO databases cover the period from 1 January 1976 to the most recent weekly issue date (usually each Tuesday). Also has the ability to order patents within this system.', 'http://www.uspto.gov/', 'http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2Fsearch-bool.html&r=0&f=S&l=50&FIELD1=&co1=AND&TERM2=&FIELD2=&d=ptxt&TERM1={$formKeywords}', NULL, 2),
(1602, 310, 'The International Organization for Standardization (ISO)', 'The International Organization for Standardization (ISO) is a worldwide federation of national standards bodies from some 140 countries. ISO''s work has resulted in some 12,000 International Standards, representing more than 300,000 pages in English and French.', 'http://www.iso.ch/iso/en/CatalogueListPage.CatalogueList', 'http://www.iso.ch/iso/en/CombinedQueryResult.CombinedQueryResult?queryString={$formKeywords}', NULL, 0),
(1599, 309, 'Canadian Patents Database', 'Canadian Patent Database lets you access over 75 years of patent descriptions and images. You can search, retrieve and study more than 1,500,000 patent documents', 'http://patents1.ic.gc.ca/intro-e.html', 'http://patents1.ic.gc.ca/fcgi-bin/patquery_eo_el?-t=_&-l=ibm.html&-m=50&-c=/cpoti/prod/verity/coll/cpd&ERROR_MSG=Query failed with rc =&GENERAL={$formKeywords}', NULL, 0),
(1600, 309, 'Europe''s Network of Patent Databases (Esp@cenet)', 'Europe''s Network of Patent Databases (Esp@cenet) is a free service for accessing patent information. Four database files may be searched: (1)European Patents (most recent 24 months, with PDF files); (2) PCT(WO) patents (most recent 24 months, with PDF files); (3) worldwide patents (coverage depends on country, mostly back to 1960s or 1970s); and (4) Japanese patents (1976-present). Since 1970, each patent family in the collection has a representative document with a searchable English-language title and abstract.', 'http://ep.espacenet.com', 'http://v3.espacenet.com/results?AB=fiber&sf=q&FIRST=1&CY=ep&LG=en&DB=EPODOC&st=AB&Submit=SEARCH&=&=&=&=&=&kw={$formKeywords}', NULL, 1),
(1598, 308, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 0),
(1597, 307, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(1596, 307, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1595, 307, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1594, 307, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1593, 306, 'CompuScience', '"CompuScience" is a bibliographic database covering literature in the field of computer science and computer technology. Dating back to 1936, the database comprises about 656.378 citations.  CompuScience is integrated in io-port.net, the portal for computer science in Germany and Europe.  CompuScience contains the abstracts of the ACM Computing Reviews and the Computer Science Section of Zentralblatt für Mathematik (MATH database) and the abstracts of over 95 selected journals in this area. Citations contain bibliographic information and indexing terms. Many records also include an abstract. Most citations are classified according to the Computing Reviews Classification Scheme of ACM.', 'http://www.fiz-informationsdienste.de/en/DB/compusci/index.html', 'http://www.io-port.net/ioport2004/singlefieldSearch.do?feld1=fulltext&eingabe2=&eingabe3=&eingabe4=&eingabe5=&sortierung=jahr&query=&Abschicken=Suchen&eingabe1={$formKeywords}', NULL, 2),
(1592, 306, 'Engineering E-journal Search Engine (EESE)', 'The Engineering E-journal Search Engine (EESE) searches the full text of over 100 free and full text engineering e-Journals.', 'http://www.eevl.ac.uk/eese/index.html', 'http://www.eevl.ac.uk/eevl-cross-results.htm?tab=all&eevl_sect=eevl&exact=on&method=All&searchst={$formKeywords}', NULL, 1),
(1591, 306, 'Collection of Computer Science Bibliographies', 'Collection of Computer Science Bibliographies - A searchable collection of bibliographies from various sources, covering most aspects of computer science. Access references to journal articles, conference papers, & technical reports. The collection currently contains more than 2 millions of references (mostly to journal articles, conference papers and technical reports), clustered in about 1500 bibliographies, and consists of more than 2.3 GBytes (530MB gzipped) of BibTeX entries. More than 600 000 references contain cross references to citing or cited publications. More than 1 million of references contain URLs to an online version of the paper. Abstracts are available for more than 800 000 entries. There are more than 2000 links to other sites carrying bibliographic information.', 'http://liinwww.ira.uka.de/bibliography/index.html', 'http://liinwww.ira.uka.de/mpsbib?field=&year=&sincd=&before=&results=citation&maxnum=40&online=on&query={$formKeywords}', NULL, 0),
(1589, 305, 'Safari Tech Books Online', 'O''Reilly''s online technical reference library.', 'http://safari.oreilly.com', 'http://safari.oreilly.com/search?_formName=searchForm&searchlistbox=Entire Site&searchtextbox={$formKeywords}', NULL, 4),
(1590, 305, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 5),
(1587, 305, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1588, 305, 'O''Reilly Search', 'Search for books, articles, weblogs, conferences, and other resources published or maintained by O''Reilly & Associates, world-renowned publishers.', 'http://www.oreillynet.com/search/', 'http://catsearch.atomz.com/search/catsearch/?sp-a=sp1000a5a9&sp-f=ISO-8859-1&sp-t=cat_search&sp-advanced=1&sp-p=any&sp-d=custom&sp-date-range=-1&sp-q-1=&sp-x-1=collection&sp-c=10&sp-m=1&sp-s=0&sp-q={$formKeywords}', NULL, 3),
(1586, 305, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1585, 305, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1584, 304, 'HCI Bibliography: : Human-Computer Interaction Resources', 'The HCI Bibliography (HCIBIB) is a free-access bibliography on Human-Computer Interaction, with over 28,5000 records in a searchable database.', 'http://www.hcibib.org/', 'http://www.hcibib.org/gs.cgi?highlight=checked&action=Search&terms={$formKeywords}', NULL, 6),
(1583, 304, 'devx', 'devx provides full text of more than 100,000 indexed and searchable articles, reviews, and more.', 'http://www.devx.com/', 'http://www.google.com/custom?cof=T%3A%23000000%3BLW%3A70%3BBIMG%3Ahttp%3A%2F%2Fwww.devxcom%2Fimages%2Fredesign%2Fbackground2.gif%3BALC%3A%23000099%3BL%3Ahttp%3A%2F%2Fwww.devx.com%2Fimages%2Fredesign%2Fnewlogosm2.gif%3BLC%3A%23000099%3BLH%3A70%3BBGC%3AFAFAE6%3BAH%3Aleft%3BVLC%3A%23000099%3BGL%3A0%3BAWFID%3Aaf259f950e64cb71%3B&domains=devx.com%3Bprojectcool.com%3Bvb2themax.com&sitesearch=devx.com&sa.x=16&sa.y=25&q={$formKeywords}', NULL, 5),
(1582, 304, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 4),
(1581, 304, 'NCSTRL', 'NCSTRL is an international collection of computer science research reports and papers made available for non-commercial use from a number of participating institutions and archives. NCSTRL provides access to over 20,000 technical reports in computer science.', 'http://www.ncstrl.org:8900/ncstrl/index.html', 'http://www.ncstrl.org:8900/ncstrl/servlet/search?formname=simple&group=archive&sort=rank&fulltext={$formKeywords}', NULL, 3),
(1578, 304, 'arXiv.org', 'ArXiv is an e-print service in the fields of physics, mathematics, non-linear science and computer science.', 'http://arxiv.org/', 'http://arxiv.org/search?searchtype=all&query={$formKeywords}', NULL, 0),
(1579, 304, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 1),
(1580, 304, 'Collection of Computer Science Bibliographies', 'Contains about 1,200 bibliographies with over 1 million references, including over 100,000 web links to the full text of the article.', 'http://liinwww.ira.uka.de/bibliography/index.html#about', 'http://liinwww.ira.uka.de/csbib?online=&maxnum=200&sort=year&query={$formKeywords}', NULL, 2),
(1577, 303, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 7),
(1576, 303, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 6),
(1575, 303, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 5),
(1574, 303, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 4),
(1572, 303, 'WhatIs.com', 'WhatIs.com is an online encyclopedia of information technology terms.', 'http://whatis.techtarget.com/', 'http://whatis.techtarget.com/wsearchResults/1,290214,sid9,00.html?query={$formKeywords}', NULL, 2),
(1573, 303, 'Free On-Line Dictionary of Computing', 'FOLDOC is a searchable dictionary of acronyms, jargon, programming languages, tools, architecture, operating systems, networking, theory, conventions, standards, mathematics, telecoms, electronics, institutions, companies, projects, products, and history related to computing.', 'http://foldoc.org/', 'http://wombat.doc.ic.ac.uk/foldoc/foldoc.cgi?action=Search&query={$formKeywords}', NULL, 3),
(1570, 303, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1571, 303, 'Webopedia', 'Webopedia is an online dictionary with definitions of technical terms related to computers and the Internet.', 'http://www.webopedia.com/', 'http://search.internet.com/www.webopedia.com?IC_QueryDatabases=www.webopedia.com&IC_QueryText={$formKeywords}', NULL, 1),
(1569, 302, 'CiteSeer', 'CiteSeer makes available a broad, fully indexed, database of research papers from the various computer science fields.', 'http://citeseer.ist.psu.edu/cs', 'http://citeseer.ist.psu.edu/cs?submit=Search+Documents&cs=1&q={$formKeywords}', NULL, 8),
(1567, 302, 'arXiv.org', 'ArXiv is an e-print service in the fields of physics, mathematics, non-linear science and computer science.', 'http://arxiv.org/', 'http://arxiv.org/search?searchtype=all&query={$formKeywords}', NULL, 6),
(1568, 302, 'devx', 'devx provides full text of more than 100,000 indexed and searchable articles, reviews, and more.', 'http://www.devx.com/', 'http://www.google.com/custom?cof=T%3A%23000000%3BLW%3A70%3BBIMG%3Ahttp%3A%2F%2Fwww.devxcom%2Fimages%2Fredesign%2Fbackground2.gif%3BALC%3A%23000099%3BL%3Ahttp%3A%2F%2Fwww.devx.com%2Fimages%2Fredesign%2Fnewlogosm2.gif%3BLC%3A%23000099%3BLH%3A70%3BBGC%3AFAFAE6%3BAH%3Aleft%3BVLC%3A%23000099%3BGL%3A0%3BAWFID%3Aaf259f950e64cb71%3B&domains=devx.com%3Bprojectcool.com%3Bvb2themax.com&sitesearch=devx.com&sa.x=16&sa.y=25&q={$formKeywords}', NULL, 7),
(1566, 302, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 5),
(1565, 302, 'NCSTRL', 'NCSTRL is an international collection of computer science research reports and papers made available for non-commercial use from a number of participating institutions and archives. NCSTRL provides access to over 20,000 technical reports in computer science.', 'http://www.ncstrl.org:8900/ncstrl/index.html', 'http://www.ncstrl.org:8900/ncstrl/servlet/search?formname=simple&group=archive&sort=rank&fulltext={$formKeywords}', NULL, 4),
(1564, 302, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(1563, 302, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(1562, 302, 'Collection of Computer Science Bibliographies', 'Contains about 1,200 bibliographies with over 1 million references, including over 100,000 web links to the full text of the article.', 'http://liinwww.ira.uka.de/bibliography/index.html#about', 'http://liinwww.ira.uka.de/csbib?online=&maxnum=200&sort=year&query={$formKeywords}', NULL, 1),
(1561, 302, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1560, 301, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1559, 301, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1557, 301, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1558, 301, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1555, 300, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(1556, 300, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(1554, 300, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(1552, 300, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 5);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(1553, 300, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(1551, 300, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(1546, 299, 'EDSITEment', 'EDSITEment is a constantly growing collection of the most valuable online resources for teaching English, history, art history, and foreign languages.', 'http://edsitement.neh.gov/', 'http://marcopolosearch.org/MPSearch/Search_Results.asp?orgn_id=5&log_type=1&hdnFilter=+AND+%28%7Bsubject_social%241%7D%29&hdnPerPage=15&selUsing=all&txtSearchFor={$formKeywords}', NULL, 0),
(1547, 300, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1548, 300, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(1549, 300, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(1550, 300, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(1544, 298, 'H-Net Humanities and Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www.h-net.org/', 'http://www.h-net.org/logsearch/index.cgi?&type=keyword&hitlimit=25&field=&nojg=on&smonth=00&syear=1989&emonth=11&eyear=2004&order=relevance&phrase={$formKeywords}', NULL, 0),
(1545, 298, 'Humanist', 'Humanist is an international electronic seminar on the application of computers in the humanities. Its primary aim is to provide a forum for discussion of intellectual, scholarly, pedagogical, and social issues and for exchange of information among members.', 'http://www.princeton.edu/~mccarty/humanist/index.html', 'http://lists.village.virginia.edu/cgi-bin/AT-Humanistsearch.cgi?sp=sp&searchButton.x=15&searchButton.y=14&search={$formKeywords}', NULL, 1),
(1542, 297, 'Oxford Text Archive', 'Oxford Text Archive contains Scholarly electronic texts and linguistic corpora across the range of humanities disciplines, with emphasis on resources of more than 1,500 literary works by many major authors in Greek, Latin, English and a dozen or more other languages.', 'http://ota.ahds.ac.uk/', 'http://ota.ahds.ac.uk/search/search.perl?search=SIMPLE&author=&title={$formKeywords}', NULL, 3),
(1543, 297, 'Project Gutenberg', 'Project Gutenberg is the definitive Web site for this project to put out-of-copyright books online in full-text. More than 6,000 texts online so far.', 'http://www.gutenberg.net/', 'http://www.gutenberg.org/catalog/world/results?author=&etestnr=&title={$formKeywords}', NULL, 4),
(1540, 297, 'IPL Online Texts Collection', 'IPL Online Texts Collection contains over 19,000 titles that can be browsed by author, by title, or by Dewey Decimal Classification.', 'http://www.ipl.org/reading/books/', 'http://www.ipl.org/div/searchresults/?where=allv&words={$formKeywords}', NULL, 1),
(1541, 297, 'Linguistic Data Consortium', 'Linguistic Data Consortium supports language-related education, research and technology development by creating and sharing linguistic resources including data, tools and standards.', 'http://www.ldc.upenn.edu/', 'http://www.ldc.upenn.edu/Catalog/catalogSearchResults.jsp?ldc_catalog_id=&name=&author=&languages=&years=&types=&datasources=&projects=&applications=&and_or=1&and_or2=1&desc={$formKeywords}', NULL, 2),
(1539, 297, 'Electronic Text Center', 'Electronic Text Center reflects over 5,000 publicly accessible texts on history, literature, philosophy, religion, history of science. Texts are in English and other languages, including Latin, Japanese and Chinese.', 'http://etext.lib.virginia.edu/', 'http://etext.virginia.edu/etcbin/ot2www-ebooks?specfile=%2Ftexts%2Fenglish%2Febooks%2Febooks.o2w&docs=TEI2&sample=1-100&grouping=work&query={$formKeywords}', NULL, 0),
(1538, 296, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(1537, 296, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1534, 295, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 5),
(1535, 296, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1536, 296, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1533, 295, 'Romantic Circles: Byron, the Shelleys, Keats and their Contemporaries', 'A Web site that provides scholarly resources for the study of Romantic-period literature and culture.', 'http://www.rc.umd.edu/', 'http://www.rc.umd.edu/cgi-bin/search/search.pl?Match=1&Realm=Editions&submit=Search&Terms={$formKeywords}', NULL, 4),
(1532, 295, 'Dante Project (Dartmouth)', 'Searchable collection of texts including the Italian text of the Divine Comedy and commentaries.', 'http://dante.dartmouth.edu/', 'http://dante.dartmouth.edu/search_view.php?commentary[]=0&language=any&cantica=0&canto=&line={$formKeywords}', 'Cmd=Search&query={$formKeywords}', 3),
(1531, 295, 'History Guide', 'Subject gateway to scholarly relevant information in history with a focus on Anglo-American history and the history of Central and Western Europe.', 'http://www.historyguide.de/', 'http://www.historyguide.de/allegrosuche.php?start=0&suchterm={$formKeywords}', NULL, 2),
(1530, 295, 'Digital South Asia Library', 'On-line information about contemporary and historical South Asia - including full-text documents, statistical data, electronic images, cartographic representations, and pedagogical resources for language instruction.', 'http://dsal.uchicago.edu/', 'http://www.google.com/u/dsal?sa=Search&q={$formKeywords}', NULL, 1),
(1529, 295, 'Archives Portal', 'UNESCO, the United Nations Educational, Scientific, and Cultural Organization, provides a list of links to archives around the world with a Web presence.', 'http://portal.unesco.org/ci/en/ev.php-URL_ID=5761&URL_DO=DO_TOPIC&URL_SECTION=201.html', 'http://www.unesco.org/cgi-bin/webworld/portal_archives/cgi/search.cgi?search2=GO&query={$formKeywords}', NULL, 0),
(1528, 294, 'Map Collection, Perry-Castaneda', 'Displays selected digitized images from the printed map collection housed at the University of Texas at Austin.', 'http://www.lib.utexas.edu/maps/index.html', 'http://www.lib.utexas.edu:8080/search/utlol/search.jsp?collections=utlol&collections=utdatabases&queryText={$formKeywords}', NULL, 7),
(1527, 294, 'Literature, Arts, and Medicine Databases', 'The Literature, Arts, & Medicine Database is an annotated multimedia listing of prose, poetry, film, video and art that was developed to be a dynamic, accessible, comprehensive resource for teaching and research in MEDICAL HUMANITIES, and for use in health/pre-health, graduate and undergraduate liberal arts and social science settings.', 'http://litmed.med.nyu.edu/Main?action=aboutDB', 'http://google.med.nyu.edu/search?btnG=search&access=p&entqr=0&output=xml_no_dtd&sort=date%3AD%3AL%3Ad1&ud=1&client=litmed_test&oe=UTF-8&ie=UTF-8&proxystylesheet=litmed_test&site=litmed_test&q={$formKeywords}', NULL, 6),
(1525, 294, 'Archives Hub (UK)', 'A national gateway to descriptions of archives in UK universities and colleges.', 'http://www.archiveshub.ac.uk/', 'http://www.archiveshub.ac.uk/cgi-bin/deadsearch.cgi?server=SF&fieldidx1=descriptionWord&bool=AND&numreq=25&firstrec=1&format=sgml&noframes=0&maxrecs=50&firstrec=1&fieldcont1={$formKeywords}', NULL, 4),
(1526, 294, 'Catholic Encyclopedia', 'Contains full and authoritative information on Catholic interests, action, and doctrine.', 'http://www.newadvent.org/cathen/index.html', 'http://www.google.com/custom?domains=NewAdvent.org&sa=Search+New+Advent&sitesearch=NewAdvent.org&client=pub-8168503353085287&forid=1&ie=ISO-8859-1&oe=ISO-8859-1&safe=active&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3A336699%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BFORID%3A1%3B&hl=en&q={$formKeywords}', NULL, 5),
(1524, 294, 'A2A - Access to Archives', 'Contains catalogues describing archives held throughout England and dating from the 900s to the present day.', 'http://www.a2a.org.uk/', 'http://www.a2a.org.uk/search/doclist.asp?nb=0&nbKey=1&com=1&properties=0601&keyword={$formKeywords}', NULL, 3),
(1363, 263, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1364, 263, 'National Environmental Publications Internet Site (NEPIS)', 'The National Environmental Publications Information System began in 1997, to offer over 9,000 full text, online documents of the United States Environmental Protection Agency. Documents that are not available online can be ordered from the agency through NEPIS.', 'http://nepis.epa.gov/', 'http://nepis.epa.gov/Exe/ZyNET.exe?User=ANONYMOUS&Password=anonymous&Client=EPA&SearchBack=ZyActionL&SortMethod=h&SortMethod=-&MaximumDocuments=15&Display=hpfr&ImageQuality=r85g16%2Fr85g16%2Fx150y150g16%2Fi500&DefSeekPage=x&ZyAction=ZyActionS&Toc=&TocEntry=&QField=&QFieldYear=&QFieldMonth=&QFieldDay=&UseQField=&Docs=&IntQFieldOp=0&ExtQFieldOp=0&File=&SeekPage=&Back=ZyActionL&BackDesc=Contents+page&MaximumPages=1&ZyEntry=0&TocRestrict=n&SearchMethod=1&Time=&FuzzyDegree=0&Index=National+Environmental+Publications+Info&Query={$formKeywords}', NULL, 2),
(1365, 263, 'National Library for the Environment', 'A universal, timely, and easy-to-use single-point entry to quality environmental data and information for the use of all participants in the environmental enterprise.', 'http://www.ncseonline.org/nle/index.cfm?&CFID=8843778&CFTOKEN=66834254', 'http://www.ncseonline.org/NLE/CRS/detail.cfm?quickKeyword={$formKeywords}', NULL, 3),
(1366, 264, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1367, 264, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1368, 264, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1369, 264, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1370, 264, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1371, 264, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1372, 264, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1373, 265, 'EnviroLink', 'The EnviroLink Network has served as the online clearinghouse for environmental information since 1991.', 'http://www.envirolink.org/', 'http://www.envirolink.org/newsearch.html?searchfor={$formKeywords}', NULL, 0),
(1374, 266, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1375, 266, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1376, 266, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1377, 266, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(1378, 267, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/mind/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 0),
(1379, 268, 'Climate Data Inventories', 'Climate data inventories comprises a partial inventory of NCDC data sets and a complete list of weather observation stations, including inventory/station lists for U.S. and global surface data and inventory/station lists for U.S. and global upper air data.', 'http://lwf.ncdc.noaa.gov/oa/climate/climateinventories.html', 'http://crawl.ncdc.noaa.gov/search?site=ncdc&output=xml_no_dtd&client=ncdc&lr=&proxystylesheet=ncdc&oe=&q={$formKeywords}', NULL, 0),
(1380, 268, 'U.S. Geological Survey', 'The U.S. Geological Survey provides information to describe and understand the Earth. This information is used to: minimize loss of life and property from natural disasters; manage water, biological, energy, and mineral resources; enhance and protect the quality of life; and contribute to wise economic and physical development. This site describes its programs, projects, publications, research, jobs, library, and educational resources. It also provides links to news releases.', 'http://www.usgs.gov/', 'http://search.usgs.gov/query.html?col=usgs&col=top2000&ht=0&qp&qs=&qc=&pw=100%25&ws=1&la=&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&si=0=&qt={$formKeywords}', NULL, 1),
(1381, 269, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1382, 269, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1383, 269, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1384, 269, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(1385, 270, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1386, 270, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(1387, 270, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(1388, 270, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(1389, 270, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(1390, 270, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(1391, 270, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(1392, 270, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(1393, 270, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(1394, 270, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(1395, 271, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1396, 271, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1397, 271, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1398, 271, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1399, 272, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1400, 272, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(1401, 272, 'Scirus', 'Scirus searches both free and access controlled journal sources. It currently covers the Web, ScienceDirect, MEDLINE on BioMedNet, Beilstein on ChemWeb, Neuroscion, BioMed Central and Patents from the USPTO.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 2),
(1402, 272, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(1403, 272, 'Centers for Disease Control and Prevention (CDC)', 'The CDC Web site provides access to the full text of MMWR and other CDC publications and data archives. Publications are searchable through CDC Wonder.', 'http://www.cdc.gov/', 'http://www.cdc.gov/search.do?action=search&x=0&y=0&queryText={$formKeywords}', NULL, 4),
(1404, 272, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 5),
(1405, 272, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(1406, 272, 'NetPrints', 'NetPrints provides a place for authors to archive their completed studies before, during, or after peer review by other agencies. Its scope is original research into clinical medicine and health.', 'http://clinmed.netprints.org/search.dtl', 'http://www.google.com/search?hl=en&q=site%3Aclinmed.netprints.org+{$formKeywords}', NULL, 7),
(1407, 272, 'Intute: Health & Life Sciences', 'The Health and Life Sciences pages of Intute is a free online service providing you with access to the very best web resources for education and research, evaluated and selected by a network of subject specialists. There are over 31,000 resource descriptions listed here that are freely accessible for keyword searching or browsing.\n\nThis service was formerly known as BIOME.', 'http://www.intute.ac.uk/healthandlifesciences/', 'http://www.intute.ac.uk/healthandlifesciences/cgi-bin/search.pl?submit.x=20&submit.y=16&submit=Go&limit=0&subject=healthandlifesciences&term1={$formKeywords}', NULL, 8),
(1408, 273, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1409, 273, 'ADAM Medical Encyclopedia', 'The ADAM Medical Encyclopedia includes over 4,000 articles about diseases, tests, symptoms, injuries, and surgeries. It also contains an extensive library of medical photographs and illustrations.', 'http://www.nlm.nih.gov/medlineplus/encyclopedia.html', 'http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SHOWTOPICS=5&SERVER2=server2&SERVER1=server1&ASPECT=-1&START=0&END=0&x=29&y=10&PARAMETER={$formKeywords}', NULL, 1),
(1410, 273, 'Life Sciences Dictionary from BioTech', 'Life Sciences Dictionary from BioTech comprises 8,300+ terms relating to biochemistry, biotechnology, botany, cell biology and genetics, as well as selective entries on ecology, limnology, pharmacology, toxicology and medicine.', 'http://biotech.icmb.utexas.edu/search/dict-search.html', 'http://biotech.icmb.utexas.edu/search/dict-search2.html?bo1=AND&search_type=normal&def=&word={$formKeywords}', NULL, 2),
(1411, 273, 'MedTerms Medical Dictionary Index', 'MedTerms Medical Dictionary Index is a doctor-produced encyclopedic medical dictionary, almost daily updated. Can be browsed by using the A to Z Index above or by typing the term in the Search Box below and click.', 'http://www.medicinenet.com/script/main/AlphaIdx.asp?li=MNI&p=A_DICT', 'http://www.medicinenet.com/script/main/srchCont.asp?li=MNI&ArtTypeID=DICT&op=MM&SRC={$formKeywords}', NULL, 3),
(1412, 273, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 4),
(1413, 273, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 5),
(1414, 273, 'On-Line Medical Dictionary', 'The dictionary started in early 1997 and has grown, to contain over 46,000 definitions totalling 17.5 megabytes. Entries are cross-referenced to each other and to related resources elsewhere on the net. It is freely available on the Internet via the World-Wide Web.  OMD is a searchable dictionary created by Dr Graham Dark and contains terms relating to biochemistry, cell biology, chemistry, medicine, molecular biology, physics, plant biology, radiobiology, science and technology. It includes: acronyms, jargon, theory, conventions, standards, institutions, projects, eponyms, history, in fact anything to do with medicine or science.', 'http://cancerweb.ncl.ac.uk/cgi-bin/omd?', 'http://cancerweb.ncl.ac.uk/cgi-bin/omd?query={$formKeywords}', NULL, 6),
(1415, 273, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 7),
(1416, 273, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 8),
(1417, 274, 'Centers for Disease Control and Prevention (CDC)', 'The CDC Web site provides access to the full text of MMWR and other CDC publications and data archives. Publications are searchable through CDC Wonder.', 'http://www.cdc.gov/', 'http://www.cdc.gov/search.do?action=search&x=0&y=0&queryText={$formKeywords}', NULL, 0),
(1418, 274, 'ClinicalTrials.gov', 'ClinicalTrials.gov (National Institutes of Health) provides information for patients about clinical research studies.', 'http://www.clinicaltrials.gov', 'http://search.nhsdirect.nhs.uk/kbroker/nhsdirect/nhsdirect/search.lsim?hs=0&sm=0&ha=1054&sc=nhsdirect&mt=0&sb=0&nh=3&qt={$formKeywords}', NULL, 1),
(1419, 274, 'Scirus', 'Scirus searches both free and access controlled journal sources. It currently covers the Web, ScienceDirect, MEDLINE on BioMedNet, Beilstein on ChemWeb, Neuroscion, BioMed Central and Patents from the USPTO.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 2),
(1420, 274, 'Emedicine', 'Emedicine is a directory of free online medical articles and up-to-date, searchable, peer-reviewed medical textbooks for physicians, veterinarians, medical students, physician assistants, nurse practitioners, nurses and the public.', 'http://www.emedicine.com/', 'http://www.emedicine.com/cgi-bin/foxweb.exe/searchengine@/em/searchengine?boolean=and&book=all&maxhits=100&HiddenURL=&query={$formKeywords}', NULL, 3),
(1421, 274, 'HealthWeb', 'Provides links to evaluated information resources selected by librarians and information professionals at academic medical centers in the Midwest. The goal is to meet the health information needs of both health care professionals and consumers. A collaborative project of the health sciences libraries of the Greater Midwest Region (GMR), of the National Network of Libraries of Medicine (NN/LM), and of the Committee for Institutional Cooperation.', 'http://www.healthweb.org/', 'http://www.healthweb.org/quicksearch_results5.cfm?StartRow=1&maxrows=25&Criteria_required=You+Must+enter+a+Keyword&where=1&criteria={$formKeywords}', NULL, 4),
(1422, 274, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&author1=&src=ml&disp_type=&fulltext={$formKeywords}', NULL, 5),
(1423, 274, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(1424, 274, 'MEDLINEplus', 'MEDLINEplus will direct you to information to help answer health questions. It brings together, by health topic, authoritative information from the world''s largest medical library, the National Library of Medicine at the National Institutes of Health. Designed for both health professionals and consumers, this service provides extensive information about specific diseases and conditions.', 'http://medlineplus.gov/', 'http://search.nlm.nih.gov/medlineplus/query?DISAMBIGUATION=true&FUNCTION=search&SERVER2=server2&SERVER1=server1&PARAMETER={$formKeywords}', NULL, 7),
(1425, 274, 'NetPrints', 'NetPrints provides a place for authors to archive their completed studies before, during, or after peer review by other agencies. Its scope is original research into clinical medicine and health.', 'http://clinmed.netprints.org/search.dtl', 'http://www.google.com/search?hl=en&q=site%3Aclinmed.netprints.org+{$formKeywords}', NULL, 8),
(1426, 274, 'Intute: Health & Life Sciences', 'The Health and Life Sciences pages of Intute is a free online service providing you with access to the very best web resources for education and research, evaluated and selected by a network of subject specialists. There are over 31,000 resource descriptions listed here that are freely accessible for keyword searching or browsing.', 'http://www.intute.ac.uk/healthandlifesciences/', 'http://www.intute.ac.uk/healthandlifesciences/cgi-bin/search.pl?submit.x=20&submit.y=16&submit=Go&limit=0&subject=healthandlifesciences&term1={$formKeywords}', NULL, 9),
(1427, 275, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(1428, 276, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1429, 276, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1430, 276, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1431, 276, 'National Academy Press(NAP)', 'The National Academy Press (NAP) publishes over 200 books a year on a wide range of topics in science, engineering, and health, capturing the most authoritative views on important issues in science and health policy.', 'http://books.nap.edu/books/0309070317/html/177.html', 'http://search.nap.edu/nap-cgi/napsearch.cgi?term={$formKeywords}', NULL, 3),
(1432, 276, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 4),
(1433, 277, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1434, 277, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1435, 277, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1436, 277, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(1437, 277, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(1438, 278, 'Canadian Health Network', 'Canadian Health Network (Canada) The Canadian Health Network (CHN) is a growing network, bringing together the best information resources of leading Canadian and international health information.', 'http://www.canadian-health-network.ca/servlet/ContentServer?pagename=CHN-RCS/Page/HomePageTemplate&cid=1038611684536&c=Page&lang=En', 'http://www.canadian-health-network.ca/servlet/ContentServer?cid=1046357853421&pagename=CHN-RCS%2FPage%2FSearchPageTemplate&c=Page&lang=En&orderBy=ORDER_RANK&searchType=ALL_WORDS&logSearch=true&searchStr={$formKeywords}', NULL, 0),
(1439, 278, 'Directgov', 'Directgov is replacing UK online as the place to turn to for the latest and widest range of public service information from the UK government.', 'http://www.direct.gov.uk/Homepage/fs/en', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 1);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(1440, 278, 'HealthInsite', 'HealthInsite (Australia) aims to improve the health of Australians by providing easy access to quality information about human health.', 'http://www.healthinsite.gov.au', 'http://www.healthinsite.gov.au/search97cgi/s97_cgi?Action=FilterSearch&Filter=ve_quick_search_filter.hts&ResultErrorTemplate=ve_error.hts&ResultCount=10&ResultMaxDocs=600&gl_search_collection=full&searchtype=simple&collection=healthinsite_coll&SortSpec=Score+desc+VDKDate_Modified+desc+VdkMeta_Title+asc+vdktarget_comp_num+asc&ResultTemplate=ve_search_results_new.hts&gl_search_text={$formKeywords}', NULL, 2),
(1441, 278, 'NHS Direct', 'NHS Direct (UK) is a gateway to health information on the Internet in the United Kingdom. NHS Direct Online provides health advice and is supported by a 24 hour nurse advice and information help line.', 'http://www.nhsdirect.nhs.uk', 'http://search.nhsdirect.nhs.uk/kbroker/nhsdirect/nhsdirect/search.lsim?hs=0&sm=0&ha=1054&sc=nhsdirect&mt=0&sb=0&nh=3&qt={$formKeywords}', NULL, 3),
(1442, 278, 'PubMed Central', 'PubMed Central is a free online archive of full-text, peer-reviewed research papers in the life sciences.', 'http://pubmedcentral.nih.gov/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=pmc&cmd=search&pmfilter_Fulltext=on&pmfilter_Relevance=on&term={$formKeywords}', NULL, 4),
(1443, 279, 'Hardin Meta Directory of Internet Health Resources', 'List of lists compiled by the Hardin Library of the Health Sciences at the University of Iowa. Divided into longer, medium-sized and shorter lists of links. The Hardin MD Clean Bill of Health Award is given to the best sites that have connection rates of at least 93%.', 'http://www.lib.uiowa.edu/hardin/md/index.html', 'http://search.atomz.com/search/?sp-a=00050f6e-sp00000000&sp-q={$formKeywords}', NULL, 0),
(1444, 279, 'AMEDEO', 'AMEDEO has been created to serve the needs of healthcare professionals.  AMEDEO''s core components include weekly emails with bibliographic lists about new scientific publications, personal Web pages for one-time download of available abstracts, and an overview of the medical literature published in relevant journals over the past 12 to 24 months.', 'http://www.amedeo.com', 'http://www.google.com/custom?sa=Search&sitesearch=www.amedeo.com&q={$formKeywords}', NULL, 1),
(1445, 280, 'AMA Physician Select', 'This American Medical Association site provides addresses, specialties, education and other background information on licensed physicians in the U.S. and its possessions. Search by physician name or medical specialty.', 'http://www.ama-assn.org/aps/amahg.htm', 'http://search.ama-assn.org/Search/query.html?qc=public+amnews&qt={$formKeywords}', NULL, 0),
(1446, 280, 'Diseases Databases Ver 1.6; Medical lists and links', 'Diseases Databases Ver 1.6: medical lists and links - a cross-referenced index of human disease, medications, symptoms, signs, abnormal investigation findings etc.; provides a medical textbook-like index and search portal.', 'http://www.diseasesdatabase.com/begin.asp?gif=1', 'http://www.diseasesdatabase.com/item_choice.asp? bytSearchType=0&strUserInput={$formKeywords}', NULL, 1),
(1447, 280, 'Drugs.com', 'Drugs.com is a free resource for medical professionals and consumers providing convenient and reliable drug information. Drug monographs are presented at both professional (USPDI), and consumer levels. The drug information could be found by browsing the alphabetical listing of the drugs or by search using generic or trade name. The drug interaction guide allows check for drug-drug and drug-food interactions.', 'http://www.drugs.com/', 'http://www.drugs.com/search.php?is_main_search=1&searchterm={$formKeywords}', NULL, 2),
(1448, 280, 'National Center for Biotechnology Information', 'In addition to maintaining the GenBank nucleic acid sequence database, the National Center for Biotechnology Information (NCBI) provides data analysis and retrieval and resources that operate on the data in GenBank and a varity of other biological data made available through NCBI''s Web site. NCBI data retrieval resources include Entrez, PubMed, LocusLink and the Taxonomy Browser. Data analysis resources include BLAST, Electronic PCR, OrfFinder, RefSeq, UniGene, Databases of Single Nucleotide Polymorphisms (dbSNP), Human Genome Sequencing pages, GeneMap ''99, Davis Human-Mouse Homology Map, Cancer Chromosome Abberation Project (CCAP) pages, Entrez Genomes, Clusters of Orthologous Groups (COGs) database, Retroviral Genotyping Tools, Cancer Genome Anatomy Project (CGAP) pages, SAGEmap, Online Mendelian Inheritance in Man (OMIM) and the Molecular Modeling Databases (MMDB).', 'http://www.ncbi.nlm.nih.gov/', 'http://www.ncbi.nlm.nih.gov/gquery/gquery.fcgi?term={$formKeywords}', NULL, 3),
(1449, 280, 'RxList', 'RxList: The Internet drug index - Searchable cross index of US prescription products for both consumers and medical professionals', 'http://www.rxlist.com/', 'http://www.rxlist.com/cgi/rxlist.cgi?drug=acetaminophen', NULL, 4),
(1450, 281, 'EurekAlert!', 'EurekAlert! is an online press service created by the American Association for the Advancement of Science (AAAS). The primary goal of EurekAlert! is to provide a forum where research institutions, universities, government agencies, corporations and the like can distribute science-related news to reporters and news media. The secondary goal of EurekAlert! is to archive these press releases and make them available to the public in an easily retrievable system.', 'http://www.eurekalert.org/links.php', 'http://search.eurekalert.org/e3/query.html?col=ev3rel&qc=ev3rel&qt={$formKeywords}', NULL, 0),
(1451, 281, 'Mad Science Net: The 24-hour exploding laboratory', 'Mad Science Net: The 24-hour exploding laboratory is a collective cranium of scientists providing answers to your questions.', 'http://www.madsci.org/', 'http://www.madsci.org/cgi-bin/search?Submit=Submit+Query&or=AND&words=1&index=MadSci+Archives&MAX_TOTAL=25&area=All+areas&grade=All+grades&query={$formKeywords}', NULL, 1),
(1452, 282, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 0),
(1453, 283, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1454, 283, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1455, 283, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1456, 283, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1457, 283, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1458, 283, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1459, 283, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1460, 283, 'Health Canada', 'Health Canada is the federal department responsible for helping the people of Canada maintain and improve their health.  Health Canada is committed to improving the lives of all of Canada''s people and to making this country''s population among the healthiest in the world as measured by longevity, lifestyle and effective use of the public health care system.', 'http://search.hc-sc.gc.ca/cgi-bin/query?mss=hcsearch', 'http://search.hc-sc.gc.ca/cgi-bin/query?mss=hcresult&pg=aq&enc=iso88591&ft=adverse+drug&doc=all&results=any&exclude=&r=&kl=en&subsite=both&search=Search&q={$formKeywords}', NULL, 7),
(1461, 283, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 8),
(1462, 283, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 9),
(1463, 284, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1464, 284, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 1),
(1465, 284, 'The Scientist', 'The Scientist is the online resource for the printed magazine, The Scientist. Provides access to information useful to those working in or studying the life sciences.', 'http://www.the-scientist.com/', 'http://www.the-scientist.com/search/dosearch/', 'box_type=toolbar&search_restriction=all&order_by=date&search_terms={$formKeywords}', 2),
(1466, 284, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 3),
(1467, 284, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 4),
(1468, 284, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 5),
(1469, 285, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1470, 285, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1471, 285, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1472, 285, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1473, 286, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1474, 286, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 1),
(1475, 286, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(1476, 286, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(1477, 286, 'Anthropological index', 'The Anthropological Index is a regionally arranged subject and author index to periodical articles in all areas of anthropology. It is produced by the Museum of Mankind Library.', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'Default_Years=#1957#1958#1959#1960#1961#1962#1963#1964#1965#1966#1967#1968#1969#1970#1971#1972#1973#1974#1975#1976#1977#1978#1979#1980#1981#1982#1983#1984#1985#1986#1987#1988#1989#1990#1991#1992#1993#1994#1995#1996#1997#1998#1999#2000#2001#2002#2003#2004#2005#Recent&Year=Recent&Text_w=&Text=&Author_w=&Subject1=&Subject2=&Subject3=&Email=You@whereever.edu&Refer=on&Author={$formKeywords}', 4),
(1478, 286, 'The English Server', 'The English Server contains humanities texts online with over 18,000 works, covering history, race, art & architecture, government and other topics.', 'http://eserver.org/', 'http://www.google.com/u/EServer?q={$formKeywords}', NULL, 5),
(1479, 286, 'IATH: Institute for Advanced Technology in the Humanities', 'IATH: Institute for Advanced Technology in the Humanities, from the University of Virginia at Charlottesville, provides access to web-based humanities research archives and reports, essays, and the current issue of Postmodern Culture, the Internet''s oldest peer-reviewed electronic journal in the humanities.', 'http://jefferson.village.virginia.edu/', 'http://www.google.com/u/iath?sa=Google+Search+of+IATH&domains=village.virginia.edu&sitesearch=village.virginia.edu&q={$formKeywords}', NULL, 6),
(1480, 286, 'The Online books Page', 'The Online books Page is the most comprehensive website that facilitates access to books that are freely readable over the Internet.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?amode=words&tmode=words&title=&author={$formKeywords}', NULL, 7),
(1481, 286, 'Perseus Digital Library', 'Perseus Digital library is designed to be resources for the study of the ancient world. Originally begun with coverage of the Archaic and Classical Greek world, has now expanded to Latin text and tools, Renaissance materials, and Papyri. Contains hundreds of texts by the major ancient authors and lexica and morphological databases and catalog entries for over 2,800 vases, sculptures, coins, buildings, and sites, including over 13,000 photographs of such objects.', 'http://www.perseus.tufts.edu/', 'http://www.perseus.tufts.edu/cgi-bin/vor?x=22&y=15&lookup={$formKeywords}', NULL, 8),
(1482, 286, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 9),
(1483, 287, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1484, 287, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 1),
(1485, 287, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 2),
(1486, 287, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 3),
(1487, 287, 'The Internet Encyclopedia of Philosophy', 'This encyclopedia contains articles adapted from public domain sources, adaptations of material written by the editor for classroom purposes, and original contributions by professional philosophers around the Internet.', 'http://www.utm.edu/research/iep/', 'http://www.google.com/search?hl=en&lr=&q=site%3Awww.utm.edu%2Fresearch%2Fiep%2F+{$formKeywords}', NULL, 4),
(1488, 287, 'Stanford Encyclopedia of Philosophy', 'Stanford Encyclopedia of Philosophy is a searchable encyclopedia of philosophy providing in-depth explanations for terms.', 'http://plato.stanford.edu/', 'http://plato.stanford.edu/cgi-bin/webglimpse.cgi?nonascii=on&errors=0&maxfiles=50&maxlines=30&maxchars=10000&ID=1&query={$formKeywords}', NULL, 5),
(1489, 287, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 6),
(1490, 287, 'WordNet', 'WordNet, an electronic lexical database, is considered to be the most important resource available to researchers in computational linguistics, text analysis, and many related areas. Its design is inspired by current psycholinguistic and computational theories of human lexical memory. English nouns, verbs, adjectives, and adverbs are organized into synonym sets, each representing one underlying lexicalized concept. Different relations link the synonym sets.', 'http://www.cogsci.princeton.edu/~wn/', 'http://wordnet.princeton.edu/perl/webwn?sub=Search+WordNet&o2=&o0=1&o7=&o5=&o1=1&o6=&o4=&o3=&h=&s={$formKeywords}', NULL, 7),
(1491, 288, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1492, 288, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://www.canada.gc.ca/main_e.html', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(1493, 288, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1494, 288, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1495, 288, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1496, 288, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1497, 288, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1498, 289, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(1499, 289, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(1500, 289, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(1501, 289, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(1502, 290, 'Literary Index (Gale Group)', 'This is "a master index to the major literature products published by Gale," including Contemporary Authors and Literature Criticism from 1400-1800. Also indexes print reference titles from Charles Scribner''s Sons, St. James Press, and Twayne Publishers. Many of these resources, commonly found in libraries, "contain complete biographies on authors and critical essays on their writings."', 'http://www.galenet.com/servlet/LitIndex', 'http://www.galenet.com/servlet/LitIndex/hits?ttlRad=ti&n=10&NA=&r=s&origSearch=true&o=DocTitle&l=8&c=1&secondary=false&u=LitIndex&t=KW&s=2&TI={$formKeywords}', NULL, 0),
(1503, 290, 'Internet Public Library Online Literary Criticism Collection', 'Browse the Internet Public Library''s collection of links to websites on western and non-western literary criticism. Organized by author, title of work studied and by literary period within a particular national tradition.', 'http://www.ipl.org/div/litcrit/', 'http://www.ipl.org/div/searchresults/?where=searchresults&words={$formKeywords}', NULL, 1),
(1504, 290, 'Poetry Portal', 'This is a very comprehensive and informative collection of links about poetry online, events, courses, styles, and publishing. The site also covers "ezines, poetry sites, audio poetry, literary appreciation, criticism and reviews, poetry courses, workshops, conferences, book and trade news, literary chit-chat and trade news, plus sources to improve your own writing and get it published."', 'http://www.poetry-portal.com/', 'http://www.google.com/search?hl=en&q=site%3Awww.poetry-portal.com+{$formKeywords}', NULL, 2),
(1505, 291, 'Bryn Mawr Classical Review', 'Bryn Mawr Classical Review contains full text of every book review published since 1990 in the Bryn Mawr Classical Review. Articles are indexed both by issue and by the title of the book.', 'http://ccat.sas.upenn.edu/bmcr/', 'http://ccat.sas.upenn.edu/cgi-bin/bmcr/bmcr_search?action=search&lookup={$formKeywords}', NULL, 0),
(1506, 291, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 1),
(1507, 291, 'The New York Times Books', 'The New York Times Books, updated daily, includes the entire Sunday Book reviews and a searchable archive of over 50,000 NYT book reviews dating back to 1980, bestseller lists and more (Need to sign up).', 'http://www.nytimes.com/auth/login?Tag=/&URI=/books/', 'http://query.nytimes.com/search/query?ppds=ctaxAbodyS&v1=Top%2FFeatures%2FBooks%2FBook+Reviews&sort=closest_newest&v2={$formKeywords}', NULL, 2),
(1508, 291, 'Early Modern Literary Studies', 'Early Modern Literary Studies (ISSN 1201-2459) is a refereed journal serving as a formal arena for scholarly discussion and as an academic resource for researchers in the area. Articles in EMLS examine English literature, literary culture, and language during the sixteenth and seventeenth centuries; responses to published papers are also published as part of a Readers'' Forum. Reviews evaluate recent work as well as academic tools of interest to scholars in the field. EMLS is committed to gathering and to maintaining links to the most useful and comprehensive internet resources for Renaissance scholars, including archives, electronic texts, discussion groups, and beyond.', 'http://www.shu.ac.uk/emls/emlshome.html', 'http://www.shu.ac.uk/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&matchesperpage=10&config=emls&restrict=&exclude=&words={$formKeywords}', NULL, 3),
(1509, 292, 'Anthropological index', 'The Anthropological Index is a regionally arranged subject and author index to periodical articles in all areas of anthropology. It is produced by the Museum of Mankind Library.', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'http://aio.anthropology.org.uk/cgi-bin/uncgi/search_bib_ai/anthind_short', 'Default_Years=2001#2002#2003#2004#2005#Recent&Year=#1957#1958#1959#1960#1961#1962#1963#1964#1965#1966#1967#1968#1969#1970#1971#1972#1973#1974#1975#1976#1977#1978#1979#1980#1981#1982#1983#1984#1985#1986#1987#1988#1989#1990#1991#1992#1993#1994#1995#1996#1997#1998#1999#2000#2001#2002#2003#2004#2005#Recent&Text_w=&Author_w=&Subject1=&Subject2=&Subject3=&Email=You@whereever.edu&Refer=on&Author=&Text={$formKeywords}', 0),
(1510, 292, 'The English Server', 'The English Server contains humanities texts online with over 18,000 works, covering history, race, art & architecture, government and other topics.', 'http://eserver.org/', 'http://www.google.com/u/EServer?q={$formKeywords}', NULL, 1),
(1511, 292, 'IATH: Institute for Advanced Technology in the Humanities', 'IATH: Institute for Advanced Technology in the Humanities, from the University of Virginia at Charlottesville, provides access to web-based humanities research archives and reports, essays, and the current issue of Postmodern Culture, the Internet''s oldest peer-reviewed electronic journal in the humanities.', 'http://jefferson.village.virginia.edu/', 'http://www.google.com/u/iath?sa=Google+Search+of+IATH&domains=village.virginia.edu&sitesearch=village.virginia.edu&q={$formKeywords}', NULL, 2),
(1512, 292, 'NetSERF: the Internet connection for medieval resources', 'Detailed topical arrangement of links to a large number of sites pertaining to medieval history and culture.', 'http://www.netserf.org/', 'http://www.netserf.org/Features/Search/default.cfm?Search_Action=Process&Phrase_required=You must provide a search phrase with this option.&phrase={$formKeywords}', NULL, 3),
(1513, 292, 'The Online books Page', 'The Online books Page is the most comprehensive website that facilitates access to books that are freely readable over the Internet.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?author=&amode=words&tmode=words&title={$formKeywords}', NULL, 4),
(1514, 292, 'Perseus Digital Library', 'Perseus Digital library is designed to be resources for the study of the ancient world. Originally begun with coverage of the Archaic and Classical Greek world, has now expanded to Latin text and tools, Renaissance materials, and Papyri. Contains hundreds of texts by the major ancient authors and lexica and morphological databases and catalog entries for over 2,800 vases, sculptures, coins, buildings, and sites, including over 13,000 photographs of such objects.', 'http://www.perseus.tufts.edu/', 'http://www.perseus.tufts.edu/cgi-bin/vor?x=22&y=15&lookup={$formKeywords}', NULL, 5),
(1515, 292, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 6),
(1516, 292, 'Dictionary of Canadian Biography Online', 'A collection of authoritative biographies portraying noteworthy persons of both sexes (with the exception of those still living). This first phase presents persons who died between the years 1000 and 1920', 'http://www.biographi.ca/EN/index.html', 'http://www.biographi.ca/EN/Results.asp?ToDo=&Show=&Data1=&Data2=&Data3=&Data4=&Data5=&Data6=&&Data7=&Data8=&Data9=&Data10=&txtSearch={$formKeywords}', NULL, 7),
(1517, 293, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase. At this point, a total of 15,000 of 750,000 records are loaded into the database. Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/content.asp?l1=5&l2=23&l3=44&l4=25', 'http://www.crl.edu/DBSearch/dissertationsSummary.asp?language=English&title={$formKeywords}', NULL, 0),
(1518, 293, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 1),
(1519, 293, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 2),
(1520, 293, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 3),
(1521, 294, 'AAD', 'Access to archival Databases (AAD) System has approximately 350 data files with millions of records available online that are highly structured, such as in databases. The series selected for AAD identify specific persons, geographic areas, organizations, or dates. Some of these series serve as indexes to accessioned archival records in non-electronic formats. Includes a link to search descriptions of NARA''s non-electronic records through NARA''s online catalogue, ARC.', 'http://aad.archives.gov/aad', 'http://search.nara.gov/query.html?rq=0&qp=&rq=0&col=4ardor&col=3ourdoc&col=2pres&col=1arch&qs=&qc=&pw=100%25&ws=0&la=&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&qt={$formKeywords}', NULL, 0),
(1522, 294, 'Making of America: the Cornell University Library MOA collection', 'A digital library of primary sources in American social history from the antebellum period through reconstruction. The collection is particularly strong in the subject areas of education, psychology, American history, sociology, religion, and science and technology.', 'http://cdl.library.cornell.edu/moa/', 'http://cdl.library.cornell.edu/cgi-bin/moa/sgml/moa-idx?&type=simple&slice=1&layer=first&coll=both&year1=1815&ear2=1926&q1={$formKeywords}', NULL, 1),
(1523, 294, 'UIUC Digital Gateway to Cultural Heritage Materials', 'This gateway is using the OAI Protocol for harvesting metadata, and exposing it with a search interface to enhance resource discoverability for materials that represent cultural heritage. The repository includes metadata records donated by 39 institutions over 1.3 million records.', 'http://nergal.grainger.uiuc.edu/cgi/b/bib/bib-idx', 'http://nergal.grainger.uiuc.edu/cgi/b/bib/bib-idx?type=simple&xc=1&q6=&rgn6=identifier&rgn1=entire+record&op6=And&q1={$formKeywords}', NULL, 2),
(2297, 441, 'Eur-Lex -- The portal to European Union law', 'Eur-Lex (European Union Law). Free service with access to the The Official Journal of the European Union, full-text of EU Treaties, consolidated versions of existing legislation and recent judgments by the Court of Justice.', 'http://europa.eu.int/eur-lex/en/index.html', 'http://europa.eu.int/search/s97.vts?Action=FilterSearch&COLLECTION=EURLEXfiles&Filter=EUROPA_filter.hts&ResultTemplate=eur-lex_res-en.hts&QueryMode=Simple&SearchPage=%2Feur-lex%2Fen%2Findex.html&SearchIn=http%3A%2F%2Feuropa.eu.int%2Feur-lex%2Fen&SortField=Score&SortOrder=desc&StartDate=&HTMLonly=&ResultCount=25&queryText={$formKeywords}', NULL, 9),
(2296, 441, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 8),
(2295, 441, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 7),
(2236, 428, 'SocioSite', 'SocioSite gives access to the worldwide scene of social sciences. The intention is to provide a comprehensive listing of all sociology resources on the Internet.', 'http://www.pscw.uva.nl/sociosite/', 'http://www.google.com/u/sociosite?sa=sociosite&domains=www2.fmg.uva.nl&sitesearch=www2.fmg.uva.nl&hq=inurl:www2.fmg.uva.nl/sociosite&q={$formKeywords}', NULL, 6),
(2237, 428, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 7),
(2235, 428, 'Intute: Social Sciences', 'Intute: Social Sciences is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 5),
(2234, 428, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 4),
(2233, 428, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 3),
(2232, 428, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(2231, 428, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(2230, 428, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2228, 427, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2229, 427, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2226, 427, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2227, 427, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2224, 426, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 9),
(2225, 426, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 10),
(2223, 426, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 8),
(2221, 426, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 6),
(2222, 426, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 7),
(2218, 426, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 3),
(2219, 426, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 4),
(2220, 426, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 5),
(2217, 426, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(2216, 426, 'Agriculture 21', 'This site contains news and features on agricultural and food-supply issues worldwide, as well as downloadable publications, links to databases, subject guides, and access to divisions of the FAO Agriculture Department. Includes search engine.', 'http://www.fao.org/ag/', 'http://www.fao.org/ag/search/agfind.asp?SortBy=rank%5Bd%5D&Scope=%2Fag&FSRestVal=any&Action=Execute&SearchString={$formKeywords}', NULL, 1),
(2215, 426, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2214, 425, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(2213, 425, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is raning from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2212, 425, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&frm=smp.x&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&p00={$formKeywords}', NULL, 1),
(2211, 425, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2210, 424, 'USDA Economics and Statistics System', 'USDA Economics and Statistics System contains more than 400 reports and datasets from the economics agencies of the U.S. Department of Agriculture. These materials cover U.S. and international agriculture and related topics. Most reports are text files that contain time-sensitive information. Most data sets are in spreadsheet format and include time-series data that are updated yearly.', 'http://usda.mannlib.cornell.edu/', 'http://usda.mannlib.cornell.edu/MannUsda/search.do?action=fullKeywordSearch&titlesearch=titlesearch&includeAMS=includeAMS&simple_search_term={$formKeywords}', NULL, 1),
(2209, 424, 'Breeds of Livestock', 'Web site allows users to search for information on livestock by world region or by species name. Data is available on cattle, horses, swine, goats, and sheep and organized as encyclopedia entries.', 'http://www.ansi.okstate.edu/breeds/', 'http://www.google.com/search?q=site%3Aansi.okstate.edu+breeds+', NULL, 0),
(2208, 423, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 2),
(2207, 423, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 1),
(2206, 423, 'Agricultural Conferences, Meetings, Seminars Calendar', 'This calendar strives to include all major national and international agricultural meetings and others of apparent scientific importance. We will incorporate local level meetings only when they seem to be scientifically significant. Meetings outside our purview will be left to appropriate local, regional, or organization-specific calendars. We do plan to create links to such calendars when they are available. Provides a central repository for information and links to information concerning upcoming agricultural conferences, with emphasis on those of scientific significance.', 'http://www.agnic.org/mtg/', 'http://www.agnic.org/events/index.html?submitted=1&searchtype=keyword&keywords={$formKeywords}', NULL, 0),
(2205, 422, 'National Plants Databases', 'From the U.S. Department of Agriculture Natural Resources Conservation Service, "The PLANTS Databases is a single source of standardized information about plants. . . focuse[d] on vascular plants, mosses, liverworts, hornworts, and lichens of the U.S. and its territories. The PLANTS Databases includes names, checklists, automated tools, identification information, species abstracts, distributional data, crop information, plant symbols, plant growth data, plant materials information, plant links, references, and other plant information." An FAQ section linked to the banner provides additional information.', 'http://plants.usda.gov/', 'http://www.nrcs.usda.gov/search.asp?site=NPDC&ct=ALL&qu={$formKeywords}', NULL, 3),
(2204, 422, 'E-Answers', 'A collection of over 250,000 pages of full text electronic documents from the Extension Services and Agricultural Experiment Stations of over fifteen states of the United States, searchable by keyword and by region of the country. A single-stop access to a large number of useful and reputable publications on topics in agriculture, family topics, consumer issues, environment, economics, and public policy.', 'http://e-answers.adec.edu/', 'http://e-answers.adec.edu/cgi-bin/htsearch?config=ea-all&words={$formKeywords}', NULL, 2),
(2203, 422, 'National Ag Safety Databases (NASD)', 'The National Ag Safety Databases (NASD) is a database of materials devoted to increased safety, health and injury prevention in agriculture, listed by topic and state. Video resources are indexed, there are special listings for conference proceedings, posters and other materials.', 'http://www.cdc.gov/search.htm', 'http://www.cdc.gov/search.do?action=search&x=0&y=0&queryText={$formKeywords}', NULL, 1),
(2202, 422, 'FAO document repository', 'FAO Document Repository collects and disseminates on the Internet full FAO documents and publications as well as selected non-FAO publications. Three types of searches are provided and several language options are available.', 'http://www.fao.org/documents/', 'http://www.fao.org/documents/advanced_s_result.asp?form_c=AND&RecordsPerPage=50&QueryString={$formKeywords}', NULL, 0),
(2201, 421, 'Agriculture 21', 'Contains news and features on agricultural and food-supply issues worldwide, as well as downloadable publications, links to databases, subject guides, and access to divisions of the FAO Agriculture Department. Includes search engine.', 'http://www.fao.org/ag/', 'http://www.fao.org/ag/search/agfind.asp?Find=Find&SortBy=rank[d]&Scope=/ag&CiuserParam3=agfind.asp&lang=en&FMMod=any&FSRest=<&FSRestval=any&Action=Execute&SearchString={$formKeywords}', NULL, 7),
(2199, 421, 'World Agricultural Information Centre (WAICENT)', 'This site contains information management and dissemination on desertification, gender and sustainable development, food standards, animal genetic resources, post-harvest operations, agro-biodiversity and food systems in urban centres.', 'http://www.fao.org/waicent/index_en.asp', 'http://www.fao.org/waicent/search/simple_s_result.asp?publication=1&webpage=2&photo=3&press=5&CGIAR=1&QueryString={$formKeywords}', NULL, 5),
(2200, 421, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 6),
(2198, 421, 'Scirus', 'Scirus is the most comprehensive science-specific search engine on the Internet. Driven by the latest search engine technology, Scirus searches over 150 million science-specific Web pages.', 'http://www.scirus.com/srsapp/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 4),
(2196, 421, 'AgriSurf! - The Farmers Search Engine', 'From family farms to agribusiness, almost 20,000 sites "hand picked by agricultural experts" are arranged in categories, indexed, rated for speed and reliability of access, labeled with the flag of their country of origin, and may be searched using keywords. Annotations are taken from the sites'' self-descriptions.', 'http://www.agrisurf.com/agrisurfscripts/agrisurf.asp?index=_25', 'http://www.agrisurf.com/?cx=009099332680230023402%3Asp1yugldxek&cof=FORID%3A10&q={$formKeywords}', NULL, 2),
(2197, 421, 'Farms.com', 'Established in 1995, Farms.com has been instrumental in the development of the Agricultural Internet. Now recognized throughout North America as the leading Agriculture Internet resource, Farms.com has successfully combined agri-business experience with the vast power of the Internet to provide producers with the information, services, and markets they need to make sound business decisions and increase profitability.', 'http://canada.eharvest.com/', 'http://www.agrisurf.com/agrisurfscripts/inc/farms/search.asp?index=_25&rbtn=ALL&ft=on&SearchString={$formKeywords}', NULL, 3),
(2194, 421, 'AgNIC', 'AgNIC is a guide to quality agricultural information on the Internet as selected by the National Agricultural Library, Land-Grant Universities, and other institutions.', 'http://www.agnic.org/', 'http://www.agnic.org/advsearch/?submitted=1&searchtype=AgResource&keywords={$formKeywords}', NULL, 0),
(2195, 421, 'AGRICOLA articles (NAL Web: 1982- )', 'AGRICOLA covers the areas of agriculture, agricultural administration, agricultural laws and legislation, agricultural regulations, agricultural economics, agricultural education and training, agricultural extension and advisory work, agricultural engineering, agricultural products, animal science, entomology, aquatic science, fisheries, feed science, food science, food products, forestry, geography, meteorology, climatology, history, home economics, human ecology, household textiles and clothing, human nutrition, natural resources, pesticides, plant science, pollution, soil science, rural sociology, rural development, and human parasitology. It indexes journal articles and other publications as well as audiovisual materials, maps, books, software, conference proceedings, theses, research reports and government documents.', 'http://agricola.nal.usda.gov/', 'http://agricola.nal.usda.gov/cgi-bin/Pwebrecon.cgi?BOOL1=all+of+these&FLD1=Keyword+Anywhere+%28GKEY%29&GRP1=AND+with+next+set&SAB2=&BOOL2=any+of+these&FLD2=Subject+%28SKEY%29&GRP2=AND+with+next+set&SAB3=&BOOL3=as+a+phrase&FLD3=Title+%28TKEY%29&GRP3=AND+with+next+set&SAB4=&BOOL4=as+a+phrase&FLD4=Author+Name+%28NKEY%29&PID=4294&SEQ=20060511212523&CNT=25&HIST=1&SAB1={$formKeywords}', NULL, 1),
(2193, 420, 'E-STREAMS', 'E-STREAMS: Electronic reviews of Science & Technology References covering Engineering, Agriculture, Medicine and Science. Each issue contains 30+ STM reviews, covering new titles in Engineering, Agriculture, Medicine and Science. Each review is signed, and includes the email address of the reviewer. The reviews feature short TOCs, a list of contributors and bibliographic information.', 'http://www.e-streams.com/', 'http://www.e-streams.com/c3/cgi-bin/search.pl', 'boolean=AND&case=Insensitive&terms={$formKeywords}', 4),
(2192, 420, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2191, 420, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2190, 420, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2189, 420, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2188, 419, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(2187, 419, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(2186, 419, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2185, 419, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(2184, 419, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(2155, 416, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 3),
(2156, 416, 'AgEcon Search: Research in agricultural Economics', 'AgEcon Search is designed to electronically distribute reports of scholarly research in the field of agricultural economics.', 'http://agecon.lib.umn.edu/', 'http://agecon.lib.umn.edu/cgi-bin/view.pl?bool=AND&fields=author&detail=0&keywords={$formKeywords}', NULL, 4),
(2157, 416, 'The Digital Library of the Commons (DLC)', 'DLC is a gateway to the international literature on the commons . This site contains a Working Paper Archive of author-submitted papers, as well as full-text conference papers, dissertations, working papers and pre-prints, and reports.', 'http://dlc.dlib.indiana.edu/', 'http://dlc.dlib.indiana.edu/perl/search?abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear_srchtype=ALL&_action_search=Search&abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear={$formKeywords}', NULL, 5),
(2158, 416, 'PESTIS document database', 'The Pesticide Information Service (PESTIS) is an on-line database for the pesticide use reform and sustainable agriculture communities, made available on the EcoNet computer network. It contains over 400 news items, action alerts, newsletter articles and fact sheets.', 'http://www.panna.org/resources/pestis.html', 'http://www.panna.org/system/searchResults.html?p=1&lang=en&include=&exclude=&penalty=.05&mode=&searchScope=all&q={$formKeywords}', NULL, 6),
(2159, 416, 'Common Names for Plant Diseases', 'This resource is an electronic version of: Common names for plant diseases, 1994. Published: St. Paul, Minn.: APS Press, 1994. This compilation provides an updated, combined version of lists of names published in Phytopathology News and Plant Disease.', 'http://www.apsnet.org/online/common/', 'http://www.apsnet.org/online/common/query.asp', 'scope=/online/common/names/&FreeText=on&SearchString={$formKeywords}', 7),
(2160, 416, 'Vegetable MD online', 'Vegetable MD Online was developed to provide access to the many Vegetable Disease Fact Sheets produced over the years by Media Services at Cornell. The addition of color photographs enhances the use of these sheets for plant disease diagnosis. The fact sheets also include information about planting methods, irrigation, weed control, insects, handling, field selection, and other issues related to vegetables and their cultivation.', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp?target={$formKeywords}', NULL, 8),
(2161, 416, 'VITIS-VEA', 'VITIS-VEA, Viticulture and Enology Abstracts is an international German or English-language publications database in the field of viticulture and enology. It covers grapevine morphology, physiology, and biochemistry, soil science, genetics and grapevine breeding, phytopathology and grapevine protection, cellar techniques, economics of viticulture and enology, and the microbiology of wine.', 'http://vitis-vea.zadi.de/stichwortsuche_eng.htm', 'http://vitis-vea.zadi.de/VITISVEA_ENG/SDF?STICHWORT_O=includes&FORM_F1=AUT1&FORM_SO=Ascend&STICHWORT={$formKeywords}', NULL, 9),
(2162, 416, 'World Agricultural Information Centre (WAICENT)', 'This site contains information management and dissemination on desertification, gender and sustainable development, food standards, animal genetic resources, post-harvest operations, agro-biodiversity and food systems in urban centres.', 'http://www.fao.org/waicent/index_en.asp', 'http://www.fao.org/waicent/search/simple_s_result.asp?publication=1&webpage=2&photo=3&press=5&CGIAR=1&QueryString={$formKeywords}', NULL, 10),
(2163, 416, 'FAO document repository', 'FAO Document Repository collects and disseminates on the Internet full FAO documents and publications as well as selected non-FAO publications. Three types of searches are provided and several language options are available.', 'http://www.fao.org/documents/', 'http://www.fao.org/documents/advanced_s_result.asp?form_c=AND&RecordsPerPage=50&QueryString={$formKeywords}', NULL, 11),
(2164, 417, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2165, 417, 'FAO Glossary of Biotechnology for Food and Agriculture', 'This site provides a tabbed list of words and their definitions, but no search function.  Online searches are free.  There is a bound book version of the dictionary available for sale.', 'http://www.fao.org/biotech/index_glossary.asp', 'http://www.fao.org/biotech/find-form-n.asp', 'terms={$formKeywords}', 1),
(2166, 417, 'NAL Agricultural Thesaurus', 'NAL Agricultural Thesaurus was created to meet the needs of the United States Department of Agriculture (USDA), Agricultural Research Service (ARS), for an agricultural thesaurus. NAL Agricultural Thesaurus is for anyone describing, organizing and classifying agricultural resources such as: books, articles, catalogs, databases, patents, games, educational materials, pictures, slides, film, videotapes, software, other electronic media, or websites. It is organized into 17 subject categories.', 'http://agclass.nal.usda.gov/agt/agt.htm', 'http://agclass.nal.usda.gov/agt/mtw.exe?k=default&p=A&l=60&s=2&t=1&n=100&w={$formKeywords}', NULL, 2),
(2167, 417, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(2168, 417, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(2169, 417, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(2170, 417, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(2171, 418, 'AgEcon Search: Research in agricultural Economics', 'AgEcon Search is designed to electronically distribute reports of scholarly research in the field of agricultural economics.', 'http://agecon.lib.umn.edu/', 'http://agecon.lib.umn.edu/cgi-bin/view.pl?bool=AND&fields=key&detail=0&keywords={$formKeywords}', NULL, 0),
(2172, 418, 'CropSEARCH', 'Index to plant lists of hundreds of crop species.', 'http://www.hort.purdue.edu/newcrop/SearchEngine.html', 'http://index.cc.purdue.edu:8765/query.html?col=pumerge&charset=iso-8859-1&ht=0&qp=%2Bsite%3Ahort.purdue.edu&qs=&qc=&pw=100%25&ws=0&la=en&qm=0&st=1&nh=10&lk=1&rf=0&rq=0&si=0&puhead=header.html&pufoot=footer.html&qt={$formKeywords}', NULL, 1),
(2173, 418, 'The Digital Library of the Commons (DLC)', 'DLC is a gateway to the international literature on the commons . This site contains a Working Paper Archive of author-submitted papers, as well as full-text conference papers, dissertations, working papers and pre-prints, and reports.', 'http://dlc.dlib.indiana.edu/', 'http://dlc.dlib.indiana.edu/perl/search?abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear_srchtype=ALL&_action_search=Search&abstract%2Fagency%2Fauthors%2Fconfdates%2Fconference%2Fconfloc%2Fcountry%2Fdiscipline%2Feditors%2Fkeywords%2Flanguage%2Fresearch%2Fseries%2Fsubjecttext%2Fthesistype%2Ftitle%2Fyear={$formKeywords}', NULL, 2),
(2174, 418, 'FAS online', 'The Foreign Agricultural Service (FAS) of the U.S. Department of Agriculture (USDA) produces hundreds of documents each year that chart and analyze production, consumption, trade flows, and market opportunities for about 100 agricultural products. Includes market-and commodity-specific reports, data and statistics, news, trade leads, information on export and import programs, and more.', 'http://www.fas.usda.gov/fassearch.asp', 'http://www.fas.usda.gov/FASSearch_results_H.asp?SearchString={$formKeywords}', NULL, 3),
(2175, 418, 'PESTIS document database', 'The Pesticide Information Service (PESTIS) is an on-line database for the pesticide use reform and sustainable agriculture communities, made available on the EcoNet computer network. It contains over 400 news items, action alerts, newsletter articles and fact sheets.', 'http://www.panna.org/resources/pestis.html', 'http://www.panna.org/system/searchResults.html?p=1&lang=en&include=&exclude=&penalty=.05&mode=&searchScope=all&q={$formKeywords}', NULL, 4),
(2176, 418, 'PlantFacts', 'PlantFacts includes guides for answering plant-related questions from 46 different universities and government institutions across the United States and Canada. Over 20,000 pages of Extension fact sheets and bulletins provide a concentrated source of plant-related information. PlantFacts has merged several digital collections developed at Ohio State University to become an international knowledge bank and multimedia learning center.', 'http://plantfacts.osu.edu/', 'http://plantfacts.osu.edu/action.lasso?-Layout=input&-Search=-nothing&-Response=results_list2.lasso&-AnyError=error.lasso&searchitem={$formKeywords}', NULL, 5),
(2177, 418, 'National PLANTS database', 'Focuses on the vascular and nonvascular plants of the United States and its territories. The PLANTS database includes checklists, distributional data, crop information, plants symbols, plant growth data, references and other plant information.', 'http://plants.usda.gov/', 'http://www.nrcs.usda.gov/search.asp?site=NPDC&ct=ALL&qu={$formKeywords}', NULL, 6),
(2178, 418, 'Common Names for Plant Diseases', 'This resource is an electronic version of: Common names for plant diseases, 1994. Published: St. Paul, Minn.: APS Press, 1994. This compilation provides an updated, combined version of lists of names published in Phytopathology News and Plant Disease.', 'http://www.apsnet.org/online/common/', 'http://www.apsnet.org/online/common/query.asp', 'scope=/online/common/names/&FreeText=on&SearchString={$formKeywords}', 7),
(2179, 418, 'Rice bibliography', 'The Rice Bibliography was begun in 1961 and is now the world''s largest source of scientific information about rice. Almost 8,000 new references are added each year and these cover all subjects related to rice culture.', 'http://ricelib.irri.cgiar.org:81/search/w', 'http://ricelib.irri.cgiar.org:81/search/w?SEARCH={$formKeywords}', NULL, 8),
(2180, 418, 'Vegetable MD online', 'Vegetable MD Online was developed to provide access to the many Vegetable Disease Fact Sheets produced over the years by Media Services at Cornell. The addition of color photographs enhances the use of these sheets for plant disease diagnosis. The fact sheets also include information about planting methods, irrigation, weed control, insects, handling, field selection, and other issues related to vegetables and their cultivation.', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp', 'http://vegetablemdonline.ppath.cornell.edu/Vegmd.asp?target={$formKeywords}', NULL, 9),
(2181, 418, 'VITIS-VEA', 'VITIS-VEA, Viticulture and Enology Abstracts is an international German or English-language publications database in the field of viticulture and enology. It covers grapevine morphology, physiology, and biochemistry, soil science, genetics and grapevine breeding, phytopathology and grapevine protection, cellar techniques, economics of viticulture and enology, and the microbiology of wine.', 'http://vitis-vea.zadi.de/stichwortsuche_eng.htm', 'http://vitis-vea.zadi.de/VITISVEA_ENG/SDF?STICHWORT_O=includes&FORM_F1=AUT1&FORM_SO=Ascend&STICHWORT={$formKeywords}', NULL, 10),
(2182, 419, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2183, 419, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(2503, 481, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2501, 480, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2502, 480, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2499, 480, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2500, 480, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2497, 479, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 9),
(2498, 479, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 10),
(2496, 479, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 8),
(2492, 479, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 4),
(2493, 479, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 5),
(2494, 479, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 6),
(2495, 479, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 7),
(2489, 479, 'The Economist', 'The Economist is the online version of the famous magazine with articles and a searchable archive.', 'http://www.economist.com/', 'http://www.economist.com/search/search.cfm?cb=46&area=1&page=index&keywords=1&frommonth=01&fromyear=1997&tomonth=02&toyear=2002&rv=2&qr={$formKeywords}', NULL, 1),
(2490, 479, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(2491, 479, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 3),
(2486, 478, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 8),
(2487, 478, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 9),
(2488, 479, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2485, 478, 'The OECD (Organisation for Economic Co-operation and Development)', 'The OECD groups 30 member countries sharing a commitment to democratic government and the market economy. With active relationships with some 70 other countries, NGOs and civil society, it has a global reach. Best known for its publications and its statistics, its work covers economic and social issues from macroeconomics, to trade, education, development and science and innovation.', 'http://www.oecd.org/home/', 'http://www.oecd.org/searchResult/0,2665,en_2649_201185_1_1_1_1_1,00.html?fpSearchExact=3&fpSearchText={$formKeywords}', NULL, 7),
(2482, 478, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2483, 478, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(2484, 478, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(2481, 478, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(2480, 478, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(2479, 478, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(2477, 477, 'EcEdWeb', 'Economic Education Website: The purpose of the Economic Education Website is to provide support for economic education in all forms and at all levels.', 'http://ecedweb.unomaha.edu/search.cfm', 'http://www.google.com/u/ecedweb?q={$formKeywords}', NULL, 2),
(2478, 478, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2475, 477, 'Tutor 2U Economics', 'Tutor 2U Economics includes study resources, revision guides, relevant links, an updated dataroom, and a discussion forum.', 'http://www.tutor2u.com/', 'http://www.tutor2u.net/search.asp?func=search&tree=0&submit=Search+Tutor2u&myquery={$formKeywords}', NULL, 0),
(2476, 477, 'biz/ed', 'Business Education on the Internet (biz/ed) is a free information service available via the World-Wide Web which allows users to search and retrieve targeted information about business and economics held on computers around the world. The service offers a one-stop information gateway for the one million economics, business and management students and staff as well as the general public in the UK and overseas.', 'http://www.bized.co.uk/', 'http://www.bized.co.uk/cgi-bin/htsearch?config=htdig&method=and&sort=score&format=builtin-long&restrict=&exclude=&words={$formKeywords}', NULL, 1),
(2474, 476, 'INOMICS', 'INOMICS provides searches in indexes of other Web pages related to Economics.', 'http://www.conference-board.org/', 'http://www.conference-board.org/cgi-bin/MsmFind.exe?AND_ON=N&ALLCATS=X&AGE_WGT=0&EN=X&ES=X&NO_DL=X&x=57&y=11&QUERY={$formKeywords}', NULL, 2),
(2472, 476, 'H-Net', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www2.h-net.msu.edu/lists/', 'http://www2.h-net.msu.edu/logsearch/index.cgi?type=keyword&list=All+lists&hitlimit=100&field=&nojg=on&smonth=00&syear=1989&emonth=11&eyear=2004&order=relevance&phrase={$formKeywords}', NULL, 0),
(2473, 476, 'Intute: Social Sciences - Conferences and Events', 'Providing search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(2471, 475, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(2470, 475, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2469, 475, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(2468, 475, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2466, 474, 'Office for National Statistics (UK)', 'National Statistics is the official UK statistics site. You can view and download a wealth of economic and social data free.', 'http://www.statistics.gov.uk/', 'http://www.statistics.gov.uk/CCI/SearchRes.asp?term={$formKeywords}', NULL, 0),
(2467, 474, 'Statistics Canada', 'Statistics Canada is the official source for Canadian social and economic statistics and products.', 'http://www.statcan.ca/', 'http://www.statcan.ca:8081/english/clf/query.html?GO%21=GO%21&ht=0&qp=&qs=&qc=0&pw=100%25&la=en&qm=1&st=1&oq=&rq=0&si=0&rf=0&col=alle&qt={$formKeywords}', NULL, 1),
(2465, 473, 'WebEC: World Wide Web Resources in Economics', 'WebEC provides links to a variety of resources on economics. Topics include: economics and teaching; methodology and history; mathematical and quantitative methods; economics and computing; economics data; microeconomics; macroeconomics; international economics; financial economics; public economics; health, education and welfare; labor and demographics; law and economics; industrial organization; business economics; economic history; development, technological change and growth; economic systems; agriculture and natural resources; regional economics; and economics of networks.', 'http://www.helsinki.fi/WebEc/', 'http://www.google.com/search?hl=en&lr=&q=site%3Awww.helsinki.fi%2F WebEc%2F+{$formKeywords}', NULL, 0),
(2464, 472, 'World Bank Group Documents & Reports', 'The World Bank Group makes more than 14,000 documents available through the Documents & Reports website. Documents include Project appraisal reports, Economic and Sector Works, Evaluation reports and studies and working papers.', 'http://www-wds.worldbank.org/', 'http://www-wds.worldbank.org/servlet/WDS_IBank_Servlet?stype=AllWords&ptype=sSrch&pcont=results&sortby=D&sortcat=D&x=17&y=3&all={$formKeywords}', NULL, 3),
(2463, 472, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 2),
(2462, 472, 'Intute: Social Sciences', 'Intute is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 1),
(2461, 472, 'EDIRC', 'EDIRC: Economics Departments, Institutes and Research Centers in the World currently contains 6,321 institutions in 207 countries and territories.', 'http://edirc.repec.org/', 'http://edirc.repec.org/cgi-bin/search.cgi?boolean=AND&keyword1={$formKeywords}', NULL, 0),
(2460, 471, 'NBER', 'NBER (The National Bureau of Economic Research, Inc) is a private, nonprofit, nonpartisan research organization dedicated to promoting a greater understanding of how the economy works. Nearly 500 NBER Working papers are published each year, and many subsequently appear in scholarly journals.', 'http://papers.nber.org/', 'http://papers.nber.org/papers?module=search&action=query&default_conjunction=and&keywords={$formKeywords}', NULL, 1),
(2459, 471, 'EconPapers', 'EconPapers use the RePEc bibliographic and author data, providing access to the largest collection of online Economics working papers and journal articles.  As of May 2006, there is a total of 375,364 searchable working papers, articles and software items with 273,186 items available on-line. \n\nThe majority of the full text files are freely available, but some (typically journal articles) require that you or your organization subscribe to the service providing the full text file.', 'http://econpapers.repec.org/about.htm', 'http://econpapers.repec.org/scripts/search.asp?ft={$formKeywords}', NULL, 0),
(2457, 470, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2458, 470, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2456, 470, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2455, 470, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2454, 469, 'bizterms.net', 'Bizterms.net provides a comprehensive dictionary of business and financial terms. Start browsing for your financial term, either by search, most popular terms, random term or simply view terms by letter.', 'http://www.bizterms.net', 'http://www.bizterms.net/index.php', 'query={$formKeywords}', 9),
(2453, 469, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 8),
(1362, 263, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 0),
(1361, 262, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(1360, 262, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(1359, 262, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(1358, 262, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(1356, 262, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1357, 262, 'NAL Agricultural Thesaurus', 'NAL Agricultural Thesaurus was created to meet the needs of the United States Department of Agriculture (USDA), Agricultural Research Service (ARS), for an agricultural thesaurus. NAL Agricultural Thesaurus is for anyone describing, organizing and classifying agricultural resources such as: books, articles, catalogs, databases, patents, games, educational materials, pictures, slides, film, videotapes, software, other electronic media, or websites. It is organized into 17 subject categories.', 'http://agclass.nal.usda.gov/agt/agt.htm', 'http://search.nal.usda.gov/query.html?charset=iso-8859-1&ht=0&qp=&qs=-url%3Atektran&qc=-&pw=100%25&ws=0&la=en&qm=0&st=1&nh=10&lk=1&rf=0&oq=&rq=0&si=1&x=15&y=8&qt={$formKeywords}', NULL, 1),
(1355, 261, 'National Environmental Publications Internet Site (NEPIS)', 'The National Environmental Publications Information System began in 1997, to offer over 9,000 full text, online documents of the United States Environmental Protection Agency. Documents that are not available online can be ordered from the agency through NEPIS.', 'http://nepis.epa.gov/', 'http://nepis.epa.gov/Exe/ZyNET.exe?User=ANONYMOUS&Password=anonymous&Client=EPA&SearchBack=ZyActionL&SortMethod=h&SortMethod=-&MaximumDocuments=15&Display=hpfr&ImageQuality=r85g16%2Fr85g16%2Fx150y150g16%2Fi500&DefSeekPage=x&ZyAction=ZyActionS&Toc=&TocEntry=&QField=&QFieldYear=&QFieldMonth=&QFieldDay=&UseQField=&Docs=&IntQFieldOp=0&ExtQFieldOp=0&File=&SeekPage=&Back=ZyActionL&BackDesc=Contents+page&MaximumPages=1&ZyEntry=0&TocRestrict=n&SearchMethod=1&Time=&FuzzyDegree=0&Index=National+Environmental+Publications+Info&Query={$formKeywords}', NULL, 5),
(1354, 261, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(1353, 261, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(1352, 261, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(1351, 261, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering & Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1350, 261, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1349, 260, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(1348, 260, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(1346, 260, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(1347, 260, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(1345, 259, 'ScienceDaily', 'Latest research news.', 'http://www.sciencedaily.com/index.htm', 'http://www.sciencedaily.com/search/?topic=all&dates=1995&dates=2005&sort=relevance&keyword={$formKeywords}', NULL, 7),
(1344, 259, 'Energy Science News', 'Published by the Office of Science, U.S. Department of Energy.  The purpose of this newsletter is to inform scientists, engineers, educators, students, and the public about the progress of scientific research supported by the Office of Science.', 'http://www.eurekalert.org/doe/', 'http://search.eurekalert.org/e3/query.html?col=ev3rel+ev3feat&ht=0&qp=%2Binstitution%3ADOE+OR+%2Bfunder%3A%22US+Department+of+Energy%22&qs=&qc=ev3rel+ev3feat&pw=%25&ws=0&la=&si=1&fs=&ex=&rq=0&oq=&qm=0&ql=&st=1&nh=10&lk=1&rf=1&qt={$formKeywords}', NULL, 6),
(1343, 259, 'BBC Online: Science & Nature', 'The BBC online science and nature services which contain a wealth of information, resources and current news divided into clearly defined categories.  These categories include the human body, genes, prehistoric life, space and animals. A Hot Topics section explores the science behind the latest news.', 'http://www.bbc.co.uk/sn/', 'http://www.bbc.co.uk/cgi-bin/search/results.pl?uri=%2Fsn%2F&q={$formKeywords}', NULL, 5),
(1342, 259, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 4),
(1341, 259, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(1339, 259, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/news/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(1340, 259, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(1337, 258, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(1338, 259, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(1336, 258, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(1335, 258, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(1334, 258, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(1333, 258, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(1332, 258, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(1331, 258, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(1330, 258, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(1329, 258, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(1328, 257, 'The Open Video Project', 'The Open Video project is a collection of public domain digital video available for research and other purposes.  The purpose of the Open Video Project is to collect and make available a repository of digitized video content for the digital video, multimedia retrieval, digital library, and other research communities.', 'http://www.open-video.org/index.php', 'http://www.open-video.org/results.php?search_field=all&terms={$formKeywords}', NULL, 0),
(1326, 256, 'Science Learning Network', 'Science Learning Network is a community of educators, students, schools, science museums, and other institutions demonstrating a new model for inquiry into. Contains a variety of inquiry-posed problems, information, demonstrations, and labs.', 'http://www.sln.org/', 'http://192.231.162.154:8080/query.html?col=first&ht=0&qp=&qs=&qc=&pw=600&ws=1&la=&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&si=0&qt={$formKeywords}', NULL, 2),
(1327, 256, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 3),
(1325, 256, 'National Science Digital Library', 'The National Science Digital Library (NSDL) was created by the National Science Foundation to provide organized access to high quality resources and tools that support innovations in teaching and learning at all levels of science, technology, engineering, and mathematics education.', 'http://nsdl.org/about', 'http://nsdl.org/search/?', 'formview=searchresults&verb=Search&s=0&n=10&boost%5B%5D=compoundTitle&boost%5B%5D=compoundDescription&q={$formKeywords}', 1),
(1324, 256, 'Research Channel Programs: Stanford Science Online Videos', 'ResearchChannel is a consortium of research universities and corporate research divisions dedicated to broadening the access to and appreciation of our individual and collective activities, ideas, and opportunities in basic and applied research.', 'http://www.researchchannel.org/program/displayseries.asp?collid=134', 'http://www.researchchannel.org/search/sitesearch.aspx?RecordsPerPage=5&Order=Rank&keywords=program&Query={$formKeywords}', NULL, 0),
(1323, 255, 'JISCmail', 'The National Academic Mailing List Service, known as ''JISCmail'', is one of a number of JANET services provided by JANET(UK) (www.ja.net) and funded by the JISC (www.jisc.ac.uk) to benefit \nlearning, teaching and research communities. The Science and Technology Facilities Council (www.scitech.ac.uk) currently operates and develops the JISCmail service on behalf of JANET(UK).', 'http://www.jiscmail.ac.uk/about/index.htm', 'http://www.jiscmail.ac.uk/../cgi-bin/listsearcher.cgi?opt=listsearcher&listname=&alpha=&category=&chk_phrase=&chk_wds=ON&thecriteria={$formKeywords}', NULL, 3),
(1322, 255, 'Mad Science Net: The 24-hour exploding laboratory', 'Mad Science Net: The 24-hour exploding laboratory is a collective cranium of scientists providing answers to your questions.', 'http://www.madsci.org/', 'http://www.madsci.org/cgi-bin/search?Submit=Submit+Query&or=AND&words=1&index=MadSci+Archives&MAX_TOTAL=25&area=All+areas&grade=All+grades&query={$formKeywords}', NULL, 2),
(1321, 255, 'EurekAlert!', 'EurekAlert! is an online press service created by the American Association for the Advancement of Science (AAAS). The primary goal of EurekAlert! is to provide a forum where research institutions, universities, government agencies, corporations and the like can distribute science-related news to reporters and news media. The secondary goal of EurekAlert! is to archive these press releases and make them available to the public in an easily retrievable system.', 'http://www.eurekalert.org/links.php', 'http://search.eurekalert.org/e3/query.html?col=ev3rel&qc=ev3rel&x=8&y=9&qt={$formKeywords}', NULL, 1),
(1320, 255, 'Ask the Experts', 'Ask the Experts is provided by the Scientific American magazine. Questions and answers are archived and organized.', 'http://www.sciam.com/askexpert', 'http://www.google.com/search?q=site%3Asciam.com+%22ask+the+experts%22%2B+', NULL, 0),
(1319, 254, 'Scholarly Societies Project Meeting/Conference Announcement List', 'Scholarly Societies Project Meeting/Conference Announcement List is a searchable service provided by the University of Waterloo.', 'http://www.scholarly-societies.org/', 'http://ssp-search.uwaterloo.ca/cd.cfm?search_type=advanced&field1=any&boolean1=and&operator1=and&field2=any&textfield2=&boolean2=and&operator2=and&field3=any&textfield3=&boolean3=and&operator3=and&founded=none&&textfield1={$formKeywords}', NULL, 0),
(1318, 253, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(1317, 253, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(1316, 253, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(1315, 253, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(1313, 252, 'PhilSci Archive', 'PhilSci Archive is an electronic archive for preprints in the philosophy of science.', 'http://philsci-archive.pitt.edu/', 'http://philsci-archive.pitt.edu/perl/search?_order=bytitle&abstract%2Fkeywords%2Ftitle_srchtype=ALL&_satisfyall=ALL&_action_search=Search&abstract%2Fkeywords%2Ftitle={$formKeywords}', NULL, 8),
(1314, 253, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(1312, 252, 'KOSMOI', 'KOSMOI includes educational articles, books, posters, & web links for all interested in the wonders of our Cosmos, on Science, Space, Technology, Nature, & Web Design. Updated daily.', 'http://kosmoi.com/', 'http://www.google.com/custom?sa=Search&cof=GIMP%3A%23cccccc%3BT%3A%23ffdd99%3BLW%3A468%3BALC%3Ared%3BL%3Ahttp%3A%2F%2Fencyclozine.com%2FPictures%2FBanner%2FEncycloZine2.jpg%3BGFNT%3A%23999999%3BLC%3A%23ffcc33%3BLH%3A60%3BBGC%3Ablack%3BAH%3Acenter%3BVLC%3A%23ffcc66%3BGL%3A2%3BGALT%3A%23ffffff%3BAWFID%3A29728ead1ae72975%3B&domains=EncycloZine.com%3BKosmoi.com%3BEluzions.com&sitesearch=Kosmoi.com&q={$formKeywords}', NULL, 7),
(1311, 252, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 6),
(1310, 252, 'CASI Technical Report Server', 'CASI Technical Report Server contains bibliographic citations and abstracts to unclassified documents announced in Scientific and technical aerospace reports, plus the document series produced by NASA''s predecessor, The National Advisory Committee for Aeronautics, and the NASA open literature file containing citations and abstracts to literature in the fields of aeronautics, space science, chemistry, engineering, geosciences, life sciences, mathematics, computer sciences, and physics.', 'http://www.sti.nasa.gov/RECONselect.html', 'http://ntrs.nasa.gov/index.cgi?method=search&limit=25&offset=0&mode=simple&order=DESC&keywords={$formKeywords}', NULL, 5),
(1308, 252, 'FirstGov for Science', 'Science.gov is a gateway to authoritative selected science information provided by U.S. Government agencies, including research and development results.  It enables you to search 47 million pages in real time.', 'http://science.gov/', 'http://www.science.gov/search30/search.html?expression={$formKeywords}', NULL, 3),
(1309, 252, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 4),
(1307, 252, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?author1=&pubdate_year=&volume=&firstpage=&src=hw&hits=10&hitsbrief=25&resourcetype=1&andorexactfulltext=and&fulltext={$formKeywords}', NULL, 2),
(1306, 252, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science.  The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1305, 252, 'Channel 4 Science', 'Channel 4''s science site covers a wide range of current scientific issues from science in society to science in medicine. The site is split into broad sections, each containing related topics, articles and programme information. There are resources at the end of the articles with listings of related Web Sites and reading material. The site also contains a helpful glossary and an "Ask an expert" facility for posing scientific queries to a body of scientific experts.', 'http://www.channel4.com/science/index.html', 'http://search.channel4.com/search?&sort=date%3AD%3AL%3Ad1&output=xml_no_dtd&ie=UTF-8&oe=UTF-8&client=standard_c4&proxystylesheet=standard_c4&q={$formKeywords}', NULL, 0),
(1304, 251, 'SciCentral', 'A directory of links to "today''s breaking science news." Browsable by topic, including biosciences, health sciences, physics, chemistry, earth and space, and engineering. Also includes links to related journals, databases, job opportunities, and conferences.', 'http://scicentral.com/', 'http://www.google.com/custom?client=pub-2641291926759270&forid=1&channel=1291454416&ie=ISO-8859-1&oe=ISO-8859-1&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23FFFFFF%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A9999FF%3BGIMP%3A9999FF%3BLH%3A50%3BLW%3A78%3BL%3Ahttp%3A%2F%2Fwww.scicentral.com%2Fimages%2Fscclogo_for_google.gif%3BS%3Ahttp%3A%2F%2Fwww.scicentral.com%3BFORID%3A1%3B&hl=en&q={$formKeywords}', NULL, 1),
(1303, 251, 'Science.gov', 'Science.gov is a gateway to over 50 million pages of authoritative selected science information provided by U.S. government agencies, including research and development results.', 'http://www.science.gov', 'http://www.science.gov/scigov/search.html?expression={$formKeywords}', NULL, 0),
(1302, 250, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 6),
(1300, 250, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 4),
(1301, 250, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 5),
(1299, 250, 'E-STREAMS', 'E-STREAMS: Electronic reviews of Science & Technology References covering Engineering, Agriculture, Medicine and Science. Each issue contains 30+ STM reviews, covering new titles in Engineering, Agriculture, Medicine and Science. Each review is signed, and includes the email address of the reviewer. The reviews feature short TOCs, a list of contributors and bibliographic information.', 'http://www.e-streams.com/', 'http://www.e-streams.com/c3/cgi-bin/search.pl', 'boolean=AND&case=Insensitive&terms={$formKeywords}', 3),
(1298, 250, 'National Academy Press(NAP)', 'The National Academy Press (NAP) publishes over 200 books a year on a wide range of topics in science, engineering, and health, capturing the most authoritative views on important issues in science and health policy.', 'http://books.nap.edu/books/0309070317/html/177.html', 'http://search.nap.edu/nap-cgi/napsearch.cgi?term={$formKeywords}', NULL, 2),
(1297, 250, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 1),
(1296, 250, 'Science Books and Films', 'Science Books and Films is the AAAS review journal for science materials for all ages, including reviews and recommendations for books, videos, software, and web sites.', 'http://sbfonline.com/', 'http://sbfonline.com/sample/search.cgi?title_query_type=all&author_query_type&author=&other=&type=B&type=F&type=S&title={$formKeywords}', NULL, 0);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(1295, 249, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 4),
(1293, 249, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 2),
(1294, 249, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 3),
(1292, 249, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 1),
(1291, 249, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(1290, 248, 'KOSMOI', 'KOSMOI includes educational articles, books, posters, & web links for all interested in the wonders of our Cosmos, on Science, Space, Technology, Nature, & Web Design. Updated daily.', 'http://kosmoi.com/', 'http://www.google.com/custom?sa=Search&cof=GIMP%3A%23cccccc%3BT%3A%23ffdd99%3BLW%3A468%3BALC%3Ared%3BL%3Ahttp%3A%2F%2Fencyclozine.com%2FPictures%2FBanner%2FEncycloZine2.jpg%3BGFNT%3A%23999999%3BLC%3A%23ffcc33%3BLH%3A60%3BBGC%3Ablack%3BAH%3Acenter%3BVLC%3A%23ffcc66%3BGL%3A2%3BGALT%3A%23ffffff%3BAWFID%3A29728ead1ae72975%3B&domains=EncycloZine.com%3BKosmoi.com%3BEluzions.com&sitesearch=Kosmoi.com&q={$formKeywords}', NULL, 8),
(1289, 248, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 7),
(1282, 248, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(1283, 248, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science.  The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(1284, 248, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(1285, 248, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(1286, 248, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(1287, 248, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 5),
(1288, 248, 'NASA Technical Report Server', 'NASA Technical Report Server (NTRS) is to provide students, educators, and the public access to NASA''s technical literature. NTRS also collects scientific and technical information from sites external to NASA to broaden the scope of information available to users.', 'http://ntrs.nasa.gov/index.jsp?method=aboutntrs', 'http://ntrs.nasa.gov/search.jsp?N=0&Ntk=all&Ntx=mode%20matchall&Ntt={$formKeywords}', NULL, 6),
(2408, 462, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2409, 462, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(2407, 461, 'ChemCenter', 'This is a pooling of Web resources from the American Chemical Society and Chemical Abstracts Service, including STNEasy, the ACS Graduate School Finder, Chemcyclopedia and more. It will eventually feature unique resources as well.', 'http://www.chemistry.org/portal/a/c/s/1/home.html', 'http://google.acs.org/search?by=&site=americanchemical&client=americanchemical&proxystylesheet=americanchemical&output=xml_no_dtd&q={$formKeywords}', NULL, 0),
(2406, 460, 'Hazardous Chemical Databases', 'This database, created at the University of Akron, will allow the user to retrieve information for any of 23,495 hazardous chemicals or ''generic'' entries based on a keyword search.', 'http://ull.chemistry.uakron.edu/erd/', 'http://ull.chemistry.uakron.edu/cgi-bin/htsearch?method=and&format=builtin-long&sort=score&config=DEFAULT&restrict=&exclude=&words={$formKeywords}', NULL, 3),
(2405, 460, 'Chemistry.Org', 'chemistry.org is the online gateway to ACS resources, products, and services for members, chemists, scientists, chemical industry professionals, educators, students, children and science enthusiasts.', 'https://portal.chemistry.org/portal/acs/corg/memberapp', 'http://google.acs.org/search?site=americanchemical&client=americanchemical&proxystylesheet=americanchemical&output=xml_no_dtd&q={$formKeywords}', NULL, 2),
(2404, 460, 'Scirus', 'Scirus is the most comprehensive science-specific search engine on the Internet. Driven by the latest search engine technology, Scirus searches over 150 million science-specific Web pages.', 'http://www.scirus.com/', 'http://www.scirus.com/search_simple/?frm=simple&dsmem=on&dsweb=on&wordtype_1=phrase&query_1={$formKeywords}', NULL, 1),
(2403, 460, 'ChemFinder (Requires Registration)', 'This site enabling searching of the CS database by chemical name, CAS Number, molecular formula, or molecular weight. Also provides links to many chemical information web sites.', 'http://chemfinder.cambridgesoft.com/', 'http://chemfinder.cambridgesoft.com/result.asp?polyQuery={$formKeywords}', NULL, 0),
(2402, 459, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2401, 459, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2400, 459, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2399, 459, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2397, 458, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of\nreferences to more than 11 million articles published in 4300 biomedical\njournals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(2398, 458, 'TOXNET', 'TOXNET provides a searchable collection of databases on toxicology, hazardous chemicals, and related areas.', 'http://toxnet.nlm.nih.gov/', 'http://toxnet.nlm.nih.gov/cgi-bin/sis/search', 'submit2=&amp;basicsearch=/cgi-bin/sis/htmlgen?index.html&revisesearch=/home/httpd/htdocs/index.html&revisesearch=/home/httpd/htdocs/html/index.html&second_search=1&chemsyn=1&database=toxline&database=dart&database=hsdb&database=iris&database=iter&database=genetox&database=ccris&database=tri2003&database=chemid&database=hpd&database=hazmap&Stemming=1&and=1&xfile=1&queryxxx={$formKeywords}', 7),
(2396, 458, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'pp=all&INTERFACE=1WINDOW&FORM=DistributedSearch.html&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&MAXDOCS=50&QUERY={$formKeywords}', 5),
(2395, 458, 'General Chemistry Online', 'An introduction that includes hyperlinked notes, guides,\nand articles for first semester chemistry. There is a glossary, FAQs and a\ntrivia quiz. The Toolbox provides interactive graphing, a pop-up periodic table,\nand calculators. Additionally, Tutorials contains self-guided tutorials,\nquizzes, and drills on specific topics. There is one database of 800 common\ncompound names, formulas, structures, and properties, and another for over 400\nannotated Web sites. From a chemistry professor at Frostburg State University,\nMaryland. Searchable.', 'http://antoine.frostburg.edu/chem/senese/101/', 'http://marie.frostburg.edu/cgi-bin/htsearch?method=and&config=htdig&restrict=101&exclude=print-&format=builtin-long&sort=score&words={$formKeywords}', NULL, 4),
(2394, 458, 'Eric Weisstein''s World of Science--Chemistry', 'Includes extensive encyclopedias of astronomy, chemistry, mathematics, physics, and scientific biography. Entries include definitions, diagrams, formulas, cross-references, and related resources. Searchable, and browsable alphabetically or by topic. Also has a "random entry" feature. The author is a scientist with advanced degrees in physics and planetary science.', 'http://scienceworld.wolfram.com/chemistry/', 'http://scienceworld.wolfram.com/search/index.cgi?sitesearch=scienceworld.wolfram.com%2Fchemistry&q={$formKeywords}', NULL, 3),
(2393, 458, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 2),
(2392, 458, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(2391, 458, 'chemdex.org', 'Searchable directory of more than 7,000 chemistry related\nsites. Includes general chemistry, organizations, Web portals, biography,\nsoftware, standards, and more. Users may rate and review sites. Some features\nrequire free registration. Based at the Department of Chemistry, University of\nSheffield, England.', 'http://www.chemdex.org/', 'http://www.chemdex.org/action.php?action=search', 'current_cat_id=&table=link&form_input_search_keyword={$formKeywords}', 0),
(2390, 457, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(2389, 457, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(2388, 457, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language \nword or acronym, and OneLook will search its index of 5,292,362 words in 934 \ndictionaries indexed in general and special interest dictionaries for the \ndefinition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(2387, 457, 'NIST Chemistry WebBook', 'This site provides thermochemical, thermophysical, and ion energetics data \ncompiled by NIST under the Standard Reference Data Program.', 'http://webbook.nist.gov/chemistry/', 'http://webbook.nist.gov/cgi/cbook.cgi?Units=SI&Name={$formKeywords}', NULL, 3),
(2386, 457, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(2384, 457, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2385, 457, 'General Chemistry Online: Glossary', 'Searchable and browsable by topic or letter. Part of General Chemistry Online.', 'http://antoine.frostburg.edu/chem/senese/101/glossary.shtml', 'http://antoine.frostburg.edu/cgi-bin/senese/searchglossary.cgi?shtml=%2Fchem%2Fsenese%2F101%2Fglossary.shtml&query={$formKeywords}', NULL, 1),
(2383, 456, 'MEDLINE/PubMed', 'MEDLINE is the National Library of Medicine''s database of\nreferences to more than 11 million articles published in 4300 biomedical\njournals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(2382, 456, 'GrayLIT Network', 'GrayLIT Network provides a full-text search across the gray literature of multiple government agencies within a science portal of technical reports. It taps into the search engines of distributed gray literature collections, enabling the user to find information without first having to know the sponsoring agency.', 'http://graylit.osti.gov/', 'http://graylit.osti.gov/cgi-bin/dexplcgi', 'app=allGRAYLIT&INTERFACE=1WINDOW&FORM=/DistributedSearch.html&$$AUTHOR=&$$QTITLE=&$$SUBJECT=&$$ABSTRACT=&$$START_YEAR=&$$END_YEAR=&COLLECTION=dticft&COLLECTION=jpl&COLLECTION=gpoinfo&COLLECTION=langley&COLLECTION=nepis&MAXDOCS=50&QUERY={$formKeywords}', 5),
(2381, 456, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(2380, 456, 'DOE Information Bridge', 'The Information Bridge provides the open source to full-text and bibliographic records of Department of Energy (DOE) research and development reports in physics, chemistry, materials, biology, environmental sciences, energy technologies, engineering, computer and information science, renewable energy, and other topics.', 'http://www.osti.gov/bridge/index.jsp', 'http://www.osti.gov/bridge/basicsearch.jsp?act=Search&formname=basicsearch.jsp&review=1&SortBy=RELV&SortOrder=DESC&querytype=search&searchFor={$formKeywords}', NULL, 3),
(2379, 456, 'OAIster (Open Archives Initaitive research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 2),
(2378, 456, 'Intute: Science, Engineering & Technology', 'Intute: Science, Engineering and Technology is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists. It covers the physical sciences, engineering, computing, geography, mathematics and environmental science. The database currently contains 33349 records.', 'http://www.intute.ac.uk/sciences/', 'http://www.intute.ac.uk/sciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=sciences&term1={$formKeywords}', NULL, 1),
(2377, 456, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2375, 455, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2376, 455, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2374, 455, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2372, 454, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 6),
(2373, 455, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2370, 454, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/search.asp', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 4),
(2371, 454, 'Scientific American Archive', 'Scientific American Archive is the online science and technology resource offering access to every page and every issue of Scientific American magazine from 1993 to the present.', 'http://www.sciamdigital.com/', 'http://www.sciamdigital.com/index.cfm?fa=Search.ViewSearchForItemResultList&AUTHOR_CHAR=&TITLE_CHAR=&FullText_CHAR={$formKeywords}', NULL, 5),
(2369, 454, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 3),
(2367, 454, 'ASTRONOMY magazine', 'ASTRONOMY magazine, the world''s best selling English magazine, offers visitors a wide variety of information for both hobbyist and armchair astronomers alike.', 'http://www.astronomy.com/home.asp', 'http://www.astronomy.com/asy/default.aspx?c=se&outsideHidden=Yes&searchStr={$formKeywords}', NULL, 1),
(2368, 454, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 2),
(2366, 454, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2364, 453, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(2365, 453, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(2363, 453, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(2362, 453, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(2361, 453, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2360, 453, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(2359, 453, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(2358, 453, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://www.canada.gc.ca/main_e.html', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(2356, 452, 'Space Science Education Home Page -- Goddard Space Flight Center', 'Data from several NASA missions, student activities, teacher resources', 'http://gsfc.nasa.gov/education/education_home.html', 'http://search.nasa.gov/nasasearch/search/search.jsp?nasaInclude={$formKeywords}', NULL, 2),
(2357, 453, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2293, 441, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 5),
(2294, 441, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 6),
(2292, 441, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www-fed-all&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=5&y=16&mw0={$formKeywords}', NULL, 4),
(2291, 441, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 3),
(2290, 441, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 2),
(2289, 441, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://publications.gc.ca/helpAndInfo/abtpbs-e.htm', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(2288, 441, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2287, 440, 'Jurist: The Law Professors'' Network', 'Jurist-Law professors on the web provides links to the home pages of over fifty law professors, to over fifty pre- and post-prints of articles (in nine subjects from business law to regulation), and to twenty meta-pages, maintained by law professors, on topics from administrative to tax law. Also included are a large list of online law course pages, three lectures, and pointers to other resources. Essentially an annotated tour through the law resources of the Internet conducted by professors of law.', 'http://www.law.pitt.edu/hibbitts/jurist.htm', 'http://www.picosearch.com/cgi-bin/ts.pl?index=110412&opt=ALL&SEARCH=Search+JURIST+5000&query={$formKeywords}', NULL, 6),
(2286, 440, 'FindLaw', 'FindLaw is one of the best examples of a subject-specific metasite. More than just an extremely well-organized directory of selected Internet law resources, FindLaw also offers a search tool for legal Web pages, the largest free database of full-text Supreme Court cases, a search engine and directory of online law reviews, a collection of state codes, interactive continuing education courses, and legal online discussions.', 'http://www.findlaw.com/', 'http://lawcrawler.findlaw.com/scripts/lc.pl?submit=search&sites=findlaw.com&entry={$formKeywords}', NULL, 5),
(2285, 440, 'The World Legal Information Institute (WorldLII)', 'The World Legal Information Institute (WorldLII) is a free, independent and non-profit global legal research facility.', 'http://www.worldlii.org/', 'http://www.worldlii.org/form/search/?method=any&meta=%2Fworldlii&results=50&submit=Search&rank=on&callback=on&query={$formKeywords}', NULL, 4),
(2284, 440, 'CanLII', 'CanLII is a permanent resource in Canadian Law that was initially built as a prototype site in the field of public and free distribution of Canadian primary legal material.', 'http://www.canlii.org/en/index.html', 'http://www.canlii.org/eliisa/search.do?language=en&searchTitle=Search+all+CanLII+Databases&searchPage=eliisa%2FmainPageSearch.vm&id=&startDate=&endDate=&legislation=legislation&caselaw=courts&boardTribunal=tribunals&text={$formKeywords}', NULL, 3),
(2283, 440, 'The British and Irish Legal Information Institute (BAILII)', 'British and Irish Legal Information Institute (BAILII) provides access to the most comprehensive set of British and Irish primary legal materials that are available for free and in one place on the Internet. As of September 2001, BAILII included 19 databases covering 5 jurisdictions. The system contains over two gigabytes of legal materials and around 275,000 searchable documents with about 10 million internal hypertext links.', 'http://www.bailii.org/', 'http://www.bailii.org/cgi-bin/sino_search_1.cgi?sort=rank&method=boolean&highlight=1&mask_path=/&query={$formKeywords}', NULL, 2),
(2282, 440, 'The Legal Information Institute (US)', 'Legal Information Institute (US) is an extensive materials on the law that has overviews of more than 100 legal topics, including: links to the laws and related Web resources; Constitutions & Codes has both state and federal; Court Opinions, available judicial opinion, federal and state; Law by Source, federal, state, and international; Current Awareness includes Eye on the Courts (news on important court decisions); Directories, links to organizations and journals (law reviews); as well as directories of judges, lawyers, and law schools.', 'http://www.law.cornell.edu/', 'http://www.law.cornell.edu/wex/index.php/Special:Search?fulltext=Search&search={$formKeywords}', NULL, 1),
(2280, 439, 'Sociology Online', 'Sociology Online is a site for students of sociology, criminology and social theory. The site has slideshows, quizzes, and documents, as well as a Socio-News page.', 'http://www.sociologyonline.co.uk/', 'http://ccgi.sociologyonline.force9.co.uk/cgi-bin/site/searchnews.pl?dosearch', 'match=keywords&searchin=(All)&author=(All)&category=(All)&newsfrom=(All)&resultnumber=10&sort=new&multipage=on&linkcompression=10&highlight=on&searchquery={$formKeywords}', 2),
(2281, 440, 'The Australasian Legal Information Institute (AustLII)', 'Australasian Legal Information Institute (AustLII) provides free Internet access to Australian legal materials. AustLII''s broad public policy agenda is to improve access to justice through better access to information. To that end, it has become one of the largest sources of legal materials on the net, with over seven gigabytes of raw text materials and over 1.5 million searchable documents.', 'http://www.austlii.org/', 'http://www.austlii.edu.au/cgi-bin/sinocgi.cgi?method=any&meta=%2Fau&results=50&submit=Search&rank=on&callback=on&query={$formKeywords}', NULL, 0),
(2279, 439, 'Intute: Social Sciences - Conferences and Events', 'Intute: Social Sciences - Conferences and Events provides search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(2277, 438, 'Statistical Resources on the Web', 'This site, created and maintained by University of Michigan Documents Center, is organized by broad subject area, such as Foreign or Statistics, in order to facilitate research.', 'http://www.lib.umich.edu/govdocs/statsnew.html', 'http://www.google.com/u/umlib?hl=en&lr=&ie=ISO-8859-1&domains=www.lib.umich.edu&sitesearch=www.lib.umich.edu&q=inurl%3Agovdocs+-govdocs%2Fadnotes%2F+%0D%0A-govdocs%2Fgodort%2F&q={$formKeywords}', NULL, 3),
(2278, 439, 'H-Net Humanities and Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www.h-net.msu.edu/', 'http://www.h-net.org/logsearch/index.cgi?type=keyword&order=relevance&list=All+lists&hitlimit=25&smonth=00&syear=1989&emonth=11&eyear=2004&phrase={$formKeywords}', NULL, 0),
(2276, 438, 'SocioSite', 'SocioSite is a multi-purpose guide for sociologists. Based in the Netherlands, it includes useful links to sites around the world.', 'http://www2.fmg.uva.nl/sociosite/', 'http://www.google.com/search?q=site:www2%2Efmg%2Euva%2Enl%2Fsociosite%2F+', NULL, 2),
(2275, 438, 'Social Science Research Network - SSRN (Austin, Texas, USA)', 'Social Science Research Network (SSRN) is devoted to the rapid worldwide dissemination of social science research and is composed of a number of specialized research networks in each of the social sciences.', 'http://www.ssrn.com/', 'http://papers.ssrn.com/sol3/results.cfm', 'searchTitle=Title&searchAbstract=Abstract&txtAuthorsFName=&txtAuthorsLName=&optionDateLimit=0&Form_Name=Abstract_Search&txtKey_Words={$formKeywords}', 1),
(2274, 438, 'Australian Social Science Data Archive', 'ASSDA is a member of the International Federation of Data Organisations (IFDO) through which it maintains contacts with data organisations abroad actively engaged in providing the social science community with computerised data and documentation. Links to other data archives.', 'http://assda.anu.edu.au/', 'http://assda.anu.edu.au/htdig/htsearch?method=and&format=builtin-long&sort=score&config=assda&restrict=http://assda.anu.edu.au/&exclude=&words={$formKeywords}', NULL, 0),
(2273, 437, 'CIA World Fact Book', 'Unclassified since 1971, The Central Intelligence Agency''s annual World Fact Book provides a reliable resource for information on independent states, dependencies, areas of special sovereignty, uninhabitable regions, and oceans (a total of 267 entries). Each entry typically includes concise physical and demographic statistics, an economic overview, as well as communications, transportation, and military information.', 'https://www.cia.gov/library/publications/the-world-factbook/index.html', 'https://www.cia.gov/search?NS-search-page=results&NS-tocstart-pat=/text/HTML-advquery-tocstart.pat', 'NS-search-type=NS-boolean-query&NS-max-records=20&NS-sort-by=&NS-max-records=20&NS-collection=Everything&NS-query={$formKeywords}', 3),
(2272, 437, 'Inter-American Development Bank Project Documents', 'Inter-American Development Bank Project Documents. Project documents from the Inter-American Development Bank, browseable by country and economic sector. Includes both proposed and approved projects.', 'http://www.iadb.org/exr/pic/index.cfm?language=english', 'http://search.iadb.org/search.asp?ServerKey=Primary&collection=newcoll&language=English&ResultTemplate=default1.hts&ResultStyle=normal&ViewTemplate=docview.hts&Querytext={$formKeywords}', NULL, 2),
(2271, 437, 'International Monetary Fund (IMF)', 'International Monetary Fund (IMF). Searchable and browsable database of IMF publications, including IMF Country Reports, Working Papers, Occasional Papers, and Policy Discussion Papers. Some reports listed on the site are not full-text but are available in print in the UCB main library.', 'http://www.imf.org/external/pubind.htm', 'http://www.imf.org/external/pubs/cat/shortres.cfm?auth_ed=&subject=&ser_note=All&datecrit=During&YEAR=Year&Lang_F=All&brtype=Date&submit=Search&TITLE={$formKeywords}', NULL, 1),
(2270, 437, 'Country Studies: Area Handbook Series', 'From the Library of Congress, this site provides extensive information on foreign countries.  The Country Studies Series presents a description and analysis of the historical setting and the social, economic, political, and national security systems and institutions of countries throughout the world.', 'http://lcweb2.loc.gov/frd/cs/cshome.html', 'http://search.loc.gov:8765/query.html?col=loc&qp=url%3A%2Frr%2Ffrd%2F&submit.x=11&submit.y=9&qt={$formKeywords}', NULL, 0),
(2269, 436, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2268, 436, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2267, 436, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2265, 435, 'CTheory (Requires registration)', 'An international, electronic review of books on theory, technology and culture. Sponsored by the Canadian Journal of Political and Social Theory, reviews are posted periodically of key books in contemporary discourse as well as theorisations of major "event-scenes" in the mediascape.', 'http://www.ctheory.net/', 'http://www.google.com/search?q=site%3Awww.ctheory.net+{$formKeywords}', NULL, 0);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(2266, 436, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2264, 434, 'Social Science Data on the Internet', 'Social Science Data on the Internet is an extensive collection of 873 Internet sites of numeric social science statistical data, data catalogs, data libraries, social science gateways, and financial and economic census files.', 'http://odwin.ucsd.edu/idata/', 'http://odwin.ucsd.edu/cgi-bin/easy_search2?print=notitle&file+Data+on+the+Net=%2Fdata%2Fdata.html&amp;skip=search.html&header=%2Fheader%2Fheader&search={$formKeywords}', NULL, 4),
(2263, 434, 'UK Data Archive', 'The Data Archive at the University of Essex houses the largest collection of accessible computer-readable data in the social sciences and humanities in the United Kingdom. It is a national resource centre, disseminating data throughout the United Kingdom and, by arrangement with other national archives, internationally. Founded in 1967, it now houses approximately seven thousand datasets of interest to researchers in all sectors and from many different disciplines.', 'http://www.data-archive.ac.uk/', 'http://www.data-archive.ac.uk/search/allSearch.asp?ct=xmlAll&zoom_and=1&q1={$formKeywords}', NULL, 3),
(2262, 434, 'Australian Social Science Data Archive', 'ASSDA is a member of the International Federation of Data Organisations (IFDO) through which it maintains contacts with data organisations abroad actively engaged in providing the social science community with computerised data and documentation. Links to other data archives.', 'http://assda.anu.edu.au/', 'http://assda.anu.edu.au/htdig/htsearch?method=and&format=builtin-long&sort=score&config=assda&restrict=http://assda.anu.edu.au/&exclude=&words={$formKeywords}', NULL, 2),
(2261, 434, 'The OECD Statistics Portal', 'The OECD Statistics Portal collects the statistics needed for its analytical work from statistical agencies of its Member countries. The OECD promotes and develops international statistical standards and co-ordinates statistical activities with other international agencies.', 'http://www.oecd.org/statsportal/0,2639,en_2825_293564_1_1_1_1_1,00.html', 'http://www.oecd.org/searchResult/0,2665,en_2825_293564_1_1_1_1_1,00.html?searchText=&fpDepartment=293564&fpSearchExact=3&fpSearchText={$formKeywords}', NULL, 1),
(2260, 434, 'Inter-university Consortium for Political and Social Research (ICPSR)', 'Inter-university Consortium for Political and Social Research (ICPSR) contains social data archives include nearly 5,000 titles and over 45,000 individual files over 300 institutions in the world.', 'http://www.icpsr.umich.edu/', 'http://search.icpsr.umich.edu/ICPSR/query.html?nh=25&rf=3&ws=0&op0=%2B&fl0=&ty0=w&col=abstract&col=series&col=uncat&op1=-&tx1=restricted&ty1=w&fl1=availability%3A&op2=%2B&tx2=ICPSR&ty2=w&fl2=archive%3A&tx0={$formKeywords}', NULL, 0),
(2258, 433, 'Public Agenda Online', 'Sponsored by fourteen public service-oriented foundations, Public Agenda Online offers 21 issue guides for such topics as Abortion, Crime, the Federal Budget, Race, and Welfare. Analytical essays, summaries of news articles, and graphs representing poll results enhance Public Agenda''s extensive coverage of each topic.', 'http://www.publicagenda.org/', 'http://www.publicagenda.org/search/search_details.cfm', 'StartRow=1&searchstring={$formKeywords}', 1),
(2259, 433, 'PollingReport.com', 'PollingReport.com is an independent, nonpartisan resource on trends in American public opinion.', 'http://www.pollingreport.com/', 'http://www.pollingreport.com/_vti_bin/shtml.exe/search.htm', 'VTI-GROUP=0&search={$formKeywords}', 2),
(2255, 432, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page. The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2256, 432, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(2257, 433, 'The Gallup Organization', 'The Gallup site allows for topic keyword searches and also has a topic index, listing major issues such as Abortion, Campaign Finance, Illegal Drugs, and Taxes, with retrospective poll results, sometimes dating back to the 1950s, included for each.', 'http://www.gallup.com/', 'http://www.gallup.com/search/results.aspx?SearchConType=&SearchTypeAll=any&SearchTypeExa=any&SearchTypeAny=any&SearchTypeNon=any&SearchTextExa=&SearchTextAny=&SearchTextNon=&SearchSiteInd=&SearchSiteAll=&SearchDateBef=&SearchDateAft=&SearchDateBMo=&SearchDateAMo=&SearchDateBDa=&SearchDateADa=&SearchDateBYe=&SearchDateAYe=&SearchTextAll={$formKeywords}', NULL, 0),
(2254, 432, 'ebrary', 'Independent researchers who do not have access to ebrary?s databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(2252, 431, 'Law and Politics Book reviews', 'The Law and Politics Book reviews is sponsored by the Law and Courts Section of the American Political Science Association. The electronic medium enables us to review almost every book about the legal process and politics, to do longer reviews than are usually published, and to make the reviews available within six months of our receipt of the book.', 'http://www.bsos.umd.edu/gvpt/lpbr/', 'http://www.searchum.umd.edu/search?btnG=Search&output=xml_no_dtd&proxystylesheet=UMCP&as_sitesearch=http://www.bsos.umd.edu/gvpt/lpbr&client=UMCP&site=UMCP&q={$formKeywords}', NULL, 2),
(2253, 432, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2251, 431, 'Books-on-Law', 'Books-on-Law reviewing new and forthcoming scholarly and trade books related to law; from JURIST: The Law Professors'' Network', 'http://jurist.law.pitt.edu/lawbooks/', 'http://search.freefind.com/find.html?id=9814374&pageid=r&mode=ALL&query={$formKeywords}', NULL, 1),
(2249, 430, 'Voice of the Shuttle', 'Voice of the Shuttle emphasizes both primary and secondary (or theoretical) resources of American literature, including links of syllabi, electronic journals and newsgroups.', 'http://vos.ucsb.edu/', 'http://vos.ucsb.edu/search-results.asp?Submit=Go&search={$formKeywords}', NULL, 5),
(2250, 431, 'Anthropology Review Databases (ARD)', 'The Anthropology Review Databases is intended to improve the level of access of anthropologists to anthropological literature by making them more aware of what is being published and helping them to evaluate its relevance to their own interests.', 'http://wings.buffalo.edu/ARD/', 'http://wings.buffalo.edu/ARD/cgi/search.cgi?authors=&subject=&date1=&date2=&medium=&reviewer=&title={$formKeywords}', NULL, 0),
(2248, 430, 'SocioSite', 'SocioSite gives access to the worldwide scene of social sciences. The intention is to provide a comprehensive listing of all sociology resources on the Internet.', 'http://www.pscw.uva.nl/sociosite/', 'http://www.google.com/u/sociosite?sa=sociosite&domains=www2.fmg.uva.nl&sitesearch=www2.fmg.uva.nl&hq=inurl:www2.fmg.uva.nl/sociosite&q={$formKeywords}', NULL, 4),
(2247, 430, 'Intute: Social Sciences', 'Intute: Social Sciences is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 3),
(2245, 430, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 1),
(2246, 430, 'H-Net Reviews', 'H-Net Reviews in the Humanities and Social Sciences is an online scholarly review resource. reviews are published online via discussion networks and the H-Net web site. This permits our reviews to reach scholars with a speed unmatched in any other medium. It also makes a new kind of interactivity possible, as reviewers, authors and readers engage in discussions of the reviews online. Through the power of e-mail and the web H-Net has helped pioneer online scholarly reviewing.', 'http://www2.h-net.msu.edu/reviews/', 'http://www2.h-net.msu.edu/reviews/search.cgi?maxlines=25&maxfiles=25&all=all&query={$formKeywords}', NULL, 2),
(2244, 430, 'CIAO (Columbia International Affairs Online)', 'Established as a collaboration between the Columbia University libraries and Columbia University Press with a grant from the Andrew W. Mellon Foundation, CIAO comprises a collection of theory and research materials in the field of international affairs. Working papers from university research institutes, policy briefs, country data, journal abstracts, and conference proceedings, all from 1991 - present, are among the materials available from this resource.', 'http://www.ciaonet.org/', 'http://usearch.cc.columbia.edu/ciao/query.html?qp=url%3Awps&qp=url%3Aolj&qp=url%3Apbei&qp=url%3Abook&qp=url%3Acasestudy&op1=%2B&fl1=&ty1=w&tx1=&dt=in&inthe=2147483647&op0=&fl0=&ty0=w&qt=&ht=0&qp=&qs=&col=ciao&qc=ciao&pw=100%25&ws=0&la=en&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&si=0&ql=a&x=34&y=8&tx0={$formKeywords}', NULL, 0),
(2243, 429, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(2242, 429, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 4),
(2241, 429, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(2240, 429, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 2),
(2238, 429, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2239, 429, 'Online Dictionary of the Social Sciences', 'Online Dictionary of the Social Sciences is a searchable dictionary of terms commonly used in the social sciences. Both phrase and keyword searches are facilitated.', 'http://bitbucket.icaap.org/', 'http://bitbucket.icaap.org/dict.pl?fuzzy={$formKeywords}', NULL, 1),
(2105, 405, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(2103, 405, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2104, 405, 'Dictionary of Philosophy of Mind', 'Dictionary of Philosophy of Mind is a searchable database of peer-reviewed articles on concepts and individuals in the field of philosophy.', 'http://www.artsci.wustl.edu/~philos/MindDict/', 'http://search.yahoo.com/search?vp=dictionary&vs=artsci.wustl.edu&va={$formKeywords}', NULL, 1),
(2102, 404, 'Medline', 'MEDLINE is the National Library of Medicine''s database of references to more than 11 million articles published in 4,300 biomedical journals.', 'http://www.ncbi.nlm.nih.gov/pubmed/', 'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=PubMed&orig_db=PubMed&cmd=search&cmd_current=&query_key=1&term={$formKeywords}', NULL, 6),
(2101, 404, 'HighWire', 'HighWire is one of the highest-impact journals in the field of science, technology and medicine. As of March 2002 HighWire contained 11,785,877 articles in over 4,500 Medline journals and 405,385 free full text articles from 321 HighWire-based journals.', 'http://highwire.stanford.edu/lists/freeart.dtl', 'http://highwire.stanford.edu/cgi/searchresults?andorexactfulltext=and&resourcetype=1&src=hw&fulltext=&pubdate_year=&volume=&firstpage=&disp_type=&author1={$formKeywords}', NULL, 5),
(2100, 404, 'CogPrints', 'CogPrints is an electronic archive for papers in any area of Psychology, Neuroscience, and Linguistics, and many areas of Computer Science and Biology, which uses the self-archiving software of eprints.org. This archive can be searched by author, title or keyword. Both preprints and published refereed articles are included, with full contact details for each author.', 'http://cogprints.soton.ac.uk/', 'http://cogprints.ecs.soton.ac.uk/perl/search/simple?meta=&meta_merge=ALL&full=&full_merge=ALL&person_merge=ALL&date=&_satisfyall=ALL&_order=bytitle&_action_search=Search&person={$formKeywords}', NULL, 4),
(2099, 404, 'Behavior and Brain Sciences', 'Behavior and Brain Sciences is running on eprints.org open archive software, a freely distributable archive system available from eprints.org.', 'http://www.bbsonline.org/perl/search', 'http://www.bbsonline.org/perl/search?title_abstract_keywords_srchtype=all&authors_srchtype=all&year=&_satisfyall=ALL&_order=order0&submit=Search&.cgifields=publication&title_abstract_keywords=&authors={$formKeywords}', NULL, 3),
(2098, 404, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(2097, 404, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(2096, 404, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2095, 403, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2094, 403, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2093, 403, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2092, 403, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2090, 402, 'CNN Finance', 'Headline financial news and markets: keep up with what''s going on in the world of finance.', 'http://cnnfn.com/', 'http://search.money.cnn.com/pages/search.jsp?QueryText={$formKeywords}', NULL, 11),
(2091, 402, 'Nikkei Business Publications Asia', 'Japan BizTech is a source for technology and business news from Japan and Asia developed by Nikkei Business Publications. It covers the latest news and research breakthroughs in the communications, electronics and computer industries in Japan and other Asian countries. An online directory for technology and business contacts throughout Asia in banking, communications, transport equipment and wholesale is available at the site.', 'http://neasia.nikkeibp.com/', 'http://neasia.nikkeibp.com/cgi-bin/search.pl?stype=&lang=eng&b=1&t=1&u=0&alt=1&l=0&default=1&d=0&k=0&au=0&terms={$formKeywords}', NULL, 12),
(2089, 402, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 10),
(2087, 402, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 8),
(2088, 402, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 9),
(2085, 402, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=site1week&submit.x=1&submit.y=9&query={$formKeywords}', NULL, 6),
(2086, 402, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 7),
(2084, 402, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 5),
(2082, 402, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(2083, 402, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 4),
(2081, 402, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 2),
(2079, 402, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2080, 402, 'Businesswire', 'Offers company press releases, searchable by company name, industry, region, or keyword/concept. Each company''s releases are broken down by topic, i.e., earnings, management changes, mergers/acquisitions, products, etc.', 'http://www.businesswire.com/', 'http://home.businesswire.com/portal/site/home/?epi_menuItemID=e23d7f2be635f4725e0fa455c6908a0c&epi_menuID=887566059a3aedb6efaaa9e27a808a0c&epi_baseMenuID=384979e8cc48c441ef0130f5c6908a0c&searchHereRadio=false&ndmHsc=v2*A0*J2*L1*N-1002313*Z{$formKeywords}', NULL, 1),
(2078, 401, 'THOMAS: Legislative Information on the Internet', 'Through Thomas, the Library of Congress offers the text of bills in the United States Congress, the full text of the Congressional Record, House and Senate committee reports, and historical documents.', 'http://thomas.loc.gov/', 'http://thomas.loc.gov/cgi-bin/thomas', 'congress=109&database=text&MaxDocs=1000&querytype=phrase&Search=SEARCH&query={$formKeywords}', 14),
(2076, 401, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www-fed-all&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=5&y=16&mw0={$formKeywords}', NULL, 12),
(2077, 401, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 13),
(2075, 401, 'Strategis', 'This site was developed by Industry Canada and provides a searchable database of Canadian companies, business information for each sector, a list of business support services, and a guide to business laws and regulations.  Trade Data Online provides Canadian and US trade data.', 'http://strategis.ic.gc.ca/engdoc/main.html', 'http://strategis.ic.gc.ca/cio/search-recherche/search.do?language=eng&V_SEARCH.command=search&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.date.modified&searchCriteriaArray%28V_SEARCH__returnedField%29=site_product_code&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.description&searchCriteriaArray%28V_SEARCH__returnedField%29=description&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.type&searchCriteriaArray%28V_SEARCH__returnedField%29=dc.creator&searchCriteriaArray%28V_SEARCH__returnedField%29=vdksummary&searchCriteria%28V_SEARCH__charMap%29=8859&searchCriteria%28V_SEARCH__resultsJSP%29=%2FsiteResults.do&searchCriteria%28V_SEARCH__customSearchJSP%29=%2FcustomSearch.do&searchCriteria%28V_SEARCH__documentJSP%29=%2Fdocument.do&searchCriteria%28V_SEARCH__locale%29=en_CA&searchCriteria%28V_SEARCH__baseURL%29=search.do&searchCriteria%28V_CUSTOM__searchWithin%29=false&searchCriteria%28V_CUSTOM__collection%29=industry&searchCriteria%28V_CUSTOM__details%29=show&searchCriteria%28V_SEARCH__sortSpec%29=score+desc&searchCriteria%28V_CUSTOM__operator%29=AND&searchCriteria%28V_CUSTOM__column%29=FULLTEXT&searchCriteria%28V_CUSTOM__userInput%29={$formKeywords}', NULL, 11),
(2074, 401, 'Country Studies: Area Handbook Series', 'From the Library of Congress, this site provides extensive information on foreign countries.  The Country Studies Series presents a description and analysis of the historical setting and the social, economic, political, and national security systems and institutions of countries throughout the world.', 'http://lcweb2.loc.gov/frd/cs/cshome.html', 'http://search.loc.gov:8765/query.html?col=loc&qp=url%3A%2Frr%2Ffrd%2F&submit.x=11&submit.y=9&qt={$formKeywords}', NULL, 10),
(2073, 401, 'E-Commerce Information from the European Union', 'Statistics, research, and discussion lists.', 'http://europa.eu.int/information_society/ecowor/ebusiness/index_en.htm', 'http://europa.eu.int/geninfo/query/engine/search/query.pl?action=FilterSearch&filter=europaflt.hts&collection=fullEUROPA&ResultTemplate=europarslt_ascii.hts&ResultCount=25&ResultMaxDocs=200&DefaultLG=en&ViewTemplate=europaview.hts&QueryText={$formKeywords}', NULL, 9),
(2072, 401, 'Organization for Economic Co-operation and Development', 'The OECD groups 30 member countries sharing a commitment to democratic government and the market economy. With active relationships with some 70 other countries, NGOs and civil society, it has a global reach. Best known for its publications and its statistics, its work covers economic and social issues from macroeconomics, to trade, education, development and science and innovation.', 'http://www.oecd.org/', 'http://www.oecd.org/searchResult/0,2665,en_2649_201185_1_1_1_1_1,00.html?fpSearchExact=3&fpSearchText={$formKeywords}', NULL, 8),
(2071, 401, 'Business.gov', 'Business.gov is  an online resource guide designed to provide legal and regulatory information to America''s small businesses. Entrepreneurs can use this gateway to federal, state and local information in order to quickly define their problems and find solutions on topics ranging from federal advertising laws to local zoning codes. In addition to self-help articles, interactive guides, and the ability to complete transactions on line such as applying for a Federal EIN, the site also connects users with sources of in-person help from government officials, attorneys and business counselors in their local area.', 'http://www.business.gov/', 'http://www.business.gov:80/appmanager/bg/main?_nfpb=true&_windowLabel=T209963971174660224846&_urlType=action&_pageLabel=bg_page_home&siteId=&view=search=fromSearchBox=1&numHitsPerPage=10&query={$formKeywords}', NULL, 7),
(2070, 401, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(2069, 401, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/engine/search/query.pl?action=FilterSearch&filter=europaflt.hts&Collection=fullEUROPA&ResultTemplate=europarslt_ascii.hts&ResultCount=25&ResultMaxDocs=200&DefaultLG=en&ViewTemplate=europaview.hts&QueryText={$formKeywords}', NULL, 5),
(2067, 401, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/searchresults.asp?formname=frmAdvanced&keywordstype=1&month=&year=&pub=1&news=1&links=1&allsubjects=1&alldepts=1&alldoctypes=1&keywords={$formKeywords}', NULL, 3),
(2068, 401, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2065, 401, 'Government of Canada Publicatons', 'The Government of Canada Publications Web site provides a single window access to free and priced publications authored by Government of Canada departments. The database does not have every publication published from all departments. It does however, have over 100,000 publications listed and this number is increasing on a daily basis as this site continues to collaborate with author departments.', 'http://www.canada.gc.ca/main_e.html', 'http://publications.gc.ca/control/quickPublicSearch?searchAction=2&termValue={$formKeywords}', NULL, 1),
(2066, 401, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(2064, 401, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2063, 400, 'TechCalendar', 'TechCalendar is a searchable/browseable event directory, with categories such as: Internet/Online, Communications, Software & Services, Vertical Markets, Computing Platforms, and Computing Industry.', 'http://www.techweb.com/calendar/', 'http://www.tsnn.com/partner/results/results_techweb.cfm?city=&select=-1&country=-1&classid=0&Month=-1&subject={$formKeywords}', NULL, 3),
(2062, 400, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+{$formKeywords}', NULL, 2),
(2060, 400, 'H-Net Humanities and Social Sciences Online', 'H-Net Humanities and Social Sciences Online provides information and resources for all those interested in the Humanities and Social Sciences.', 'http://www.h-net.msu.edu/', 'http://www.h-net.org/logsearch/index.cgi?type=keyword&order=relevance&list=All+lists&hitlimit=25&smonth=00&syear=1989&emonth=11&eyear=2004&phrase={$formKeywords}', NULL, 0),
(2061, 400, 'Intute: Social Sciences - Conferences and Events', 'Intute: Social Sciences - Conferences and Events provides search of conferences and events for social sciences.', 'http://www.intute.ac.uk/socialsciences/conferences.html', 'http://www.intute.ac.uk/socialsciences/cgi-bin/conferences.pl?type=All+events&subject=All%7CAll+subjects&submit.x=0&submit.y=0&submit=Go&term={$formKeywords}', NULL, 1),
(2058, 399, 'TaxLinks', 'A link and data aggregator focusing on tax payers and tax professionals. Its strength lies in its free databases of IRS Revenue Rulings since 1960 and Revenue Procedures since 1995. TaxLinks links up with tax sites above. Again, the content of the databases may not be totally complete, but they''re free and easily accessible from the home page.', 'http://www.taxlinks.com/', 'http://www.taxlinks.com/_vti_bin/shtml.dll/search.htm', 'VTI-GROUP=0&search={$formKeywords}', 6),
(2059, 399, 'Hoover''s Online! Company Info', 'Databases of information on tens of thousands of the largest or fastest-growing public and private U.S. companies. Information provided includes company address, number of employees, key people, financial data, news items and selected Web links to company Web site, SEC filings, and current stock prices. Some information is fee-based, but quite a bit of content is still freely available.', 'http://www.hoovers.com/free/?abforward=true', 'http://www.hoovers.com/free/search/simple/xmillion/index.xhtml?page=1&which=company&query_string={$formKeywords}', NULL, 7),
(2057, 399, 'Bond Markets Online', 'Bond Market Association, association for bond market professionals, provides information and education resources for bond market professionals that underwrite, trade and sell debt securities. Includes policy issues, advocacy, news, research and statistics for bond professionals and investors.', 'http://www.bondmarkets.com/', 'http://www.bondmarkets.com/search/search.pl?nocpp=1&Match=1&Realm=bondmarkets&sort-method=1&Terms={$formKeywords}', NULL, 5),
(2056, 399, 'Global Edge', 'International business information include Country Insights'' information on all countries, along with extensive links to research resources.', 'http://globaledge.msu.edu/ibrd/ibrd.asp', 'http://globaledge.msu.edu/ibrd/busresmain.asp?search=1&SearchTerms={$formKeywords}', NULL, 4),
(2055, 399, 'BPubs.com', 'Business Publications Search Engine', 'http://www.bpubs.com/', 'http://www.bpubs.com/cgi/search.cgi?bool=or&query={$formKeywords}', NULL, 3),
(2054, 399, 'Microsoft Investor', 'Microsoft''s investor information page -- free. Has links to information on all of the companies that it covers.', 'http://moneycentral.msn.com/investor/home.asp', 'http://moneycentral.msn.com/money.search?q={$formKeywords}', NULL, 2),
(2053, 399, 'ThomasRegister', '"Free access to: over 168,000 companies; 68,000 product and service categories; thousands of online suppliers catalogs and web site links; over 2 million line items available for secvure online ordering; and, over 1 million downloadable CAD drawings."', 'http://www.thomasregister.com/', 'http://www.thomasnet.com/prodsearch.html?cov=NA&which=prod&navsec=search&what={$formKeywords}', NULL, 1),
(2052, 399, 'Free EDGAR database of corporate information', 'EDGAR, the Electronic Data Gathering, Analysis, and Retrieval system, performs automated collection, validation, indexing, acceptance, and forwarding of submissions by companies and others who are required by law to file forms with the U.S. Securities and Exchange Commission (SEC).', 'http://sec.freeedgar.com/', 'http://sec.freeedgar.com/resultsCompanies.asp?searchfrom=new&searchtype=name&x=27&y=3&searchvalue={$formKeywords}', NULL, 0),
(2051, 398, 'Business Finance Magazine', 'Trade magazine for finance executives. Subject areas include Budgeting & Reporting; Cost Management; Performance Management; Risk Management; E-Business; Technology & Software; more. Also includes full article archives; Webcasts; Salary Central; an events & vendor directory; Web links; Research Reports; e-Newsletters. Visitors can participate in a regularly updated slate of research projects.', 'http://www.businessfinancemag.com/', 'http://www.businessfinancemag.com/site/search/search.cfm?site=BF&qs={$formKeywords}', NULL, 5),
(2050, 398, 'Inc.com', 'Inc.com, the website for Inc. magazine, delivers advice, tools, and services, to help business owners and CEOs start, run, and grow their businesses more successfully.  Inc. magazine archives date back to 1988 and are fully searchable. Site also features products, services, and online tools for virtually every business or management task.', 'http://www.inc.com/home/', 'http://www.inc.com/cgi-bin/finder.cgi?query={$formKeywords}', NULL, 4),
(2049, 398, 'The McKinsey Quarterly', 'The McKinsey Quarterly, a unique print and online publication published by McKinsey & Company, the leading global management consultancy, has long been a trusted source of strategic thinking, industry scenarios, and real-world market analysis.', 'http://www.mckinseyquarterly.com/home.aspx', 'http://www.mckinseyquarterly.com/search_result.aspx', 'search_query={$formKeywords}', 3),
(2048, 398, 'Fortune', 'Fortune magazine''s Web site offers the full text of the print publication back to September 1995, plus links to special features like the Fortune 500, Best Cities for Business, Investor''s Guide, and others.', 'http://www.fortune.com/fortune/', 'http://search.money.cnn.com/pages/search.jsp?Coll=moneymag_xml&QuerySubmit=true&Page=1&LastQuery=&magazine=fort&QueryText={$formKeywords}', NULL, 2),
(2047, 398, 'businesswire.com', 'Offers company press releases, searchable by company name, industry, region, or keyword/concept. Each company''s releases are broken down by topic, i.e., earnings, management changes, mergers/acquisitions, products, etc.', 'http://www.businesswire.com/', 'http://home.businesswire.com/portal/site/home/?epi_menuItemID=e23d7f2be635f4725e0fa455c6908a0c&epi_menuID=887566059a3aedb6efaaa9e27a808a0c&epi_baseMenuID=384979e8cc48c441ef0130f5c6908a0c&searchHereRadio=false&ndmHsc=v2*A0*J2*L1*N-1002313*Z{$formKeywords}', NULL, 1),
(2035, 394, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 5),
(2036, 395, 'The Corporate Library', 'The Corporate Library is intended to serve as a central repository for research, study and critical thinking about the nature of the modern global corporation, with a special focus on corporate governance and the relationship between company management, their boards and their shareowners. Use this site to retrieve biographies for the companies in the S&P 1500 Supercomposite Index. Screen on a variety of features to identify matching directors (e.g. company name, age, attendance problems, # shares held, etc.) The site also contains research reports on trends in corporate governance.', 'http://www.thecorporatelibrary.com/', 'http://thecorporatelibrary.master.com/texis/master/search/?s=SS&q={$formKeywords}', NULL, 0),
(2037, 395, 'Find articles', 'Provides citations, abstracts and fulltext articles for over 300 magazines and journals on topics such as business, health, society, entertainment and sports.', 'http://www.findarticles.com/PI/index.jhtml', 'http://www.findarticles.com/cf_0/PI/search.jhtml?magR=all+magazines&key={$formKeywords}', NULL, 1),
(2038, 395, 'Intute: Social Sciences', 'Intute: Social Sciences is  a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 2),
(2039, 396, 'Brint.com', 'Extensive information portal with news, analysis and links related to business, commerce, economics, information technology, and information resources.', 'http://www.brint.com/', 'http://portal.brint.com/cgi-bin/cgsearch/cgsearch.cgi?query={$formKeywords}', NULL, 0),
(2040, 396, 'SMEALSearch', 'SMEALSearch is a publicly available vertical digital library and search engine hosted at Penn State''s Smeal College of Business that focuses on academic business documents. SmealSearch crawls the web and harvests, catalogs, and indexes academic business documents. It is based on the computer and information science engine, CiteSeer, initially developed at NEC Research Institute by Kurt Bollacker, Lee Giles and Steve Lawrence. The search engine crawls websites of academia, commerce, research institutes, government agencies, etc. for academic business documents, including published articles, working papers, white papers, consulting reports, etc. For certain documents, SmealSearch only indexes and stores the hyperlinks to those documents. SMEALSearch generates a citation analysis for all the academic articles harvested and ranks them in order of their citation rates (the most cited articles are listed first) similar to the ranking of CiteSeer and the Google Scholar.', 'http://130.203.133.125/SMEALSearchAbout.html', 'http://130.203.133.125/cs?submit=Search+Documents&q={$formKeywords}', NULL, 1),
(2041, 396, 'Roubini Global Economics (RGE) Montor', 'Includes daily economic analysis for individual countries, and information on emerging markets, financial markets, banking, and other topics. Contains original content and links to government and news sources. Searchable.', 'http://www.rgemonitor.com/', 'http://www.rgemonitor.com/?option=com_content&task=search&kwd={$formKeywords}', NULL, 2),
(2042, 397, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2043, 397, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&f00=text&p01=&f01=subject&d=journal&l=en&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&frm=adv.x&p00={$formKeywords}', NULL, 1),
(2044, 397, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2045, 397, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(2046, 398, 'Business Week', 'Business Week''s Web site provides the full text of the current issue, plus selected articles from earlier editions. There is also a searchable archive covering three years of articles from the print magazine, although charges apply for retrieving the full articles. Other features include updated news in the Daily Briefing section and BW Plus!, offering archive articles and other content on such topics as the computer industry, women in business, and business book reviews.', 'http://www.businessweek.com/', 'http://search.businessweek.com/search97cgi/s97_cgi?action=FilterSearch&ServerKey=Primary&filter=bwfilt.hts&command=GetMenu&ResultMaxDocs=500&ResultCount=25&resulttemplate=bwarchiv.hts&querytext={$formKeywords}', NULL, 0),
(2452, 469, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 7);
INSERT INTO `rt_searches` (`search_id`, `context_id`, `title`, `description`, `url`, `search_url`, `search_post`, `seq`) VALUES
(2451, 469, 'EH.Net Encyclopedia of Economic and Business History', 'Directed by a distinguished board, articles in this encyclopedia on both business and economic history "are written by experts, screened by a group of authorities, and carefully edited."', 'http://eh.net/encyclopedia/', 'http://eh.net/encyclopedia/search/?Search.x=37&Search.y=10& q={$formKeywords}', NULL, 6),
(2449, 469, 'AmosWeb GLOSS*arama', 'The AmosWEB GLOSS*arama, a glossary for principles students, is a searchable database of 1800 economic terms and concepts.', 'http://amosweb.com/gls/', 'http://amosweb.com/cgi-bin/gls.pl?fcd=dsp&key={$formKeywords}', NULL, 4),
(2450, 469, 'Concise Encyclopedia of Economics (CEE)', 'Concise Encyclopedia of Economics (CEE) - tutorials on various economic topics', 'http://www.econlib.org/library/CEE.html', 'http://www.econlib.org/cgi-bin/search.pl?results=0&book=Encyclopedia&andor=and&sensitive=no&query={$formKeywords}', NULL, 5),
(2448, 469, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 3),
(2445, 469, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2446, 469, 'Online Glossary of Research Economics', 'An online glossary of terms in research economics.', 'http://econterms.com/', 'http://econterms.com/glossary.cgi?query={$formKeywords}', NULL, 1),
(2447, 469, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 2),
(2444, 468, 'NBER', 'NBER (The National Bureau of Economic Research, Inc) is a private, nonprofit, nonpartisan research organization dedicated to promoting a greater understanding of how the economy works. Nearly 500 NBER Working papers are published each year, and many subsequently appear in scholarly journals.', 'http://papers.nber.org/', 'http://papers.nber.org/papers?module=search&action=query&default_conjunction=and&keywords={$formKeywords}', NULL, 7),
(2443, 468, 'World Bank Group Documents & Reports', 'The World Bank Group makes more than 14,000 documents available through the Documents & Reports website. Documents include Project appraisal reports, Economic and Sector Works, Evaluation reports and studies and working papers.', 'http://www-wds.worldbank.org/', 'http://www-wds.worldbank.org/servlet/WDS_IBank_Servlet?all=&stype=AllWords&dname=&rc=&ss=&dt=&dr=range&bdt=&edt=&rno=&lno=&cno=&pid=&tno=&sortby=D&sortcat=D&psz=20&x=34&y=8&ptype=advSrch&pcont=results&auth={$formKeywords}', NULL, 6),
(2442, 468, 'IDEAc', 'IDEA: the complete RePEc database at your disposal. Working papers, journal articles, software components, author information, directory of institutions.', 'http://ideas.repec.org/', 'http://ideas.repec.org/cgi-bin/htsearch?restrict=http://ideas.repec.org/p/&config=htdig&restrict=&exclude=&sort=score&format=long&method=and&search_algorithm=exact:1&words={$formKeywords}', NULL, 5),
(2441, 468, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 4),
(2439, 468, 'Intute: Repository Search', 'Use this service to find descriptions from over 152,000 working papers, journal articles, reports, conference papers, and other scholarly items that have been deposited into UK eprints repositories. Search results will link to original items where these have been made available by the originating institution.', 'http://irs.ukoln.ac.uk/', 'http://irs.ukoln.ac.uk/search/?view=&submit.x=0&submit.y=0&submit=Go&query={$formKeywords}', NULL, 2),
(2440, 468, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 3),
(2438, 468, 'Intute: Social Sciences', 'Intute is a free online service providing you with access to the very best Web resources for education and research, evaluated and selected by a network of subject specialists.', 'http://www.intute.ac.uk/socialsciences//', 'http://www.intute.ac.uk/socialsciences/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=socialsciences&term1={$formKeywords}', NULL, 1),
(2437, 468, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=eng&as_sauthors={$formKeywords}', NULL, 0),
(2436, 467, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3),
(2435, 467, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2433, 467, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2434, 467, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2431, 466, 'Science News Online', 'Science News Online is one of the most useful science news magazines available online. The 75 year old weekly is putting a generous number of full-text articles on the Web each week, adding to a collection of articles archived from 1994 to the present.', 'http://www.sciencenews.org/', 'http://www.sciencenews.org/pages/search_results.asp?search={$formKeywords}', NULL, 3),
(2432, 466, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 4),
(2430, 466, 'Nature Science Update', 'Nature Science Update provides daily news stories written by the editors of the Nature Journal.', 'http://www.nature.com/nsu/', 'http://search.nature.com/search/?sp-x-9=cat&sp-q-9=NEWS&submit=go&sp-a=sp1001702d&sp-sfvl-field=subject%7Cujournal&sp-t=results&sp-x-1=ujournal&sp-p-1=phrase&sp-p=all&sp-q={$formKeywords}', NULL, 2),
(2429, 466, 'Daily Science News from NewScientist', 'Daily Science News from NewScientist provides science news updated throughout the day.', 'http://www.newscientist.com/news/', 'http://www.newscientist.com/search.ns?doSearch=true&query={$formKeywords}', NULL, 1),
(2426, 465, 'FirstGov', 'FirstGov (U.S. federal and state) is a public-private partnership, led by a cross-agency board.', 'http://www.firstgov.gov/', 'http://www.firstgov.gov/fgsearch/index.jsp?db=www&st=AS&ms0=should&mt0=all&rn=2&parsed=true&x=2&y=8&mw0={$formKeywords}', NULL, 7),
(2427, 465, 'Canada Sites', 'Canada Sites provides an information and services gateway run by the Government of Canada and each of the provinces.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple.html&enc=iso88591&pg=q&kl=en&site=main&q={$formKeywords}', NULL, 8),
(2428, 466, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2425, 465, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(2424, 465, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(2423, 465, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2422, 465, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(2421, 465, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(2420, 465, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as \n\nprovincial, territorial and municipal governments. There is a Departments and Agencies link, and \n\nthe A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which \n\noutlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian \n\nGovernment, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together \n\ninformation from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(2419, 465, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2418, 464, 'Science, Mathematics, Engineering and Technology Education (SMETE)', 'Science, Mathematics, Engineering and Technology Education (SMETE) contains a searchable working prototype of a National Science, Mathematics, Engineering, and Technology Education Digital Library.', 'http://www.smete.org/', 'http://www.smete.org/smete/?path=/public/find/search_results.jhtml&_DARGS=/smete/public/find/index_body.jhtml&/smete/forms/FindLearningObjects.operation=search&_D:/smete/forms/FindLearningObjects.operation=%20&_D:/smete/forms/FindLearningObjects.keyword=%20&/smete/forms/FindLearningObjects.learningResourceType=&_D:/smete/forms/FindLearningObjects.learningResourceType=%20&/smete/forms/FindLearningObjects.grade=0-Any&_D:/smete/forms/FindLearningObjects.grade=%20&/smete/forms/FindLearningObjects.title=&_D:/smete/forms/FindLearningObjects.title=%20&/smete/forms/FindLearningObjects.author=&_D:/smete/forms/FindLearningObjects.author=%20&/smete/forms/FindLearningObjects.hostCollection=&_D:/smete/forms/FindLearningObjects.hostCollection=%20&/smete/forms/FindLearningObjects.afterYear=&_D:/smete/forms/FindLearningObjects.afterYear=%20&/smete/forms/FindLearningObjects.beforeYear=&_D:/smete/forms/FindLearningObjects.beforeYear=%20&&/smete/forms/FindLearningObjects.keyword={$formKeywords}', NULL, 2),
(2417, 464, 'Science Learning Network', 'Science Learning Network is a community of educators, students, schools, science museums, and other institutions demonstrating a new model for inquiry into. Contains a variety of inquiry-posed problems, information, demonstrations, and labs.', 'http://www.sln.org/', 'http://192.231.162.154:8080/query.html?col=first&ht=0&qp=&qs=&qc=&pw=600&ws=1&la=&qm=0&st=1&nh=25&lk=1&rf=0&oq=&rq=0&si=0&qt={$formKeywords}', NULL, 1),
(2415, 463, 'All Conferences Directory', 'All Conferences Directory is a searchable database of Computer Science and Technology conferences that organizes conferences by category and offers information regarding paper submission deadlines.', 'http://all-conferences.com/Computers/', 'http://www.allconferences.com/Search/output.php?Title={$formKeywords}', NULL, 2),
(2416, 464, 'General Chemistry Online', 'An introduction that includes hyperlinked notes, guides,\nand articles for first semester chemistry. There is a glossary, FAQs and a\ntrivia quiz. The Toolbox provides interactive graphing, a pop-up periodic table,\nand calculators. Additionally, Tutorials contains self-guided tutorials,\nquizzes, and drills on specific topics. There is one database of 800 common\ncompound names, formulas, structures, and properties, and another for over 400\nannotated Web sites. From a chemistry professor at Frostburg State University,\nMaryland. Searchable.', 'http://antoine.frostburg.edu/chem/senese/101/', 'http://marie.frostburg.edu/cgi-bin/htsearch?method=and&config=htdig&restrict=101&exclude=print-&format=builtin-long&sort=score&words={$formKeywords}', NULL, 0),
(2414, 463, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com+mind+', NULL, 1),
(2413, 463, 'chemistry.org Meeting Locator', 'chemistry.org’s Meeting Locator will allow you to find details about meetings, workshops, short courses, and symposia of interest to practitioners of the chemical-related sciences.', 'http://acswebapplications.acs.org/applications/meetinglocator/home.cfm', 'http://google.acs.org/search?site=americanchemical&client=americanchemical&proxystylesheet=americanchemical&output=xml_no_dtd&q=meetings+{$formKeywords}', NULL, 0),
(2412, 462, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 4),
(2411, 462, 'TheScientificWorld', 'TheScientificWorld offers sciBASE to give free access to a collection of databases of scientific, technical and medical research literature. sciBASE now also features immediate digital delivery of full text articles from over 700 journals produced by participating publishers, and sciBASE is particularly effective for users who do not have library support (non-mediated environments).', 'http://www.thescientificworld.com/', 'http://www.thescientificworld.com/SCIENTIFICWORLDJOURNAL/search/SearchResults.asp?From=Main&Terms={$formKeywords}', NULL, 3),
(2410, 462, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is ranging from 19.05 per month to 119.95 per year.', 'http://www.questia.com/', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2504, 481, 'OAIster (Open Archives Initiative research databases)', 'OAIster is a project of the University of Michigan Digital Library Production Services, and provides searching a wide variety of collections from a wide variety of institutions. These institutions have made the records of their digital resources available to access, and the project team has gathered and aggregated them into the OAIster service.', 'http://oaister.umdl.umich.edu/', 'http://oaister.umdl.umich.edu/cgi/b/bib/bib-idx?type=boolean&size=10&c=oaister&q1=&rgn1=entire+record&op2=and&q2=&rgn2=entire+record&op3=And&q3=&rgn3=title&op4=And&rgn4=author&op5=And&q5=&rgn5=subject&op6=And&rgn6=norm&q6=all+types&sort=author%2Fcreator&submit2=search&q4={$formKeywords}', NULL, 1),
(2505, 481, 'Public Knowledge Project Open Archives Harvester', 'The PKP Open Archives Harvester is a free metadata indexing system developed by the Public Knowledge Project through its federally funded efforts to expand and improve access to research. The PKP OAI Harvester allows you to create a searchable index of the metadata from Open Archives Initiative-compliant archives, such as sites using Open Journal Systems or Open Conference Systems.', 'http://pkp.sfu.ca/harvester/', 'http://pkp.sfu.ca/harvester/search.php?limit=author&query={$formKeywords}', NULL, 2),
(2506, 481, 'SPIRO (Architecture Slide Library, University of California - Berkeley)', 'SPIRO (slide & photograph image retrieval online) provides access to images and descriptive information about 20% of the Library''s collection of 200,000 35mm slides.', 'http://www.mip.berkeley.edu/query_forms/browse_spiro_form.html', 'http://www.mip.berkeley.edu/cgi-bin/browse_spiro_new/tmp?db_handle=browse_spiro&object=&place=&aat_term=&aat_term2=&source=&image_id=&kw=&from_date=&period=any&result_type=thumbnail_with_descr&name={$formKeywords}', NULL, 3),
(2507, 481, 'GreatBuildings.com', 'This gateway to architecture around the world and across history documents a thousand buildings and hundreds of leading architects, with 3D models, photographic images and architectural drawings, commentaries, bibliographies, web links, and more, for famous designers and structures of all kinds.', 'http://www.greatbuildings.com/search.html', 'http://www.greatbuildings.com/cgi-bin/gbc-search.cgi?search=architect&architect={$formKeywords}', NULL, 4),
(2508, 481, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 5),
(2509, 482, 'Google', 'Search for definitions using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?hl=en&q=define%3A{$formKeywords}', NULL, 0),
(2510, 482, 'Columbia Encyclopedia', 'Serving as a "first aid" for those who read, the sixth edition of the Columbia Encyclopedia contains over 51,000 entries with 80,000 hypertext links.', 'http://www.bartleby.com/65/', 'http://www.bartleby.com/cgi-bin/texis/webinator/65search?search_type=full&query={$formKeywords}', NULL, 1),
(2511, 482, 'WordWeb Online', 'WordWeb is an international dictionary and word finder with more than 280 000 possible lookup words and phrases. It is also available as Windows software.\n\nWordWeb fully covers American, British, Australian, Canadian and Asian English spellings and words.', 'http://www.wordwebonline.com/', 'http://www.wordwebonline.com/search.pl?w={$formKeywords}', NULL, 2),
(2512, 482, 'Merriam-Webster Online', 'A dictionary based on the Webster 10th Collegiate edition, 1993, with updates added annually. More than 160,000 entries. Each word is accompanied by definition, pronunciation, usage, grammatical function, and a brief etymology. Includes a thesaurus. Misspellings return suggested spellings. The dictionary''s search system supports internal wildcards and right hand truncation searching. Includes an extensive pronunciation guide and sound files for the pronunciation of many terms.', 'http://www.merriam-webster.com/', 'http://www.merriam-webster.com/cgi-bin/dictionary?book=Dictionary&va={$formKeywords}', NULL, 3),
(2513, 482, 'OneLook Dictionaries', 'OneLook is a meta-dictionary. Enter an English language word or acronym, and OneLook will search its index of 5,292,362 words in 934 dictionaries indexed in general and special interest dictionaries for the definition.', 'http://www.onelook.com/index.html', 'http://www.onelook.com/?ls=a&w={$formKeywords}', NULL, 4),
(2514, 482, 'Wikipedia: The Free Encyclopedia', '"Wikipedia is a free content encyclopedia that is being written collaboratively by contributors from all around the world. The site is a WikiWiki, meaning that anyone ... can edit any article. ..." Without editorial oversight, the quality of the content on this site varies dramatically, but it is worth exploring. The English version has hundreds of thousands of entries. Spanish, French, and Esperanto are among the several other languages offered.', 'http://en.wikipedia.org/wiki/Main_Page', 'http://en.wikipedia.org/wiki/Special:Search?go=Go&fulltext=Search&search={$formKeywords}', NULL, 5),
(2515, 482, 'Infoplease.com', 'This site includes contents of the Information Please Almanacs, a biography database, a dictionary, an atlas, and articles from the Columbia Encyclopedia. You can search these ready reference works together or separately or browse the Almanacs. There are feature stories each week covering topics in the news, with links to pertinent Almanac content and other Web resources.', 'http://www.infoplease.com', 'http://www.infoplease.com/search?fr=iptn&in=all&x=0&y=0&query={$formKeywords}', NULL, 6),
(2516, 483, 'SPIRO (Architecture Slide Library, University of California - Berkeley)', 'SPIRO (slide & photograph image retrieval online) provides access to images and descriptive information about 20% of the Library''s collection of 200,000 35mm slides.', 'http://www.mip.berkeley.edu/query_forms/browse_spiro_form.html', 'http://www.mip.berkeley.edu/cgi-bin/browse_spiro_new/tmp?db_handle=browse_spiro&object=&place=&aat_term=&aat_term2=&source=&image_id=&from_date=&period=any&result_type=thumbnail_with_descr&name=&kw={$formKeywords}', NULL, 0),
(2517, 483, 'Intute: Arts & Humanities', 'Intute: Arts & Humanities is a free online service providing you with access to the best Web resources for education and research, selected and evaluated by a network of subject specialists. There are over 18,000 Web resources listed here that are freely available by keyword searching and browsing.', 'http://www.intute.ac.uk/artsandhumanities/ejournals.html', 'http://www.intute.ac.uk/artsandhumanities/cgi-bin/search.pl?submit.x=0&submit.y=0&submit=Go&limit=0&subject=artsandhumanities&term1={$formKeywords}', NULL, 1),
(2518, 483, 'GreatBuildings.com', 'This gateway to architecture around the world and across history documents a thousand buildings and hundreds of leading architects, with 3D models, photographic images and architectural drawings, commentaries, bibliographies, web links, and more, for famous designers and structures of all kinds.', 'http://www.greatbuildings.com/search.html', 'http://www.greatbuildings.com/cgi-bin/gbc-search.cgi?search=building&building={$formKeywords}', NULL, 2),
(2519, 484, 'Access to Australian Government Information and Services', 'The Australian Government Entry Point offers comprehensive and integrated access to Australian Government information and services.  You will find a concentrated body of Australian Government information through this site. <a href="http://www.australia.gov.au">www.australia.gov.au</a> currently signposts over 700 Australian Government web sites, indexes more than 5,000,000 pages and uses both metadata and full text indexing to ensure it is a comprehensive government portal.', 'http://www.fed.gov.au', 'http://govsearch.australia.gov.au/search/search.cgi?collection=gov&form=au&query=&query_phrase=&query_or=&query_not=&meta_f_sand=&scope=&fscope=512&num_ranks=20&chksummary=chksummary&query_and={$formKeywords}', NULL, 0),
(2520, 484, 'The Government of Canada', 'You can search across all government departments federal departments and agencies as well as provincial, territorial and municipal governments. There is a Departments and Agencies link, and the A to Z Index offers a keyword search to programmes and services. \n\nA recent development on Departmental sites is the inclusion of a "Proactive Disclosure" page, which outlines travel and hospitality expenses, disclosure of contracts, grants and awards. \n\nThe About Canada page includes links to Departments and Agencies, Structure of the Canadian Government, Commissions of Inquiry and more. \n\nIn addition to Department web sites, the government has been creating Portals which bring together information from across federal and provincial sources, and non-governmental organizations as well.', 'http://www.canada.gc.ca/main_e.html', 'http://search-recherche.gc.ca/cgi-bin/query?mss=canada%2Fen%2Fsimple&pg=q&enc=iso88591&site=main&bridge=&stt=&lowercaseq=&what=web&user=searchintranet&browser=N6E&kl=XX&op=a&q={$formKeywords}', NULL, 1),
(2521, 484, 'Directgov', 'Directgov is a government service giving people access to the latest and widest range of public service information in one place on the Web and on Digital TV. Directgov uses the specifications formulated and consulted on through UK GovTalk.', 'http://www.direct.gov.uk', 'http://www.direct.gov.uk/AdvancedSearch/SearchResults/fs/en?NP=1&PO1=C&PI1=W&PF1=A&PG=1&RP=20&SC=__dgov_site&Z=1&PT1={$formKeywords}', NULL, 2),
(2522, 484, 'Info4local.gov.uk', 'Information for local government from central government.  This site gives local authorities a quick and easy way to find relevant information on the web sites of central government departments, agencies and public bodies. It includes extensive information on implementing electronic government.', 'http://www.info4local.gov.uk', 'http://www.info4local.gov.uk/?view=Search+results&subjects=all&departmentsIds=0&informationTypesIds=all&query={$formKeywords}', NULL, 3),
(2523, 484, 'The New Zealand government portal', 'The New Zealand government portal is a website providing search capability for, and links into the online and offline information and services of most government agencies.  This site is managed and maintained by the State Services Commission, a New Zealand government department.', 'http://www.govt.nz', 'http://www.govt.nz/search?type=spider&t=spider&q={$formKeywords}', NULL, 4),
(2524, 484, 'Europa', 'Current information on the member countries of the European Union, including statistical data, policies, news, official documents, legal texts, and other publications.', 'http://europa.eu.int/index_en.htm', 'http://europa.eu.int/geninfo/query/resultaction.jsp?page=1', 'Collection=EuropaFull&ResultTemplate=/result_en.jsp&ResultCount=25&qtype=simple&ResultMaxDocs=200&DefaultLG=en&QueryText={$formKeywords}', 5),
(2525, 484, 'The Global Legal Information Network (GLIN)', 'The Global Legal Information Network (GLIN) is a database of laws, regulations, judicial decisions, and other complementary legal sources contributed by governmental agencies and international organizations. These GLIN members contribute the official full texts of published documents to the database in their original language. Each document is accompanied by a summary in English and subject terms selected from the multilingual index to GLIN.', 'http://www.glin.gov', 'http://www.glin.gov/search.do?refineQuery=&offset=0&refineQueryType=&fromSearch=true&queryType=ALL&searchBtn=Search&includeAllFields=on&searchAll=on&sumLanguage=any&pubLanguage=any&pubJurisdiction=any&publicationJurisdictionExclude=false&searchPublicationDate=true&dateFromDay=01&dateFromMonth=01&dateFromYear=&dateToDay=01&dateToMonth=01&dateToYear=&subjTerm=&subjTermConjunction%5B0%5D=AND&subjTerm=&subjTermConjunction%5B1%5D=AND&subjTerm=&subjTermConjunction%5B2%5D=AND&subjTerm=&subjTermConjunction%5B3%5D=AND&subjTerm=&searchOrder=default&hitsPerPage=10&showSummary=on&queryString={$formKeywords}', NULL, 6),
(2526, 485, 'Google Print', 'Google is working with libraries at the University of Michigan, Harvard University, Stanford University, Oxford University and the New York Public Library to digitize books in their collections and make them accessible via Google Print, a massive scanning project that will bring millions of volumes of printed books into the Google Print database.  Click a book title and you''ll see the page of the book that has your search terms, your can search for more information within that specific book, find reviews, find related information, learn about the publisher, buy this book, and find nearby libraries that have it.', 'http://print.google.com', 'http://print.google.com/print?q={$formKeywords}', NULL, 0),
(2527, 485, 'Online books Page', 'Online books Page, edited by John Mark Ockerbloom, at the University of Pennsylvania.  This is an excellent starting point in the search for full-text books on the Internet. Over 20,000 English works in various formats available online at different sites. Entries may be searched by author or title. An interesting feature allows browsing by Library of Congress call number categories. New listings are added regularly and are listed on a separate web page at <a href="http://onlinebooks.library.upenn.edu/new.html">http://onlinebooks.library.upenn.edu/new.html</a>.', 'http://digital.library.upenn.edu/books/', 'http://onlinebooks.library.upenn.edu/webbin/book/search?tmode=words&title={$formKeywords}', NULL, 1),
(2528, 485, 'Books-On-Line', 'A collection of over 32935 titles, although some are only excerpts. Browse by subject or search by author or title. Not all items are free.', 'http://www.books-on-line.com/', 'http://www.books-on-line.com/bol/KeyWordSearch.cfm?RowCount=50&Searchquery={$formKeywords}', NULL, 2),
(2529, 485, 'Universal Library', 'The Universal Library is considerably more involved, and more ambitious -- it has amassed a collection of 100,000 e-books (some of them from Project Gutenberg), and is aiming for 1 million e-books by the end of 2006.', 'http://tera-3.ul.cs.cmu.edu/', 'http://tera-3.ul.cs.cmu.edu/cgi-bin/DBscripts/advsearch_db.cgi?perPage=25&listStart=0&author1=&subject1=Any&year1=&year2=&language1=Any&scentre=Any&search=Search&title1={$formKeywords}', NULL, 3),
(2530, 486, 'Networked Digital Library of Theses and Dissertations Union Catalog', 'This Union Catalog serves as a repository of rich graduate educational material contributed by a number of member institutions worldwide.  This project is a joint development with NDLTD and VTLS Inc.  It is hoped that this project will increase the availability of student research for scholars, empowere students to convey a richer message through the use of multimedia and hypermedia technologies and advance digital library technology worldwide.', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon', 'http://zippo.vtls.com/cgi-bin/ndltd/chameleon?sessionid=2006051219043826835&skin=ndltd&submittheform=Search&usersrch=1&beginsrch=1&elementcount=3&function=INITREQ&search=SCAN&lng=en&pos=1&conf=.%2Fchameleon.conf&u1=4&host=localhost%2B3668%2BDEFAULT&t1={$formKeywords}', NULL, 0),
(2531, 486, 'CRL Foreign Doctoral Dissertation Databases', 'The CRL''s (Center For Research Libraries) database for dissertations published outside of the United States and Canada is still in the construction phase.  At this point, a total of 15,000 of 750,000 records are loaded into the database.  Searchable by author, institution name, title, year, translated title, subject keywords, language, and country, the database also provides instructions for interlibrary loan procedure.', 'http://www.crl.edu/default.asp', 'http://www.crl.edu/DBSearch/catalogSearchNew.asp?sort=R&req_type=X&search={$formKeywords}', NULL, 1),
(2532, 486, 'Scirus ETD Search', 'NDLTD offers a search service provided by Scirus, which is based on data harvested from the Union Archive hosted by OCLC.', 'http://www.ndltd.org/info/description.en.html', 'http://www.scirus.com/srsapp/search?rep=ndl&q={$formKeywords}', NULL, 2),
(2533, 486, 'Dissertation.com', 'Academic publishers of masters theses and doctoral PhD dissertations. Search 1000s of dissertation abstracts in dissertation database.', 'http://dissertation.com/', 'http://dissertation.com/browse.php?criteria=all&submit.x=23&submit.y=5&keyword={$formKeywords}', NULL, 3),
(2534, 487, 'The Art, Design, Architecture & Media Information Gateway (ADAM)', 'ADAM is being developed to provide a gateway to information about fine art, design, architecture, applied arts, media, theory, museum studies and conservation and professional practice related to any of the above. It is one of the eLib Access to Network Resources (ANR) projects and received its funding from JISC. A user survey to measure information needs and search methods, annual reports, and service usage statistics are published at the site.', 'http://www.adam.ac.uk/index.html', 'http://www.adam.ac.uk/ixbin/hixserv?_IXDB_=adam&%7BUPPER%7D%24%3Fany%3A+IX_MODE+rel%3D1+%28%24any%29+INDEX+res_keywords=.&%24+with+res_pub=.&%24sort+@descending+%24%24relevance=.&%24%3F%21x%3A%28%28collection+or+item%29+in+res_granularity%29=.&_IXSPFX_=s&submit-button=SUMMARY&%24%3Dany%3D%24={$formKeywords}', NULL, 0),
(2535, 487, 'Akropolis.net', 'The premier architecture resource on the Internet, including Architects, Interior Designers, Landscapers, employment, free web sites, free portfolios, search engine, and more.', 'http://www.akropolis.net/', 'http://www.akropolis.net/search/index.ahtml?referredby=home&action=SEARCH&words={$formKeywords}', NULL, 1),
(2536, 488, 'Artcyclopedia.com', 'This site has compiled a comprehensive index of every artist represented at hundreds of museum sites, image archives, and other online resources.  The site has started out by covering the biggest and best sites around, and has links for most well-known artists:  contains 1800 art sites, and offers over 60,000 links to an estimated 150,000 artworks by 8,100 renowned artists.', 'http://www.artcyclopedia.com/', 'http://www.artcyclopedia.com/scripts/tsearch.pl?type=2&t={$formKeywords}', NULL, 0),
(2537, 488, 'Union List of Artists Names', 'Contains biographical information about artists and architects, including variant names, pseudonyms, and language variants.', 'http://www.getty.edu/research/tools/vocabulary/ulan/', 'http://www.getty.edu/vow/ULANServlet?nation=&english=Y&role=&page=1&find={$formKeywords}', NULL, 1),
(2538, 489, 'MInd: the Meetings Index', 'Use this service to identify and locate the organizers and sponsors for future conferences, congresses, meetings and symposia, as well as conference proceedings (for future and past conferences).', 'http://www.interdok.com/', 'http://www.google.com/search?q=site%3Ainterdok.com/mind/+{$formKeywords}', NULL, 0),
(2539, 490, 'Ingenta', 'Ingenta restricts access to full text articles. Although access to the full text costs money, the site can be used as a free index.', 'http://www.ingenta.com/', 'http://www.ingenta.com/isis/searching/Search/ingenta?database=1&title={$formKeywords}', NULL, 0),
(2540, 490, 'ebrary', 'Independent researchers who do not have access to ebrary_ databases through their library may now set up an individual account for as little as $5. ebrary Discover spans multiple academic disciplines and provides anytime, anywhere access to over 20,000 authoritative titles including books in full-text, sheet music, reports and other authoritative documents from more than 175 leading publishers such as Cambridge University Press, Random House, Inc., and The McGraw-Hill Companies.', 'http://www.ebrary.com/corp/content.htm', 'http://shop.ebrary.com/Top?layout=search&frm=smp.x&sch=%A0%A0%A0%A0%A0Search%A0%A0%A0%A0%A0&p00={$formKeywords}', NULL, 1),
(2541, 490, 'Questia', 'Questia provides access to over 47,000 books and 375,000 journal, magazine, and newspaper articles. All books and articles are available in their entirety - search every page.  The subscription rate is raning from 19.05 per month to 119.95 per year.', 'http://www.questia.com', 'http://www.questia.com/SM.qst?act=search&keywordsSearchType=1000&mediaType=book&mediaType=journal&mediaType=magazine&mediaType=newspaper&mediaType=encyclopedia&mediaType=startpage&keywords={$formKeywords}', NULL, 2),
(2542, 490, 'Wiley InterScience Pay-per-view Service', 'Wiley InterScience Pay-per-view affords instant, full-text access to an extensive collection of journal articles or book chapters available on Wiley InterScience without the need for a subscription. This service allows anyone to purchase access to individual journal articles or book chapters directly by using a credit card. Access is instant and available for 24 hours.', 'http://www3.interscience.wiley.com/aboutus/ppv-articleselect.html', 'http://www3.interscience.wiley.com/search/allsearch', 'allContentSearchForm=&mode=quicksearch&WISindexid1=WISall&WISsearch1={$formKeywords}', 3),
(2543, 491, 'ARTSEDGE', 'ARTSEDGE supports the place of arts education at the center of the curriculum through the creative and appropriate uses of technology. ARTSEDGE helps educators to teach in, through and about the arts.', 'http://artsedge.kennedy-center.org/', 'http://artsedge.kennedy-center.org/search/search_perform.cfm?advanced=false&contentTypes=&artsSubjects=&x=31&y=9&keywords={$formKeywords}', NULL, 0),
(2544, 491, 'ArtsEdNet', 'ArtsEdNet, an online service developed by the Getty Education Institute for the Arts, supports the needs of the K-12 arts education community. It focuses on helping arts educators, general classroom teachers using the arts in their curriculum, museum educators, and university', 'http://www.getty.edu/artsednet/home.html', 'http://www.google.com/search?hl=en&btnG=Search&q=site%3Awww.getty.edu%2Feducation%2F+{$formKeywords}', NULL, 1),
(2545, 492, 'Arts Journal', 'Arts Journal is a weekday digest of some of the best arts and cultural journalism. Each day Arts Journal combs through more than 100 English-language newspapers, magazines and publications featuring writing about arts and culture. Direct links to the most interesting or important stories are posted every weekday on the Arts Journal news pages. Stories from sites that charge for access are excluded as are sites which require visitors to register, with the exception of the New York Times.', 'http://www.artsjournal.com/', 'http://www.google.com/custom?domains=artsjournal.com&sitesearch=artsjournal.com&sa=GoogleSearch&cof=LW:240;L:http://www.artsjournal.com/img/logo.gif;LH:52;AH:left;S:http://www.artsjournal.com;AWFID:edabed9eb3afda60;&q={$formKeywords}', NULL, 0),
(2546, 492, 'Aesthetics On-line', 'In Aesthetics On-line you''ll find articles about aesthetics, philosophy of art, art theory and art criticism, as well as information about aesthetics events worldwide, and links to other aesthetics-related resources on the internet, including the Aesthetics-L email discussion list.', 'http://www.aesthetics-online.org/', 'http://www.aesthetics-online.org/tech/search.cgi?context=Site&terms={$formKeywords}', NULL, 1),
(2547, 492, 'Architronic', 'Architronic is a scholarly refereed journal, exploring the new ranges of architectural communication available through digital media. It is a platform for both presenting and reviewing research as a journal, and a forum for stimulating dialogue on emerging ideas.', 'http://architronic.saed.kent.edu/', 'http://www.google.com/search?q=site:architronic.saed.kent.edu+', NULL, 2),
(2548, 493, 'Google News', 'Search news reports using the popular search engine Google''s news feature.', 'http://news.google.com/', 'http://news.google.com/news?hl=en&q={$formKeywords}', NULL, 0),
(2549, 493, 'Globe and Mail', 'Globe and Mail, Toronto (last seven days)', 'http://www.globeandmail.com/', 'http://www.globeandmail.com/servlet/HTMLTemplate/search?tf=tgam/search/tgam/SearchResults.html&cf=tgam/search/tgam/SearchResults.cfg&current_row=1&start_row=1&num_rows=10&keywords={$formKeywords}', NULL, 1),
(2550, 493, 'People''s Daily', 'People''s Daily, China (January 1999-)', 'http://english.peopledaily.com.cn/', 'http://search.people.com.cn/was40/people/GB/english_index.jsp?type=1&channel=&Content=&searchword={$formKeywords}', NULL, 2),
(2551, 493, 'Mail & Guardian Newspaper', 'Mail & Guardian Newspaper, South Africa (1994-)', 'http://www.mg.co.za/', 'http://www.mg.co.za/mg_search_results.aspx?PrintEdition=PrintEdition&DailyNews=DailyNews&SearchSection=&StartDay=&StartMonth=&StartYear=&EndDay=&EndMonth=&EndYear=&keywords={$formKeywords}', NULL, 3),
(2552, 493, 'National Public Radio', 'National Public Radio, United States (unlimited)', 'http://www.npr.org/archives/', 'http://www.npr.org/search.php?text={$formKeywords}', NULL, 4),
(2553, 493, 'New York Times', 'New York Times, New York (last seven days)', 'http://www.nytimes.com/', 'http://query.nytimes.com/search/query?date=past30days&submit.x=11&submit.y=12&query={$formKeywords}', NULL, 5),
(2554, 493, 'The Japan Times Online', 'The Japan Times Online, Japan (January 1999-)', 'http://www.japantimes.co.jp/', 'http://www.google.co.jp/custom?domains=japantimes.co.jp&client=pub-4223870936880387&forid=1&ie=Shift_JIS&oe=Shift_JIS&term1=&cof=GALT%3A%23008000%3BGL%3A1%3BDIV%3A%23336699%3BVLC%3A663399%3BAH%3Acenter%3BBGC%3AFFFFFF%3BLBGC%3AFFFFFF%3BALC%3A0000FF%3BLC%3A0000FF%3BT%3A000000%3BGFNT%3A0000FF%3BGIMP%3A0000FF%3BLH%3A60%3BLW%3A200%3BL%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2Fimages%2Fheader_title.gif%3BS%3Ahttp%3A%2F%2Fwww.japantimes.co.jp%2F%3BFORID%3A1%3B&hl=ja&advancesearch=&q={$formKeywords}', NULL, 6),
(2555, 493, 'The Moscow Times', 'The Moscow Times, Russia (1994-)', 'http://www.moscowtimes.ru/doc/Search.html', 'http://www.moscowtimes.ru/cgi-bin/search?config=&exclude=&method=and&format=long&sort=score&matchesperpage=10&words={$formKeywords}', NULL, 7),
(2556, 493, 'Washington Post', 'Washington Post, Washington, DC (last two weeks)', 'http://www.washingtonpost.com/', 'http://www.washingtonpost.com/cgi-bin/search99.pl?searchsection=news&searchdatabase=news&x=11&y=8&searchtext={$formKeywords}', NULL, 8),
(2557, 493, 'Newsdirectory', 'Newsdirectory is a comprehensive and searchable guide to the world''s English-language online media. Currently over 8,000 newspapers and magazines are listed, as well as more than 1,000 U.S. television broadcasters.', 'http://www.newsdirectory.com/', 'http://www.newsdirectory.com/hbSearch.php', 's={$formKeywords}& submit=Go', 9),
(2558, 493, 'The ArchNewsNow', 'The ArchNewsNow (ANN) newsletter, launched in February 2002, is delivered daily to subscribers -- free of charge -- via e-mail by 9:30AM (New York time). It hyperlinks directly to the latest news and commentary gleaned from sources around the world.', 'http://www.archnewsnow.com/', 'http://www.archnewsnow.com/cgi-local/search.pl?Required={$formKeywords}', NULL, 10),
(2559, 494, 'Google', 'Search using the popular Google search engine.', 'http://www.google.com/', 'http://www.google.com/search?q={$formKeywords}', NULL, 0),
(2560, 494, 'Google Scholar', 'Google Scholar enables specific searches of scholarly literature, including peer-reviewed papers, theses, books, pre-prints, abstracts, and technical reports. Content includes a range of publishers and aggregators with whom Google already has standing arrangements, e.g., the Association for Computing Machinery, IEEE, OCLC''s Open WorldCat library locator service, etc. Result displays will show different version clusters, citation analysis, and library location (currently books only).', 'http://scholar.google.com', 'http://scholar.google.com/scholar?ie=UTF-8&oe=UTF-8&hl=en&q={$formKeywords}', NULL, 1),
(2561, 494, 'Clusty the Clustering Engine', 'This search tool from Vivismo offers clustered results for a selection of searches.  Metasearch the whole web, or use tabs to search for news, gossip, images, orproducts via Bizrate or eBay.', 'http://clusty.com/about', 'http://clusty.com/search?query={$formKeywords}', NULL, 2),
(2562, 494, 'Vivisimo', 'The award-winning Vivisimo clustering technology, developed by Carnegie Mellon research scientists, is unlocking the value of stored information at Fortune 500 companies, top websites, prestigious publishers and government agencies by categorizing research results on the fly into meaningful orders, thus achieving breakthrough improvement in access to relevant information.', 'http://vivisimo.com', 'http://vivisimo.com/search?tb=homepage&v%3Asources=Web&query={$formKeywords}', NULL, 3);

-- --------------------------------------------------------

--
-- Table structure for table `rt_versions`
--

CREATE TABLE IF NOT EXISTS `rt_versions` (
  `version_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `version_key` varchar(40) NOT NULL,
  `locale` varchar(5) DEFAULT 'en_US',
  `title` varchar(120) NOT NULL,
  `description` text,
  PRIMARY KEY (`version_id`),
  KEY `rt_versions_journal_id` (`journal_id`),
  KEY `rt_versions_version_key` (`version_key`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=39 ;

--
-- Dumping data for table `rt_versions`
--

INSERT INTO `rt_versions` (`version_id`, `journal_id`, `version_key`, `locale`, `title`, `description`) VALUES
(36, 2, 'Chemistry', 'en_US', 'Chemistry', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(37, 2, 'Economics', 'en_US', 'Economics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(32, 2, 'Cognitive_Science', 'en_US', 'Cognitive Science', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(33, 2, 'Agriculture', 'en_US', 'Agriculture', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(34, 2, 'Social_Sciences', 'en_US', 'Social Sciences', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(35, 2, 'Astrophysics', 'en_US', 'Astrophysics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(31, 2, 'Business', 'en_US', 'Business', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(30, 2, 'Education', 'en_US', 'Education', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(25, 2, 'Generic', 'en_US', 'Generic', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(26, 2, 'Mathematics', 'en_US', 'Mathematics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(27, 2, 'Biology', 'en_US', 'Biology', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(28, 2, 'Music', 'en_US', 'Music', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(29, 2, 'Physics', 'en_US', 'Physics', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(20, 2, 'General_Science', 'en_US', 'General Science', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(21, 2, 'Environment', 'en_US', 'Environment', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(22, 2, 'Life_Sciences', 'en_US', 'Life Sciences', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(23, 2, 'Humanities', 'en_US', 'Humanities', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(24, 2, 'Computer_Science', 'en_US', 'Computer Science', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.'),
(38, 2, 'Art_Architecture', 'en_US', 'Art & Architecture', 'The Reading Tools can help readers of this study consult a wide range of related resources that can provide a context for interpreting, situating and evaluating the study.');

-- --------------------------------------------------------

--
-- Table structure for table `scheduled_tasks`
--

CREATE TABLE IF NOT EXISTS `scheduled_tasks` (
  `class_name` varchar(255) NOT NULL,
  `last_run` datetime DEFAULT NULL,
  UNIQUE KEY `scheduled_tasks_pkey` (`class_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `scheduled_tasks`
--


-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE IF NOT EXISTS `sections` (
  `section_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `review_form_id` bigint(20) DEFAULT NULL,
  `seq` double NOT NULL DEFAULT '0',
  `editor_restricted` tinyint(4) NOT NULL DEFAULT '0',
  `meta_indexed` tinyint(4) NOT NULL DEFAULT '0',
  `meta_reviewed` tinyint(4) NOT NULL DEFAULT '1',
  `abstracts_not_required` tinyint(4) NOT NULL DEFAULT '0',
  `hide_title` tinyint(4) NOT NULL DEFAULT '0',
  `hide_author` tinyint(4) NOT NULL DEFAULT '0',
  `hide_about` tinyint(4) NOT NULL DEFAULT '0',
  `disable_comments` tinyint(4) NOT NULL DEFAULT '0',
  `abstract_word_count` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`section_id`),
  KEY `sections_journal_id` (`journal_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`section_id`, `journal_id`, `review_form_id`, `seq`, `editor_restricted`, `meta_indexed`, `meta_reviewed`, `abstracts_not_required`, `hide_title`, `hide_author`, `hide_about`, `disable_comments`, `abstract_word_count`) VALUES
(2, 2, 2, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `section_editors`
--

CREATE TABLE IF NOT EXISTS `section_editors` (
  `journal_id` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `can_edit` tinyint(4) NOT NULL DEFAULT '1',
  `can_review` tinyint(4) NOT NULL DEFAULT '1',
  UNIQUE KEY `section_editors_pkey` (`journal_id`,`section_id`,`user_id`),
  KEY `section_editors_journal_id` (`journal_id`),
  KEY `section_editors_section_id` (`section_id`),
  KEY `section_editors_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `section_editors`
--


-- --------------------------------------------------------

--
-- Table structure for table `section_settings`
--

CREATE TABLE IF NOT EXISTS `section_settings` (
  `section_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `section_settings_pkey` (`section_id`,`locale`,`setting_name`),
  KEY `section_settings_section_id` (`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `section_settings`
--

INSERT INTO `section_settings` (`section_id`, `locale`, `setting_name`, `setting_value`, `setting_type`) VALUES
(2, 'en_US', 'title', 'Articles', 'string'),
(2, 'en_US', 'abbrev', 'ART', 'string'),
(2, 'en_US', 'policy', '', 'string'),
(2, 'en_US', 'identifyType', '', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(40) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `ip_address` varchar(39) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created` bigint(20) NOT NULL DEFAULT '0',
  `last_used` bigint(20) NOT NULL DEFAULT '0',
  `remember` tinyint(4) NOT NULL DEFAULT '0',
  `data` text,
  `acting_as` bigint(20) NOT NULL DEFAULT '0',
  UNIQUE KEY `sessions_pkey` (`session_id`),
  KEY `sessions_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `user_id`, `ip_address`, `user_agent`, `created`, `last_used`, `remember`, `data`, `acting_as`) VALUES
('82450u6b0hg7b0l5bdnui3o651', 2, '127.0.0.1', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.57 Safari/534.24', 1304389494, 1304389554, 0, 'userId|s:1:"2";username|s:6:"author";', 0),
('o47kq3eevptldrc5mbgnsjnur5', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10) Gecko/20100922 Ubuntu/10.10 (maverick) Firefox/3.6.10', 1304301867, 1304307279, 0, 'username|s:6:"author";', 0),
('tin3a6n3s99s1a60ooo4rovdr3', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.57 Safari/534.24', 1304301904, 1304307213, 0, 'username|s:13:"sectioneditor";', 0),
('6ooukqb0hfp6qdkl7ct4rrr7o0', 1, '127.0.0.1', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10) Gecko/20100922 Ubuntu/10.10 (maverick) Firefox/3.6.10', 1304387526, 1304389476, 0, 'userId|s:1:"1";username|s:5:"admin";enrolmentReferrer|a:1:{i:0;s:7:"authors";}', 0);

-- --------------------------------------------------------

--
-- Table structure for table `signoffs`
--

CREATE TABLE IF NOT EXISTS `signoffs` (
  `signoff_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `symbolic` varchar(32) NOT NULL,
  `assoc_type` bigint(20) NOT NULL DEFAULT '0',
  `assoc_id` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) NOT NULL,
  `file_id` bigint(20) DEFAULT NULL,
  `file_revision` bigint(20) DEFAULT NULL,
  `date_notified` datetime DEFAULT NULL,
  `date_underway` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `date_acknowledged` datetime DEFAULT NULL,
  `stage_id` bigint(20) DEFAULT NULL,
  `user_group_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`signoff_id`),
  UNIQUE KEY `signoff_symbolic` (`assoc_type`,`assoc_id`,`symbolic`,`user_id`,`stage_id`,`user_group_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `signoffs`
--


-- --------------------------------------------------------

--
-- Table structure for table `site`
--

CREATE TABLE IF NOT EXISTS `site` (
  `redirect` bigint(20) NOT NULL DEFAULT '0',
  `primary_locale` varchar(5) NOT NULL,
  `min_password_length` tinyint(4) NOT NULL DEFAULT '6',
  `installed_locales` varchar(255) NOT NULL DEFAULT 'en_US',
  `supported_locales` varchar(255) DEFAULT NULL,
  `original_style_file_name` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `site`
--

INSERT INTO `site` (`redirect`, `primary_locale`, `min_password_length`, `installed_locales`, `supported_locales`, `original_style_file_name`) VALUES
(0, 'en_US', 6, 'en_US', 'en_US', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `site_settings`
--

CREATE TABLE IF NOT EXISTS `site_settings` (
  `setting_name` varchar(255) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `site_settings_pkey` (`setting_name`,`locale`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `site_settings`
--

INSERT INTO `site_settings` (`setting_name`, `locale`, `setting_value`, `setting_type`) VALUES
('title', 'en_US', 'Open Journal Systems', 'string'),
('contactName', 'en_US', 'Open Journal Systems', 'string'),
('contactEmail', 'en_US', 'xein_ne04@yahoo.com', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `static_pages`
--

CREATE TABLE IF NOT EXISTS `static_pages` (
  `static_page_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `journal_id` bigint(20) NOT NULL,
  PRIMARY KEY (`static_page_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `static_pages`
--


-- --------------------------------------------------------

--
-- Table structure for table `static_page_settings`
--

CREATE TABLE IF NOT EXISTS `static_page_settings` (
  `static_page_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` longtext,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `static_page_settings_pkey` (`static_page_id`,`locale`,`setting_name`),
  KEY `static_page_settings_static_page_id` (`static_page_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `static_page_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE IF NOT EXISTS `subscriptions` (
  `subscription_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `type_id` bigint(20) NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `membership` varchar(40) DEFAULT NULL,
  `reference_number` varchar(40) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`subscription_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `subscriptions`
--


-- --------------------------------------------------------

--
-- Table structure for table `subscription_types`
--

CREATE TABLE IF NOT EXISTS `subscription_types` (
  `type_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `cost` double NOT NULL,
  `currency_code_alpha` varchar(3) NOT NULL,
  `non_expiring` tinyint(4) NOT NULL DEFAULT '0',
  `duration` smallint(6) DEFAULT NULL,
  `format` smallint(6) NOT NULL,
  `institutional` tinyint(4) NOT NULL DEFAULT '0',
  `membership` tinyint(4) NOT NULL DEFAULT '0',
  `disable_public_display` tinyint(4) NOT NULL,
  `seq` double NOT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `subscription_types`
--


-- --------------------------------------------------------

--
-- Table structure for table `subscription_type_settings`
--

CREATE TABLE IF NOT EXISTS `subscription_type_settings` (
  `type_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `subscription_type_settings_pkey` (`type_id`,`locale`,`setting_name`),
  KEY `subscription_type_settings_type_id` (`type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `subscription_type_settings`
--


-- --------------------------------------------------------

--
-- Table structure for table `temporary_files`
--

CREATE TABLE IF NOT EXISTS `temporary_files` (
  `file_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `file_name` varchar(90) NOT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) NOT NULL,
  `original_file_name` varchar(127) DEFAULT NULL,
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY (`file_id`),
  KEY `temporary_files_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `temporary_files`
--


-- --------------------------------------------------------

--
-- Table structure for table `theses`
--

CREATE TABLE IF NOT EXISTS `theses` (
  `thesis_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_id` bigint(20) NOT NULL,
  `status` smallint(6) NOT NULL,
  `degree` smallint(6) NOT NULL,
  `degree_name` varchar(255) DEFAULT NULL,
  `department` varchar(255) NOT NULL,
  `university` varchar(255) NOT NULL,
  `date_approved` datetime NOT NULL,
  `title` varchar(255) NOT NULL,
  `url` text,
  `abstract` text,
  `comment` text,
  `student_first_name` varchar(40) NOT NULL,
  `student_middle_name` varchar(40) DEFAULT NULL,
  `student_last_name` varchar(90) NOT NULL,
  `student_email` varchar(90) NOT NULL,
  `student_email_publish` tinyint(4) DEFAULT '0',
  `student_bio` text,
  `supervisor_first_name` varchar(40) NOT NULL,
  `supervisor_middle_name` varchar(40) DEFAULT NULL,
  `supervisor_last_name` varchar(90) NOT NULL,
  `supervisor_email` varchar(90) NOT NULL,
  `discipline` varchar(255) DEFAULT NULL,
  `subject_class` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `coverage_geo` varchar(255) DEFAULT NULL,
  `coverage_chron` varchar(255) DEFAULT NULL,
  `coverage_sample` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `language` varchar(10) DEFAULT 'en',
  `date_submitted` datetime NOT NULL,
  PRIMARY KEY (`thesis_id`),
  KEY `theses_journal_id` (`journal_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `theses`
--


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(40) NOT NULL,
  `salutation` varchar(40) DEFAULT NULL,
  `first_name` varchar(40) NOT NULL,
  `middle_name` varchar(40) DEFAULT NULL,
  `last_name` varchar(90) NOT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `initials` varchar(5) DEFAULT NULL,
  `email` varchar(90) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `phone` varchar(24) DEFAULT NULL,
  `fax` varchar(24) DEFAULT NULL,
  `mailing_address` varchar(255) DEFAULT NULL,
  `country` varchar(90) DEFAULT NULL,
  `locales` varchar(255) DEFAULT NULL,
  `date_last_email` datetime DEFAULT NULL,
  `date_registered` datetime NOT NULL,
  `date_validated` datetime DEFAULT NULL,
  `date_last_login` datetime NOT NULL,
  `must_change_password` tinyint(4) DEFAULT NULL,
  `auth_id` bigint(20) DEFAULT NULL,
  `auth_str` varchar(255) DEFAULT NULL,
  `disabled` tinyint(4) NOT NULL DEFAULT '0',
  `disabled_reason` text,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_username` (`username`),
  UNIQUE KEY `users_email` (`email`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `salutation`, `first_name`, `middle_name`, `last_name`, `gender`, `initials`, `email`, `url`, `phone`, `fax`, `mailing_address`, `country`, `locales`, `date_last_email`, `date_registered`, `date_validated`, `date_last_login`, `must_change_password`, `auth_id`, `auth_str`, `disabled`, `disabled_reason`) VALUES
(1, 'admin', 'f6fdffe48c908deb0f4c3bd36c032e72', NULL, 'admin', NULL, '', NULL, NULL, 'xein_ne04@yahoo.com', NULL, NULL, NULL, NULL, NULL, '', NULL, '2011-05-01 15:57:10', NULL, '2011-05-03 09:52:28', 0, NULL, NULL, 0, NULL),
(2, 'author', 'd50afb6ec7b2501164b80a0480596ded', 'Ms', 'Abbey', 'Gail', 'Westminster', 'F', 'AGW', 'tagliatelle.penne@gmail.com', 'http://morningsmockme.wordpress.com', '(02) 414-0934', '(02) 414-0934', 'Yorkshire England', 'PH', '', NULL, '2011-05-01 16:53:20', NULL, '2011-05-03 10:25:01', 0, NULL, NULL, 0, NULL),
(3, 'sectioneditor', '4b4cd187c48bd6e0338c7ee8472259d4', 'Mr', 'Ronald', 'Jollibee', 'Mcdonald', 'M', 'RJM', 'cor_heinz@yahoo.com', 'http://morningsmockme.wordpress.com', '(02)414-0934', '(02)414-0934', 'Quezon City', 'PH', '', NULL, '2011-05-01 20:35:34', NULL, '2011-05-02 10:05:17', 0, NULL, NULL, 0, NULL),
(4, 'reviewer', '895e61454b3a4e72b7f72c15b4e3f44d', 'Ms', 'Haruhi', 'Mei', 'Suzumiya', 'F', 'HMS', 'mikeludex@gmail.com', 'http://morningsmockme.wordpress.com', '(02)414-0934', '(02)414-0934', 'Tokyo Japan', 'JP', '', NULL, '2011-05-02 02:11:02', NULL, '2011-05-02 02:11:02', 0, NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE IF NOT EXISTS `user_settings` (
  `user_id` bigint(20) NOT NULL,
  `locale` varchar(5) NOT NULL DEFAULT '',
  `setting_name` varchar(255) NOT NULL,
  `assoc_type` bigint(20) DEFAULT '0',
  `assoc_id` bigint(20) DEFAULT '0',
  `setting_value` text,
  `setting_type` varchar(6) NOT NULL,
  UNIQUE KEY `user_settings_pkey` (`user_id`,`locale`,`setting_name`,`assoc_type`,`assoc_id`),
  KEY `user_settings_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_settings`
--

INSERT INTO `user_settings` (`user_id`, `locale`, `setting_name`, `assoc_type`, `assoc_id`, `setting_value`, `setting_type`) VALUES
(2, 'en_US', 'biography', 0, 0, 'Westminster Abbey is the official Duchess of Cambridge and has been the Countess of Yorkshire for 3 years.', 'string'),
(2, 'en_US', 'signature', 0, 0, 'Abbey Gail Westminster\r\nDuchess of Cambridge', 'string'),
(3, 'en_US', 'biography', 0, 0, 'Mr Ronald Jollibee McDonald is the king of all fastfood chains and will conquer the world in the near future.', 'string'),
(3, 'en_US', 'signature', 0, 0, 'Mr ronald Jollibee McDonald', 'string'),
(3, '', 'filterSection', 256, 1, '0', 'int'),
(3, '', 'filterEditor', 256, 1, '0', 'int'),
(4, 'en_US', 'biography', 0, 0, 'The Melancholy of Haruhi Suzumiya is the next anime na dapat i-marathon before this summer ends. :)', 'string'),
(4, 'en_US', 'gossip', 0, 0, '', 'string'),
(4, 'en_US', 'affiliation', 0, 0, 'the Melancholy of Haruhi Suzumiya', 'string');

-- --------------------------------------------------------

--
-- Table structure for table `versions`
--

CREATE TABLE IF NOT EXISTS `versions` (
  `major` int(11) NOT NULL DEFAULT '0',
  `minor` int(11) NOT NULL DEFAULT '0',
  `revision` int(11) NOT NULL DEFAULT '0',
  `build` int(11) NOT NULL DEFAULT '0',
  `date_installed` datetime NOT NULL,
  `current` tinyint(4) NOT NULL DEFAULT '0',
  `product_type` varchar(30) DEFAULT NULL,
  `product` varchar(30) DEFAULT NULL,
  `product_class_name` varchar(80) DEFAULT NULL,
  `lazy_load` tinyint(4) NOT NULL DEFAULT '0',
  `sitewide` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `versions_pkey` (`product`,`major`,`minor`,`revision`,`build`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `versions`
--

INSERT INTO `versions` (`major`, `minor`, `revision`, `build`, `date_installed`, `current`, `product_type`, `product`, `product_class_name`, `lazy_load`, `sitewide`) VALUES
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.auth', 'ldap', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'donation', 'DonationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'help', 'HelpBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'navigation', 'NavigationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'information', 'InformationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'authorBios', 'AuthorBiosBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'role', 'RoleBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'subscription', 'SubscriptionBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'readingTools', 'ReadingToolsBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'keywordCloud', 'KeywordCloudBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'relatedItems', 'RelatedItemsBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'user', 'UserBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'notification', 'NotificationBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'developedBy', 'DevelopedByBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'languageToggle', 'LanguageToggleBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.blocks', 'fontSize', 'FontSizeBlockPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'endNote', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'refMan', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'apa', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'proCite', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'mla', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'abnt', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'refWorks', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'turabian', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'bibtex', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.citationFormats', 'cbe', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.gateways', 'metsGateway', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.gateways', 'resolver', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'thesisFeed', 'ThesisFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'phpMyVisites', 'PhpMyVisitesPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'externalFeed', 'ExternalFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'coins', 'CoinsPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'sehl', 'SehlPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'webFeed', 'WebFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'translator', 'TranslatorPlugin', 1, 1),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'tinymce', 'TinyMCEPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'openAds', 'OpenAdsPlugin', 1, 0),
(1, 1, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'counter', 'CounterPlugin', 1, 1),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'googleAnalytics', 'GoogleAnalyticsPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'booksForReview', 'BooksForReviewPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'openAIRE', 'OpenAIREPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'announcementFeed', 'AnnouncementFeedPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'sword', 'SwordPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'xmlGalley', 'XmlGalleyPlugin', 1, 0),
(1, 2, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'staticPages', 'StaticPagesPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'thesis', 'ThesisPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'customLocale', 'CustomLocalePlugin', 1, 0),
(1, 1, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'customBlockManager', 'CustomBlockManagerPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'referral', 'ReferralPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.generic', 'roundedCorners', 'RoundedCornersPlugin', 1, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.implicitAuth', 'shibboleth', '', 0, 1),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'users', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'pubmed', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'doaj', '', 0, 0),
(1, 1, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'crossref', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'erudit', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'mets', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'native', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.importexport', 'quickSubmit', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.oaiMetadataFormats', 'dc', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.oaiMetadataFormats', 'marc', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.oaiMetadataFormats', 'rfc1807', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.oaiMetadataFormats', 'nlm', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.oaiMetadataFormats', 'marcxml', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.paymethod', 'manual', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.paymethod', 'paypal', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.reports', 'subscriptions', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.reports', 'articles', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.reports', 'views', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.reports', 'reviews', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'classicRed', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'lilac', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'uncommon', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'steel', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'vanilla', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'classicBrown', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'classicGreen', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'redbar', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'classicNavy', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'night', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'custom', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'classicBlue', '', 0, 0),
(1, 0, 0, 0, '2011-05-01 15:57:10', 1, 'plugins.themes', 'desert', '', 0, 0),
(2, 3, 4, 0, '2011-05-01 15:56:56', 1, 'core', 'ojs2', '', 0, 1);
