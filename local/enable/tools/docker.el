;;; docker.el -*- lexical-binding: t; -*-

;; Docker doesn't actually work on Android/Termux: the kernel lacks what
;; Docker needs even rooted, and Termux's own docker package is patched
;; but not fully functional (docker-compose broken).
(enable-if (not rps-system-android-p))

(store-thread
  (store-install "docker")

  :then
  (store-install "docker-compose"
    :explicit t
    :xbps '(:name "docker-compose")))

(cfg-pkg docker
  (:bind rps-keymap-open
         "d" #'docker)
  (:opt docker-compose-command "docker-compose")
  (:after eat
    (:opt docker-run-async-with-buffer-function #'docker-run-async-with-buffer-eat)

    (:after docker-compose
      (transient-append-suffix 'docker-compose-up "t"
        '("w" "Watch" "--watch")))))
