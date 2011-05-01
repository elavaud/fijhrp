<?php /* Smarty version 2.6.26, created on 2011-05-01 16:03:14
         compiled from manager/reviewForms/reviewFormElements.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'url', 'manager/reviewForms/reviewFormElements.tpl', 18, false),array('function', 'translate', 'manager/reviewForms/reviewFormElements.tpl', 40, false),array('function', 'page_info', 'manager/reviewForms/reviewFormElements.tpl', 84, false),array('function', 'page_links', 'manager/reviewForms/reviewFormElements.tpl', 85, false),array('function', 'html_options', 'manager/reviewForms/reviewFormElements.tpl', 92, false),array('block', 'iterate', 'manager/reviewForms/reviewFormElements.tpl', 61, false),array('modifier', 'escape', 'manager/reviewForms/reviewFormElements.tpl', 64, false),array('modifier', 'truncate', 'manager/reviewForms/reviewFormElements.tpl', 65, false),array('modifier', 'to_array', 'manager/reviewForms/reviewFormElements.tpl', 67, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('pageTitle', "manager.reviewFormElements"); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>

<script type="text/javascript">
<?php echo '
$(document).ready(function() { setupTableDND("#reviewFormElementsTable",
'; ?>

"<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'moveReviewFormElement'), $this);?>
"
<?php echo '
); });
'; ?>

</script>

<script type="text/javascript">
<?php echo '
<!--
function toggleChecked() {
	var elements = document.reviewFormElements.elements;
	for (var i=0; i < elements.length; i++) {
		if (elements[i].name == \'copy[]\') {
			elements[i].checked = !elements[i].checked;
		}
	}
}
// -->
'; ?>

</script>

<ul class="menu">
	<li><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editReviewForm','path' => $this->_tpl_vars['reviewFormId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewForms.edit"), $this);?>
</a></li>
	<li class="current"><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'reviewFormElements','path' => $this->_tpl_vars['reviewFormId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements"), $this);?>
</a></li>
	<li><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'previewReviewForm','path' => $this->_tpl_vars['reviewFormId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewForms.preview"), $this);?>
</a></li>
</ul>

<br/>

<div id="reviewFormElements">
<form name="reviewFormElements" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'copyReviewFormElement'), $this);?>
" method="post">
<table width="100%" class="listing" id="reviewFormElementsTable">
	<tr>
		<td class="headseparator" colspan="3">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="3%">&nbsp;</td>
		<td width="77%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements.question"), $this);?>
</td>
		<td width="20%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.action"), $this);?>
</td>
	</tr>
	<tr>
		<td class="headseparator" colspan="3">&nbsp;</td>
	</tr>
<?php $this->_tag_stack[] = array('iterate', array('from' => 'reviewFormElements','item' => 'reviewFormElement','name' => 'reviewFormElements')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
<?php $this->assign('reviewFormElementExists', 1); ?>
	<tr valign="top" id="formelt-<?php echo $this->_tpl_vars['reviewFormElement']->getId(); ?>
" class="data">
		<td><input type="checkbox" name="copy[]" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['reviewFormElement']->getId())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
"/></td>
		<td class="drag"><?php echo ((is_array($_tmp=$this->_tpl_vars['reviewFormElement']->getLocalizedQuestion())) ? $this->_run_mod_handler('truncate', true, $_tmp, 200, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 200, "...")); ?>
</td>
		<td class="nowrap">
			<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editReviewFormElement','path' => ((is_array($_tmp=$this->_tpl_vars['reviewFormElement']->getReviewFormId())) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['reviewFormElement']->getId()) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['reviewFormElement']->getId()))), $this);?>
" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.edit"), $this);?>
</a>&nbsp;|&nbsp;<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'deleteReviewFormElement','path' => ((is_array($_tmp=$this->_tpl_vars['reviewFormElement']->getReviewFormId())) ? $this->_run_mod_handler('to_array', true, $_tmp, $this->_tpl_vars['reviewFormElement']->getId()) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp, $this->_tpl_vars['reviewFormElement']->getId()))), $this);?>
" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements.confirmDelete"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.delete"), $this);?>
</a>&nbsp;|&nbsp;<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'moveReviewFormElement','d' => 'u','id' => $this->_tpl_vars['reviewFormElement']->getId()), $this);?>
" class="action">&uarr;</a>&nbsp;<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'moveReviewFormElement','d' => 'd','reviewFormElementId' => $this->_tpl_vars['reviewFormElement']->getId()), $this);?>
" class="action">&darr;</a>
		</td>
	</tr>
  <?php if ($this->_tpl_vars['reviewFormElements']->eof()): ?>
    <tr><td class="endseparator" colspan="3"></td></tr>
  <?php endif; ?>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>

<?php if ($this->_tpl_vars['reviewFormElements']->wasEmpty()): ?>
	<tr>
		<td colspan="3" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements.noneCreated"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="3" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="2" align="left"><?php echo $this->_plugins['function']['page_info'][0][0]->smartyPageInfo(array('iterator' => $this->_tpl_vars['reviewFormElements']), $this);?>
</td>
		<td align="right"><?php echo $this->_plugins['function']['page_links'][0][0]->smartyPageLinks(array('anchor' => 'reviewFormElements','name' => 'reviewFormElements','iterator' => $this->_tpl_vars['reviewFormElements']), $this);?>
</td>
	</tr>
<?php endif; ?>

</table>

<?php if ($this->_tpl_vars['reviewFormElementExists']): ?>
	<p><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements.copyTo"), $this);?>
&nbsp;<select name="targetReviewForm" class="selectMenu" size="1"><?php echo smarty_function_html_options(array('options' => $this->_tpl_vars['unusedReviewFormTitles']), $this);?>
</select>&nbsp;<input type="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.copy"), $this);?>
" class="button defaultButton"/>&nbsp;<input type="button" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.selectAll"), $this);?>
" class="button" onclick="toggleChecked()" /></p>
<?php endif; ?>
</form>

<br />

<a class="action" href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'createReviewFormElement','path' => $this->_tpl_vars['reviewFormId']), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.reviewFormElements.create"), $this);?>
</a>
</div>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
