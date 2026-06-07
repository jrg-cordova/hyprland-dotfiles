# 🌃 Hyprland Dotfiles

My personal [Hyprland](https://hyprland.org/) setup on **Arch Linux** (NVIDIA / Wayland),
built around a content-creation workflow: quick screenshots, a floating streamer webcam,
and one-key screen recording with mic + system audio.

![Wayland](https://img.shields.io/badge/Wayland-Hyprland-blue)
![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?logo=arch-linux&logoColor=white)

## ✨ Features

| Keybind | Action |
|---|---|
| `Super` + `Return` | Terminal (kitty) |
| `Super` + `D` | App launcher (rofi) |
| `Super` + `Shift` + `S` | **Screenshot (area)** → clipboard → click toast to edit in swappy |
| `Print` | Screenshot (full screen) |
| `Super` + `Print` | Screenshot (active window) |
| `Super` + `Shift` + `C` | **Toggle floating webcam** (streamer cam) |
| `Super` + `Shift` + `R` | **Toggle screen recording** (video + mic + system audio) |

- **Snip & Sketch–style screenshots** — select an area, it's copied to the clipboard
  instantly, and a notification lets you click to open [swappy](https://github.com/jtheoof/swappy)
  for annotation. Ignore it and the temp file is cleaned up.
- **Floating webcam** — an `mpv` preview pinned to the bottom-right corner, visible on all
  workspaces, like a streamer cam.
- **Screen recording for YouTube** — [wf-recorder](https://github.com/ammen99/wf-recorder)
  captures the screen while a temporary PipeWire null-sink mixes your **microphone + desktop
  audio** into the recording. A blinking red `● REC` appears in Waybar; click it to stop.

## 📦 Dependencies

```bash
sudo pacman -S --needed \
  hyprland waybar swaync rofi kitty \
  grim slurp wl-clipboard swappy \
  wf-recorder mpv libnotify \
  pipewire pipewire-pulse
```

> Wallpapers use an `awww`/`swww` daemon (see `hyprland.conf`). Notifications use **swaync**
> with its default config. Audio control uses **PipeWire** (`pactl`).

## 🚀 Install (GNU stow)

This repo is organized as [GNU stow](https://www.gnu.org/software/stow/) packages — each
top-level folder mirrors `$HOME`, so stow can symlink everything into place.

```bash
sudo pacman -S --needed stow
git clone https://github.com/jrg-cordova/hyprland-dotfiles.git ~/hyprland-dotfiles
cd ~/hyprland-dotfiles
```

> ⚠️ **If you already have these configs**, stow will refuse to overwrite real files.
> Back them up first:
> ```bash
> for d in hypr waybar swappy; do
>   [ -e ~/.config/$d ] && mv ~/.config/$d ~/.config/$d.bak
> done
> ```

```bash
./install.sh                 # symlink all packages into $HOME
./install.sh hypr waybar     # only selected packages
./install.sh -D              # remove the symlinks

# Reload
hyprctl reload && pkill -SIGUSR2 waybar
```

Because everything is symlinked, editing a file in `~/.config/hypr/` edits it right here in
the repo — `git commit` and you're done.

## 📂 Structure

```
hyprland-dotfiles/
├── install.sh              # stow wrapper
├── hypr/.config/hypr/      # hyprland.conf + scripts/ (screenshot, webcam, recording)
├── waybar/.config/waybar/  # bar config, style, recording indicator
├── swappy/.config/swappy/  # screenshot editor config
└── bin/.local/bin/         # full-screen screenshot helpers
```

## 🛠️ Notes / Gotchas

- swaync fires a notification **body click** only when the action key is literally `default`
  (`notify-send -A "default=Label"`); a named key just renders a button.
- `mktemp` rejects `--suffix=.png` on a template ending in `.png` — use `mktemp /tmp/x_XXXXXX.png`.
- Recording sink/source are resolved at start time, so whatever audio devices are **default**
  when you press record are what gets captured.

## 📄 License

[MIT](LICENSE)
