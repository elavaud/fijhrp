<?php /* Smarty version 2.6.26, created on 2011-06-14 21:22:34
         compiled from author/submit/submitHeader.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'url', 'author/submit/submitHeader.tpl', 17, false),array('function', 'translate', 'author/submit/submitHeader.tpl', 18, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('pageCrumbTitle', "author.submit"); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<ul class="steplist">
<li id="step1" <?php if ($this->_tpl_vars['submitStep'] == 1): ?> class="current"<?php endif; ?>><?php if ($this->_tpl_vars['submitStep'] != 1 && $this->_tpl_vars['submissionProgress'] >= 1): ?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submit','path' => '1','articleId' => $this->_tpl_vars['articleId']), $this);?>
"><?php endif; ?>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submit.start"), $this);?>
<?php if ($this->_tpl_vars['submitStep'] != 1 && $this->_tpl_vars['submissionProgress'] >= 1): ?></a><?php endif; ?></li>

<li id="step2" <?php if ($this->_tpl_vars['submitStep'] == 2): ?> class="current"<?php endif; ?>><?php if ($this->_tpl_vars['submitStep'] != 2 && $this->_tpl_vars['submissionProgress'] >= 2): ?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submit','path' => '2','articleId' => $this->_tpl_vars['articleId']), $this);?>
"><?php endif; ?>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submit.upload"), $this);?>
<?php if ($this->_tpl_vars['submitStep'] != 2 && $this->_tpl_vars['submissionProgress'] >= 2): ?></a><?php endif; ?></li>

<li id="step3" <?php if ($this->_tpl_vars['submitStep'] == 3): ?> class="current"<?php endif; ?>><?php if ($this->_tpl_vars['submitStep'] != 3 && $this->_tpl_vars['submissionProgress'] >= 3): ?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submit','path' => '3','articleId' => $this->_tpl_vars['articleId']), $this);?>
"><?php endif; ?>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submit.metadata"), $this);?>
<?php if ($this->_tpl_vars['submitStep'] != 3 && $this->_tpl_vars['submissionProgress'] >= 3): ?></a><?php endif; ?></li>

<li id="step4" <?php if ($this->_tpl_vars['submitStep'] == 4): ?> class="current"<?php endif; ?>><?php if ($this->_tpl_vars['submitStep'] != 4 && $this->_tpl_vars['submissionProgress'] >= 4): ?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submit','path' => '4','articleId' => $this->_tpl_vars['articleId']), $this);?>
"><?php endif; ?>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submit.supplementaryFiles"), $this);?>
<?php if ($this->_tpl_vars['submitStep'] != 4 && $this->_tpl_vars['submissionProgress'] >= 4): ?></a><?php endif; ?></li>

<li id="step5" <?php if ($this->_tpl_vars['submitStep'] == 5): ?> class="current"<?php endif; ?>><?php if ($this->_tpl_vars['submitStep'] != 5 && $this->_tpl_vars['submissionProgress'] >= 5): ?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submit','path' => '5','articleId' => $this->_tpl_vars['articleId']), $this);?>
"><?php endif; ?>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submit.confirmation"), $this);?>
<?php if ($this->_tpl_vars['submitStep'] != 5 && $this->_tpl_vars['submissionProgress'] >= 5): ?></a><?php endif; ?></li>
</ul>
