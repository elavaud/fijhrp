<?php /* Smarty version 2.6.26, created on 2011-05-09 17:42:26
         compiled from reviewer/submission.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'reviewer/submission.tpl', 16, false),array('function', 'url', 'reviewer/submission.tpl', 59, false),array('function', 'icon', 'reviewer/submission.tpl', 60, false),array('function', 'get_help_id', 'reviewer/submission.tpl', 311, false),array('function', 'html_options_translate', 'reviewer/submission.tpl', 339, false),array('modifier', 'assign', 'reviewer/submission.tpl', 16, false),array('modifier', 'escape', 'reviewer/submission.tpl', 26, false),array('modifier', 'strip_unsafe_html', 'reviewer/submission.tpl', 40, false),array('modifier', 'nl2br', 'reviewer/submission.tpl', 48, false),array('modifier', 'concat', 'reviewer/submission.tpl', 58, false),array('modifier', 'to_array', 'reviewer/submission.tpl', 59, false),array('modifier', 'strip_tags', 'reviewer/submission.tpl', 59, false),array('modifier', 'date_format', 'reviewer/submission.tpl', 88, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?><?php echo ''; ?><?php $this->assign('reviewId', $this->_tpl_vars['reviewAssignment']->getId()); ?><?php echo ''; ?><?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.page.review",'id' => $this->_tpl_vars['articleId']), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'pageTitleTranslated') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'pageTitleTranslated'));?><?php echo ''; ?><?php $this->assign('pageCrumbTitle', "submission.review"); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<script type="text/javascript">
<?php echo '
<!--
function confirmSubmissionCheck() {
	if (document.recommendation.recommendation.value==\'\') {
		alert(\''; ?>
<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.mustSelectDecision"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'javascript') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'javascript'));?>
<?php echo '\');
		return false;
	}
	return confirm(\''; ?>
<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.confirmDecision"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'javascript') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'javascript'));?>
<?php echo '\');
}
// -->
'; ?>

</script>
<div id="submissionToBeReviewed">
<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.submissionToBeReviewed"), $this);?>
</h3>

<table width="100%" class="data">
<tr valign="top">
	<td width="20%" class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "article.title"), $this);?>
</td>
	<td width="80%" class="value"><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)); ?>
</td>
</tr>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "article.journalSection"), $this);?>
</td>
	<td class="value"><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getSectionTitle())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
</tr>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "article.abstract"), $this);?>
</td>
	<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedAbstract())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)); ?>
</td>
</tr>
<?php $this->assign('editAssignments', $this->_tpl_vars['submission']->getEditAssignments()); ?>
<?php $_from = $this->_tpl_vars['editAssignments']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['editAssignment']):
?>
	<?php if (! $this->_tpl_vars['notFirstEditAssignment']): ?>
		<?php $this->assign('notFirstEditAssignment', 1); ?>
		<tr valign="top">
			<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.submissionEditor"), $this);?>
</td>
			<td class="value">
	<?php endif; ?>
			<?php $this->assign('emailString', ((is_array($_tmp=$this->_tpl_vars['editAssignment']->getEditorFullName())) ? $this->_run_mod_handler('concat', true, $_tmp, " <", $this->_tpl_vars['editAssignment']->getEditorEmail(), ">") : $this->_plugins['modifier']['concat'][0][0]->smartyConcat($_tmp, " <", $this->_tpl_vars['editAssignment']->getEditorEmail(), ">"))); ?>
			<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'email','to' => ((is_array($_tmp=$this->_tpl_vars['emailString'])) ? $this->_run_mod_handler('to_array', true, $_tmp) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp)),'redirectUrl' => $this->_tpl_vars['currentUrl'],'subject' => ((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_tags', true, $_tmp) : smarty_modifier_strip_tags($_tmp)),'articleId' => $this->_tpl_vars['articleId']), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'url') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'url'));?>

			<?php echo ((is_array($_tmp=$this->_tpl_vars['editAssignment']->getEditorFullName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
 <?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','url' => $this->_tpl_vars['url']), $this);?>

			<?php if (! $this->_tpl_vars['editAssignment']->getCanEdit() || ! $this->_tpl_vars['editAssignment']->getCanReview()): ?>
				<?php if ($this->_tpl_vars['editAssignment']->getCanEdit()): ?>
					(<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.editing"), $this);?>
)
				<?php else: ?>
					(<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.review"), $this);?>
)
				<?php endif; ?>
			<?php endif; ?>
			<br/>
<?php endforeach; endif; unset($_from); ?>
<?php if ($this->_tpl_vars['notFirstEditAssignment']): ?>
		</td>
	</tr>
<?php endif; ?>
	<tr valign="top">
	       <td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.metadata"), $this);?>
</td>
	       <td class="value">
		       <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'viewMetadata','path' => ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['articleId']) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['articleId']))), $this);?>
" class="action" target="_new"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.viewMetadata"), $this);?>
</a>
	       </td>
	</tr>
</table>
</div>
<div class="separator"></div>
<div id="reviewSchedule">
<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.reviewSchedule"), $this);?>
</h3>
<table width="100%" class="data">
<tr valign="top">
	<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.schedule.request"), $this);?>
</td>
	<td class="value" width="80%"><?php if ($this->_tpl_vars['submission']->getDateNotified()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateNotified())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
</tr>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.schedule.response"), $this);?>
</td>
	<td class="value"><?php if ($this->_tpl_vars['submission']->getDateConfirmed()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateConfirmed())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
</tr>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.schedule.submitted"), $this);?>
</td>
	<td class="value"><?php if ($this->_tpl_vars['submission']->getDateCompleted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateCompleted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
</tr>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.schedule.due"), $this);?>
</td>
	<td class="value"><?php if ($this->_tpl_vars['submission']->getDateDue()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateDue())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
</tr>
</table>
</div>
<div class="separator"></div>

<div id="reviewSteps">
<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.reviewSteps"), $this);?>
</h3>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/formErrors.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php $this->assign('currentStep', 1); ?>

<table width="100%" class="data">
<tr valign="top">
	<?php $this->assign('editAssignments', $this->_tpl_vars['submission']->getEditAssignments); ?>
		<?php if ($this->_tpl_vars['editAssignments'][0]): ?><?php $this->assign('firstEditAssignment', $this->_tpl_vars['editAssignments'][0]); ?><?php endif; ?>
	<td width="3%"><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
	<td width="97%"><span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.notifyEditorA"), $this);?>
<?php if ($this->_tpl_vars['firstEditAssignment']): ?>, <?php echo ((is_array($_tmp=$this->_tpl_vars['firstEditAssignment']->getEditorFullName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
,<?php endif; ?> <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.notifyEditorB"), $this);?>
</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.response"), $this);?>
&nbsp;&nbsp;&nbsp;&nbsp;
		<?php if (! $this->_tpl_vars['confirmedStatus']): ?>
			<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'confirmReview','reviewId' => $this->_tpl_vars['reviewId']), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'acceptUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'acceptUrl'));?>

			<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'confirmReview','reviewId' => $this->_tpl_vars['reviewId'],'declineReview' => 1), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'declineUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'declineUrl'));?>


			<?php if (! $this->_tpl_vars['submission']->getCancelled()): ?>
				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.canDoReview"), $this);?>
 <?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','url' => $this->_tpl_vars['acceptUrl']), $this);?>

				&nbsp;&nbsp;&nbsp;&nbsp;
				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.cannotDoReview"), $this);?>
 <?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','url' => $this->_tpl_vars['declineUrl']), $this);?>

			<?php else: ?>
				<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'confirmReview','reviewId' => $this->_tpl_vars['reviewId']), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'url') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'url'));?>

				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.canDoReview"), $this);?>
 <?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','disabled' => 'disabled','url' => $this->_tpl_vars['acceptUrl']), $this);?>

				&nbsp;&nbsp;&nbsp;&nbsp;
				<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'confirmReview','reviewId' => $this->_tpl_vars['reviewId'],'declineReview' => 1), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'url') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'url'));?>

				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.cannotDoReview"), $this);?>
 <?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','disabled' => 'disabled','url' => $this->_tpl_vars['declineUrl']), $this);?>

			<?php endif; ?>
		<?php else: ?>
			<?php if (! $this->_tpl_vars['declined']): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.accepted"), $this);?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.rejected"), $this);?>
<?php endif; ?>
		<?php endif; ?>
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<?php if ($this->_tpl_vars['journal']->getLocalizedSetting('reviewGuidelines') != ''): ?>
<tr valign="top">
        <td><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
	<td><span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.consultGuidelines"), $this);?>
</span></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<?php endif; ?>
<tr valign="top">
	<td><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
	<td><span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.downloadSubmission"), $this);?>
</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<table width="100%" class="data">
			<?php if (( $this->_tpl_vars['confirmedStatus'] && ! $this->_tpl_vars['declined'] ) || ! $this->_tpl_vars['journal']->getSetting('restrictReviewerFileAccess')): ?>
			<tr valign="top">
				<td width="30%" class="label">
					<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.submissionManuscript"), $this);?>

				</td>
				<td class="value" width="70%">
					<?php if ($this->_tpl_vars['reviewFile']): ?>
					<?php if ($this->_tpl_vars['submission']->getDateConfirmed() || ! $this->_tpl_vars['journal']->getSetting('restrictReviewerAccessToFile')): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'downloadFile','path' => ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['articleId'], $this->_tpl_vars['reviewFile']->getFileId(), $this->_tpl_vars['reviewFile']->getRevision()) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['articleId'], $this->_tpl_vars['reviewFile']->getFileId(), $this->_tpl_vars['reviewFile']->getRevision()))), $this);?>
" class="file"><?php echo ((is_array($_tmp=$this->_tpl_vars['reviewFile']->getFileName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</a>
					<?php else: ?><?php echo ((is_array($_tmp=$this->_tpl_vars['reviewFile']->getFileName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php endif; ?>
					&nbsp;&nbsp;<?php echo ((is_array($_tmp=$this->_tpl_vars['reviewFile']->getDateModified())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>

					<?php else: ?>
					<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.none"), $this);?>

					<?php endif; ?>
				</td>
			</tr>
			<tr valign="top">
				<td class="label">
					<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "article.suppFiles"), $this);?>

				</td>
				<td class="value">
					<?php $this->assign('sawSuppFile', 0); ?>
					<?php $_from = $this->_tpl_vars['suppFiles']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['suppFile']):
?>
						<?php if ($this->_tpl_vars['suppFile']->getShowReviewers()): ?>
							<?php $this->assign('sawSuppFile', 1); ?>
							<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'downloadFile','path' => ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['articleId'], $this->_tpl_vars['suppFile']->getFileId()) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['articleId'], $this->_tpl_vars['suppFile']->getFileId()))), $this);?>
" class="file"><?php echo ((is_array($_tmp=$this->_tpl_vars['suppFile']->getFileName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</a><br />
						<?php endif; ?>
					<?php endforeach; endif; unset($_from); ?>

					<?php if (! $this->_tpl_vars['sawSuppFile']): ?>
						<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.none"), $this);?>

					<?php endif; ?>
				</td>
			</tr>
			<?php else: ?>
			<tr><td class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.restrictedFileAccess"), $this);?>
</td></tr>
			<?php endif; ?>
		</table>
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<?php if ($this->_tpl_vars['currentJournal']->getSetting('requireReviewerCompetingInterests')): ?>
	<tr valign="top">
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
		<td>
			<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'information','op' => 'competingInterestGuidelines'), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'competingInterestGuidelinesUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'competingInterestGuidelinesUrl'));?>

			<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.enterCompetingInterests",'competingInterestGuidelinesUrl' => $this->_tpl_vars['competingInterestGuidelinesUrl']), $this);?>
</span>
			<?php if (! $this->_tpl_vars['confirmedStatus'] || $this->_tpl_vars['declined'] || $this->_tpl_vars['submission']->getCancelled() || $this->_tpl_vars['submission']->getRecommendation()): ?><br/>
				<?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['reviewAssignment']->getCompetingInterests())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)); ?>

			<?php else: ?>
				<form action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'saveCompetingInterests','reviewId' => $this->_tpl_vars['reviewId']), $this);?>
" method="post">
					<textarea <?php if ($this->_tpl_vars['cannotChangeCI']): ?>disabled="disabled" <?php endif; ?>name="competingInterests" class="textArea" id="competingInterests" rows="5" cols="40"><?php echo ((is_array($_tmp=$this->_tpl_vars['reviewAssignment']->getCompetingInterests())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea><br />
					<input <?php if ($this->_tpl_vars['cannotChangeCI']): ?>disabled="disabled" <?php endif; ?>class="button defaultButton" type="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.save"), $this);?>
" />
				</form>
			<?php endif; ?>
		</td>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<?php endif; ?>
<?php if ($this->_tpl_vars['reviewAssignment']->getReviewFormId()): ?>
	<tr valign="top">
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
		<td><span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.enterReviewForm"), $this);?>
</span></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.reviewForm"), $this);?>
 
			<?php if ($this->_tpl_vars['confirmedStatus'] && ! $this->_tpl_vars['declined']): ?>
				<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editReviewFormResponse','path' => ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['reviewAssignment']->getReviewFormId()) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['reviewAssignment']->getReviewFormId()))), $this);?>
" class="icon"><?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'comment'), $this);?>
</a>
			<?php else: ?>
				 <?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'comment','disabled' => 'disabled'), $this);?>

			<?php endif; ?>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<?php else: ?>	<tr valign="top">
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
		<td><span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.enterReviewA"), $this);?>
</span></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.logType.review"), $this);?>
 
			<?php if ($this->_tpl_vars['confirmedStatus'] && ! $this->_tpl_vars['declined']): ?>
				<a href="javascript:openComments('<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'viewPeerReviewComments','path' => ((is_array($_tmp=$this->_tpl_vars['articleId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['reviewId']) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['reviewId']))), $this);?>
');" class="icon"><?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'comment'), $this);?>
</a>
			<?php else: ?>
				 <?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'comment','disabled' => 'disabled'), $this);?>

			<?php endif; ?>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<?php endif; ?><tr valign="top">
	<td><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
	<td><span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.uploadFile"), $this);?>
</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<table class="data" width="100%">
			<?php $_from = $this->_tpl_vars['submission']->getReviewerFileRevisions(); if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['key'] => $this->_tpl_vars['reviewerFile']):
?>
				<?php $this->assign('uploadedFileExists', '1'); ?>
				<tr valign="top">
				<td class="label" width="30%">
					<?php if ($this->_tpl_vars['key'] == '0'): ?>
						<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.uploadedFile"), $this);?>

					<?php endif; ?>
				</td>
				<td class="value" width="70%">
					<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'downloadFile','path' => ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['articleId'], $this->_tpl_vars['reviewerFile']->getFileId(), $this->_tpl_vars['reviewerFile']->getRevision()) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['articleId'], $this->_tpl_vars['reviewerFile']->getFileId(), $this->_tpl_vars['reviewerFile']->getRevision()))), $this);?>
" class="file"><?php echo ((is_array($_tmp=$this->_tpl_vars['reviewerFile']->getFileName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</a>
					<?php echo ((is_array($_tmp=$this->_tpl_vars['reviewerFile']->getDateModified())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>

					<?php if (( $this->_tpl_vars['submission']->getRecommendation() === null || $this->_tpl_vars['submission']->getRecommendation() === '' ) && ( ! $this->_tpl_vars['submission']->getCancelled() )): ?>
						<a class="action" href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'deleteReviewerVersion','path' => ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['reviewerFile']->getFileId(), $this->_tpl_vars['reviewerFile']->getRevision()) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['reviewerFile']->getFileId(), $this->_tpl_vars['reviewerFile']->getRevision()))), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.delete"), $this);?>
</a>
					<?php endif; ?>
				</td>
				</tr>
			<?php endforeach; else: ?>
				<tr valign="top">
				<td class="label" width="30%">
					<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.uploadedFile"), $this);?>

				</td>
				<td class="nodata">
					<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.none"), $this);?>

				</td>
				</tr>
			<?php endif; unset($_from); ?>
		</table>
		<?php if ($this->_tpl_vars['submission']->getRecommendation() === null || $this->_tpl_vars['submission']->getRecommendation() === ''): ?>
			<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'uploadReviewerVersion'), $this);?>
" enctype="multipart/form-data">
				<input type="hidden" name="reviewId" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />
				<input type="file" name="upload" <?php if (! $this->_tpl_vars['confirmedStatus'] || $this->_tpl_vars['declined'] || $this->_tpl_vars['submission']->getCancelled()): ?>disabled="disabled"<?php endif; ?> class="uploadField" />
				<input type="submit" name="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.upload"), $this);?>
" <?php if (! $this->_tpl_vars['confirmedStatus'] || $this->_tpl_vars['declined'] || $this->_tpl_vars['submission']->getCancelled()): ?>disabled="disabled"<?php endif; ?> class="button" />
			</form>

			<?php if ($this->_tpl_vars['currentJournal']->getSetting('showEnsuringLink')): ?>
			<span class="instruct">
				<a class="action" href="javascript:openHelp('<?php echo $this->_plugins['function']['get_help_id'][0][0]->smartyGetHelpId(array('key' => "editorial.sectionEditorsRole.review.blindPeerReview",'url' => 'true'), $this);?>
')"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.ensuringBlindReview"), $this);?>
</a>
			</span>
			<?php endif; ?>
		<?php endif; ?>
	</td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
<tr valign="top">
	<td><?php echo ((is_array($_tmp=$this->_tpl_vars['currentStep'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
.<?php $this->assign('currentStep', $this->_tpl_vars['currentStep']+1); ?></td>
	<td><span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.selectRecommendation"), $this);?>
</span></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td>
		<table class="data" width="100%">
			<tr valign="top">
				<td class="label" width="30%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.recommendation"), $this);?>
</td>
				<td class="value" width="70%">
				<?php if ($this->_tpl_vars['submission']->getRecommendation() !== null && $this->_tpl_vars['submission']->getRecommendation() !== ''): ?>
					<?php $this->assign('recommendation', $this->_tpl_vars['submission']->getRecommendation()); ?>
					<strong><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['reviewerRecommendationOptions'][$this->_tpl_vars['recommendation']]), $this);?>
</strong>&nbsp;&nbsp;
					<?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateCompleted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>

				<?php else: ?>
					<form name="recommendation" method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'recordRecommendation'), $this);?>
">
					<input type="hidden" name="reviewId" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />
					<select name="recommendation" <?php if (! $this->_tpl_vars['confirmedStatus'] || $this->_tpl_vars['declined'] || $this->_tpl_vars['submission']->getCancelled() || ( ! $this->_tpl_vars['reviewFormResponseExists'] && ! $this->_tpl_vars['reviewAssignment']->getMostRecentPeerReviewComment() && ! $this->_tpl_vars['uploadedFileExists'] )): ?>disabled="disabled"<?php endif; ?> class="selectMenu">
						<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['reviewerRecommendationOptions'],'selected' => ''), $this);?>

					</select>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="submit" name="submit" onclick="return confirmSubmissionCheck()" class="button" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.submitReview"), $this);?>
" <?php if (! $this->_tpl_vars['confirmedStatus'] || $this->_tpl_vars['declined'] || $this->_tpl_vars['submission']->getCancelled() || ( ! $this->_tpl_vars['reviewFormResponseExists'] && ! $this->_tpl_vars['reviewAssignment']->getMostRecentPeerReviewComment() && ! $this->_tpl_vars['uploadedFileExists'] )): ?>disabled="disabled"<?php endif; ?> />
					</form>					
				<?php endif; ?>
				</td>		
			</tr>
		</table>
	</td>
</tr>
</table>
</div>
<?php if ($this->_tpl_vars['journal']->getLocalizedSetting('reviewGuidelines') != ''): ?>
<div class="separator"></div>
<div id="reviewerGuidelines">
<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "reviewer.article.reviewerGuidelines"), $this);?>
</h3>
<p><?php echo ((is_array($_tmp=$this->_tpl_vars['journal']->getLocalizedSetting('reviewGuidelines'))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)); ?>
</p>
</div>
<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

