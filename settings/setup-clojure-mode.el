(require 'clojure-mode)
(require 'clojure-mode-extra-font-locking)

(defadvice clojure-test-run-tests (before save-first activate)
  (save-buffer))

(defadvice nrepl-load-current-buffer (before save-first activate)
  (save-buffer))

(require 'clj-refactor)

(setq cljr-favor-prefix-notation nil)
(setq cljr-favor-private-functions nil)

(cljr-add-keybindings-with-modifier "C-s-")
(define-key clj-refactor-map (kbd "C-x C-r") 'cljr-rename-file)

(define-key clojure-mode-map [remap paredit-forward] 'clojure-forward-logical-sexp)
(define-key clojure-mode-map [remap paredit-backward] 'clojure-backward-logical-sexp)

;;(setq cider-pprint-fn 'pprint)

(require 'core-async-mode)

(defun enable-clojure-mode-stuff ()
  (clj-refactor-mode 1)
  (when (not (s-ends-with-p "/dev/user.clj" (buffer-file-name)))
    (core-async-mode 1)))

(add-hook 'clojure-mode-hook 'enable-clojure-mode-stuff)

(require 'symbol-focus)
(define-key clojure-mode-map (kbd "M-s-f") 'sf/focus-at-point)

(defun clj-duplicate-top-level-form ()
  (interactive)
  (save-excursion
    (cljr--goto-toplevel)
    (insert (cljr--extract-sexp) "\n")
    (cljr--just-one-blank-line)))

(define-key clojure-mode-map (kbd "M-s-d") 'clj-duplicate-top-level-form)

(add-to-list 'cljr-project-clean-functions 'cleanup-buffer)

(define-key clojure-mode-map (kbd "C->") 'cljr-thread)
(define-key clojure-mode-map (kbd "C-<") 'cljr-unwind)

(define-key clojure-mode-map (kbd "s-j") 'clj-jump-to-other-file)

(define-key clojure-mode-map (kbd "C-.") 'clj-hippie-expand-no-case-fold)

(defun clj-hippie-expand-no-case-fold ()
  (interactive)
  (let ((old-syntax (char-to-string (char-syntax ?/))))
    (modify-syntax-entry ?/ " ")
    (hippie-expand-no-case-fold)
    (modify-syntax-entry ?/ old-syntax)))

(require 'cider)

(define-key cider-repl-mode-map (kbd "<home>") nil)
(define-key cider-repl-mode-map (kbd "C-,") 'complete-symbol)
(define-key cider-repl-mode-map (kbd "C-c C-l") 'cider-repl-clear-buffer)
(define-key cider-mode-map (kbd "C-,") 'complete-symbol)
(define-key cider-mode-map (kbd "C-c C-q") 'nrepl-close)
(define-key cider-mode-map (kbd "C-c C-Q") 'cider-quit)
(define-key cider-mode-map (kbd "C-c C-l") 'cider-repl-clear-buffer)

(defun cider-repl-command (cmd)
  (set-buffer (cider-current-repl-buffer))
  (goto-char (point-max))
  (insert cmd)
  (cider-repl-return))

(defun cider-repl-restart ()
  "Assumes that tools.namespace is used to reload everything on
   the classpath (which is why we save buffers first)"
  (interactive)
  (save-some-buffers)
  (cider-repl-command "(user/reset!)"))

(defun cider-repl-compile-and-restart ()
  "Compile the current file and restart the app"
  (interactive)
  (cider-load-current-buffer)
  (cider-repl-command "(user/restart!)"))

(defun cider-repl-run-clj-test ()
  "Run the clojure.test tests in the current namespace"
  (interactive)
  (cider-load-current-buffer)
  (cider-repl-command "(run-tests)"))

(define-key cider-mode-map (kbd "C-c M-r") 'cider-repl-reset)
(define-key cider-mode-map (kbd "C-c M-k") 'cider-repl-compile-and-restart)
(define-key cider-mode-map (kbd "C-c t") 'cider-repl-run-clj-test)

(require 'yesql-ghosts)

;; indent [quiescent.dom :as d] specially

(define-clojure-indent
  (d/a 1)
  (d/button 1)
  (d/div 1)
  (d/form 1)
  (d/h1 1)
  (d/h2 1)
  (d/h3 1)
  (d/h4 1)
  (d/h5 1)
  (d/hr 1)
  (d/img 1)
  (d/label 1)
  (d/li 1)
  (d/option 1)
  (d/p 1)
  (d/pre 1)
  (d/select 1)
  (d/small 1)
  (d/span 1)
  (d/strong 1)
  (d/ul 1)
  (d/svg 1)
  (d/g 1)
  (d/table 1)
  (d/tbody 1)
  (d/thead 1)
  (d/tr 1)
  (d/td 1)
  (d/linearGradient 1)
  (dd/measure! 2)
  (dog/measure! 2)
  (e/prose 1)
  (e/value 1)
  (e/section 1)
  (e/section-prose 1)
  (e/section-header 1)
  (e/page 1)
  (e/instructions 1)
  (e/setup-header 1)
  (l/padded 1)
  (l/lightly-padded 1)
  (l/padded-all 1)
  (l/bubble-grid 1)
  (l/slider 1)
  (l/bottom-fixed 1)
  (l/centered 1)
  (c/box 1)
  (c/square 1)
  (c/box-with-subsection 1)
  (c/embossed-section 1)
  (c/embossed 1)
  (c/group 1)
  (c/list 1)
  (c/split 1)

  (add-watch 2)
  (async 1))

;; Don't warn me about the dangers of clj-refactor, fire the missiles!
(setq cljr-warn-on-eval nil)

;; Use figwheel for cljs repl

(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; Indent and highlight more commands
(put-clojure-indent 'match 'defun)

;; Hide nrepl buffers when switching buffers (switch to by prefixing with space)
(setq nrepl-hide-special-buffers t)

;; Enable error buffer popping also in the REPL:
(setq cider-repl-popup-stacktraces t)

;; Specify history file
(setq cider-history-file "~/.emacs.d/nrepl-history")

;; auto-select the error buffer when it's displayed
(setq cider-auto-select-error-buffer t)

;; Prevent the auto-display of the REPL buffer in a separate window after connection is established
(setq cider-repl-pop-to-buffer-on-connect nil)

;; Pretty print results in repl
(setq cider-repl-use-pretty-printing t)

;; Don't prompt for symbols
(setq cider-prompt-for-symbol nil)

;; Enable eldoc in Clojure buffers
(add-hook 'cider-mode-hook #'eldoc-mode)

;; Some expectations features

(require 'clj-autotest)

(defun my-toggle-expect-focused ()
  (interactive)
  (save-excursion
    (search-backward "(expect" (cljr--point-after 'cljr--goto-toplevel))
    (forward-word)
    (if (looking-at "-focused")
        (paredit-forward-kill-word)
      (insert "-focused"))))

(defun my-remove-all-focused ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "(expect-focused" nil t)
      (delete-char -8))))

(define-key clj-refactor-map
  (cljr--key-pairs-with-modifier "C-s-" "xf") 'my-toggle-expect-focused)

(define-key clj-refactor-map
  (cljr--key-pairs-with-modifier "C-s-" "xr") 'my-remove-all-focused)

;; Cycle between () {} []

(defun live-delete-and-extract-sexp ()
  "Delete the sexp and return it."
  (interactive)
  (let* ((begin (point)))
    (forward-sexp)
    (let* ((result (buffer-substring-no-properties begin (point))))
      (delete-region begin (point))
      result)))

(defun live-cycle-clj-coll ()
  "convert the coll at (point) from (x) -> {x} -> [x] -> (x) recur"
  (interactive)
  (let* ((original-point (point)))
    (while (and (> (point) 1)
                (not (equal "(" (buffer-substring-no-properties (point) (+ 1 (point)))))
                (not (equal "{" (buffer-substring-no-properties (point) (+ 1 (point)))))
                (not (equal "[" (buffer-substring-no-properties (point) (+ 1 (point))))))
      (backward-char))
    (cond
     ((equal "(" (buffer-substring-no-properties (point) (+ 1 (point))))
      (insert "{" (substring (live-delete-and-extract-sexp) 1 -1) "}"))
     ((equal "{" (buffer-substring-no-properties (point) (+ 1 (point))))
      (insert "[" (substring (live-delete-and-extract-sexp) 1 -1) "]"))
     ((equal "[" (buffer-substring-no-properties (point) (+ 1 (point))))
      (insert "(" (substring (live-delete-and-extract-sexp) 1 -1) ")"))
     ((equal 1 (point))
      (message "beginning of file reached, this was probably a mistake.")))
    (goto-char original-point)))

(define-key clojure-mode-map (kbd "C-`") 'live-cycle-clj-coll)

;; Warn about missing nREPL instead of doing stupid things

(defun nrepl-warn-when-not-connected ()
  (interactive)
  (message "Oops! You're not connected to an nREPL server. Please run M-x cider or M-x cider-jack-in to connect."))

(define-key clojure-mode-map (kbd "C-M-x")   'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-x C-e") 'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-c C-e") 'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-c C-l") 'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-c C-r") 'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-c C-z") 'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-c C-k") 'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-c C-n") 'nrepl-warn-when-not-connected)
(define-key clojure-mode-map (kbd "C-c C-q") 'nrepl-warn-when-not-connected)

(setq cljr-magic-require-namespaces
      '(("io"   . "clojure.java.io")
        ("set"  . "clojure.set")
        ("str"  . "clojure.string")
        ("walk" . "clojure.walk")
        ("zip"  . "clojure.zip")
        ("time" . "clj-time.core")
        ("log"  . "clojure.tools.logging")
        ("json" . "cheshire.core")))

;; refer all from expectations

(setq cljr-expectations-test-declaration "[expectations :refer :all]")

;; Add requires to blank devcards files

(defun cljr--find-source-ns-of-devcard-ns (test-ns test-file)
  (let* ((ns-chunks (split-string test-ns "[.]" t))
         (test-name (car (last ns-chunks)))
         (src-dir-name (s-replace "devcards/" "src/" (file-name-directory test-file)))
         (replace-underscore (-partial 's-replace "_" "-"))
         (src-ns (car (--filter (or (s-prefix-p it test-name)
                                    (s-suffix-p it test-name))
                                (-map (lambda (file-name)
                                        (funcall replace-underscore
                                                 (file-name-sans-extension file-name)))
                                      (directory-files src-dir-name))))))
    (when src-ns
      (mapconcat 'identity (append (butlast ns-chunks) (list src-ns)) "."))))

(defun clj--find-devcards-component-name ()
  (or
   (ignore-errors
     (with-current-buffer
         (find-file-noselect (clj--src-file-name-from-cards (buffer-file-name)))
       (save-excursion
         (goto-char (point-max))
         (search-backward "defcomponent ")
         (clojure-forward-logical-sexp)
         (skip-syntax-forward " ")
         (let ((beg (point))
               (end (progn (re-search-forward "\\w+")
                           (point))))
           (buffer-substring-no-properties beg end)))))
   ""))

(defun cljr--add-card-declarations ()
  (save-excursion
    (let* ((ns (clojure-find-ns))
           (source-ns (cljr--find-source-ns-of-devcard-ns ns (buffer-file-name))))
      (cljr--insert-in-ns ":require")
      (when source-ns
        (insert "[" source-ns " :refer [" (clj--find-devcards-component-name) "]]"))
      (cljr--insert-in-ns ":require")
      (insert (if (cljr--project-depends-on-p "reagent")
                  "[devcards.core :refer-macros [defcard-rg]]"
                "[devcards.core :refer-macros [defcard]]")))
    (indent-region (point-min) (point-max))))

(defun cljr--add-ns-if-blank-clj-file ()
  (ignore-errors
    (when (and cljr-add-ns-to-blank-clj-files
               (cljr--clojure-ish-filename-p (buffer-file-name))
               (= (point-min) (point-max)))
      (insert (format "(ns %s)\n\n" (clojure-expected-ns)))
      (when (cljr--in-tests-p)
        (cljr--add-test-declarations))
      (when (clj--is-card? (buffer-file-name))
        (cljr--add-card-declarations)))))

(defun clojure-mode-indent-top-level-form ()
  (interactive)
  (save-excursion
    (cljr--goto-toplevel)
    (indent-region (point)
                   (progn (paredit-forward) (point)))))

(define-key clojure-mode-map (vector 'remap 'cleanup-buffer) 'clojure-mode-indent-top-level-form)

(defun clojure-mode-paredit-wrap (pre post)
  (unless (looking-back "[ #]" 1)
    (insert " "))
  (let ((beg (point))
        (end nil))
    (insert pre)
    (save-excursion
      (clojure-forward-logical-sexp 1)
      (insert post)
      (setq end (point)))
    (indent-region beg end)))

(defun clojure-mode-paredit-wrap-square ()
  (interactive)
  (clojure-mode-paredit-wrap "[" "]"))

(defun clojure-mode-paredit-wrap-round ()
  (interactive)
  (clojure-mode-paredit-wrap "(" ")"))

(defun clojure-mode-paredit-wrap-curly ()
  (interactive)
  (clojure-mode-paredit-wrap "{" "}"))

(define-key clojure-mode-map (vector 'remap 'paredit-wrap-round) 'clojure-mode-paredit-wrap-round)
(define-key clojure-mode-map (vector 'remap 'paredit-wrap-square) 'clojure-mode-paredit-wrap-square)
(define-key clojure-mode-map (vector 'remap 'paredit-wrap-curly) 'clojure-mode-paredit-wrap-curly)

;; Set up linting of clojure code with eastwood

;; Make sure to add [acyclic/squiggly-clojure "0.1.2-SNAPSHOT"]
;; to your :user :dependencies in .lein/profiles.clj

(require 'flycheck-clojure)

(defun my-cider-mode-enable-flycheck ()
  ;; (when (and (s-ends-with-p ".clj" (buffer-file-name))
  ;;            (not (s-ends-with-p "/dev/user.clj" (buffer-file-name))))
  ;;   (flycheck-mode 1))
  )

(add-hook 'cider-mode-hook 'my-cider-mode-enable-flycheck)

(eval-after-load 'flycheck '(add-to-list 'flycheck-checkers 'clojure-cider-eastwood))

;; Make q quit out of find-usages to previous window config

(defadvice cljr-find-usages (before setup-grep activate)
  (window-configuration-to-register ?$))

;; ------------

;; TODO: Loot more stuff from:
;;  - https://github.com/overtone/emacs-live/blob/master/packs/dev/clojure-pack/config/paredit-conf.el


(provide 'setup-clojure-mode)
