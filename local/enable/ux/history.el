;;; history.el -*- lexical-binding: t; -*-

(cfg emacs
  (:opt save-place-file (:join rps-dir-cache "save-place")
        recentf-save-file (:join rps-dir-cache "recentf")
        recentf-max-menu-items 100
        savehist-file (:join rps-dir-cache "savehist"))

  ;; Track buffer switches
  (:after recentf
    (:hook-to 'buffer-list-update-hook #'recentf-track-opened-file))

  (save-place-mode 1)
  (recentf-mode 1)
  (savehist-mode 1))
