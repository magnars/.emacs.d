(use-package jedi :ensure t)
(use-package py-autopep8 :ensure t)

(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  (elpy-use-ipython)
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (add-hook 'elpy-mode-hook 'flycheck-mode)
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  (setq elpy-rpc-backend "jedi")
  (eval-after-load 'elpy
          '(progn
             (define-key elpy-mode-map (kbd "<M-up>") nil)
             (define-key elpy-mode-map (kbd "<M-down>") nil)
             (define-key elpy-mode-map (kbd "<C-left>") nil)
             (define-key elpy-mode-map (kbd "<C-right>") nil))))

(use-package ein
  :ensure t
  :config
  (add-hook 'ein:connect-mode-hook 'ein:jedi-setup)
  ;; (setq ein:use-auto-complete-superpack t)
  ;; (setq ein:console-args
  ;;       (lambda (url-or-port) '("--ssh" "dev")))
  (setq ein:completion-backend 'ein:use-company-backend)
  (eval-after-load 'ein:notebook-mode
          '(progn
             (define-key ein:notebook-mode-map (kbd "<M-up>") nil)
             (define-key ein:notebook-mode-map (kbd "<M-down>") nil)
             (define-key ein:notebook-mode-map (kbd "<C-left>") nil)
             (define-key ein:notebook-mode-map (kbd "<C-right>") nil))))

;; (use-package smartrep :ensure t)

(add-hook 'ein:notebook-mode-hook #'smartparens-mode)

(sp-with-modes 'ein:notebook-multilang-mode
  (sp-local-pair "'" "'" :unless '(sp-in-comment-p sp-in-string-quotes-p) :post-handlers '(:add sp-python-fix-tripple-quotes))
  (sp-local-pair "\"" "\"" :post-handlers '(:add sp-python-fix-tripple-quotes))
  (sp-local-pair "'''" "'''")
  (sp-local-pair "\\'" "\\'")
  (sp-local-pair "\"\"\"" "\"\"\""))

;; (setq ein:use-smartrep t)

;; workaround python console issue
;; https://github.com/millejoh/emacs-ipython-notebook/issues/191
(setenv "JUPYTER_CONSOLE_TEST" "1")
;; https://github.com/jorgenschaefer/elpy/issues/887
(setq python-shell-completion-native-enable nil)

;; (add-hook 'python-mode-hook
;;           (progn
;;             ;; (setq indent-tabs-mode nil))
;;             (local-set-key (kbd "<C-up>") 'sgml-skip-tag-forward)
;;             (local-set-key (kbd "<C-down>") 'sgml-skip-tag-backward))

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

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ein . t)))

(provide 'setup-python)
