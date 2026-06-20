;;; my-markdown.el --- markdown, pandoc, mermaid, live preview -*- lexical-binding: t; -*-

(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :hook (markdown-mode . visual-line-mode)
  :custom
  (markdown-command "pandoc -f gfm -t html5 --mathjax --highlight-style=pygments")
  :config
  (custom-set-faces
   '(markdown-header-face-1 ((t (:height 1.4 :weight bold))))
   '(markdown-header-face-2 ((t (:height 1.2 :weight bold))))
   '(markdown-header-face-3 ((t (:height 1.1 :weight bold))))))

(use-package markdown-toc
  :after markdown-mode)

(use-package edit-indirect)

;;; ──────────────────────────────────────────────────────────────
;;; Mermaid
;;; ──────────────────────────────────────────────────────────────

(use-package mermaid-mode
  :mode "\\.mmd\\'"
  :custom
  (mermaid-mmdc-location "mmdc")
  (mermaid-output-format ".svg"))

(use-package ob-mermaid
  :after org
  :custom (ob-mermaid-cli-path "mmdc"))

;; markdown-mermaid (third-party, install via :vc)
(unless (file-directory-p (expand-file-name "markdown-mermaid" package-user-dir))
  (package-vc-install
   '(markdown-mermaid :url "https://github.com/pasunboneleve/markdown-mermaid")))
(use-package markdown-mermaid
  :ensure nil
  :after markdown-mode
  :bind (:map markdown-mode-map
         ("C-c m" . markdown-mermaid-preview)))

;;; ──────────────────────────────────────────────────────────────
;;; Live browser preview (impatient-mode + pandoc filter)
;;; ──────────────────────────────────────────────────────────────

(use-package impatient-mode
  :defer t
  :config
  (defun my/markdown-filter (buffer)
    "Render markdown BUFFER to HTML via pandoc for impatient-mode."
    (princ
     (with-current-buffer buffer
       (shell-command-to-string
        (format "echo %s | pandoc -f gfm -t html5 --standalone --mathjax --highlight-style=pygments"
                (shell-quote-argument (buffer-string)))))
     (current-buffer)))

  (defun my/markdown-live-preview ()
    "Start live-updating markdown preview in browser."
    (interactive)
    (httpd-start)
    (impatient-mode 1)
    (imp-set-user-filter #'my/markdown-filter)
    (browse-url (format "http://localhost:8080/imp/live/%s/" (buffer-name)))
    (message "Live preview started at localhost:8080")))

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "C-c P") #'my/markdown-live-preview))

(provide 'my-markdown)
;;; my-markdown.el ends here
