;;; window-box.el -*- lexical-binding: t; -*-

(cfg-pkg (:elpaca window-box
                  :host github
                  :repo "MArpogaus/window-box")
  (:opt window-box-window-predicate
        (lambda (window) (window-parameter window 'window-side)))
  (global-window-box-mode 1))
