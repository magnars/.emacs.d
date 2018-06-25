(defmacro project-specifics (name &rest body)
  `(progn
     (add-hook 'find-file-hook
               (lambda ()
                 (when (string-match-p ,name (buffer-file-name))
                   ,@body)))
     (add-hook 'dired-after-readin-hook
               (lambda ()
                 (when (string-match-p ,name (dired-current-directory))
                   ,@body)))))

;; Buster

(defun custom-persp/buster ()
  (interactive)
  (custom-persp "Buster"
                (find-file "~/projects/busterjs/modules")))

(define-key persp-mode-map (kbd "C-x p b") 'custom-persp/buster)

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "buster" (buffer-file-name))
              (setq js2-additional-externs '("buster"))
              (setq buster-default-global "buster")
              (setq buster-add-default-global-to-iife t)
              (setq buster-use-strict t))))

;; Emacs

(defun custom-persp/emacs ()
  (interactive)
  (custom-persp "Emacs"
                (find-file "~/.emacs.d/init.el")))
(define-key persp-mode-map (kbd "C-x p e") 'custom-persp/emacs)

;; Org

(defun custom-persp/org ()
  (interactive)
  (custom-persp "org"
                (find-file "~/Dropbox/org/")))
(define-key persp-mode-map (kbd "C-<f6>") 'custom-persp/org)

;; My tomatoes

(project-specifics "mytomatoes"
  (ffip-local-patterns "*.css" "*.html" "*.js" "*.cljs?")
  (set (make-local-variable 'css-indent-offset) 2))

;; Buster

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/busterjs" (buffer-file-name))
              (set (make-local-variable 'js2-basic-offset) 4))))

;; NRK

(project-specifics "radioarkiv"
  (ffip-local-patterns "*.css" "*.html" "*.js" "*.svg" "*.sh")
  (set (make-local-variable 'css-indent-offset) 2))

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects" (buffer-file-name))
              (require 'single-quotes-mode)
              (single-quotes-mode 1)
              (set (make-local-variable 'js2-basic-offset) 2))))

(add-hook 'css-mode-hook
          (lambda ()
            (when (string-match-p "projects" (buffer-file-name))
              (set (make-local-variable 'css-indent-offset) 2))))
