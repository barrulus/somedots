;;; init.el --- vanilla Emacs config -*- lexical-binding: t; -*-
;;
;; Layout:
;;   early-init.el         GC, frame defaults, package-user-dir
;;   init.el               this file — bootstrap + module loader
;;   lisp/my-context.el    treemacs persistence + workspace layout
;;   lisp/my-*.el          feature modules

;;; ──────────────────────────────────────────────────────────────
;;; Package bootstrap
;;; ──────────────────────────────────────────────────────────────

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; Refresh archives once if elpa dir is empty (first launch)
(unless (file-directory-p package-user-dir)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t
      use-package-compute-statistics nil)

;;; ──────────────────────────────────────────────────────────────
;;; Sane defaults
;;; ──────────────────────────────────────────────────────────────

;; Set these to your own name and email.
(setq user-full-name "Your Name"
      user-mail-address "you@example.com")

(setq-default indent-tabs-mode nil
              tab-width 2
              standard-indent 2
              fill-column 100
              truncate-lines t)

(setq case-fold-search t
      sentence-end-double-space nil
      require-final-newline t
      create-lockfiles nil
      make-backup-files nil
      auto-save-default nil
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      ;; XDG-clean: keep state out of init dir
      backup-directory-alist `((".*" . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

(when (file-exists-p custom-file) (load custom-file 'noerror 'nomessage))

(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)

(global-auto-revert-mode 1)
(setq auto-revert-verbose nil
      global-auto-revert-non-file-buffers t)

(electric-pair-mode 1)
(show-paren-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(delete-selection-mode 1)
(column-number-mode 1)
(repeat-mode 1)

;; Restore GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)))

;;; ──────────────────────────────────────────────────────────────
;;; Module loader
;;; ──────────────────────────────────────────────────────────────

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'my-context)
(require 'my-ui)
(require 'my-forge-cursor)
(require 'my-completion)
(require 'my-edit)
(require 'my-prog)
(require 'my-org)
(require 'my-markdown)
(require 'my-claude)
(require 'my-misc)

;;; ──────────────────────────────────────────────────────────────
;;; Top-level keybindings (vanilla C-c prefix)
;;; ──────────────────────────────────────────────────────────────
;;
;;  C-c f f   find file in project        (project-find-file)
;;  C-c f g   live grep in project        (consult-ripgrep)
;;  C-c f b   switch buffer               (consult-buffer)
;;  C-c f r   recent files                (consult-recent-file)
;;  C-c e     toggle treemacs             (treemacs)
;;  C-c r n   LSP rename                  (eglot-rename)
;;  C-c c a   LSP code action             (eglot-code-actions)
;;  C-c f m   format buffer               (apheleia-format-buffer)
;;  C-c c x   diagnostics                 (consult-flymake)
;;  C-c g     magit-status
;;  C-c o a   org-agenda
;;  C-c o c   org-capture
;;  C-c o w   workspace layout            (my/workspace)
;;  C-c k     claude-code-ide menu

(keymap-global-set "C-c f f" #'project-find-file)
(keymap-global-set "C-c f r" #'consult-recent-file)
(keymap-global-set "C-c e"   #'treemacs)
(keymap-global-set "C-c r n" #'eglot-rename)
(keymap-global-set "C-c c a" #'eglot-code-actions)
(keymap-global-set "C-c f m" #'apheleia-format-buffer)
(keymap-global-set "C-c g"   #'magit-status)
(keymap-global-set "C-c o a" #'org-agenda)
(keymap-global-set "C-c o c" #'org-capture)
(keymap-global-set "C-c o w" #'my/workspace)

(provide 'init)
;;; init.el ends here
