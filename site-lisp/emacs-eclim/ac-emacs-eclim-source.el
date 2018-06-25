;; ac-emacs-eclim-source.el --- an interface to the Eclipse IDE.
;;
;; Copyright (C) 2009   Fredrik Appelberg
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Contributors
;;
;;; Conventions
;;
;; Conventions used in this file: Name internal variables and functions
;; "eclim--<descriptive-name>", and name eclim command invocations
;; "eclim/command-name", like eclim/project-list.
;;; Description
;;
;; ac-emacs-eclim-source.el -- a emacs eclime source for auto-complete-mode
;;

(require 'eclim)
(require 'eclim-java)
(require 'auto-complete)

(defface ac-emacs-eclim-candidate-face
  '((t (:background "gold1" :foreground "black")))
  "Face for emacs-eclim candidate."
  :group 'auto-complete)

(defface ac-emacs-eclim-selection-face
  '((t (:background "gold4" :foreground "white")))
  "Face for the emacs-eclim selected candidate."
  :group 'auto-complete)

(defun ac-emacs-eclim-candidates ()
  (with-no-warnings
    (mapcar (lambda (c) (assoc-default 'info c))
            (assoc-default 'completions (eclim/java-complete)))))

(defun ac-emacs-eclim-available ()
  (eclim--accepted-p (buffer-file-name)))

(defvar ac-emacs-eclim-point)

(defun ac-emacs-eclim-init ()
  (setq ac-emacs-eclim-point ac-point)
  (when eclim-print-debug-messages (message "Completion started at %s, ac-point is %s" (point) ac-point)))

(defun ac-emacs-eclim-yasnippet-convert (s)
  "Convert a completion string to a yasnippet template"
  (apply #'concat
	 (let* ((beg (string-match "[<(]" s)))
	   (cons (substring s 0 (or beg (length s)))
		 (loop for start = beg then (match-end 0)
		       for end = (string-match "(\\|)\\|, *" s start)
		       with i = 0
		       while end
		       if (not (= start end)) collect (format "${%s:%s}" (incf i) (substring s start end)) into res
		       collect (match-string 0 s) into res
		       finally return (append res '("$0")))))))

(defun ac-emacs-eclim-action ()
    (let* ((end (point))
	   (completion (buffer-substring-no-properties ac-emacs-eclim-point end)))
      (if (string-match "\\([^-:]+\\) .*?\\(- *\\(.*\\)\\)?" completion)
	  (let* ((insertion (match-string 1 completion))
		 (rest (match-string 3 completion))
		 (package (if (and rest (string-match "\\w+\\(\\.\\w+\\)*" rest)) rest nil))
		 (template (ac-emacs-eclim-yasnippet-convert insertion)))
	    (delete-region ac-emacs-eclim-point end)
	    (if (and eclim-use-yasnippet template (featurep 'yasnippet))
		(yas/expand-snippet template)
	      (insert insertion))
	    (when package
	      (eclim--java-organize-imports
	       (eclim/execute-command "java_import_order" "-p")
	       (list (concat package "." (substring insertion 0 (or (string-match "[<(]" insertion)
								    (length insertion)))))))))))

(ac-define-source emacs-eclim
  '((candidates . ac-emacs-eclim-candidates)
    (available . ac-emacs-eclim-available)
    (init . ac-emacs-eclim-init)
    (action . ac-emacs-eclim-action)
    (requires . 0)
    (cache)
    (selection-face . ac-emacs-eclim-selection-face)
    (candidate-face . ac-emacs-eclim-candidate-face)
    (symbol . "f")))

(ac-define-source emacs-eclim-c-dot
  '((candidates . ac-emacs-eclim-candidates)
    (available . ac-emacs-eclim-available)
    (init . ac-emacs-eclim-init)
    (action . ac-emacs-eclim-action)
    (prefix . c-dot)
    (requires . 0)
    (cache)
    (selection-face . ac-emacs-eclim-selection-face)
    (candidate-face . ac-emacs-eclim-candidate-face)
    (symbol . "f")))

(provide 'ac-emacs-eclim-source)
