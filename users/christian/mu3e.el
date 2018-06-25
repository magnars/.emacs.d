;; (setq mu4e-drafts-folder "/cjohansen/drafts")
;; (setq user-mail-address "christian@cjohansen.no")

;; ;; Shortcuts
;; (setq mu4e-maildir-shortcuts
;;       '(("/cjohansen/inbox" . ?c)
;;         ("/gitorious/inbox" . ?g)
;;         ("/gmail/inbox" . ?G)
;;         ("/shortcut/inbox" . ?s)))

;; ;; sending mail
;; (setq message-send-mail-function 'message-send-mail-with-sendmail
;;       sendmail-program "/usr/local/bin/msmtp"
;;       user-full-name "Christian Johansen")

;; ;; Borrowed from http://ionrock.org/emacs-email-and-mu.html
;; ;; Choose account label to feed msmtp -a option based on From header
;; ;; in Message buffer; This function must be added to
;; ;; message-send-mail-hook for on-the-fly change of From address before
;; ;; sending message since message-send-mail-hook is processed right
;; ;; before sending message.
;; (defun choose-msmtp-account ()
;;   (if (message-mail-p)
;;       (save-excursion
;;         (let*
;;             ((from (or (save-restriction
;;                          (message-narrow-to-headers)
;;                          (message-fetch-field "from")) ""))
;;              (cc (or (save-restriction
;;                        (message-narrow-to-headers)
;;                        (message-fetch-field "cc")) ""))
;;              (to (or (save-restriction
;;                        (message-narrow-to-headers)
;;                        (message-fetch-field "to")) ""))
;;              (account
;;               (cond
;;                ((or (string-match "christian@shortcut.no" from)
;;                     (string-match "christian@shortcut.no" cc)) "shortcut")
;;                ((or (string-match "christian@gitorious.com" from)
;;                     (string-match "christian@gitorious.com" cc)
;;                     (string-match "christian@gitorious.org" from)
;;                     (string-match "christian@gitorious.org" cc)
;;                     (string-match "team@gitorious.com" from)
;;                     (string-match "team@gitorious.com" cc)) "gitorious")
;;                ((string-match "sinonjs@googlegroups.com" to) "gmail")
;;                ((string-match "gitorious@googlegroups.com" to) "gmail")
;;                (t "cjohansen"))))
;;           (setq message-sendmail-extra-arguments (list '"-a" account))))))
;; (setq message-sendmail-envelope-from 'header)
;; (add-hook 'message-send-mail-hook 'choose-msmtp-account)

;; ;; Bookmarks
;; (add-to-list 'mu4e-bookmarks
;;              '("maildir:/gitorious/inbox OR maildir:/shortcut/inbox OR maildir:/gmail/inbox OR maildir:/cjohansen/inbox" "Inbox" ?z))

;; ;; Dynamic sender addresses
;; (add-hook 'mu4e-compose-pre-hook
;;           (defun my-set-from-address ()
;;             "Set the From address based on the To address of the original."
;;             (let ((msg mu4e-compose-parent-message)) ;; msg is shorter...
;;               (if msg
;;                   (setq user-mail-address
;;                         (cond
;;                          ((mu4e-message-contact-field-matches msg :to "@gitorious")
;;                           "christian@gitorious.com")
;;                          ((mu4e-message-contact-field-matches msg :to "christian@shortcut.no")
;;                           "christian@shortcut.no")
;;                          ((mu4e-message-contact-field-matches msg :to "christian@cjohansen.no")
;;                           "christian@cjohansen.no")
;;                          ((mu4e-message-contact-field-matches msg :to "chris@execration.no")
;;                           "christian@cjohansen.no")
;;                          ((mu4e-message-contact-field-matches msg :cc "@gitorious")
;;                           "christian@gitorious.com")
;;                          ((mu4e-message-contact-field-matches msg :cc "christian@shortcut.no")
;;                           "christian@shortcut.no")
;;                          ((mu4e-message-contact-field-matches msg :cc "christian@cjohansen.no")
;;                           "christian@cjohansen.no")
;;                          ((mu4e-message-contact-field-matches msg :cc "chris@execration.no")
;;                           "christian@cjohansen.no")
;;                          ((mu4e-message-contact-field-matches msg :cc "chrisjoha@gmail.com")
;;                           "christian@cjohansen.no")
;;                          ((mu4e-message-contact-field-matches msg :to "sinonjs@googlegroups.com")
;;                           "chrisjoha@gmail.com")
;;                          ((mu4e-message-contact-field-matches msg :to "gitorious@googlegroups.com")
;;                           "chrisjoha@gmail.com")
;;                          (t "christian@cjohansen.no")))))))

;; ;; Smart refile locations
;; (setq mu4e-refile-folder
;;       (lambda (msg)
;;         (cond
;;          ;; messages sent directly to me go to /archive
;;          ;; also `mu4e-user-mail-address-regexp' can be used
;;          ((mu4e-message-contact-field-matches msg :to "gitorious@googlegroups.com")
;;           "/gitorious/mailinglist")
;;          ((mu4e-message-contact-field-matches msg :to "@gitorious")
;;           "/gitorious/archive")
;;          ((mu4e-message-contact-field-matches msg :to "@cjohansen.no")
;;           "/cjohansen/archive")
;;          ((mu4e-message-contact-field-matches msg :to "chrisjoha@gmail.com")
;;           "/gmail/archive")
;;          ((mu4e-message-contact-field-matches msg :to "christian@shortcut.no")
;;           "/shortcut/archive")
;;          ;; everything else goes to /archive
;;          ;; important to have a catch-all at the end!
;;          (t  "/cjohansen/archive"))))

;; (setq mu4e-user-mail-address-list
;;       (list "christian@cjohansen.no" "christian@gitorious.com" "christian@shortcut.no"))
