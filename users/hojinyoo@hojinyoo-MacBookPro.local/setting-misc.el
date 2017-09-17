(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(global-set-key (kbd "C-;") 'switch-to-prev-buffer)

(use-package ace-window
  :ensure t
  :config (global-set-key (kbd "M-p") 'ace-window))

(use-package ace-jump-mode
  :ensure t
  :config (global-set-key (kbd "C-c w") 'ace-jump-word-mode))

;; (use-package golden-ratio
;;   :ensure t
;;   :config
;;   (golden-ratio-mode 1)
;;   (add-to-list 'golden-ratio-extra-commands 'ace-window))

(use-package expand-region
  :ensure t
  :config (global-set-key (kbd "C-=") 'er/expand-region))

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell
         (replace-regexp-in-string "[[:space:]\n]*$" ""
                                   (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
(when (equal system-type 'darwin) (set-exec-path-from-shell-PATH))

;; (set-default-font "Source Code Pro" nil t)
;; (set-face-attribute 'default nil :height 125)

(use-package wgrep :ensure t)

(use-package git-link :ensure t)

;;; stole from git-link
(defun git-link-tree (remote)
  "Create a URL for the current buffer's REMOTE repository homepage.
The URL will be added to the kill ring.  If `git-link-open-in-browser'
is non-nil also call `browse-url'."

  (interactive (list (git-link--select-remote)))
  (let ((remote-host (git-link--remote-host remote)))
    (if remote-host
        ;;TODO: shouldn't assume https, need service specific handler like others
        (git-link--new (format "https://%s/%s/tree/%s" (git-link--remote-host remote) (git-link--remote-dir remote) (git-link--branch)))
      (error  "Remote `%s' is unknown or contains an unsupported URL" remote))))

(use-package dumb-jump
  :ensure t
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config
  (setq dumb-jump-selector 'ivy)
  (setq dumb-jump-aggressive nil))
