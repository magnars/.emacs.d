;;; eclimd.el --- Start and stop eclimd from within emacs

;; Copyright (C) 2012 Vedat Hallac

;; Authors: Vedat Hallac
;; Version: 1.0
;; Created: 2012/05/11
;; Keywords: java, emacs-eclim

;; This file is NOT part of Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;; MA 02110-1301, USA.

(require 'eclim)

(defgroup eclimd nil
  "eclimd customizations"
  :prefix "eclimd-"
  :group 'eclim)

(defcustom eclimd-executable
  nil
  "The eclimd executable to use.
Set to nil to auto-discover from `eclim-executable' value (the default value).
Set to \"eclimd\" if eclim and eclimd are in `exec-path'. Otherwise, set to
the full path to eclimd executable."
  :type '(choice (const :tag "Same directory as eclim-executable variable" nil)
                 (string :tag "Custom value" "eclimd"))
  :group 'eclimd)

(defcustom eclimd-default-workspace
  "~/workspace"
  "The workspace to use with eclimd"
  :type 'directory
  :group 'eclimd)

(defcustom eclimd-wait-for-process
  t
  "Set to t if you want `start-eclimd' to wait until the eclimd process is ready.
When this variable is nil, `start-eclimd' returns immediately after
eclimd process is started. Since the eclimd process startup takes a few seconds,
running eclim commands immediately after the function returns may cause failures.
You can freeze emacs until eclimd is ready to accept commands with this variable."
  :tag "Wait until eclimd is ready"
  :type 'boolean
  :group 'eclimd)

(defvar eclimd-process-buffer nil
  "Buffer used for communication with eclimd process")

(defvar eclimd-process nil
  "The active eclimd process")

(defconst eclimd-process-buffer-name "eclimd")

(defun eclimd--executable-path ()
  (if eclimd-executable
      (executable-find eclimd-executable)
    (let ((eclim-prog (executable-find eclim-executable)))
      (expand-file-name "eclimd" (file-name-directory eclim-prog)))))

(defun eclimd--running-p ()
  (not (null (get-buffer-process eclimd-process-buffer))))

(defun eclimd--match-process-output (regexp proc)
  "Wait for the given process to output a string that matches the specified regexp.
Return the string used for `match-string' if a match is found, and nil if the process is killed.

The caller must use `save-match-data' to preserve the match data if necessary."
  (let ((old-filter (process-filter proc))
	(old-sentinel (process-sentinel proc))
	(output "")
	(terminated-p))
    (set-process-filter proc (lambda (proc string)
			       (setf output (concat output string))
			       ;; Chain to the old filter
			       (if old-filter
				   (funcall old-filter proc string))))
    (set-process-sentinel proc (lambda (proc state)
				 (unless (eq 'run
					     (process-status proc))
				   (setf terminated-p t))))
    (while (and (not terminated-p)
		(not (string-match regexp output)))
      (accept-process-output proc))
    (set-process-sentinel proc old-sentinel)
    (set-process-filter proc old-filter)
    (and (not terminated-p) output)))

(defun wait-eclimd-start ()
  "Wait for the eclimd server to become active.
This function also waits for the eclimd server to report that it is started.
It returns the port it is listening on"
  (let ((eclimd-start-regexp "Eclim Server Started on\\(?: port\\|:\\) \\(?:\\(?:[0-9]+\\.\\)\\{3\\}[0-9]+:\\)?\\([0-9]+\\)"))
    (save-match-data
      (let ((output (eclimd--match-process-output eclimd-start-regexp eclimd-process)))
	(when output
	  (setq eclimd-port (match-string 1 output))
	  (message (concat "eclimd serving at port " eclimd-port)))))
    eclimd-port))

(defun start-eclimd (workspace-dir)
  (interactive (list (read-directory-name "Workspace directory: "
                                          eclimd-default-workspace nil t)))
  (let ((eclimd-prog (eclimd--executable-path)))
    (if (not eclimd-prog)
        (message "Cannot start eclimd: check eclimd-executable variable.")
      (if (eclimd--running-p)
          (message "Cannot start eclimd: eclimd is already running.")
        (message (concat "Starting eclimd for workspace: " workspace-dir "..."))
        (setq eclimd-process-buffer
              (make-comint eclimd-process-buffer-name
                           eclimd-prog
                           nil
                           (concat "-Dosgi.instance.area.default="
                                   (replace-regexp-in-string "~" "@user.home" workspace-dir))))
        (setq eclimd-process (get-buffer-process eclimd-process-buffer))
        (when eclimd-wait-for-process
          (wait-eclimd-start))))))

(defun stop-eclimd ()
  (interactive)
  (when eclimd-process
    (eclim/execute-command "shutdown")
    (eclimd--match-process-output "Process eclimd finished" eclimd-process)
    (delete-process eclimd-process)
    (setq eclimd-process nil))
  (when eclimd-process-buffer
    (kill-buffer eclimd-process-buffer)
    (setq eclimd-process-buffer nil)))

(provide 'eclimd)
