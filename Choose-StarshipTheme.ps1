#TGT 3/26/2026

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
    & "$PSScriptRoot/Set-StarshipTheme.ps1" $selected
} else {
    Write-Host "Invalid selection." -ForegroundColor Red
}
