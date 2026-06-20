;;; my-ui.el --- theme, modeline, fonts, transparency -*- lexical-binding: t; -*-

(use-package nerd-icons)

(use-package catppuccin-theme
  :init
  (setq catppuccin-flavor 'mocha)
  :config
  (load-theme 'catppuccin :no-confirm))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 3)
  (doom-modeline-icon t)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project))

;; Fonts (JetBrainsMono Nerd Font, size 14, matching nvim/Doom)
(let ((font "JetBrainsMono Nerd Font-14"))
  (when (member "JetBrainsMono Nerd Font" (font-family-list))
    (add-to-list 'default-frame-alist `(font . ,font))
    (set-face-attribute 'default nil :font font)
    (set-face-attribute 'fixed-pitch nil :font font)
    (set-face-attribute 'variable-pitch nil :font font)))

(use-package which-key
  :init (which-key-mode 1)
  :custom (which-key-idle-delay 0.5))

;; vc-gutter equivalent — git diff in the fringe
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

(use-package rainbow-mode
  :hook ((prog-mode . rainbow-mode)
         (css-mode . rainbow-mode)))

(provide 'my-ui)
;;; my-ui.el ends here
