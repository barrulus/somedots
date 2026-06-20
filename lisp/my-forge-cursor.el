;;; my-forge-cursor.el --- welding sparks + comet streak + pulsar flash -*- lexical-binding: t; -*-
;;
;; Three independent cursor effects sharing one forge palette:
;;
;;   | Effect         | Source             | Triggers on                        |
;;   |----------------+--------------------+------------------------------------|
;;   | welding sparks | welding-cursor.el  | every self-inserted character      |
;;   | comet streak   | comet-trail (:vc)  | cursor jumps >= 2 cells (movement) |
;;   | pulsar flash   | pulsar (GNU ELPA)  | big commands, scroll, window change|
;;
;; Adapted from ~/Downloads/forge-cursor-setup.org. All three are GUI-best;
;; in `emacs -nw' they degrade to flat cell backgrounds (no sub-cell glow).

;;; --- Forge palette: single source of truth ---------------------------
(defconst my/forge-core  "#fff7e6" "White-hot core.")
(defconst my/forge-amber "#ff9b3d" "Amber mid-glow.")
(defconst my/forge-ember "#c81e0a" "Dark-red cooling tail.")

;;; --- 1. Per-keystroke welding sparks (local package in lisp/) --------
(use-package welding-cursor
  :ensure nil                            ; local file, already on load-path
  :demand t                              ; :bind would defer loading; we want it armed at startup
  :bind ("C-c t w" . welding-cursor-mode)
  :custom
  (welding-cursor-step 0.045)            ; cool-down frame interval (s)
  (welding-cursor-foreground "black")    ; legible glyph over hot cell; nil = glow only
  ;; Recolour the spark ramp from the shared palette.
  (welding-cursor-ramp (vector my/forge-core "#ffd27a" my/forge-amber "#ff5a1f" my/forge-ember))
  :config
  ;; Enable AFTER the package is loaded — `global-welding-cursor-mode' is
  ;; defined by welding-cursor.el, so it must not be called from `:init'.
  (global-welding-cursor-mode 1))

;;; --- 2. Comet streak on cursor jumps ---------------------------------
;; `:vc' is built in on Emacs 30 (this host runs 30.2).
(use-package comet-trail
  :vc (:url "https://git.andros.dev/andros/comet-trail.el" :rev :newest)
  :hook ((prog-mode text-mode) . comet-trail-mode)
  :custom
  (comet-trail-minimum-distance 1)       ; streak on any cursor move, incl. C-n/C-p
  (comet-trail-tick-interval 0.016)      ; ~60fps
  :config
  ;; Match the forge palette (default is #f0c674).
  (set-face-foreground 'comet-trail-highlight my/forge-amber))

;;; --- 3. Pulsar forge-flash on big commands ---------------------------
(use-package pulsar
  :ensure t
  :custom
  (pulsar-pulse t)
  (pulsar-delay 0.055)
  (pulsar-iterations 12)
  (pulsar-face 'pulsar-yellow)
  (pulsar-highlight-face 'pulsar-yellow)
  (pulsar-pulse-on-window-change t)      ; this is a variable, not a function
  :config
  ;; Recolour the built-in pulsar-yellow face to the forge amber.
  (set-face-attribute 'pulsar-yellow nil :background my/forge-amber)
  ;; Extra commands worth a flash, on top of pulsar's defaults.
  (dolist (fn '(recenter-top-bottom
                scroll-up-command scroll-down-command
                other-window delete-window delete-other-windows
                forward-page backward-page
                beginning-of-buffer end-of-buffer))
    (add-to-list 'pulsar-pulse-functions fn))
  (pulsar-global-mode 1))

(provide 'my-forge-cursor)
;;; my-forge-cursor.el ends here
