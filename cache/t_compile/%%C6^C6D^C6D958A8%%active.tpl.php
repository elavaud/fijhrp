<?php /* Smarty version 2.6.26, created on 2011-05-01 15:52:25
         compiled from author/active.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'sort_heading', 'author/active.tpl', 15, false),array('function', 'translate', 'author/active.tpl', 16, false),array('function', 'url', 'author/active.tpl', 34, false),array('function', 'page_info', 'author/active.tpl', 100, false),array('function', 'page_links', 'author/active.tpl', 101, false),array('block', 'iterate', 'author/active.tpl', 24, false),array('modifier', 'escape', 'author/active.tpl', 29, false),array('modifier', 'date_format', 'author/active.tpl', 30, false),array('modifier', 'truncate', 'author/active.tpl', 32, false),array('modifier', 'strip_unsafe_html', 'author/active.tpl', 34, false),)), $this); ?>
<div id="submissions">
<table class="listing" width="100%">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.id",'sort' => 'id','sortOrder' => 'ASC'), $this);?>
</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.submit",'sort' => 'submitDate'), $this);?>
</td>
		<td width="5%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.sec",'sort' => 'section'), $this);?>
</td>
		<td width="25%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.authors",'sort' => 'authors'), $this);?>
</td>
		<td width="35%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="25%" align="right"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.status",'sort' => 'status'), $this);?>
</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?>
	<?php $this->assign('progress', $this->_tpl_vars['submission']->getSubmissionProgress()); ?>

	<tr valign="top">
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['articleId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<td><?php if ($this->_tpl_vars['submission']->getDateSubmitted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateSubmitted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getSectionAbbrev())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<td><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getAuthorString(true))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<?php if ($this->_tpl_vars['progress'] == 0): ?>
			<td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
			<td align="right">
				<?php $this->assign('status', $this->_tpl_vars['submission']->getSubmissionStatus()); ?>
				<?php if ($this->_tpl_vars['status'] == STATUS_QUEUED_UNASSIGNED): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.queuedUnassigned"), $this);?>

				<?php elseif ($this->_tpl_vars['status'] == STATUS_QUEUED_REVIEW): ?>
					<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submissionReview','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">
						<?php $this->assign('decision', $this->_tpl_vars['submission']->getMostRecentDecision()); ?>
						<?php if ($this->_tpl_vars['decision'] == @SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.queuedReviewRevisions"), $this);?>

						<?php elseif ($this->_tpl_vars['submission']->getCurrentRound() > 1): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.queuedReviewSubsequent",'round' => $this->_tpl_vars['submission']->getCurrentRound()), $this);?>

						<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.queuedReview"), $this);?>

						<?php endif; ?>
					</a>
				<?php elseif ($this->_tpl_vars['status'] == STATUS_QUEUED_EDITING): ?>
					<?php $this->assign('proofSignoff', $this->_tpl_vars['submission']->getSignoff('SIGNOFF_PROOFREADING_AUTHOR')); ?>
					<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submissionEditing','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">
						<?php if ($this->_tpl_vars['proofSignoff']->getDateNotified() && ! $this->_tpl_vars['proofSignoff']->getDateCompleted()): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.queuedEditingCopyedit"), $this);?>

						<?php elseif ($this->_tpl_vars['proofSignoff']->getDateNotified() && ! $this->_tpl_vars['proofSignoff']->getDateCompleted()): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.queuedEditingProofread"), $this);?>

						<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.queuedEditing"), $this);?>

						<?php endif; ?>
					</a>
				<?php endif; ?>

								<?php if ($this->_tpl_vars['status'] == STATUS_QUEUED_UNASSIGNED || $this->_tpl_vars['status'] == STATUS_QUEUED_REVIEW): ?>
					<?php if ($this->_tpl_vars['submissionEnabled'] && ! $this->_tpl_vars['completedPaymentDAO']->hasPaidSubmission($this->_tpl_vars['submission']->getJournalId(),$this->_tpl_vars['submission']->getArticleId())): ?>
						<br />
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'paySubmissionFee','path' => ($this->_tpl_vars['articleId'])), $this);?>
" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.submission.paySubmission"), $this);?>
</a>					
					<?php elseif ($this->_tpl_vars['fastTrackEnabled']): ?>
						<br />
						<?php if ($this->_tpl_vars['submission']->getFastTracked()): ?>
							<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.fastTrack.inFastTrack"), $this);?>

						<?php else: ?>
							<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'payFastTrackFee','path' => ($this->_tpl_vars['articleId'])), $this);?>
" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.fastTrack.payFastTrack"), $this);?>
</a>
						<?php endif; ?>
					<?php endif; ?>
				<?php elseif ($this->_tpl_vars['status'] == STATUS_QUEUED_EDITING): ?>
					<?php if ($this->_tpl_vars['publicationEnabled']): ?>
						<br />
						<?php if ($this->_tpl_vars['completedPaymentDAO']->hasPaidPublication($this->_tpl_vars['submission']->getJournalId(),$this->_tpl_vars['submission']->getArticleId())): ?>
							<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.publication.publicationPaid"), $this);?>

						<?php else: ?>
						 	<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'payPublicationFee','path' => ($this->_tpl_vars['articleId'])), $this);?>
" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.publication.payPublication"), $this);?>
</a>
						 <?php endif; ?>
				<?php endif; ?>		
		<?php endif; ?>
			</td>
		<?php else: ?>
			<td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submit','path' => $this->_tpl_vars['progress'],'articleId' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
			<td align="right"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.incomplete"), $this);?>
<br /><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'deleteSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.confirmDelete"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.delete"), $this);?>
</a></td>
		<?php endif; ?>

	</tr>

	<tr>
		<td colspan="6" class="<?php if ($this->_tpl_vars['submissions']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td>
	</tr>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['submissions']->wasEmpty()): ?>
	<tr>
		<td colspan="6" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.noSubmissions"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="4" align="left"><?php echo $this->_plugins['function']['page_info'][0][0]->smartyPageInfo(array('iterator' => $this->_tpl_vars['submissions']), $this);?>
</td>
		<td colspan="2" align="right"><?php echo $this->_plugins['function']['page_links'][0][0]->smartyPageLinks(array('anchor' => 'submissions','name' => 'submissions','iterator' => $this->_tpl_vars['submissions'],'sort' => $this->_tpl_vars['sort'],'sortDirection' => $this->_tpl_vars['sortDirection']), $this);?>
</td>
	</tr>
<?php endif; ?>
</table>
</div>
