(use-package haskell-mode
  :ensure t)

(use-package scion
  :ensure t)

(use-package hindent
  :ensure t)

;; See https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md
(add-hook 'haskell-mode-hook #'hindent-mode)

(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))


;; use setq properly instead of custom-set-variables
(custom-set-variables '(haskell-tags-on-save t))

(custom-set-variables
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-log t))

(custom-set-variables '(haskell-process-type 'cabal-repl))
