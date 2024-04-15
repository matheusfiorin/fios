;; Package Management with 'use-package'
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; UI Customization
(menu-bar-mode -1)   ;; Remove the menu bar
(tool-bar-mode -1)   ;; Remove the tool bar
(scroll-bar-mode -1) ;; Remove scroll bars
(set-fringe-mode nil) ;; Optionally remove fringes if you don't use them

;; Theme
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config (load-theme 'sanityinc-tomorrow-day t))
(set-face-attribute 'default nil :family "Fantasque Sans Mono" :height 160)

;; Essential Packages
(use-package projectile :ensure t)
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
(use-package all-the-icons
  :ensure t
  :config
  (use-package treemacs-all-the-icons
    :ensure t))

;; Bookmark bindings
(global-set-key (kbd "C-c C-c C-s") 'bookmark-set)
(global-set-key (kbd "C-c C-c C-j") 'bookmark-jump)
(global-set-key (kbd "C-c C-c C-d") 'bookmark-)

;; Toggle Features
(defvar clojure-toggled            t "Add clojure support")
(defvar cider-toggled              t "Add cider support")
(defvar paredit-toggled            t "Add paredit support")
(defvar ace-window-toggled         t "Add ace-window support")
(defvar treemacs-toggled           t "Add treemacs support")
(defvar ivy-toggled                t "Add ivy support")
(defvar which-key-toggled          t "Add which-key support")
(defvar projectile-toggled         t "Add counsel and projectile support")
(defvar mc-toggled                 t "Add multiple-cursors support")
(defvar dap-mode-toggled           t "Add dap-mode support")
(defvar rainbow-delimiters-toggled t "Add rainbow-delimiters support")
(defvar lsp-toggled                t "Add lsp support")

;; Features
(when projectile-toggled
  (use-package ripgrep
    :ensure t
    :config
    (use-package projectile
      :ensure t
      :config
      (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
      (global-set-key (kbd "C-c p A") 'projectile-add-known-project)
      (global-set-key (kbd "C-c k") 'counsel-projectile-ag)
      (global-set-key (kbd "M-x") 'smex)
      (projectile-mode)
      (use-package projectile-ripgrep
	:ensure t
	:config
	(use-package smex
	  :ensure t)))))

(when which-key-toggled
  (use-package which-key :ensure t :config (which-key-mode)))

(when ivy-toggled
  (use-package vertico
    :ensure t
    :init
    (vertico-mode)
    (setq vertico-count 20)
    (setq vertico-resize t)
    (setq vertico-cycle t))

  (keymap-set vertico-map "TAB" #'minibuffer-complete)
  
  (use-package savehist
    :init
    (savehist-mode))

  (use-package emacs
    :init
    (defun crm-indicator (args)
      (cons (format "[CRM%s] %s"
                    (replace-regexp-in-string
                     "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                     crm-separator)
                    (car args))
            (cdr args)))
    (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

    (setq minibuffer-prompt-properties
          '(read-only t cursor-intangible t face minibuffer-prompt))
    (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
    (setq enable-recursive-minibuffers t)
    (setq read-extended-command-predicate #'command-completion-default-include-p))
  (use-package marginalia
    :ensure t
    :bind (:map minibuffer-local-map
		("M-A" . marginalia-cycle))
    :init
    (marginalia-mode))
  (use-package orderless
    :ensure t
    :init
    (setq completion-styles '(substring orderless basic)
          completion-category-defaults nil
          completion-category-overrides '((file (styles partial-completion))))))

(when treemacs-toggled
  (use-package treemacs :ensure t)
  (use-package treemacs-projectile
    :ensure t
    :after treemacs
    :config
    (global-set-key (kbd "C-c o p") 'treemacs)
    (global-set-key (kbd "C-c o r") 'treemacs-add-and-display-current-project-exclusively)
    (global-set-key (kbd "C-c C--") 'treemacs-select-window)))

(when ace-window-toggled
  (use-package ace-window :ensure t :bind ("C-x o" . ace-window)))

(when dap-mode-toggled (use-package dap-mode :ensure t))
(when cider-toggled
  (use-package cider :ensure t))
(when rainbow-delimiters-toggled
  (use-package rainbow-delimiters
    :ensure t
    :config
    (use-package clj-refactor :ensure t)))
(when clojure-toggled
  (use-package paredit
    :ensure t
    :config
    (use-package clojure-mode
      :ensure t
      :config
      (use-package clojure-ts-mode
	:ensure t
	:config
	(add-hook 'clojure-ts-mode-hook #'cider-mode)
	(add-hook 'clojure-ts-mode-hook #'enable-paredit-mode)
	(add-hook 'clojure-ts-mode-hook #'rainbow-delimiters-mode)
	(add-hook 'clojure-ts-mode-hook #'clj-refactor-mode)))))

(when lsp-toggled
  (use-package lsp-mode
    :init
    (setq lsp-keymap-prefix "C-c l")
    :hook ((clojure-mode . lsp)
	   (clojure-ts-mode . lsp)
	   (lsp-mode . lsp-enable-which-key-integration))
    :commands lsp)

  (use-package lsp-ui :ensure t :commands lsp-ui-mode)
  (use-package lsp-treemacs :commands lsp-treemacs-errors-list))

(when mc-toggled
  (use-package multiple-cursors
    :ensure t
    :config
    (global-set-key (kbd "s-d") 'mc/mark-next-like-this)))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         
   ("M-." . embark-dwim)        
   ("C-h B" . embark-bindings)) 
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
(use-package consult
  :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   :preview-key '(:debounce 0.4 any))

  (setq consult-narrow-key "<"))







































(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d77d6ba33442dd3121b44e20af28f1fae8eeda413b2c3d3b9f1315fbda021992" "efcecf09905ff85a7c80025551c657299a4d18c5fcfedd3b2f2b6287e4edd659" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "524fa911b70d6b94d71585c9f0c5966fe85fb3a9ddd635362bfabd1a7981a307" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "57a29645c35ae5ce1660d5987d3da5869b048477a7801ce7ab57bfb25ce12d3e" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "714ab222604a0555b118f1c37d60a9e233a8d84a49349a3443485a62d06079c2" "2ebd6217d74282fe204f58a64adea7d210c60a5cd11e57f9e435b01e35d2b028" "cdb768021bf99e838364dd5e7fc22d9b6f790124c97be379a5bda4f900e50c26" "b15bf9cabdd891f0c163d1b914e901d0d9f8f74ad4075b2b8e68a8f35247f82b" default))
 '(package-selected-packages
   '(catppuccin-theme ag lsp-ui embark-consult embark consult marginalia orderless vertico projectile-ripgrep ripgrep color-theme-sanityinc-tomorrow solarized-theme wildcharm-light-theme xah-fly-keys treemacs-all-the-icons dap-mode clj-refactor rainbow-delimiters cider clojure-ts-mode testcover-mark-line smex counsel-projectile which-key persp-projectile persp-mode dashboard all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
