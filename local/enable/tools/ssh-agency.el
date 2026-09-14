;;; ssh-agency.el -*- lexical-binding: t; -*-

(enable-when (not rps-system-android-p))

(cfg-pkg ssh-agency
  (:after magit (:require ssh-agency))
  (:hook-to 'vc-retrieve-tag
    #'ssh-agency-ensure))
