;;; transient.el -*- lexical-binding: t; -*-

(cfg-pkg transient
  (:opt transient-levels-file (:join rps-dir-cache "transient" "levels.el")
        transient-values-file (:join rps-dir-cache "transient" "values.el")
        transient-history-file (:join rps-dir-cache "transient" "history.el")
        transient-history (transient--read-file-contents transient-history-file)))

