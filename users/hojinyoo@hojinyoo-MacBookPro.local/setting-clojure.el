(require 'setup-clojure-mode)

(add-to-list 'load-path "~/.emacs.d/site-lisp/kubemacider")
(require 'kubemacider)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clojure mode hook and helpers

(defun clojure-mode-custom-indent ()
  "Custom identation."
  (put-clojure-indent 'fnk 'defun)
  (put-clojure-indent 'defnk 'defun)
  (put-clojure-indent 'for-map 1)
  (put-clojure-indent 'pfor-map 1)
  (put-clojure-indent 'instance 2)
  (put-clojure-indent 'inline 1)
  (put-clojure-indent 'letk 1)
  (put-clojure-indent 'fdef 0))

(defun indent-whole-buffer ()
  "Indent whole buffer."
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun indent-whole-buffer-c ()
  "Indent whole buffer."
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun lint-before-save ()
  "Command for linting."
  (clojure-mode-custom-indent)
  (local-set-key (kbd "C-c C-i") 'indent-whole-buffer)
  (local-set-key (kbd "C-c C-/") 'cider-test-run-ns-tests)
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq cider-auto-select-error-buffer nil)

  (add-hook 'before-save-hook 'indent-whole-buffer nil t)
  (add-hook 'before-save-hook 'delete-trailing-whitespace))
(add-hook 'clojure-mode-hook 'lint-before-save)

;; (cider-add-to-alist 'cider-jack-in-lein-plugins "cider/cider-nrepl" (upcase "0.16.0")) ;; moved to .lein/profile.clj
;; (setq cider-jack-in-lein-plugins nil)

;; (use-package flycheck-tip
;;   :ensure t
;;   (flycheck-tip-use-timer 'verbose))

(flycheck-clojure-setup)
(use-package flycheck-pos-tip
  :ensure t
  :config (setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; (add-hook 'cider-mode-hook
;;   (lambda () (setq next-error-function #'flycheck-next-error-function)))

(defun clojure-minor-mode-hook ()
  "My settings for clojure."
    (clj-refactor-mode 1)
    (yas-minor-mode 1)
    (cljr-add-keybindings-with-prefix "C-c C-m"))
(add-hook 'clojure-mode-hook 'clojure-minor-mode-hook)

;; (cider-add-to-alist 'cider-jack-in-lein-plugins "refactor-nrepl" "2.3.1")
;; (cider-add-to-alist 'cider-jack-in-dependencies "acyclic/squiggly-clojure" "0.1.8")

(provide 'setting-clojure)
