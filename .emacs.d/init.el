;;; init.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Prashant Tak
;;
;; Author: Prashant Tak <prashantrameshtak@gmail.com>
;; Maintainer: Prashant Tak <prashantrameshtak@gmail.com>
;; Created: June 11, 2023
;; Modified: June 11, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/brongulus/init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;  Ref 1: https://zenn.dev/takeokunn/articles/56010618502ccc
;;  Ref 2: https://zenn.dev/zk_phi/books/cba129aacd4c1418ade4
;;  Ref 3: https://robbmann.io/emacsd/
;;  TODO: file and buffer shortcuts, tempel.
;;  TODO: Outline, TAB folding, eglot, viper visual mode?
;;  Description
;;
;;; Code:

;; (require 'profiler)
;; (profiler-start 'cpu)

;;; Gccemacs stuff / Startup hacks
(setq comp-deferred-compilation t
      comp-async-report-warnings-errors nil)

;; ;; (el-get-bundle benchmark-init)
;; (load "/home/prashant/.emacs.d/el-get/benchmark-init/benchmark-init.el"
      ;; 'no-error nil 'no-suffix)
;; (require 'benchmark-init)
;; (add-hook 'after-init-hook 'benchmark-init/deactivate)

(defvar my/delayed-priority-high-configurations '())
(defvar my/delayed-priority-high-configuration-timer nil)

(defvar my/delayed-priority-low-configurations '())
(defvar my/delayed-priority-low-configuration-timer nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq my/delayed-priority-high-configuration-timer
                  (run-with-timer
                   0.1 0.01
                   (lambda ()
                     (if my/delayed-priority-high-configurations
                         (let ((inhibit-message t))
                           (eval (pop my/delayed-priority-high-configurations)))
                       (progn
                         (cancel-timer my/delayed-priority-high-configuration-timer))))))
            (setq my/delayed-priority-low-configuration-timer
                  (run-with-timer
                   0.3 0.01
                   (lambda ()
                     (if my/delayed-priority-low-configurations
                         (let ((inhibit-message t))
                           (eval (pop my/delayed-priority-low-configurations)))
                       (progn
                         (cancel-timer my/delayed-priority-low-configuration-timer))))))))

(defmacro with-delayed-execution-priority-high (&rest body)
  (declare (indent 0))
  `(setq my/delayed-priority-high-configurations
         (append my/delayed-priority-high-configurations ',body)))

(defmacro with-delayed-execution (&rest body)
  (declare (indent 0))
  `(setq my/delayed-priority-low-configurations
         (append my/delayed-priority-low-configurations ',body)))

;; --------------------------------------------------------------------------------


;;; TEMP FIX before doom profiles are functioning properly
(setq ignored-local-variable-values '((git-commit-major-mode . git-commit-elisp-text-mode)))

;;; Better Defaults
(setq-default
  warning-minimum-level :error
  tab-width 2
  mouse-yank-at-point t
	;; nice scrolling
	scroll-margin 0
	scroll-conservatively 100000
	scroll-preserve-screen-position 1
  recenter-positions '(5 top bottom)
  vc-follow-symlinks t)

(with-delayed-execution-priority-high
	(add-hook 'text-mode-hook #'(lambda () (setq-local display-line-numbers 'relative)))
	(add-hook 'prog-mode-hook #'(lambda () (setq-local display-line-numbers 'relative))))

(with-delayed-execution
  (setq bookmark-default-file "~/doom-configs/.emacs.d/bookmarks"
	cursor-in-non-selected-windows nil
	help-window-select t
	large-file-warning-threshold nil
	shell-file-name "/bin/bash"
	auth-sources '("~/.authinfo")
	show-paren-delay 0
	initial-buffer-choice 'remember-notes
	remember-notes-buffer-name "*scratch*"))

;;; Package Management

;;;; Viper
(setq-default
  viper-mode t
  viper-expert-level 5
	viper-want-ctl-h-help t
	viper-want-emacs-keys-in-insert t
	viper-ex-style-editing nil
	viper-ex-style-motion nil
	viper-case-fold-search t
  viper-inhibit-startup-message t
  viper-vi-style-in-minibuffer nil
  viper-ESC-moves-cursor-back nil
	viper-shift-width 2
	viper-fast-keyseq-timeout 300
  viper-electric-mode t
  viper-ex-style-motion nil)
(require 'viper)

(with-eval-after-load 'viper
	(push 'org-capture-mode viper-insert-state-mode-list) ;; FIXME:
	;; Defines how many times the next command is run
	(define-key viper-vi-global-user-map "\M-u" 'universal-argument)
	;; macros
	(define-key viper-vi-global-user-map "q" 'kmacro-start-macro-or-insert-counter)
	(define-key viper-vi-global-user-map "Q" 'kmacro-end-or-call-macro)
	(define-key viper-vi-global-user-map "@" 'consult-kmacro)
	;; WIP: visual mode (commands not getting executed)
  (define-key viper-vi-global-user-map "v" 'set-mark-command)
	(define-key viper-vi-global-user-map "\C-v" 'rectangle-mark-mode)
  (define-key viper-vi-global-user-map "ESC" 'keyboard-quit)
  ;; (define-key viper-vi-global-user-map "d" 'clipboard-kill-region)
	;; ------------
  (define-key viper-vi-global-user-map "(" 'backward-list)
  (define-key viper-vi-global-user-map ")" 'forward-list)
  (define-key viper-vi-global-user-map ";" 'viper-ex)
  (define-key viper-vi-global-user-map "-" 'dired-jump)
  (define-key viper-vi-global-user-map (kbd "M-<down>") 'scroll-other-window)
  (define-key viper-vi-global-user-map (kbd "M-<up>") 'scroll-other-window-down)
  (define-key viper-vi-global-user-map (kbd "C-t") 'tab-new)
  (define-key viper-vi-global-user-map (kbd "C-w") 'tab-close)
  (define-key viper-vi-global-user-map (kbd "SPC") 'consult-buffer)
  (define-key viper-vi-global-user-map (kbd "?") 'consult-recent-file)
  (define-key viper-insert-global-user-map "\C-v" 'viper-Put-back)
  (define-key viper-insert-global-user-map "\C-y" 'viper-Put-back)

  (viper-record-kbd-macro "gf" 'vi-state [(meta x) f f a p return] t)
  (viper-record-kbd-macro "gd" 'vi-state [(meta .)] t)
  (viper-record-kbd-macro "gt" 'vi-state [(ctrl x) t o] t)
  (viper-record-kbd-macro "gT" 'vi-state [(ctrl x) t O] t)
  (viper-record-kbd-macro "gg" 'vi-state [1 G] t)
  (viper-record-kbd-macro "gc" 'vi-state [(ctrl x) (ctrl \;)] t)
  (viper-record-kbd-macro "jk" 'insert-state [escape] t)
  (viper-record-kbd-macro ",w" 'vi-state [(ctrl x) o] t)
  (viper-record-kbd-macro ",v" 'vi-state [(ctrl x) 3] t)
  (viper-record-kbd-macro ",s" 'vi-state [(ctrl x) 2] t)
  (viper-record-kbd-macro ",d" 'vi-state [(ctrl x) 0] t))
 ;; (viper-record-kbd-macro ",t" 'vi-state [(ctrl x) b] t) ;; FIXME:
 ;; (viper-record-kbd-macro ",/" 'vi-state [(ctrl x) f] t) ;; FIXME:
(eval-after-load 'viper
  '(progn
     (setq viper-vi-state-id
	   (concat (propertize "⬤" 'face '(:foreground "#ccdfff")) " "))
     (setq viper-emacs-state-id
	   (concat (propertize "⬤" 'face '(:foreground "#b9f2c6")) " "))
     (setq viper-insert-state-id
	   (concat (propertize "⬤" 'face '(:foreground "#fff576")) " "))
     (setq viper-replace-state-id
	   (concat (propertize "⬤" 'face 'ansi-color-green) " "))
     (put 'viper-mode-string 'risky-local-variable t)))

(with-eval-after-load 'doc-view
  (define-key doc-view-mode-map "j" 'doc-view-next-line-or-next-page)
  (define-key doc-view-mode-map "k" 'doc-view-previous-line-or-previous-page))

;;;; Visual
;; Theming
(add-to-list 'load-path "~/doom-configs/.emacs.d")
(require 'ef-themes)
(setq ef-themes-mixed-fonts t
      ef-themes-variable-pitch-ui t
			ef-themes-to-toggle '(ef-summer ef-cherie))
(load-theme 'ef-summer :no-confirm)
(set-face-attribute 'default nil :family "Victor Mono" :height 140)

;; Modeline (Ref: https://github.com/motform/emacs.d/blob/master/init.el)
(setq-default mode-line-format
							'("%e" mode-line-front-space mode-line-modified
								mode-line-remote "  " mode-line-misc-info "  ";; (vc-mode vc-mode)
								mode-line-buffer-identification "%l %p "))

;;;; el-get (Packages)
(add-to-list 'load-path (expand-file-name "el-get/el-get" user-emacs-directory))

(unless (require 'el-get nil 'noerror)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.org/packages/"))
  (package-refresh-contents)
  (package-initialize)
  (package-install 'el-get)
  (require 'el-get))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(setq el-get-is-lazy t)

;; (el-get 'sync)

;; TESTING: eglot
;; (el-get-bundle! external-completion)
;; (el-get-bundle! eglot)
;; (el-get-bundle! eglot-java)

;; Vertico
(el-get-bundle vertico)
(with-delayed-execution-priority-high
  (vertico-mode)
  (savehist-mode)
  (keymap-set vertico-map "<backspace>" #'vertico-directory-delete-char)
  (keymap-set vertico-map "TAB" #'vertico-insert)
  (keymap-set vertico-map "ESC" #'abort-minibuffers)
  (keymap-set vertico-map "C-j" #'vertico-next)
  (keymap-set vertico-map "C-k" #'vertico-previous)
  ;; RET -> insert and select (FIXME: Selects even if no exact match)
  (defun my/vertico-gg (&optional arg)
    (interactive)
    (vertico-insert)
    (vertico-exit))
  (keymap-set vertico-map "RET" #'my/vertico-gg)
  (setq vertico-scroll-margin 0
	vertico-resize nil
	vertico-cycle t))

;; Consult/Orderless
(el-get-bundle compat) ;; for minad's pkgs
(el-get-bundle orderless)
(with-delayed-execution-priority-high
	(setq completion-category-defaults nil
	completion-styles '(substring orderless basic)
	completion-category-overrides '((file (styles basic partial-completion)))
	completion-ignore-case t
	read-buffer-completion-ignore-case t
	read-file-name-completion-ignore-case t
	completion-in-region-function
	(lambda (&rest args)
	  (apply (if vertico-mode
		     #'consult-completion-in-region
		   #'completion--in-region)
		 args))))
  
(el-get-bundle consult)
(with-delayed-execution-priority-high
	(when (executable-find "rg")
		(setq grep-program "rg"))
	(when (executable-find "fd")
		(setq find-program "fd"))
  (setq register-preview-function #'consult-register-format)
  (recentf-mode)
  (global-set-key (kbd "C-x f") 'consult-recent-file)
  (global-set-key (kbd "C-<return>") 'consult-bookmark)
  (global-set-key (kbd "C-x b") 'consult-buffer)
	(global-set-key [remap list-buffers] 'consult-buffer)
	(global-set-key [remap isearch-forward] 'consult-grep))

;; Helpful
;; Its requires aren't being pulled by el-get automatically
(el-get-bundle f)
(el-get-bundle s)
(el-get-bundle elisp-refs)

(el-get-bundle helpful)
(with-delayed-execution
  (define-key viper-vi-global-user-map "K" #'helpful-at-point)
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h '") #'describe-face)
  (global-set-key (kbd "C-h x") #'helpful-command))

;; Cape and Corfu
(el-get-bundle corfu)
(with-delayed-execution-priority-high
  (global-corfu-mode)
  (add-hook 'corfu-mode-hook 'corfu-popupinfo-mode)
  (keymap-set corfu-map "ESC" #'abort-minibuffers)
  (setq corfu-cycle t
	corfu-auto t
	corfu-auto-prefix 2
	corfu-auto-delay 0
	corfu-separator ?_
	corfu-quit-no-match 'separator
	corfu-preview-current nil
	corfu-popupinfo-delay '(0.2 . 0.1)
	corfu-preselect-first nil
	tab-always-indent 'complete)
  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (setq-local corfu-auto nil)
	      (corfu-mode))))

(el-get-bundle! cape)

(with-delayed-execution-priority-high
	(defun my/add-capfs ()
		(push 'cape-file completion-at-point-functions)
		(push 'cape-dabbrev completion-at-point-functions)
		(push 'cape-keyword completion-at-point-functions))
	(add-hook 'prog-mode-hook #'my/add-capfs)
	(add-hook 'text-mode-hook #'my/add-capfs))

;; Undo tree
(el-get-bundle undo-fu)
(el-get-bundle undo-fu-session)
(with-delayed-execution-priority-high
  (setq undo-limit 67108864
	undo-strong-limit 100663296
	undo-outer-limit 1006632960)
  (define-key viper-vi-global-user-map "u" #'undo-fu-only-undo)
  (define-key viper-vi-global-user-map "\C-r" #'undo-fu-only-redo)
  (undo-fu-session-global-mode))

;; Nov
(el-get-bundle esxml)
(el-get-bundle nov)
(with-delayed-execution
  (push (locate-user-emacs-file "el-get/nov") load-path)
  (push '("\\.epub\\'" . nov-mode) auto-mode-alist))
(with-eval-after-load 'nov
  (define-key nov-mode-map "j" 'next-line)
  (define-key nov-mode-map "k" 'previous-line))

;; eww
(with-eval-after-load 'eww
  (define-key eww-mode-map "j" 'next-line)
  (define-key eww-mode-map "k" 'previous-line)
  (define-key eww-mode-map "h" 'eww-back-url)
  (define-key eww-mode-map "l" 'eww-forward-url))

;; magit
(el-get-bundle magit/transient)
(el-get-bundle magit/ghub)
(el-get-bundle magit/magit-popup)
(el-get-bundle magit/with-editor)
(el-get-bundle magit/magit)
(el-get-bundle magit/forge)

(with-delayed-execution-priority-high
  (push (locate-user-emacs-file "el-get/transient/lisp") load-path)
  (push (locate-user-emacs-file "el-get/ghub/lisp") load-path)
  (push (locate-user-emacs-file "el-get/magit-pop") load-path)
  (push (locate-user-emacs-file "el-get/with-editor/lisp") load-path)
  (push (locate-user-emacs-file "el-get/magit/lisp") load-path)
  (push (locate-user-emacs-file "el-get/forge/lisp") load-path)
  (autoload 'magit "magit" nil t)
	(global-set-key (kbd "C-c g") 'magit)
  (setq forge-owned-accounts '(("brongulus")))
  (add-hook 'magit-mode-hook #'(lambda () (require 'forge))))

;; terminal stuff, taken from doom (cursor, cliboard)
(el-get-bundle xclip)
(el-get-bundle evil-terminal-cursor-changer)

(el-get 'sync)

;;; Keymaps
(global-set-key [f2] 'save-buffer)
(global-set-key [f10] 'kill-current-buffer)
(global-set-key (kbd "C-x x") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c C-t") 'ef-themes-toggle)

;; dired
(with-delayed-execution
  (define-key dired-mode-map "v" 'dired-x-find-file)
  (define-key dired-mode-map "V" 'dired-view-file)
  (define-key dired-mode-map "j" 'dired-next-line)
  (define-key dired-mode-map "J" 'dired-goto-file)
  (define-key dired-mode-map "k" 'dired-previous-line)
  (define-key dired-mode-map "K" 'dired-do-kill-lines)
  (define-key dired-mode-map "-" 'dired-up-directory)
  (define-key dired-mode-map "~"
    #'(lambda () (interactive) (dired "/home/prashant/")))
	(setq dired-dwim-target t
				dired-recursive-deletes 'always
				dired-recursive-copies 'always)
  (add-hook 'dired-mode-hook 'dired-hide-details-mode))

;; tabs
(with-eval-after-load 'tab-bar
	;; (add-to-list 'tab-bar-format #'tab-bar-format-menu-bar)
  (setq tab-bar-close-button-show nil
	tab-bar-new-button-show nil
	tab-bar-new-tab-choice "*scratch*"
	tab-bar-tab-name-truncated-max 12))

;;; Random
(with-delayed-execution
  (save-place-mode 1)
	(winner-mode 1)
	(with-eval-after-load 'winner
		(define-key winner-mode-map (kbd "C-c C-<left>") 'winner-undo)
		(define-key winner-mode-map (kbd "C-c C-<right>") 'winner-redo))
	(with-eval-after-load 'recentf
    (setq recentf-max-menu-items 10000)
    (setq recentf-max-saved-items 10000)
    (setq recentf-auto-cleanup 'never)
    (setq recentf-save-file  "~/.emacs.d/.recentf")
    (setq recentf-exclude '(".recentf" "\\.gpg\\")))
  (show-paren-mode)
  (global-hl-line-mode)
	;; auto pair completion
	(add-hook 'prog-mode-hook (electric-pair-mode t))
	(add-hook 'prog-mode-hook (show-paren-mode t))
  (fset 'yes-or-no-p 'y-or-n-p))

;;; Org-Capture
(with-eval-after-load 'org-capture
  (setq +org-capture-readings-file "~/Dropbox/org/links.org"
	+org-capture-log-file "~/Dropbox/org/log.org"
	+org-capture-todo-file "~/Dropbox/org/inbox.org"
	org-capture-templates
	'(("t" "Personal todo" entry
	   (file+headline +org-capture-todo-file "todo")
	   "* TODO %?\n%i\n%a%f" :prepend t)
	  ("n" "Personal notes" entry
	   (file+headline +org-capture-notes-file "Notes")
	   "* %u %?\n%i\n%a" :prepend t)
	  ("r" "Readings" entry
	   (file+headline +org-capture-readings-file "Readings")
	   "* " :prepend t)
	  ("l" "Personal Log" item
	   (file +org-capture-log-file)
	   "+ %T %?" :prepend t)
	  ("j" "Journal" entry
	   (file+olp+datetree +org-capture-journal-file)
	   "* %U %?\n** What happened \n** What is going through your mind? \n** What emotions are you feeling? \n** What thought pattern do you recognize? \n** How can you think about the situation differently? " :prepend t))))

;;; Org-agenda
(with-eval-after-load 'org-agenda
	(setq org-agenda-start-with-log-mode t
	org-log-done t
	org-log-into-drawer t
	org-agenda-breadcrumbs-separator " ❱ "
	org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/inbox.org")))

;; Start the server (FIXME: Slowing down the startup)
; (with-delayed-execution
; 		(server-start))

;; Terminal session (taken from doom)
(with-delayed-execution-priority-high
	(unless (display-graphic-p)
		(xterm-mouse-mode 1)
		(turn-on-xclip)
		(etcc-on)))

;; Gnus
(load "~/doom-configs/.emacs.d/+gnus")

;; Startup hacks
(setq file-name-handler-alist my-saved-file-name-handler-alist)

;; (profiler-report)
;; (profiler-stop)

(provide 'init)
;;; init.el ends here


;; ------------------------- This contains code for the future.
;; (if (version< emacs-version "29.0")
    ;; (pixel-scroll-mode)
  ;; (pixel-scroll-precision-mode 1)
  ;; (setq pixel-scroll-precision-large-scroll-height 35.0))
