;;; my-context.el --- treemacs persistence and workspace layout -*- lexical-binding: t; -*-

;; Treemacs persist file — single file for all projects.
(setq treemacs-persist-file
      (expand-file-name "treemacs-persist" user-emacs-directory))

;; Seed treemacs persist if missing, to prevent interactive prompts in daemon.
(let ((persist treemacs-persist-file))
  (when (or (not (file-exists-p persist))
            (zerop (or (file-attribute-size (file-attributes persist)) 0)))
    (make-directory (file-name-directory persist) t)
    (with-temp-file persist
      (insert "* Default\n** personal\n - path :: ~/personal/org\n"))))

(setq frame-title-format '("Emacs — %b"))

;;; ──────────────────────────────────────────────────────────────
;;; Workspace layout (called from desktop entry on launch)
;;; ──────────────────────────────────────────────────────────────

(defun my/--workspace-build ()
  "Build the standard layout: treemacs | (dashboard / agenda)."
  (let ((ignore-window-parameters t))
    (let ((main (window-with-parameter 'window-side nil)))
      (when main (select-window main)))
    (delete-other-windows))
  ;; 1. Main window: personal inbox as dashboard.
  (find-file "~/personal/org/inbox.org")
  ;; 2. Agenda below.
  (let ((agenda-win (split-window-below)))
    (with-selected-window agenda-win
      (org-agenda-list nil nil 10)))
  ;; 3. Treemacs sidebar.
  (when (fboundp 'treemacs) (treemacs)))

(defun my/workspace (&optional frame)
  "Open workspace layout: treemacs | (inbox / agenda).
When called from `emacsclient -c --eval', defer until a visible
frame exists."
  (interactive)
  (let ((target (or frame (car (filtered-frame-list #'frame-visible-p)))))
    (if target
        (with-selected-frame target
          (my/--workspace-build))
      (let (hook)
        (setq hook (lambda (f)
                     (remove-hook 'after-make-frame-functions hook)
                     (with-selected-frame f
                       (my/--workspace-build))))
        (add-hook 'after-make-frame-functions hook)))))

(provide 'my-context)
;;; my-context.el ends here
