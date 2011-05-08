<?php /* Smarty version 2.6.26, created on 2011-05-08 16:00:59
         compiled from sectionEditor/submission/editorDecision.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'sectionEditor/submission/editorDecision.tpl', 42, false),array('function', 'url', 'sectionEditor/submission/editorDecision.tpl', 62, false),array('function', 'html_options_translate', 'sectionEditor/submission/editorDecision.tpl', 66, false),array('function', 'icon', 'sectionEditor/submission/editorDecision.tpl', 234, false),array('modifier', 'escape', 'sectionEditor/submission/editorDecision.tpl', 68, false),array('modifier', 'date_format', 'sectionEditor/submission/editorDecision.tpl', 177, false),array('modifier', 'assign', 'sectionEditor/submission/editorDecision.tpl', 229, false),)), $this); ?>
	
<?php $this->assign('proposalStatusKey', $this->_tpl_vars['submission']->getProposalStatusKey()); ?>
<?php $this->assign('proposalStatus', $this->_tpl_vars['submission']->getProposalStatus()); ?>


<?php if ($this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_ASSIGNED || ( $this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_REVIEWED && $this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_RESUBMIT )): ?>
	
	<div id="peerReview">
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "sectionEditor/submission/peerReview.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		<div class="separator"></div>
	</div>
<?php endif; ?>

<div id="editorDecision">
<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.editorDecision"), $this);?>
</h3>

<table id="table1" width="100%" class="data">

<tr valign="top">
	<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.proposalStatus"), $this);?>
</td>
	<td width="80%" class="value"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['proposalStatusKey']), $this);?>
</td>
</tr>

<tr valign="top">
	<?php if ($this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_SUBMITTED): ?>
		<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.selectInitialReview"), $this);?>
</td>
		<td width="80%" class="value">
			<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'recordDecision'), $this);?>
">
				<input type="hidden" name="articleId" value="<?php echo $this->_tpl_vars['submission']->getId(); ?>
" />
				<input type="hidden" name="lastDecisionId" value="<?php echo $this->_tpl_vars['lastDecisionArray']['editDecisionId']; ?>
" />
				<select name="decision" size="1" class="selectMenu">
					<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['initialReviewOptions'],'selected' => 1), $this);?>

				</select>
				<input type="submit" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.submissionReview.confirmInitialReview"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')" name="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.recordInitialReview"), $this);?>
"  class="button" />
			</form>
		</td>


	<?php elseif ($this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_CHECKED): ?>
		<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.selectExemptionDecision"), $this);?>
</td>
		<td width="80%" class="value">
			<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'recordDecision'), $this);?>
">
				<input type="hidden" name="articleId" value="<?php echo $this->_tpl_vars['submission']->getId(); ?>
" />
				<input type="hidden" name="lastDecisionId" value="<?php echo $this->_tpl_vars['lastDecisionArray']['editDecisionId']; ?>
" />
				<select name="decision" size="1" class="selectMenu">
					<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['exemptionOptions'],'selected' => 1), $this);?>

				</select>
				<input type="submit" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.submissionReview.confirmExemption"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')" name="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.recordExemptionDecision"), $this);?>
"  class="button" />
			</form>
		</td>


	<?php elseif ($this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_EXEMPTED || $this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_ASSIGNED): ?>
		<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.selectDecision"), $this);?>
</td>
		<td width="80%" class="value">
			<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'recordDecision'), $this);?>
">
				<input type="hidden" name="articleId" value="<?php echo $this->_tpl_vars['submission']->getId(); ?>
" />
				<input type="hidden" name="lastDecisionId" value="<?php echo $this->_tpl_vars['lastDecisionArray']['editDecisionId']; ?>
" />
				<select name="decision" size="1" class="selectMenu">
					<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['editorDecisionOptions'],'selected' => 1), $this);?>

				</select>
				<input type="submit" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.submissionReview.confirmDecision"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')" name="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.recordDecision"), $this);?>
"  class="button" />
			</form>
		</td>
	
	<?php elseif ($this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_RETURNED): ?>
		<?php if ($this->_tpl_vars['articleMoreRecent']): ?>
			<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.selectInitialReview"), $this);?>
</td>
			<td width="80%" class="value">
				<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'recordDecision'), $this);?>
">
					<input type="hidden" name="articleId" value="<?php echo $this->_tpl_vars['submission']->getId(); ?>
" />
					<input type="hidden" name="lastDecisionId" value="<?php echo $this->_tpl_vars['lastDecisionArray']['editDecisionId']; ?>
" />
					<select name="decision" size="1" class="selectMenu">
						<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['initialReviewOptions'],'selected' => 1), $this);?>

					</select>
					<input type="submit" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.submissionReview.confirmInitialReview"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')" name="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.recordInitialReview"), $this);?>
"  class="button" />
				</form>
			</td>
		<?php else: ?>
			<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.submissionStatus"), $this);?>
</td>
			<td width="80%" class="value"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.waitingForResubmission"), $this);?>
</td>
		<?php endif; ?>

	<?php elseif ($this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_REVIEWED && ( $this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_RESUBMIT || $this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS )): ?>	
		<?php if ($this->_tpl_vars['articleMoreRecent']): ?>
			<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.selectDecision"), $this);?>
</td>
			<td width="80%" class="value">
				<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'recordDecision'), $this);?>
">
					<input type="hidden" name="articleId" value="<?php echo $this->_tpl_vars['submission']->getId(); ?>
" />
					<input type="hidden" name="lastDecisionId" value="<?php echo $this->_tpl_vars['lastDecisionArray']['editDecisionId']; ?>
" />
					<select name="decision" size="1" class="selectMenu">
						<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['editorDecisionOptions'],'selected' => 1), $this);?>

					</select>
					<input type="submit" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.submissionReview.confirmDecision"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')" name="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.recordDecision"), $this);?>
"  class="button" />
				</form>
			</td>
		<?php else: ?>
			<td class="label" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.submissionStatus"), $this);?>
</td>
			<td width="80%" class="value"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.waitingForResubmission"), $this);?>
</td>
		<?php endif; ?>		
	<?php endif; ?>
</tr>

<?php if ($this->_tpl_vars['articleMoreRecent'] && ( ( $this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_RETURNED ) || ( $this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_REVIEWED && ( $this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_RESUBMIT || $this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS ) ) )): ?>
	<tr valign="top">
		<td class="label"></td>
		<?php $this->assign('articleLastModified', $this->_tpl_vars['submission']->getLastModified()); ?>
		<td width="80%" class="value"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.proposalResubmitted"), $this);?>
  <?php echo ((is_array($_tmp=$this->_tpl_vars['articleLastModified'])) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>

</td>
	</tr>
<?php endif; ?>

<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.decision"), $this);?>
</td>
	<td class="value">
		<?php if ($this->_tpl_vars['proposalStatus'] == PROPOSAL_STATUS_REVIEWED): ?>
			<?php $this->assign('decision', $this->_tpl_vars['lastDecisionArray']['decision']); ?>
			<?php if ($this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_ACCEPT): ?>
				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.decision.accept"), $this);?>

			<?php elseif ($this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_PENDING_REVISIONS): ?>
				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.decision.pendingRevisions"), $this);?>

			<?php elseif ($this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_RESUBMIT): ?>
				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.decision.resubmit"), $this);?>

			<?php elseif ($this->_tpl_vars['lastDecisionArray']['decision'] == SUBMISSION_EDITOR_DECISION_DECLINE): ?>
				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.decision.decline"), $this);?>

			<?php endif; ?>
			<?php echo ((is_array($_tmp=$this->_tpl_vars['lastDecisionArray']['dateDecided'])) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>

			<?php else: ?>
				<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.none"), $this);?>

		<?php endif; ?>
			</td>
</tr>



<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.notifyAuthor"), $this);?>
</td>
	<td class="value">
		<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'emailEditorDecisionComment','articleId' => $this->_tpl_vars['submission']->getId()), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'notifyAuthorUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'notifyAuthorUrl'));?>


		<?php if ($this->_tpl_vars['decision'] == SUBMISSION_EDITOR_DECISION_DECLINE): ?>
						<?php echo ((is_array($_tmp=((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.submissionReview.emailWillArchive"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'quotes') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'quotes')))) ? $this->_run_mod_handler('assign', true, $_tmp, 'confirmString') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'confirmString'));?>

			<?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','url' => $this->_tpl_vars['notifyAuthorUrl'],'onclick' => "return confirm('".($this->_tpl_vars['confirmString'])."')"), $this);?>

		<?php else: ?>
			<?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','url' => $this->_tpl_vars['notifyAuthorUrl']), $this);?>

		<?php endif; ?>

		&nbsp;&nbsp;&nbsp;&nbsp;
		<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.editorAuthorRecord"), $this);?>

		<?php if ($this->_tpl_vars['submission']->getMostRecentEditorDecisionComment()): ?>
			<?php $this->assign('comment', $this->_tpl_vars['submission']->getMostRecentEditorDecisionComment()); ?>
			<a href="javascript:openComments('<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'viewEditorDecisionComments','path' => $this->_tpl_vars['submission']->getId(),'anchor' => $this->_tpl_vars['comment']->getId()), $this);?>
');" class="icon"><?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'comment'), $this);?>
</a>&nbsp;&nbsp;<?php echo ((is_array($_tmp=$this->_tpl_vars['comment']->getDatePosted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>

		<?php else: ?>
			<a href="javascript:openComments('<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'viewEditorDecisionComments','path' => $this->_tpl_vars['submission']->getId()), $this);?>
');" class="icon"><?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'comment'), $this);?>
</a><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.noComments"), $this);?>

		<?php endif; ?>
	</td>
</tr>
</table>

<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editorReview'), $this);?>
" enctype="multipart/form-data">
<input type="hidden" name="articleId" value="<?php echo $this->_tpl_vars['submission']->getId(); ?>
" />
<?php $this->assign('authorFiles', $this->_tpl_vars['submission']->getAuthorFileRevisions($this->_tpl_vars['round'])); ?>
<?php $this->assign('editorFiles', $this->_tpl_vars['submission']->getEditorFileRevisions($this->_tpl_vars['round'])); ?>

<?php $this->assign('authorRevisionExists', false); ?>
<?php $_from = $this->_tpl_vars['authorFiles']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['authorFile']):
?>
	<?php $this->assign('authorRevisionExists', true); ?>
<?php endforeach; endif; unset($_from); ?>

<?php $this->assign('editorRevisionExists', false); ?>
<?php $_from = $this->_tpl_vars['editorFiles']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['editorFile']):
?>
	<?php $this->assign('editorRevisionExists', true); ?>
<?php endforeach; endif; unset($_from); ?>
<?php if ($this->_tpl_vars['reviewFile']): ?>
	<?php $this->assign('reviewVersionExists', 1); ?>
<?php endif; ?>


	</table>

</form>
</div>
