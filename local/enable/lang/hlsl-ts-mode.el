;;; hlsl-ts-mode.el -*- lexical-binding: t; -*-

(cfg-pkg (:elpaca lsp-shader-sense
                  :host github
                  :repo "repelliuss/lsp-shader-sense"))

(cfg-pkg (:elpaca lsp-hlsl
                  :host github
                  :repo "repelliuss/lsp-hlsl"))

(cfg-pkg (:require (:elpaca hlsl-ts-mode
                            :host github
                            :repo "repelliuss/hlsl-ts-mode"))
  (:after lsp-mode
    (:require lsp-shader-sense lsp-hlsl)
    (:hook-to 'hlsl-ts-mode #'lsp-deferred)))

