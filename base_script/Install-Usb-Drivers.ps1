# 定义找到 7-Zip 执行文件的函数
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

    Write-Host "7-Zip 未安装，请检查 7-Zip 的安装路径。"
    return $null
}

# 定义安装 USB 驱动的函数
function Install-Usb-Driver-CP2102 {
    param (
        [string]$sevenZipPath
    )

    # 判断 cp2102 驱动是否存在
    $driverExists = Get-ChildItem -Path "C:\Windows\System32\DriverStore\FileRepository" -Force | Where-Object { $_.Name -match "silabser" }
    if ($driverExists) {
        Write-Host "cp2102 驱动已安装" -ForegroundColor Red
        return
    }

    # 解压文件到临时目录
    $tempDir = [System.IO.Path]::GetTempPath() + "CP210x_Install\"
    # 创建临时目录
    if (-Not (Test-Path $tempDir)) {
        New-Item -Path $tempDir -ItemType Directory
    } else {
        Remove-Item -Path "$tempDir" -Recurse -Force
    }

    $command = "& `"$sevenZipPath`" x `".\usb_drivers\CP210x_WIN10.7z`" -bsp0 -y -o`"$tempDir`""
    Invoke-Expression $command

    # 查找并执行 EXE 文件安装驱动
    $exeFile = Get-ChildItem -Path $tempDir -Filter *x64.exe -Recurse | Select-Object -First 1
    if ($exeFile) {
        Start-Process -FilePath $exeFile.FullName -Wait
        Write-Host "cp2102 USB驱动安装完成" -ForegroundColor Red
    }

    # 删除临时文件
    if (Test-Path $tempDir) {
        Remove-Item -Path "$tempDir" -Recurse -Force
    }
}

# 定义安装 CH343 USB 驱动的函数
function Install-Usb-Driver-CH343 {
    param (
        [string]$sevenZipPath
    )

    # 查找 CH343 驱动是否存在
    $driverExists = Get-ChildItem -Path "C:\Windows\System32\DriverStore\FileRepository" -Force | Where-Object { $_.Name -match "ch34" } | Select-Object FullName
    if ($driverExists) {
        Write-Host "CH343 驱动已安装"  -ForegroundColor Red
        return
    }

    # 解压文件到临时目录
    $tempDir = [System.IO.Path]::GetTempPath() + "CH343_Install\"
    # 创建临时目录
    if (-Not (Test-Path $tempDir)) {
        New-Item -Path $tempDir -ItemType Directory
    } else {
        Remove-Item -Path "$tempDir" -Recurse -Force
    }

    $command = "& `"$sevenZipPath`" x `".\usb_drivers\CH343SER.7z`" -bsp0 -y -o`"$tempDir`""
    Invoke-Expression $command

    # 查找并执行 EXE 文件安装驱动
    $exeFile = Get-ChildItem -Path $tempDir -Filter *.exe -Recurse | Select-Object -First 1
    if ($exeFile) {
        Start-Process -FilePath $exeFile.FullName -Wait
        Write-Host "CH343 驱动安装完成" -ForegroundColor Red
    }

    # 删除临时文件
    if (Test-Path $tempDir) {
        Remove-Item -Path "$tempDir" -Recurse -Force
    }
}

function Install-Usb-Driver() {
    $sevenZipPath = Find-SevenZipPath
    Install-Usb-Driver-CH343 -sevenZipPath $sevenZipPath
    Install-Usb-Driver-CP2102 -sevenZipPath $sevenZipPath
}
