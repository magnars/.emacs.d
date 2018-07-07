;;; setup-straight.el --- bootstrapping straight.el

;;; Commentary:

;; Set up straight.el, a package manager

;;; Code:

;; from https://github.com/raxod502/straight.el#getting-started
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 4))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;; to use use-package style
(setq straight-use-package-by-default t)

(provide 'setup-straight)
;;; setup-straight.el ends here
