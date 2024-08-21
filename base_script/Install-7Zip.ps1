function Install-7Zip {
    # 如果已经安装，忽略
    if (Test-Path "C:\Program Files\7-Zip\7z.exe") {
        Write-Host "7-Zip 已经安装, 安装路径为：C:\Program Files\7-Zip\7z.exe"
        return
    }
    if (Test-Path "C:\Program Files (x86)\7-Zip\7z.exe") {
        Write-Host "7-Zip 已经安装, 安装路径为：C:\Program Files (x86)\7-Zip\7z.exe"
        return
    }

    # 设置 7-Zip 下载 URL 和安装路径
    $installExeFile = ".\7-Zip\7z2301-x64.exe"
    
    # 安装 7-Zip（静默安装）
    Write-Host "正在安装 7-Zip, $installExeFile"
    Start-Process -FilePath $installExeFile -ArgumentList "/S" -NoNewWindow -Wait

    # 输出 7-Zip 安装路径
    if (Test-Path "C:\Program Files\7-Zip\7z.exe") {
        Write-Host "7-Zip 已经安装, 安装路径为：C:\Program Files\7-Zip\7z.exe" -ForegroundColor Red
        return
    }
    if (Test-Path "C:\Program Files (x86)\7-Zip\7z.exe") {
        Write-Host "7-Zip 已经安装, 安装路径为：C:\Program Files (x86)\7-Zip\7z.exe" -ForegroundColor Red
        return
    }
}