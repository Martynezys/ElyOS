# ✨ ElyOS Installer

> A minimal, automated installer for **Arch Linux + Wayfire** — clean, fast, and configurable.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Shell Script](https://img.shields.io/badge/Bash-Script-4a4a4a?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Version](https://img.shields.io/badge/Version-0.0.5-blue)](https://github.com/Martynezys/wayfire-elyos-installer/releases)

---

## 🚀 Quick Start

```bash
# Clone the repo
git clone [https://github.com/Martynezys/wayfire-elyos-installer.git](https://github.com/Martynezys/wayfire-elyos-installer.git)
cd wayfire-elyos-installer

# Fix line endings (if cloned on Windows) and make executable
sed -i 's/\r$//' install.sh
chmod +x install.sh

# Run the installer (on a fresh minimal Arch install!)
./install.sh
```

> ⚠️ **WARNING**: This script modifies your system. Only run on a **fresh minimal Arch Linux installation**. Backup important data first.

---

## 📦 What Gets Installed

| Component | Package/Link | Purpose |
|-----------|-------------|---------|
| 🎨 Compositor | [Wayfire](https://wayfire.org) + `wcm` | Modern Wayland desktop & GUI config manager |
| 🔧 AUR Helper | [Paru](https://github.com/Morganamilo/paru) | Install AUR packages easily |
| 💡 Display Manager | [SDDM](https://wiki.archlinux.org/title/SDDM) | Modern Wayland-compatible login screen |
| ⌨️ Terminal | [Kitty](https://github.com/kovidgoyal/kitty) | GPU-accelerated terminal |
| 📁 File Manager | [Thunar](https://docs.xfce.org/xfce/thunar/start) | Lightweight XFCE file manager |
| 🔍 App Launcher | [Wofi](https://github.com/SimplyCEO/wofi) | Fast, keyboard-driven launcher |
| 📊 Status Bar | [Waybar](https://github.com/Alexays/Waybar) | Customizable Wayland status bar |
| 🔊 Audio | [PipeWire](https://pipewire.org/) | Modern, low-latency audio & screen-sharing stack |
| 🌐 Browser | Firefox | Pre-installed for convenience |
| 🧰 Utilities | `fastfetch`, `wl-clipboard`, `brightnessctl`, `nm-applet`, Font Awesome & Emojis | Quality-of-life extras & theming |

### 🔧 Config Files Deployed
- `~/.config/wayfire/wayfire.ini` — Core Wayfire config *(required)*
- `~/.config/waybar/` — Waybar layout & CSS theme *(optional)*
- `~/.config/wofi/` — Wofi theme & settings *(optional)*
- `~/.config/kitty/` — Kitty terminal config *(optional)*
- `~/.local/bin/*.sh` — Utility scripts *(optional)*

---

## 🖼️ Screenshots

> *Coming soon!* Once the rice is seasoned 🍚✨  
> *(Placeholder: Wayfire desktop with waybar, wofi, and kitty)*

---

## ⚙️ Requirements

- ✅ Fresh **minimal Arch Linux** installation (no DE/WM pre-installed)
- ✅ Active **internet connection**
- ✅ `sudo` privileges
- ✅ ~2-3 GB free disk space recommended

---

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| `Permission denied` running script | Run `chmod +x install.sh` |
| Script fails on Windows clone | Run `sed -i 's/\r$//' install.sh` to fix CRLF |
| `wayfire.ini not found` error | Ensure `wayfire.ini` is in the same folder as the script |
| No internet during install | Script will exit early — reconnect and retry |
| SDDM doesn't show Wayfire session | Reboot after install; select "Wayfire" at login |

💡 **Pro Tip**: Test the script in a VM first (QEMU/VirtualBox) before running on bare metal!

---

## 🤝 Contributing

Found a bug? Want a feature?  
👉 [Open an Issue](https://github.com/Martynezys/wayfire-elyos-installer/issues) or submit a PR!

Guidelines:
- Keep changes modular and well-commented
- Test on a fresh Arch install before submitting
- Update the README if adding new dependencies

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgements

- [Wayfire](https://wayfire.org) — Amazing Wayland compositor
- [Arch Linux](https://archlinux.org) — The best base, period
- The AUR maintainers — You're legends
- You — for trying this out! 🫶

---

> 💬 *"Simplicity is the ultimate sophistication."* > — Inspired by Arch, built with ❤️ for Wayfire enthusiasts

<div align="center">
  <sub>Built by <a href="https://github.com/Martynezys">@Martynezys</a> • <a href="#-elyos-installer">↑ Back to top ↑</a></sub>
</div>
