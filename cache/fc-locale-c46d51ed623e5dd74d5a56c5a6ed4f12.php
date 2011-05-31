<?php return array (
  'plugins.generic.sword.displayName' => 'SWORD Plugin',
  'plugins.generic.sword.description' => 'Allow Journal Managers and (optionally) Authors to deposit articles via the SWORD protocol',
  'plugins.generic.sword.enabled' => 'The SWORD plugin has been enabled.',
  'plugins.generic.sword.disable' => 'The SWORD plugin has been disabled.',
  'plugins.generic.sword.settings' => 'Settings',
  'plugins.generic.sword.settings.allowAuthorSpecify' => 'Allow the author to specify a deposit point',
  'plugins.generic.sword.settings.depositPoints' => 'Deposit Points',
  'plugins.generic.sword.depositPoints.create' => 'Create Deposit Point',
  'plugins.generic.sword.depositPoints.edit' => 'Edit Deposit Point',
  'plugins.generic.sword.depositPoints.type.automatic' => 'Automatic',
  'plugins.generic.sword.depositPoints.type.optionalSelection' => 'Optional; Flexible',
  'plugins.generic.sword.depositPoints.type.optionalFixed' => 'Optional; Fixed',
  'plugins.generic.sword.depositPoints.type.manager' => 'Manager Only',
  'plugins.generic.sword.depositPoints.type.description' => '<h4>Deposit Point Types:</h4>
<p><strong>Automatic</strong>: The deposit occurs automatically. The full SWORD deposit point is specified. A username and password must be specified. Deposit occurs after notifying the author of acceptance.<br/>
<strong>Optional; Flexible</strong>: The author can choose whether or not to deposit. The specified URL indicates a service document, and the author may choose which specific deposit point to use from that document. Deposit occurs after notifying the author of acceptance.<br/>
<strong>Optional; Fixed</strong>: The author can choose whether or not to deposit. The URL specifies the specific SWORD deposit point. Deposit occurs after notifying the author of acceptance.<br/>
<strong>Manager Only</strong>: Only the Journal Manager may use this deposit point. The URL indicates a service document. Deposit is manually performed by the Journal Manager using the Import/Export interface in Journal Management.
</p>',
  'plugins.generic.sword.depositPoints.password.description' => 'If you do not specify a password here, you and/or the author will be prompted for one when the deposit occurs. Note that this password will be visible to all Journal Managers and will be stored unencrypted in the database.',
  'plugins.generic.sword.depositPoints.name' => 'Name',
  'plugins.generic.sword.automaticDepositComplete' => 'The item "{$itemTitle}" was automatically deposited into the repository "{$repositoryName}".',
  'plugins.generic.sword.depositComplete' => 'The item "{$itemTitle}" was deposited into the repository "{$repositoryName}".',
  'plugins.generic.sword.authorDepositDescription' => '<p>You may optionally use the following form to deposit your submission, "{$submissionTitle}", in one of the repositories listed. Use the checkboxes down the left-hand column to select which repositories you wish to deposit your submission into; each repository may also allow you to specify a deposit point from a pull-down list.</p>',
  'plugins.generic.sword.authorCustomDepositDescription' => '<p>You may optionally specify a SWORD-compliant deposit point in the following form. If desired, please specify a SWORD URL, username and password to your repository and the submission will be deposited.</p>',
  'plugins.importexport.sword.displayName' => 'SWORD Import/Export Deposit Plugin',
  'plugins.importexport.sword.description' => 'Deposit articles in remote repositories using the SWORD deposit protocol',
  'plugins.importexport.sword.deposit' => 'Deposit',
  'plugins.importexport.sword.serviceDocUrl' => 'Service Document URL',
  'plugins.importexport.sword.depositUrl' => 'Deposit Point URL',
  'plugins.importexport.sword.depositPoint' => 'Deposit Point',
  'plugins.importexport.sword.depositPoint.addRemove' => 'Add/Remove',
  'plugins.importexport.sword.depositGalleys' => 'Deposit Galleys',
  'plugins.importexport.sword.depositEditorial' => 'Deposit Most Recent Editorial File',
  'plugins.importexport.sword.depositSuccessful' => 'Deposit Successful',
  'plugins.importexport.sword.depositSuccessfulDescription' => 'The item(s) selected have been deposited.',
  'plugins.importexport.sword.depositFailed' => 'Deposit Failed',
); ?>