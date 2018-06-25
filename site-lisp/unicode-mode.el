(defun unicode-mode-insert-help ()
  "Insert the list of currently mapped keys"
  (interactive)
  (insert "Unicode-mode key mappings:\n")
  (insert "\th: ♥\n")
  (insert "\tb: 💣\n")
  (insert "\tx: ✂\n")
  (insert "\ts: ☻\n")
  (insert "\tf: ⚐\n")
  (insert "\td: ⚠\n")
  (insert "\tl: ⚡\n")
  (insert "\t*: ★\n")
  (insert "\ty: ☯\n")
  (insert "\tp: ☮\n")
  (insert "\tr: ♻\n")
  (insert "\tv: ✔\n")
  (insert "\tz: 💤\n")
  (insert "\tk: ⌨\n")
  (insert "\t-: ⛔\n")
  (insert "\tw: ☠\n")
  (insert "\t|: │\n")
  (insert "\t-: ─\n")
  (insert "\t1: ┐\n")
  (insert "\t2: ┘\n")
  (insert "\t3: └\n")
  (insert "\t4: ┌\n")
  (insert "\t?: Show help (this)\n")
  )

(define-minor-mode unicode-mode "Unicode art mode"
  :lighter " Unicode"
  :global nil
  :keymap (let ((unicode-mode-keymap (make-sparse-keymap)))
            (define-key unicode-mode-keymap (kbd "h") (lambda () (interactive) (insert "♥")))  ;; heart
            (define-key unicode-mode-keymap (kbd "b") (lambda () (interactive) (insert "💣"))) ;; bomb
            (define-key unicode-mode-keymap (kbd "x") (lambda () (interactive) (insert "✂")))  ;; x for cut
            (define-key unicode-mode-keymap (kbd "s") (lambda () (interactive) (insert "☻")))  ;; smile
            (define-key unicode-mode-keymap (kbd "f") (lambda () (interactive) (insert "⚐")))  ;; flag
            (define-key unicode-mode-keymap (kbd "d") (lambda () (interactive) (insert "⚠")))  ;; danger
            (define-key unicode-mode-keymap (kbd "l") (lambda () (interactive) (insert "⚡")))  ;; lightning
            (define-key unicode-mode-keymap (kbd "*") (lambda () (interactive) (insert "★")))  ;; star
            (define-key unicode-mode-keymap (kbd "y") (lambda () (interactive) (insert "☯")))  ;; yin
            (define-key unicode-mode-keymap (kbd "p") (lambda () (interactive) (insert "☮")))  ;; peace
            (define-key unicode-mode-keymap (kbd "r") (lambda () (interactive) (insert "♻")))  ;; recycle
            (define-key unicode-mode-keymap (kbd "v") (lambda () (interactive) (insert "✔")))  ;; v for checking off
            (define-key unicode-mode-keymap (kbd "z") (lambda () (interactive) (insert "💤"))) ;; zzz
            (define-key unicode-mode-keymap (kbd "k") (lambda () (interactive) (insert "⌨")))  ;; keyboard
            (define-key unicode-mode-keymap (kbd "-") (lambda () (interactive) (insert "⛔"))) ;; - don't enter
            (define-key unicode-mode-keymap (kbd "w") (lambda () (interactive) (insert "☠")))  ;; word
            (define-key unicode-mode-keymap (kbd "|") (lambda () (interactive) (insert "│")))
            (define-key unicode-mode-keymap (kbd "-") (lambda () (interactive) (insert "─")))
            (define-key unicode-mode-keymap (kbd "1") (lambda () (interactive) (insert "┐")))  ;; first corner, CSS style
            (define-key unicode-mode-keymap (kbd "2") (lambda () (interactive) (insert "┘")))  ;; second corner, CSS style
            (define-key unicode-mode-keymap (kbd "3") (lambda () (interactive) (insert "└")))  ;; third corner, CSS style
            (define-key unicode-mode-keymap (kbd "4") (lambda () (interactive) (insert "┌")))  ;; fourth corner, CSS style
            (define-key unicode-mode-keymap (kbd "?") 'unicode-mode-insert-help)
            unicode-mode-keymap))

(global-set-key (kbd "<f12>") 'unicode-mode)

(provide 'unicode-mode)
