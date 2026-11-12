;;; compile.el -*- lexical-binding: t; -*-

(cfg compile
  (:autoload comint-truncate-buffer)
  (:opt compilation-scroll-output 'first-error)
  ;; Placement of compilation buffers lives in popper.el with the other popups.
  (:hook-to 'compilation-filter-hook #'comint-truncate-buffer #'rps-compilation-colorize)
  (:after-this
    (:bind compilation-mode-map
           "M-<" #'beginning-of-buffer
           "M->" #'end-of-buffer
           "<" #'scroll-down-command
           ">" #'scroll-up-command)))

(defun rps-compilation-colorize ()
  (with-silent-modifications
    (ansi-color-apply-on-region compilation-filter-start (point))))

