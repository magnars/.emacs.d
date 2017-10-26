(pyvenv-activate "/home/hojinyoo/project/kaggle/venv3")

(require 'setup-python)

(use-package ob-ipython
  :ensure t
  :config
  (add-hook 'org-mode-hook 'my-ob-ipython-config)
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((ipython . t)
                                 ;; other languages..
                                 )))

(defun my-ob-ipython-config ()
  "For use in `org-mode-hook'."
  (local-set-key (kbd "C-c C-o") 'org-edit-src-code)
  (setq org-confirm-babel-evaluate nil)   ;don't prompt me to confirm everytime I want to evaluate a block
  ;;; display/update images in the buffer after I evaluate
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
)
