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
(load-theme 'adwaita t)

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

;; Toggle Features
(defvar clojure-toggled            t "Add clojure support")
(defvar cider-toggled              t "Add cider support")
(defvar paredit-toggled            t "Add paredit support")
(defvar ace-window-toggled         t "Add ace-window support")
(defvar treemacs-toggled           t "Add treemacs support")
(defvar ivy-toggled                t "Add ivy support")
(defvar which-key-toggled          t "Add which-key support")
(defvar counsel-toggled            t "Add counsel support")
(defvar mc-toggled                 t "Add multiple-cursors support")
(defvar dap-mode-toggled           t "Add dap-mode support")
(defvar rainbow-delimiters-toggled t "Add rainbow-delimiters support")
(defvar lsp-toggled                t "Add lsp support")

;; Features
(when counsel-toggled
  (use-package counsel-projectile
    :ensure t
    :config
    (require 'counsel-projectile)
    (counsel-projectile-mode)
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    (global-set-key (kbd "C-c p A") 'projectile-add-known-project)))

(when which-key-toggled
  (use-package which-key :ensure t :config (which-key-mode)))

(when ivy-toggled
  (use-package ivy
    :ensure t
    :config
    (ivy-mode)
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)))

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
	   (lsp-mode . lsp-enable-which-key-integration))
    :commands lsp)

  (use-package lsp-ui :commands lsp-ui-mode)
  (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
  (use-package lsp-treemacs :commands lsp-treemacs-errors-list))

(when mc-toggled
  (use-package multiple-cursors
    :ensure t
    :config
    (global-set-key (kbd "s-d") 'mc/mark-next-like-this)))









































(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("2ebd6217d74282fe204f58a64adea7d210c60a5cd11e57f9e435b01e35d2b028" "cdb768021bf99e838364dd5e7fc22d9b6f790124c97be379a5bda4f900e50c26" "b15bf9cabdd891f0c163d1b914e901d0d9f8f74ad4075b2b8e68a8f35247f82b" default))
 '(package-selected-packages
   '(xah-fly-keys treemacs-all-the-icons dap-mode clj-refactor rainbow-delimiters cider clojure-ts-mode testcover-mark-line smex counsel-projectile which-key persp-projectile persp-mode dashboard all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
