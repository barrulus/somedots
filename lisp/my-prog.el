;;; my-prog.el --- LSP, magit, treemacs, project, language modes -*- lexical-binding: t; -*-

;;; ──────────────────────────────────────────────────────────────
;;; Eglot (built-in LSP)
;;; ──────────────────────────────────────────────────────────────

(use-package eglot
  :ensure nil ; built-in
  :hook ((python-mode python-ts-mode) . eglot-ensure)
  :hook ((rust-mode rust-ts-mode) . eglot-ensure)
  :hook ((go-mode go-ts-mode) . eglot-ensure)
  :hook ((js-mode js-ts-mode typescript-mode typescript-ts-mode) . eglot-ensure)
  :hook ((nix-mode nix-ts-mode) . eglot-ensure)
  :hook ((sh-mode bash-ts-mode) . eglot-ensure)
  :hook ((yaml-mode yaml-ts-mode) . eglot-ensure)
  :hook ((html-mode css-mode) . eglot-ensure)
  :hook ((markdown-mode) . eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-extend-to-xref t)
  :config
  ;; nixd
  (add-to-list 'eglot-server-programs '((nix-mode nix-ts-mode) . ("nixd")))
  ;; mpls for markdown
  (add-to-list 'eglot-server-programs '(markdown-mode . ("mpls")))
  ;; pyright + ruff for python (pyright primary)
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pyright-langserver" "--stdio"))))

(use-package consult-eglot
  :after (consult eglot))

;;; ──────────────────────────────────────────────────────────────
;;; Project + flymake
;;; ──────────────────────────────────────────────────────────────

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".projectile" ".project")))

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :custom (flymake-no-changes-timeout 0.5))

(use-package flymake-popon
  :hook (flymake-mode . flymake-popon-mode))

;;; ──────────────────────────────────────────────────────────────
;;; Magit
;;; ──────────────────────────────────────────────────────────────

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-diff-refine-hunk 'all))

;;; ──────────────────────────────────────────────────────────────
;;; Treemacs
;;; ──────────────────────────────────────────────────────────────

(use-package treemacs
  :defer t
  :custom
  (treemacs-width 35)
  (treemacs-position 'left)
  (treemacs-follow-after-init t)
  :config
  (treemacs-follow-mode t))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-nerd-icons
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))

;;; ──────────────────────────────────────────────────────────────
;;; Language modes (treesit-auto handles most; these are extras)
;;; ──────────────────────────────────────────────────────────────

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package yaml-mode
  :mode ("\\.ya?ml\\'"))

(provide 'my-prog)
;;; my-prog.el ends here
