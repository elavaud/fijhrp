<?php /* Smarty version 2.6.26, created on 2011-05-03 21:47:51
         compiled from file:/var/www/whorrp/whorrp/plugins/blocks/donation/block.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'url', 'file:/var/www/whorrp/whorrp/plugins/blocks/donation/block.tpl', 12, false),array('function', 'translate', 'file:/var/www/whorrp/whorrp/plugins/blocks/donation/block.tpl', 12, false),)), $this); ?>
<?php if ($this->_tpl_vars['donationEnabled']): ?>
<div class="block" id="sidebarDonation">
	<span class="blockTitle"><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'donations'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "payment.type.donation"), $this);?>
</a></span>
</div>
<?php endif; ?>