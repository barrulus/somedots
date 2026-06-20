# somedots — Emacs config

A from-scratch **vanilla Emacs** configuration (no Doom, Spacemacs, or other
framework — just `package.el` + `use-package`). Single long-running daemon,
Catppuccin Mocha, JetBrainsMono Nerd Font, org-mode workflow, and a small set
of focused feature modules under `lisp/`.

> Previously this repo held a Doom Emacs + niri config. It's been repurposed
> to the current vanilla setup; the old history was replaced.

## Layout

```
early-init.el        GC tuning, frame defaults, package-user-dir (XDG-clean)
init.el              package bootstrap + sane defaults + module loader
custom.el            Customize-written package list (auto-generated)
lisp/
  my-context.el      treemacs persistence + workspace layout helpers
  my-ui.el           Catppuccin theme, doom-modeline, fonts, diff-hl, which-key
  my-forge-cursor.el welding sparks + comet streak + pulsar flash cursor FX
  welding-cursor.el  per-keystroke "welding flare" spark trail (local package)
  my-completion.el   vertico + orderless + corfu + cape + marginalia + consult
  my-edit.el         editing tweaks
  my-prog.el         eglot, treesit-auto, apheleia, languages
  my-org.el          org core, kanban/sales states, capture, agenda views
  my-markdown.el     markdown + live preview
  my-claude.el       claude-code-ide.el bridge
  my-misc.el         vterm, writeroom, ispell
```

## Requirements

- **Emacs 30+** — `init.el`/modules use `use-package`'s built-in `:vc` to pull
  a couple of packages straight from git (`comet-trail`, `claude-code-ide`).
- A **GUI frame** for the cursor effects (they degrade to flat cell
  backgrounds in `emacs -nw`).
- **JetBrainsMono Nerd Font** installed (falls back gracefully if absent).
- First launch needs network access to populate `elpa/` from GNU/MELPA.

This config was written on **NixOS**, so a few paths are NixOS-specific —
`my-claude.el` and `my-misc.el` reference `/run/current-system/sw/bin`. Adjust
those for other distros.

## Install

```sh
# back up any existing config first
git clone https://github.com/barrulus/somedots ~/.config/emacs
```

(or `~/.emacs.d` if you don't use the XDG location). Then **edit the two
personal bits**:

- `init.el` — set `user-full-name` / `user-mail-address` (placeholders ship).
- `lisp/my-org.el` / `lisp/my-context.el` — the org workflow assumes
  `~/personal/org/` and `~/sales/org/`. Point these at your own org dirs or
  the agenda/capture/workspace helpers will create/visit empty files there.

Launch the daemon:

```sh
emacs --daemon
emacsclient -c
```

## The cursor effects

Three independent effects share one "forge" palette (white-hot → amber →
ember):

| Effect         | Triggers on                        |
|----------------|------------------------------------|
| welding sparks | every self-inserted character      |
| comet streak   | cursor jumps / movement            |
| pulsar flash   | big commands, scroll, window change |

Toggle the welding sparks per-buffer with `C-c t w`. See
`lisp/my-forge-cursor.el` for the palette and per-effect knobs.

## License

MIT — see [LICENSE](LICENSE). The bundled `welding-cursor.el` is original work;
third-party packages keep their own licenses.
