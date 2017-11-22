;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Emacs Environment ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; save palces in files between sessions
(use-package saveplace
  :ensure t
  :config
  (setq-default save-place t)           ; FIXME : (save-place-mode 1) for 25.1 or latter
  (setq save-place-file (expand-file-name ".places" user-emacs-directory)) )

;; code completion
(use-package company
  :ensure t
  :config
  (global-company-mode)
  (global-set-key (kbd "TAB") #'company-indent-or-complete-common))

;; dynamic abbrev expansion, similar to auto-completion
;; (use-package dabbrev
;;   :defer t
;;   :init (setf abbrev-file-name (locate-user-emacs-file "local/abbrev_defs"))
;;   :config (setf dabbrev-case-fold-search nil))

;; (autoload 'auto-complete-mode "auto-complete" nil t)

;; frame zoom in/out
;; (use-package zoom-frm :ensure t)

;; (use-package dired
;;   :defer t
;;   :config
;;   (progn
;;     (add-hook 'dired-mode-hook #'toggle-truncate-lines)
;;     (setf dired-listing-switches "-alhG"
;;           dired-guess-shell-alist-user
;;           '(("\\.pdf\\'" "evince")
;;             ("\\(\\.ods\\|\\.xlsx?\\|\\.docx?\\|\\.csv\\)\\'" "libreoffice")
;;             ("\\(\\.png\\|\\.jpe?g\\)\\'" "qiv")
;;             ("\\.gif\\'" "animate")))))

;; This option to reduce initial connection time by saving connection history in previous sessions
;; (use-package tramp
;;   :defer t
;;   :config
;;   (setf tramp-persistency-file-name
;;         (concat temporary-file-directory "tramp-" (user-login-name))))

(use-package framemove
  :ensure t
  :config
  (windmove-default-keybindings)
  (setq framemove-hook-into-windmove t))

;; FIXME : interesting package. Try this : Comint mode is a package that defines a general command-interpreter-in-a-buffer.
;; (use-package comint
;;   :defer t
;;   :config
;;   (progn
;;     (define-key comint-mode-map (kbd "<down>") #'comint-next-input)
;;     (define-key comint-mode-map (kbd "<up>") #'comint-previous-input)
;;     (define-key comint-mode-map (kbd "C-n") #'comint-next-input)
;;     (define-key comint-mode-map (kbd "C-p") #'comint-previous-input)
;;     (define-key comint-mode-map (kbd "C-r") #'comint-history-isearch-backward)
;;     (setf comint-prompt-read-only t
;;           comint-history-isearch t)))

;; give a unique for buffers
(use-package uniquify
  :config
  (setf uniquify-buffer-name-style 'post-forward-angle-brackets))

;; navigate frame configurations
(use-package winner
  :config
  (progn
    (winner-mode 1)
    (windmove-default-keybindings)))

;; shows the regexp result visually
(use-package visual-regexp
  :ensure t
  :config
  (define-key global-map (kbd "C-c q") 'vr/query-replace)
  (define-key global-map (kbd "C-c r") 'vr/replace))

(use-package guide-key
  :ensure t
  :config
  (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-x v" "C-x 8" "C-x +" "C-h" "C-c"))
  (guide-key-mode 1)
  (setq guide-key/recursive-key-sequence-flag t)
  (setq guide-key/popup-window-position 'bottom))

;; highlight escape characters
(use-package highlight-escape-sequences
  :ensure t
  :config
  (put 'font-lock-regexp-grouping-backslash 'face-alias 'font-lock-builtin-face)
  (put 'hes-escape-backslash-face 'face-alias 'font-lock-builtin-face)
  (put 'hes-escape-sequence-face 'face-alias 'font-lock-builtin-face))

(use-package ivy
  :ensure t
  :init (ivy-mode 1)
  :bind (("C-c C-r" . ivy-resume)))

(use-package counsel
 :ensure t)

;; smex should be later than ivy
(use-package smex
  :ensure t
  :config
  (smex-initialize)
  :bind (("M-x" . smex) ("C-c C-c M-x" . execute-extended-command)))

(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-strict-mode t)
  (sp-use-paredit-bindings))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy)
  ;(setq projectile-mode-line '(:eval (format " Projectile[%s]" (projectile-project-name))))
  (counsel-projectile-on))

(use-package counsel-projectile :ensure t)

(use-package magit
  :ensure t
  :config
  (projectile-global-mode)
  (setq magit-completing-read-function 'ivy-completing-read))

(use-package git-link
  :ensure t
  :config (setq git-link-open-in-browser t)
  :bind (("C-M-;" . git-link-tree)
         ("C-M-'" . git-link)))

(require 'setup-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Visual Environment ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package mustard-theme
;;   :ensure t)
;; (use-package suscolors-theme
;;   :ensure t)
(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))
(set-face-attribute 'region nil :background "#555")

;; disable fci to avoid the conflict with htmlize
;; (use-package fill-column-indicator
;;   :ensure t
;;   :config
;;   (setq fci-rule-color "#101010"))

;; (display-time-mode nil)

(use-package smart-mode-line
  :ensure t
  :config
  ;; (setq powerline-arrow-shape 'curve)
  ;; (setq powerline-default-separator-dir '(right . left))
  ;; (setq sml/theme 'powerline)
  ;; (setq sml/mode-width 0)
  ;; (setq sml/name-width 20)
  ;; (rich-minority-mode 1)
  ;; (setf rm-blacklist "")
  ;; (setq sml/theme 'dark)
  ;; (setq sml/theme 'light)
  (setq sml/theme 'respectful)
  (setq sml/active-background-color "black")
  (sml/setup))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Language General ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package whitespace-cleanup-mode
  :ensure t
  :init
  (progn
    (setq-default indent-tabs-mode nil)
    (global-whitespace-cleanup-mode)))

(use-package diff-mode
  :defer t
  :config (add-hook 'diff-mode-hook #'read-only-mode))

(use-package paren
  :config (show-paren-mode))

(use-package ggtags
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'c-mode-common-hook
              (lambda ()
                (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                  (ggtags-mode 1))))))

(use-package yasnippet
  :ensure t
  :config
  (require 'setup-yasnippet))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Specific Language ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package eshell
;;   :bind ([f1] . eshell-as)
;;   :init
;;   (setf eshell-directory-name (locate-user-emacs-file "local/eshell"))
;;   :config
;;   (add-hook 'eshell-mode-hook ; Bad, eshell, bad!
;;             (lambda ()
;;               (define-key eshell-mode-map (kbd "<f1>") #'quit-window))))

(provide 'default-packages)
