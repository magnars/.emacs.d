(use-package jedi
  :ensure t)

(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  (setq elpy-rpc-backend "jedi"))

(use-package ein
  :ensure t
  :config
  (add-hook 'ein:connect-mode-hook 'ein:jedi-setup))

(use-package py-autopep8
  :ensure t
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

(provide 'setup-python)
