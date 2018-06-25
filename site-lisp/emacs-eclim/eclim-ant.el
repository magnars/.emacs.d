;; eclim-ant.el --- an interface to the Eclipse IDE.
;;
;; Copyright (C) 2009  Yves Senn <yves senn * gmx ch>
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
;;
;;; Conventions
;;
;; Conventions used in this file: Name internal variables and functions
;; "eclim--<descriptive-name>", and name eclim command invocations
;; "eclim/command-name", like eclim/project-list.

;;* Eclim Ant

(define-key eclim-mode-map (kbd "C-c C-e a c") 'eclim-ant-clear-cache)
(define-key eclim-mode-map (kbd "C-c C-e a r") 'eclim-ant-run)
(define-key eclim-mode-map (kbd "C-c C-e a a") 'eclim-ant-run)
(define-key eclim-mode-map (kbd "C-c C-e a v") 'eclim-ant-validate)

(defgroup eclim-ant nil
  "Build java projects using Apache Ant"
  :group 'eclim)

(defcustom eclim-ant-directory ""
  "This variable contains the location, where the main buildfile is
stored. It is used globally for all eclim projects."
  :group 'eclim-ant
  :type 'directory)

(defcustom eclim-ant-buildfile-name "build.xml"
  "The name of the main buildfile from your projects."
  :group 'eclim-ant
  :type 'string)

(defvar eclim--ant-target-cache nil)

(defun eclim--ant-buildfile-name ()
  (concat (file-name-as-directory eclim-ant-directory) eclim-ant-buildfile-name))

(defun eclim--ant-buildfile-path ()
  (file-name-directory (concat (eclim--project-dir) "/" (eclim--ant-buildfile-name))))

(defun eclim--ant-targets (project buildfile)
  (when (null eclim--ant-target-cache)
    (setq eclim--ant-target-cache (make-hash-table :test 'equal)))
  (or (gethash buildfile eclim--ant-target-cache)
      (puthash buildfile (eclim/ant-target-list project buildfile) eclim--ant-target-cache)))

(defun eclim--ant-read-target (project buildfile)
  (eclim--completing-read "Target: " (eclim--ant-targets project buildfile)))

(defun eclim/ant-validate (project buildfile)
  (eclim--check-project project)
  (mapcar (lambda (line)
            (split-string line "|"))
          (eclim--call-process "ant_validate" "-p" project "-f" file)))

(defun eclim/ant-target-list (project buildfile)
  (eclim--check-project project)
  (eclim--call-process "ant_targets" "-p" project "-f" buildfile))

(defun eclim-ant-clear-cache ()
  "Clear the cached ant target list. This can be usefull when the
buildfile for the current project has changed and needs to be updated"
  (interactive)
  (setq eclim--ant-target-cache nil))

(defun eclim-ant-validate (project file)
  "Run ant-xml validation against the file opened in the current
buffer. The resulst are displayed in a deticated compilation buffer."
  (interactive (list (eclim--project-name) (buffer-file-name)))
  (pop-to-buffer (get-buffer-create "*eclim: build*"))
  (let ((buffer-read-only nil))
    (erase-buffer)
    (dolist (line (eclim/ant-validate project file))
      (insert (eclim--convert-find-result-to-string line))
      (newline)))
  (beginning-of-buffer)
  (compilation-mode))

(defun eclim-ant-run (target)
  "run a specified ant target in the scope of the current project. If
the function is called interactively the users is presented with a
  list of all available ant targets."
  (interactive (list (eclim--ant-read-target (eclim--project-name)
                                             (eclim--ant-buildfile-name))))
  (let ((default-directory (eclim--ant-buildfile-path)))
    ;; TODO: use the right version of java to execute ant
    (compile (concat "ant " target))))

(provide 'eclim-ant)