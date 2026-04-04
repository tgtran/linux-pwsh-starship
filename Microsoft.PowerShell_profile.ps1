# ============================================
# PowerShell Profile - Enhanced Linux-like Shell
# ============================================

# --------------------------------------------
# 1. Load LinuxCompat Module
# --------------------------------------------
$LinuxCompatPath = "C:\Users\coe-admin\Documents\PowerShell\Modules\LinuxCompat"
if (Test-Path $LinuxCompatPath) {
    Import-Module $LinuxCompatPath
} elseif (Get-Module -ListAvailable -Name LinuxCompat) {
    Import-Module LinuxCompat
}

# --------------------------------------------
# 2. Modern, Informative Prompt (Fallback)
# --------------------------------------------
function prompt {
    $path = Split-Path -Leaf (Get-Location)
    $git = ""
    if (Test-Path .git) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) { $git = " [$branch]" }
    }
    $status = if ($LASTEXITCODE -ne 0) { "✗" } else { "✓" }
    "$status $($env:COMPUTERNAME):$path$git > "
}

# --------------------------------------------
# 3. PSReadLine Enhancements
# --------------------------------------------
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory

# --------------------------------------------
# 4. Auto-CD & Editor Shortcuts
# --------------------------------------------
Set-PSReadLineOption -AddToHistoryHandler {
    param($line)
    if (Test-Path $line -PathType Container) {
        Set-Location $line
        return $false
    }
    return $true
}

function e { code . }
function np { & "C:\Program Files\Notepad++\notepad++.exe" $args }

# --------------------------------------------
# 5. Directory Bookmarks
# --------------------------------------------
$global:marks = @{}
function mark { param($name) $global:marks[$name] = (Get-Location).Path }
function jump { param($name) Set-Location $global:marks[$name] }

# --------------------------------------------
# 6. Utility Functions
# --------------------------------------------
function reload { . $PROFILE }

function cleanup {
    Remove-Item -Recurse -Force "$env:TEMP\*" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "c:\windows\TEMP\*" -ErrorAction SilentlyContinue
    Write-Host "Temp cleaned." -ForegroundColor Cyan
}

function pingurl {
    param([string]$url)
    Invoke-WebRequest -Method Head -Uri $url
}

function Move-FilesToFolders {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [string]$Path,
        [Parameter(Position=1)]
        [string[]]$Extension = @(".m4b", ".jpg", ".mp3")
    )
    process {
        if (-not (Test-Path $Path)) { Write-Error "Path '$Path' does not exist."; return }
        $files = Get-ChildItem -Path $Path -File -Include $Extension
        foreach ($file in $files) {
            $targetFolder = Join-Path -Path $Path -ChildPath $file.BaseName
            if (-not (Test-Path $targetFolder)) { New-Item -Path $targetFolder -ItemType Directory -Force | Out-Null }
            
            $finalPath = Join-Path -Path $targetFolder -ChildPath $file.Name
            $counter = 1
            while (Test-Path $finalPath) {
                $newName = "{0}_{1}{2}" -f $file.BaseName, $counter, $file.Extension
                $finalPath = Join-Path -Path $targetFolder -ChildPath $newName
                $counter++
            }
            Move-Item -Path $file.FullName -Destination $finalPath
        }
    }
}

function Remove-Dash {
    param([string]$Path = (Get-Location))
    Get-ChildItem -Path $Path -Filter "*_*" | ForEach-Object { 
        Rename-Item $_.FullName -NewName ($_.Name -replace "_", " ") 
    }
}

# --------------------------------------------
# 7. Starship Theme Management
# --------------------------------------------
$global:_StarshipThemeCache = @()

function Get-StarshipThemes {
    $themePath = "$HOME/.config/starship-themes"
    if (Test-Path $themePath) {
        $global:_StarshipThemeCache = Get-ChildItem $themePath -Filter *.toml | Select-Object -ExpandProperty BaseName
    }
    return $global:_StarshipThemeCache
}

function Set-StarshipTheme {
    param([string]$Name)
    $source = "$HOME/.config/starship-themes/$Name.toml"
    $target = "$HOME/.config/starship.toml"

    if (Test-Path $source) {
        Copy-Item -LiteralPath $source -Destination $target -Force
        Write-Host "Starship theme switched to '$Name'." -ForegroundColor Green
        reload
    } else {
        Write-Host "Theme '$Name' not found." -ForegroundColor Red
    }
}

function Choose-StarshipTheme {
    $themes = Get-StarshipThemes
    if ($themes.Count -eq 0) {
        Write-Host "No themes found in $HOME/.config/starship-themes" -ForegroundColor Yellow
        return
    }

    Write-Host "Available Starship Themes:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $themes.Count; $i++) {
        Write-Host "[$($i + 1)] $($themes[$i])"
    }

    $choice = Read-Host "Select theme number"
    if ([int]::TryParse($choice, [ref]$idx) -and $idx -le $themes.Count -and $idx -gt 0) {
        Set-StarshipTheme $themes[$idx - 1]
    } else {
        Write-Host "Invalid selection." -ForegroundColor Red
    }
}

# Initialize Starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
