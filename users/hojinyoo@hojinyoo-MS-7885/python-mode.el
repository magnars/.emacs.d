(require 'setup-python)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 2)
            (setq python-indent 2)
            (setq py-autopep8-options '("--indent-size=2" "--max-line-length=120"))
            ;; (local-set-key (kbd "C-c C-d") 'python-restart--shell-send-region-or-buffer)
            ;; (defun python-restart--shell-send-region-or-buffer (&optional arg)
            ;;   "Restart the python shell, and send the active region or the buffer to it."
            ;;   (interactive "P")
            ;;   (pyvenv-restart-python)
            ;;   (elpy-shell-send-region-or-buffer (and )rg))
            ))


(setenv "PYTHONPATH" "/home/hyoo/projects/notes/modules")
(pyvenv-activate "/home/hojinyoo/projects/forecast/venv")

(elpy-enable)
(setq elpy-rpc-backend "jedi")
(elpy-use-ipython)
(setq python-shell-interpreter-args "--simple-prompt -i")
(setq python-shell-interpreter-interactive-arg "--simple-prompt -i")

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

(use-package ob-ipython
  :ensure t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ipython . t)
   ;; other languages..
   ))

(defun my-ob-ipython-config ()
  "For use in `org-mode-hook'."
  (local-set-key (kbd "C-c C-o") 'org-edit-src-code)
  (setq org-confirm-babel-evaluate nil)   ;don't prompt me to confirm everytime I want to evaluate a block
  ;;; display/update images in the buffer after I evaluate
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
)

(add-hook 'org-mode-hook 'my-ob-ipython-config)
