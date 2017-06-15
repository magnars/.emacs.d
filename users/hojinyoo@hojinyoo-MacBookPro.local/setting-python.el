(require 'setup-python)

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode nil)
        ;; (setq tab-width 2)
        ;; (setq python-indent 2)
        ;; (setq py-autopep8-options '("--indent-size=2"))
))

;; (setenv "PYTHONPATH" "/Users/hojin.yoo/project/repo/scripts/_modules/python")
(pyvenv-activate "~/env")

(elpy-enable)
(setq elpy-rpc-backend "jedi")
(elpy-use-ipython)


(setq python-shell-interpreter "ipython" python-shell-interpreter-args "--simple-prompt --pprint")
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; (setq ein:use-auto-complete-superpack t)
;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
