(require 'package)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)
(package-refresh-contents)

;;; We really need use-package to begin the party

(unless (and (package-installed-p 'use-package)
             (package-installed-p 'diminish))
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'diminish))


(eval-when-compile
  (require 'use-package)
  (require 'diminish)
  (require 'bind-key)
  (require 'cl))

;;; This is the actual config file
(require 'org)
(require 'ob-tangle)
(require 'org-compat)
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("/Users/mcorrales/Dropbox/Org/2.Inbox_phone.org" "/Users/mcorrales/Dropbox/Org/3.Personal.org" "/Users/mcorrales/Dropbox/Org/4.Work.org" "/Users/mcorrales/Dropbox/Org/5.Someday.org" "/Users/mcorrales/Dropbox/Org/Errands.org" "/Users/mcorrales/Dropbox/Org/Review.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
