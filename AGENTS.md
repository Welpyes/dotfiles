# AGENTS.md

Personal dotfiles for an Arch/Debian-style Linux desktop (bspwm/Hyprland/qtile, st, nvim, zsh).

## Layout

The repo root is `~/dotfiles`. The **stow package is the nested `dotfiles/` directory**, not the repo root.

- `dotfiles/` — the only stow package. Everything here becomes a symlink in `$HOME`.
- `nvim/`, `st-terminal/` — git submodules, NOT stow-managed.
- `keyd/`, `xorg.conf.d/` — not stow-managed; copied to `/etc` by hand.

## Install / uninstall

Run both scripts **from the repo root**. `stow.sh` does `cd $(pwd)/dotfiles`, so invoking it from anywhere else (e.g. `bash ~/dotfiles/stow.sh` while in `$HOME`) targets the wrong path.

```sh
cd ~/dotfiles && ./stow.sh      # stow -t $HOME --dotfiles . --adopt + link ~/.config/nvim
cd ~/dotfiles && ./unstow.sh    # stow --dotfiles -D -t $HOME dotfiles
```

- `--adopt` moves pre-existing target files into the package. Don't run `stow.sh` casually.
- `stow.sh`'s `ln -s ~/dotfiles/nvim ~/.config/nvim` is unconditional — it fails if that path already exists, and `unstow.sh` never removes it. `~/.config/nvim` is a plain absolute symlink, not a stow link.
- Mapping is `dotfiles/dot-<name>` → `~/<name>` and `dotfiles/dot-config/<app>` → `~/.config/<app>`.
- `--adopt` folds `~/.icons` into a real directory holding one symlink per child, so `~/.icons` itself is *not* a symlink. Don't assume every target is a link.

### Manual copies (must be re-copied after editing)

Repo and `/etc` copies are byte-identical today; editing the repo alone changes nothing at runtime.

- `keyd/default.conf` → `/etc/keyd/default.conf`
- `xorg.conf.d/*.conf` → `/etc/X11/xorg.conf.d/`

## Shell wiring (zsh)

`~/.zshenv` sets `ZDOTDIR="$HOME/.config/zsh"`, so **`dot-config/zsh/.zshrc` is the real zshrc**.

`.zshrc` sources a hardcoded heredoc list, in order: `theme env aliases keybinds options plugins utils prompt gowall`. Adding a new `foo.zsh` does nothing until you add it to that list in `.zshrc`.

`plugins.zsh` git-clones zinit from GitHub on first shell start if `~/.local/share/zinit/zinit.git` is missing. `prompt.zsh` hardcodes `$HOME/.config/oh-my-posh/zen.toml`.

## Submodules

Both are checked out **detached HEAD** (`## HEAD (no branch)`). Commit inside the submodule first, then bump the pointer in the parent repo — editing submodule files alone changes nothing in the parent.

- `nvim/` → `Welpyes/neovim-config`. HEAD is detached at `952e25d`, which is 1 commit **behind** `dev`'s tip (`5ca4532`) — check `git log HEAD..dev` before assuming you're on the branch. Entry `init.lua` → `lua/config/lazy.lua` bootstraps lazy.nvim. `lazy-lock.json` is gitignored.
- `st-terminal/` → `Welpyes/st`, a patched st fork. **The patches in `patches/*.diff` are already applied and committed** (`graphics.c`, `boxdraw.c`, `hb.c`, `rowcolumn_diacritics_helpers.c` are real sources in the `Makefile`'s `SRC`). Don't re-run `patch`; edit the C directly or regenerate the diff.

### Recursive symlink hazard

`nvim/nvim` is a **committed self-referential symlink** to `/home/welpyes/dotfiles/nvim` (machine-absolute, added in the nvim repo's `952e25d`). It has no functional purpose. Beware of `find`/`rg --follow`/glob tools recursing through it, and don't copy that path to another machine.

## Building st

```sh
cd st-terminal && make        # config.h is gitignored; auto-copied from config.def.h
sudo make install             # -> /usr/local/bin (st, st-icat)
```

`config.mk` auto-detects Android/Termux and switches `PREFIX` and adds libshmemu; on Linux it uses `/usr/local`.

st reads **all** colors, fonts, and behavior from `~/.Xresources` (`dot-Xresources`). After editing: `xrdb -merge ~/.Xresources`, then `kill -USR1 $(pgrep -x st)` to reload without restarting. `bspwmrc` already calls `xrdb -merge ~/.Xresources` at startup.

## Colors live in two places

There is no theme pipeline. To change the palette you must edit **both**:

- `dot-Xresources` — st, GTK, and the `colors.*` keys bspwm reads via `xrdb-wrap`.
- `dot-config/rofi/theme-generated.rasi` — imported by `dmenu.rasi`; separate copy of the same palette.

## Git noise you did not cause

These are tracked runtime state, rewritten by daemons at runtime. Expect them dirty in `git status`; don't commit them blindly.

- `dotfiles/dot-mpd/{database,log,state,sticker.sql}` — written by mpd (`log` alone is ~800K).
- `dotfiles/dot-config/pulse/cookie` — machine-local PulseAudio auth cookie.
- `dotfiles/dot-config/oh-my-posh/zen.toml.bak` — stale backup.

`.gitignore` only covers `.zcompdump`, `venv/`, `__pycache__/`.

## Commit conventions

`dot-config/git/config` is live and opinionated:

- `commit.template = ~/.config/git/template` — conventional-commit messages with fixed emoji per type: `feat: ✨`, `fix: 🐛`, `chore: 🧹`, `docs: 📜`, `refactor: 🔨`, `style: 💅`, `test: 🚦`, `perf: 🚀`, `BREAKING CHANGE: 🚨`. Match this.
- `commit.gpgSign = true` with `gpg.format = ssh` — commits will fail without the signing key.
- `pull.rebase = true`, `push.default = current`, `init.defaultBranch = dev`.
- Local branches (`chadrice2`, `chadriceidk`) don't follow that convention; don't infer branch naming rules from them.

## Known pre-existing breakage

- `dot-config/bspwm/bspwmrc`: `__main__` calls `rules`, which is **never defined** in the file. Every start prints `rules: command not found`. There's no `set -e`, so the WM still loads.
- `dot-config/rofi/rofi/config.rasi` and `rofi/rofi/scripts/power.sh` reference `~/.config/rofi/themes/*.rasi`, but those themes live one level deeper at `~/.config/rofi/rofi/themes/`. Dead paths from an unfinished directory restructure — rofi has two parallel layouts under `dot-config/rofi/`.

## Hardcoded Termux leftovers

These Android paths survive in a Linux desktop config and will break if executed:

- `dot-config/fastfetch/synch` — shebang `#!/data/data/com.termux/files/usr/bin/bash`.
- `dot-config/zsh/.zshrc` — `TARGET_DIR="/data/data/com.termux/files/home"`.
- `dot-zshenv` — commented-out Termux `HOME`.
- `dot-config/zsh/aliases.zsh` — `forcevulkan` points at an `aarch64` ICD path.