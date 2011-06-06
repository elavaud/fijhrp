<?php /* Smarty version 2.6.26, created on 2011-06-05 21:26:00
         compiled from user/index.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'url', 'user/index.tpl', 18, false),array('function', 'translate', 'user/index.tpl', 18, false),array('function', 'call_hook', 'user/index.tpl', 19, false),array('modifier', 'escape', 'user/index.tpl', 26, false),array('modifier', 'assign', 'user/index.tpl', 177, false),array('modifier', 'date_format', 'user/index.tpl', 228, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('pageTitle', "user.userHome"); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<?php if ($this->_tpl_vars['isSiteAdmin']): ?>
	<?php $this->assign('hasRole', 1); ?>
	&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => 'index','page' => $this->_tpl_vars['isSiteAdmin']->getRolePath()), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['isSiteAdmin']->getRoleName()), $this);?>
</a>
	<?php echo $this->_plugins['function']['call_hook'][0][0]->smartyCallHook(array('name' => "Templates::User::Index::Site"), $this);?>

<?php endif; ?>

<div id="myJournals">
<?php if (! $this->_tpl_vars['currentJournal']): ?><h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.myJournals"), $this);?>
</h3><?php endif; ?>

<?php $_from = $this->_tpl_vars['userJournals']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['journal']):
?>
	<div id="journal-<?php echo ((is_array($_tmp=$this->_tpl_vars['journal']->getPath())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
">
	<?php $this->assign('hasRole', 1); ?>
	<?php if (! $this->_tpl_vars['currentJournal']): ?><h4><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journal']->getPath(),'page' => 'user'), $this);?>
"><?php echo ((is_array($_tmp=$this->_tpl_vars['journal']->getLocalizedTitle())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</a></h4>
	<?php else: ?><h3><?php echo ((is_array($_tmp=$this->_tpl_vars['journal']->getLocalizedTitle())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</h3><?php endif; ?>
	<?php $this->assign('journalId', $this->_tpl_vars['journal']->getId()); ?>
	<?php $this->assign('journalPath', $this->_tpl_vars['journal']->getPath()); ?>
	<table width="100%" class="info">
		<?php if ($this->_tpl_vars['isValid']['JournalManager'][$this->_tpl_vars['journalId']]): ?>
			<tr>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'manager'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.manager"), $this);?>
</a></td>
				<td></td>
				<td></td>
				<td></td>
				<td align="right"><?php if ($this->_tpl_vars['setupIncomplete'][$this->_tpl_vars['journalId']]): ?>[<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'manager','op' => 'setup','path' => '1'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.setup"), $this);?>
</a>]<?php endif; ?></td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['SubscriptionManager'][$this->_tpl_vars['journalId']]): ?>
			<tr>
				<td width="20%" colspan="5">&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'subscriptionManager'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.subscriptionManager"), $this);?>
</a></td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['Editor'][$this->_tpl_vars['journalId']] || $this->_tpl_vars['isValid']['SectionEditor'][$this->_tpl_vars['journalId']] || $this->_tpl_vars['isValid']['LayoutEditor'][$this->_tpl_vars['journalId']] || $this->_tpl_vars['isValid']['Copyeditor'][$this->_tpl_vars['journalId']] || $this->_tpl_vars['isValid']['Proofreader'][$this->_tpl_vars['journalId']]): ?>
			<tr><td class="separator" width="100%" colspan="5">&nbsp;</td></tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['Editor'][$this->_tpl_vars['journalId']]): ?>
			<tr>
				<?php $this->assign('editorSubmissionsCount', $this->_tpl_vars['submissionsCount']['Editor'][$this->_tpl_vars['journalId']]); ?>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'editor'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.editor"), $this);?>
</a></td>
				<td><?php if ($this->_tpl_vars['editorSubmissionsCount'][0]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'editor','op' => 'submissions','path' => 'submissionsUnassigned'), $this);?>
"><?php echo $this->_tpl_vars['editorSubmissionsCount'][0]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsUnassigned"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsUnassigned"), $this);?>
</span><?php endif; ?>
				</td>
				<td><?php if ($this->_tpl_vars['editorSubmissionsCount'][1]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'editor','op' => 'submissions','path' => 'submissionsInReview'), $this);?>
"><?php echo $this->_tpl_vars['editorSubmissionsCount'][1]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInReview"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInReview"), $this);?>
</span><?php endif; ?>
				</td>
				<td><?php if ($this->_tpl_vars['editorSubmissionsCount'][2]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'editor','op' => 'submissions','path' => 'submissionsInEditing'), $this);?>
"><?php echo $this->_tpl_vars['editorSubmissionsCount'][2]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</span><?php endif; ?>
				</td>
				<td align="right">[<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'editor','op' => 'createIssue'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.issues.createIssue"), $this);?>
</a>] [<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'editor','op' => 'notifyUsers'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.notifyUsers"), $this);?>
</a>]</td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['SectionEditor'][$this->_tpl_vars['journalId']]): ?>
			<?php $this->assign('sectionEditorSubmissionsCount', $this->_tpl_vars['submissionsCount']['SectionEditor'][$this->_tpl_vars['journalId']]); ?>
			<tr>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'sectionEditor'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.sectionEditor"), $this);?>
</a></td>
				<td></td>
				<td><?php if ($this->_tpl_vars['sectionEditorSubmissionsCount'][0]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'sectionEditor','op' => 'index','path' => 'submissionsInReview'), $this);?>
"><?php echo $this->_tpl_vars['sectionEditorSubmissionsCount'][0]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInReview"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInReview"), $this);?>
</span><?php endif; ?>
				</td>
				<td><?php if ($this->_tpl_vars['sectionEditorSubmissionsCount'][1]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'sectionEditor','op' => 'index','path' => 'submissionsInEditing'), $this);?>
"><?php echo $this->_tpl_vars['sectionEditorSubmissionsCount'][1]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</span><?php endif; ?>
				</td>
				<td align="right"></td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['LayoutEditor'][$this->_tpl_vars['journalId']]): ?>
			<?php $this->assign('layoutEditorSubmissionsCount', $this->_tpl_vars['submissionsCount']['LayoutEditor'][$this->_tpl_vars['journalId']]); ?>
			<tr>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'layoutEditor'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.layoutEditor"), $this);?>
</a></td>
				<td></td>
				<td></td>
				<td><?php if ($this->_tpl_vars['layoutEditorSubmissionsCount'][0]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'layoutEditor','op' => 'submissions'), $this);?>
"><?php echo $this->_tpl_vars['layoutEditorSubmissionsCount'][0]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</span><?php endif; ?>
				</td>
				<td align="right"></td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['Copyeditor'][$this->_tpl_vars['journalId']]): ?>
			<?php $this->assign('copyeditorSubmissionsCount', $this->_tpl_vars['submissionsCount']['Copyeditor'][$this->_tpl_vars['journalId']]); ?>
			<tr>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'copyeditor'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.copyeditor"), $this);?>
</a></td>
				<td></td>
				<td></td>
				<td><?php if ($this->_tpl_vars['copyeditorSubmissionsCount'][0]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'copyeditor'), $this);?>
"><?php echo $this->_tpl_vars['copyeditorSubmissionsCount'][0]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</span><?php endif; ?>
				</td>
				<td align="right"></td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['Proofreader'][$this->_tpl_vars['journalId']]): ?>
			<?php $this->assign('proofreaderSubmissionsCount', $this->_tpl_vars['submissionsCount']['Proofreader'][$this->_tpl_vars['journalId']]); ?>
			<tr>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'proofreader'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.proofreader"), $this);?>
</a></td>
				<td></td>
				<td></td>
				<td><?php if ($this->_tpl_vars['proofreaderSubmissionsCount'][0]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'proofreader'), $this);?>
"><?php echo $this->_tpl_vars['proofreaderSubmissionsCount'][0]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.submissionsInEditing"), $this);?>
</span><?php endif; ?>
				</td>
				<td align="right"></td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['Author'][$this->_tpl_vars['journalId']] || $this->_tpl_vars['isValid']['Reviewer'][$this->_tpl_vars['journalId']]): ?>
			<tr><td class="separator" width="100%" colspan="5">&nbsp;</td></tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['Author'][$this->_tpl_vars['journalId']]): ?>
			<?php $this->assign('authorSubmissionsCount', $this->_tpl_vars['submissionsCount']['Author'][$this->_tpl_vars['journalId']]); ?>
			<tr>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'author'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.author"), $this);?>
</a></td>
				<td></td>
				<td></td>
				<td><?php if ($this->_tpl_vars['authorSubmissionsCount'][0]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'author'), $this);?>
"><?php echo $this->_tpl_vars['authorSubmissionsCount'][0]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.active"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.active"), $this);?>
</span><?php endif; ?>
				</td>
				<td align="right">[<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'author','op' => 'submit'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submit"), $this);?>
</a>]</td>
			</tr>
		<?php endif; ?>
		<?php if ($this->_tpl_vars['isValid']['Reviewer'][$this->_tpl_vars['journalId']]): ?>
			<?php $this->assign('reviewerSubmissionsCount', $this->_tpl_vars['submissionsCount']['Reviewer'][$this->_tpl_vars['journalId']]); ?>
			<tr>
				<td>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'reviewer'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.reviewer"), $this);?>
</a></td>
				<td></td>
				<td></td>
				<td><?php if ($this->_tpl_vars['reviewerSubmissionsCount'][0]): ?>
						<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['journalPath'],'page' => 'reviewer'), $this);?>
"><?php echo $this->_tpl_vars['reviewerSubmissionsCount'][0]; ?>
 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.active"), $this);?>
</a>
					<?php else: ?><span class="disabled">0 <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.active"), $this);?>
</span><?php endif; ?>
				</td>
				<td align="right"></td>
			</tr>
		<?php endif; ?>
				<tr>
			<td width="25%"></td>
			<td width="12%"></td>
			<td width="12%"></td>
			<td width="12%"></td>
			<td width="39%"></td>
		</tr>
			
	</table>
	<?php echo $this->_plugins['function']['call_hook'][0][0]->smartyCallHook(array('name' => "Templates::User::Index::Journal",'journal' => $this->_tpl_vars['journal']), $this);?>

	</div>
<?php endforeach; endif; unset($_from); ?>
</div>	


<?php if (! $this->_tpl_vars['hasRole']): ?>
	<?php if ($this->_tpl_vars['currentJournal']): ?>
		<div id="noRolesForJournal">
		<p><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.noRoles.noRolesForJournal"), $this);?>
</p>
		<ul class="plain">
			<li>
				&#187;
				<?php if ($this->_tpl_vars['allowRegAuthor']): ?>
					<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'author','op' => 'submit'), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'submitUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'submitUrl'));?>

					<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'become','path' => 'author','source' => $this->_tpl_vars['submitUrl']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.noRoles.submitArticle"), $this);?>
</a>
				<?php else: ?>					<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.noRoles.submitArticleRegClosed"), $this);?>

				<?php endif; ?>			</li>
			<li>
				&#187;
				<?php if ($this->_tpl_vars['allowRegReviewer']): ?>
					<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'index'), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'userHomeUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'userHomeUrl'));?>

					<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'become','path' => 'reviewer','source' => $this->_tpl_vars['userHomeUrl']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.noRoles.regReviewer"), $this);?>
</a>
				<?php else: ?>					<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.noRoles.regReviewerClosed"), $this);?>

				<?php endif; ?>			</li>
		</ul>
		</div>
	<?php else: ?>		<div id="currentJournal">
		<p><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.noRoles.chooseJournal"), $this);?>
</p>
		<ul class="plain">
			<?php $_from = $this->_tpl_vars['allJournals']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['thisJournal']):
?>
				<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => $this->_tpl_vars['thisJournal']->getPath(),'page' => 'user','op' => 'index'), $this);?>
"><?php echo ((is_array($_tmp=$this->_tpl_vars['thisJournal']->getLocalizedTitle())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</a></li>
			<?php endforeach; endif; unset($_from); ?>
		</ul>
		</div>
	<?php endif; ?><?php endif; ?>
<div id="myAccount">
<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.myAccount"), $this);?>
</h3>
<ul class="plain">
	<?php if ($this->_tpl_vars['hasOtherJournals']): ?>
		<?php if (! $this->_tpl_vars['showAllJournals']): ?>
			<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('journal' => 'index','page' => 'user'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.showAllJournals"), $this);?>
</a></li>
		<?php endif; ?>
	<?php endif; ?>
	<?php if ($this->_tpl_vars['currentJournal']): ?>
		<?php if ($this->_tpl_vars['subscriptionsEnabled']): ?>
			<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'subscriptions'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.manageMySubscriptions"), $this);?>
</a></li>
		<?php endif; ?>
	<?php endif; ?>
	<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'profile'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.editMyProfile"), $this);?>
</a></li>

	<?php if (! $this->_tpl_vars['implicitAuth']): ?>
		<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'changePassword'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.changeMyPassword"), $this);?>
</a></li>
	<?php endif; ?>

	<?php if ($this->_tpl_vars['currentJournal']): ?>
		<?php if ($this->_tpl_vars['journalPaymentsEnabled'] && $this->_tpl_vars['membershipEnabled']): ?>
			<?php if ($this->_tpl_vars['dateEndMembership']): ?>
				<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'payMembership'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.membership.renewMembership"), $this);?>
</a> (<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.membership.ends"), $this);?>
: <?php echo ((is_array($_tmp=$this->_tpl_vars['dateEndMembership'])) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatShort']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatShort'])); ?>
)</li>
			<?php else: ?>
				<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'payMembership'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.membership.buyMembership"), $this);?>
</a></li>		
			<?php endif; ?>
		<?php endif; ?>	<?php endif; ?>
	<li>&#187; <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'login','op' => 'signOut'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.logOut"), $this);?>
</a></li>
	<?php echo $this->_plugins['function']['call_hook'][0][0]->smartyCallHook(array('name' => "Templates::User::Index::MyAccount"), $this);?>

</ul>
</div>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
