<?php /* Smarty version 2.6.26, created on 2011-05-01 16:03:15
         compiled from manager/reviewForms/reviewFormElementForm.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'manager/reviewForms/reviewFormElementForm.tpl', 24, false),array('function', 'url', 'manager/reviewForms/reviewFormElementForm.tpl', 34, false),array('function', 'fieldLabel', 'manager/reviewForms/reviewFormElementForm.tpl', 43, false),array('function', 'form_language_chooser', 'manager/reviewForms/reviewFormElementForm.tpl', 48, false),array('function', 'html_options_translate', 'manager/reviewForms/reviewFormElementForm.tpl', 74, false),array('modifier', 'escape', 'manager/reviewForms/reviewFormElementForm.tpl', 24, false),array('modifier', 'to_array', 'manager/reviewForms/reviewFormElementForm.tpl', 45, false),array('modifier', 'assign', 'manager/reviewForms/reviewFormElementForm.tpl', 45, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('pageId', "manager.reviewFormElements.reviewFormElementForm"); ?><?php echo ''; ?><?php $this->assign('pageCrumbTitle', $this->_tpl_vars['pageTitle']); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<script type="text/javascript">
<?php echo '
<!--
function togglePossibleResponses(newValue, multipleResponsesElementTypesString) {
	if (multipleResponsesElementTypesString.indexOf(\';\'+newValue+\';\') != -1) {
		document.reviewFormElementForm.addResponse.disabled=false;
	} else {
		if (document.reviewFormElementForm.addResponse.disabled == false) {
			alert('; ?>
'<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElement.changeType"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
'<?php echo ');
		}
		document.reviewFormElementForm.addResponse.disabled=true;
	}
}
// -->
'; ?>

</script>

<br/>
<form name="reviewFormElementForm" method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'updateReviewFormElement','anchor' => 'possibleResponses'), $this);?>
">
	<input type="hidden" name="reviewFormId" value="<?php echo $this->_tpl_vars['reviewFormId']; ?>
"/>
	<input type="hidden" name="reviewFormElementId" value="<?php echo $this->_tpl_vars['reviewFormElementId']; ?>
"/>

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
			<?php if ($this->_tpl_vars['reviewFormElementId']): ?><?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editReviewFormElement','path' => ((is_array($_tmp=$this->_tpl_vars['reviewFormId'])) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['reviewFormElementId']) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['reviewFormElementId'])),'escape' => false), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'reviewFormElementFormUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'reviewFormElementFormUrl'));?>

			<?php else: ?><?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'createReviewFormElement','path' => $this->_tpl_vars['reviewFormId'],'escape' => false), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'reviewFormElementFormUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'reviewFormElementFormUrl'));?>

			<?php endif; ?>
			<?php echo $this->_plugins['function']['form_language_chooser'][0][0]->smartyFormLanguageChooser(array('form' => 'reviewFormElementForm','url' => $this->_tpl_vars['reviewFormElementFormUrl']), $this);?>

			<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "form.formLanguage.description"), $this);?>
</span>
		</td>
	</tr>
<?php endif; ?>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'question','required' => 'true','key' => "manager.reviewFormElements.question"), $this);?>
</td>
	<td class="value"><textarea name="question[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
]" rows="4" cols="40" id="question" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['question'][$this->_tpl_vars['formLocale']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea></td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td class="value">
		<input type="checkbox" name="required" id="required" value="1" <?php if ($this->_tpl_vars['required']): ?>checked="checked"<?php endif; ?> />
		<?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'required','key' => "manager.reviewFormElements.required"), $this);?>

	</td>
</tr>
<tr valign="top">
	<td>&nbsp;</td>
	<td class="value">
		<input type="checkbox" name="included" id="included" value="1" <?php if ($this->_tpl_vars['included']): ?>checked="checked"<?php endif; ?> />
		<?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'included','key' => "manager.reviewFormElements.included"), $this);?>

	</td>
</tr>
<tr valign="top">
	<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'elementType','required' => 'true','key' => "manager.reviewFormElements.elementType"), $this);?>
</td>
	<td class="value">
		<select name="elementType" id="elementType" class="selectMenu" size="1" onchange="togglePossibleResponses(this.options[this.selectedIndex].value, '<?php echo $this->_tpl_vars['multipleResponsesElementTypesString']; ?>
')"><?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['reviewFormElementTypeOptions'],'selected' => $this->_tpl_vars['elementType']), $this);?>
</select>
	</td>
</tr>
<tr valign="top">
	<td class="label">&nbsp;</td>
	<td class="value">
		<a name="possibleResponses"></a>
		<?php $_from = $this->_tpl_vars['possibleResponses'][$this->_tpl_vars['formLocale']]; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['responses'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['responses']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['responseId'] => $this->_tpl_vars['responseItem']):
        $this->_foreach['responses']['iteration']++;
?>
			<?php if (! $this->_tpl_vars['notFirstResponseItem']): ?>
				<?php $this->assign('notFirstResponseItem', 1); ?>
				<table width="100%" class="data">
				<tr valign="top">
					<td width="5%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.order"), $this);?>
</td>
					<td width="95%" colspan="2"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements.possibleResponse"), $this);?>
</td>
				</tr>
			<?php endif; ?>
				<tr valign="top">
					<td width="5%" class="label"><input type="text" name="possibleResponses[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
][<?php echo ((is_array($_tmp=$this->_tpl_vars['responseId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
][order]" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['responseItem']['order'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="3" maxlength="2" class="textField" /></td>
					<td class="value"><textarea name="possibleResponses[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
][<?php echo ((is_array($_tmp=$this->_tpl_vars['responseId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
][content]" id="possibleResponses-<?php echo $this->_tpl_vars['responseId']; ?>
" rows="3" cols="40" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['responseItem']['content'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea></td>
					<td width="100%"><input type="submit" name="delResponse[<?php echo $this->_tpl_vars['responseId']; ?>
]" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.delete"), $this);?>
" class="button" /></td>
				</tr>
		<?php endforeach; endif; unset($_from); ?>

		<?php if ($this->_tpl_vars['notFirstResponseItem']): ?>
				</table>
		<?php endif; ?>
		<br/>
		<input type="submit" name="addResponse" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements.addResponseItem"), $this);?>
" class="button" <?php if (! in_array ( $this->_tpl_vars['elementType'] , $this->_tpl_vars['multipleResponsesElementTypes'] )): ?>disabled="disabled"<?php endif; ?>/>
	</td>
</tr>
</table>

<p><input type="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.save"), $this);?>
" class="button defaultButton" /> <input type="button" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.cancel"), $this);?>
" class="button" onclick="document.location.href='<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'reviewFormElements','path' => $this->_tpl_vars['reviewFormId'],'escape' => false), $this);?>
'" /></p>
</form>

<p><span class="formRequired"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.requiredField"), $this);?>
</span></p>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
