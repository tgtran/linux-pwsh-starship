# 🐧 LinuxCompat Module  
*A PowerShell module that brings familiar Linux‑style commands to Windows.*

This project includes **LinuxCompat**, a custom PowerShell module that adds Linux‑style commands and utilities to PowerShell on Windows. It provides commands such as:

- `cp`, `mv`, `rm`, `cat`, `pwd`, `cd`, `touch`, `head`, `tail`, `grep`, `find`, `which`, `du`, `ps`
- `ll` — colorized long listing  
- Safe aliases that do **not** override PowerShell core behavior  
- Automatic loading after installation

---

# 🛠 Installing LinuxCompat (Windows Only)

LinuxCompat is not published to the PowerShell Gallery. Installation is manual.

## 1. Download or Clone the Repository

```powershell
git clone https://github.com/tgtran/linux-pwsh-starship.git
```

Or download the ZIP and extract it.

---

## 2. Create the Module Directory

PowerShell user modules live here:

```
$HOME\Documents\PowerShell\Modules\LinuxCompat
```

Create the folder:

```powershell
New-Item -ItemType Directory -Force `
    "$HOME\Documents\PowerShell\Modules\LinuxCompat"
```

---

## 3. Copy the Module Files

From the repo root:

```powershell
Copy-Item -Recurse -Force .\LinuxCompat\ `
    "$HOME\Documents\PowerShell\Modules\LinuxCompat"
```

---

## 4. Load LinuxCompat Automatically

Add this line to your PowerShell profile:

```powershell
Import-Module LinuxCompat
```

** You may need to set-executionpolicy to remotesigned and/or issue unblock LinuxCompat.psm1 command

If your profile doesn’t exist:

```powershell
if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}
notepad $PROFILE
```
---

## 5. Install Starship 
use "winget install starship"
or go to the source
https://starship.rs/installing/


# 🌌 Starship Galactic Themes  
*A multi‑quadrant terminal theme pack for Starship & Oh My Posh*

This repository also includes a collection of **Star Trek–inspired terminal themes** for the Starship prompt engine. Each theme captures the visual identity of a major galactic faction — from the cold precision of the Borg Collective to the honor‑driven aggression of the Klingon Empire.

---

## ✨ Included Themes

### **Federation / Starfleet**
- Starfleet Engineering — LCARS‑inspired, gold/blue  
- LCARS — classic TNG‑style interface  

### **Borg Collective**
- Borg Engineering — cold, green, mechanical  
- Unimatrix Zero — glitchy, rebellious  

### **Klingon Empire**
- Klingon Command — red/black, aggressive  

### **Romulan Star Empire**
- Romulan Warbird — sleek, covert, green‑on‑black  

### **Cardassian Union**
- Cardassian Ops — industrial, amber/gray  

### **Dominion**
- Dominion Founders — regal, purple/gold  

---

# 🛠 Installing Starship Themes (Windows Only)

## 1. Install Starship

```powershell
winget install starship
```

---

## 2. Create the Config Directories

```powershell
New-Item -ItemType Directory -Force "$HOME\.config"
New-Item -ItemType Directory -Force "$HOME\.config\starship-themes"
```

---

## 3. Copy All Theme Files

Move all `*.toml` files from this repo into:

```
$HOME\.config\starship-themes
```

Example:

```powershell
Copy-Item .\starship-themes\*.toml "$HOME\.config\starship-themes" -Force
```

---

# 🎛 Add Theme Switching to Your PowerShell Profile

Append the following to **$PROFILE** to enable instant theme switching:

```powershell
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
```

---

# 🧪 Using the Theme Selector

```powershell
Choose-StarshipTheme
```

Pick a number → instant theme switch → no restart required.

---

# 🧬 Oh My Posh Themes

Matching OMP themes are included in the `oh-my-posh-themes/` folder.

To activate:

```powershell
oh-my-posh init pwsh --config "$HOME\.config\oh-my-posh-themes\unimatrix-zero.omp.json" | Invoke-Expression
```

---

# 📜 License

Released under the **MIT License**.

---

# 🖖 Live Long and Customize

This project is built for fans who want their terminal to feel like part of the Star Trek universe.  
Contributions, new factions, and enhancements are welcome.
```

---

If you want, I can also generate:

- A **badge header**  
- A **table of contents**  
- A **preview screenshot grid**  
- A **release description**  

Just tell me the direction you want to take it.