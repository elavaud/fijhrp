<?php /* Smarty version 2.6.26, created on 2011-06-06 10:47:47
         compiled from manager/people/userProfile.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'escape', 'manager/people/userProfile.tpl', 16, false),array('modifier', 'default', 'manager/people/userProfile.tpl', 29, false),array('modifier', 'nl2br', 'manager/people/userProfile.tpl', 45, false),array('modifier', 'concat', 'manager/people/userProfile.tpl', 69, false),array('modifier', 'to_array', 'manager/people/userProfile.tpl', 70, false),array('modifier', 'assign', 'manager/people/userProfile.tpl', 70, false),array('modifier', 'urldecode', 'manager/people/userProfile.tpl', 88, false),array('modifier', 'strip_unsafe_html', 'manager/people/userProfile.tpl', 96, false),array('modifier', 'date_format', 'manager/people/userProfile.tpl', 115, false),array('function', 'translate', 'manager/people/userProfile.tpl', 18, false),array('function', 'url', 'manager/people/userProfile.tpl', 20, false),array('function', 'icon', 'manager/people/userProfile.tpl', 71, false),)), $this); ?>
<?php echo ''; ?><?php $this->assign('pageTitle', "manager.people"); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<h3 id="userFullName"><?php echo ((is_array($_tmp=$this->_tpl_vars['user']->getFullName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</h3>
<div id="profile">
<h4><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.profile"), $this);?>
</h4>

<p><a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'editUser','path' => $this->_tpl_vars['user']->getId()), $this);?>
" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.editProfile"), $this);?>
</a></p>

<table width="100%" class="data">
	<tr valign="top">
		<td width="20%" class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.username"), $this);?>
</td>
		<td width="80%" class="data"><strong><?php echo ((is_array($_tmp=$this->_tpl_vars['user']->getUsername())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</strong></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.salutation"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getSalutation())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.firstName"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getFirstName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.middleName"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getMiddleName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.lastName"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getLastName())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.affiliation"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getLocalizedAffiliation())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.signature"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getLocalizedSignature())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.initials"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getInitials())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.gender"), $this);?>
</td>
		<td class="value">
			<?php if ($this->_tpl_vars['user']->getGender() == 'M'): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.masculine"), $this);?>

			<?php elseif ($this->_tpl_vars['user']->getGender() == 'F'): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.feminine"), $this);?>

			<?php elseif ($this->_tpl_vars['user']->getGender() == 'O'): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.other"), $this);?>

			<?php else: ?>&mdash;
			<?php endif; ?>
		</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.email"), $this);?>
</td>
		<td class="value">
			<?php echo ((is_array($_tmp=$this->_tpl_vars['user']->getEmail())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>

			<?php $this->assign('emailString', ((is_array($_tmp=$this->_tpl_vars['user']->getFullName())) ? $this->_run_mod_handler('concat', true, $_tmp, " <", $this->_tpl_vars['user']->getEmail(), ">") : $this->_plugins['modifier']['concat'][0][0]->smartyConcat($_tmp, " <", $this->_tpl_vars['user']->getEmail(), ">"))); ?>
			<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'user','op' => 'email','to' => ((is_array($_tmp=$this->_tpl_vars['emailString'])) ? $this->_run_mod_handler('to_array', true, $_tmp) : $this->_plugins['modifier']['to_array'][0][0]->smartyToArray($_tmp)),'redirectUrl' => $this->_tpl_vars['currentUrl']), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'url') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'url'));?>

			<?php echo $this->_plugins['function']['icon'][0][0]->smartyIcon(array('name' => 'mail','url' => $this->_tpl_vars['url']), $this);?>

		</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.url"), $this);?>
</td>
		<td class="value"><a href="<?php echo ((is_array($_tmp=$this->_tpl_vars['user']->getUrl())) ? $this->_run_mod_handler('escape', true, $_tmp, 'quotes') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'quotes')); ?>
"><?php echo ((is_array($_tmp=$this->_tpl_vars['user']->getUrl())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</a></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.phone"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getPhone())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.fax"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getFax())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.interests"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getInterests())) ? $this->_run_mod_handler('urldecode', true, $_tmp) : urldecode($_tmp)))) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.gossip"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getLocalizedGossip())) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.mailingAddress"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getMailingAddress())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.country"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['country'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.biography"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['user']->getLocalizedBiography())) ? $this->_run_mod_handler('strip_unsafe_html', true, $_tmp) : String::stripUnsafeHtml($_tmp)))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)))) ? $this->_run_mod_handler('default', true, $_tmp, "&mdash;") : smarty_modifier_default($_tmp, "&mdash;")); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.workingLanguages"), $this);?>
</td>
		<td class="value"><?php $_from = $this->_tpl_vars['user']->getLocales(); if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['workingLanguages'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['workingLanguages']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['localeKey']):
        $this->_foreach['workingLanguages']['iteration']++;
?><?php echo ((is_array($_tmp=$this->_tpl_vars['localeNames'][$this->_tpl_vars['localeKey']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
<?php if (! ($this->_foreach['workingLanguages']['iteration'] == $this->_foreach['workingLanguages']['total'])): ?>; <?php endif; ?><?php endforeach; else: ?>&mdash;<?php endif; unset($_from); ?></td>
	</tr>
	<tr valign="top">
		<td colspan="2" class="separator">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.dateRegistered"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=$this->_tpl_vars['user']->getDateRegistered())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['datetimeFormatLong']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['datetimeFormatLong'])); ?>
</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.dateLastLogin"), $this);?>
</td>
		<td class="value"><?php echo ((is_array($_tmp=$this->_tpl_vars['user']->getDateLastLogin())) ? $this->_run_mod_handler('date_format', true, $_tmp, $this->_tpl_vars['datetimeFormatLong']) : smarty_modifier_date_format($_tmp, $this->_tpl_vars['datetimeFormatLong'])); ?>
</td>
	</tr>
</table>
</div>
<div class="separator"></div>
<div id="enrollment>">
<h4><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.enrollment"), $this);?>
</h4>

<?php unset($this->_sections['role']);
$this->_sections['role']['name'] = 'role';
$this->_sections['role']['loop'] = is_array($_loop=$this->_tpl_vars['userRoles']) ? count($_loop) : max(0, (int)$_loop); unset($_loop);
$this->_sections['role']['show'] = true;
$this->_sections['role']['max'] = $this->_sections['role']['loop'];
$this->_sections['role']['step'] = 1;
$this->_sections['role']['start'] = $this->_sections['role']['step'] > 0 ? 0 : $this->_sections['role']['loop']-1;
if ($this->_sections['role']['show']) {
    $this->_sections['role']['total'] = $this->_sections['role']['loop'];
    if ($this->_sections['role']['total'] == 0)
        $this->_sections['role']['show'] = false;
} else
    $this->_sections['role']['total'] = 0;
if ($this->_sections['role']['show']):

            for ($this->_sections['role']['index'] = $this->_sections['role']['start'], $this->_sections['role']['iteration'] = 1;
                 $this->_sections['role']['iteration'] <= $this->_sections['role']['total'];
                 $this->_sections['role']['index'] += $this->_sections['role']['step'], $this->_sections['role']['iteration']++):
$this->_sections['role']['rownum'] = $this->_sections['role']['iteration'];
$this->_sections['role']['index_prev'] = $this->_sections['role']['index'] - $this->_sections['role']['step'];
$this->_sections['role']['index_next'] = $this->_sections['role']['index'] + $this->_sections['role']['step'];
$this->_sections['role']['first']      = ($this->_sections['role']['iteration'] == 1);
$this->_sections['role']['last']       = ($this->_sections['role']['iteration'] == $this->_sections['role']['total']);
?>
	<?php $this->assign('roleJournalId', $this->_tpl_vars['userRoles'][$this->_sections['role']['index']]->getJournalId()); ?>
	<?php if ($this->_tpl_vars['isSiteAdmin'] && $this->_tpl_vars['lastJournalTitle'] != $this->_tpl_vars['journalTitles'][$this->_tpl_vars['roleJournalId']]): ?>
		<?php if ($this->_tpl_vars['notFirstRole']): ?>
			</ul>
		<?php endif; ?>
		<?php $this->assign('lastJournalTitle', $this->_tpl_vars['journalTitles'][$this->_tpl_vars['roleJournalId']]); ?>
		<h3><?php echo $this->_tpl_vars['lastJournalTitle']; ?>
</h3>
		<?php if ($this->_tpl_vars['notFirstRole']): ?>
			<ul>
		<?php endif; ?>
	<?php endif; ?>
	<?php if (! $this->_tpl_vars['notFirstRole']): ?>
		<ul>
		<?php $this->assign('notFirstRole', 1); ?>
	<?php endif; ?>
	<li>
		<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['userRoles'][$this->_sections['role']['index']]->getRoleName()), $this);?>

		<?php if ($this->_tpl_vars['userRoles'][$this->_sections['role']['index']]->getRoleId() != @ROLE_ID_SITE_ADMIN): ?>
			<a href="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'unEnroll','path' => $this->_tpl_vars['userRoles'][$this->_sections['role']['index']]->getRoleId(),'userId' => $this->_tpl_vars['user']->getId(),'journalId' => $this->_tpl_vars['userRoles'][$this->_sections['role']['index']]->getJournalId()), $this);?>
" onclick="return confirm('<?php echo ((is_array($_tmp=$this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.confirmUnenroll"), $this))) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam'));?>
')" class="action"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.unenroll"), $this);?>
</a>
		<?php endif; ?>
	</li>
<?php endfor; endif; ?>
<?php if ($this->_tpl_vars['notFirstRole']): ?>
	</ul>
<?php endif; ?>
</div>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
