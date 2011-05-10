<?php /* Smarty version 2.6.26, created on 2011-05-10 21:37:31
         compiled from submission/comment/header.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'translate', 'submission/comment/header.tpl', 16, false),array('modifier', 'escape', 'submission/comment/header.tpl', 17, false),)), $this); ?>
<?php echo '<?xml'; ?>
 version="1.0" encoding="UTF-8"<?php echo '?>'; ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['pageTitle']), $this);?>
</title>
	<meta http-equiv="Content-Type" content="text/html; charset=<?php echo ((is_array($_tmp=$this->_tpl_vars['defaultCharset'])) ? $this->_run_mod_handler('escape', true, $_tmp) : $this->_plugins['modifier']['escape'][0][0]->smartyEscape($_tmp)); ?>
" />
	<meta name="description" content="" />
	<meta name="keywords" content="" />

	<link rel="stylesheet" href="<?php echo $this->_tpl_vars['baseUrl']; ?>
/lib/pkp/styles/common.css" type="text/css" />
	<link rel="stylesheet" href="<?php echo $this->_tpl_vars['baseUrl']; ?>
/styles/common.css" type="text/css" />
	<link rel="stylesheet" href="<?php echo $this->_tpl_vars['baseUrl']; ?>
/styles/comments.css" type="text/css" />

	<?php $_from = $this->_tpl_vars['stylesheets']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['cssUrl']):
?>
		<link rel="stylesheet" href="<?php echo $this->_tpl_vars['cssUrl']; ?>
" type="text/css" />
	<?php endforeach; endif; unset($_from); ?>

	<!-- Base Jquery -->
	<?php if ($this->_tpl_vars['allowCDN']): ?><script type="text/javascript" src="http://www.google.com/jsapi"></script>
	<script type="text/javascript"><?php echo '
		// Provide a local fallback if the CDN cannot be reached
		if (typeof google == \'undefined\') {
			document.write(unescape("%3Cscript src=\''; ?>
<?php echo $this->_tpl_vars['baseUrl']; ?>
<?php echo '/lib/pkp/js/lib/jquery/jquery.min.js\' type=\'text/javascript\'%3E%3C/script%3E"));
			document.write(unescape("%3Cscript src=\''; ?>
<?php echo $this->_tpl_vars['baseUrl']; ?>
<?php echo '/lib/pkp/js/lib/jquery/plugins/jqueryUi.min.js\' type=\'text/javascript\'%3E%3C/script%3E"));
		} else {
			google.load("jquery", "'; ?>
<?php echo @CDN_JQUERY_VERSION; ?>
<?php echo '");
			google.load("jqueryui", "'; ?>
<?php echo @CDN_JQUERY_UI_VERSION; ?>
<?php echo '");
		}
	'; ?>
</script>
	<?php else: ?>
	<script type="text/javascript" src="<?php echo $this->_tpl_vars['baseUrl']; ?>
/lib/pkp/js/lib/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="<?php echo $this->_tpl_vars['baseUrl']; ?>
/lib/pkp/js/lib/jquery/plugins/jqueryUi.min.js"></script>
	<?php endif; ?>

	<script type="text/javascript" src="<?php echo $this->_tpl_vars['baseUrl']; ?>
/lib/pkp/js/general.js"></script>
	<?php echo $this->_tpl_vars['additionalHeadData']; ?>

</head>
<body>
<?php echo '
<script type="text/javascript">
<!--
	if (self.blur) { self.focus(); }
// -->
</script>
'; ?>


<div id="container">
<div id="body">
<div id="main">
<h2><?php echo $this->_plugins['function']['translate'][0][0]->smartyTranslate(array('key' => $this->_tpl_vars['pageTitle']), $this);?>
</h2>
<div id="content">

