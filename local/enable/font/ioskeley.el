;;; ioskeley.el -*- lexical-binding: t; -*-

(defun rps-fontaine-set-latest-preset ()
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular-ioskeley-mono)))

(defun rps-ioskeley-set-mode-line-face (&rest _)
  (set-face-attribute 'mode-line nil :family "Ioskeley Mono" :height 130))

(store-install "https://github.com/ahatem/IoskeleyMono/releases/download/v2.1.0/IoskeleyMono.zip"
  :url-font t
  :then
  (lambda ()
    (cfg fontaine
      (:after-this
        (:prepend* fontaine-presets '((regular-ioskeley-mono :default-family "Ioskeley Mono"
                                                             :default-weight regular
                                                             :default-height 160
                                                             :variable-pitch-family "Ioskeley Mono"
                                                             :mode-line-active-height 130
                                                             :mode-line-inactive-height 130)
                                      (regular-ioskeley-mono-sm :inherit regular-ioskeley-mono
                                                                :default-height 120)))

        (unless rps-system-android-p
          (if (daemonp)
              (:hook-to 'server-after-make-frame-hook #'rps-fontaine-set-latest-preset)
            (rps-fontaine-set-latest-preset))
          
          ;; fontaine doesn't handle mode-line face but doom-modeline
          ;; explicitly use it to define a blank seperator between left
          ;; aligned and right aligned segments for inactive(?)
          ;; window. this causes shift on right side of the mode line
          ;; after changing selected window.
          (:face mode-line (:family "Ioskeley Mono" :height 130))
          
          ;; furthermore, spacious-padding-mode and every theme (re)enable
          ;; reset the mode-line face (verified: load-theme wipes it).
          (:hook-to 'spacious-padding-mode #'rps-ioskeley-set-mode-line-face)
          (:hook-to 'enable-theme-functions (90 #'rps-ioskeley-set-mode-line-face)))
        
        (when rps-system-android-p
          (defun rps-font-set-ioskeley ()
            (interactive)
            (:face default (:family "Ioskeley Mono" :height 150)
                   fixed-pitch (:family "Ioskeley Mono")
                   header-line (:family "Ioskeley Mono")
                   mode-line (:family "Ioskeley Mono")))
          (rps-font-set-ioskeley))))))

