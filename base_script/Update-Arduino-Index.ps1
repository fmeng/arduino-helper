function Update-Arduino-Library {
    param (
        [string]$sourceFile
    )

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

    # 设置目标目录
    $dstDirectory = "$env:USERPROFILE\AppData\Local\Arduino15"
    $tarFileName = [System.IO.Path]::GetFileNameWithoutExtension($sourceFile)
    $tempTarFile = Join-Path "$env:TEMP" "$tarFileName"

    # 查找7-Zip的路径
    $sevenZipPath = Find-SevenZipPath
    $command = "& `"$sevenZipPath`" x `"$sourceFile`" -bsp0 -y -o`"$env:TEMP`""
    Invoke-Expression $command

    # 使用tar解压临时tar文件到目标目录
    & tar -xf $tempTarFile -C $dstDirectory
    Write-Host "解压 $sourceFile 到 $dstDirectory 完成" -ForegroundColor Red
    # 删除临时tar文件
    Remove-Item $tempTarFile -Recurse -Force
}

function Update-Arduino-Index {
    Update-Arduino-Library -sourceFile ".\arduino_index\library_index.tar.bz2"
    Update-Arduino-Library -sourceFile ".\arduino_index\package_index.tar.bz2"
}
