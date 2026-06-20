;;; welding-cursor.el --- Welding-flare spark trail while typing -*- lexical-binding: t; -*-

;; Author: (Barrulus)
;; Version: 0.1
;; Package-Requires: ((emacs "27.1"))
;; Keywords: convenience, faces

;;; Commentary:
;;
;; Leaves a "welding rod flare" behind the cursor as you type.  Each
;; self-inserted character briefly glows white-hot, then cools through
;; amber to dark-red and fades out.  Because every keystroke gets its
;; own fading overlay, fast typing trails a line of cooling sparks
;; behind point -- the molten-metal / welding aesthetic.
;;
;; This drives Emacs overlays + timers; it works in GUI (PGTK/Wayland)
;; frames and, more crudely, in `emacs -nw' (cell backgrounds only, no
;; sub-cell glow).  It is independent of any terminal shader.
;;
;; Usage:
;;   (require 'welding-cursor)
;;   (welding-cursor-mode 1)            ; per-buffer
;;   (global-welding-cursor-mode 1)     ; everywhere
;;
;; For movement/jump streaks (not per-keystroke), pair this with the
;; `comet-trail' package; the two are complementary.

;;; Code:

(defgroup welding-cursor nil
  "Welding-flare spark trail on self-insert."
  :group 'convenience
  :prefix "welding-cursor-")

(defcustom welding-cursor-ramp
  ["#ffffff" "#ffd27a" "#ff9b3d" "#ff5a1f" "#c81e0a"]
  "Colour ramp from white-hot core to dark-red tail.
Each keystroke's spark steps through these in order, one per
`welding-cursor-step' seconds, then disappears."
  :type '(vector string)
  :group 'welding-cursor)

(defcustom welding-cursor-step 0.065
  "Seconds between frames of a single spark's cool-down."
  :type 'number
  :group 'welding-cursor)

(defcustom welding-cursor-foreground "black"
  "Glyph colour while a cell is glowing.
The ramp colours are light, so a dark foreground stays legible.
Set to nil to leave the glyph colour untouched (glow via background
only -- looks more like a hot cell)."
  :type '(choice (const :tag "Untouched" nil) color)
  :group 'welding-cursor)

(defun welding-cursor--spark (pos)
  "Animate a cooling spark over the character ending at POS."
  (when (and (integerp pos) (> pos (point-min)))
    (let* ((ov   (make-overlay (1- pos) pos nil t nil))
           (n    (length welding-cursor-ramp))
           (i    0)
           (timer nil))
      (overlay-put ov 'priority 100)
      (setq timer
            (run-at-time
             0 welding-cursor-step
             (lambda ()
               (cond
                ((or (>= i n) (not (overlay-buffer ov)))
                 (when (overlay-buffer ov) (delete-overlay ov))
                 (when (timerp timer) (cancel-timer timer)))
                (t
                 (overlay-put
                  ov 'face
                  (append
                   (when welding-cursor-foreground
                     (list :foreground welding-cursor-foreground))
                   (list :background (aref welding-cursor-ramp i)
                         :weight 'bold)))
                 (setq i (1+ i))))))))))

(defun welding-cursor--on-insert ()
  "Hook function: spark the just-inserted character."
  (welding-cursor--spark (point)))

;;;###autoload
(define-minor-mode welding-cursor-mode
  "Leave a welding-flare spark trail as you type in this buffer."
  :lighter " 🔥"
  (if welding-cursor-mode
      (add-hook 'post-self-insert-hook #'welding-cursor--on-insert nil t)
    (remove-hook 'post-self-insert-hook #'welding-cursor--on-insert t)))

;;;###autoload
(define-globalized-minor-mode global-welding-cursor-mode
  welding-cursor-mode
  (lambda () (unless (minibufferp) (welding-cursor-mode 1))))

(provide 'welding-cursor)
;;; welding-cursor.el ends here
