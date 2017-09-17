(require 'setup-python)

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode nil)))
;; (add-hook 'python-mode-hook 'paredit-mode)

(pyvenv-activate "~/env")

(elpy-enable)
(elpy-use-ipython)

;; (setq python-shell-interpreter "ipython" python-shell-interpreter-args "--simple-prompt --pprint")
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; (setq ein:use-auto-complete-superpack t)
;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(setq ein:completion-backend 'ein:use-company-backend)
;; (setq ein:use-auto-complete-superpack t)
;; token : fbb91ad090b8cc1f3576e7cef941162027877f5f169c9f83
;; (setq ein:console-args
;;       (lambda (url-or-port) '("--ssh" "dev")))
