Add-Type -AssemblyName System.Windows.Forms;
Add-Type -AssemblyName System.Drawing;

function Close-Process {
    Unregister-Event -SourceIdentifier Change;
    $watcher.EnableRaisingEvents = $false;
    $watcher.Dispose();
	$main.Visible = $false;
    Stop-Process -Id $pid;
}

$main = New-Object System.Windows.Forms.NotifyIcon;
$main.Text = "NotiFire";
$main.Icon = "ico.ico";
$main.BalloonTipIcon = "None";
$main.BalloonTipTitle = "Break Time";
$main.Visible = $true;

$main.Add_Click({
    Close-Process;
})

$form = New-Object System.Windows.Forms.Form;
$form.Text = "Notifire";
$form.FormBorderStyle = "Fixed3D";
$form.MaximizeBox = $false;
$form.Icon = "ico.ico";
$form.Size = New-Object System.Drawing.Size(360, 200);
$form.StartPosition = "CenterScreen";

$okButton = New-Object System.Windows.Forms.Button;
$okButton.Location = New-Object System.Drawing.Point(80, 125);
$okButton.Size = New-Object System.Drawing.Size(75, 23);
$okButton.Text = "OK";
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK;
$form.AcceptButton = $okButton;
$form.Controls.Add($okButton);

$cancelButton = New-Object System.Windows.Forms.Button;
$cancelButton.Location = New-Object System.Drawing.Point(185, 125);
$cancelButton.Size = New-Object System.Drawing.Size(75, 23);
$cancelButton.Text = "Cancel";
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel;
$form.CancelButton = $cancelButton;
$form.Controls.Add($cancelButton);

$label = New-Object System.Windows.Forms.Label;
$label.Location = New-Object System.Drawing.Point(10, 15);
$label.Size = New-Object System.Drawing.Size(320, 40);
$label.Text = "Please enter the time you would like to receive a notification:";
$label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label);

$timePicker = New-Object System.Windows.Forms.DateTimePicker;
$timePicker.Location = New-Object System.Drawing.Size(130, 65);
$timePicker.Width = "70";
$timePicker.ShowUpDown = $true;
$timePicker.Format = [windows.forms.datetimepickerFormat]::custom;
$timePicker.CustomFormat = "HH:mm";
$timePicker.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$setTime = Get-Content -Path .\time.txt -TotalCount 1;
$timePicker.Text = $setTime;
$form.Controls.Add($timePicker);

$checkbox = New-Object System.Windows.Forms.Checkbox;
$checkbox.Location = New-Object System.Drawing.Size(10, 95);
$checkbox.Width = "120";
$checkbox.Text = "Watch folder";
$checkbox.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$checkbox.TabIndex = 4;
$form.Controls.Add($checkbox);

$form.Topmost = $true;

$form.Add_Shown({$timePicker.Select()});
$result = $form.ShowDialog();

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $newTime = $timePicker.Text;
    if ($setTime -ne $newTime) {
        Set-Content -Path .\time.txt -Value $newTime -NoNewline;
        $setTime = $newTime;
    }
    $main.BalloonTipText = "Notification time set to " + $setTime;
    $main.ShowBalloonTip(20000);

    if ($checkbox.Checked -eq $true) {
        $browser = New-Object System.Windows.Forms.FolderBrowserDialog;
        $path = Get-Content -Path .\path.txt -TotalCount 1;
        $browser.SelectedPath = $path;
        $browserResult = $browser.ShowDialog();
        if ($browserResult -eq [System.Windows.Forms.DialogResult]::CANCEL) {
            Close-Process;
        }
        $newPath = $browser.SelectedPath;
        if ($path -ne $newPath) {
            Set-Content -Path .\path.txt -Value $newPath -NoNewline;
            $path = $newPath;
        }

        explorer $path;
        $watcher = New-Object System.IO.FileSystemWatcher;
        $watcher.Path = $path;
        $watcher.EnableRaisingEvents = $true;

        $action = {
            $main = New-Object System.Windows.Forms.NotifyIcon;
            $main.Text = "NotiFire";
            $main.Icon = "ico.ico";
            $main.BalloonTipIcon = "None";
            $main.BalloonTipTitle = "New Change";
            $main.Visible = $true;

            $main.Add_Click({
                $main.Visible = $false;
            })
            $main.BalloonTipText = "New Change";
            $main.ShowBalloonTip(20000);
        }

        Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action -SourceIdentifier Change;
    }
} else {
    Close-Process;
}

while ($true) {
    $theTime = Get-Date -format HH:mm;
    if ($theTime.equals($setTime)) {
        $main.BalloonTipText = $theTime;
        $main.ShowBalloonTip(20000);
        Wait-Event -Timeout 60;
    }
    Wait-Event -Timeout 5;
}
