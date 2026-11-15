;;; hl-todo.el -*- lexical-binding: t; -*-

(cfg-pkg hl-todo
  (:opt
   hl-todo-color-background t
   hl-todo-highlight-punctuation ":")

  (:face hl-todo (:bold t :foreground "white"))

  (:after-this
    (:opt hl-todo-keyword-faces (-map (-lambda ((key . value))
                                        (cons (format "%s\\(_[^[:blank:]:]*\\)?" key) value))
                                      (append hl-todo-keyword-faces (list (cons "CNCL" "#695500")
                                                                          (cons "WAIT" "#d0bf8f"))))))

  (global-hl-todo-mode 1))

(cfg-pkg consult-todo
  (:bind rps-keymap-search
         "t" #'consult-todo
         "T" #'consult-todo-all))

