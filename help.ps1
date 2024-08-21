# 检查运行权限
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "按任意键后, 输入 Set-ExecutionPolicy Unrestricted"

    [void][System.Console]::ReadKey($true)
}

# 切换目录
$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $scriptDirectory
Write-Output "目录切换到: $scriptDirectory"

# 从 base_script 目录 导入文件
$scriptWinPath = Join-Path -Path (Get-Location) -ChildPath "base_script"
$ps1Files = Get-ChildItem -Path $scriptWinPath -Filter *.ps1
foreach ($file in $ps1Files) {
    . $file.FullName
}

# 确保当删除了一些文件，也能正常运行
$repoUpdated = $false
if (Git-Installed) {
    $repoUpdated = Remote-Repo-Updated
    if ($repoUpdated) {
        Do-Update-Repo
    }
}
# 如果git未安装, 尝试安装
Install-Git
# 尝试初始化仓库
Try-Init-Repo
# 更新代码
$repoUpdated = Remote-Repo-Updated
if ($repoUpdated) {
    Do-Update-Repo
}
# 如果7Zip压缩软件未安装, 尝试安装
Install-7Zip
# 如果ArduinoIDE未安装, 尝试安装
Install-Arduino-IDE
# 如果USB驱动(CH343,CP2102)未安装, 尝试安装
Install-Usb-Driver
# 尝试从远程代码仓库获取最新代码
if ($repoUpdated) {
    # 代码有更新, 就更新Arduino的索引(library_index.json、package_index.json)
    Update-Arduino-Index
}
# 运行github访问优化(Arduino IDE安装库，需要访问github)
Run-FastGithub

Write-Host @"
  _______
 /       \
|  ^   ^  |
|    _    |
|  \___/  |
 \_______/
"@ -ForegroundColor Red