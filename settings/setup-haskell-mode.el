(use-package haskell-mode :ensure t)
;; (use-package scion :ensure t)
(use-package hindent :ensure t)
(use-package intero :ensure t)

(add-hook 'haskell-mode-hook 'intero-mode)

;; See https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md
(add-hook 'haskell-mode-hook #'hindent-mode)

(add-hook 'haskell-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 (append '((company-capf company-dabbrev-code))
                         company-backends))))

(add-hook 'haskell-mode-hook 'turn-on-haskell-unicode-input-method)

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
(custom-set-variables '(haskell-interactive-popup-errors nil))

(provide 'setup-haskell-mode)
