<?php /* Smarty version 2.6.26, created on 2011-06-06 10:46:08
         compiled from manager/reviewForms/reviewFormForm.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'url', 'manager/reviewForms/reviewFormForm.tpl', 16, false),array('function', 'translate', 'manager/reviewForms/reviewFormForm.tpl', 16, false),array('function', 'fieldLabel', 'manager/reviewForms/reviewFormForm.tpl', 34, false),array('function', 'form_language_chooser', 'manager/reviewForms/reviewFormForm.tpl', 39, false),array('modifier', 'assign', 'manager/reviewForms/reviewFormForm.tpl', 36, false),array('modifier', 'escape', 'manager/reviewForms/reviewFormForm.tpl', 46, false),)), $this); ?>
<?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<?php if ($this->_tpl_vars['reviewFormId']): ?>
	<ul class="menu">
		<li class="current"><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editReviewForm','path' => $this->_tpl_vars['reviewFormId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewForms.edit"), $this);?>
</a></li>
		<li><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'reviewFormElements','path' => $this->_tpl_vars['reviewFormId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements"), $this);?>
</a></li>
		<li><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'previewReviewForm','path' => $this->_tpl_vars['reviewFormId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewForms.preview"), $this);?>
</a></li>
	</ul>
<?php endif; ?>

<br/>

<form name="reviewFormForm" method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'updateReviewForm'), $this);?>
">
<?php if ($this->_tpl_vars['reviewFormId']): ?>
	<input type="hidden" name="reviewFormId" value="<?php echo $this->_tpl_vars['reviewFormId']; ?>
"/>
<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/formErrors.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<table class="data" width="100%">
<?php if (count ( $this->_tpl_vars['formLocales'] ) > 1): ?>
	<tr valign="top">
		<td width="20%" class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'formLocale','key' => "form.formLanguage"), $this);?>
</td>
		<td width="80%" class="value">
			<?php if ($this->_tpl_vars['reviewFormId']): ?><?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editReviewForm','path' => $this->_tpl_vars['reviewFormId'],'escape' => false), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'reviewFormFormUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'reviewFormFormUrl'));?>

			<?php else: ?><?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'createReviewForm','escape' => false), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'reviewFormFormUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'reviewFormFormUrl'));?>

			<?php endif; ?>
			<?php echo $this->_plugins['function']['form_language_chooser'][0][0]->smartyFormLanguageChooser(array('form' => 'reviewFormForm','url' => $this->_tpl_vars['reviewFormFormUrl']), $this);?>

			<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "form.formLanguage.description"), $this);?>
</span>
		</td>
	</tr>
<?php endif; ?>
<tr valign="top">
	<td width="20%" class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'title','required' => 'true','key' => "manager.reviewForms.title"), $this);?>
</td>
	<td width="80%" class="value"><input type="text" name="title[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
]" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['title'][$this->_tpl_vars['formLocale']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" id="title" size="40" maxlength="120" class="textField" /></td>
</tr>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'description','key' => "manager.reviewForms.description"), $this);?>
</td>
	<td class="value"><textarea name="description[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
]" rows="4" cols="40" id="description" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['description'][$this->_tpl_vars['formLocale']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea></td>
</tr>
</table>

<p><input type="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.save"), $this);?>
" class="button defaultButton" /> <input type="button" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.cancel"), $this);?>
" class="button" onclick="document.location.href='<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'reviewForms','escape' => false), $this);?>
'" /></p>
</form>

<p><span class="formRequired"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.requiredField"), $this);?>
</span></p>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
