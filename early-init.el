;;; early-init.el --- pre-init setup -*- lexical-binding: t; -*-

;; GC tuning during startup; restored in init.el
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Don't rescan load-path for compiled files at startup
(setq load-prefer-newer noninteractive)

;; Frame defaults — set early so they apply to the first frame
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(alpha-background . 65) default-frame-alist)
(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function 'ignore)

;; Keep installed packages out of the git-tracked init dir
(setq package-user-dir
      (expand-file-name "emacs/elpa" (or (getenv "XDG_DATA_HOME") "~/.local/share")))

;; Quiet native-comp warnings
(setq native-comp-async-report-warnings-errors 'silent
      native-compile-prune-cache t)

;; Disable package.el's automatic activation — we do it explicitly in init.el
(setq package-enable-at-startup nil)

(provide 'early-init)
;;; early-init.el ends here
