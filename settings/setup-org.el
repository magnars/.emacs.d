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

;; (setq org-directory "~/Dropbox/org")
;; (setq org-default-notes-file (concat org-directory "/notes.org"))
;; (define-key global-map (kbd "M-<f6>") 'org-capture)

(setq org-log-done t)

(setq org-agenda-files (list "/pi@rp2:~/org/work.org"
                             "/pi@rp2:~/org/home.org"
                             "/pi@rp2:~/org/mobileorg.org"
                             "/pi@rp2:~/org/todo.org"
                             ))

(provide 'setup-org)
