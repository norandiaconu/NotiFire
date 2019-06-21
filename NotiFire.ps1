[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');

$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon;
$Main_Tool_Icon.Text = "NotiFire";
$Main_Tool_Icon.Icon = "ico.ico";
$Main_Tool_Icon.BalloonTipIcon = "None";
$Main_Tool_Icon.BalloonTipTitle = "Break Time";
$Main_Tool_Icon.Visible = $true;

$Main_Tool_Icon.Add_Click({
    Unregister-Event -SourceIdentifier Change;
    $watcher.EnableRaisingEvents = $false;
    $watcher.Dispose();
	$Main_Tool_Icon.Visible = $false;
    Stop-Process -Id $pid;
})

$path = "c:\folderPath"
explorer $path

$watcher = New-Object System.IO.FileSystemWatcher;
$watcher.Path  = $path;
$watcher.Filter = "*.txt";
$watcher.EnableRaisingEvents = $true;

$action = {
    $Main_Tool_Icon2 = New-Object System.Windows.Forms.NotifyIcon;
    $Main_Tool_Icon2.Text = "NotiFire";
    $Main_Tool_Icon2.Icon = "ico.ico";
    $Main_Tool_Icon2.BalloonTipIcon = "None";
    $Main_Tool_Icon2.BalloonTipTitle = "New Message";
    $Main_Tool_Icon2.Visible = $true;

    $Main_Tool_Icon2.Add_Click({
	    $Main_Tool_Icon2.Visible = $false;
    })
    $Main_Tool_Icon2.BalloonTipText = "New Message";
    $Main_Tool_Icon2.ShowBalloonTip(20000);
}

Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action -SourceIdentifier Change;

while ($true) {
    $theTime = Get-Date -format HH:mm;
    if ($theTime.equals("11:15") -or $theTime.equals("14:45")) {
        $Main_Tool_Icon.BalloonTipText = $theTime;
        $Main_Tool_Icon.ShowBalloonTip(20000);
    }
    Wait-Event -Timeout 5;
}
