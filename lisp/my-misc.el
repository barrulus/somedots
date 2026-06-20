;;; my-misc.el --- vterm, writeroom, ispell -*- lexical-binding: t; -*-

(use-package vterm
  :commands vterm
  :custom (vterm-shell "/run/current-system/sw/bin/bash")
  :config
  (define-key vterm-mode-map (kbd "<escape>") #'vterm-send-escape)
  (define-key vterm-mode-map (kbd "S-<return>")
    (lambda () (interactive) (vterm-send-string "\n"))))

(use-package writeroom-mode
  :commands writeroom-mode
  :custom
  (writeroom-width 80)
  (writeroom-extra-line-spacing 4))

(use-package ispell
  :ensure nil
  :custom (ispell-dictionary "en_GB"))

(provide 'my-misc)
;;; my-misc.el ends here
