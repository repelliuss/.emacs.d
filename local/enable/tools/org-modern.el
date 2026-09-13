;;; org-modern.el -*- lexical-binding: t; -*-

(cfg-pkg org-modern
  (global-org-modern-mode 1))

(cfg-pkg (:elpaca org-modern-indent
                  :host github
                  :repo "jdtsmith/org-modern-indent")
  ;; Enable after org-indent-mode
  (:hook-into (90 org-indent-mode-hook)))
