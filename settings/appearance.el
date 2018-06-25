(setq font-lock-maximum-decoration t
      color-theme-is-global t
      truncate-partial-width-windows nil)

;; Don't beep. Don't visible-bell (fails on el capitan). Just blink the modeline on errors.

(setq visible-bell nil)
(setq ring-bell-function (lambda ()
                           (invert-face 'mode-line)
                           (run-with-timer 0.05 nil 'invert-face 'mode-line)))

;; Highlight current line
(global-hl-line-mode 1)

;; Set custom theme path
(setq custom-theme-directory (concat user-emacs-directory "themes"))

(dolist
    (path (directory-files custom-theme-directory t "\\w+"))
  (when (file-directory-p path)
    (add-to-list 'custom-theme-load-path path)))

;; Default theme
(defun use-presentation-theme ()
  (interactive)
  (when (boundp 'magnars/presentation-font)
    (set-face-attribute 'default nil :font magnars/presentation-font)))

(defun use-default-theme ()
  (interactive)
  (load-theme 'kingsajz)
  (when (boundp 'magnars/default-font)
    (set-face-attribute 'default nil :font magnars/default-font)))

(defun toggle-presentation-mode ()
  (interactive)
  (if (string= (frame-parameter nil 'font) magnars/default-font)
      (use-presentation-theme)
    (use-default-theme)))

(global-set-key (kbd "C-<f9>") 'toggle-presentation-mode)

(use-default-theme)

;; Preeeetty font in Emacs 24/Ubuntu
(if is-mac nil
  (set-default-font "DejaVu Sans Mono")
  (set-face-attribute 'default nil :height 105))

(set-default-font "Source Code Pro for Powerline Light")

;; Don't defer screen updates when performing operations
(setq redisplay-dont-pause t)

;; org-mode colors
(setq org-todo-keyword-faces
      '(
        ("INPR" . (:foreground "yellow" :weight bold))
        ("DONE" . (:foreground "green" :weight bold))
        ("IMPEDED" . (:foreground "red" :weight bold))
        ))

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (blink-cursor-mode -1))

;; Make zooming affect frame instead of buffers
(load "~/.emacs.d/site-lisp/zoom-frm")
(require 'zoom-frm)

;; Sweet window-splits
(defadvice split-window-right (after balance activate) (balance-windows))
(defadvice delete-window (after balance activate) (balance-windows))

;; Unclutter the modeline
(require 'diminish)
(eval-after-load "yasnippet" '(diminish 'yas-minor-mode))
(eval-after-load "eldoc" '(diminish 'eldoc-mode))
(eval-after-load "paredit" '(diminish 'paredit-mode))
(eval-after-load "tagedit" '(diminish 'tagedit-mode))
(eval-after-load "elisp-slime-nav" '(diminish 'elisp-slime-nav-mode))
(eval-after-load "skewer-mode" '(diminish 'skewer-mode))
(eval-after-load "skewer-css" '(diminish 'skewer-css-mode))
(eval-after-load "skewer-html" '(diminish 'skewer-html-mode))
(eval-after-load "smartparens" '(diminish 'smartparens-mode))
(eval-after-load "guide-key" '(diminish 'guide-key-mode))
(eval-after-load "whitespace-cleanup-mode" '(diminish 'whitespace-cleanup-mode))

(defmacro rename-modeline (package-name mode new-name)
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))

(rename-modeline "js2-mode" js2-mode "JS2")
(rename-modeline "clojure-mode" clojure-mode "Clj")

(provide 'appearance)
