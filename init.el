;;; init.el --- bootstrapping configurations

;;; Commentary:
;; Init for Emacs

;;; Code:

;; Set path to dependencies
(defvar site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory) "Directory for manually maintained packages.")
(defvar settings-dir (expand-file-name "settings" user-emacs-directory) "Directory for package specific settings.")

;; Set up load path
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-lisp-dir)

;; Set up the package manager, straight.el
(require 'setup-straight)

;; Keep Emacs custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-readable-p custom-file) (load custom-file))

;; User specific settings
(setq user-settings-dir
      (concat user-emacs-directory "users/" user-login-name "@" system-name))
(add-to-list 'load-path user-settings-dir)

;; Add external projects to load path
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load default setting
(load "global")

;; Load packages for any systems
(require 'default-packages)

;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; Setup key bindings
;; (require 'key-bindings)

;; For mac
(when is-mac (require 'mac))

;; Conclude init by setting up specifics for the current user
(when (file-exists-p user-settings-dir)
  (mapc 'load (directory-files user-settings-dir nil "^[^#].*el$")))

(provide 'init)
;;; init.el ends here
