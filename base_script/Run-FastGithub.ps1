function Run-FastGithub {
    # 检查 fastgithub.exe 是否正在运行
    $processRunning = Get-Process -Name "fastgithub" -ErrorAction SilentlyContinue
    while ($processRunning) {
        Write-Output "正在终止 fastgithub"
        Stop-Process -Name "fastgithub" -Force
        Start-Sleep -Seconds 2 # 等待进程终止
        $processRunning = Get-Process -Name "fastgithub" -ErrorAction SilentlyContinue
    }

    Write-Output "fastgithub 已停止"

    # 启动 fastgithub
    $fastGithubPath = ".\fastgithub_win-x64\fastgithub.exe"
    Start-Process -FilePath $fastGithubPath -NoNewWindow
#     Start-Process -FilePath $fastGithubPath
    Write-Output "fastgithub 已启动" -ForegroundColor Red
}
