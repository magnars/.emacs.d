(use-package nix-mode
  :ensure t)

(use-package lua-mode
  :ensure t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(global-set-key (kbd "C-'")  'other-window)
(global-set-key (kbd "C-;") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)
