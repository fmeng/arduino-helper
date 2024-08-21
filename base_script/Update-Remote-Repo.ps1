function Do-Update-Repo {
    Write-Host "正在更新最新代码 $remoteCommit" -ForegroundColor Red
    & git fetch origin master 2>&1 | Out-Null
    & git reset --hard "origin/master"
    & git clean -fd
}

function Git-Installed {
  if (Get-Command git -ErrorAction SilentlyContinue) {
        return $true
   }
   return $false
}

function Try-Init-Repo {
    $remoteGiteeRepo = "git@gitee.com:fmeng-no-bug/arduino-helper.git"

    # 当前目录不是 git 仓库
    if (-not (Test-Path -Path ".git")) {
        git init .
        git remote add origin $remoteGiteeRepo
        Write-Host "初始化项目地址0 origin $remoteGiteeRepo" -ForegroundColor Red
        return
    }

    # remote中无origin
    $remotes = git remote
    if (-not ($remotes -contains "origin")) {
        git remote add origin $remoteGiteeRepo
        Write-Host "初始化项目地址1 origin $remoteGiteeRepo" -ForegroundColor Red
        return
    }

    # remote中有origin, url不是gitee的
    $originUrl = git remote get-url origin
    if (-not ($originUrl -eq $remoteGiteeRepo)) {
        git remote set-url origin $remoteGiteeRepo
        Write-Host "初始化项目地址2 origin $remoteGiteeRepo" -ForegroundColor Red
        return
     }
}

function Remote-Repo-Updated  {
    # 检查当前目录是否为 Git 仓库
    if (-not (Test-Path .git)) {
        Write-Output "当前目录不是 Git 仓库"
        return $false
    }

    $remoteGitUrl = git remote get-url origin
    set GIT_ASK_YESNO=false

    # 拉取远程分支更新
    & git fetch origin master 2>&1 | Out-Null

    # 检查是否有差异
    $diff = git --no-pager diff --name-only "origin/master"

    if ($diff) {
        Write-Output "代码有更新：$remoteGitUrl" -ForegroundColor Red
        return $true
    }

    Write-Output "代码没有更新"
    return $false
}