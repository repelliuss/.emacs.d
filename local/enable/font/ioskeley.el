;;; ioskeley.el -*- lexical-binding: t; -*-

(store-install "https://github.com/ahatem/IoskeleyMono/releases/download/v2.1.0/IoskeleyMono.zip"
  :url-font t
  :then
  (lambda ()
    (cfg fontaine
      (:after-this
        (:prepend* fontaine-presets '((regular-ioskeley-mono :default-family "Ioskeley Mono"
                                                             :default-weight regular
                                                             :default-height 150
                                                             :variable-pitch-family "Ioskeley Mono"
                                                             :mode-line-active-height 130
                                                             :mode-line-inactive-height 130)
                                      (regular-ioskeley-mono-sm :inherit regular-ioskeley-mono
                                                                :default-height 120)))

        (unless rps-system-android-p
          (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular-ioskeley-mono))
          
          ;; fontaine doesn't handle mode-line face but doom-modeline
          ;; explicitly use it to define a blank seperator between left
          ;; aligned and right aligned segments for inactive(?)
          ;; window. this causes shift on right side of the mode line
          ;; after changing selected window.
          (:face mode-line (:family "Ioskeley Mono" :height 130))
          
          ;; furthermore, spacious-padding-mode resets the mode-line for some reason
          (:hook-to 'spacious-padding-mode
            (lambda () (:face mode-line (:family "Ioskeley Mono" :height 130)))))
        
        (when rps-system-android-p
          (defun rps-font-set-ioskeley ()
            (interactive)
            (:face default (:family "Ioskeley Mono" :height 150)
                   fixed-pitch (:family "Ioskeley Mono")
                   header-line (:family "Ioskeley Mono")
                   mode-line (:family "Ioskeley Mono")))
          (rps-font-set-ioskeley))))))
