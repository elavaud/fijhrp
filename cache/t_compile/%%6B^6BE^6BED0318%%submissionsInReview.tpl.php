<?php /* Smarty version 2.6.26, created on 2011-05-23 11:50:41
         compiled from editor/submissionsInReview.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'sort_search', 'editor/submissionsInReview.tpl', 15, false),array('function', 'translate', 'editor/submissionsInReview.tpl', 16, false),array('function', 'url', 'editor/submissionsInReview.tpl', 45, false),array('function', 'page_info', 'editor/submissionsInReview.tpl', 104, false),array('function', 'page_links', 'editor/submissionsInReview.tpl', 105, false),array('block', 'iterate', 'editor/submissionsInReview.tpl', 37, false),array('modifier', 'escape', 'editor/submissionsInReview.tpl', 40, false),array('modifier', 'date_format', 'editor/submissionsInReview.tpl', 42, false),array('modifier', 'truncate', 'editor/submissionsInReview.tpl', 44, false),array('modifier', 'strip_unsafe_html', 'editor/submissionsInReview.tpl', 45, false),array('modifier', 'default', 'editor/submissionsInReview.tpl', 53, false),)), $this); ?>
<div id="submissions">
<table width="100%" class="listing">
	<tr>
		<td colspan="8" class="headseparator">&nbsp;</td>
	</tr>
	<tr class="heading" valign="bottom">
		<td width="5%"><?php echo $this->_plugins['function']['sort_search'][0][0]->smartySortSearch(array('key' => "common.id",'sort' => 'id'), $this);?>
</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_search'][0][0]->smartySortSearch(array('key' => "submissions.submitted",'sort' => 'submitDate'), $this);?>
</td>
		<td width="5%"><?php echo $this->_plugins['function']['sort_search'][0][0]->smartySortSearch(array('key' => "submissions.sec",'sort' => 'section'), $this);?>
</td>
		<td width="15%"><?php echo $this->_plugins['function']['sort_search'][0][0]->smartySortSearch(array('key' => "article.authors",'sort' => 'authors'), $this);?>
</td>
		<td width="30%"><?php echo $this->_plugins['function']['sort_search'][0][0]->smartySortSearch(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="30%">
			<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.peerReview"), $this);?>

			<table width="100%" class="nested">
				<tr valign="top">
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.ask"), $this);?>
</td>
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.due"), $this);?>
</td>
					<td width="34%" style="padding: 0 4px 0 0; font-size: 1.0em"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.done"), $this);?>
</td>
				</tr>
			</table>
		</td>
		<td width="5%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.ruling"), $this);?>
</td>
		<td width="5%"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "article.sectionEditor"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="8" class="headseparator">&nbsp;</td>
	</tr>
	
	<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('highlightClass', $this->_tpl_vars['submission']->getHighlightClass()); ?>
	<?php $this->assign('fastTracked', $this->_tpl_vars['submission']->getFastTracked()); ?>
	<tr valign="top"<?php if ($this->_tpl_vars['highlightClass'] || $this->_tpl_vars['fastTracked']): ?> class="<?php echo ((is_array($_tmp=$this->_tpl_vars['highlightClass'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
 <?php if ($this->_tpl_vars['fastTracked']): ?>fastTracked<?php endif; ?>"<?php endif; ?>>
		<td><?php echo $this->_tpl_vars['submission']->getId(); ?>
</td>
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateSubmitted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
</td>
		<td><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getSectionAbbrev())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<td><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getAuthorString(true))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td>
		<td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submissionReview','path' => $this->_tpl_vars['submission']->getId()), $this);?>
" class="action"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")); ?>
</a></td>
		<td>
			<table width="100%">
			<?php $_from = $this->_tpl_vars['submission']->getReviewAssignments(); if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['reviewAssignments']):
?>
				<?php $_from = $this->_tpl_vars['reviewAssignments']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['assignmentList'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['assignmentList']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['assignment']):
        $this->_foreach['assignmentList']['iteration']++;
?>
					<?php if (! $this->_tpl_vars['assignment']->getCancelled() && ! $this->_tpl_vars['assignment']->getDeclined()): ?>
					<tr valign="top">
						<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em"><?php if ($this->_tpl_vars['assignment']->getDateNotified()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['assignment']->getDateNotified())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
						<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em"><?php if ($this->_tpl_vars['assignment']->getDateCompleted() || ! $this->_tpl_vars['assignment']->getDateConfirmed()): ?>&mdash;<?php else: ?><?php echo ((is_array($_tmp=@$this->_tpl_vars['assignment']->getWeeksDue())) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
<?php endif; ?></td>
						<td width="34%" style="padding: 0 4px 0 0; font-size: 1.0em"><?php if ($this->_tpl_vars['assignment']->getDateCompleted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['assignment']->getDateCompleted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
					</tr>
					<?php endif; ?>
				<?php endforeach; else: ?>
				<tr valign="top">
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="34%" style="padding: 0 0 0 0; font-size: 1.0em">&mdash;</td>
				</tr>
				<?php endif; unset($_from); ?>
			<?php endforeach; else: ?>
				<tr valign="top">
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="33%" style="padding: 0 4px 0 0; font-size: 1.0em">&mdash;</td>
					<td width="34%" style="padding: 0 0 0 0; font-size: 1.0em">&mdash;</td>
				</tr>
			<?php endif; unset($_from); ?>
			</table>
		</td>
		<td>
			<?php $_from = $this->_tpl_vars['submission']->getDecisions(); if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['decisions']):
?>
				<?php $_from = $this->_tpl_vars['decisions']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['decisionList'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['decisionList']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['decision']):
        $this->_foreach['decisionList']['iteration']++;
?>
					<?php if (($this->_foreach['decisionList']['iteration'] == $this->_foreach['decisionList']['total'])): ?>
							<?php echo ((is_array($_tmp=$this->_tpl_vars['decision']['dateDecided'])) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
				
					<?php endif; ?>
				<?php endforeach; else: ?>
					&mdash;
				<?php endif; unset($_from); ?>
			<?php endforeach; else: ?>
				&mdash;
			<?php endif; unset($_from); ?>
		</td>
		<td>
			<?php $this->assign('editAssignments', $this->_tpl_vars['submission']->getEditAssignments()); ?>
			<?php $_from = $this->_tpl_vars['editAssignments']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['editAssignment']):
?><?php echo ((is_array($_tmp=$this->_tpl_vars['editAssignment']->getEditorInitials())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
 <?php endforeach; endif; unset($_from); ?>
		</td>
	</tr>
	<tr>
		<td colspan="8" class="<?php if ($this->_tpl_vars['submissions']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td>
	</tr>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['submissions']->wasEmpty()): ?>
	<tr>
		<td colspan="8" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.noSubmissions"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="8" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="5" align="left"><?php echo $this->_plugins['function']['page_info'][0][0]->smartyPageInfo(array('iterator' => $this->_tpl_vars['submissions']), $this);?>
</td>
		<td colspan="3" align="right"><?php echo $this->_plugins['function']['page_links'][0][0]->smartyPageLinks(array('anchor' => 'submissions','name' => 'submissions','iterator' => $this->_tpl_vars['submissions'],'searchField' => $this->_tpl_vars['searchField'],'searchMatch' => $this->_tpl_vars['searchMatch'],'search' => $this->_tpl_vars['search'],'dateFromDay' => $this->_tpl_vars['dateFromDay'],'dateFromYear' => $this->_tpl_vars['dateFromYear'],'dateFromMonth' => $this->_tpl_vars['dateFromMonth'],'dateToDay' => $this->_tpl_vars['dateToDay'],'dateToYear' => $this->_tpl_vars['dateToYear'],'dateToMonth' => $this->_tpl_vars['dateToMonth'],'dateSearchField' => $this->_tpl_vars['dateSearchField'],'section' => $this->_tpl_vars['section'],'sort' => $this->_tpl_vars['sort'],'sortDirection' => $this->_tpl_vars['sortDirection']), $this);?>
</td>
	</tr>
<?php endif; ?>
</table>
</div>
