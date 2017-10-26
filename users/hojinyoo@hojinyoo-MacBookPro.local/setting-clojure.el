(require 'setup-clojure-mode)

(add-to-list 'load-path "~/.emacs.d/site-lisp/kubemacider")
(require 'kubemacider)

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

;; let cider use the monorepo
(setq cider-lein-parameters "monolith with-all :select :default repl :headless :host ::")
; (setq cider-lein-parameters "monolith with-all :select :default with-profile dev repl :headless :host ::")

(cider-add-to-alist 'cider-jack-in-lein-plugins "cider/cider-nrepl" (upcase "0.15.1"))
