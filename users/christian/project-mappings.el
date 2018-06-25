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

;; Gitorious

(defun custom-persp/gitorious ()
  (interactive)
  (custom-persp "Gts"
                (find-file "~/projects/gitorious/gitorious/todo.org")))

(define-key persp-mode-map (kbd "C-x p g") 'custom-persp/gitorious)

(project-specifics "gitorious/gitorious"
  (ffip-local-excludes "db/migrate")
  (setq tags-file-name "/home/christian/projects/gitorious/gitorious/TAGS"))

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

;; Småjobber
(require 'smajobber-mode)

(defun custom-persp/smajobber ()
  (interactive)
  (custom-persp "smajobber"
                (find-file "~/projects/smajobber/")))

(define-key persp-mode-map (kbd "C-x p s") 'custom-persp/smajobber)

(require 'smajobber-mode)

(project-specifics "smajobber"
  (ffip-local-patterns "*.js" "*.jsp" "*.css" "*.org" "*.vm" "*.xml" "*.properties")
  (ffip-local-excludes "node_modules")
  (smajobber-mode))

;; SPiD

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/spid/tech-docs" (buffer-file-name))
              (set (make-local-variable 'js2-basic-offset) 2))))

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/spid/reckoning" (buffer-file-name))
              (require 'single-quotes-mode)
              (single-quotes-mode 1)
              (set (make-local-variable 'js2-basic-offset) 4))))

(project-specifics "spid/reckoning"
  (ffip-local-patterns "*.scss" "*.html" "*.js")
  (set (make-local-variable 'css-indent-offset) 2))

;; My tomatoes

(project-specifics "mytomatoes"
  (ffip-local-patterns "*.css" "*.html" "*.js" "*.cljs?")
  (set (make-local-variable 'css-indent-offset) 2))

;; Eve

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/eve" (buffer-file-name))
              (set (make-local-variable 'js2-basic-offset) 2))))

;; Bidrag

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/bidrag" (buffer-file-name))
              (set (make-local-variable 'js2-basic-offset) 2))))

;; Radioarkivet

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/radio" (buffer-file-name))
              (set (make-local-variable 'js2-basic-offset) 2))))

;; Functional js video

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/functional-js-video" (buffer-file-name))
              (set (make-local-variable 'js2-basic-offset) 2))))

;;

(add-hook 'js2-mode-hook
          (lambda ()
            (when (string-match-p "projects/react-sweeper" (buffer-file-name))
              (set (make-local-variable 'js2-basic-offset) 2))))
