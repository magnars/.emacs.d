;; packages we want installed

(use-package cider :ensure t)
(use-package clojure-mode :ensure t)
(use-package popup :ensure)
(use-package company :ensure t)

(use-package clojure-cheatsheet :ensure t)

(add-to-list 'load-path "~/.emacs.d/site-lisp/kubemacider")
(require 'kubemacider)

;; Cider &amp; nREPL
(add-hook 'cider-mode-hook #'eldoc-mode)
;; (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
(setq nrepl-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "<em>nrepl</em>")

;; Disable moving to error buffer
(setq cider-auto-select-error-buffer nil)

;; company mode
(add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-repl-mode-hook #'toggle-truncate-lines)
(add-hook 'cider-stacktrace-mode-hook #'toggle-truncate-lines)
(add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
;; (global-set-key (kbd "TAB") #'company-indent-or-complete-common)

;; Pretty print results in repl
(setq cider-repl-use-pretty-printing t)

;; yasnippet
(use-package clojure-snippets :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; clojure mode hook and helpers
(defun clojure-mode-custom-indent ()
  (put-clojure-indent 'fnk 'defun)
  (put-clojure-indent 'defnk 'defun)
  (put-clojure-indent 'for-map 1)
  (put-clojure-indent 'pfor-map 1)
  (put-clojure-indent 'instance 2)
  (put-clojure-indent 'inline 1)
  (put-clojure-indent 'letk 1))

(defun indent-whole-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun indent-whole-buffer-c ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun my-tab-fix ()
  (local-set-key [tab] 'company-indent-or-complete-common))

(add-hook 'clojure-mode-hook
          #'(lambda ()
              (clojure-mode-custom-indent)
              (local-set-key (kbd "C-c C-i") 'indent-whole-buffer)
              (local-set-key (kbd "C-c C-/") 'cider-test-run-ns-tests)
              (setq c-basic-offset 4)
              (setq tab-width 4)
              (setq indent-tabs-mode nil)
              (setq cider-auto-select-error-buffer nil)

              (add-hook 'before-save-hook 'indent-whole-buffer nil t)
              (add-hook 'before-save-hook 'delete-trailing-whitespace)))

(add-hook 'cider-repl-mode-hook
          #'(lambda () (my-tab-fix)))

;; let cider use the monorepo
(setq cider-lein-parameters "monolith with-all :select :default repl :headless :host ::")
; (setq cider-lein-parameters "monolith with-all :select :default with-profile dev repl :headless :host ::")

;; show nrepl server port
(setq nrepl-buffer-name-show-port t)

;; cider test mode - show report
(setq cider-test-show-report-on-success t)

;; retain history
(setq cider-repl-wrap-history t)
(setq cider-repl-history-size 10000)
(setq cider-repl-history-file (concat (getenv "HOME") "/.emacs.d/cider-history"))

(use-package fill-column-indicator
  :ensure t
  :config
  (setq fci-rule-column 100)
  (setq fci-rule-width 1)
  (add-hook 'clojure-mode-hook 'fci-mode))

(use-package clojure-mode-extra-font-locking :ensure t)

(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'turn-on-smartparens-strict-mode)

(use-package rainbow-delimiters
  :ensure t
  :config (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))
(use-package rainbow-mode :ensure t)

(cider-add-to-alist 'cider-jack-in-lein-plugins "cider/cider-nrepl" (upcase "0.15.1"))

(use-package ob-clojure
  :ensure t
  :config (setq org-babel-clojure-backend 'cider))
