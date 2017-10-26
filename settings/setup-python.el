(use-package jedi :ensure t)
(use-package py-autopep8 :ensure t)

(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  (elpy-use-ipython)
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (setq elpy-rpc-backend "jedi"))

(use-package ein
  :ensure t
  :config
  (add-hook 'ein:connect-mode-hook 'ein:jedi-setup)
  ;; (setq ein:use-auto-complete-superpack t)
  ;; (setq ein:console-args
  ;;       (lambda (url-or-port) '("--ssh" "dev")))
  (setq ein:completion-backend 'ein:use-company-backend))

;; (use-package smartrep
;;   :ensure t
;;   :config
;;   (setq ein:use-smartrep t))

;; (add-hook 'python-mode-hook
;;       (lambda ()
;;         (setq indent-tabs-mode nil)))

(setq python-shell-interpreter "ipython" python-shell-interpreter-args "--simple-prompt --pprint")
;; (setq python-shell-interpreter-args "--simple-prompt -i")
;; (setq python-shell-interpreter-interactive-arg "--simple-prompt -i")

;; cat ~/.config/flake8
;; [flake8]
;; ignore = E221,E501,E203,E202,E272,E251,E211,E222,E701
;; max-line-length = 160
;; exclude = tests/*
;; max-complexity = 10

;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (setq indent-tabs-mode nil)
;;             ;; (setq tab-width 2)
;;             ;; (setq python-indent 2)
;;             ;; (setq py-autopep8-options '("--indent-size=2" "--max-line-length=120"))
;;             ;; (local-set-key (kbd "C-c C-d") 'python-restart--shell-send-region-or-buffer)
;;             ;; (defun python-restart--shell-send-region-or-buffer (&optional arg)
;;             ;;   "Restart the python shell, and send the active region or the buffer to it."
;;             ;;   (interactive "P")
;;             ;;   (pyvenv-restart-python)
;;             ;;   (elpy-shell-send-region-or-buffer (and )rg))
;;             ))

(provide 'setup-python)
