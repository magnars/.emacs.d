
(defgroup eclim-problems nil
  "Problems: settings for displaying the problems buffer and highlighting errors in code."
  :group 'eclim)

(defcustom eclim-problems-refresh-delay 0.5
  "The delay (in seconds) to wait before we refresh the problem list buffer after a file is saved."
  :group 'eclim-problems
  :type 'number)

(defcustom eclim-problems-resize-file-column t
  "Resizes file column in emacs-eclim problems mode"
  :group 'eclim-problems
  :type '(choice (const :tag "Off" nil)
                 (const :tag "On" t)))

(defcustom eclim-problems-show-pos nil
  "Shows problem line/column in emacs-eclim problems mode"
  :group 'eclim-problems
  :type '(choice (const :tag "Off" nil)
                 (const :tag "On" t)))

(defcustom eclim-problems-show-file-extension nil
  "Shows file extensions in emacs-eclim problems mode"
  :group 'eclim-problems
  :type '(choice (const :tag "Off" nil)
                 (const :tag "On" t)))

(defcustom eclim-problems-hl-errors t
  "Highlights errors in the problem list buffer"
  :group 'eclim-problems
  :type '(choice (const :tag "Off" nil)
                 (const :tag "On" t)))

(defface eclim-problems-highlight-error-face
  '((t (:underline "red")))
  "Face used for highlighting errors in code"
  :group 'eclim-problems)

(defface eclim-problems-highlight-warning-face
  '((t (:underline "orange")))
  "Face used for highlighting errors in code"
  :group 'eclim-problems)

(defvar eclim-autoupdate-problems t)

(defvar eclim-problems-mode-hook nil)

(defvar eclim--problems-filter-description "")
(defvar eclim--problems-project nil) ;; problems are relative to this project
(defvar eclim--problems-file nil) ;; problems are relative to this file (when eclim--problems-filefilter is non-nil)

(setq eclim-problems-mode-map
      (let ((map (make-keymap)))
        (suppress-keymap map t)
        (define-key map (kbd "a") 'eclim-problems-show-all)
        (define-key map (kbd "e") 'eclim-problems-show-errors)
        (define-key map (kbd "g") 'eclim-problems-buffer-refresh)
        (define-key map (kbd "q") 'eclim-quit-window)
        (define-key map (kbd "w") 'eclim-problems-show-warnings)
        (define-key map (kbd "f") 'eclim-problems-toggle-filefilter)
        (define-key map (kbd "RET") 'eclim-problems-open-current)
        map))

(define-key eclim-mode-map (kbd "C-c C-e b") 'eclim-problems)
(define-key eclim-mode-map (kbd "C-c C-e o") 'eclim-problems-open)

(defvar eclim--problems-list nil)

(defvar eclim--problems-filter nil) ;; nil -> all problems, w -> warnings, e -> errors
(defvar eclim--problems-filefilter nil) ;; should filter by file name

(defconst eclim--problems-buffer-name "*eclim: problems*")
(defconst eclim--problems-compilation-buffer-name "*compilation: eclim*")

(defun eclim--problems-mode ()
  (kill-all-local-variables)
  (buffer-disable-undo)
  (setq majod-mode 'eclim-problems-mode
        mode-name "eclim/problems"
        mode-line-process ""
        truncate-lines t
        line-move-visual nil
        buffer-read-only t
        default-directory (eclim/workspace-dir))
  (setq mode-line-format
        (list "-"
              'mode-line-mule-info
              'mode-line-modified
              'mode-line-frame-identification
              'mode-line-buffer-identification

              "   "
              'mode-line-position

              "  "
              'eclim--problems-filter-description

              "  "
              'mode-line-modes
              '(which-func-mode ("" which-func-format "--"))

              'global-mode-string
              "-%-"))
  (hl-line-mode t)
  (use-local-map eclim-problems-mode-map)
  (run-mode-hooks 'eclim-problems-mode-hook))

(defun eclim--problems ()
  "Calls eclipse to obtain all current problems. Returns a list of lists."
  (remove-if-not (lambda (l) (= (length l) 4)) ;; for now, ignore multiline errors
                 (mapcar (lambda (line) (split-string line "|" nil))
                         (eclim--call-process "problems"
                                              "-p" eclim--problems-project))))

(defun eclim--problem-goto-pos (p)
  (goto-char (point-min))
  (forward-line (1- (assoc-default 'line p)))
  (dotimes (i (1- (assoc-default 'column p)))
    (forward-char)))

(defun eclim--problems-apply-filter (f)
  (setq eclim--problems-filter f)
  (eclim-problems-buffer-refresh))

(defun eclim-problems-show-errors ()
  (interactive)
  (eclim--problems-apply-filter "e"))

(defun eclim-problems-toggle-filefilter ()
  (interactive)
  (setq eclim--problems-filefilter (not eclim--problems-filefilter))
  (eclim--problems-buffer-redisplay))

(defun eclim-problems-show-warnings ()
  (interactive)
  (eclim--problems-apply-filter "w"))

(defun eclim-problems-show-all ()
  (interactive)
  (eclim--problems-apply-filter nil))

(defun eclim--problems-insert-highlight (problem)
  (save-excursion
    (eclim--problem-goto-pos problem)
    (let* ((id (eclim--java-identifier-at-point t t))
           (start (car id))
           (end (+ (car id) (length (cdr id)))))
      (let ((highlight (make-overlay start end (current-buffer) t t)))
        (overlay-put highlight 'face
                     (if (eq t (assoc-default 'warning problem))
                         'eclim-problems-highlight-warning-face
                       'eclim-problems-highlight-error-face))
        (overlay-put highlight 'category 'eclim-problem)
        (overlay-put highlight 'kbd-help (assoc-default 'message problem))))))

(defun eclim--problems-clear-highlights ()
  (remove-overlays nil nil 'category 'eclim-problem))

(defadvice find-file (after eclim-problems-highlight-on-find-file activate)
  (eclim-problems-highlight))
(defadvice find-file-other-window (after eclim-problems-highlight-on-find-file-other-window activate)
  (eclim-problems-highlight))
(defadvice other-window (after eclim-problems-highlight-on-other-window activate)
  (eclim-problems-highlight))
(defadvice switch-to-buffer (after eclim-problems-highlight-switch-to-buffer activate)
  (eclim-problems-highlight))

(defun eclim-problems-highlight ()
  (interactive)
  (when (eclim--file-managed-p)
    (eclim--problems-clear-highlights)
    (loop for problem across (remove-if-not (lambda (p) (string= (assoc-default 'filename p) (buffer-file-name))) eclim--problems-list)
          do (eclim--problems-insert-highlight problem))))

(defun eclim-problems-open-current ()
  (interactive)
  (let* ((p (aref (eclim--problems-filtered) (1- (line-number-at-pos)))))
    (find-file-other-window (assoc-default 'filename p))
    (eclim--problem-goto-pos p)))

(defun eclim-problems-buffer-refresh ()
  "Refresh the problem list and draw it on screen."
  (interactive)
  (when (not (minibuffer-window-active-p (minibuffer-window)))
    (message "refreshing... %s " (current-buffer)))
  (eclim/with-results-async res ("problems" ("-p" eclim--problems-project) (when (string= "e" eclim--problems-filter) '("-e" "true")))
    (setq eclim--problems-list res)
    (eclim--problems-buffer-redisplay)
    (if (not (minibuffer-window-active-p (minibuffer-window)))
        (if (string= "e" eclim--problems-filter)
            (message "Eclim reports %d errors." (length eclim--problems-list))
          (message "Eclim reports %d errors, %d warnings."
                   (length (remove-if-not (lambda (p) (not (eq t (assoc-default 'warning p)))) eclim--problems-list))
                   (length (remove-if-not (lambda (p) (eq t (assoc-default 'warning p))) eclim--problems-list)))))))

(defun eclim--problems-cleanup-filename (filename)
  (let ((x (file-name-nondirectory (assoc-default 'filename problem))))
    (if eclim-problems-show-file-extension x (file-name-sans-extension x))))

(defun eclim--problems-filecol-size ()
  (if eclim-problems-resize-file-column
      (min 40
           (apply #'max 0
                  (mapcar (lambda (problem)
                            (length (eclim--problems-cleanup-filename (assoc-default 'filename problem))))
                          (eclim--problems-filtered))))
    40))

(defun eclim--problems-update-filter-description ()
  (if eclim--problems-filefilter
      (if eclim--problems-filter
          (setq eclim--problems-filter-description (concat "(file-" eclim--problems-filter ")"))
        (setq eclim--problems-filter-description "(file)"))
    (if eclim--problems-filter
        (setq eclim--problems-filter-description (concat eclim--problems-project "(" eclim--problems-filter ")"))
      (setq eclim--problems-filter-description eclim--problems-project))))

(defun eclim--problems-buffer-redisplay ()
  "Draw the problem list on screen."
  (let ((buf (get-buffer "*eclim: problems*")))
    (when buf
      (save-excursion
        (set-buffer buf)
        (eclim--problems-update-filter-description)
        (save-excursion
          (dolist (b (mapcar #'window-buffer (window-list)))
            (set-buffer b)
            (eclim-problems-highlight)))
        (let ((inhibit-read-only t)
              (line-number (line-number-at-pos))
              (filecol-size (eclim--problems-filecol-size)))
          (erase-buffer)
          (loop for problem across (eclim--problems-filtered)
                do (eclim--insert-problem problem filecol-size))
          (goto-char (point-min))
          (forward-line (1- line-number)))))))

(defun eclim--problems-filtered (&optional ignore-type-filter)
  "Filter reported problems by eclim.

It filters out problems using the ECLIM--PROBLEMS-FILEFILTER
criteria. If IGNORE-TYPE-FILTER is nil (default), then problems
are also filtered according to ECLIM--PROBLEMS-FILTER, i.e.,
error type. Otherwise, error type is ignored. This is useful when
other mechanisms, like compilation's mode
COMPILATION-SKIP-THRESHOLD, implement this feature."
  (remove-if-not
   (lambda (x) (and
                (or (not eclim--problems-filefilter)
                    (string= (assoc-default 'filename x) eclim--problems-file))
                (or ignore-type-filter
                    (not eclim--problems-filter)
                    (and (string= "e" eclim--problems-filter)
                         (not (eq t (assoc-default 'warning x))))
                    (and (string= "w" eclim--problems-filter)
                         (eq t (assoc-default 'warning x))))))
   eclim--problems-list))

(defun eclim--insert-problem (problem filecol-size)
  (let* ((filecol-format-string (concat "%-" (number-to-string filecol-size) "s"))
         (filename (truncate-string-to-width (eclim--problems-cleanup-filename (assoc-default 'filename problem))
                                             40 0 nil t))
         (text (if eclim-problems-show-pos
                   (format (concat filecol-format-string
                                   " | line %-12s"
                                   " | %s")
                           filename
                           (assoc-default 'line problem)
                           (assoc-default 'message problem))
                 ;; else
                 (format (concat filecol-format-string
                                 " | %s")
                         filename
                         (assoc-default 'message problem)))))
    (when (and eclim-problems-hl-errors (eq :json-false (assoc-default 'warning problem)))
      (put-text-property 0 (length text) 'face 'bold text))
    (insert text)
    (insert "\n")))

(defun eclim--get-problems-buffer ()
  "Return the eclim problems buffer, if it exists. Otherwise,
create and initialize a new buffer."
  (or (get-buffer "*eclim: problems*")
      (let ((buf (get-buffer-create "*eclim: problems*")))
        (save-excursion
          ;; (setq eclim--problems-project (eclim--project-name))
          (setq eclim--problems-file buffer-file-name)
          (set-buffer buf)
          (eclim--problems-mode)
          ;(eclim-problems-buffer-refresh)
          (goto-char (point-min))))))

(defun eclim--problems-mode-init (&optional quiet)
  "Create and initialize the eclim problems buffer. If the
argument QUIET is non-nil, open the buffer in the background
without switching to it."
  (let ((buf (get-buffer-create "*eclim: problems*")))
    (save-excursion
      (setq eclim--problems-project (eclim--project-name))
      (setq eclim--problems-file buffer-file-name)
      (set-buffer buf)
      (eclim--problems-mode)
      (eclim-problems-buffer-refresh)
      (goto-char (point-min)))
    (if (not quiet)
        (switch-to-buffer buf))))

(defun eclim-problems ()
  "Show current compilation problems in a separate window."
  (interactive)
  (eclim--problems-mode-init))

(defun eclim-problems-open ()
  "Opens a new (emacs) window inside the current frame showing the current project compilation problems"
  (interactive)
  (let ((w (selected-window)))
    (select-window (split-window nil (round (* (window-height w) 0.75)) nil))
    (eclim-problems)
    (select-window w)))

(add-hook 'find-file-hook
          (lambda () (when (and (eclim--accepted-p (buffer-file-name))
                                (not (get-buffer eclim--problems-buffer-name)))
                       (eclim--problems-mode-init t))))

(defun eclim-problems-refocus ()
  (interactive)
  (when (eclim--project-dir)
    (setq eclim--problems-project (eclim--project-name))
    (setq eclim--problems-file buffer-file-name)
    (with-current-buffer eclim--problems-buffer-name
      (eclim-problems-buffer-refresh))))

(defun eclim-problems-next ()
  (interactive)
  (let ((prob-buf (get-buffer eclim--problems-buffer-name)))
    (when prob-buf
      (set-buffer prob-buf)
      (if eclim--problems-list-at-first
          (setq eclim--problems-list-at-first nil)
        (next-line))
      (hl-line-move hl-line-overlay)
      (eclim-problems-open-current))))

(defun eclim-problems-previous ()
  (interactive)
  (let ((prob-buf (get-buffer eclim--problems-buffer-name)))
    (when prob-buf
      (set-buffer prob-buf)
      (previous-line)
      (hl-line-move hl-line-overlay)
      (eclim-problems-open-current))))

(defun eclim--problems-update-maybe ()
  "If autoupdate is enabled, this function triggers a delayed
refresh of the problems buffer."
  (when (and (not eclim--is-completing)
             (eclim--project-dir)
             eclim-autoupdate-problems)
    (setq eclim--problems-project (eclim--project-name))
    (setq eclim--problems-file buffer-file-name)
    (run-with-idle-timer eclim-problems-refresh-delay nil (lambda () (eclim-problems-buffer-refresh)))))

(defun eclim-problems-compilation-buffer ()
  "Creates a compilation buffer from eclim error messages. This
is convenient as it lets the user navigate between errors using
`next-error' (\\[next-error])."
  (interactive)
  (let ((problems (eclim--problems))
        (filecol-size (eclim--problems-filecol-size))
        (project-directory (concat (eclim--project-dir buffer-file-name) "/"))
        (compil-buffer (get-buffer-create eclim--problems-compilation-buffer-name)))
    (with-current-buffer compil-buffer
      (setq default-directory project-directory)
      (setq buffer-read-only nil)
      (erase-buffer)
      (insert (concat "-*- mode: compilation; default-directory: "
                      project-directory
                      " -*-\n"))
      (let ((errors 0) (warnings 0))
        (dolist (problem (eclim--problems-filtered t))
          (eclim--insert-problem-compilation problem filecol-size project-directory)
          (cond ((string-equal (eclim--problem-type problem) "e")
                 (setq errors (1+ errors)))
                ((string-equal (eclim--problem-type problem) "w")
                 (setq warnings (1+ warnings)))))
        (insert (format "\nCompilation results: %d errors and %d warnings."
                        errors warnings)))
      (compilation-mode))
    (display-buffer compil-buffer 'other-window)))

(defun eclim--insert-problem-compilation (problem filecol-size project-directory)
  (let ((filename (first (split-string (assoc-default 'filename problem) project-directory t)))
        (position (split-string (eclim--problem-pos problem) " col " t))
        (description (assoc-default 'message problem))
        (type (eclim--problem-type problem)))
    (let ((line (first position))
          (col (second position)))
      (insert (format "%s:%s:%s: %s: %s\n" filename line col (upcase type) description)))))

(add-hook 'after-save-hook #'eclim--problems-update-maybe)

(provide 'eclim-problems)
