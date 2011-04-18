<?php /* Smarty version 2.6.26, created on 2011-04-18 16:39:28
         compiled from core:install/installComplete.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'url', 'core:install/installComplete.tpl', 16, false),array('function', 'translate', 'core:install/installComplete.tpl', 17, false),array('modifier', 'assign', 'core:install/installComplete.tpl', 16, false),array('modifier', 'escape', 'core:install/installComplete.tpl', 26, false),)), $this); ?>
<?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'login'), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'loginUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'loginUrl'));?>

<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "installer.installationComplete",'loginUrl' => $this->_tpl_vars['loginUrl']), $this);?>


<?php if ($this->_tpl_vars['writeConfigFailed']): ?>
<div id="writeConfigFailed">
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "installer.overwriteConfigFileInstructions"), $this);?>


<form action="#">
<p>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "installer.contentsOfConfigFile"), $this);?>
:<br />
<textarea name="config" cols="80" rows="20" class="textArea" style="font-family: Courier,'Courier New',fixed-width"><?php echo ((is_array($_tmp=$this->_tpl_vars['configFileContents'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea>
</p>
</form>
</div>
<?php endif; ?>

<?php if ($this->_tpl_vars['manualInstall']): ?>

<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "installer.manualSQLInstructions"), $this);?>

<p><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "installer.pleaseUpgradeAfterManualInstall"), $this);?>
</p>
<div id="manualSQLInstructions">
<form action="#">
<p>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "installer.installerSQLStatements"), $this);?>
:<br />
<textarea name="sql" cols="80" rows="20" class="textArea" style="font-family: Courier,'Courier New',fixed-width"><?php $_from = $this->_tpl_vars['installSql']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['sqlStmt']):
?><?php echo ((is_array($_tmp=$this->_tpl_vars['sqlStmt'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
;


<?php endforeach; endif; unset($_from); ?></textarea>
</p>
</form>
</div>
<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
