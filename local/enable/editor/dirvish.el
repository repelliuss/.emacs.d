;;; dirvish.el -*- lexical-binding: t; -*-

;; HACK: Dirvish binds each Dired buffer to the tab/frame it was created in.
;; `dirvish-winbuf-change-h' treats a Dired buffer showing up in another tab as
;; a freshly cloned tab and kills it (plus its session roots). `consult-buffer'
;; previews candidates in the current window, so previewing a Dired buffer from
;; another tab killed it, leaving a dead buffer in the candidate list
;; ("Selecting deleted buffer" from nerd-icons-completion). Skip the handler
;; while a minibuffer is active. Side effect: Dirvish layout updates triggered
;; by window-buffer changes are also skipped during minibuffer input.
(define-advice dirvish-winbuf-change-h (:around (orig window) rps-skip-in-minibuffer)
  (unless (active-minibuffer-window)
    (funcall orig window)))

(cfg-pkg dirvish
  (dirvish-override-dired-mode 1)
  (:bind "?" #'dirvish-dispatch)
  (:prepend* dirvish-attributes '(file-time collapse subtree-state))

  (:after nerd-icons
    (:opt dirvish-subtree-state-style 'nerd)
    (:prepend dirvish-attributes 'nerd-icons)
    (:opt dirvish-path-separators (list
                                   (format "  %s " (nerd-icons-codicon "nf-cod-home"))
                                   (format "  %s " (nerd-icons-codicon "nf-cod-root_folder"))
                                   (format " %s " (nerd-icons-faicon "nf-fa-angle_right"))))))

