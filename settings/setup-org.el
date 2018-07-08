;;; setup-org.el --- org-mode settings

;;; Commentary:

;;; Code:

(require 'org-version)

(use-package htmlize)

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

;; see https://github.com/hojinyoo/orgcss
(setq org-html-htmlize-output-type 'css)
(setq org-image-actual-width nil)

;; for nikola from nikola plugin: org-mode
;;; Add any custom configuration that you would like to 'conf.el'.
(setq nikola-use-pygments t
      org-export-with-toc nil
      org-export-with-section-numbers nil
      org-startup-folded 'showeverything)

;;; Load Nikola macros
;; (setq nikola-macro-templates
;;       (with-current-buffer
;;           (find-file
;;            (expand-file-name "macros.org" (file-name-directory load-file-name)))
;;         (org-macro--collect-macros)))

;;; Code highlighting
(defun org-html-decode-plain-text (text)
  "Convert HTML character to plain TEXT. i.e. do the inversion of
     `org-html-encode-plain-text`. Possible conversions are set in
     `org-html-protect-char-alist'."
  (mapc
   (lambda (pair)
     (setq text (replace-regexp-in-string (cdr pair) (car pair) text t t)))
   (reverse org-html-protect-char-alist))
  text)

;; Use pygments highlighting for code
(defun pygmentize (lang code)
  "Use Pygments to highlight the given code and return the output"
  (with-temp-buffer
    (insert code)
    (let ((lang (or (cdr (assoc lang org-pygments-language-alist)) "text")))
      (shell-command-on-region (point-min) (point-max)
                               (format "pygmentize -f html -l %s" lang)
                               (buffer-name) t))
    (buffer-string)))

(defconst org-pygments-language-alist
  '(("asymptote" . "asymptote")
    ("awk" . "awk")
    ("c" . "c")
    ("c++" . "cpp")
    ("cpp" . "cpp")
    ("clojure" . "clojure")
    ("css" . "css")
    ("d" . "d")
    ("emacs-lisp" . "scheme")
    ("F90" . "fortran")
    ("gnuplot" . "gnuplot")
    ("groovy" . "groovy")
    ("haskell" . "haskell")
    ("java" . "java")
    ("js" . "js")
    ("julia" . "julia")
    ("latex" . "latex")
    ("lisp" . "lisp")
    ("makefile" . "makefile")
    ("matlab" . "matlab")
    ("mscgen" . "mscgen")
    ("ocaml" . "ocaml")
    ("octave" . "octave")
    ("perl" . "perl")
    ("picolisp" . "scheme")
    ("python" . "python")
    ("r" . "r")
    ("ruby" . "ruby")
    ("sass" . "sass")
    ("scala" . "scala")
    ("scheme" . "scheme")
    ("sh" . "sh")
    ("sql" . "sql")
    ("sqlite" . "sqlite3")
    ("tcl" . "tcl"))
  "Alist between org-babel languages and Pygments lexers.
lang is downcased before assoc, so use lowercase to describe language available.
See: http://orgmode.org/worg/org-contrib/babel/languages.html and
http://pygments.org/docs/lexers/ for adding new languages to the mapping.")

;; Override the html export function to use pygments
(defun org-html-src-block (src-block contents info)
  "Transcode a SRC-BLOCK element from Org to HTML.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (if (org-export-read-attribute :attr_html src-block :textarea)
      (org-html--textarea-block src-block)
    (let ((lang (org-element-property :language src-block))
          (code (org-element-property :value src-block))
          (code-html (org-html-format-code src-block info)))
      (if nikola-use-pygments
          (pygmentize (downcase lang) (org-html-decode-plain-text code))
        code-html))))

;; Export images with custom link type
(defun org-custom-link-img-url-export (path desc format)
  (cond
   ((eq format 'html)
    (format "<img src=\"%s\" alt=\"%s\"/>" path desc))))
;; (org-add-link-type "img-url" nil 'org-custom-link-img-url-export)

;; Export function used by Nikola.
(defun nikola-html-export (infile outfile)
  "Export the body only of the input file and write it to
specified location."
  (with-current-buffer (find-file infile)
    (org-macro-replace-all nikola-macro-templates)
    (org-html-export-as-html nil nil t t)
    (write-file outfile nil)))

(provide 'setup-org)
;;; setup-org.el ends here
