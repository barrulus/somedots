;;; my-org.el --- org-mode core, kanban states, capture, agenda -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :hook (org-mode . visual-line-mode)
  :custom
  (org-deadline-warning-days 7)
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-edit-src-content-indentation 0)
  (org-log-done 'time)
  ;; Kanban / sales pipeline states
  (org-todo-keywords
   '((sequence "TODO(t)" "IN-PROGRESS(i)" "BLOCKED(b)" "|" "DONE(d)" "CANCELLED(c)")
     (sequence "PROSPECT(p)" "QUALIFIED(q)" "PROPOSAL(P)" "NEGOTIATION(n)" "|" "WON(w)" "LOST(l)")))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  :config
  ;; Unified org — both personal and work directories
  (setq org-directory "~/personal/org/"
        org-agenda-files '("~/personal/org/" "~/sales/org/")
        org-default-notes-file "~/personal/org/inbox.org")
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

  ;; All capture templates available at all times
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/personal/org/inbox.org" "Inbox")
           "* TODO %?\n%U\n%a" :prepend t)
          ("n" "Note" entry (file+headline "~/personal/org/notes.org" "Notes")
           "* %?\n%U" :prepend t)
          ("j" "Journal" entry (file+olp+datetree "~/personal/org/journal.org")
           "* %?\n%U" :prepend t)
          ("e" "Expense" table-line
           (file+headline "~/personal/org/expenses.org" "Expenses")
           "| %^{Date} | 1 | %^{Description} | %^{Amount (EUR)} | %^{Amount (EUR)} |"
           :immediate-finish t)
          ("m" "Meeting" entry (file+headline "~/sales/org/meetings.org" "Meetings")
           "* %? :meeting:\n%U\n** Attendees\n** Agenda\n** Notes\n** Actions" :prepend t)
          ("c" "Client Note" entry (file+headline "~/sales/org/clients.org" "Notes")
           "* %? :client:\n%U" :prepend t)))

  ;; Custom agenda views for filtering
  (setq org-agenda-custom-commands
        '(("p" "Personal" agenda ""
           ((org-agenda-files '("~/personal/org/"))))
          ("w" "Work" agenda ""
           ((org-agenda-files '("~/sales/org/"))))
          ("a" "All" agenda ""
           ((org-agenda-files '("~/personal/org/" "~/sales/org/"))))))

  ;; Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((mermaid     . t)
     (emacs-lisp . t)
     (shell      . t)
     (python     . t))))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :hook (org-agenda-finalize . org-modern-agenda))

(use-package org-kanban
  :after org)

(provide 'my-org)
;;; my-org.el ends here
