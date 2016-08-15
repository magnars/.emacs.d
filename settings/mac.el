;; change command to meta, and ignore option to use weird Norwegian keyboard
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
(setq ns-function-modifier 'hyper)

;; Setup environment variables from the user's shell.
(require-package 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; Norwegian mac-keyboard alt-keys)
;; (define-key key-translation-map (kbd "s-8") (kbd "["))
;; (define-key key-translation-map (kbd "s-(") (kbd "{"))
;; (define-key key-translation-map (kbd "s-9") (kbd "]"))
;; (define-key key-translation-map (kbd "s-)") (kbd "}"))
;; (define-key key-translation-map (kbd "s-7") (kbd "|"))
;; (define-key key-translation-map (kbd "s-/") (kbd "\\"))
;; (define-key key-translation-map (kbd "M-s-7") (kbd "M-|"))

;; (global-set-key (kbd "s-u") 'universal-argument)
;; (global-set-key (kbd "s--") 'negative-argument)
;; (--dotimes 5 (global-set-key (read-kbd-macro (format "s-%d" it)) 'digit-argument))

;; redefine read-char, at least for invocation from elisp
(defun read-char (&optional prompt) ;; (inherit-input-method seconds)
  "Read a character from the command input (keyboard or macro).
   It is returned as a number.
   If the character has modifiers, they are resolved and reflected to the
   character code if possible (e.g. C-SPC -> 0).

   If the user generates an event which is not a character (i.e. a mouse
   click or function key event), `read-char' signals an error.  As an
   exception, switch-frame events are put off until non-character events
   can be read.
   If you want to read non-character events, or ignore them, call
   `read-event' or `read-char-exclusive' instead.

   If the optional argument PROMPT is non-nil, display that as a prompt.
   If the optional argument INHERIT-INPUT-METHOD is non-nil and some
   input method is turned on in the current buffer, that input method
   is used for reading a character.
   If the optional argument SECONDS is non-nil, it should be a number
   specifying the maximum number of seconds to wait for input.  If no
   input arrives in that time, return nil.  SECONDS may be a
   floating-point value."
  ;; if (! NILP (prompt))
  ;;   message_with_string ("%s", prompt, 0);
  ;; val = read_filtered_event (1, 1, 1, ! NILP (inherit_input_method),
  ;;                            seconds);
  ;; return (NILP (val) ? Qnil
  ;;         : make_number (char_resolve_modifier_mask (XINT (val))));
  (let ((inherit-input-method nil) (seconds nil))
    ;; `read-key' doesn't explicitly inhibit the input method, but in
    ;; practice it disables at least quail input methods because it
    ;; binds overriding-terminal-local-map.
    (if inherit-input-method (error "Not implemented"))
    (catch 'read-char-exclusive
      (let ((timer (when seconds
                     (run-with-timer seconds nil
                                     (lambda ()
                                       (throw 'read-char-exclusive nil))))))
        (unwind-protect
            (let ((event (read-key prompt)))
              (if (numberp event)
                  event
                (setq unread-command-events
                      (nconc (mapcar 'identity (this-single-command-raw-keys))
                             unread-command-events))
                (error "Non-character input-event")))
          (when timer (cancel-timer timer)))))))

;; mac friendly font
;; (when window-system
;;   (setq magnars/default-font "-apple-Monaco-medium-normal-normal-*-16-*-*-*-m-0-iso10646-1")
;;   (setq magnars/presentation-font "-apple-Monaco-medium-normal-normal-*-21-*-*-*-m-0-iso10646-1")
;;   (set-face-attribute 'default nil :font magnars/default-font))

;; keybinding to toggle full screen mode
;; (global-set-key (quote [M-f10]) (quote ns-toggle-fullscreen))

;; Move to trash when deleting stuff
(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash/emacs")

;; Ignore .DS_Store files with ido mode
;; (add-to-list 'ido-ignore-files "\\.DS_Store")

;; Don't open files from the workspace in a new frame
(setq ns-pop-up-frames nil)

;; Use aspell for spell checking: brew install aspell --lang=en
(setq ispell-program-name "/usr/local/bin/aspell")

;; Open files
(defun mac-open-current-file ()
  (interactive)
  (shell-command (concat "open " (buffer-file-name))))

(global-set-key (kbd "C-c C-S-o") 'mac-open-current-file)

;; fix osx weirdness with magit avatars

(setq-default magit-revision-use-gravatar-kludge t)

(provide 'mac)
