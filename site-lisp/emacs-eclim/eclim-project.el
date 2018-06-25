;; eclim-project.el --- an interface to the Eclipse IDE.
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
;;; Conventions
;;
;; Conventions used in this file: Name internal variables and functions
;; "eclim--<descriptive-name>", and name eclim command invocations
;; "eclim/command-name", like eclim/project-list.

;;* Eclim Project

(defvar eclim-project-mode-hook nil)

(defvar eclim--project-scopes '("project"
                                "workspace"))

(defvar eclim-project-mode-map
  (let ((map (make-keymap)))
    (suppress-keymap map t)
    (define-key map (kbd "N") 'eclim-project-create)
    (define-key map (kbd "m") 'eclim-project-mark-current)
    (define-key map (kbd "M") 'eclim-project-mark-all)
    (define-key map (kbd "u") 'eclim-project-unmark-current)
    (define-key map (kbd "U") 'eclim-project-unmark-all)
    (define-key map (kbd "o") 'eclim-project-open)
    (define-key map (kbd "c") 'eclim-project-close)
    (define-key map (kbd "i") 'eclim-project-info)
    (define-key map (kbd "I") 'eclim-project-import)
    (define-key map (kbd "RET") 'eclim-project-goto)
    (define-key map (kbd "D") 'eclim-project-delete)
    (define-key map (kbd "p") 'eclim-project-update)
    (define-key map (kbd "g") 'eclim-project-mode-refresh)
    (define-key map (kbd "R") 'eclim-project-rename)
    (define-key map (kbd "q") 'eclim-quit-window)
    map))


(define-key eclim-mode-map (kbd "C-c C-e g") 'eclim-project-goto)
(define-key eclim-mode-map (kbd "C-c C-e p p") 'eclim-manage-projects)
(define-key eclim-mode-map (kbd "C-c C-e p m") 'eclim-manage-projects)
(define-key eclim-mode-map (kbd "C-c C-e p i") 'eclim-project-import)
(define-key eclim-mode-map (kbd "C-c C-e p c") 'eclim-project-create)
(define-key eclim-mode-map (kbd "C-c C-e p g") 'eclim-project-goto)

(defun eclim--project-clear-cache ()
  (setq eclim--project-natures-cache nil)
  (setq eclim--projects-cache nil))

(defun eclim--check-nature (nature)
  (let ((natures (or eclim--project-natures-cache
                     (setq eclim--project-natures-cache))))
    (when (not (assoc-string nature natures))
      (error (concat "invalid project nature: " nature)))))

(defun eclim--check-project (project)
  (let ((projects (or eclim--projects-cache
                      (setq eclim--projects-cache (mapcar (lambda (p) (assoc-default 'name p)) (eclim/project-list))))))
    (when (not (assoc-string project projects))
      (error (concat "invalid project: " project))))) ;

(defun eclim--project-read (&optional single)
  (interactive)
  (if (eq major-mode 'eclim-project-mode)
      (progn
        (or (if single nil (eclim--project-get-marked))
            (eclim--project-current-line)))
    (eclim--completing-read "Project: "
                            (mapcar (lambda (p) (assoc-default 'name p)) (eclim/project-list)))))

(defun eclim--project-mode-init ()
  (switch-to-buffer (get-buffer-create "*eclim: projects*"))
  (eclim--project-mode)
  (eclim--project-buffer-refresh)
  (beginning-of-buffer))

(defun eclim--project-mode ()
  "Manage all your eclim projects one buffer"
  (kill-all-local-variables)
  (buffer-disable-undo)
  (setq major-mode 'eclim-project-mode
        mode-name "eclim/project"
        mode-line-process ""
        truncate-lines t
        line-move-visual nil
        buffer-read-only t
        default-directory (eclim/workspace-dir))
  (hl-line-mode t)
  (use-local-map eclim-project-mode-map)
  (cd "~") ;; setting a defualt directoy avoids some problems with tramp
  (run-mode-hooks 'eclim-project-mode-hook))

(defun eclim--project-buffer-refresh ()
  (eclim--project-clear-cache)
  (when (eq major-mode 'eclim-project-mode)
    (let ((inhibit-read-only t)
          (line-number (line-number-at-pos)))
      (erase-buffer)
      (loop for project across (eclim/project-list)
            do (eclim--insert-project project))
      (goto-line line-number))))

(defun eclim--insert-project (project)
  (insert (format "  | %-6s | %-30s | %s\n"
                  (if (eq :json-false (assoc-default 'open project)) "closed" "open")
                  (truncate-string-to-width (assoc-default 'name project) 30 0 nil t)
                  (assoc-default 'path project))))

(defun eclim--project-insert-mark-current (face)
  (let ((inhibit-read-only t))
    (save-excursion
      (beginning-of-line)
      (delete-char 1)
      (insert "*")
      (put-text-property (- (point) 1) (point) 'face face))))

(defun eclim--project-remove-mark-current ()
  (let ((inhibit-read-only t))
    (save-excursion
      (beginning-of-line)
      (delete-char 1)
      (insert " "))))

(defun eclim--project-get-marked ()
  (interactive)
  (let ((marked-projects '()))
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward "*" nil t)
        (push (eclim--project-current-line) marked-projects)))
    marked-projects))

(defun eclim--project-column-start (column)
  (save-excursion
    (+ (re-search-forward "|" nil t (- column 1)) 1)))

(defun eclim--project-column-end (column)
  (save-excursion
    (- (re-search-forward "|" nil t column) 1)))

(defun eclim--project-current-line ()
  (save-excursion
    (beginning-of-line)
    (eclim--string-strip (buffer-substring-no-properties
                          (eclim--project-column-start 3)
                          (eclim--project-column-end 3)))))

(defun eclim/project-list ()
  (eclim/execute-command "project_list"))

(defun eclim/project-import (folder)
  (eclim--project-clear-cache)
  (eclim--call-process "project_import" "-f" (expand-file-name folder)))

(defun eclim/project-create (folder natures name &optional depends)
  ;; TODO: allow multiple natures
  (eclim--project-clear-cache)
  (eclim--call-process "project_create" "-f" folder "-n" natures "-p" name))

(defun eclim/project-delete (project)
  (eclim--check-project project)
  (eclim--project-clear-cache)
  (eclim--call-process "project_delete" "-p" project))

(defun eclim/project-open (project)
  (eclim--check-project project)
  (eclim--call-process "project_open" "-p" project))

(defun eclim/project-close (project)
  (eclim--check-project project)
  (eclim--call-process "project_close" "-p" project))

(defun eclim/project-info (project)
  (eclim--check-project project)
  (eclim--call-process "project_info" "-p" project))

(defun eclim/project-settings (project)
  (eclim--check-project project)
  ;; TODO: make the output useable
  (eclim--call-process "project_settings" "-p" project))

(defun eclim/project-setting (project setting)
  (eclim--check-project project)
  ;; TODO: make the output useable
  (eclim--call-process "project_setting" "-p" project "-s" setting))

(defun eclim/project-nature-add (project nature)
  (eclim--check-project project)
  (eclim--check-nature nature)
  (eclim--call-process "project_nature_add" "-p" project "-n" nature))

(defun eclim/project-nature-remove (project nature)
  (eclim--check-project project)
  (eclim--check-nature nature)
  (eclim--call-process "project_nature_remove" "-p" project "-n" nature))

(defun eclim/project-natures (project)
  (eclim--check-project project)
  (eclim--call-process "project_natures" "-p" project))

(defun eclim/project-refresh (project)
  (eclim--check-project project)
  (eclim--call-process "project_refresh" "-p" project))

(defun eclim/project-refresh-file (project file)
  (eclim--check-project project)
  (eclim--call-process "project_refresh_file" "-p" project "-f" file))

(defun eclim/project-nature-aliases ()
  (eclim--call-process "project_nature_aliases"))

(defun eclim/project-links (project)
  (eclim--check-project project)
  (eclim--call-process "project_links" "-p" project))

(defun eclim/project-rename (project new-name)
  (eclim--check-project project)
  (eclim--call-process "project_rename" "-p" project "-n" new-name))

(defun eclim/project-classpath (&optional delimiter)
  "return project classpath for the current buffer."
  (eclim/execute-command "java_classpath" "-p" ("-d" delimiter)))

(defun eclim-project-rename (project name)
  (interactive (let ((project-name (eclim--project-read t)))
                 (list project-name (read-string (concat "Rename <" project-name "> To: ")))))
  (message (eclim/project-rename project name))
  (eclim--project-buffer-refresh))

(defun eclim-project-delete (projects)
  (interactive (list (eclim--project-read)))
  (when (not (listp projects)) (set 'projects (list projects)))
  (dolist (project projects)
    (when (yes-or-no-p (concat "Delete Project: <" project"> "))
      (message (eclim/project-delete project))))
  (eclim--project-buffer-refresh))

(defun eclim-project-create (name path nature)
  (interactive (list (read-string "Name: ")
                     (expand-file-name (read-directory-name "Project Directory: "))
                     (eclim--project-nature-read)))
  (message (eclim/project-create path nature name))
  (eclim--project-buffer-refresh))

(defun eclim-project-import (folder)
  (interactive "DProject Directory: ")
  (message (eclim/project-import folder))
  (eclim--project-buffer-refresh))

(defun eclim--project-nature-read ()
  (completing-read "Type: " (append (eclim/project-nature-aliases) '())))

(defun eclim-project-mode-refresh ()
  (interactive)
  (eclim--project-buffer-refresh)
  (message "projects refreshed..."))

(defun eclim--display-file-matches (header matches)
  (when (get-buffer "*eclim: find*") (kill-buffer "*eclim: find*"))
    (pop-to-buffer "*eclim: find*" t)
    (when header (insert header))
    (insert "searching for: " pattern "..." "\n\n")
    (loop for match across matches
          do (insert (format "%s:0:\t%s\n"
                             (assoc-default 'path match)
                             (assoc-default 'name match))))
    (goto-char 0)
    (grep-mode))

(defun eclim-project-file-locate (pattern)
  (interactive "MPattern: ")
  (eclim/with-results matches ("locate_file" ("-p" pattern) ("-s" "project") ("-n" (eclim--project-name)))
    (eclim--display-file-matches nil matches)))

(defun eclim-file-locate (pattern)
  (interactive "MPattern: ")
  (eclim/with-results matches ("locate_file" ("-p" pattern) ("-s" "workspace"))
    (eclim--display-file-matches
     (concat "-*- mode: grep; default-directory: \"" (eclim/workspace-dir) "\" -*-")
     matches)))

(defun eclim-file-locate-fuzzy (pattern)
  (interactive "MPattern: ")
  (eclim-file-locate
   (concat ".*" (replace-regexp-in-string "\\(.\\)" ".*?\\1" pattern) ".*")))

(defun eclim-project-update (projects)
  (interactive (list (eclim--project-read)))
  (when (not (listp projects)) (set 'projects (list projects)))
  (dolist (project projects)
    (eclim/execute-command "project_update" ("-p" project)))
  (eclim--project-buffer-refresh))

(defun eclim-project-open (projects)
  (interactive (list (eclim--project-read)))
  (when (not (listp projects)) (set 'projects (list projects)))
  (dolist (project projects)
    (eclim/project-open project))
  (eclim--project-buffer-refresh))

(defun eclim-project-close (projects)
  (interactive (list (eclim--project-read)))
  (when (not (listp projects)) (set 'projects (list projects)))
  (dolist (project projects)
    (eclim/project-close project))
  (eclim--project-buffer-refresh))

(defun eclim-project-mark-current ()
  (interactive)
  (eclim--project-insert-mark-current 'dired-mark)
  (forward-line 1))

(defun eclim-project-mark-all ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (loop do (eclim--project-insert-mark-current 'dired-mark)
          until (not (forward-line 1)))))

(defun eclim-project-unmark-current ()
  (interactive)
  (eclim--project-remove-mark-current)
  (forward-line 1))

(defun eclim-project-unmark-all ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (loop do (eclim--project-remove-mark-current)
          until (not (forward-line 1)))))

(defun eclim-project-goto (project)
  (interactive (list (eclim--project-read t)))
  (ido-find-file-in-dir
   (assoc-default 'path
                  (find project (eclim/project-list)
                        :key (lambda (e) (assoc-default 'name e))
                        :test #'string=))))

(defun eclim-project-info (project)
  (interactive (list (eclim--project-read t)))
  (let ((old-buffer (current-buffer))
        (project-info "")
        (project-settings ""))
    (switch-to-buffer (get-buffer-create "*eclim: info*"))
    (loop for attr in (eclim/project-info project)
          do (insert (format "%s: %s\n" (car attr) (cdr attr))))
    (insert "\n\nSETTINGS:\n")
    (loop for attr across (eclim/project-settings project)
          do (insert (format "%s: %s\n" (assoc-default 'name attr) (assoc-default 'value attr))))
    (local-set-key (kbd "q") (lambda ()
                               (interactive)
                               (kill-buffer)))
    (beginning-of-buffer)
    (setq major-mode 'special-mode
          mode-name "eclim/project-info"
          buffer-read-only t)))

(defun eclim-project-build ()
  "Triggers a build of the current project"
  (interactive)
  (eclim/execute-command-async
   (lambda (res) (message res))
   "project_build" "-p"))

(defun eclim-manage-projects ()
  (interactive)
  (eclim--project-clear-cache)
  (eclim--project-mode-init))


(provide 'eclim-project)