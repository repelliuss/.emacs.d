;;; msvc.el -*- lexical-binding: t; -*-

(enable-if rps-user-work-p)

(cfg-pkg (:require (:elpaca msvc
                              :host github
                              :repo "repelliuss/msvc"
							  :protocol ssh)
                     msvc-sndbs))

