function Install-Arduino-IDE {
    param (
        [string]$ArduinoInstallFile = "arduino-ide_2.3.2_Windows_64bit.7z.001"
    )

    # 定义 Arduino 安装路径
    $arduinoExePath = "$env:USERPROFILE\AppData\Local\Programs\Arduino IDE\Arduino IDE.exe"

    # 检查 Arduino 是否已经安装
    if (Test-Path -Path $arduinoExePath) {
        Write-Output "Arduino 已经安装, $arduinoExePath。"
        return
    }

    function Find-SevenZipPath {
        $possiblePaths = @(
            "C:\Program Files\7-Zip\7z.exe",
            "C:\Program Files (x86)\7-Zip\7z.exe"
        )

        foreach ($path in $possiblePaths) {
            if (Test-Path -Path $path) {
                return $path
            }
        }

        Write-Output "未找到 7-Zip。请确保 7-Zip 已安装。"
        return $null
    }

    $ArchiveDir = ".\arduino_ide"

    # 查找 7-Zip 安装路径
    $sevenZipPath = Find-SevenZipPath

    # 设置临时解压缩目录
    $tempDir = [System.IO.Path]::GetTempPath() + "arduino_ide_temp\"
    # 创建临时目录
    if (-Not (Test-Path $tempDir)) {
        New-Item -Path $tempDir -ItemType Directory
    } else {
        Get-ChildItem -Path $tempDir -Recurse | Remove-Item -Force
    }

    # 解压缩文件到临时目录
    $command = "& `"$sevenZipPath`" x `"$ArchiveDir\$ArduinoInstallFile`" -bsp0 -y -o`"$tempDir`""
    Invoke-Expression $command

    # 查找解压缩后的 .exe 文件
    $exePath = Get-ChildItem -Path $tempDir -Filter "*.exe" -Recurse | Select-Object -First 1

    if ($exePath) {
        # 执行解压缩后的 .exe 文件
        Write-Output "正在安装 Arduino：$($exePath.FullName)"
        Start-Process -FilePath $exePath.FullName -Wait
        Write-Output "Arduino IDE 安装完成" -ForegroundColor Red
    }

    # 删除临时文件
    if (Test-Path $tempDir) {
       Remove-Item -Path "$tempDir" -Recurse -Force
    }
}
