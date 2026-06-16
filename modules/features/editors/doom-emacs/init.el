(doom! :completion
       vertico

       :ui
       doom
       dashboard
       modeline
       nav-flash
       ophints
       (popup +defaults)
       tabs
       window-select

       :editor
       smartparens

       :emacs
       undo

       :term
       eshell
       vterm

       :os
       (tty +osc)

       :lang
       emacs-lisp
       (nix +lsp)
       (rust +lsp)
       (ocaml +lsp)

       :tools
       direnv
       (lsp +eglot)

       :config
       (default +smartparens))
