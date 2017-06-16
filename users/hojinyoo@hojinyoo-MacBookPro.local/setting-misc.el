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

(set-default-font "Source Code Pro" nil t)
(set-face-attribute 'default nil :height 125)

(use-package wgrep
  :ensure t)
