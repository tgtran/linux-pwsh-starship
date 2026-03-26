## 🐧 LinuxCompat Module

This project includes **LinuxCompat**, a PowerShell module that adds familiar Linux-style commands and utilities to PowerShell on Windows, Linux, and macOS.

### Features
- Linux-style commands:
  - `cp`, `mv`, `rm`, `cat`, `pwd`, `cd`, `touch`, `head`, `tail`, `grep`, `find`, `which`, `du`, `ps`
- Enhanced directory listings:
  - `ll` (colorized long listing)
- Safe aliases that do not override PowerShell core behavior
- Works automatically after installation

### Auto-loading
The installer places LinuxCompat into:


# 🌌 Starship Galactic Themes
### *A multi‑quadrant terminal theme pack for Starship & Oh My Posh*

This repository contains a collection of **Star Trek–inspired terminal themes** designed for the Starship prompt engine (and select themes for Oh My Posh). Each theme captures the visual identity and cultural flavor of a major galactic faction — from the cold precision of the Borg Collective to the honor‑driven aggression of the Klingon Empire.

Whether you're a Starfleet engineer, a Romulan operative, or a drone in Unimatrix Zero, there's a theme here for your console.

---

## ✨ Included Themes

### **Federation / Starfleet**
- **Starfleet Engineering** — LCARS‑inspired, gold/blue, technical  
- **LCARS** — classic TNG‑style interface  

### **Borg Collective**
- **Borg Engineering** — cold, green, mechanical  
- **Unimatrix Zero** — glitchy, rebellious, resistance‑coded  

### **Klingon Empire**
- **Klingon Command** — red/black, aggressive, warrior‑coded  

### **Romulan Star Empire**
- **Romulan Warbird** — sleek, covert, green‑on‑black  

### **Cardassian Union**
- **Cardassian Ops** — industrial, amber/gray, militaristic  

### **Dominion**
- **Dominion Founders** — regal, purple/gold, ominous  

---

## 🛠 Installation

### 1. Install Starship
```powershell
winget install starship
```

### 2. Create your config directory
```powershell
mkdir ~/.config
mkdir ~/.config/starship-themes
```

### 3. Copy the themes
Place all `.toml` files into:

```
~/.config/starship-themes/
```

### 4. Enable Starship in PowerShell
Add this to your PowerShell profile:

```powershell
Invoke-Expression (&starship init powershell)
```

Reload:

```
reload
```

---

## 🎛 Theme Switching (LCARS‑Style Menu)

This repo includes a theme‑switching system so you can change factions instantly.

### Install the scripts

Copy the contents of `scripts/` into your PowerShell profile directory or import them manually.

### Use the selector

```
Choose-StarshipTheme
```

You’ll see a menu like:

```
Available Starship Themes:
[1] borg
[2] unimatrix-zero
[3] klingon-command
[4] romulan-warbird
[5] cardassian-ops
[6] dominion-founders
[7] starfleet-engineering
[8] lcars
Select theme number:
```

Pick a number → instant theme switch → no restart required.

---

## 🧬 Oh My Posh Themes

The `oh-my-posh-themes/` folder contains matching themes for users who prefer OMP.

To activate:

```powershell
oh-my-posh init pwsh --config ~/.config/oh-my-posh-themes/unimatrix-zero.omp.json | Invoke-Expression
```

---

## 📜 License

This project is released under the **MIT License**.

---

## 🖖 Live Long and Customize

This project is built for fans who want their terminal to feel like part of the Star Trek universe.  
Contributions, new factions, and enhancements are welcome.
