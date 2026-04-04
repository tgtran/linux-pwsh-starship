# ============================================
# PowerShell Profile - Enhanced Linux-like Shell
# ============================================
#  Force UTF-8 Encoding (CRITICAL for v5.1 Fonts/Icons)
# --------------------------------------------
# This ensures that Starship symbols and Git icons render correctly.
[console]::InputEncoding = [console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# --------------------------------------------
# 1. Load LinuxCompat Module (if installed)
# --------------------------------------------
$LinuxCompatPath = "$Home\Documents\PowerShell\Modules\LinuxCompat"
if (Test-Path $LinuxCompatPath) {
    Import-Module $LinuxCompatPath
} elseif (Get-Module -ListAvailable -Name LinuxCompat) {
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
    $status = if ($LASTEXITCODE -ne 0) { "X" } else { ">" }
    Write-Output "$status $($env:COMPUTERNAME):$path$git "
}

# --------------------------------------------
# 3. PSReadLine Enhancements
# --------------------------------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    $psr = Get-Module -ListAvailable -Name PSReadLine | Sort-Object Version -Descending | Select-Object -First 1
    
    # Predictions require v2.1.0 or higher
    if ($psr.Version -ge [version]"2.1.0") {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
    }
    
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
}

# --------------------------------------------
# 4. Auto-CD (type a folder name to enter it)
# --------------------------------------------

if (Get-Module -ListAvailable -Name PSReadLine) {
    $psr = Get-Module -ListAvailable -Name PSReadLine | Sort-Object Version -Descending | Select-Object -First 1
    
    # Predictions require v2.1.0 or higher
    if ($psr.Version -ge [version]"2.1.0") {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
    }
    
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
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

function Move-FilesToFolders {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [string]$Path,

        [Parameter(Position=1)]
        [string[]]$Extension = @(".m4b", ".jpg", ".mp3")
    )

    process {
        if (-not (Test-Path $Path)) {
            Write-Error "Path '$Path' does not exist."
            return
        }

        # Filter files based on the extensions provided
        $files = Get-ChildItem -Path $Path -File -Include $Extension

        foreach ($file in $files) {
            $targetFolder = Join-Path -Path $Path -ChildPath $file.BaseName
            
            if (-not (Test-Path $targetFolder)) {
                New-Item -Path $targetFolder -ItemType Directory -Force | Out-Null
            }

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

function Remove-dash {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [string]$Path
         )

    process {
        if (-not (Test-Path $Path)) {
            Write-Error "Path '$Path' does not exist."
            return}
        Get-ChildItem -path $Path -filter *_* | ForEach-Object { Rename-Item $_ -NewName ($_.Name -replace "_", "") }

   }
}

Invoke-Expression (&starship init powershell)

# --------------------------------------------
# 9. Startup Message
# --------------------------------------------
Write-Host "Enhanced PowerShell environment loaded." -ForegroundColor Cyan
