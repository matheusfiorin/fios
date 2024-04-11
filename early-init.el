
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

(setq dashboard-icon-type 'all-the-icons)
(setq dashboard-banner-logo-title "A minimal and extensible flavour ~")
(setq dashboard-startup-banner "~/.emacs.d/assets/logo-no-background.svg")
(setq dashboard-center-content t)
(setq dashboard-vertically-center-content t)

(setq dashboard-items '((recents   . 5)
                        (bookmarks . 5)
                        (projects  . 5)))
