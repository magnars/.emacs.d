;; (defun yt/punch-in ()
;;   (interactive)
;;     (org-with-point-at (org-id-find "1b586ec1-fa8a-4bd1-a44c-faf3aa2adf51" 'marker)
;;     (org-clock-in)
;;      ))
;; ;; (global-set-key (kbd "<f9> I") 'yt/punch-in)

;; (defun my/modify-org-done-face ()
;;   (setq org-fontify-done-headline t)
;;   (set-face-attribute 'org-done nil :strike-through t)
;;   (set-face-attribute 'org-headline-done nil
;;                       :strike-through t
;;                       :foreground "light gray"))
;; (add-hook 'org-mode-hook 'my/modify-org-done-face)
;; (setq org-fontify-done-headline t)
;; (set-face-attribute 'org-done nil :strike-through t)
;; (set-face-attribute 'org-headline-done nil :strike-through t)

;; (setq org-archive-location "::* Archived Tasks") ;;in-file archive
;; (setq org-habit-show-habits nil)
;; (setq org-agenda-span 'week)

;; (sp-local-pair 'org-mode "=" "=") ; select region, hit = then region -> =region= in org-mode
;; (sp-local-pair 'org-mode "*" "*") ; select region, hit * then region -> *region* in org-mode
;; (sp-local-pair 'org-mode "/" "/") ; select region, hit / then region -> /region/ in org-mode
;; (sp-local-pair 'org-mode "_" "_") ; select region, hit _ then region -> _region_ in org-mode
;; (sp-local-pair 'org-mode "+" "+") ; select region, hit + then region -> +region+ in org-mode

;; (set-face-attribute 'org-mode-line-clock nil
;;                     :weight 'bold :box '(:line-width 1 :color "#FFBB00") :foreground "white" :background "#FF4040")
;; (setq org-reverse-note-order t) ;; refiled headline will be the first under the taget

(setq org-confirm-babel-evaluate t)

;; Remove the markup characters, i.e., "/text/" becomes (italized) "text"
(setq org-hide-emphasis-markers t)

;; for \cite{key}
;; (require 'ox-bibtex)
