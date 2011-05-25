<?php /* Smarty version 2.6.26, created on 2011-05-25 10:49:52
         compiled from author/active.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'author/active.tpl', 16, false),array('function', 'sort_heading', 'author/active.tpl', 16, false),array('function', 'url', 'author/active.tpl', 33, false),array('function', 'page_info', 'author/active.tpl', 109, false),array('function', 'page_links', 'author/active.tpl', 110, false),array('block', 'iterate', 'author/active.tpl', 24, false),array('modifier', 'escape', 'author/active.tpl', 28, false),array('modifier', 'date_format', 'author/active.tpl', 29, false),array('modifier', 'truncate', 'author/active.tpl', 31, false),array('modifier', 'strip_unsafe_html', 'author/active.tpl', 33, false),)), $this); ?>
<div id="submissions">
<table class="listing" width="100%">
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.submit",'sort' => 'submitDate'), $this);?>
</td>
		<td width="5%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.sec",'sort' => 'section'), $this);?>
</td>
		<td width="25%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.authors",'sort' => 'authors'), $this);?>
</td>
		<td width="35%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="25%" align="right"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.status",'sort' => 'status'), $this);?>
</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?>
        <?php $this->assign('whoId', $this->_tpl_vars['submission']->getWhoId($this->_tpl_vars['submission']->getLocale())); ?>
	<tr valign="top">
		<td><?php if ($this->_tpl_vars['whoId']): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['whoId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
		<td><?php if ($this->_tpl_vars['submission']->getDateSubmitted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateSubmitted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getSectionAbbrev())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<td><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getAuthorString(true))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>

                <td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
                <td align="right">
                        <?php $this->assign('status', $this->_tpl_vars['submission']->getSubmissionStatus()); ?>

                        <?php if ($this->_tpl_vars['status'] == PROPOSAL_STATUS_SUBMITTED): ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.submitted"), $this);?>
<br /><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.confirmWithdraw"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a>
                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_RETURNED): ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.returned"), $this);?>
<br /><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'resubmit','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">Resubmit</a>
                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_WITHDRAWN): ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.withdrawn"), $this);?>
<br />
                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_DRAFT): ?> 
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.draft"), $this);?>
<br /><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'deleteSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.confirmDelete"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.delete"), $this);?>
</a>
                        <?php endif; ?>
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
		<td colspan="4" align="left"><?php echo $this->_plugins['function']['page_info'][0][0]->smartyPageInfo(array('iterator' => $this->_tpl_vars['submissions']), $this);?>
</td>
		<td colspan="2" align="right"><?php echo $this->_plugins['function']['page_links'][0][0]->smartyPageLinks(array('anchor' => 'submissions','name' => 'submissions','iterator' => $this->_tpl_vars['submissions'],'sort' => $this->_tpl_vars['sort'],'sortDirection' => $this->_tpl_vars['sortDirection']), $this);?>
</td>
	</tr>
<?php endif; ?>
</table>
</div>
