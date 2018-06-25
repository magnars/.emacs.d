;; Seed the random-number generator
(random t)

;; Keep region when undoing in region
(defadvice undo-tree-undo (around keep-region activate)
  (if (use-region-p)
      (let ((m (set-marker (make-marker) (mark)))
            (p (set-marker (make-marker) (point))))
        ad-do-it
        (goto-char p)
        (set-mark m)
        (set-marker p nil)
        (set-marker m nil))
    ad-do-it))

;; Whitespace-style
(setq whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 100)

;; Add Urban Dictionary to webjump (C-x g)
(eval-after-load "webjump"
  '(add-to-list 'webjump-sites '("Urban Dictionary" .
                             [simple-query
                              "www.urbandictionary.com"
                              "http://www.urbandictionary.com/define.php?term="
                              ""])))

;; Fix whitespace on save, but only if the file was clean
(global-whitespace-cleanup-mode)

;; Use normal tabs in makefiles
(add-hook 'makefile-mode-hook 'indent-tabs-mode)

;; More neat bindings for C-x 8
(global-set-key (kbd "C-x 8 t m") (λ (insert "™")))
(global-set-key (kbd "C-x 8 ( c )") (λ (insert "©")))
(global-set-key (kbd "C-x 8 - >") (λ (insert "→")))
(global-set-key (kbd "C-x 8 8") (λ (insert "∞")))
(global-set-key (kbd "C-x 8 ( c )") (λ (insert "©")))
(global-set-key (kbd "C-x 8 v") (λ (insert "✓")))

;; Add JSP expansions to html-mode
(eval-after-load "sgml-mode" '(require 'jsp-expansions))

;; A bit of misc cargo culting in misc.el
(setq xterm-mouse-mode t)

;; Unfill paragraph
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

(global-set-key (kbd "M-U") 'unfill-paragraph)

(provide 'my-misc)
