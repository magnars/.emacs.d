;; company-emacs-eclim.el --- an interface to the Eclipse IDE.
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
;; company-emacs-eclim.el -- a company-mode backend that replaces company-eclim
;;
;; To activate this backend, replace company-eclim with
;; company-emacs-eclim in the eclim-backends list, or call the
;; convenience function company-emacs-eclim-setup.

;;* Eclim Company

(require 'eclim)
(require 'eclim-java)
(require 'company)

(defvar cee--candidates nil)
(make-variable-buffer-local 'cee--candidates)

(defun company-emacs-eclim-setup ()
  "Convenience function that adds company-emacs-eclim to the list
  of available company backends."
  (flet ((replace-recur (elt rpl lst)
			(cond ((null lst) nil)
			      ((listp (first lst)) (cons (replace-recur elt rpl (first lst))
							 (replace-recur elt rpl (rest lst))))
			      (t (cons (if (equal (first lst) elt) rpl (first lst))
				       (replace-recur elt rpl (rest lst)))))))
    (let ((replaced (replace-recur 'company-eclim 'company-emacs-eclim company-backends)))
      (setq company-backends
	    (if (eq replaced company-backends)
		(cons 'company-emacs-eclim company-backends)
	      replaced)))))

(defun cee--correct-completions (candidates)
  "If we are lookup at a list of method call completions, check
  if we have already typed part of this call."
  (cond ((every (lambda (c) (string= "f" (eclim--completion-candidate-type c))) candidates)
         ;; When completing a method call that have alread been completed
         ;; up to the 'method(' point, eclim still reports the
         ;; completions as 'method(arg1, arg2, ...)', which is not what
         ;; company-mode expects.
         (let ((common (try-completion "" (mapcar 'eclim--completion-candidate-doc candidates))))
           (save-excursion
             (if (search-backward common (- (point) (length common)) t)
                 (mapcar (lambda (c)
                           (list
                            (eclim--completion-candidate-type c)
                            (eclim--completion-candidate-class c)
                            (substring (eclim--completion-candidate-doc c) (length common))))
                         candidates)
               candidates))))
        (t candidates)))

(defun cee--candidates (prefix)
  "Calls eclim to get a list of matching completion candidates."
  (interactive "d")
  (let ((project-file (eclim--project-current-file))
        (project-name (eclim--project-name)))
    (eclim/java-src-update)
    (setq cee--candidates  (cee--correct-completions (assoc-default 'completions (eclim/java-complete)))))
  (let ((completion-ignore-case nil))
    (all-completions prefix (mapcar 'eclim--completion-candidate-doc cee--candidates))))

(defun cee--lookup-candidate (lookup)
  "Looks up the candidate record that matches the string inserted
by company-mode in the list of eclim-matches."
  (find lookup cee--candidates
   	:key #'eclim--completion-candidate-doc
   	:test #'string=))

(defun company-emacs-eclim (command &optional arg &rest ignored)
  "A `company-mode' back-end for eclim completion"
  (interactive)
  (case command
    ('prefix (and (derived-mode-p 'java-mode 'jde-mode)
                  buffer-file-name
                  eclim-executable
                  (eclim--project-name)
                  (not (company-in-string-or-comment))
                  (or (company-grab-symbol) 'stop)))
    ('candidates (cee--candidates arg))
    ('meta (eclim--completion-candidate-doc (cee--lookup-candidate arg)))
    ('no-cache (equal arg ""))))

(defun cee--delete-backward (delim)
  "Delete text backwards from point up to and including the part
of the buffer that matches DELIM. The search is bounded by
COMPANY-POINT - 1."
  (let ((end (point))
	(start (search-backward delim (- company-point 1) t)))
    (when start
      (delete-region start end))))

(defun cee--generic-args (candidate)
  "If the doc string for this CANDIDATE is a generic arg list,
  return a list of the arguments, otherwise return nil."
  (save-excursion
    (let ((doc (eclim--completion-candidate-doc candidate)))
      (if (string-match "\\(.*?<\\)\\(.*\\)>" doc)
	  (let ((class (match-string 1 doc))
		(args (match-string 2 doc)))
	    (if (search-backward class 0 t)
		(split-string args ",")))))))

(defun cee--method-call (candidate)
  "If the doc string for this CANDIDATE is a method call argument
  list, return a list of lists representing the type and
  name of each argument."
  (let ((doc (eclim--completion-candidate-doc candidate)))
    (if (or (string-match "\\(.*\\)(\\(.*\\))" doc)
	    (string-match "\\(\\)\\(.*\\))" doc))
	(mapcar (lambda (e) (split-string e " "))
		(split-string (match-string 2 doc) ", " t)))))

(defun cee--join-list (lst glue)
  "Utility function; returns a list based on LST with GLUE
inserted between each element."
  (cond ((null lst) nil)
	((null (rest lst)) lst)
	(t
	 (cons (first lst)
	       (cons glue (cee--join-list (rest lst) glue))))))

(defun cee--show-arg-list (start-delim args glue end-delim)
  "Displays/inserts an argument list at point, using yasnippet if
available."
  (flet ((args-to-string (arg-list)
			 (apply 'concat
				(append
				 (when start-delim (list start-delim))
				 (cee--join-list arg-list glue)
				 (when end-delim (list end-delim))))))
    (if (and eclim-use-yasnippet (featurep 'yasnippet))
	(yas/expand-snippet (args-to-string
			     (loop for arg in args
				   for i from 1
				   collect (concat "${" (int-to-string i) ":" arg "}"))))
      (insert (args-to-string args)))))

;; TODO: handle override/implementation of methods
;; TODO: handle constructor arguments
(defun cee--completion-finished (arg)
  "Post-completion hook after running company-mode completions."
  (let* ((candidate (cee--lookup-candidate arg))
         (type (eclim--completion-candidate-type candidate)))
    (when candidate
      (if (string= "t" type)
          ;; If this is a type, first check if this is a completion of generic argumends
          (let ((gen-args (cee--generic-args candidate)))
            (if gen-args
                (progn
                  (delete-region company-point (point))
                  (cee--show-arg-list nil gen-args ", " ">"))
              (progn
                ;; otherwise, remove the doc string and insert an import statement
                (cee--delete-backward " - ")
                (eclim--java-organize-imports
                 (eclim/execute-command "java_import_order" "-p")
                 (list
                  (concat (eclim--completion-candidate-package candidate) "."
                          (eclim--completion-candidate-class candidate)))))))
        ;; Otherwise, check if this is a method call
        (if (string= "f" type)
            (let ((call-args (cee--method-call candidate)))
              (push-mark (point) t)
              (goto-char (search-backward "("))
              (cee--show-arg-list "("
                                  (mapcar (lambda (c) (concat (first c) " " (second c))) call-args)
                                  ", " ")")
              (save-excursion
                (delete-region (1- (search-forward "(")) (mark t)))
              (pop-mark))
          ;; Otherwise, just delete the doc string
          (cee--delete-backward " : "))))))

(add-hook 'company-completion-finished-hook
	  'cee--completion-finished)

(provide 'company-emacs-eclim)
