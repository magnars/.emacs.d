(use-package saveplace
  :ensure t
  :config 
  (setq-default save-place t)
  (setq save-place-file (expand-file-name ".places" user-emacs-directory))
  )

(use-package dabbrev
  :defer t
  :init (setf abbrev-file-name (locate-user-emacs-file "local/abbrev_defs"))
  :config (setf dabbrev-case-fold-search nil))

(use-package impatient-mode
  :defer t
  :ensure t
  :config
  (defun imp-markdown-filter (in)
    (let ((out (current-buffer)))
      (with-current-buffer in
        (markdown out))))
  (push (cons 'markdown-mode #'imp-markdown-filter)
        imp-default-user-filters))

;; (use-package lua-mode
;;   :defer t
;;   :ensure t
;;   :config
;;   (require 'lua-extras)
;;   (setf lua-default-application "luajit"
;;         lua-always-show nil)
;;   (define-key lua-mode-map (kbd "C-x C-e") #'lua-send-current-line)
;;   (define-key lua-mode-map (kbd "C-M-x")   #'lua-send-defun)
;;   (define-key lua-mode-map (kbd "C-c C-k") #'skeeto/lua-send-buffer)
;;   (define-key lua-mode-map (kbd "C-c C-z") #'skeeto/lua-toggle-process-buffer)
;;   (add-function :after (symbol-function 'lua-start-process)
;;                 #'skeeto/lua-add-filter))

;; (use-package memoize
;;   :defer t
;;   :ensure t)

(use-package dired
  :defer t
  :config
  (progn
    (add-hook 'dired-mode-hook #'toggle-truncate-lines)
    (setf dired-listing-switches "-alhG"
          dired-guess-shell-alist-user
          '(("\\.pdf\\'" "evince")
            ("\\(\\.ods\\|\\.xlsx?\\|\\.docx?\\|\\.csv\\)\\'" "libreoffice")
            ("\\(\\.png\\|\\.jpe?g\\)\\'" "qiv")
            ("\\.gif\\'" "animate")))))

(use-package message
  :defer t
  :config (define-key message-mode-map (kbd "C-c C-s") nil)) ; super annoying

;; (use-package notmuch
;;   :ensure t
;;   :bind ("C-x m" . notmuch)
;;   :config
;;   (progn
;;     (require 'email-setup)
;;     (require 'notmuch-address)
;;     (define-key notmuch-common-keymap "q" (expose #'kill-buffer))
;;     (setf notmuch-command "notmuch-remote"
;;           message-send-mail-function 'smtpmail-send-it
;;           message-kill-buffer-on-exit t
;;           smtpmail-smtp-server "localhost"
;;           smtpmail-smtp-service 2525
;;           notmuch-address-command "addrlookup-remote"
;;           notmuch-fcc-dirs nil
;;           notmuch-search-oldest-first nil
;;           notmuch-archive-tags '("-inbox" "-unread" "+archive")
;;           hashcash-path (executable-find "hashcash"))
;;     (custom-set-faces
;;      '(notmuch-search-subject ((t :foreground "#afa")))
;;      '(notmuch-search-date    ((t :foreground "#aaf")))
;;      '(notmuch-search-count   ((t :foreground "#777"))))
;;     (setq notmuch-hello-sections
;;           '(notmuch-hello-insert-header
;;             notmuch-hello-insert-saved-searches
;;             notmuch-hello-insert-search))))

;; (use-package elfeed
;;   :ensure t
;;   :bind ("C-x w" . elfeed)
;;   :init (setf url-queue-timeout 30)
;;   :config
;;   (require 'feed-setup)
;;   (setf bookmark-default-file (locate-user-emacs-file "local/bookmarks")))

(use-package lisp-mode
  :defer t
  :config
  (progn
    (defun ert-all ()
      (interactive)
      (ert t))
    (defun ielm-repl ()
      (interactive)
      (pop-to-buffer (get-buffer-create "*ielm*"))
      (ielm))
    (define-key emacs-lisp-mode-map (kbd "C-x r")   #'ert-all)
    (define-key emacs-lisp-mode-map (kbd "C-c C-z") #'ielm-repl)
    (define-key emacs-lisp-mode-map (kbd "C-c C-k") #'eval-buffer*)
    (defalias 'lisp-interaction-mode 'emacs-lisp-mode)
    (font-lock-add-keywords
     'emacs-lisp-mode
     `((,(concat "(\\(\\(?:\\(?:\\sw\\|\\s_\\)+-\\)?"
                 "def\\(?:\\sw\\|\\s_\\)*\\)\\_>"
                 "\\s-*'?" "\\(\\(?:\\sw\\|\\s_\\)+\\)?")
        (1 'font-lock-keyword-face)
        (2 'font-lock-function-name-face nil t)))
     :low-priority)))

(use-package time
  :config
  (progn
    (setf display-time-default-load-average nil
          display-time-use-mail-icon t
          display-time-24hr-format t)
    (display-time-mode t)))

(use-package comint
  :defer t
  :config
  (progn
    (define-key comint-mode-map (kbd "<down>") #'comint-next-input)
    (define-key comint-mode-map (kbd "<up>") #'comint-previous-input)
    (define-key comint-mode-map (kbd "C-n") #'comint-next-input)
    (define-key comint-mode-map (kbd "C-p") #'comint-previous-input)
    (define-key comint-mode-map (kbd "C-r") #'comint-history-isearch-backward)
    (setf comint-prompt-read-only t
          comint-history-isearch t)))

(use-package tramp
  :defer t
  :config
  (setf tramp-persistency-file-name
        (concat temporary-file-directory "tramp-" (user-login-name))))

(use-package whitespace-cleanup-mode
  :ensure t
  :init
  (progn
    (setq-default indent-tabs-mode nil)
    (global-whitespace-cleanup-mode)))

(use-package diff-mode
  :defer t
  :config (add-hook 'diff-mode-hook #'read-only-mode))

;; (use-package simple
;;   :defer t
;;   :config
;;   (progn
;;     ;; disable so I don't use it by accident
;;     (define-key visual-line-mode-map (kbd "M-q") (expose (lambda ())))
;;     (add-hook 'tabulated-list-mode-hook #'hl-line-mode)))

(use-package uniquify
  :config
  (setf uniquify-buffer-name-style 'post-forward-angle-brackets))

(use-package winner
  :config
  (progn
    (winner-mode 1)
    (windmove-default-keybindings)))

(use-package calc
  :defer t
  :config (setf calc-display-trail nil))

(use-package eshell
  :bind ([f1] . eshell-as)
  :init
  (setf eshell-directory-name (locate-user-emacs-file "local/eshell"))
  :config
  (add-hook 'eshell-mode-hook ; Bad, eshell, bad!
            (lambda ()
              (define-key eshell-mode-map (kbd "<f1>") #'quit-window))))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :init (setf magit-last-seen-setup-instructions "2.1.0")
  :config
  (setf vc-display-status nil
        magit-push-always-verify nil)
  (remove-hook 'git-commit-finish-query-functions
               'git-commit-check-style-conventions))

(use-package gitconfig-mode
  :ensure t
  :defer t
  :config (add-hook 'gitconfig-mode-hook
                    (lambda ()
                      (setf indent-tabs-mode nil
                            tab-width 4))))

;; (use-package markdown-mode
;;   :ensure t
;;   :mode ("\\.md$" "\\.markdown$" "vimperator-.+\\.tmp$")
;;   :config
;;   (add-hook 'markdown-mode-hook
;;             (lambda ()
;;               (remove-hook 'fill-nobreak-predicate
;;                            'markdown-inside-link-text-p t)))
;;   (setf sentence-end-double-space nil
;;         markdown-command
;;         "pandoc -f markdown -t html5 -s --self-contained --smart"))

(use-package octave
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))
  (setf octave-block-offset 4))

;; (use-package simple-httpd
;;   :ensure t
;;   :defer t
;;   :functions httpd-send-header
;;   :config
;;   (progn
;;     (defservlet uptime "text/plain" ()
;;       (princ (emacs-uptime)))
;;     (defun httpd-here ()
;;       (interactive)
;;       (setf httpd-root default-directory))
;;     (defadvice httpd-start (after httpd-query-on-exit-flag activate)
;;       (let ((httpd-process (get-process "httpd")))
;;         (when httpd-process
;;           (set-process-query-on-exit-flag httpd-process nil))))))

;; (use-package js2-mode
;;   :ensure t
;;   :mode "\\.js$"
;;   :config
;;   (progn
;;     (add-hook 'js2-mode-hook (lambda () (setq mode-name "js2")))
;;     (setf js2-skip-preprocessor-directives t)
;;     (setq-default js2-additional-externs
;;                   '("$" "unsafeWindow" "localStorage" "jQuery"
;;                     "setTimeout" "setInterval" "location" "skewer"
;;                     "console" "phantom"))))

;; (use-package skewer-mode
;;   :ensure t
;;   :defer t
;;   :init (skewer-setup)
;;   :config
;;   (progn
;;     (setf skewer-bower-cache-dir (locate-user-emacs-file "local/skewer"))
;;     (define-key skewer-mode-map (kbd "C-c $")
;;       (expose #'skewer-bower-load "jquery" "1.9.1"))))

;; (use-package skewer-repl
;;   :defer t
;;   :config (define-key skewer-repl-mode-map (kbd "C-c C-z") #'quit-window))

;; (use-package clojure-mode
;;   :ensure t
;;   :mode "\\.cljs$")

;; (use-package ps-print
;;   :defer t
;;   :config (setf ps-print-header nil))

;; (use-package glsl-mode
;;   :ensure t
;;   :mode ("\\.fs$" "\\.vs$"))

;; (use-package erc
;;   :defer t
;;   :config
;;   (when (eq 0 (string-match "wello" (user-login-name)))
;;     (setf erc-nick "skeeto")))

(use-package cc-mode
  :defer t
  :init
  (defun skeeto/c-hook ()
    (setf c-basic-offset 4)
    (c-set-offset 'case-label '+)
    (c-set-offset 'access-label '/)
    (c-set-offset 'label '/))
  :config
  (progn
    (define-key java-mode-map (kbd "C-x I") 'add-java-import)
    (add-hook 'c-mode-hook #'skeeto/c-hook)
    (add-hook 'c++-mode-hook #'skeeto/c-hook)
    (add-to-list 'c-default-style '(c-mode . "k&r"))
    (add-to-list 'c-default-style '(c++-mode . "k&r"))))

(use-package nasm-mode
  :ensure t
  :defer t
  :mode ("\\.nasm$" "\\.asm$" "\\.s$")
  :config
  (add-hook 'nasm-mode-hook (lambda () (setf indent-tabs-mode t))))

(use-package asm-mode
  :config
  (add-hook 'asm-mode-hook (lambda () (setf indent-tabs-mode t
                                            tab-always-indent t))))

(use-package x86-lookup
  :ensure t
  :defer t
  :bind ("C-h x" . x86-lookup)
  :functions x86-lookup-browse-pdf-evince
  :config
  (let ((pdf-regexp "^64-ia-32-.*-instruction-set-.*\\.pdf$")
        (pdf-dir "~/doc/"))
    (setf x86-lookup-browse-pdf-function #'x86-lookup-browse-pdf-evince
          x86-lookup-pdf (ignore-errors
                           (car (directory-files pdf-dir t pdf-regexp))))))

(use-package ielm
  :defer t
  :config
  (progn
    (define-key ielm-map (kbd "C-c C-z") #'quit-window)
    (defadvice ielm-eval-input (after ielm-paredit activate)
      "Begin each ielm prompt with a paredit pair."
      (paredit-open-round))))

(use-package paredit
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
    (add-hook 'lisp-mode-hook #'paredit-mode)
    (add-hook 'scheme-mode-hook #'paredit-mode)
    (add-hook 'ielm-mode-hook #'paredit-mode)
    (add-hook 'clojure-mode-hook #'paredit-mode))
  :config (define-key paredit-mode-map (kbd "C-j") #'join-line))

(use-package paren
  :config (show-paren-mode))

(use-package rainbow-delimiters
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
    (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
    (add-hook 'ielm-mode-hook #'rainbow-delimiters-mode))
  :config
  (progn
    (set-face-foreground 'rainbow-delimiters-depth-1-face "snow4")
    (setf rainbow-delimiters-max-face-count 1)
    (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                        :foreground 'unspecified
                        :inherit 'error)
    (set-face-foreground 'rainbow-delimiters-depth-1-face "snow4")))

(use-package counsel
  :ensure t)

(use-package flx
  :ensure t)

(use-package swiper
  :ensure t
  :defer nil
  :init (ivy-mode 1)
  :config
  (setf ivy-wrap t
        ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (define-key ivy-minibuffer-map (kbd "C-s") #'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "C-r") #'ivy-previous-line)
  (define-key ivy-minibuffer-map (kbd "C-l")
    (lambda ()
      "Be like like Helm."
      (interactive)
      (unless (eql (char-before) ?/)
        (ivy-backward-kill-word))
      (ivy-backward-delete-char))))

(use-package ggtags
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'c-mode-common-hook
              (lambda ()
                (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                  (ggtags-mode 1))))))

;; (use-package color-theme-sanityinc-tomorrow
;;   :ensure t
;;   :init
;;   (progn
;;     (load-theme 'sanityinc-tomorrow-night :no-confirm)
;;     (setf frame-background-mode 'dark)
;;     (global-hl-line-mode 1)
;;     (custom-set-faces
;;      '(cursor               ((t :background "#eebb28")))
;;      '(diff-added           ((t :foreground "green" :underline nil)))
;;      '(diff-removed         ((t :foreground "red" :underline nil)))
;;      '(highlight            ((t :background "black" :underline nil)))
;;      '(magit-item-highlight ((t :background "black")))
;;      '(hl-line              ((t :background "gray10"))))))

;; (use-package websocket
;;   :ensure t
;;   :defer t)

;; (use-package javadoc-lookup
;;   :ensure t
;;   :defer t
;;   :bind ("C-h j" . javadoc-lookup)
;;   :config
;;   (ignore-errors
;;     (setf javadoc-lookup-cache-dir (locate-user-emacs-file "local/javadoc"))))

(use-package gnuplot-mode
  :ensure t
  :defer t)

(use-package browse-url
  :defer t
  :init (setf url-cache-directory (locate-user-emacs-file "local/url"))
  :config
  (when (executable-find "firefox")
    (setf browse-url-browser-function #'browse-url-firefox
          browse-url-generic-program "xombrero"
          browse-url-generic-args '("-n"))))

(use-package multiple-cursors
  :ensure t
  :bind (("C-c e" . mc/edit-lines)
         ("C-<" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this))
  :init (setf mc/list-file (locate-user-emacs-file "local/mc-lists.el")))

(use-package graphviz-dot-mode
  :ensure t
  :defer t
  :config
  (setf graphviz-dot-indent-width 2
        graphviz-dot-auto-indent-on-semi nil))

(use-package uuid-simple
  :demand t
  :bind ("C-x !" . uuid-insert)
  :config (random (make-uuid)))

(use-package compile-bind
  :demand t
  :bind (("C-h g" . compile-bind-set-command)
         ("C-h G" . compile-bind-set-root-file))
  :config
  (progn
    (setf compilation-always-kill t
          compilation-scroll-output 'first-error
          compile-bind-command (format "make -kj%d" (numcores)))
    (compile-bind* (current-global-map)
                   ("C-x c" ""
                    "C-x r" 'run
                    "C-x t" 'test
                    "C-x C" 'clean))))

(use-package batch-mode
  :defer t)

(use-package yaml-mode
  :ensure t
  :defer t
  :config
  (add-hook 'yaml-mode-hook
            (lambda ()
              (setq-local paragraph-separate ".*>-$\\|[   ]*$")
              (setq-local paragraph-start paragraph-separate))))

;; (use-package jekyll
;;   :demand t
;;   :functions httpd-send-header
;;   :config
;;   (progn
;;     (setf jekyll-home "~/src/skeeto.github.com/")
;;     (when (file-exists-p jekyll-home)
;;       (require 'simple-httpd)
;;       (setf httpd-root (concat jekyll-home "_site"))
;;       (ignore-errors
;;         (httpd-start)
;;         (jekyll/start))
;;       (defservlet robots.txt text/plain ()
;;         (insert "User-agent: *\nDisallow: /\n")))))

(use-package help-mode
  :defer t
  :config
  (define-key help-mode-map (kbd "f") #'push-first-button))

(use-package vimrc-mode
  :ensure t
  :defer t)

(use-package json-mode
  :ensure t
  :defer t
  :config
  (progn
    (setf json-reformat:pretty-string? t
          json-reformat:indent-width 2)
    (define-key json-mode-map (kbd "M-q")
      (lambda ()
        (interactive)
        (if (region-active-p)
            (call-interactively #'json-reformat-region)
          (json-reformat-region (point-min) (point-max)))))))

(use-package gamegrid
  :defer t
  :init
  (setf gamegrid-user-score-file-directory (locate-user-emacs-file "games")))

(use-package apt-sources-mode
  :defer t
  :mode "sources.list$")

(use-package pov-mode
  :defer t
  :ensure t)

(use-package pov-mode
  :defer t
  :init
  (autoload 'irfc-mode "irfc" nil t)
  (autoload 'irfc-visit "irfc" nil t)
  (setf irfc-directory (locate-user-emacs-file "local/rfc")
        irfc-assoc-mode t)
  (mkdir irfc-directory t))

;; (use-package ospl-mode
;;   (autoload 'ospl-mode "ospl-mode"))

(use-package visual-regexp
  :ensure t
  :config
  (define-key global-map (kbd "M-&") 'vr/query-replace)
  (define-key global-map (kbd "M-/") 'vr/replace))

(use-package fill-column-indicator
  :ensure t
  :config
  (setq fci-rule-color "#111122"))

(use-package flycheck
  :ensure t
  :config
  (require 'setup-flycheck))

(use-package yasnippet
  :ensure t
  :config
  (require 'setup-yasnippet))

(use-package flycheck-pos-tip :ensure t)
(use-package flx :ensure t)
(use-package f :ensure t)
(use-package flx-ido :ensure t)
(use-package dired-details :ensure t)

(use-package smartparens :ensure t)
(use-package ido-vertical-mode :ensure t)
(use-package ido-at-point :ensure t)

(use-package guide-key 
  :ensure t  
  :config
  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-x v" "C-x 8" "C-x +" "C-h"))
  (guide-key-mode 1)
  (setq guide-key/recursive-key-sequence-flag t)
  (setq guide-key/popup-window-position 'bottom))

(use-package highlight-escape-sequences
  :ensure t
  :config
  (require 'highlight-escape-sequences)
  (hes-mode)
  (put 'font-lock-regexp-grouping-backslash 'face-alias 'font-lock-builtin-face))

;; (use-package smex
;;   :ensure t
;;   :config
;;   (smex-initialize))

;; (use-package mustard-theme
;;   :ensure t)
;; (use-package suscolors-theme
;;   :ensure t)
(use-package idea-darkula-theme
  :ensure t)

;; (eval-after-load 'ido '(require 'setup-ido))
;; (eval-after-load 'org '(require 'setup-org))
;; (eval-after-load 'dired '(require 'setup-dired))
;; (eval-after-load 'magit '(require 'setup-magit))
;; (eval-after-load 'grep '(require 'setup-rgrep))
;; (eval-after-load 'shell '(require 'setup-shell))
;; (require 'setup-hippie)
;; 
;; (require 'setup-perspective)
;; (require 'setup-ffip)
;; (require 'setup-html-mode)
;; (require 'setup-paredit)

;; (require 'prodigy)
;; (global-set-key (kbd "C-x M-m") 'prodigy)

;; Default setup of smartparens
;; (require 'smartparens-config)
;; (setq sp-autoescape-string-quote nil)
;; (--each '(css-mode-hook
;;           restclient-mode-hook
;;           js-mode-hook
;;           java-mode
;;           ruby-mode
;;           markdown-mode
;;           groovy-mode
;;           scala-mode)
;;   (add-hook it 'turn-on-smartparens-mode))


;; Language specific setup files
;; (eval-after-load 'js2-mode '(require 'setup-js2-mode))
;; (eval-after-load 'ruby-mode '(require 'setup-ruby-mode))
;; (eval-after-load 'clojure-mode '(require 'setup-clojure-mode))
;; (eval-after-load 'markdown-mode '(require 'setup-markdown-mode))

;; Load stuff on demand
;; (autoload 'skewer-start "setup-skewer" nil t)
;; (autoload 'skewer-demo "setup-skewer" nil t)
(autoload 'auto-complete-mode "auto-complete" nil t)

;; Map files to modes
;; (require 'mode-mappings)

;; Functions (load all files in defuns-dir)
;; (setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
;; (dolist (file (directory-files defuns-dir t "\\w+"))
;;   (when (file-regular-p file)
;;     (load file)))

;; (require 'expand-region)
;; (require 'multiple-cursors)
;; (require 'delsel)
;; (require 'jump-char)
;; (require 'eproject)
;; (require 'wgrep)
;; (require 'smart-forward)
;; (require 'change-inner)
;; (require 'multifiles)

;; Browse kill ring
;; (require 'browse-kill-ring)
;; (setq browse-kill-ring-quit-action 'save-and-restore)

(use-package framemove
  :ensure t
  :config
  (windmove-default-keybindings)
  (setq framemove-hook-into-windmove t))

(use-package cpputils-cmake
  :ensure t
  :config
  (add-hook 'c-mode-common-hook
            (lambda ()
              (if (derived-mode-p 'c-mode 'c++-mode)
                  (cppcm-reload-all))))
  ;; OPTIONAL, somebody reported that they can use this package with Fortran
  (add-hook 'c90-mode-hook (lambda () (cppcm-reload-all)))
  ;; OPTIONAL, avoid typing full path when starting gdb
  (global-set-key (kbd "C-c C-g")
                  '(lambda ()(interactive) 
                     (gud-gdb (concat "gdb --fullname " (cppcm-get-exe-path-current-buffer)))))
  ;; OPTIONAL, some users need specify extra flags forwarded to compiler
  ;; (setq cppcm-extra-preprocss-flags-from-user '("-I/usr/src/linux/include" "-DNDEBUG"))
)


;; (require 'sticky-windows)

;; Emacs server
(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

(provide 'default-packages)
