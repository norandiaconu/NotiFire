[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
$notification = New-Object System.Windows.Forms.NotifyIcon;
$notification.Icon = "ico.ico";
$notification.BalloonTipIcon = "None";
$notification.BalloonTipText = $args[0];
$notification.BalloonTipTitle = "Break Time";
$notification.Visible = $True;
$notification.ShowBalloonTip(20000);