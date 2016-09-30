(require 'setup-python)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq py-autopep8-options '("--max-line-length=120"))
            ;; (local-set-key (kbd "C-c C-d") 'python-restart--shell-send-region-or-buffer)
            ;; (defun python-restart--shell-send-region-or-buffer (&optional arg)
            ;;   "Restart the python shell, and send the active region or the buffer to it."
            ;;   (interactive "P")
            ;;   (pyvenv-restart-python)
            ;;   (elpy-shell-send-region-or-buffer (and )rg))
            ))


;; (setenv "PYTHONPATH" "/home/hyoo/repo/scripts/_modules/python:/apps/jv/lib/spark/2.0.0-bin-hadoop2.7/python:/apps/jv/lib/spark/2.0.0-bin-hadoop2.7/python/lib/py4j-0.10.1-src.zip")
(pyvenv-activate "/home/hojinyoo/projects/forecast/venv")

(elpy-enable)
(setq elpy-rpc-backend "jedi")
(elpy-use-ipython)
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; I added the following:
;; cat ~/.config/flake8
;; [flake8]
;; ignore = E221,E501,E203,E202,E272,E251,E211,E222,E701
;; max-line-length = 160
;; exclude = tests/*
;; max-complexity = 10
