(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
(require 'powerline)

(setq powerline-arrow-shape 'arrow)

(custom-set-faces
 '(mode-line ((t (:foreground "#030303" :background "#bdbdbd" :box nil))))
 '(mode-line-inactive ((t (:foreground "#f9f9f9" :background "#666666" :box nil)))))

(provide 'setup-powerline)
