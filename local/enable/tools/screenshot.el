;;; screenshot.el -*- lexical-binding: t; -*-

(enable-if (not rps-system-windows-p))

(store-install "imagemagick"
  :xbps '(:name "ImageMagick" :system void-linux)
  :then
  (lambda ()
    (cfg-pkg (:elpaca screenshot
                      :host github
                      :repo "tecosaur/screenshot"
		              :files ("*.el"))
      (:bind rps-keymap-open
             "s" #'screenshot))))
