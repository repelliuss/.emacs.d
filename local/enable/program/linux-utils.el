;;; linux-utils.el -*- lexical-binding: t; -*-

;; xdg-utils doesn't exist on Android/Termux at all (requested but never
;; added — see termux/termux-packages#15388).
(enable-if (not rps-system-android-p))

(store-install "xdg-utils")

