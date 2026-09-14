;;; compile-angel.el -*- lexical-binding: t; -*-

(cfg-pkg (:require compile-angel)
  (:opt compile-angel-verbose t
        native-comp-async-query-on-exit t)
  (push "/init.el" compile-angel-excluded-path-suffixes)
  (push "/early-init.el" compile-angel-excluded-path-suffixes)
  (compile-angel-on-load-mode 1))
