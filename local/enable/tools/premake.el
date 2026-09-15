;;; premake.el -*- lexical-binding: t; -*-

(enable-if rps-user-work-p)

(cfg-pkg (:require (:elpaca premake
                              :host github
                              :repo "repelliuss/premake"
							  :protocol ssh
                              :files (:defaults "files"))))

