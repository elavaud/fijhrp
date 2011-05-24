<?php /* Smarty version 2.6.26, created on 2011-05-09 17:42:25
         compiled from file:/var/www/whorrp/whorrp/plugins/blocks/role/reviewer.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'file:/var/www/whorrp/whorrp/plugins/blocks/role/reviewer.tpl', 17, false),array('function', 'url', 'file:/var/www/whorrp/whorrp/plugins/blocks/role/reviewer.tpl', 20, false),)), $this); ?>

<?php if ($this->_tpl_vars['isUserLoggedIn']): ?>
	<div class="block" id="sidebarReviewer">
		<span class="blockTitle"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.role.reviewer"), $this);?>
</span>
		<span class="blockSubtitle"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "article.submissions"), $this);?>
</span>
		<ul>
			<li><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'index','path' => 'active'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.active"), $this);?>
</a>&nbsp;(<?php if ($this->_tpl_vars['submissionsCount'][0]): ?><?php echo $this->_tpl_vars['submissionsCount'][0]; ?>
<?php else: ?>0<?php endif; ?>)</li>
			<li><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'index','path' => 'completed'), $this);?>
"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.queue.short.completed"), $this);?>
</a>&nbsp;(<?php if ($this->_tpl_vars['submissionsCount'][1]): ?><?php echo $this->_tpl_vars['submissionsCount'][1]; ?>
<?php else: ?>0<?php endif; ?>)</li>
		</ul>
	</div>
<?php endif; ?>