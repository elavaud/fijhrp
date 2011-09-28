<?php /* Smarty version 2.6.26, created on 2011-09-28 12:27:29
         compiled from author/active.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'author/active.tpl', 18, false),array('function', 'sort_heading', 'author/active.tpl', 18, false),array('function', 'url', 'author/active.tpl', 45, false),array('block', 'iterate', 'author/active.tpl', 27, false),array('modifier', 'escape', 'author/active.tpl', 37, false),array('modifier', 'date_format', 'author/active.tpl', 38, false),array('modifier', 'truncate', 'author/active.tpl', 41, false),array('modifier', 'strip_unsafe_html', 'author/active.tpl', 45, false),)), $this); ?>

<div id="submissions">
<table class="listing" width="100%">
        <tr><td colspan="6">ACTIVE PROPOSALS (Awaiting Decision/Revise and Resubmit)</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.submit",'sort' => 'submitDate'), $this);?>
</td>
		<!--  -->
		<td width="25%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.authors",'sort' => 'authors'), $this);?>
</td>
		<td width="35%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="25%" align="right"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.status",'sort' => 'status'), $this);?>
</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>

<?php $this->assign('count', 0); ?>
<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions1','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('status', $this->_tpl_vars['submission']->getSubmissionStatus()); ?>
        <?php $this->assign('decision', $this->_tpl_vars['submission']->getMostRecentDecision()); ?>
        
        <?php if (( $this->_tpl_vars['status'] != PROPOSAL_STATUS_REVIEWED && $this->_tpl_vars['status'] != PROPOSAL_STATUS_EXEMPTED ) || $this->_tpl_vars['decision'] == SUBMISSION_EDITOR_DECISION_RESUBMIT || $this->_tpl_vars['status'] == PROPOSAL_STATUS_EXTENSION): ?>

            <?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?>
            <?php $this->assign('whoId', $this->_tpl_vars['submission']->getWhoId($this->_tpl_vars['submission']->getLocale())); ?>

            <tr valign="top">
                <td><?php if ($this->_tpl_vars['whoId']): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['whoId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <td><?php if ($this->_tpl_vars['submission']->getDateSubmitted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateSubmitted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <!--  -->
                <!--  Commented out by MSB, Sept25, 2011 -->
   				<td><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getFirstAuthor(true))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
                <?php if ($this->_tpl_vars['status'] == PROPOSAL_STATUS_DRAFT): ?>
                    <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                    <?php $this->assign('progress', $this->_tpl_vars['submission']->getSubmissionProgress()); ?>
                    <td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submit','path' => $this->_tpl_vars['progress'],'articleId' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
                <?php else: ?>
                    <td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
                <?php endif; ?>
                <td align="right">
                        <?php if ($this->_tpl_vars['status'] == PROPOSAL_STATUS_DRAFT): ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.draft"), $this);?>
<br /><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'deleteSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.confirmDelete"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.delete"), $this);?>
</a>
                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_SUBMITTED): ?>
                            <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.submitted"), $this);?>
<br />
                            <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" ><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a>

                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_CHECKED): ?>
                            <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.checked"), $this);?>
<br />
                            <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" ><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a>

                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_EXPEDITED): ?>
                            <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.expedited"), $this);?>
<br />
                            <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" ><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a>

                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_ASSIGNED): ?>
                            <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.assigned"), $this);?>
<br />
                            <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" ><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a>

                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_RETURNED): ?>
                            <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                            <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.returned"), $this);?>
<br />
                            <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'resubmit','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">Resubmit</a><br />
                            <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" ><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a>
                            
                        <?php elseif ($this->_tpl_vars['status'] == PROPOSAL_STATUS_REVIEWED): ?>
                            <?php if ($this->_tpl_vars['decision'] == SUBMISSION_EDITOR_DECISION_RESUBMIT): ?>
                                <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                                <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.resubmit"), $this);?>
<br />
                                <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'resubmit','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">Resubmit</a><br />
                                <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" ><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a>
                                
                            <?php endif; ?>
                        <?php endif; ?>
                 </td>
            </tr>
            <tr>
		<td colspan="6" class="<?php if ($this->_tpl_vars['submissions1']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td>
	    </tr>
        <?php endif; ?>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['count'] == 0): ?>
	<tr>
		<td colspan="6" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.noSubmissions"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="6" align="left"><?php echo $this->_tpl_vars['count']; ?>
 active submission(s)</td>
	</tr>
<?php endif; ?>
</table>

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">APPROVED PROPOSALS (Research Ongoing)</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.submit",'sort' => 'submitDate'), $this);?>
</td>
		<!--  -->
		<td width="20%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.authors",'sort' => 'authors'), $this);?>
</td>
		<td width="35%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="20%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.status",'sort' => 'status'), $this);?>
</td>
		<td width="10%">Approval Date</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


<?php $this->assign('count', 0); ?>

<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions2','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('status', $this->_tpl_vars['submission']->getSubmissionStatus()); ?>
        <?php $this->assign('decision', $this->_tpl_vars['submission']->getMostRecentDecision()); ?>

        <?php if (( $this->_tpl_vars['status'] == PROPOSAL_STATUS_REVIEWED && $this->_tpl_vars['decision'] == SUBMISSION_EDITOR_DECISION_ACCEPT )): ?>
            <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>

            <?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?>
            <?php $this->assign('whoId', $this->_tpl_vars['submission']->getWhoId($this->_tpl_vars['submission']->getLocale())); ?>

            <tr valign="top">
                <td><?php if ($this->_tpl_vars['whoId']): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['whoId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <td><?php if ($this->_tpl_vars['submission']->getDateSubmitted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateSubmitted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <!--  -->
                <!--   Commented out by MSB, Sept25, 2011 -->
   				<td><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getFirstAuthor(true))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td> <!-- Get first author. Added by MSB, Sept25, 2011 -->
                
                <td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
                <td align="right">
                    <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.approved"), $this);?>
<?php if ($this->_tpl_vars['submission']->isSubmissionDue()): ?>&nbsp;(For Continuing Review)<?php endif; ?><br />
                    <?php if ($this->_tpl_vars['submission']->isSubmissionDue()): ?><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'addExtensionRequest','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">Submit Extension Request</a><br /><?php endif; ?>
                    <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'addProgressReport','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">Upload Progress Report</a><br />
                    <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'addCompletionReport','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action">Complete</a><br />
                    <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'withdrawSubmission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.withdraw"), $this);?>
</a><br />
                 </td>
            </tr>
            <tr>
                    <td colspan="6" class="<?php if ($this->_tpl_vars['submissions2']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td>
            </tr>
        <?php endif; ?>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['count'] == 0): ?>
	<tr>
		<td colspan="6" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.noSubmissions"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="6" align="left"><?php echo $this->_tpl_vars['count']; ?>
 submission(s)</td>
	</tr>
<?php endif; ?>
</table>

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">NOT APPROVED</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.submit",'sort' => 'submitDate'), $this);?>
</td>
		<!--  -->
		<td width="25%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.authors",'sort' => 'authors'), $this);?>
</td>
		<td width="35%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="25%" align="right"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.status",'sort' => 'status'), $this);?>
</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


<?php $this->assign('count', 0); ?>

<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions3','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('status', $this->_tpl_vars['submission']->getSubmissionStatus()); ?>
        <?php $this->assign('decision', $this->_tpl_vars['submission']->getMostRecentDecision()); ?>

        <?php if (( $this->_tpl_vars['status'] == PROPOSAL_STATUS_REVIEWED && $this->_tpl_vars['decision'] == SUBMISSION_EDITOR_DECISION_DECLINE )): ?>

            <?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?>
            <?php $this->assign('whoId', $this->_tpl_vars['submission']->getWhoId($this->_tpl_vars['submission']->getLocale())); ?>

            <tr valign="top">
                <td><?php if ($this->_tpl_vars['whoId']): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['whoId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <td><?php if ($this->_tpl_vars['submission']->getDateSubmitted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateSubmitted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <!--  -->
                <!--   Commented out by MSB, Sept25,2011 -->
   				<td><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getFirstAuthor(true))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td> <!-- Get first author. Added by MSB, Sept25, 2011 -->
                
                <td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
                <td align="right">
                    <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                    <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.decline"), $this);?>
<br />
                    <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'sendToArchive','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.confirmArchive"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.sendtoarchive"), $this);?>
</a>
                 </td>
            </tr>
            <tr>
                    <td colspan="6" class="<?php if ($this->_tpl_vars['submissions3']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td>
            </tr>
        <?php endif; ?>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['count'] == 0): ?>
	<tr>
		<td colspan="6" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.noSubmissions"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="6" align="left"><?php echo $this->_tpl_vars['count']; ?>
 submission(s)</td>
	</tr>
<?php endif; ?>
</table>

<br />
<br />
<br />

<table class="listing" width="100%">
        <tr><td colspan="6">EXEMPT FROM REVIEW</td></tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>
	<tr class="heading" valign="bottom">
		<td width="5%">WHO Proposal ID</td>
		<td width="5%"><span class="disabled"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submission.date.mmdd"), $this);?>
</span><br /><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "submissions.submit",'sort' => 'submitDate'), $this);?>
</td>
		<!--  -->
		<td width="25%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.authors",'sort' => 'authors'), $this);?>
</td>
		<td width="35%"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "article.title",'sort' => 'title'), $this);?>
</td>
		<td width="25%" align="right"><?php echo $this->_plugins['function']['sort_heading'][0][0]->smartySortHeading(array('key' => "common.status",'sort' => 'status'), $this);?>
</td>
	</tr>
	<tr><td colspan="6" class="headseparator">&nbsp;</td></tr>


<?php $this->assign('count', 0); ?>

<?php $this->_tag_stack[] = array('iterate', array('from' => 'submissions4','item' => 'submission')); $_block_repeat=true;$this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<?php $this->assign('status', $this->_tpl_vars['submission']->getSubmissionStatus()); ?>
        <?php $this->assign('decision', $this->_tpl_vars['submission']->getMostRecentDecision()); ?>

        <?php if (( $this->_tpl_vars['status'] == PROPOSAL_STATUS_EXEMPTED )): ?>

            <?php $this->assign('articleId', $this->_tpl_vars['submission']->getArticleId()); ?>
            <?php $this->assign('whoId', $this->_tpl_vars['submission']->getWhoId($this->_tpl_vars['submission']->getLocale())); ?>

            <tr valign="top">
                <td><?php if ($this->_tpl_vars['whoId']): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['whoId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <td><?php if ($this->_tpl_vars['submission']->getDateSubmitted()): ?><?php echo ((is_array($_tmp=$this->_tpl_vars['submission']->getDateSubmitted())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['dateFormatTrunc']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['dateFormatTrunc'])); ?>
<?php else: ?>&mdash;<?php endif; ?></td>
                <!--  -->
                <!--  Commented out by MSB, Sept25, 2011 -->
   				<td><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getFirstAuthor(true))) ? $this->_run_mod_handler('truncate', true, $_tmp, 40, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 40, "...")))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</td> <!-- Get first author. Added by MSB, Sept 25, 2011 -->
                
                <td><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'submission','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action"><?php if ($this->_tpl_vars['submission']->getLocalizedTitle()): ?><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['submission']->getLocalizedTitle())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, 60, "...") : $this->_plugins['modifier']['truncate'][0][0]->smartyTruncate($_tmp, 60, "...")); ?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.untitled"), $this);?>
<?php endif; ?></a></td>
                <td align="right">
                   <?php $this->assign('count', $this->_tpl_vars['count']+1); ?>
                   <?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.proposal.exempted"), $this);?>
<br />
                   <a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'sendToArchive','path' => $this->_tpl_vars['articleId']), $this);?>
" class="action" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "author.submissions.confirmArchive"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.sendtoarchive"), $this);?>
</a>     
                 </td>
            </tr>
            <tr>
                    <td colspan="6" class="<?php if ($this->_tpl_vars['submissions4']->eof()): ?>end<?php endif; ?>separator">&nbsp;</td>
            </tr>
        <?php endif; ?>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo $this->_plugins['block']['iterate'][0][0]->smartyIterate($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php if ($this->_tpl_vars['count'] == 0): ?>
	<tr>
		<td colspan="6" class="nodata"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "submissions.noSubmissions"), $this);?>
</td>
	</tr>
	<tr>
		<td colspan="6" class="endseparator">&nbsp;</td>
	</tr>
<?php else: ?>
	<tr>
		<td colspan="6" align="left"><?php echo $this->_tpl_vars['count']; ?>
 submission(s)</td>
	</tr>
<?php endif; ?>
</table>

</div>
