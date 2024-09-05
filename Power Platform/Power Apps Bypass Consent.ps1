# Sets the consent bypass flag so users aren't required to authorize API connections for the input app in Power Apps.
$environmentID = "[YOUR ENV ID]"
$appID = "[YOUR APP ID]"
Set-AdminPowerAppApisToBypassConsent -EnvironmentName $environmentID -AppName $appID
