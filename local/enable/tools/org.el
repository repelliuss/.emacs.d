;;; org.el -*- lexical-binding: t; -*-

(cfg-pkg org
  (:bind rps-keymap-note
         "l" #'org-store-link)
  (:after-this
    (:bind org-mode-map
           (:locally
            "t" #'org-todo
            "l" #'org-insert-last-stored-link)))
  (:opt org-directory (:mkdir rps-dir-home "org")
	    org-id-locations-file (:touch org-directory ".org-id-locations")
	    org-archive-location (:join (:mkdir org-directory "archive") "archive_%s::datetree")
	    org-persist-directory (:mkdir rps-dir-cache "org-persist")
        org-attach-id-dir (:mkdir org-directory "attachments")
	    org-id-link-to-org-use-id t
        org-startup-indented t
        org-todo-keywords '((sequence "TODO" "NEXT" "WAIT" "|" "DONE" "CNCL"))
        org-auto-align-tags nil
        org-tags-column 0
        org-catch-invisible-edits 'show-and-error
        org-special-ctrl-a/e t
        org-insert-heading-respect-content t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-agenda-tags-column 0
        org-log-done 'time
        org-reverse-note-order t
        org-complete-tags-always-offer-all-agenda-tags t
        org-ellipsis "…"
        org-clock-idle-time 5)
  (:hook #'rps-org-mode-disable-line-spacing)
  (:face org-block-begin-line (:overline t)
         org-block-end-line (:underline '(:position bottom))))

(cfg-pkg org-pdftools
  (:opt org-pdftools-markup-pointer-function #'pdf-annot-add-highlight-markup-annotation)
  (:hook-to 'org-mode-hook #'org-pdftools-setup-link)
  ;; org-noter cries about nov and djvu is not installed. org-noter is dependency of org-pdftools so silence it.
  (cfg org-noter
    (:opt org-noter-supported-modes '(doc-view-mode pdf-view-mode))))

(defun rps-org-mode-disable-line-spacing (&rest args)
  (setq-local line-spacing nil))
