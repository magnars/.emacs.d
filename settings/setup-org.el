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
      '((sequence "TODO" "|" "DONE" "DELEGATED" "CANCELED")))

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-default-notes-file "~/Dropbox/org/note.org")

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/org/todo.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/Dropbox/org/diary.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ;; ("j" "Journal" entry (file+datetree "~/Dropbox/org/diary.org")
        ;;  "* Event: %?\n\n  %i\n\n  From: %a" :empty-lines 1)
        ))

(provide 'setup-org)
