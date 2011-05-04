<?php /* Smarty version 2.6.26, created on 2011-05-04 00:36:27
         compiled from editor/selectSectionEditor.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'concat', 'editor/selectSectionEditor.tpl', 12, false),array('modifier', 'translate', 'editor/selectSectionEditor.tpl', 16, false),array('modifier', 'escape', 'editor/selectSectionEditor.tpl', 27, false),array('function', 'translate', 'editor/selectSectionEditor.tpl', 16, false),array('function', 'url', 'editor/selectSectionEditor.tpl', 18, false),array('function', 'html_options_translate', 'editor/selectSectionEditor.tpl', 20, false),array('function', 'page_info', 'editor/selectSectionEditor.tpl', 80, false),array('function', 'page_links', 'editor/selectSectionEditor.tpl', 81, false),array('block', 'iterate', 'editor/selectSectionEditor.tpl', 43, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('pageTitle', ((is_array($_tmp=$this->_tpl_vars['roleName'])) ? $this->_run_mod_handler('concat', true, $_tmp, 's') : $this->_plugins['modifier']['concat'][0][0]->smartyConcat($_tmp, 's'))); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.selectEditor",'roleName' => ((is_array($_tmp=$this->_tpl_vars['roleName'])) ? $this->_run_mod_handler('translate', true, $_tmp) : Locale::translate($_tmp))), $this);?>
</h3>

<form name="submit" method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'assignEditor','path' => $this->_tpl_vars['rolePath'],'articleId' => $this->_tpl_vars['articleId']), $this);?>
">
	<select name="searchField" size="1" class="selectMenu">
		<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['fieldOptions'],'selected' => $this->_tpl_vars['searchField']), $this);?>

	</select>
	<select name="searchMatch" size="1" class="selectMenu">
		<option value="contains"<?php if ($this->_tpl_vars['searchMatch'] == 'contains'): ?> selected="selected"<?php endif; ?>><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "form.contains"), $this);?>
</option>
		<option value="is"<?php if ($this->_tpl_vars['searchMatch'] == 'is'): ?> selected="selected"<?php endif; ?>><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "form.is"), $this);?>
</option>
		<option value="startsWith"<?php if ($this->_tpl_vars['searchMatch'] == 'startsWith'): ?> selected="selected"<?php endif; ?>><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "form.startsWith"), $this);?>
</option>
	</select>
	<input type="text" name="search" class="textField" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['search'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />&nbsp;<input type="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.search"), $this);?>
" class="button" />
</form>

<p><?php $_from = $this->_tpl_vars['alphaList']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['letter']):
?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'assignEditor','path' => $this->_tpl_vars['rolePath'],'articleId' => $this->_tpl_vars['articleId'],'searchInitial' => $this->_tpl_vars['letter']), $this);?>
"><?php if ($this->_tpl_vars['letter'] == $this->_tpl_vars['searchInitial']): ?><strong><?php echo ((is_array($_tmp=$this->_tpl_vars['letter'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</strong><?php else: ?><?php echo ((is_array($_tmp=$this->_tpl_vars['letter'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php endif; ?></a> <?php endforeach; endif; unset($_from); ?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'assignEditor','articleId' => $this->_tpl_vars['articleId']), $this);?>
"><?php if ($this->_tpl_vars['searchInitial'] == ''): ?><strong><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.all"), $this);?>
</strong><?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.all"), $this);?>
<?php endif; ?></a></p>

<div id="editors">
<table width="100%" class="listing">
<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
<tr valign="bottom">
	<td class="heading" width="30%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.name"), $this);?>
</td>
	<td class="heading" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "section.sections"), $this);?>
</td>
	<td class="heading" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.completed"), $this);?>
</td>
	<td class="heading" width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.active"), $this);?>
</td>
	<td class="heading" width="10%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.action"), $this);?>
</td>
</tr>
<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
<?php $this->_tag_stack[] = array('iterate', array('from' => 'editors','item' => 'editor')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
<?php $this->assign('editorId', $this->_tpl_vars['editor']->getId()); ?>
<tr valign="top">
	<td><a class="action" href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'userProfile','path' => $this->_tpl_vars['editorId']), $this);?>
"><?php echo ((is_array($_tmp=$this->_tpl_vars['editor']->getFullName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</a></td>
	<td>
		<?php $this->assign('thisEditorSections', $this->_tpl_vars['editorSections'][$this->_tpl_vars['editorId']]); ?>
		<?php $_from = $this->_tpl_vars['thisEditorSections']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['section']):
?>
			<?php echo ((is_array($_tmp=$this->_tpl_vars['section']->getLocalizedAbbrev())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
&nbsp;
		<?php endforeach; else: ?>
			&mdash;
		<?php endif; unset($_from); ?>
	</td>
	<td>
		<?php if ($this->_tpl_vars['editorStatistics'][$this->_tpl_vars['editorId']] && $this->_tpl_vars['editorStatistics'][$this->_tpl_vars['editorId']]['complete']): ?>
			<?php echo $this->_tpl_vars['editorStatistics'][$this->_tpl_vars['editorId']]['complete']; ?>

		<?php else: ?>
			0
		<?php endif; ?>
	</td>
	<td>
		<?php if ($this->_tpl_vars['editorStatistics'][$this->_tpl_vars['editorId']] && $this->_tpl_vars['editorStatistics'][$this->_tpl_vars['editorId']]['incomplete']): ?>
			<?php echo $this->_tpl_vars['editorStatistics'][$this->_tpl_vars['editorId']]['incomplete']; ?>

		<?php else: ?>
			0
		<?php endif; ?>
	</td>
	<td><a class="action" href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'assignEditor','articleId' => $this->_tpl_vars['articleId'],'editorId' => $this->_tpl_vars['editorId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.assign"), $this);?>
</a></td>
</tr>
<tr><td colspan="5" class="<?php if ($this->_tpl_vars['editors']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td></tr>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['editors']->wasEmpty()): ?>
<tr>
<td colspan="5" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.noneEnrolled"), $this);?>
</td>
</tr>
<tr><td colspan="5" class="<?php if ($this->_tpl_vars['editors']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td></tr>
<?php else: ?>
	<tr>
		<td colspan="2" align="left"><?php echo $this->_plugins['function']['page_info'][0][0]->smartyPageInfo(array('iterator' => $this->_tpl_vars['editors']), $this);?>
</td>
		<td colspan="3" align="right"><?php echo $this->_plugins['function']['page_links'][0][0]->smartyPageLinks(array('anchor' => 'editors','name' => 'editors','iterator' => $this->_tpl_vars['editors'],'searchInitial' => $this->_tpl_vars['searchInitial'],'searchField' => $this->_tpl_vars['searchField'],'searchMatch' => $this->_tpl_vars['searchMatch'],'search' => $this->_tpl_vars['search'],'dateFromDay' => $this->_tpl_vars['dateFromDay'],'dateFromYear' => $this->_tpl_vars['dateFromYear'],'dateFromMonth' => $this->_tpl_vars['dateFromMonth'],'dateToDay' => $this->_tpl_vars['dateToDay'],'dateToYear' => $this->_tpl_vars['dateToYear'],'dateToMonth' => $this->_tpl_vars['dateToMonth'],'articleId' => $this->_tpl_vars['articleId']), $this);?>
</td>
	</tr>
<?php endif; ?>
</table>
</div>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
