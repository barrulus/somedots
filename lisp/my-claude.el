;;; my-claude.el --- claude-code-ide.el integration -*- lexical-binding: t; -*-
;;
;; https://github.com/manzaltu/claude-code-ide.el
;; Provides Emacs ↔ Claude Code IDE bridge with MCP tool support.
;; Requires the `claude` CLI on PATH (provided by the claude-code flake input).

(add-to-list 'exec-path "/run/current-system/sw/bin")

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind (("C-c k k" . claude-code-ide-menu)
         ("C-c k s" . claude-code-ide)
         ("C-c k r" . claude-code-ide-resume)
         ("C-c k q" . claude-code-ide-stop)
         ("C-c k t" . claude-code-ide-toggle))
  :custom
  (claude-code-ide-terminal-backend 'vterm)
  (claude-code-ide-use-side-window t)
  :config
  ;; Enable MCP tool support — exposes Emacs commands as MCP tools
  ;; that the claude CLI can call. Configure individual tools as needed.
  (when (fboundp 'claude-code-ide-emacs-tools-setup)
    (claude-code-ide-emacs-tools-setup)))

(provide 'my-claude)
;;; my-claude.el ends here
