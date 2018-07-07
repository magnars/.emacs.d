;; rename current buffer-visiting file
(defun yt/rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun yt/delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(defun yt/last-updated-date ()
  "return modification time of current file-visitng buffer"
  (interactive)
  (let* ((mtime (visited-file-modtime)))
    (unless (integerp mtime)
      (concat "/Last UPdated/: "
              (format-time-string "%d %b %Y" mtime)))))

(defun yt/sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))


;; (defhydra hydra-file-management (:color red
;;                                         :hint nil)
;;   "
;; _o_pen file
;; _O_pen file as Sudo user
;; copy file _p_ath to kill ring
;; _r_ename buffer-visiting file
;; _d_elete buffer-visiting file"
;;   ("o" find-file)
;;   ("O" yt/sudo-find-file)
;;   ("p" yt/copy-full-path-to-kill-ring)
;;   ("r" yt/rename-current-buffer-file)
;;   ("c" yt/copy-file-to)
;;   ("d" yt/delete-this-buffer-and-file)
;;   )
;; (global-set-key [f3] 'hydra-file-management/body)

;; full path of current buffer
(defun yt/copy-full-path-to-kill-ring ()
  "copy buffer's full path to kill ring"
  (interactive)
  (when buffer-file-name
    (kill-new (file-truename buffer-file-name))))
