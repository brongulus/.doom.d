(add-hook! 'writeroom-mode-hook
  (if writeroom-mode
      (add-hook 'post-command-hook #'recenter nil t)
    (remove-hook 'post-command-hook #'recenter t)))

(setq yequake-frames
      '(("Yequake & scratch" .
         ((width . 0.75)
          (height . 0.5)
          (alpha . 0.90)
          (buffer-fns . ("~/doom-emacs/.local/straight/build-27.1/yequake/yequake.el"
                         split-window-horizontally
                         "*scratch*"))
          (frame-parameters . ((undecorated . t)))))))

(defun emacs-run-launcher ()
"Create and select a frame called emacs-run-launcher which consists only of a minibuffer and has specific dimensions. Run counsel-linux-app on that frame, which is an emacs command that prompts you to select an app and open it in a dmenu like behaviour. Delete the frame after that command has exited"
(interactive)
(with-selected-frame (make-frame '((name . "emacs-run-launcher")
(minibuffer . only)
(width . 120)
(height . 11)))
(counsel-linux-app)
(delete-frame)))

;; (use-package! vertico-posframe
;;   :config
;;   (vertico-posframe-mode 1)
;;   (setq vertico-posframe-parameters
;;       '((left-fringe . 8)
;;         (right-fringe . 8))))

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;;(eshell-command "setq stringvar $XDG_CURRENT_DESKTOP")
;;(if (string= stringvar "EXWM")
;;   (load! "+exwm")
;;nil
;;)

