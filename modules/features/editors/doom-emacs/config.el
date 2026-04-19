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

;; HEL (Helix Emacs Lateral) - Helix-like keybindings
(use-package! hel
  :config
  (hel-mode 1))

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
      "C-r" #'undo-fu-only-redo
      "C-S-r" (cmd! (revert-buffer t t t)))
