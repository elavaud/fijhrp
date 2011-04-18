<?php /* Smarty version 2.6.26, created on 2011-04-15 08:15:46
         compiled from core:common/footer.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'core:common/footer.tpl', 11, false),array('function', 'call_hook', 'core:common/footer.tpl', 17, false),array('function', 'get_debug_info', 'core:common/footer.tpl', 22, false),array('modifier', 'assign', 'core:common/footer.tpl', 27, false),array('modifier', 'escape', 'core:common/footer.tpl', 33, false),array('modifier', 'default', 'core:common/footer.tpl', 33, false),)), $this); ?>
<?php if ($this->_tpl_vars['displayCreativeCommons']): ?>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.ccLicense"), $this);?>

<?php endif; ?>
<?php if ($this->_tpl_vars['pageFooter']): ?>
<br /><br />
<?php echo $this->_tpl_vars['pageFooter']; ?>

<?php endif; ?>
<?php echo $this->_plugins['function']['call_hook'][0][0]->smartyCallHook(array('name' => "Templates::Common::Footer::PageFooter"), $this);?>

</div><!-- content -->
</div><!-- main -->
</div><!-- body -->

<?php echo $this->_plugins['function']['get_debug_info'][0][0]->smartyGetDebugInfo(array(), $this);?>

<?php if ($this->_tpl_vars['enableDebugStats']): ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => $this->_tpl_vars['pqpTemplate'], 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php endif; ?>

</div><!-- container -->
<?php if (! empty ( $this->_tpl_vars['systemNotifications'] )): ?>
	<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "notification.notification"), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'defaultTitleText') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'defaultTitleText'));?>

	<script type="text/javascript">
	<!--
	<?php $_from = $this->_tpl_vars['systemNotifications']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['notification']):
?>
		<?php echo '
			$.pnotify({
				pnotify_title: \''; ?>
<?php if ($this->_tpl_vars['notification']->getIsLocalized()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['notification']->getTitle()), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'js') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'js')))) ? $this->_run_mod_handler('default', true, $_tmp, @$this->_tpl_vars['defaultTitleText']) : smarty_modifier_default($_tmp, @$this->_tpl_vars['defaultTitleText']));?>
<?php else: ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['notification']->getTitle())) ? $this->_run_mod_handler('escape', true, $_tmp, 'js') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'js')))) ? $this->_run_mod_handler('default', true, $_tmp, @$this->_tpl_vars['defaultTitleText']) : smarty_modifier_default($_tmp, @$this->_tpl_vars['defaultTitleText'])); ?>
<?php endif; ?><?php echo '\',
				pnotify_text: \''; ?>
<?php if ($this->_tpl_vars['notification']->getIsLocalized()): ?><?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['notification']->getContents(),'param' => $this->_tpl_vars['notification']->getParam()), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'js') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'js'));?>
<?php else: ?><?php echo ((is_array($_tmp=$this->_tpl_vars['notification']->getContents())) ? $this->_run_mod_handler('escape', true, $_tmp, 'js') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'js')); ?>
<?php endif; ?><?php echo '\',
				pnotify_addclass: \''; ?>
<?php echo ((is_array($_tmp=$this->_tpl_vars['notification']->getStyleClass())) ? $this->_run_mod_handler('escape', true, $_tmp, 'js') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'js')); ?>
<?php echo '\',
				pnotify_notice_icon: \'notifyIcon '; ?>
<?php echo ((is_array($_tmp=$this->_tpl_vars['notification']->getIconClass())) ? $this->_run_mod_handler('escape', true, $_tmp, 'js') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'js')); ?>
<?php echo '\'
			});
		'; ?>

	<?php endforeach; endif; unset($_from); ?>
	// -->
	</script>
<?php endif; ?></body>
</html>
