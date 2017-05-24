(defun install-if (name)
  (print (concat "considering" (symbol-name name) "\n"))
  (when (not (package-installed-p name))
    (print (concat "installing" (symbol-name name) "\n"))
    (package-install name)))

;; packages we want installed
;; (install-if 'zenburn-theme)
(install-if 'cider)
(install-if 'clojure-mode)
(install-if 'auto-complete)
(install-if 'ac-cider)
(install-if 'paredit)
(install-if 'popup)
(install-if 'rainbow-delimiters)
(install-if 'rainbow-mode)
(install-if 'company)
(install-if 'autopair)

(use-package clojure-cheatsheet
  :ensure t)
(require 'ob-clojure)
(setq org-babel-clojure-backend 'cider)

;; Cider &amp; nREPL
(add-hook 'cider-mode-hook #'eldoc-mode)
;; (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
(setq nrepl-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "<em>nrepl</em>")

;; General Auto-Complete
;; (require 'auto-complete-config)
;; ;(setq ac-delay 0.0)
;; ;(setq ac-quick-help-delay 0.5)
;; (ac-config-default)
;; (setq ac-auto-start nil)
;; (ac-set-trigger-key "TAB")

;; Disable moving to error buffer
(setq cider-auto-select-error-buffer nil)

;; ac-cider (Auto-complete for the nREPL)
(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

;; Disable entries in the popup menu will also display the namespace that the symbol belongs to.
(setq ac-cider-show-ns nil)

;; Trigger auto-complete using TAB in CIDER buffers
; (defun set-auto-complete-as-completion-at-point-function ()
;   (setq completion-at-point-functions '(auto-complete)))
; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
; (add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; paredit
(add-hook 'clojure-mode-hook 'paredit-mode)

;; Show parenthesis mode
(show-paren-mode 1)

;; rainbow delimiters
;;(global-rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; Noctilus Theme
;(load-theme 'noctilux t)

;; Switch frame using F8
;; (global-set-key [f8] 'other-frame)
;; (global-set-key [f7] 'paredit-mode)
;; (global-set-key [f9] 'cider-jack-in)
;; (global-set-key [f11] 'speedbar)


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
  (untabify (point-min) (point-max))
  )

(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))

(defun my-tab-fix ()
  (local-set-key [tab] 'indent-or-expand))

(add-hook 'clojure-mode-hook
          #'(lambda ()
              (autopair-mode)
              (clojure-mode-custom-indent)
              (local-set-key (kbd "C-c C-i") 'indent-whole-buffer)
              (local-set-key (kbd "C-c C-/") 'cider-test-run-ns-tests)
              (setq c-basic-offset 4)
              (setq tab-width 4)
              (setq indent-tabs-mode nil)
              (setq cider-auto-select-error-buffer nil)
              (my-tab-fix)

              (add-hook 'before-save-hook 'indent-whole-buffer nil t)
              (add-hook 'before-save-hook 'delete-trailing-whitespace)))

(add-hook 'cider-repl-mode-hook 'paredit-mode)

;; let cider use the monorepo
; (setq cider-lein-parameters "monolith with-all :select :default repl :headless :host ::")
; (setq cider-lein-parameters "monolith with-all :select :default with-profile dev repl :headless :host ::")


;; show nrepl server port
(setq nrepl-buffer-name-show-port t)

;; cider test mode - show report
(setq cider-test-show-report-on-success t)

;; retain history
(setq cider-repl-wrap-history t)
(setq cider-repl-history-size 10000)
(setq cider-repl-history-file (concat (getenv "HOME") "/.cider-history"))

;; line length limit indicator
(require 'fill-column-indicator)
(setq fci-rule-column 100)
(setq fci-rule-width 1)
;; (setq fci-rule-color "color-244")
(add-hook 'clojure-mode-hook 'fci-mode)

(add-to-list 'tramp-methods
              '("pod"
                (tramp-login-program "kubectl")
                (tramp-login-args
                 (("exec")
                  ("-it")
                  ("%h")
                  ("-n")
                  ("contour")
                  ("/bin/sh")))
                (tramp-login-env
                  (("SHELL")
                   ("/bin/sh")))
                (tramp-remote-shell "/bin/sh")))

;; ;; cider-diet for fast start-up
;; (setq cider-diet-path (expand-file-name (concat user-emacs-directory
;;                                                 "/bin/cider-diet-0.1.0-SNAPSHOT-standalone.jar")))

;; (defun cider-diet-jack-in ()
;;   (interactive)
;;   (let* ((cider-diet-process (start-process "cider-diet-nrepl" "*cider-diet-nrepl*"
;;                                             "java" "-jar" cider-diet-path "17888")))
;;     (accept-process-output cider-diet-process)
;;     (cider-connect "localhost" 17888)))
