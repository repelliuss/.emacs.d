;;; git.el -*- lexical-binding: t; -*-

(defun rps--git-config-all (ctx steps)
  "Run each of STEPS as `git config --global ARGS...', in order.
A step is (ACCEPTED-CODES . ARGS); ACCEPTED-CODES lists the exit codes
that count as success. Calls `store-install-ok' on CTX when every step
succeeds, else `store-install-fail' naming the step that failed."
  (if-let* ((failed (cl-find-if-not
                     (lambda (step)
                       (memq (apply #'call-process "git" nil nil nil
                                    "config" "--global" (cdr step))
                             (car step)))
                     steps)))
      (store-install-fail
       ctx (format "post-install: git config --global %s failed"
                   (string-join (cdr failed) " ")))
    (store-install-ok ctx)))

(store-thread
  (store-install "git"
    :pacman '(:name "mingw-w64-x86_64-git" :system windows)
    :post-install
    (lambda (ctx)
      (rps--git-config-all
       ctx '(((0) "user.name" "repelliuss")
             ((0) "user.email" "repelliuss@gmail.com")
             ((0) "core.autocrlf" "false")
             ((0) "status.showUntrackedFiles" "all")))))

  :then
  (store-install "git-gui"
    :pacman '(:name "mingw-w64-x86_64-git-gui" :system windows))

  :then
  (store-install "git-credential-oauth"
    :skip '(:system android)
    :post-install
    (lambda (ctx)
      (rps--git-config-all
       ;; --unset-all exits 5 when credential.helper isn't set yet —
       ;; that's fine, there was simply nothing to clear.
       ctx '(((0 5) "--unset-all" "credential.helper")
             ((0) "--add" "credential.helper" "cache --timeout 21600")
             ((0) "--add" "credential.helper" "oauth")
             ((0) "github.user" "repelliuss"))))))

(cfg-pkg git-timemachine
  (:after meow
    (:prepend meow-mode-state-list '(git-timemachine-mode . motion))))
