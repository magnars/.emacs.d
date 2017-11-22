(use-package org :ensure t)
(use-package htmlize :ensure t)

;; Make windmove work in org-mode:
(add-hook 'org-shiftup-hook 'windmove-up)
(add-hook 'org-shiftleft-hook 'windmove-left)
(add-hook 'org-shiftdown-hook 'windmove-down)
(add-hook 'org-shiftright-hook 'windmove-right)

;; (defun myorg-update-parent-cookie ()
;;   (when (equal major-mode 'org-mode)
;;     (save-excursion
;;       (ignore-errors
;;         (org-back-to-heading)
;;         (org-update-parent-todo-statistics)))))

;; (defadvice org-kill-line (after fix-cookies activate)
;;   (myorg-update-parent-cookie))

;; (defadvice kill-whole-line (after fix-cookies activate)
;;   (myorg-update-parent-cookie))

(setq org-startup-indented t)
(setq org-src-preserve-indentation t)
(setq org-replace-disputed-keys t)
(setq org-directory "~/Dropbox/org")
;; (setq org-default-notes-file (concat org-directory "/notes.org"))
;; (define-key global-map (kbd "M-<f6>") 'org-capture)

(setq org-log-done t)

;; (setq org-agenda-files (list "/rp2:~/org/work.org"
;;                              "/rp2:~/org/home.org"
;;                              "/rp2:~/org/mobileorg.org"
;;                              "/rp2:~/org/todo.org"
;;                              ))

(setq org-todo-keywords
      '((sequence "TODO" "PROG" "|" "DONE" "DELEGATED" "CANCELED")))

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-default-notes-file "~/Dropbox/org/note.org")

(defun org-capture-get-major-mode ()
  (with-current-buffer (org-capture-get :original-buffer) major-mode))

(defun major-mode-to-lang (mode)
  (cond ((equal mode 'clojure-mode) "clojure")
        ((equal mode 'cider-repl-mode) "clojure")
        ((equal mode 'org-mode) "org")
        ((equal mode 'python-mode) "python")
        (t "%^{language}")))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline (lambda () (concat org-directory "/task.org")) "Tasks")
         "* TODO %?\n  %i")
        ("j" "Journal" entry (file+olp+datetree (lambda () (concat org-directory "/diary.org")))
         "* %?\nEntered on %U\n  %i")
        ("s" "Code Snippet" entry (file (lambda () (concat org-directory "/snippets.org")))
         "* %U %?\t%^G\n#+BEGIN_SRC %(format \"%s\" (major-mode-to-lang (org-capture-get-major-mode)))\n%i\n#+END_SRC" :empty-lines 1)
        ;; ("j" "Journal" entry (file+datetree "~/Dropbox/org/diary.org")
        ;;  "* Event: %?\n\n  %i\n\n  From: %a" :empty-lines 1)
        ))

;; (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

(setq org-export-with-sub-superscripts nil)

(provide 'setup-org)
