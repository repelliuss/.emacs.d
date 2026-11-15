;;; spacious-padding.el -*- lexical-binding: t; -*-

(cfg-pkg spacious-padding
  (:opt spacious-padding-subtle-frame-lines nil
        spacious-padding-widths (list :internal-border-width 32
                                      :fringe-width 8
                                      :header-line-width 0
                                      :mode-line-width 0
                                      :tab-width 4
                                      :right-divider-width 8
                                      :scroll-bar-width 8
                                      :fringe-width 8
                                      :custom-button-width 8))
  ;; every path into spacious-padding re-specs its faces as a theme, which
  ;; wipes whatever `:face' set.  it is reached on mode toggle,
  ;; `window-divider-mode-hook' and each new frame, so cover the function
  ;; rather than each of its callers.
  (:advice-to #'spacious-padding-set-faces :after #'cfg-faces-apply)

  (spacious-padding-mode 1))
