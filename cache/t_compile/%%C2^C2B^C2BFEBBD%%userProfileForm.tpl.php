<?php /* Smarty version 2.6.26, created on 2011-06-14 22:29:41
         compiled from manager/people/userProfileForm.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'url', 'manager/people/userProfileForm.tpl', 12, false),array('function', 'translate', 'manager/people/userProfileForm.tpl', 66, false),array('function', 'fieldLabel', 'manager/people/userProfileForm.tpl', 100, false),array('function', 'form_language_chooser', 'manager/people/userProfileForm.tpl', 103, false),array('function', 'html_options_translate', 'manager/people/userProfileForm.tpl', 128, false),array('function', 'html_options', 'manager/people/userProfileForm.tpl', 166, false),array('modifier', 'assign', 'manager/people/userProfileForm.tpl', 12, false),array('modifier', 'escape', 'manager/people/userProfileForm.tpl', 24, false),array('modifier', 'urldecode', 'manager/people/userProfileForm.tpl', 236, false),)), $this); ?>
<?php echo ''; ?><?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'people','path' => 'all'), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'currentUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'currentUrl'));?><?php echo ''; ?><?php $this->assign('pageTitle', "manager.people"); ?><?php echo ''; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo ''; ?>


<?php echo '
<script type="text/javascript">
	$(document).ready(function(){
		$("#interestsTextOnly").hide();
		$("#interests").tagit({
			'; ?>
<?php if ($this->_tpl_vars['existingInterests']): ?><?php echo '
			// This is the list of interests in the system used to populate the autocomplete
			availableTags: ['; ?>
<?php $_from = $this->_tpl_vars['existingInterests']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['existingInterests'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['existingInterests']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['interest']):
        $this->_foreach['existingInterests']['iteration']++;
?>"<?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['interest'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('escape', true, $_tmp, 'javascript') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'javascript')); ?>
"<?php if (! ($this->_foreach['existingInterests']['iteration'] == $this->_foreach['existingInterests']['total'])): ?>, <?php endif; ?><?php endforeach; endif; unset($_from); ?><?php echo '],'; ?>
<?php endif; ?>
			// This is the list of the user's interests that have already been saved
			<?php if ($this->_tpl_vars['interestsKeywords']): ?><?php echo 'currentTags: ['; ?>
<?php $_from = $this->_tpl_vars['interestsKeywords']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['currentInterests'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['currentInterests']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['interest']):
        $this->_foreach['currentInterests']['iteration']++;
?>"<?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['interest'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)))) ? $this->_run_mod_handler('escape', true, $_tmp, 'javascript') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'javascript')); ?>
"<?php if (! ($this->_foreach['currentInterests']['iteration'] == $this->_foreach['currentInterests']['total'])): ?>, <?php endif; ?><?php endforeach; endif; unset($_from); ?><?php echo ']'; ?>

			<?php else: ?><?php echo 'currentTags: []'; ?>
<?php endif; ?><?php echo '
		});
	});
</script>
'; ?>


<?php if (! $this->_tpl_vars['userId']): ?>
<?php $this->assign('passwordRequired', 'true'); ?>

<?php echo '
<script type="text/javascript">
<!--
	function setGenerateRandom(value) {
		if (value) {
			document.userForm.password.value=\'********\';
			document.userForm.password2.value=\'********\';
			document.userForm.password.disabled=1;
			document.userForm.password2.disabled=1;
			document.userForm.sendNotify.checked=1;
			document.userForm.sendNotify.disabled=1;
		} else {
			document.userForm.password.disabled=0;
			document.userForm.password2.disabled=0;
			document.userForm.sendNotify.disabled=0;
			document.userForm.password.value=\'\';
			document.userForm.password2.value=\'\';
			document.userForm.password.focus();
		}
	}

	function enablePasswordFields() {
		document.userForm.password.disabled=0;
		document.userForm.password2.disabled=0;
	}

	function generateUsername() {
		var req = makeAsyncRequest();

		if (document.userForm.lastName.value == "") {
			alert("'; ?>
<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.mustProvideName"), $this);?>
<?php echo '");
			return;
		}

		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				document.userForm.username.value = req.responseText;
			}
		}
		sendAsyncRequest(req, \''; ?>
<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'suggestUsername','firstName' => 'REPLACE1','lastName' => 'REPLACE2','escape' => false), $this);?>
<?php echo '\'.replace(\'REPLACE1\', escape(document.userForm.firstName.value)).replace(\'REPLACE2\', escape(document.userForm.lastName.value)), null, \'get\');
	}

// -->
</script>
'; ?>

<?php endif; ?>

<?php if ($this->_tpl_vars['userCreated']): ?>
<p><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.userCreatedSuccessfully"), $this);?>
</p>
<?php endif; ?>

<h3><?php if ($this->_tpl_vars['userId']): ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.editProfile"), $this);?>
<?php else: ?><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.createUser"), $this);?>
<?php endif; ?></h3>

<form name="userForm" method="post" action="<?php echo $this->_plugins['function']['url'][0][0]->smartyUrl(array('op' => 'updateUser'), $this);?>
" onsubmit="enablePasswordFields()">
<input type="hidden" name="source" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['source'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />
<?php if ($this->_tpl_vars['userId']): ?>
<input type="hidden" name="userId" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['userId'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />
<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/formErrors.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<table width="100%" class="data">
<?php if (count ( $this->_tpl_vars['formLocales'] ) > 1): ?>
	 <tr valign="top">
	 	<td width="20%" class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'formLocale','key' => "form.formLanguage"), $this);?>
</td>
		<td width="80%" class="value">
			<?php echo ((is_array($_tmp=$this->_plugins['function']['url'][0][0]->smartyUrl(array('page' => 'manager','op' => 'editUser','path' => $this->_tpl_vars['userId'],'escape' => false), $this))) ? $this->_run_mod_handler('assign', true, $_tmp, 'userFormUrl') : $this->_plugins['modifier']['assign'][0][0]->smartyAssign($_tmp, 'userFormUrl'));?>

			<?php echo $this->_plugins['function']['form_language_chooser'][0][0]->smartyFormLanguageChooser(array('form' => 'userForm','url' => $this->_tpl_vars['userFormUrl']), $this);?>

			<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "form.formLanguage.description"), $this);?>
</span>
		</td>
	</tr>
<?php endif; ?>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'salutation','key' => "user.salutation"), $this);?>
</td>
		<td class="value"><input type="text" name="salutation" id="salutation" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['salutation'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="20" maxlength="40" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'firstName','required' => 'true','key' => "user.firstName"), $this);?>
</td>
		<td class="value"><input type="text" name="firstName" id="firstName" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['firstName'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="20" maxlength="40" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'middleName','key' => "user.middleName"), $this);?>
</td>
		<td class="value"><input type="text" name="middleName" id="middleName" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['middleName'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="20" maxlength="40" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'lastName','required' => 'true','key' => "user.lastName"), $this);?>
</td>
		<td class="value"><input type="text" name="lastName" id="lastName" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['lastName'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="20" maxlength="90" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('suppressId' => 'true','name' => 'gender','key' => "user.gender"), $this);?>
</td>
		<td class="value">
			<select name="gender" id="gender" size="1" class="selectMenu">
				<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['genderOptions'],'selected' => $this->_tpl_vars['gender']), $this);?>

			</select>
		</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'initials','key' => "user.initials"), $this);?>
</td>
		<td class="value"><input type="text" name="initials" id="initials" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['initials'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="5" maxlength="5" class="textField" />&nbsp;&nbsp;<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.initialsExample"), $this);?>
</td>
	</tr>
	<?php if (! $this->_tpl_vars['userId']): ?>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'enrollAs','key' => "manager.people.enrollUserAs"), $this);?>
</td>
		<td class="value">
			<select name="enrollAs[]" id="enrollAs" multiple="multiple" size="11" class="selectMenu">
			<?php echo $this->_plugins['function']['html_options_translate'][0][0]->smartyHtmlOptionsTranslate(array('options' => $this->_tpl_vars['roleOptions'],'selected' => $this->_tpl_vars['enrollAs']), $this);?>

			</select>
			<br />
			<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.enrollUserAsDescription"), $this);?>
</span>
		</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'username','required' => 'true','key' => "user.username"), $this);?>
</td>
		<td class="value">
			<input type="text" name="username" id="username" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['username'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="20" maxlength="32" class="textField" />&nbsp;&nbsp;<input type="button" class="button" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.suggest"), $this);?>
" onclick="generateUsername()" />
			<br />
			<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.register.usernameRestriction"), $this);?>
</span>
		</td>
	</tr>
	<?php else: ?>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('suppressId' => 'true','name' => 'username','key' => "user.username"), $this);?>
</td>
		<td class="value"><strong><?php echo ((is_array($_tmp=$this->_tpl_vars['username'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</strong></td>
	</tr>
	<?php endif; ?>
	<?php if ($this->_tpl_vars['authSourceOptions']): ?>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'authId','key' => "manager.people.authSource"), $this);?>
</td>
		<td class="value"><select name="authId" id="authId" size="1" class="selectMenu">
			<option value=""></option>
			<?php echo smarty_function_html_options(array('options' => $this->_tpl_vars['authSourceOptions'],'selected' => $this->_tpl_vars['authId']), $this);?>

		</select></td>
	</tr>
	<?php endif; ?>

	<?php if (! $this->_tpl_vars['implicitAuth']): ?>
		<tr valign="top">
			<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'password','required' => $this->_tpl_vars['passwordRequired'],'key' => "user.password"), $this);?>
</td>
			<td class="value">
				<input type="password" name="password" id="password" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['password'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="20" maxlength="32" class="textField" />
				<br />
				<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.register.passwordLengthRestriction",'length' => $this->_tpl_vars['minPasswordLength']), $this);?>
</span>
			</td>
		</tr>
		<tr valign="top">
			<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'password2','required' => $this->_tpl_vars['passwordRequired'],'key' => "user.register.repeatPassword"), $this);?>
</td>
			<td class="value"><input type="password" name="password2"  id="password2" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['password2'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="20" maxlength="32" class="textField" /></td>
		</tr>
		<?php if ($this->_tpl_vars['userId']): ?>
		<tr valign="top">
			<td>&nbsp;</td>
			<td class="value"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.register.passwordLengthRestriction",'length' => $this->_tpl_vars['minPasswordLength']), $this);?>
<br /><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.profile.leavePasswordBlank"), $this);?>
</td>
		</tr>
		<?php else: ?>
		<tr valign="top">
			<td class="label">&nbsp;</td>
			<td class="value"><input type="checkbox" onclick="setGenerateRandom(this.checked)" name="generatePassword" id="generatePassword" value="1"<?php if ($this->_tpl_vars['generatePassword']): ?> checked="checked"<?php endif; ?> /> <label for="generatePassword"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.createUserGeneratePassword"), $this);?>
</label></td>
		</tr>
		<tr valign="top">
			<td class="label">&nbsp;</td>
			<td class="value"><input type="checkbox" name="sendNotify" id="sendNotify" value="1"<?php if ($this->_tpl_vars['sendNotify']): ?> checked="checked"<?php endif; ?> /> <label for="sendNotify"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.createUserSendNotify"), $this);?>
</label></td>
		</tr>
		<?php endif; ?>
		<tr valign="top">
			<td class="label">&nbsp;</td>
			<td class="value"><input type="checkbox" name="mustChangePassword" id="mustChangePassword" value="1"<?php if ($this->_tpl_vars['mustChangePassword']): ?> checked="checked"<?php endif; ?> /> <label for="mustChangePassword"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.userMustChangePassword"), $this);?>
</label></td>
		</tr>
	<?php endif; ?>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'affiliation','key' => "user.affiliation"), $this);?>
</td>
		<td class="value">
			<textarea name="affiliation[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
]" id="affiliation" rows="5" cols="40" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['affiliation'][$this->_tpl_vars['formLocale']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea><br/>
			<span class="instruct"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.affiliation.description"), $this);?>
</span>
		</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'signature','key' => "user.signature"), $this);?>
</td>
		<td class="value"><textarea name="signature[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
]" id="signature" rows="5" cols="40" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['signature'][$this->_tpl_vars['formLocale']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'email','required' => 'true','key' => "user.email"), $this);?>
</td>
		<td class="value"><input type="text" name="email" id="email" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['email'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="30" maxlength="90" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'userUrl','key' => "user.url"), $this);?>
</td>
		<td class="value"><input type="text" name="userUrl" id="userUrl" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['userUrl'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="30" maxlength="90" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'phone','key' => "user.phone"), $this);?>
</td>
		<td class="value"><input type="text" name="phone" id="phone" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['phone'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="15" maxlength="24" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'fax','key' => "user.fax"), $this);?>
</td>
		<td class="value"><input type="text" name="fax" id="fax" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['fax'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" size="15" maxlength="24" class="textField" /></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('for' => 'interests','key' => "user.interests"), $this);?>
</td>
		<td class="value"><ul id="interests"><li></li></ul><br />
			<textarea name="interests" id="interestsTextOnly" rows="5" cols="40" class="textArea">
				<?php $_from = $this->_tpl_vars['interestsKeywords']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['currentInterests'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['currentInterests']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['interest']):
        $this->_foreach['currentInterests']['iteration']++;
?><?php echo ((is_array($_tmp=$this->_tpl_vars['interest'])) ? $this->_run_mod_handler('urldecode', true, $_tmp) : urldecode($_tmp)); ?>
<?php if (! ($this->_foreach['currentInterests']['iteration'] == $this->_foreach['currentInterests']['total'])): ?>, <?php endif; ?><?php endforeach; endif; unset($_from); ?>
			</textarea>
		</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'gossip','key' => "user.gossip"), $this);?>
</td>
		<td class="value"><textarea name="gossip[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
]" id="gossip" rows="3" cols="40" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['gossip'][$this->_tpl_vars['formLocale']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'mailingAddress','key' => "common.mailingAddress"), $this);?>
</td>
		<td class="value"><textarea name="mailingAddress" id="mailingAddress" rows="3" cols="40" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['mailingAddress'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea></td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'country','key' => "common.country"), $this);?>
</td>
		<td class="value">
			<select name="country" id="country" class="selectMenu">
				<option value=""></option>
				<?php echo smarty_function_html_options(array('options' => $this->_tpl_vars['countries'],'selected' => $this->_tpl_vars['country']), $this);?>

			</select>
		</td>
	</tr>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['fieldLabel'][0][0]->smartyFieldLabel(array('name' => 'biography','key' => "user.biography"), $this);?>
<br /><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.biography.description"), $this);?>
</td>
		<td class="value"><textarea name="biography[<?php echo ((is_array($_tmp=$this->_tpl_vars['formLocale'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
]" id="biography" rows="5" cols="40" class="textArea"><?php echo ((is_array($_tmp=$this->_tpl_vars['biography'][$this->_tpl_vars['formLocale']])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</textarea></td>
	</tr>
	<?php if (count ( $this->_tpl_vars['availableLocales'] ) > 1): ?>
	<tr valign="top">
		<td class="label"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "user.workingLanguages"), $this);?>
</td>
		<td><?php $_from = $this->_tpl_vars['availableLocales']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['localeKey'] => $this->_tpl_vars['localeName']):
?>
			<input type="checkbox" name="userLocales[]" id="userLocales-<?php echo ((is_array($_tmp=$this->_tpl_vars['localeKey'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" value="<?php echo ((is_array($_tmp=$this->_tpl_vars['localeKey'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
"<?php if ($this->_tpl_vars['userLocales'] && in_array ( $this->_tpl_vars['localeKey'] , $this->_tpl_vars['userLocales'] )): ?> checked="checked"<?php endif; ?> /> <label for="userLocales-<?php echo ((is_array($_tmp=$this->_tpl_vars['localeKey'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
"><?php echo ((is_array($_tmp=$this->_tpl_vars['localeName'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
</label><br />
		<?php endforeach; endif; unset($_from); ?></td>
	</tr>
	<?php endif; ?>
</table>

<p><input type="submit" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.save"), $this);?>
" class="button defaultButton" /> <?php if (! $this->_tpl_vars['userId']): ?><input type="submit" name="createAnother" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "manager.people.saveAndCreateAnotherUser"), $this);?>
" class="button" /> <?php endif; ?><input type="button" value="<?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.cancel"), $this);?>
" class="button" onclick="<?php if ($this->_tpl_vars['source'] == ''): ?>history.go(-1);<?php else: ?>document.location='<?php echo ((is_array($_tmp=$this->_tpl_vars['source'])) ? $this->_run_mod_handler('escape', true, $_tmp, 'jsparam') : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp, 'jsparam')); ?>
';<?php endif; ?>" /></p>

<p><span class="formRequired"><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => "common.requiredField"), $this);?>
</span></p>

</form>

<?php if ($this->_tpl_vars['generatePassword']): ?>
<?php echo '
	<script type="text/javascript">
		<!--
		setGenerateRandom(1);
		// -->
	</script>
'; ?>

<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
