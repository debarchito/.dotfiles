;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; UI
(add-to-list 'custom-theme-load-path "~/.cache/emacs/themes")
(setq doom-theme 'dankcolors)
(setq display-line-numbers-type 'relative)
(setq doom-font (font-spec :family "Maple Mono NF" :size 14.0)
      doom-variable-pitch-font (font-spec :family "Maple Mono NF" :size 14.0))
(add-to-list 'default-frame-alist '(font . "Maple Mono NF-15:cv01=1:cv61=1:calt=0:zero=0:cv02=0"))

;; Editing
(setq-default visual-fill-column-width 90
              word-wrap t)
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'prog-mode-hook #'visual-line-mode)
(add-hook 'prog-mode-hook #'rainbow-mode)
(setq scroll-conservatively 101
      scroll-margin 1)

;; Meow
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   '("j" . "H-j")
   '("k" . "H-k")
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("1" . meow-expand-1)
   '("2" . meow-expand-2)
   '("3" . meow-expand-3)
   '("4" . meow-expand-4)
   '("5" . meow-expand-5)
   '("6" . meow-expand-6)
   '("7" . meow-expand-7)
   '("8" . meow-expand-8)
   '("9" . meow-expand-9)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(use-package! meow
  :config
  (meow-setup)
  (meow-global-mode 1))

;; Completion
(after! company
  (setq company-idle-delay 0.2))
(map! :i "C-SPC" #'company-complete)

;; Indent bars
(use-package! indent-bars
  :hook (prog-mode . indent-bars-mode)
  :config
  (setq indent-bars-pattern "."
        indent-bars-width-frac 0.15
        indent-bars-pad-frac 0.1
        indent-bars-zigzag nil
        indent-bars-display-on-blank-lines t))

;; Tabs
(after! centaur-tabs
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 28
        centaur-tabs-set-bar 'under
        centaur-tabs-show-count nil))

;; Direnv
(after! envrc
  (envrc-global-mode))

;; LSP
(after! eglot
  (setq eglot-ignored-server-capabilities '())
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (eglot-inlay-hints-mode 1))))

;; Modeline
(after! doom-modeline
  (setq doom-modeline-buffer-file-name-style 'truncate-from-project
        doom-modeline-vcs-max-length 24
        doom-modeline-buffer-encoding t
        doom-modeline-check-simple-format nil))

;; Flymake
(after! flymake
  (setq flymake-show-diagnostics-at-end-of-line 'short))

;; Vertico
(after! vertico
  (setq completion-ignored-extensions nil))

;; Projectile
(after! projectile
  (setq projectile-globally-ignored-directories nil))

;; Keybindings
(map! "M-j"
      (cmd!
       (let ((col (current-column)))
         (forward-line 1)
         (transpose-lines 1)
         (forward-line -1)
         (move-to-column col)))
      "M-k"
      (cmd!
       (let ((col (current-column)))
         (transpose-lines 1)
         (forward-line -2)
         (move-to-column col)))
      "C-a"
      (cmd!
       (dolist (buf (buffer-list))
         (with-current-buffer buf
           (when (and buffer-file-name (not (buffer-modified-p)))
             (revert-buffer t t t)))))
      "C-i" #'eglot-inlay-hints-mode
      "C-r" (cmd! (revert-buffer t t t)))
