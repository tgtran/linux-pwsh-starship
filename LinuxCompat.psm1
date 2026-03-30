# ================================
# LinuxCompat PowerShell Module
# TGT 03/26/2026
# ================================

# -------------------------------
# Color Helpers
# -------------------------------
function Write-Color {
    param(
        [string]$Text,
        [ConsoleColor]$Color = "White"
    )
    $orig = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Output $Text
    $Host.UI.RawUI.ForegroundColor = $orig
}

# Safe aliases
Set-Alias ll Get-ChildItem | ft Name, Length, LastWriteTime, Mode -autosize
Set-Alias lcd Set-Location

# Linux-style command overrides (functions override aliases safely)

function cp { Copy-Item @args }
function mv { Move-Item @args }
function rm { Remove-Item @args }
function ls { Get-ChildItem @args }
function cd { Set-Location @args }
function pwd { Get-Location @args }
function cat { Get-Content @args }
function man { help @args }
function sort { Sort-Object @args }
function sleep { Start-Sleep @args }
function mkdir { New-Item -ItemType Directory @args }
function ps { Get-Process @args }

# -------------------------------
# Enhanced Linux-like Functions
# -------------------------------

# touch — create file or update timestamp
function touch {
    param([string]$Path)
    if (Test-Path $Path) {
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Path $Path | Out-Null
    }
}

# head — show first N lines
function head {
    param(
        [string]$Path,
        [int]$Lines = 10
    )
    Get-Content -Path $Path -TotalCount $Lines
}

# tail — show last N lines (with -f)
function tail {
    param(
        [string]$Path,
        [int]$Lines = 10,
        [switch]$f
    )

    if ($f) {
        Get-Content -Path $Path -Wait
    } else {
        Get-Content -Path $Path | Select-Object -Last $Lines
    }
}

# grep — colorized search
function grep {
    param(
        [string]$Pattern,
        [string]$Path
    )

    $results = Select-String -Pattern $Pattern -Path $Path

    foreach ($match in $results) {
        $line = $match.Line
        $highlight = $line -replace $Pattern, { Write-Color $args[0] "Yellow" }
        Write-Output "$($match.Filename):$($match.LineNumber): $highlight"
    }
}

# find — recursive file search
function find {
    param(
        [string]$Path = ".",
        [string]$Pattern = "*"
    )
    Get-ChildItem -Path $Path -Recurse -Filter $Pattern
}

# which — find command location
function which {
    param([string]$Name)
    Get-Command $Name | Select-Object -ExpandProperty Source
}

# du — directory size summary
function du {
    param([string]$Path = ".")
    Get-ChildItem -Recurse -File $Path |
        Measure-Object -Property Length -Sum |
        Select-Object @{Name="SizeMB";Expression={[math]::Round($_.Sum / 1MB, 2)}}
}

# ll — colorized long listing
function ll {
    $items = Get-ChildItem
    foreach ($i in $items) {
        if ($i.PSIsContainer) {
            Write-Color ("d {0,-20} {1,10} {2}" -f $i.LastWriteTime, "", $i.Name) Cyan
        } else {
            Write-Color ("- {0,-20} {1,10} {2}" -f $i.LastWriteTime, $i.Length, $i.Name) Green
        }
    }
}

# ls (enhanced) — colorized
function ls {
    $items = Get-ChildItem
    foreach ($i in $items) {
        if ($i.PSIsContainer) {
            Write-Color $i.Name Cyan
        } else {
            Write-Color $i.Name Green
        }
    }
}

# -------------------------------
# Export Functions & Aliases
# -------------------------------
Export-ModuleMember -Function * -Alias *
