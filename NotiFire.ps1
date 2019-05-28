[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');

$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon;
$Main_Tool_Icon.Text = "NotiFire";
$Main_Tool_Icon.Icon = "ico.ico";
$Main_Tool_Icon.BalloonTipIcon = "None";
$Main_Tool_Icon.BalloonTipTitle = "Break Time";
$Main_Tool_Icon.Visible = $True;

$Main_Tool_Icon.Add_Click({
	$Main_Tool_Icon.Visible = $false;
    Stop-Process -Id $pid;
})

while ($true) {
    $theTime = Get-Date -format HH:mm;
    if ($theTime.equals("11:15") -or $theTime.equals("14:45")) {
        $Main_Tool_Icon.BalloonTipText = $theTime;
        $Main_Tool_Icon.ShowBalloonTip(20000);
    }
    Start-Sleep 5;
}