(setq-default
 user-full-name "Prashant Tak"
 user-mail-address "prashantrameshtak@gmail.com"
 doom-font (font-spec :family "FantasqueSansMono Nerd Font Mono" :size 11.0)
 ;; doom-font "Comic Mono:size 20 :weight 'light"
 ;;MesloLGS Nerd Font Mono
 doom-variable-pitch-font (font-spec :family "NotoSans Nerd Font" :size 10.0 :weight 'light)
 doom-theme 'doom-flatwhite
 doom-serif-font (font-spec :family "iA Writer Quattro S" :weight 'regular)
 org-directory "/home/prashant/Dropbox/org/"
 ;;org-indent-mode t
 evil-escape-mode 1
 display-line-numbers-type nil
 rainbow-mode t
 left-margin-width 2
 tab-width 2
 doom-fallback-buffer-name "*doom*"
 which-key-idle-delay 0.5
 large-file-warning-threshold nil
 org-latex-toc-command "\\tableofcontents \\clearpage"
 )

(custom-theme-set-faces! 'doom-flatwhite
  '(font-lock-comment-face  :background "#fcf2bf")
  '(hi-yellow :background "#d9c6c3")
  '(org-block :background "#fcf2bf")
  '(org-block-begin-line :background "#fcf2bf" :extend t)
  '(org-block-end-line :background "#fcf2bf" :extend t)
  '(cursor :background "#614c61")
  )

(map! :i "C-y" #'evil-paste-after)
(map! :map image-mode-map
      :ni "r" #'image-rotate)

(after! evil
  (setq evil-move-cursor-back nil))

;; (setq projectile-switch-project-action #'projectile-dired)

(after! warnings
        (add-to-list 'warning-suppress-types '(defvaralias)))

(custom-set-faces! '(default :background nil))

(add-hook! 'window-setup-hook
  (select-frame-set-input-focus (selected-frame)))

(setq window-resize-pixelwise nil
      frame-resize-pixelwise nil)

;; (after! company
;;   (setq company-idle-delay 0.2))

;;(add-hook 'dired-mode-hook 'dired-hide-details-mode)
;; (add-hook 'dired-mode-hook 'writeroom-mode)
(add-hook! 'ranger-mode-hook
  (setq hl-line-mode 1))

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

(when (featurep! :ui zen)
  (after! writeroom-mode
    (setq +zen-text-scale 0)))

;;(defun display-workspaces-in-minibuffer ()
;;  (with-current-buffer " *Minibuf-0*"
;;    (erase-buffer)
;;    (insert (+workspace--tabline))))
;;(run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
;;(+workspace/display)

(defun save-and-close ()
  (interactive)
  (call-interactively 'save-buffer)
  (call-interactively 'kill-current-buffer))

(map! :n "SPC b w" #'save-and-close)

;;(add-hook 'after-change-major-mode-hook
;;(lambda ()
;;(hl-line-mode -1)))

(doom/set-frame-opacity 98)
(add-hook! 'writeroom-mode-hook
  (doom/set-frame-opacity (if writeroom-mode 98 100)))

(setq forge-owned-accounts '(("brongulus")))
(setq auth-sources '("/home/prashant/.authinfo" "/home/prashant/.emacs.d/.local/etc/authinfo.gpg" "~/.authinfo.gpg"))

;; displaying useful information

;; (display-time-mode 1)

(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))

(add-hook! 'Info-mode-hook #'hide-mode-line-mode)

(after! doom-modeline
  (remove-hook! 'doom-modeline-mode-hook #'column-number-mode)
  (doom-modeline-def-segment buffer-name
    (concat
     (doom-modeline-spc)
     (doom-modeline--buffer-name)))
  (setq-default doom-modeline-major-mode-icon t
                doom-modeline-enable-word-count nil
                doom-modeline-buffer-encoding nil
                doom-modeline-buffer-file-name-style 'relative-to-project
                line-number-mode nil
                column-number-mode nil
                size-indication-mode nil)
  ;; (doom-modeline-def-modeline 'personal
  ;; '(bar workspace-name window-number modals matches buffer-name remote-host  parrot selection-info)
  ;; '(objed-state misc-info battery grip irc mu4e debug repl lsp input-method indent-info major-mode process vcs checker))
  ;; (defun setup-custom-doom-modeline ()
  ;;  (doom-modeline-set-modeline 'personal 'default))
  ;; (add-hook 'doom-modeline-mode-hook 'setup-custom-doom-modeline)
  )

(add-hook! 'org-mode-hook #'org-fragtog-mode)
;; (after! org
;; (add-hook! 'org-mode-hook #'writeroom-mode))
(add-hook 'org-mode-hook
          (λ! (yas-minor-mode)
              (yas-activate-extra-mode 'latex-mode)))
;; (add-hook 'org-mode-hook 'lsp-completion-mode)

(setq org-startup-with-inline-images t)

(add-hook! 'org-mode-hook #'mixed-pitch-mode)
(custom-set-faces!
  '(org-table :inherit 'fixed-pitch))
;;(set-face-attribute 'org-table nil :inherit 'fixed-pitch)

(setq org-fontify-quote-and-verse-blocks t)

(setq yas-triggers-in-field t)

(setq flycheck-global-modes '(not LaTeX-mode latex-mode))

(setq-default org-latex-pdf-process '("tectonic -Z shell-escape --outdir=%o %f"))

;; (use-package graphviz-dot-mode
;;   :config
;;   (setq graphviz-dot-indent-width 4))

;; (use-package company-graphviz-dot
;;   )
(setq org-preview-latex-default-process 'dvisvgm)

(after! org
  (plist-put org-format-latex-options :background "Transparent")
  (setq org-src-block-faces '(("latex" (:inherit default :extend t))))
  (setq org-format-latex-options '(:foreground default :background "Transparent" :scale 1.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
  )
(add-hook! 'doom-load-theme-hook
  (setq org-preview-latex-image-directory
        (concat doom-cache-dir "org-latex/" (symbol-name doom-theme) "/"))
  (dolist (buffer (doom-buffers-in-mode 'org-mode (buffer-list)))
    (with-current-buffer buffer
      (+org--toggle-inline-images-in-subtree (point-min) (point-max) 'refresh)
      (org-clear-latex-preview (point-min) (point-max))
      (org--latex-preview-region (point-min) (point-max))
      )))

(map! :after evil-org
      :map evil-org-mode-map
      :ni "C-RET"   #'+org/insert-item-below
      :ni "C-S-RET" #'+org/insert-item-above)

(setq org-agenda-start-with-log-mode t
      org-log-done t
      org-log-into-drawer t
      org-agenda-breadcrumbs-separator " ❱ ")

(setq org-agenda-files
      '("~/Dropbox/org/inbox.org"
        "~/Dropbox/org/todo.org"))

(setq org-agenda-custom-commands
      '(("A" "My agenda"
         ((todo "TODO" (
                        (org-agenda-overriding-header "⚡ TODAY:\n")
                        (org-agenda-remove-tags t)
                        (org-agenda-prefix-format " %-15b")
                        (org-agenda-todo-keyword-format "")))
          (agenda "" (
                      (org-agenda-skip-scheduled-if-done t)
                      (org-agenda-skip-timestamp-if-done t)
                      (org-agenda-skip-deadline-if-done t)
                      (org-agenda-start-day "-1d")
                      (org-agenda-span 3)
                      (org-agenda-overriding-header "⚡ SCHEDULE:\n")
                      (org-agenda-remove-tags t)
                      (org-agenda-prefix-format " %-15b%t %s")
                      (org-agenda-todo-keyword-format "")
                      ;;         (org-agenda-time)
                      (org-agenda-current-time-string "⮜┈┈┈┈┈┈┈ now")
                      (org-agenda-scheduled-leaders '("" ""))
                      ;;       (org-agenda-deadline-leaders '("" ""))
                      (org-agenda-time-grid (quote ((today require-timed remove-match) (0800 1100 1400 1700 2000) "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈")))
                      )
                  )
          ;;(todo "NEXT" (
          ;;              (org-agenda-overriding-header "⚡ THIS WEEK:\n")
          ;;              (org-agenda-prefix-format " %b")
          ;;              (org-agenda-todo-keyword-format "")))
          ))))

(defun my-org-agenda-format-date-aligned (DATE)
  "Format a DATE string for display in the daily/weekly agenda, or timeline.
This function makes sure that dates are aligned for easy reading."
  (require 'cal-iso)
  (let* ((dayname (calendar-day-name DATE 1 nil))
         (day (cadr DATE))
         (month (car DATE))
         (monthname (calendar-month-name month 1))
         ;;   (year (nth 2 DATE))
         )
    (format " %-2s. %2d %s"
            dayname day monthname)))

(setq org-agenda-format-date 'my-org-agenda-format-date-aligned)

(setq org-agenda-block-separator (string-to-char " "))

(setq org-agenda-hidden-separator "‌‌ ")

;; (use-package! appt
;;   :defer-incrementally t
;;   :config

;;   (appt-activate t)

;;   ;; use appointment data from org-mode
;;   (defun my-org-agenda-to-appt ()
;;     (interactive)
;;     (setq appt-time-msg-list nil)
;;     (org-agenda-to-appt))

;;   (setq appt-message-warning-time 5) ; Show notification 5 minutes before event
;;   (setq appt-display-interval appt-message-warning-time) ; Disable multiple reminders
;;   (setq appt-display-mode-line nil)

;;   ;; update alarms when starting emacs
;;   (my-org-agenda-to-appt)
;;   ;; (2) ... Everyday at 12:05am (useful in case you keep Emacs always on)
;;   (run-at-time "12:05am" (* 24 3600) 'my-org-agenda-to-appt)

;;   ;; (3) ... When TODO.org is saved
;;   (add-hook 'after-save-hook
;;             #'(lambda ()
;;                (if (string= (buffer-file-name) (concat (getenv "HOME") "~/Dropbox/org/todo.org"))
;;                    (my-org-agenda-to-appt))))

;;   ;; TODO Display appointments as a window manager notification (incorporate the script within elisp)
;;   (setq appt-disp-window-function 'my-appt-display)
;;   (setq appt-delete-window-function (lambda () t))

;;   (setq my-appt-notification-app "~/appt-notification.sh")

;;   (defun my-appt-display (min-to-app new-time msg)
;;     (if (atom min-to-app)
;;         (start-process "my-appt-notification-app" nil my-appt-notification-app min-to-app msg)
;;       (dolist (i (number-sequence 0 (1- (length min-to-app))))
;;         (start-process "my-appt-notification-app" nil my-appt-notification-app (nth i min-to-app) (nth i msg)))))
  ;; )

(setq +org-capture-readings-file "~/Dropbox/org/links.org"
      +org-capture-todo-file "~/Dropbox/org/inbox.org")
(after! org-capture
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "todo")
           "* TODO %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Notes")
           "* %u %?\n%i\n%a" :prepend t)
          ("r" "Readings" entry
           (file+headline +org-capture-readings-file "Readings")
           "* " :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n** What happened \n** What is going through your mind? \n** What emotions are you feeling? \n** What thought pattern do you recognize? \n** How can you think about the situation differently? " :prepend t)
          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("pn" "Project-local notes" entry
           (file+headline +org-capture-project-notes-file "Inbox")
           "* %U %?\n%i\n%a" :prepend t)
          ("pc" "Project-local changelog" entry
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a" :prepend t)
          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
          ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
          ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t))
        ))

;; (add-hook! 'treemacs-mode-hook #'hl-todo-mode #'org-fragtog-mode #'org-mode)

(custom-set-faces!
  '(ein:cell-input-area :background "bg-alt" :extend t)
  ;;'(company-tooltip :family doom-font)
  )

(custom-set-faces!
  '((font-lock-comment-face font-lock-doc-face) :slant italic))

(custom-set-faces!
  '(treemacs-git-unmodified-face :inherit treemacs-file-face))

(setq rmh-elfeed-org-files '("~/.doom.d/elfeed.org"))
(after! elfeed
  (setq elfeed-search-filter "@2-month-ago"))
(add-hook! 'elfeed-show-mode-hook
  (setq left-margin-width 2))
(defun =elfeed ()
  (interactive)
  (elfeed)
  )
(add-hook! 'elfeed-show-mode 'variable-pitch-mode)
(map! :n "SPC o l" #'=elfeed)
(map! :map elfeed-search-mode-map :localleader "u" #'elfeed-update)

;; FIXME
(after! pocket-reader
  (set-evil-initial-state! 'pocket-reader-mode
    'insert))
(setq pocket-reader-open-url-default-function #'eww
      pocket-reader-pop-to-url-default-function #'eww)

(add-hook 'pdf-view-mode-hook (lambda ()
                                (pdf-view-midnight-minor-mode)))
;;(add-hook 'pdf-view-mode-hook 'pdf-view-auto-slice-minor-mode)
(add-hook 'pdf-view-mode-hook #'hide-mode-line-mode)

;;(map! pdf-view-mode-map
;;      :niv "h" #'pdf-annot-add-markup-annotation)

(add-hook 'pdf-view-mode-hook 'pdf-continuous-scroll-mode)

(after! pdf-tools
  (map! :map pdf-view-mode-map
        ;; "j" nil
        ;; "k" nil
        :n "M-j" #'pdf-continuous-scroll-forward
        :n "M-k" #'pdf-continuous-scroll-backward))
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; (use-package! nov
;;   :mode ("\\.epub\\'" . nov-mode))

(setq fancy-splash-image "~/.doom.d/doom-trans.png")
(setq +doom-dashboard-menu-sections
      '(("Reload last session"
         :icon (all-the-icons-octicon "history" :face 'doom-dashboard-menu-title)
         :when (cond ((require 'persp-mode nil t)
                      (file-exists-p (expand-file-name persp-auto-save-fname persp-save-dir)))
                     ((require 'desktop nil t)
                      (file-exists-p (desktop-full-file-name))))
         :face (:inherit (doom-dashboard-menu-title bold))
         :action doom/quickload-session)
        ("Open notmuch"
         :icon (all-the-icons-octicon "mention" :face 'doom-dashboard-menu-title)
         :face (:inherit (doom-dashboard-menu-title bold))
         :action notmuch)
        ("Open elfeed"
         :icon (all-the-icons-octicon "book" :face 'doom-dashboard-menu-title)
         :face (:inherit (doom-dashboard-menu-title bold))
         :action =elfeed)
        ("Open Agenda"
         :icon (all-the-icons-octicon "check" :face 'doom-dashboard-menu-title)
         :face (:inherit (doom-dashboard-menu-title bold))
         :action org-agenda)
        )
      )
(add-hook! '+doom-dashboard-mode-hook #'hide-mode-line-mode)

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)
(add-hook 'Info-mode-hook #'writeroom-mode)

(use-package windmove
  :bind
  (("S-<left>" . windmove-left)
   ("S-<right>" . windmove-right)
   ("S-<up>" . windmove-up)
   ("S-<down>" . windmove-down)))

(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)
(setq org-support-shift-select 'always)

(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;  (setq display-buffer-alist
;;        '(("\\*\\(e?shell\\|doom:vterm-popup:#.\\)\\*"
;;          (display-buffer-in-side-window)
;;           (window-height . 0.25)
;;           (side . bottom)
;;           (slot . -1))
;;("\\*\\(Backtrace\\|Warnings\\|Compile-log\\|[Hh]elp\\|Messages\\)\\*"
;; (display-buffer-in-side-window)
;; (window-height . 0.25)
;; (side . bottom)
;; (slot . 0))
;;("\\*Faces\\*"
;; (display-buffer-in-side-window)
;; (window-height . 0.25)
;; (side . bottom)
;; (slot . 1))
;; )
;; )


(set-popup-rules!
  ;;  (when (featurep! +all)
  ;;    '(("^\\*"  :slot 1 :vslot -1 :select t)
  ;;      ("^ \\*" :slot 1 :vslot -1 :size +popup-shrink-to-fit)))
  ;;  (when (featurep! +defaults)
  '(("^\\*Completions" :ignore t)
    ("^\\*Local variables\\*$"
     :vslot -1 :slot 1 :size +popup-shrink-to-fit)
    ("^\\*\\(?:[Cc]ompil\\(?:ation\\|e-Log\\)\\|Messages\\)"
     :vslot -2 :size 0.3  :autosave t :quit t :ttl nil)
    ("^\\*\\(?:doom \\|Pp E\\)"  ; transient buffers (no interaction required)
     :vslot -3 :size +popup-shrink-to-fit :autosave t :select ignore :quit t :ttl 0)
    ("^\\*doom:"  ; editing buffers (interaction required)
     :vslot -4 :size 0.35 :autosave t :select t :modeline t :quit nil :ttl t)
    ("^\\*doom:\\(?:v?term\\|e?shell\\)-popup"  ; editing buffers (interaction required)
     :vslot -5 :size 0.35 :select t :modeline nil :quit nil :ttl nil)
    ("^\\*\\(?:Wo\\)?Man "
     :vslot -6 :size 0.45 :select t :quit t :ttl 0)
    ("^\\*Calc"
     :vslot -7 :side bottom :size 0.4 :select t :quit nil :ttl 0)
    ("^\\*Customize"
     :slot 2 :side right :size 0.5 :select t :quit nil)
    ("^ \\*undo-tree\\*"
     :slot 2 :side left :size 20 :select t :quit t)
    ;; `help-mode', `helpful-mode'
    ("^\\*[Hh]elp"
     :slot 2 :vslot -8 :size 0.35 :select t)
    ;; ("^\\*eww\\*"  ; `eww' (and used by dash docsets)
    ;;  :vslot -11 :size 0.35 :select t)
    ;; ("^\\*info\\*$"  ; `Info-mode'
    ;;  :slot 2 :vslot 2 :size 0.45 :select t)
    ;;    ))
    ;;'(
    ("^\\*Warnings" :vslot 99 :size 0.25)
    ("^\\*Backtrace" :vslot 99 :size 0.4 :quit nil)
    ("^\\*CPU-Profiler-Report "    :side bottom :vslot 100 :slot 1 :height 0.4 :width 0.5 :quit nil)
    ("^\\*Memory-Profiler-Report " :side bottom :vslot 100 :slot 2 :height 0.4 :width 0.5 :quit nil)
    ("^\\*Process List\\*" :side bottom :vslot 101 :size 0.25 :select t :quit t)
    ("^\\*\\(?:Proced\\|timer-list\\|Abbrevs\\|Output\\|Occur\\|unsent mail\\|info\\|eww\\)\\*" :ignore t)))

;;(setq +notmuch-sync-backend 'mbsync)
(autoload 'notmuch "notmuch" "notmuch mail" t)
;; setup the mail address and use name
(setq mail-user-agent 'message-user-agent)
(setq user-mail-address "prashantrameshtak@gmail.com"
      user-full-name "Prashant Tak")
;; smtp config
;;(setq smtpmail-smtp-server "smtp.gmail.com"
;;      message-send-mail-function 'message-smtpmail-send-it)

;; report problems with the smtp server
;;(setq smtpmail-debug-info t)
;; add Cc and Bcc headers to the message buffer
;;(setq message-defNotmault-mail-headers "Cc: \nBcc: \n")
;; postponed message is put in the following draft directory
(setq message-auto-save-directory "~/.mail/gmail/draft")
;;(setq message-kill-buffer-on-exit t)
;; change the directory to store the sent mail
(setq message-directory "~/.mail/gmail/")

;;(after! notmuch
;;(set-popup-rule! "^\\*notmuch-hello" :ignore t))
(map! :n "SPC o n" 'notmuch)
;;(add-hook 'notmuch-hello-refresh-hook
;;              (lambda ()
;;                (if (and (eq (point) (point-min))
;;                         (search-forward "Saved searches:" nil t))
;;                    (progn
;;                     (forward-line)
;;                      (widget-forward 1))
;;                  (if (eq (widget-type (widget-at)) 'editable-field)
;;                      (beginning-of-line)))))

;;(after! notmuch
;;  (setq notmuch-saved-searches
;;        '((:name "inbox"    :query "tag:inbox not tag:trash"    :key "i")
;;          (:name "personal" :query "tag:personal"               :key "p")
;;          (:name "bits"     :query "tag:bits"                   :key "b")
;;          (:name "unread"   :query "tag:unread"                 :key "u")
;;          (:name "flagged"  :query "tag:flagged"                :key "f")
;;          (:name "sent"     :query "tag:sent"                   :key "s")
;;          )
;;        )
;;  )

;;FIXME (add-hook! 'notmuch-search-mode-hook #'notmuch-tree-mode)
;;(setq mm-text-html-renderer 'shr
;;      notmuch-multipart/alternative-discouraged '("text/plain" ;;"multipart/related")
;;      shr-use-colors nil
;;      gnus-blocked-images nil
;;      )
;; inline images?
;;(if (not (fboundp 'gnus-blocked-images))
;;    (defun gnus-blocked-images () nil))

;;FIXME
;;(setq notmuch-search-result-format
;;      '(("date" . "%12s | ")
;;        ("authors" . "%-20s | ")
;;        ("subject" . "%-54s")
;;        ("tags" . ":%s:")
;;        ))
;;(after! notmuch
;;  (setq notmuch-hello-sections
;;        '(notmuch-hello-insert-header +notmuch-hello-insert-saved-searches notmuch-hello-insert-search notmuch-hello-insert-recent-searches notmuch-hello-insert-alltags notmuch-hello-insert-footer)
;;        notmuch-message-headers-visible nil))
;; Look for alternate methods of centering, writeroom destroys formatting
;;(add-hook! 'notmuch-show-mode-hook #'writeroom-mode)

;;(setq lsp-file-watch-threshold 2000)
(defun java-ide-view-enable ()
  (interactive)
  (progn
    (lsp-treemacs-symbols)
    (lsp-treemacs-java-deps-list)))

(map! :map java-mode-map
      :n "SPC m p" #'java-ide-view-enable)


(setq oj-home-dir "/mnt/Data/Documents/problems")

(defun end-process ()
  (interactive)
  (progn
    (delete-process (get-buffer-process (current-buffer)))
    (kill-current-buffer)
    (+workspace/close-window-or-workspace)))

(map! :map comint-mode-map
      :ni "q" #'end-process)

(add-hook! c++-mode
  ;; FIXED (Finally) Disable naive completion of angle brackets <>
  (sp-local-pair 'c++-mode "<" ">" :actions :rem)
  ;; Disable built-in "smart" completion of tags
  (map! :map c++-mode-map
        "<" nil
        ">" nil))

;; Start c++ files in insert state, why would one want it any other way...
(add-to-list 'evil-insert-state-modes 'c++-mode)

;; (map! :map c++-mode-map
;;       :localleader "c" (cmd! (compile (concat "g++ -std=c++17 -O2" buffer-file-name " -Wall"))))

;; Compile Command
(defun cpp-compile-command (f-name)
  (when f-name
    (setq compile-command
          (concat "g++ -std=c++17 -O2 -o "
                  (shell-quote-argument (file-name-sans-extension f-name))
                  " "
                  (shell-quote-argument f-name)
                  " -Wall;"))))
;; HACK DOESN'T WORK LMFAO For now, disabling adding codeforces dir to lsp, but look into it later
;; (with-eval-after-load 'projectile
;;   (add-to-list 'projectile-globally-ignored-directories "/mnt/Data/Documents/code/codeforces"))

(add-hook! 'c++-mode-hook
  (setq-local compile-command (cpp-compile-command (buffer-file-name))))

(after! projectile
(projectile-register-project-type 'cpp '("*.cpp")
                                  :compile "g++ -std=c++17 -O2 -o "))
;; (defun proj-cpp-compile-command ()
;;   (cond
;;    ((and (eq major-mode 'c++-mode)
;;          (not (string-match-p (regexp-quote "\\.*/atcoder/\\.*") (buffer-file-name (current-buffer)))))
;;     "./g++ -std=c++17 -O2 -o ")))

;; (after! 'c++-mode
;;   (set (make-local-variable 'compile-command)
;;        (concat "g++ -std=c++17 -O2 " buffer-file-name " -Wall")))
;; (set-file-template! "/main\\.c\\(?:c\\|pp\\)$" :trigger "__main.cpp" :mode 'c++-mode)

;;(after! cc-mode
;;  (set-company-backend! 'c-mode
;;    '(:separate company-irony-c-headers company-irony)))
;;Windows
;;(after! lsp-mode
;;  (set-lsp-priority! 'clangd 1))
;;
;;Linux
;;(after! lsp-mode
;;  (require 'dap-cpptools)
;;  (yas-global-mode)
;;  )

;;(setq lsp-julia-default-environment "~/.julia/environments/v1.0")
(setq lsp-enable-folding t)

(after! scheme
  ;;(put 'test-group 'scheme-indent-function 1)
  (setq geiser-mode-start-repl-p t))

(add-to-list 'evil-insert-state-modes #'circe-mode)
(after! circe
  (set-irc-server! "irc.libera.chat"
                   `(:tls t
                     :port 6697
                     :nick "brongulus"
                     :sasl-username "brongulus"
                     ;; :sasl-password "mypassword"
                     :channels ("#mlpack")))
  )

  ;; (setq-default circe-use-tls t)
;;   (setq circe-notifications-alert-icon "/usr/share/icons/breeze/actions/24/network-connect.svg"
;;         lui-logging-directory "~/.emacs.d/.local/etc/irc"
;;         lui-logging-file-format "{buffer}/%Y/%m-%d.txt"
;;         circe-format-self-say "{nick:+13s} ┃ {body}")

;;   (custom-set-faces!
;;     '(circe-my-message-face :weight unspecified))

;;   (enable-lui-logging-globally)
;;   (enable-circe-display-images)

;;   (defun named-circe-prompt ()
;;     (lui-set-prompt
;;      (concat (propertize (format "%13s > " (circe-nick))
;;                          'face 'circe-prompt-face)
;;              "")))
;;   (add-hook 'circe-chat-mode-hook #'named-circe-prompt)

;;   (appendq! all-the-icons-mode-icon-alist
;;             '((circe-channel-mode all-the-icons-material "message" :face all-the-icons-lblue)
;;               (circe-server-mode all-the-icons-material "chat_bubble_outline" :face all-the-icons-purple))))

(use-package! lexic
  :commands lexic-search lexic-list-dictionary
  :config
  (map! :map lexic-mode-map
        :n "q" #'lexic-return-from-lexic
        :nv "RET" #'lexic-search-word-at-point
        :n "a" #'outline-show-all
        :n "h" (cmd! (outline-hide-sublevels 3))
        :n "o" #'lexic-toggle-entry
        :n "n" #'lexic-next-entry
        :n "N" (cmd! (lexic-next-entry t))
        :n "p" #'lexic-previous-entry
        :n "P" (cmd! (lexic-previous-entry t))
        :n "C-p" #'lexic-search-history-backwards
        :n "C-n" #'lexic-search-history-forwards
        :n "/" (cmd! (call-interactively #'lexic-search))))

(defadvice! +lookup/dictionary-definition-lexic (identifier &optional arg)
  "Look up the definition of the word at point (or selection) using `lexic-search'."
  :override #'+lookup/dictionary-definition
  (interactive
   (list (or (doom-thing-at-point-or-region 'word)
             (read-string "Look up in dictionary: "))
         current-prefix-arg))
  (lexic-search identifier nil nil t))

(load! "~/.doom.d/openwith")
(require 'openwith)
(add-hook 'dired-mode-hook 'openwith-mode 1)

;;(load! "~/.emacs.d/elegant-emacs/sanity")
;;(load! "~/.emacs.d/elegant-emacs/elegance")

(setq eshell-visual-commands '("spt" "ncmpcpp" "nvim" "vim" "vi" "screen" "tmux" "top" "htop" "less" "more" "lynx" "links" "ncftp" "mutt" "pine" "tin" "trn" "elm"))

(map! :n "SPC a t" #'counsel-spotify-toggle-play-pause
      :n "SPC a <" #'counsel-spotify-previous
      :n "SPC a >" #'counsel-spotify-next
      :n "SPC a s" #'counsel-spotify-search-track
      :n "SPC a p" #'counsel-spotify-search-playlist
      )

;;(use-package! el-secretario-org
;;  :after (el-secretario))
;;(use-package! el-secretario-notmuch
;;  :after (el-secretario))

;;(use-package! el-secretario
;;  :config
;;  (defun my/dailyreview-secretary ()
;;    (list

     ;; First take care of email
;;     (el-secretario-notmuch-make-source "tag:unread")
     ;; Then Take care of inbox
;;     (el-secretario-org-make-source nil ("/mnt/Data/Documents/org/index.org"))

     ;; Check if any waiting items are done
    ;;(el-secretario-org-make-source (todo "WAITING") ("~/org/orgzly/Todo.org"))
     ;; Go through TODOs
    ;; (el-secretario-org-make-source (todo "TODO") ("~/org/orgzly/Todo.org"))
;;     )
;;    )
  ;; Create a function to start the review
;;  (defun el-secretario-daily-review ()
;;    (interactive)
;;    (el-secretario-start-session (my/dailyreview-secretary)))
;;  :commands (el-secretario-daily-review)
;;  )

;; (use-package paper
;;   ;; you could also add html, png, jpg
;;   :mode ("\\.pdf\\'"  . paper-mode)
;;   :mode ("\\.epub\\'"  . paper-mode)
;;   :mode ("\\.cbz\\'"  . paper-mode)
;;   :config
;;   (require 'evil-collection-paper)
;;   (evil-collection-paper-setup))

;;(use-package nano
;;  :init
;;  (require 'nano-base-colors)
;;  (require 'nano-colors)
;;  (require 'nano-faces)
;;  (require 'nano-theme)
;;  (require 'nano-theme-light)
;;  (require 'nano-theme-dark)
  ;; (require 'nano-splash)
  ;; (require 'nano-modeline)
;;  (nano-faces)
;;  (nano-theme)
;;  :config
;;  (menu-bar-mode -1)
;;  )

;; (use-package! tree-sitter
;;   :when (bound-and-true-p module-file-suffix)
;;   :hook (prog-mode . tree-sitter-mode)
;;   :hook (tree-sitter-after-on . tree-sitter-hl-mode)
;;   :config
;;   (require 'tree-sitter-langs)
;;   (defadvice! doom-tree-sitter-fail-gracefully-a (orig-fn &rest args)
;;     "Don't break with errors when current major mode lacks tree-sitter support."
;;     :around #'tree-sitter-mode
;;     (condition-case e
;;         (apply orig-fn args)
;;       (error
;;        (unless (string-match-p (concat "^Cannot find shared library\\|"
;;                                        "^No language registered\\|"
;;                                        "cannot open shared object file")
;;                                (error-message-string e))
;;          (signal (car e) (cadr e)))))))

(unless (display-graphic-p)
  (map! :map org-mode-map
        :ni "C-c C-<down>" '+org/insert-item-below
        :ni "C-c C-<up>" '+org/insert-item-above
        :ni "C-c C-<left>" 'org-insert-heading
        :ni "C-c C-<right>" 'org-insert-subheading)
  )
