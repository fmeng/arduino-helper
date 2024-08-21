function Show-Windows-UpdateDialog {
    param (
        [string]$Message = "代码已更新",
        [string]$Link = "https://gitee.com/fmeng-no-bug/arduino-helper",
        [int]$TimeoutSeconds = 5
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # 创建对话框
    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "更新通知"
    $Form.Width = 350
    $Form.Height = 200
    $Form.StartPosition = "CenterScreen"

    # 添加第一行提示文本
    $LabelMessage = New-Object System.Windows.Forms.Label
    $LabelMessage.Text = $Message
    $LabelMessage.Width = 300
    $LabelMessage.Height = 20
    $LabelMessage.Top = 20
    $LabelMessage.Left = 25
    $Form.Controls.Add($LabelMessage)

    # 添加第二行倒计时文本
    $LabelCountdown = New-Object System.Windows.Forms.Label
    $LabelCountdown.Text = "将在 $TimeoutSeconds 秒后自动关闭"
    $LabelCountdown.Width = 300
    $LabelCountdown.Height = 20
    $LabelCountdown.Top = 50
    $LabelCountdown.Left = 25
    $Form.Controls.Add($LabelCountdown)

    # 创建“打开链接”按钮
    $OpenLinkButton = New-Object System.Windows.Forms.Button
    $OpenLinkButton.Text = "打开链接"
    $OpenLinkButton.Width = 100
    $OpenLinkButton.Height = 30
    $OpenLinkButton.Top = 90
    $OpenLinkButton.Left = 50
    $OpenLinkButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $Form.Controls.Add($OpenLinkButton)

    # 创建“取消”按钮
    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Text = "取消"
    $CancelButton.Width = 100
    $CancelButton.Height = 30
    $CancelButton.Top = 90
    $CancelButton.Left = 180
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $Form.Controls.Add($CancelButton)

    # 处理按钮点击事件
    $Form.AcceptButton = $OpenLinkButton
    $Form.CancelButton = $CancelButton

    # 创建线程计时器用于倒计时显示
    $SecondsRemaining = $TimeoutSeconds
    $TimerCallback = {
        $SecondsRemaining--
        $LabelCountdown.Invoke({
            $LabelCountdown.Text = "$using:SecondsRemaining 秒后自动关闭"
        })
        if ($SecondsRemaining -le 0) {
            $Form.Invoke({ $Form.Close() })
        }
    }

    $Timer = New-Object System.Threading.Timer($TimerCallback, $null, 1000, 1000)

    # 显示对话框并获取用户的选择
    $Result = $Form.ShowDialog()

    # 释放计时器
    $Timer.Dispose()

    # 根据用户选择执行操作
    if ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
        # 用户点击了“打开链接”按钮
        Start-Process $Link
    } elseif ($Result -eq [System.Windows.Forms.DialogResult]::Cancel) {
        Write-Host "用户取消了操作。"
    } else {
        Write-Host "对话框已超时关闭。"
    }

    # 关闭对话框
    $Form.Dispose()
}

# 调用函数
# Show-Windows-UpdateDialog -Message "代码已更新" -Link "https://gitee.com/fmeng-no-bug/arduino-helper" -TimeoutSeconds 5
