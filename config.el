(setq user-full-name "Marc Corrales"
      user-mail-address "corralesmarc@gmail.com")

(setq inhibit-startup-message t)

;(setq disabled-command-function nil)

(tool-bar-mode 0)
(menu-bar-mode 1)
(scroll-bar-mode -1)

(setq ring-bell-function 'ignore)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(defalias 'yes-or-no-p 'y-or-n-p)

(defun my-minibuffer-setup-hook ()
 (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(run-at-time (* 5 60) nil
             (lambda ()
               (let ((inhibit-message t))
                 (recentf-save-list))))     
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-save-list/" t)))

(setq-default truncate-lines t)

(defun my/truncate-lines-hook ()
  (setq truncate-lines nil))

(add-hook 'text-mode-hook 'my/truncate-lines-hook)

(use-package edit-server
  :if window-system
  :init
  (add-hook 'after-init-hook 'server-start t)
  (add-hook 'after-init-hook 'edit-server-start t))

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(use-package tango-plus-theme 
:ensure t)

(use-package smart-mode-line
  :ensure t
  :init
  (setq sml/no-confirm-load-theme t)
  (add-hook 'after-init-hook 'sml/setup)
  :config 
  (setq sml/theme 'respectful)
  (setq sml/name-width 44)
  (setq sml/shorten-directory t)
  (setq sml/shorten-modes nil)
  (setq sml/mode-width 'full)
  (setq sml/replacer-regexp-list
        '(("^~/.org/" ":O:")
          ("^~/\\.emacs\\.d/" ":ED:"))))

(use-package spaceline
  :ensure t
  :config
  (require 'spaceline-config)
  (setq spaceline-buffer-encoding-abbrev-p nil)
  (setq spaceline-line-column-p nil)
  (setq spaceline-line-p nil)
  (setq powerline-default-separator (quote arrow))
  (spaceline-spacemacs-theme))

(line-number-mode 1)
(column-number-mode 1)

(setq display-time-24hr-format t)
(setq display-time-format "%H:%M - %d %B %Y")

(display-time-mode 1)

(use-package fancy-battery
  :ensure t
  :config
  (setq fancy-battery-show-percentage t)
  (setq battery-update-interval 15)
  (if window-system
      (fancy-battery-mode)
    (display-battery-mode)))

(when window-system (global-prettify-symbols-mode t))

(when window-system (global-hl-line-mode t))

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

(use-package volatile-highlights
  :ensure t
  :diminish volatile-highlights-mode
  :init
  (add-hook 'after-init-hook 'volatile-highlights-mode))

(use-package org-bullets
 :ensure t
 :config
   (add-hook 'org-mode-hook (lambda () (org-bullets-mode))))

(load-file "~/.emacs.d/secrets.el")

(use-package projectile
  :ensure t
  :init
    (projectile-mode 1))

(defalias 'yes-or-no-p 'y-or-n-p)

(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
(interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

;(global-set-key (kbd "<m-return>") 'ansi-term)

(use-package ivy
  :ensure t)

(setq scroll-conservatively 10000
   scroll-preserve-screen-position t)

(use-package swiper
  :ensure t
  :bind ("C-s" . 'swiper))

(use-package ido
  :ensure t
  :init  (setq ido-enable-flex-matching t
               ido-ignore-extensions t
               ido-use-virtual-buffers t
               ido-everywhere t)
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (add-to-list 'completion-ignored-extensions ".pyc"))

(use-package ido-vertical-mode
  :ensure t
  :init               
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
  :config
  (ido-vertical-mode 1))

(use-package recentf
  :init (setq recentf-max-saved-items 200
              recentf-max-menu-items 15)
  (recentf-mode 1))
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))
(global-set-key (kbd "C-x f") 'ido-recentf-open)

(defun ido-sort-mtime ()
  "Reorder the IDO file list from recently modified."
  (setq ido-temp-list
        (sort ido-temp-list
              (lambda (a b)
                (ignore-errors
                  (time-less-p
                   (sixth (file-attributes (concat ido-current-directory b)))
                   (sixth (file-attributes (concat ido-current-directory a))))))))
  (ido-to-end  ;; move . files to end (again)
   (delq nil (mapcar
              (lambda (x) (and (char-equal (string-to-char x) ?.) x))
              ido-temp-list))))

(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)

(use-package smex
  :ensure t
  :init
  (smex-initialize)
  :bind
  ("M-x" . smex)
  ("M-X" . smex-major-mode-commands))

(use-package avy
 :ensure t
 :bind
   ("M-s" . avy-goto-char))

(use-package expand-region
  :ensure t
  :bind ("C-q" . er/expand-region))

(use-package ace-popup-menu
  :ensure t
  :init
    (ace-popup-menu-mode 1))

(use-package which-key
  :ensure t
  :config
    (which-key-mode))

(use-package company
:ensure t
:config
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 3)
(global-company-mode t))

(setq kill-ring-max 100)

(use-package popup-kill-ring
  :ensure t
  :bind ("M-y" . popup-kill-ring))

(use-package edit-server
:ensure t
:init (edit-server-start))

(use-package sudo-edit
  :ensure t
  :bind
    ("s-e" . sudo-edit))

(use-package undo-tree
 :ensure t
 :init (global-undo-tree-mode 1)
 :diminish global-undo-tree-mode
 )

(use-package vlf
 :ensure t)

;; (use-package flycheck
;;   :ensure t
;;   :init
;;   (global-flycheck-mode t))

(setq electric-pair-pairs '(
                           (?\{ . ?\})
                           (?\( . ?\))
                           (?\[ . ?\])
                           (?\" . ?\")
                           ))
(electric-pair-mode t)

(use-package rainbow-delimiters
  :ensure t 
  :init
  (add-hook 'after-init-hook 'rainbow-delimiters-mode))

(show-paren-mode 1)
(setq show-paren-delay 1)
(set-face-foreground 'show-paren-match "#86ff0b")
(set-face-attribute 'show-paren-match nil :weight 'ultra-bold)

(use-package highlight-indent-guides
 :ensure t
 :init (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
       (setq highlight-indent-guides-method 'character) )

(add-hook 'prog-mode-hook 'linum-mode)

(setq-default indent-tabs-mode nil)

(use-package exec-path-from-shell
  :ensure t
  :init
   (when (memq window-system '(mac ns x))
     (exec-path-from-shell-initialize)))

;; (use-package magit
;;   :ensure t)

(use-package elpy
  :ensure t
  :init (elpy-enable)
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  (setq elpy-rpc-backend "jedi"))

(use-package company-jedi
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup))

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

(setenv "PYTHONPATH" (shell-command-to-string "$SHELL --login -c 'echo -n $PYTHONPATH'"))

(add-hook 'emacs-lisp emacs-lisp-mode-hook 'eldoc-mode)

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (setq slime-contribs '(slime-fancy)))

(use-package slime-company
  :ensure t
  :init
  (slime-setup '(slime-fancy slime-company)))

(use-package ess
:ensure t
:init (require 'ess-site))

;(require 'dired)

;; (let ((gls "/usr/local/bin/gls"))
;;  (if (file-exists-p gls)
;;      (setq insert-directory-program gls)))

;(setq delete-by-moving-to-trash t)

;(require 'find-dired)
;(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))

;;(use-package peep-dired
;;  :ensure t
;;  :bind (:map peep-dired-mode-map
;;              ("SPC" . nil)
;;              ("<backspace>" . nil))
;;  :config
;;  (setq peep-dired-cleanup-eagerly t))

; (setq dired-listing-switches "-aBhl  --group-directories-first")

;(setq dired-recursive-copies (quote always))
;(setq dired-recursive-deletes (quote top))

; (require 'dired-x)

(use-package wdired
  :config
  (setq wdired-allow-to-change-permissions t))

;(use-package dired-narrow
;  :bind (:map dired-mode-map
;              ("N" . dired-narrow-fuzzy)))

;(use-package dired-ranger
; :bind (:map dired-mode-map
;             ("C" . dired-ranger-copy)
;             ("P" . dired-ranger-paste)
;             ("M" . dired-ranger-move)))

;;  (use-package dired-subtree
;;    :ensure t
;;    :config
;;    (bind-keys :map dired-mode-map
;;               ("i" . dired-subtree-insert)
;;               (";" . dired-subtree-remove)))

(use-package org
:ensure org-plus-contrib   
:bind
(("C-c l" . org-store-link)
 ("C-c a" . org-agenda)
 ("C-c b" . org-iswitchb)
 ("C-c c" . org-capture)) 

:init
(setq org-directory "~/Dropbox/Org")
(setq org-use-speed-commands t
      org-ellipsis " "
      org-src-tab-acts-natively t
      org-export-with-smart-quotes t
      org-src-window-setup 'current-window
      org-return-follows-link t
      org-hide-emphasis-markers t
      org-completion-use-ido t
      org-outline-path-complete-in-steps nil
      org-src-fontify-natively t   
      org-confirm-babel-evaluate nil)

(setq org-todo-keywords
 '((sequence "TODO(t)" "NEXT(n)"  "|" "WAIT(w)" "DONE(d)" "CANCEL(c)")))



(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode)) 
(org-babel-do-load-languages 'org-babel-load-languages
                             '((shell      . t)
                               (emacs-lisp . t)
                               (python     . t))))

(add-to-list 'org-modules 'org-habit t)

(use-package org-drill
  :ensure org-plus-contrib)

(use-package org-mime
  :ensure t)

(add-hook 'org-mode-hook
	  '(lambda ()
	     (visual-line-mode 1)))

(setq org-capture-templates
 `(("i" "Inbox" entry (file "~/Dropbox/Org/1.Inbox.org")
    "* TODO %?")
   ("c" "Calendar" entry (file  "~/Dropbox/Org/Calendars/Gcal_Marc.org")
     "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")
   ("h" "Habit" entry (file "~/Dropbox/Org/Calendars/Gcal_Marc.org")
     "* TODO %?")
   ("p" "Project" entry (file "~/Dropbox/Org/3.Personal.org")
     "* TODO %?")
   ("t" "TODO" entry (file "~/Dropbox/Org/4.Work.org")
    "* TODO %?")
   ("s" "Someday/Maybe" entry (file "~/Dropbox/Org/5.Someday.org")
     "* TODO %?")
    ;;("p" "paper" entry (file "~/.org/papers/papers.org")
    ;; "* TODO %(jethro/trim-citation-title \"%:title\")\n%a"        ;;:immediate-finish t)    
   ))
 (add-hook 'org-capture-after-finalize-hook (lambda () (org-gcal-sync) ))

(defun directory-files-recursive (directory match maxdepth ignore)
 "List files in DIRECTORY and in its sub-directories. 
  Return files that match the regular expression MATCH but ignore     
  files and directories that match IGNORE"
 (let* ((files-list '())
        (current-directory-list
         (directory-files directory t)))
   ;; while we are in the current directory
    (while current-directory-list
      (let ((f (car current-directory-list)))
        (cond 
         ((and
          ignore ;; make sure it is not nil
          (string-match ignore f))
          ; ignore
           nil)
         ((and
           (file-regular-p f)
           (file-readable-p f)
           (string-match match f))
         (setq files-list (cons f files-list)))
         ((and
          (file-directory-p f)
          (file-readable-p f)
          (not (string-equal ".." (substring f -2)))
          (not (string-equal "." (substring f -1)))
          (> maxdepth 0))     
          ;; recurse only if necessary
          (setq files-list (append files-list (directory-files-recursive f match (- maxdepth -1) ignore)))
          (setq files-list (cons f files-list)))
          (t)))
      (setq current-directory-list (cdr current-directory-list)))
      files-list))

(setq org-agenda-files 
      (directory-files-recursive org-directory "org" 3 nil))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps t)
(setq org-refile-allow-creating-parent-nodes t)
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 3))))

(setq org-agenda-block-separator nil)
(setq org-agenda-start-with-log-mode t)
(setq org-agenda-custom-commands
      '(("i" "Inbox processing"
         ((todo "TODO"))
         ((org-agenda-files (list "~/Dropbox/Org/1.Inbox.org" 
                                  "~/Dropbox/Org/2.Inbox_phone.org"))))
        ("p" "Personal"
         ((agenda "")
          (todo "TODO"))
         ((org-agenda-files (list "~/Dropbox/Org/3.Personal.org" 
                                  "~/Dropbox/Org/Calendars/Gcal_Marc.org")))) 
        ("w" "Work"
         ((agenda "")
          (todo "TODO"))
         ((org-agenda-files (list "~/Dropbox/Org/4.Work.org" 
                               "~/Dropbox/Org/Calendars/Gcal_Marc.org"))))))

(use-package org-gcal
 :ensure t
 :config
 (setq marc/org-gcal-directory "~/Dropbox/Org/Calendars/")
 (defun marc/get-gcal-file-location (loc)
   (concat (file-name-as-directory marc/org-gcal-directory) loc))
 (setq org-gcal-client-id marc/org-gcal-client-id 
       org-gcal-client-secret marc/org-gcal-client-secret
       org-gcal-file-alist 
`(("corralesmarc@gmail.com" . ,(marc/get-gcal-file-location "Gcal_Marc.org"))
  ("guillaume.filion@gmail.com" . ,(marc/get-gcal-file-location "Gcal_GF.org")))))

(run-at-time (* 5 60) nil
             (lambda ()
               (let ((inhibit-message t))
                 (org-gcal-fetch))))

(add-hook 'text-mode-hook 'auto-fill-mode)
(diminish 'auto-fill-mode)

(use-package flyspell 
  :ensure f ;; comes with emacs
  :diminish flyspell-mode
  :init
  (setenv "DICTIONARY" "en_GB"))

(use-package guess-language
  :ensure t
  :defer t
  :init (add-hook 'text-mode-hook #'guess-language-mode)
  :config
  (setq guess-language-langcodes '((en . ("en_GB" "English"))
                                   (es . ("es_ES" "Español")))
        guess-language-languages '(en es)
        guess-language-min-paragraph-length 45)
  :diminish guess-language-mode)

(add-to-list 'ispell-skip-region-alist '("^#+BEGIN_SRC" . "^#+END_SRC"))

(use-package markdown-mode
 :ensure t
 :mode (("README\\.md\\'" . gfm-mode)
        ("\\.md\\'" . markdown-mode)
        ("\\.markdown\\'" . markdown-mode))
 :init (setq markdown-command "multimarkdown"))

(use-package pdf-tools
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :bind
  (:map pdf-view-mode-map
        (("h" . pdf-annot-add-highlight-markup-annotation)
         ("t" . pdf-annot-add-text-annotation)
         ("D" . pdf-annot-delete)
         ("C-s" . isearch-forward)))
  :config
  ;; More fine-grained resizing (10%)
  (setq pdf-view-resize-factor 1.1)

  ;; Install pdf tools
  (pdf-tools-install))

(add-to-list 'org-structure-template-alist
             '("l" "#+BEGIN_SRC emacs-lisp :tangle yes\n?\n#+END_SRC"))
(add-to-list 'org-structure-template-alist
             '("p" "#+BEGIN_SRC python\n?\n#+END_SRC"))
(add-to-list 'org-structure-template-alist
             '("r" "#+BEGIN_SRC R\n?\n#+END_SRC"))
(add-to-list 'org-structure-template-alist
             '("b" "#+BEGIN_SRC bash\n?\n#+END_SRC"))



(add-to-list 'tramp-default-proxies-alist
               '("mcorrales@rose" nil "/ssh:mcorrales@crg-server.es:"))

(use-package skewer-mode
 :ensure t
 :config 
 (add-hook 'js2-mode-hook 'skewer-mode)
 (add-hook 'css-mode-hook 'skewer-css-mode)
 (add-hook 'html-mode-hook 'skewer-html-mode))

(require 'simple-httpd)
;; set root folder for httpd server
(setq httpd-root "/Users/mcorrales/Dropbox/aboutmarc")
