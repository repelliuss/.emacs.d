;;; org-remark.el -*- lexical-binding: t; -*-

(cfg-pkg org-remark
  (:after-this
    (:opt org-remark-notes-file-path (:join org-directory "org-remark.org")))
  (:bind
    ((setq org-remark-map (make-sparse-keymap))
     (:repeat
       "[" #'org-remark-prev
       "]" #'org-remark-next
       "{" #'org-remark-view-prev
       "}" #'org-remark-view-next)
     "m" #'org-remark-mark
     "l" #'org-remark-mark-line
     "o" #'org-remark-open
     "d" #'org-remark-remove
     "k" #'org-remark-delete
     "s" #'org-remark-save
     "c" #'org-remark-change
     "t" #'org-remark-toggle
     "v" #'org-remark-view))
  (:after org
    (:bind org-mode-map
           (:locally
            "r" (cons "remark" org-remark-map)))
    (org-remark-global-tracking-mode 1)))
