;; Customizations relating to editing a buffer.

;; Key binding to use "hippie expand" for text autocompletion
;; http://www.emacswiki.org/emacs/HippieExpand
(global-set-key (kbd "M-/") 'hippie-expand)

;; Lisp-friendly hippie expand
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

;; Highlights matching parenthesis
(show-paren-mode 1)

;; Highlight current line
;; Disable for now, it causes lag on slow machines.
;; (global-hl-line-mode 1)

;; Interactive search key bindings. By default, C-s runs
;; isearch-forward, so this swaps the bindings.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Don't use hard tabs
(setq-default indent-tabs-mode nil)

;; When you visit a file, point goes to the last place where it
;; was when you previously visited the same file.
;; http://www.emacswiki.org/emacs/SavePlace
(require 'saveplace)
(setq-default save-place t)
;; keep track of saved places in ~/.emacs.d/places
(setq save-place-file (concat user-emacs-directory "places"))

;; Emacs can automatically create backup files. This tells Emacs to
;; put all backups in ~/.emacs.d/backups. More info:
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(setq auto-save-default nil)

;; Enable really easy commenting
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; use 2 spaces for tabs
(defun die-tabs ()
  (interactive)
  (set-variable 'tab-width 2)
  (mark-whole-buffer)
  (untabify (region-beginning) (region-end))
  (keyboard-quit))

;; fix weird os x kill error
(defun ns-get-pasteboard ()
  "Returns the value of the pasteboard, or nil for unsupported formats."
  (condition-case nil
      (ns-get-selection-internal 'CLIPBOARD)
    (quit nil)))

(setq electric-indent-mode nil)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-c q") 'join-line)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)
(global-set-key (kbd "<mouse-2>") 'x-clipboard-yank)

;; Delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun toggle-delete-trailing-whitespace ()
  (interactive)
  (if (member 'delete-trailing-whitespace before-save-hook )
    (progn
      (remove-hook 'before-save-hook 'delete-trailing-whitespace)
      (message "Hook removed."))
    (progn
      (add-hook 'before-save-hook 'delete-trailing-whitespace)
      (message "Hook added."))))

;; Toggling of keys that slow down editing when used.
(defvar slowpoke-keys? nil)

(defun unset-slowpoke-keys ()
  (interactive)
  (global-unset-key (kbd "<left>"))
  (global-unset-key (kbd "<right>"))
  (global-unset-key (kbd "<up>"))
  (global-unset-key (kbd "<down>"))
  (global-unset-key (kbd "<C-left>"))
  (global-unset-key (kbd "<C-right>"))
  (global-unset-key (kbd "<C-up>"))
  (global-unset-key (kbd "<C-down>"))
  (global-unset-key (kbd "<M-left>"))
  (global-unset-key (kbd "<M-right>"))
  (global-unset-key (kbd "<M-up>"))
  (global-unset-key (kbd "<M-down>"))
  (global-unset-key (kbd "<prior>"))
  (global-unset-key (kbd "<next>"))
  (global-unset-key (kbd "<home>"))
  (global-unset-key (kbd "<end>"))
  (global-unset-key (kbd "<insert>"))
  (global-unset-key (kbd "<delete>"))
  (setq slowpoke-keys? nil)
  (message "Unset slowpoke keys."))

(defun set-slowpoke-keys ()
  (interactive)
  (setq slowpoke-keys? nil)
  (global-set-key (kbd "<left>") 'backward-char)
  (global-set-key (kbd "<right>") 'forward-char)
  (global-set-key (kbd "<up>") 'previous-line)
  (global-set-key (kbd "<down>") 'next-line)
  (global-set-key (kbd "<C-left>") 'backward-word)
  (global-set-key (kbd "<C-right>") 'forward-word)
  (global-set-key (kbd "<home>") 'move-beginning-of-line)
  (global-set-key (kbd "<end>") 'move-end-of-line)
  (global-set-key (kbd "<prior>") 'scroll-down-command)
  (global-set-key (kbd "<next>") 'scroll-up-command)
  (setq slowpoke-keys? 1)
  (message "Set slowpoke keys."))

(defun toggle-slowpoke-keys ()
  (interactive)
  (if slowpoke-keys?
    (unset-slowpoke-keys)
    (set-slowpoke-keys)))

;; Bind keys to work like pgup and pgdn
(global-set-key (kbd "M-n") 'scroll-up-command)
(global-set-key (kbd "M-p") 'scroll-down-command)

;; Binds for SSH terminal use
;; (global-set-key (kbd "<deletechar>") 'backward-kill-word)
;; (global-set-key (kbd "TAB") 'indent-for-tab-command)

(global-set-key (kbd "M-i") 'paredit-backward-slurp-sexp)
(global-set-key (kbd "M-o") 'paredit-forward-slurp-sexp)

(global-set-key (kbd "C-M-i") 'paredit-backward-barf-sexp)
(global-set-key (kbd "C-M-o") 'paredit-forward-barf-sexp)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(global-set-key (kbd "<f9>") 'set-selective-display-dlw)

(defun set-selective-display-dlw (&optional level)
"Fold text indented same of more than the cursor.
If level is set, set the indent level to LEVEL.
If 'selective-display' is already set to LEVEL, clicking
F5 again will unset 'selective-display' by setting it to 0."
  (interactive "P")
  (if (eq selective-display (1+ (current-column)))
      (set-selective-display 0)
(set-selective-display (or level (1+ (current-column))))))

(setq tramp-default-method "ssh")
