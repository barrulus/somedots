;;; my-edit.el --- formatter, treesit, snippets, direnv -*- lexical-binding: t; -*-

;; conform.nvim equivalent — async, doesn't move point
(use-package apheleia
  :init (apheleia-global-mode +1)
  :config
  ;; Disable for sql-mode (matched +format-on-save-disabled-modes from Doom)
  (setq apheleia-inhibit-functions
        (list (lambda () (derived-mode-p 'sql-mode))))
  ;; nixfmt for nix-mode
  (setf (alist-get 'nixfmt apheleia-formatters)
        '("nixfmt"))
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'nixfmt)
  (setf (alist-get 'nix-ts-mode apheleia-mode-alist) 'nixfmt))

;; Auto-install and use tree-sitter grammars
(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package yasnippet
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; direnv integration (envrc — per-buffer, race-free)
(use-package envrc
  :init (envrc-global-mode))

(provide 'my-edit)
;;; my-edit.el ends here
