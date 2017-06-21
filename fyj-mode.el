;;; fyj-mode.el --- Minor mode for playing background musci

;; Copyright 2017 Free Software Foundation, Inc.
;;
;; Author: Jackson Fu <fuyajun1983cn@163.com>
;; Keywords: emacs background music
;; Homepage:
;; Version: 0.1

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a minor mode for playing background music

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'fyj-mode)

;;; Code:

(defgroup fyj nil
  "Fyj background music mode."
  :prefix "fyj-"
  :group 'applications)


(defcustom fyj-player nil
  "Specify a music player executable name.
Suggested values are:

mplayer  using mplayer as the backend
cvlc     using vlc as the backend"
  :group 'fyj
  :type 'string)

(defcustom fyj-playlistdir nil
  "Specify the play list directory."
  :group 'fyj
  :type 'string)

(defvar fyj-mode-timer nil
  "Is player running now.")
(make-variable-buffer-local 'fyj-mode-timer)

(defvar fyj-mode nil
  "Mode variable for refill minor mode.")
(make-variable-buffer-local 'fyj-mode)



(defun fyj-play-music-file ()
  "Play music file specified by MUSIC-FILE."
  (let* ((list (directory-files fyj-playlistdir nil "\\.mp3$"))
         (n (length list))
         (file (nth (random n) list)))
    (if (executable-find fyj-player)
        (progn
          (start-process fyj-player nil fyj-player (format "%s/%s" fyj-playlistdir file))
          (if (executable-find "notify-send")
              (start-process "fyj-mode-notification" nil "notify-send" (format "将要播放 %s" file))
            (message (format "将要播放 %s" file)))
          )
      (message "Please install mplayer on your system first."))))

(defun toggle-play-background-music()
  "Start or stop background music player."
  (if (get-process fyj-player)
      (progn
      (interrupt-process fyj-player))
    (fyj-play-music-file)))

(defun fyj-mode-timer-handler()
  "Handler for timer."
  (unless (get-process fyj-player)
    (toggle-play-background-music)))

(define-minor-mode global-fyj-mode
  "Minor mode: FYJ-MODE."
  :group 'fyj
  :global t
  (cond
   (fyj-mode
    (progn
      (message "turn fyj-mode off")
      (setq fyj-mode nil)
      (when fyj-mode-timer
        (cancel-timer fyj-mode-timer)
        (setq fyj-mode-timer nil))))
   (t
    (progn
      (message "turn fyj-mode on")
      (setq fyj-mode t)
      (setq fyj-mode-timer (run-with-timer 0 3 'fyj-mode-timer-handler)))))
  (toggle-play-background-music))

(provide 'fyj-mode)

;;; fyj-mode.el ends here


