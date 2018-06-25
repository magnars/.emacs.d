;;; smajobber-mode.el --- Convenience utilities for working with Finn Småjobber in Emacs

;; Copyright (C) 2013 Jostein Holje

;; Author: Jostein Holje <jostein.holje@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 's)

(defun smajobber-hot-deploy-buffer-file ()
  "If the current buffer is visiting a file, and that file is deployed
in an exploded war, re-deploy the file."
  (interactive)
  (let* ((source (buffer-file-name))
         (target (s-replace "src/main/webapp" "target/smajobber" source)))
    (if (and (file-writable-p target)
             (not (string= source target)))
        (progn
          (copy-file source target t)
          (message (concat "Deployed " source " to " target)))
      (message (concat target " does not exist, file not deployed")))))

(define-minor-mode smajobber-mode
  "Convenience utilities for working with Finn Småjobber"
  nil " Smajobber" nil
  (if smajobber-mode
      (add-hook 'after-save-hook 'smajobber-hot-deploy-buffer-file nil t)
    (remove-hook 'after-save-hook 'smajobber-hot-deploy-buffer-file t)))

(defun smajobber--setup-js-quirks ()
  (when (string-match-p "smajobber" (buffer-file-name))
    (fci-mode 1)
    (setq js2-additional-externs '("testCase" "define"))
    (setq js2r-path-to-tests "/test/javascript/tests/")
    (setq js2r-path-to-sources "/main/webapp/scripts/smajobber/")
    (setq js2r-test-suffix "Test")
    (setq buster-testcase-snippets-enabled t)
    (make-variable-buffer-local 'buster-test-prefix)
    (set (make-local-variable 'sgml-basic-offset) 4)
    (make-variable-buffer-local 'js2-basic-offset)
    (setq js2-basic-offset 4)))

(defun smajobber-deploy ()
  (interactive)
  (shell-command "grunt build")
  (shell-command (concat "cp -r "
                         (eproject-root) "web/src/main/webapp/scripts/smajobber/browserify/dist/* "
                         (eproject-root) "web/target/smajobber/scripts/smajobber/browserify/dist/.")))

(add-hook 'js2-mode-hook 'smajobber--setup-js-quirks)

(provide 'smajobber-mode)
;;; smajobber-mode.el ends here
