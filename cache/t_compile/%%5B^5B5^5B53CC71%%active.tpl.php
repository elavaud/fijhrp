<?php /* Smarty version 2.6.26, created on 2011-05-09 17:42:25
         compiled from reviewer/active.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'sort_heading', 'reviewer/active.tpl', 15, false),array('function', 'translate', 'reviewer/active.tpl', 16, false),array('function', 'url', 'reviewer/active.tpl', 32, false),array('function', 'page_info', 'reviewer/active.tpl', 49, false),array('function', 'page_links', 'reviewer/active.tpl', 50, false),array('block', 'iterate', 'reviewer/active.tpl', 24, false),array('modifier', 'escape', 'reviewer/active.tpl', 29, false),array('modifier', 'date_format', 'reviewer/active.tpl', 30, false),array('modifier', 'strip_unsafe_html', 'reviewer/active.tpl', 32, false),array('modifier', 'truncate', 'reviewer/active.tpl', 32, false),)), $this); ?>
<div id="submissions">
<table class="listing" width="100%">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.id",'sort' => 'id'), $this);?>
</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.assigned",'sort' => 'assignDate'), $this);?>
</td>
		<td width="5%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.sec",'sort' => 'section'), $this);?>
</td>
		<td width="70%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="5%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submission.due",'sort' => 'dueDate'), $this);?>
</td>
		<td width="10%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.reviewRound",'sort' => 'round'), $this);?>
</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?>
	<?php $this->assign('reviewId', $this->_tpl_vars['submission']->getReviewId()); ?>

	<tr valign="top">
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['articleId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateNotified())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
</td>
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getSectionAbbrev())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submission','path' => $this->_tpl_vars['reviewId']), $this);?>
" class="action"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
</a></td>
		<td class="nowrap"><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateDue())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
</td>
		<td><?php echo $this->_tpl_vars['submission']->getRound(); ?>
</td>
	</tr>
	<tr>
		<td colspan="6" class="<?php if ($this->_tpl_vars['submissions']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td>
	</tr>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['submissions']->wasEmpty()): ?>
<tr>
		<td colspan="6" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.noSubmissions"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="3" align="left"><?php echo $this->_plugins['function']['page_info'][0][0]->smartyPageInfo(array('iterator' => $this->_tpl_vars['submissions']), $this);?>
</td>
		<td colspan="3" align="right"><?php echo $this->_plugins['function']['page_links'][0][0]->smartyPageLinks(array('anchor' => 'submissions','name' => 'submissions','iterator' => $this->_tpl_vars['submissions'],'sort' => $this->_tpl_vars['sort'],'sortDirection' => $this->_tpl_vars['sortDirection']), $this);?>
</td>
	</tr>
<?php endif; ?>
</table>
</div>
