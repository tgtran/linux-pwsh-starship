# ============================================
# PowerShell Profile - Enhanced Linux-like Shell
# ============================================

# --------------------------------------------
# 1. Load LinuxCompat Module (if installed)
# --------------------------------------------
if (Get-Module -ListAvailable -Name LinuxCompat) {
    Import-Module LinuxCompat
}

# --------------------------------------------
# 2. Modern, Informative Prompt
# --------------------------------------------
function prompt {
    $path = Split-Path -Leaf (Get-Location)
    $git = ""

    if (Test-Path .git) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) { $git = " [$branch]" }
    }

    $status = if ($LASTEXITCODE -ne 0) { "✗" } else { "✓" }
    $hostName = $env:COMPUTERNAME

    "$status ${hostName}:$path$git > "
}

# --------------------------------------------
# 3. PSReadLine Enhancements
# --------------------------------------------
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory

# --------------------------------------------
# 4. Auto-CD (type a folder name to enter it)
# --------------------------------------------
Set-PSReadLineOption -AddToHistoryHandler {
    param($line)
    if (Test-Path $line -PathType Container) {
        Set-Location $line
        return $false
    }
    return $true
}

# --------------------------------------------
# 5. Editor Shortcuts
# --------------------------------------------
# VS Code
function e { code . }

# Notepad++
function np { & "C:\Program Files\Notepad++\notepad++.exe" $args }

# --------------------------------------------
# 6. Directory Bookmarks
# --------------------------------------------
$global:marks = @{}

function mark { param($name) $global:marks[$name] = (Get-Location).Path }
function jump { param($name) Set-Location $global:marks[$name] }

# --------------------------------------------
# 7. Utility Functions
# --------------------------------------------

# Reload profile
function reload { . $PROFILE }

# Cleanup temp files
function cleanup {
    Remove-Item -Recurse -Force "$env:TEMP\*" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "c:\windows\TEMP\*" -ErrorAction SilentlyContinue
    Write-Host "Temp cleaned."
}

# Quick HEAD request (like curl -I)
function pingurl {
    param([string]$url)
    Invoke-WebRequest -Method Head -Uri $url
}

function Set-StarshipTheme {
    param([string]$Name)

    $source = "$HOME/.config/starship-themes/$Name.toml"
    $target = "$HOME/.config/starship.toml"

    if (Test-Path $source) {
        Copy-Item $source $target -Force
        Write-Host "Starship theme switched to '$Name'." -ForegroundColor Green
        reload
    } else {
        Write-Host "Theme '$Name' not found." -ForegroundColor Red
    }
}

function Choose-StarshipTheme {
    $themes = Get-ChildItem "$HOME/.config/starship-themes" -Filter *.toml |
              Select-Object -ExpandProperty BaseName

    Write-Host "Available Starship Themes:" -ForegroundColor Cyan
    $i = 1
    foreach ($t in $themes) {
        Write-Host "[$i] $t"
        $i++
    }

    $choice = Read-Host "Select theme number"
    $selected = $themes[$choice - 1]

    if ($selected) {
        Set-StarshipTheme $selected
    } else {
        Write-Host "Invalid selection." -ForegroundColor Red
    }
}

Invoke-Expression (&starship init powershell)

# --------------------------------------------
# 9. Startup Message
# --------------------------------------------
Write-Host "Enhanced PowerShell environment loaded." -ForegroundColor Cyan
