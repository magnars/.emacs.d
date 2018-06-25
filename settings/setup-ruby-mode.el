;; avoid ridiculous ruby indentation
(setq ruby-deep-indent-paren nil)

(defun ruby--jump-to-test ()
  (find-file
   (replace-regexp-in-string
    "/lib/" "/test/"
    (replace-regexp-in-string
     "/\\([^/]+\\).rb$" "/test_\\1.rb"
     (buffer-file-name)))))

(defun ruby--jump-to-lib ()
  (find-file
   (replace-regexp-in-string
    "/test/" "/lib/"
    (replace-regexp-in-string
     "/test_\\([^/]+\\).rb$" "/\\1.rb"
     (buffer-file-name)))))

(defun ruby-jump-to-other ()
  (interactive)
  (if (string-match-p "/test/" (buffer-file-name))
      (ruby--jump-to-lib)
    (ruby--jump-to-test)))

;; Nicely indented hashes/method arguments
(setq ruby-deep-indent-paren nil)

(define-key ruby-mode-map (kbd "C-c t") 'ruby-jump-to-other)

(provide 'setup-ruby-mode)
