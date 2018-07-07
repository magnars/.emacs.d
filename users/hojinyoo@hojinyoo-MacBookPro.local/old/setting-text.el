;; ;; check spelling
;; (add-hook 'text-mode-hook 'flyspell-mode)
;; (add-hook 'org-mode-hook 'flyspell-mode)
;; (setq ispell-dictionary "british"
;;       ispell-extra-args '() ;; TeX mode "-t"
;;       ispell-silently-savep t)
;; (if (eq system-type 'darwin)
;;     (setq ispell-program-name "/usr/local/bin/aspell")
;;   (setq ispell-program-name "/usr/bin/aspell"))
;; ;; (setq ispell-personal-dictionary "~/git/.emacs.d/personal/ispell-dict")
;; ;; add personal dictionary

;; ;; [2014-12-25 Thu 22:21]
;; (defun yt/write-mode ()
;;   (interactive)
;;   (hl-sentence-mode)
;;   (variable-pitch-mode)
;;   (nanowrimo-mode))

;; ;; word count
;; ;; https://bitbucket.org/gvol/nanowrimo.el
;; (require 'org-wc)
;; (require 'nanowrimo)
;; (setq nanowrimo-today-goal 500)


;; ;; [2014-12-23 Tue 22:06]
;; ;; Highlight sentence
;; ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Attribute-Functions.html
;; (require 'hl-sentence)
;; (add-hook 'nanowrimo-mode 'hl-sentence-mode)
;; (set-face-attribute 'hl-sentence-face nil
;;                     ;; :foreground "black")
;;                     :foreground "white")
;; (add-hook 'nanowrimo-mode 'variable-pitch-mode)
;; (set-face-attribute 'variable-pitch nil
;;                     :foreground "gray40")

;; ;; [2015-02-12 Thu 21:14]
;; ;; https://github.com/rootzlevel/synosaurus
;; ;; synosaurus-lookup
;; ;; synosaurus-choose-and-replace
;; ;; brew install wordnet
;; (require 'synosaurus)
;; (setq synosaurus-choose-method "popup")

;; ;; synosaurus-lookup C-c s l
;; ;; synosaurus-choose-and-replace C-c s r
;; (setq synosaurus-backend 'synosaurus-backend-wordnet)
;; (setq synosaurus-choose-method 'popup)

;; (defun my-text-abbrev-expand-p ()
;;   "Return t if the abbrev is in a text context, which is: in
;;  comments and strings only when in a prog-mode derived-mode or
;;  src block in org-mode, and anywhere else."
;;   (if (or (derived-mode-p 'prog-mode)
;;           (and (eq major-mode 'org-mode)
;;                (org-in-src-block-p 'inside)))
;;       (nth 8 (syntax-ppss))
;;     t))

;; (define-abbrev-table 'my-text-abbrev-table ()
;;   "Abbrev table for text-only abbrevs. Expands only in comments and strings."
;;   :enable-function #'my-text-abbrev-expand-p)

;; (dolist (table (list text-mode-abbrev-table
;;                      prog-mode-abbrev-table))
;;   (abbrev-table-put table
;;                     :parents (list my-text-abbrev-table)))

;; (defun my-text-abbrev-table-init (abbrevs-org-list)
;;   "Parse 'name: expansion' pairs from an org list and insert into abbrev table."
;;   (message "Creating text-abbrev table...")
;;   (dolist (abbrev abbrevs-org-list)
;;     (let ((name (nth 0 abbrev))
;;           (expansion (nth 1 abbrev)))
;;       ;; (print (cons name expansion))
;;       (define-abbrev my-text-abbrev-table name expansion nil :system t))))
;; (my-text-abbrev-table-init my-text-abbrevs)
