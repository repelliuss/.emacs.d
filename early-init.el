;;; early-init.el --- -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "local/package/enable" user-emacs-directory))

(defvar enable-config-file (concat user-emacs-directory "local/enable/config.el"))
(require 'enable)
(require 'enable-catalog)

(enable-module :local :path (concat user-emacs-directory "local/enable/"))
(enable :early)
(elpaca-wait)
