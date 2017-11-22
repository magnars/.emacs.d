(use-package rainbow-delimiters :ensure t)
(use-package rainbow-mode :ensure t)
(use-package cider :ensure t)
(use-package clojure-mode :ensure t)
(use-package company :ensure t)
(use-package clojure-cheatsheet :ensure t)
(use-package clojure-snippets :ensure t)
(use-package clojure-mode-extra-font-locking :ensure t)
(use-package flycheck-clojure :ensure t)
;; (use-package clj-refactor :ensure t)
(use-package ob-clojure
  :ensure t
  :config (setq org-babel-clojure-backend 'cider))

;;; clojure-mode
(defun my-clojure-mode-hook ()
  ;; (clj-refactor-mode 1)
  ;; disable fci due to conflict with htmlize
  ;; (setq fci-rule-column 100)
  ;; (setq fci-rule-width 1)
)

(add-hook 'clojure-mode-hook 'my-clojure-mode-hook)

(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'clojure-mode-hook 'fci-mode)

(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'turn-on-smartparens-strict-mode)

;;; cider
(defun my-tab-fix ()
  (local-set-key [tab] 'company-indent-or-complete-common))
(add-hook 'cider-repl-mode-hook 'my-tab-fix)

;; Pretty print results in repl
(setq cider-repl-use-pretty-printing t)

;; Hide nrepl buffers when switching buffers (switch to by prefixing with space)
(setq nrepl-hide-special-buffers t)

;; Enable error buffer popping also in the REPL:
(setq cider-repl-popup-stacktraces t)

;; Specify history file
(setq cider-history-file "~/.emacs.d/nrepl-history")

;; Disable moving to error buffer
(setq cider-auto-select-error-buffer nil)

;; Auto-display the REPL buffer in a separate window after connection
(setq cider-repl-pop-to-buffer-on-connect t)

;; Don't prompt for symbols
(setq cider-prompt-for-symbol nil)

;; Enable eldoc in Clojure buffers
(add-hook 'cider-mode-hook #'eldoc-mode)
;; (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)

;; company mode
(add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)

;; truncate lines
(add-hook 'cider-repl-mode-hook #'toggle-truncate-lines)
(add-hook 'cider-stacktrace-mode-hook #'toggle-truncate-lines)

;; show nrepl server port
(setq nrepl-buffer-name-show-port t)

;; cider test mode - show report
(setq cider-test-show-report-on-success t)

;; retain history
(setq cider-repl-wrap-history t)
(setq cider-repl-history-size 10000)
(setq cider-repl-history-file (concat (getenv "HOME") "/.emacs.d/cider-history"))

;; (eval-after-load 'flycheck '(add-to-list 'flycheck-checkers 'clojure-cider-eastwood))

;; see https://github.com/clojure-emacs/cider/blob/master/doc/using_the_repl.md
;; :repl-options {:init (set! *print-length* 50)}

(provide 'setup-clojure-mode)
