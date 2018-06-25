(setq markdown-imenu-generic-expression
      '(("title"  "^\\(.*\\)[\n]=+$" 1)
        ("h2-"    "^\\(.*\\)[\n]-+$" 1)
        ("h1"   "^# \\(.*\\)$" 1)
        ("h2"   "^## \\(.*\\)$" 1)
        ("h3"   "^### \\(.*\\)$" 1)
        ("h4"   "^#### \\(.*\\)$" 1)
        ("h5"   "^##### \\(.*\\)$" 1)
        ("h6"   "^###### \\(.*\\)$" 1)
        ("fn"   "^\\[\\^\\(.*\\)\\]" 1)
        ))

(add-hook 'markdown-mode-hook
          (lambda ()
            (setq imenu-generic-expression markdown-imenu-generic-expression)))

(defun md-slide-insert-diamond ()
  (interactive)
  (end-of-line)
  (insert "<1>")
  (backward-char))

(define-key markdown-mode-map (kbd "C-c C-d") 'md-slide-insert-diamond)

(provide 'setup-markdown-mode)
