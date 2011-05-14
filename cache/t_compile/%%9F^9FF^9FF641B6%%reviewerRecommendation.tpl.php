<?php /* Smarty version 2.6.26, created on 2011-05-10 22:23:19
         compiled from sectionEditor/reviewerRecommendation.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'sectionEditor/reviewerRecommendation.tpl', 16, false),array('function', 'url', 'sectionEditor/reviewerRecommendation.tpl', 20, false),array('function', 'html_options_translate', 'sectionEditor/reviewerRecommendation.tpl', 28, false),array('modifier', 'escape', 'sectionEditor/reviewerRecommendation.tpl', 21, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('pageTitle', "submission.recommendation"); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>

<div id="reviewerRecommendation">
<h3><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.enterReviewerRecommendation"), $this);?>
</h3>

<br />

<form method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'enterReviewerRecommendation'), $this);?>
">
<input type="hidden" name="articleId" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['articleId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />
<input type="hidden" name="reviewId" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['reviewId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />
<table width="100%" class="data">
<tr valign="top">
	<td width="20%" class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "editor.article.recommendation"), $this);?>
</td>
	<td width="80%" class="value">
		<select name="recommendation" size="1" class="selectMenu">
			<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['reviewerRecommendationOptions']), $this);?>

		</select>
	</td>
</tr>
</table>
<p><input type="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.save"), $this);?>
" class="button defaultButton" /> <input type="button" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.cancel"), $this);?>
" class="button" onclick="document.location.href='<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submissionReview','path' => $this->_tpl_vars['articleId'],'escape' => false), $this);?>
';"/></p>
</form>
</div>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
