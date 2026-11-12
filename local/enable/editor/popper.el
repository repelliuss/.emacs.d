;;; popper.el -*- lexical-binding: t; -*-

;; Popups: transient buffers (help, output, search results, messages...)
;; that can be toggled, cycled, raised to a regular window or lowered back
;; without disturbing the main layout. Popups are grouped per projectile
;; project, so cycling only walks the current project's popups.
;;
;; Where each kind of popup shows up is all defined here, as ordinary
;; `display-buffer-alist' rules in front of popper's own catch-all rule:
;;   help & docs              right side, selected
;;   search & diagnostics     top side, selected
;;   output & REPLs           bottom side, NOT selected (keep typing)
;;   everything else          bottom, popper's default (*Messages* etc.)
;; Every rule only matches while the buffer is a popup, so a popup raised
;; to a regular window (SPC ` t) is displayed like any other buffer.
;;
;; Keys (normal state; consult's register keys moved to M-` M-~ C-~):
;;   `                toggle the latest popup (C-` does the same in any
;;                    state). C-u: open the next one too, C-u C-u: all.
;;   ~                popup map, `rps-keymap-popup':
;;     ` n p          toggle / cycle forward / cycle backward
;;     t              popup <-> regular window for the current buffer
;;     k              kill the latest popup
;;   After any of these the popup map stays active (`repeat-mode'), so
;;   e.g. ` n n n cycles without repeating the ~ prefix.
;;   M-0..M-9         jump to a popup listed in the echo area
;;   SPC `            hide/show every side window
;;   C-g              closes the latest popup when nothing else needs
;;                    quitting — see `rps-escape-hook'
;;   SPC , ` SPC      `consult-buffer' narrowed to popup buffers
;;                    (p is consult's project narrow)

(defvar rps-keymap-popup (make-sparse-keymap)
  "Popup keys; repeatable after `popper-toggle'.")

(cfg-pkg popper
  (:bind
    (rps-keymap-popup
     (:repeat
       "`" #'popper-toggle
       "n" #'popper-cycle
       "p" #'popper-cycle-backwards
       "t" #'popper-toggle-type
       "k" #'popper-kill-latest-popup))
    ((:global-map)
     "C-`" #'popper-toggle)               ; every state, including insert
    (rps-keymap-normal
     "`" #'popper-toggle
     "~" (cons "popup" rps-keymap-popup)))

  (:opt popper-reference-buffers
        '(;; Emacs internals
          "\\*Messages\\*"
          "\\*Warnings\\*"
          "\\*Backtrace\\*"
          "\\*Compile-Log\\*"
          "\\*Shell Command Output\\*"
          ("\\*Async Shell Command\\*" . hide) ; shown only when asked for
          "Output\\*\\'"
          ;; help & docs
          help-mode
          helpful-mode
          "\\*eldoc.*\\*"
          ;; search & diagnostics
          grep-mode
          occur-mode
          "\\*xref\\*"
          "\\*Flycheck errors\\*"
          "\\*Flymake diagnostics.*\\*"
          ;; output & REPLs
          compilation-mode
          comint-mode
          "\\`\\*vc-git : "           ; not *vc-dir*, which is a real UI
          "\\`magit-process: ")
        popper-group-function #'popper-group-by-projectile
        popper-mode-line '(:eval (propertize " POP " 'face 'mode-line-emphasis)))

  ;; `popper-group-by-projectile' errors until projectile is loaded, and
  ;; popper calls it as soon as the mode is on — projectile.el loads after
  ;; this file, so wait for it.
  (:after projectile
    (popper-mode 1)
    ;; popper-echo.el defvars `popper-tab-line-mode' to a string, so enabling
    ;; echo mode always thinks tab-line mode is on and logs a bogus
    ;; "incompatible" message at startup. It isn't on; say so first.
    (require 'popper-echo)
    (setq popper-tab-line-mode nil)
    (popper-echo-mode 1)

    ;; Placement. Prepended after `popper-mode' added its catch-all rule, so
    ;; these win for the buffers they match. Order matters: `grep-mode'
    ;; derives from `compilation-mode', so search comes before output.
    (:prepend* display-buffer-alist
               '(((and popper-display-control-p
                       (or (derived-mode . help-mode)
                           (derived-mode . helpful-mode)
                           "\\*eldoc"))
                  (display-buffer-reuse-window display-buffer-in-side-window)
                  (side . right) (slot . 0) (window-width . 0.4)
                  (body-function . select-window))

                 ((and popper-display-control-p
                       (or (derived-mode . grep-mode)
                           (derived-mode . occur-mode)
                           "\\*xref\\*"
                           "\\*Flycheck errors\\*"
                           "\\*Flymake diagnostics"))
                  (display-buffer-reuse-window display-buffer-in-side-window)
                  (side . top) (slot . 0) (window-height . 0.3)
                  (body-function . select-window))

                 ((and popper-display-control-p
                       (or (derived-mode . compilation-mode)
                           (derived-mode . comint-mode)
                           "\\*Async Shell Command\\*"
                           "\\*Shell Command Output\\*"
                           "\\`\\*vc-git : "
                           "\\`magit-process: "))
                  (display-buffer-reuse-window display-buffer-in-side-window)
                  (side . bottom) (slot . -1) (window-height . 0.3)))))

  (:hook-to 'rps-escape-hook #'rps-popper-close-on-escape)

  (:after consult
    (:append consult-buffer-sources 'rps-consult-source-popper)))

(defun rps-popper-close-on-escape ()
  "Close the latest popup on C-g. Does nothing (letting C-g do its usual
job) while a region is active or no popup is open."
  (when (and (bound-and-true-p popper-mode)
             popper-open-popup-alist
             (not (region-active-p)))
    (popper-close-latest)
    t))

(defvar rps-consult-source-popper
  (list :name "Popup"
        :narrow ?`                      ; ?p is consult's "Project"
        :hidden t
        :category 'buffer
        :face 'consult-buffer
        :history 'buffer-name-history
        :action #'pop-to-buffer         ; so it opens as a popup, not in place
        :items (lambda ()
                 (mapcar #'buffer-name
                         (seq-filter #'popper-display-control-p (buffer-list)))))
  "`consult-buffer' source listing popup buffers, behind narrow key `.")
