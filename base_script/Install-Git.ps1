function Get-Install-File() {
    # 设置 Git 下载 URL 和安装路径
#     $gitInstallerUrl = "https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe"
    $gitInstallerUrl = "https://registry.npmmirror.com/-/binary/git-for-windows/v2.46.0.windows.1/Git-2.46.0-64-bit.exe"
    $tmpPath = ".\Git-2.46.0-64-bit.exe"

    if (Test-Path $tmpPath) {
        Write-Host "识别到git安装文件 $tmpPath" -ForegroundColor Red
        return $true;
    }

    Write-Host "正在下载git: $gitInstallerUrl"
    try {
        $wc = New-Object net.webclient
        $wc.Downloadfile($gitInstallerUrl, $tmpPath)
        Write-Host "git安装文件下载完成 $tmpPath" -ForegroundColor Red
        return $true
    } catch {
        Write-Host "请使用百度云链接, 下载$tmpPath，放到项目根目录"
        Write-Host "https://pan.baidu.com/s/1NfupmHYnfVXn9mtGaZVX-A?pwd=qq1n" -ForegroundColor Red
    }
    return $false
}

function Install-Git {
    # 检查 Git 是否已安装
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $gitPath = Get-Command git | Select-Object -ExpandProperty Source
        Write-Host "Git 已经安装, 安装路径为：$gitPath" -ForegroundColor Red
        return
    }

    # 获取安装文件
    $success = Get-Install-File
    if (-Not $success) {
       Write-Host "按任意键退出脚本"
        # 等待用户按下任意键
        [void][System.Console]::ReadKey($true)
        exit
    }

    # 安装 Git（静默安装）
    Write-Host "正在安装 git ..."
    Start-Process -FilePath $tmpPath -ArgumentList "/VERYSILENT", "/NORESTART" -NoNewWindow -Wait

    # 删除安装文件
    if (Test-Path $tmpPath) {
        Remove-Item $tmpPath -Force
    }

    # 手动刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")

    # 输出 Git 安装路径
    $gitPath = Get-Command git | Select-Object -ExpandProperty Source
    Write-Host "git安装成功，安装路径为：$gitPath" -ForegroundColor Red

    # 验证 Git 安装
    Write-Host "git版本信息:"
    git --version
}
