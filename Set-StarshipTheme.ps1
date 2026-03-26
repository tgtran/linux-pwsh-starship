#TGT 3/26/2026
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
