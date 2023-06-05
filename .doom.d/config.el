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

;; TODO Add fragtog compatible with tectonic, add nice rendering
;; capabilities to elfeed, mixed pitch, latex frag
;; TODO Fix treemacs symbols, indent guide continuation,
;; font size, variable pitch modeline, faces for palenight

;;; Commentary:
;; Hello there weary traveller? What brings you to these wild parts?
;; Stop and turn around, what lies ahead is madness and a pit of
;; despair and disappointments. Consider yourself warned.

;;; Basics

;; (doom/reload-font)

(setq-default
 user-full-name "Prashant Tak"
 user-mail-address "prashantrameshtak@gmail.com"
 forge-owned-accounts '(("brongulus"))
 auth-sources '("/home/prashant/.authinfo" "/home/prashant/.emacs.d/.local/etc/authinfo.gpg" "~/.authinfo.gpg")
 doom-font "Victor Mono:pixelsize=18"
 doom-theme 'doom-dracula
 org-directory "/home/prashant/Dropbox/org/"
 bookmark-default-file "~/.doom.d/bookmarks"
 evil-escape-mode 1
 display-line-numbers-type 'nil
 tab-width 2
 doom-fallback-buffer-name "*dashboard*"
 left-margin-width 2
 which-key-idle-delay 0.5
 large-file-warning-threshold nil
 custom-file (expand-file-name ".custom.el" doom-user-dir)
 org-latex-toc-command "\\tableofcontents \\clearpage"
 window-resize-pixelwise nil
 evil-split-window-below t
 evil-vsplit-window-right t
 frame-resize-pixelwise nil
 treemacs-width 30
 doom-themes-treemacs-theme "doom-atom" ; doom-colors
 +treemacs-git-mode 'deferred)

(setq smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587)

(map! :map global
      :n ";" nil
      :n ";" #'evil-ex)

;; HACK Fixes font sizing issue
;; (add-to-list 'default-frame-alist '(font . "Hack-8"))

;; (when (file-exists-p custom-file)
;;   (load custom-file))

(good-scroll-mode 1)

(setq tab-width 2)

;; (add-hook! 'writeroom-mode-hook
;;   (if writeroom-mode
;;       (add-hook 'post-command-hook #'recenter nil t)
;;     (remove-hook 'post-command-hook #'recenter t)))

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
  "Create and select a frame called emacs-run-launcher which
 consists only of a minibuffer and has specific dimensions.
 Run counsel-linux-app on that frame, which is an emacs
 command that prompts you to select an app and open it in a
 dmenu like behaviour. Delete the frame after that command has exited"
  (interactive)
  (with-selected-frame
      (make-frame '((name . "emacs-run-launcher")
                    (minibuffer . only)
                    (width . 120)
                    (height . 11)))
    (counsel-linux-app)
    (delete-frame)))


(add-to-list 'load-path "~/.doom.d/selectric")
(load! "openwith")
(add-hook 'dired-mode-hook 'openwith-mode 1)

(defun hugo-build ()
  (interactive)
  (eshell-command "cd /mnt/manjaro/home/prashant/blog & hugo" nil))

(setq eshell-visual-commands
      '("spt" "ncmpcpp" "nvim" "vim" "vi" "screen" "tmux" "top" "htop" "less" "more" "lynx" "links" "ncftp" "mutt" "pine" "tin" "trn" "elm"))

(defun timestamp ()
   (interactive)
   (insert (format-time-string "%Y-%m-%d %H:%M ")))

(map! :map global
      :n "SPC >" #'timestamp)

;;; Better Keymaps - FAR, MC etc
(map! :ni "<f2>" #'basic-save-buffer
      :ni "<f10>" #'kill-current-buffer
      :n "-" #'dired-jump)

(map! :i "C-y" #'evil-paste-before)
(map! :map image-mode-map
      :ni "r" #'image-rotate)

(after! evil
  (setq evil-move-cursor-back nil))

(after! warnings
  (add-to-list 'warning-suppress-types '(defvaralias)))

(add-hook! 'window-setup-hook
  (select-frame-set-input-focus (selected-frame)))

(when (modulep! :ui zen)
  (after! writeroom-mode
    (setq +zen-text-scale 0)
    (setq display-line-numbers nil)))

(defun save-and-close ()
  (interactive)
  (call-interactively 'save-buffer)
  (call-interactively 'kill-current-buffer))

(map! :n "SPC b w" #'save-and-close)

;; (doom/set-frame-opacity 95)
;; (add-hook! 'writeroom-mode-hook
;;   (doom/set-frame-opacity (if writeroom-mode 98 100)))

;;;; Outline minor mode
(defvar-local outline-folded nil)

(defun toggle-outline-entry (&optional arg)
  (interactive)
  (if (setq outline-folded (not outline-folded))
      (outline-show-subtree)
    (outline-hide-subtree)))

(add-hook! 'emacs-lisp-mode-hook #'outline-minor-mode)
(after! racket
  (add-hook! 'racket-mode-hook #'outline-minor-mode))

(map! :map outline-minor-mode-map
      :n [backtab] #'outline-hide-body
      :n [tab] #'toggle-outline-entry
      :n "SPC m o" #'consult-outline)

(setq-default imenu-list-position 'left)
(setq imenu-list-position 'left)
(map! :map doom-leader-map
      "s i" nil
      "s i" #'imenu-list)

(add-hook! 'imenu-list-major-mode-hook #'hide-mode-line-mode)

;;; Webkit (Disabled now, will use with pgtk)

(setq eww-search-prefix "https://lite.duckduckgo.com/lite/?q=")
(map! :map eww-mode-map
      :n "q" nil
      :n "q" 'kill-current-buffer)

(map! :n "SPC o w" 'webkit)

;; HACK add checks for last window then dont close workspace
;; TODO insert mode, vertico freeze fix
(defun webkit-close-tab(&optional arg)
  (interactive)
  (progn
    (kill-current-buffer)
    (+workspace/close-window-or-workspace)))

(map! :map webkit-mode-map :n "q" #'webkit-close-tab)

;; (use-package! webkit
;;   :init
;;   (when (eq window-system 'x)
;;         (modify-frame-parameters nil '((inhibit-double-buffering . t))))
;;   (require 'ol)
;;   :config
;;   (setq browse-url-browser-function 'webkit-browse-url
;;         webkit-cookie-file "~/.doom.d/webkit/cookies"
;;         webkit-history-file "~/.doom.d/webkit/history"
;;         webkit-browse-url-force-new t)
;;   (defun webkit--display-progress (progress)
;;     (setq webkit--progress-formatted
;;           (if (equal progress 100.0)
;;               ""
;;             (format "%s%.0f%%  " (all-the-icons-faicon "spinner") progress)))
;;     (force-mode-line-update)))

;; (use-package webkit-dark)

;; (use-package evil-collection-webkit
;;   :config
;;   (evil-collection-xwidget-setup))

;;; Modeline

(map! :n "SPC t m" #'hide-mode-line-mode)

(remove-hook! 'doom-modeline-mode-hook #'size-indication-mode)

(after! doom-modeline
  (remove-hook! 'doom-modeline-mode-hook #'column-number-mode)
  (doom-modeline-def-segment buffer-name
    (concat
     (doom-modeline-spc)
     (doom-modeline--buffer-name)))
  (setq-default doom-modeline-major-mode-icon t
                doom-modeline-enable-word-count nil
                doom-modeline-gnus t
                doom-modeline-gnus-timer 5
                doom-modeline-gnus-idle 1
                doom-modeline-gnus-excluded-groups '("nnimap+personal:[Gmail/All Mail]" "nnimap+uni:[Gmail/All Mail]")
                doom-modeline-buffer-encoding nil
                doom-modeline-buffer-file-name-style 'relative-to-project
                line-number-mode t
                column-number-mode nil
                size-indication-mode nil))

;;; Org

(unless (display-graphic-p)
  (map! :map org-mode-map
        :ni "C-c C-<down>" '+org/insert-item-below
        :ni "C-c C-<up>" '+org/insert-item-above
        :ni "C-c C-<left>" 'org-insert-heading
        :ni "C-c C-<right>" 'org-insert-subheading))

(add-hook! 'org-mode-hook #'org-appear-mode #'org-fragtog-mode)

(set-file-template! :trigger "template" :mode 'org-mode)

;; fcitx5
(map! :map global
      "C-SPC" nil)

(setq org-appear-autoemphasis t
      org-appear-autosubmarkers nil
      org-appear-autolinks t)

(add-hook 'org-mode-hook
          (λ! (yas-minor-mode)
              (yas-activate-extra-mode 'latex-mode)))

(add-hook! 'org-mode-hook
  (setq left-margin-width 2))

(setq org-fontify-quote-and-verse-blocks t
      yas-triggers-in-field t
      org-startup-with-inline-images nil
      +latex-viewers nil
      flycheck-global-modes '(not LaTeX-mode latex-mode)
      org-latex-pdf-process '("tectonic -X compile %f --outdir=%o -Z shell-escape")
      org-preview-latex-default-process 'imagemagick)

(setq!
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 org-preview-latex-process-alist
   '((dvipng :programs
      ("tectonic" "dvipng")
      :description "dvi > png" :message "you need to install the programs: latex/tectonic and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
      (1.0 . 1.0)
      :latex-compiler
      ("tectonic -X compile %f --outdir=%o -Z shell-escape")
      :image-converter
      ("dvipng -D %D -T tight -o %O %f")
      :transparent-image-converter
      ("dvipng -D %D -T tight -bg Transparent -o %O %f"))
     (dvisvgm :programs
      ("tectonic" "dvisvgm")
      :description "dvi > svg" :message "you need to install the programs: latex/tectonic and dvisvgm." :image-input-type "dvi" :image-output-type "svg" :image-size-adjust
      (1.7 . 1.5)
      :latex-compiler
      ("tectonic -X compile %f --outdir=%o -Z shell-escape")
      :image-converter
      ("dvisvgm %f -n -b min -c %S -o %O"))
     (imagemagick :programs
      ("tectonic" "convert")
      :description "pdf > png" :message "you need to install the programs: latex/tectonic and imagemagick." :image-input-type "pdf" :image-output-type "png" :image-size-adjust
      (1.0 . 1.0)
      :latex-compiler
      ("tectonic -X compile %f --outdir=%o -Z shell-escape")
      :image-converter
      ("convert -density %D -trim -antialias %f -quality 100 %O"))))


;; (after! org
;;   (plist-put org-format-latex-options :background "Transparent")
;;   (setq org-src-block-faces '(("latex" (:inherit default :extend t))))
;;   (setq org-format-latex-options
;;         '(:foreground default :background "Transparent" :scale 1.0 :html-foreground "Black"
;;           :html-background "Transparent" :html-scale 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\["))))

;; (add-hook! 'doom-load-theme-hook
;;   (setq org-preview-latex-image-directory
;;         (concat doom-cache-dir "org-latex/" (symbol-name doom-theme) "/"))
;;   (dolist (buffer (doom-buffers-in-mode 'org-mode (buffer-list)))
;;     (with-current-buffer buffer
;;       (+org--toggle-inline-images-in-subtree (point-min) (point-max) 'refresh)
;;       (org-clear-latex-preview (point-min) (point-max))
;;       (org--latex-preview-region (point-min) (point-max)))))

(after! org
  (map! :after evil-org
        :map evil-org-mode-map
        :ni "C-RET"   #'+org/insert-item-below
        :ni "C-S-RET" #'+org/insert-item-above))

(setq org-agenda-start-with-log-mode t
      org-log-done t
      org-log-into-drawer t
      org-agenda-breadcrumbs-separator " ❱ "
      org-agenda-files
      '("~/Dropbox/org/inbox.org"
        "~/Dropbox/org/todo.org"))

(setq org-agenda-custom-commands
      '(("A" "My agenda"
         ((alltodo "" ((org-agenda-overriding-header
                         (insert(concat
                                (insert (all-the-icons-faicon "star" :v-adjust 0.1 :face 'all-the-icons-yellow))
                                (propertize "  Today" 'face '(:height 1.3 :inherit variable-pitch)))))
                        (org-agenda-remove-tags t)
                        (org-agenda-prefix-format " %-15b")
                        (org-agenda-todo-keyword-format "")))
          (agenda "" ((org-agenda-overriding-header ;"")
                             (concat (propertize "  Schedule" 'face '(:height 1.3 :inherit variable-pitch))))
                       ;; (insert (concat ;; Buffer is read only
                       ;;         (insert (all-the-icons-faicon "calendar" :v-adjust 0.1 :face 'all-the-icons-red))
                       ;;         (propertize "  Schedule" 'face '(:height 1.3 :inherit 'variable-pitch)))))
                      (org-agenda-skip-deadline-if-done t)
                      ;; (org-agenda-skip-scheduled-if-done t)
                      ;; (org-agenda-skip-timestamp-if-done t)
                      (org-agenda-start-day "-1d")
                      (org-agenda-span 3)
                      (org-agenda-remove-tags t)
                      (org-agenda-prefix-format " %-15b%t %s")
                      (org-agenda-todo-keyword-format "")
                      ;;         (org-agenda-time)
                      (org-agenda-current-time-string "⭠ now ─────────────────────────────────────────────────")
                      (org-agenda-scheduled-leaders '("" ""))
                      ;;       (org-agenda-deadline-leaders '("" ""))
                      (org-agenda-time-grid (quote ((today require-timed remove-match) (0800 1100 1400 1700 2000) "      " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))))
                  )
          ;;(todo "NEXT" (
          ;;              (org-agenda-overriding-header "⚡ THIS WEEK:\n")
          ;;              (org-agenda-prefix-format " %b")
          ;;              (org-agenda-todo-keyword-format "")))
          ))))

(defun =agenda (&optional arg)
  (interactive)
  (org-agenda nil "A"))

(map! :n "SPC o A" nil
      :n "SPC o A" '=agenda)

;; (add-hook 'after-init-hook (lambda () (org-agenda nil "A")))

;; Org-modern setup --------------
(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-fold-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 ;; org-agenda-tags-column 0
 ;; org-agenda-block-separator ?─
 ;; org-agenda-time-grid
 ;; '((daily today require-timed)
 ;;   (800 1000 1200 1400 1600 1800 2000)
 ;;   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 ;; org-agenda-current-time-string
 ;; "⭠ now ────────────────────────────────────────────────"
 )

(if (display-graphic-p)
    (global-org-modern-mode))

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

(setq org-agenda-format-date 'my-org-agenda-format-date-aligned
      org-agenda-block-separator (string-to-char " ")
      org-agenda-hidden-separator "‌‌ "
      +org-capture-readings-file "~/Dropbox/org/links.org"
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

;;; Faces
;; Flatwhite
(custom-theme-set-faces! 'doom-flatwhite
  '(font-lock-comment-face  :background "#fcf2bf")
  '(hi-yellow :background "#d9c6c3")
  '(org-block :background "#fff9db")
  '(org-block-begin-line :background "#fff9db" :extend t)
  '(org-block-end-line :background "#fff9db" :extend t)
  '(cursor :background "#614c61")
  )

(custom-set-faces!
  ;; '(mode-line :font "Open Sans" :weight regular)
  '(default :background nil)
  '(ein:cell-input-area :background "bg-alt" :extend t)
  '((font-lock-comment-face font-lock-doc-face) :slant italic)
  '(treemacs-git-unmodified-face :inherit treemacs-file-face)
  '(org-table :inherit 'fixed-pitch)
  '(tooltip :font "VictorMono:pixelsize=18"))

;;; Readers

;; (setq rmh-elfeed-org-files '("~/.doom.d/elfeed.org"))
(defadvice! your/elfeed-goodes-entry-line-draw (entry)
  "Some doc"
  :override #'elfeed-goodies/entry-line-draw
  (let* ((title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
         (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
         (feed (elfeed-entry-feed entry))
         (feed-title
          (when feed
            (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
         (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
         (tags-str (concat "[" (mapconcat 'identity tags ",") "]"))
         (title-width (- (window-width) elfeed-goodies/feed-source-column-width
                         elfeed-goodies/tag-column-width 4))
         ;; what actually gets displayed.
         ;; Feed name
         (feed-column (elfeed-format-column
                       feed-title
                       elfeed-goodies/feed-source-column-width
                       :left))
         ;; Subject
         (title-column (elfeed-format-column
                        title ;; str
                        elfeed-search-title-max-width ;; width
                        :left)) ;; alignment
         ;; Tags
         (tag-column (elfeed-format-column
                      tags-str
                      elfeed-goodies/tag-column-width
                      :left)))

    (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
        (progn
          (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
          (insert (propertize title-column 'face title-faces 'kbd-help title) " ")
          (insert (propertize tag-column 'face 'elfeed-search-tag-face) " "))
      (insert (propertize title 'face title-faces 'kbd-help title)))))

(defadvice! your/search-header-draw-wide (separator-left separator-right search-filter stats db-time)
  "some doc"
  :override #'search-header/draw-wide
  (let* ((update (format-time-string "%Y-%m-%d %H:%M:%S %z" db-time))
         (lhs (list
               (powerline-raw (-pad-string-to "Feed" (- elfeed-goodies/feed-source-column-width 4)) 'powerline-active1 'l)
               (funcall separator-left 'powerline-active1 'powerline-active2)
               ;; play with the number 7 to get the tags to align better
               (powerline-raw (-pad-string-to  "Subject" (-  elfeed-search-title-max-width 7)) 'mode-line 'l)
               (funcall separator-left 'powerline-active2 'mode-line)
               (powerline-raw (-pad-string-to "Tags" (- elfeed-goodies/tag-column-width 6)) 'powerline-active2 'l)))
         (rhs (search-header/rhs separator-left separator-right search-filter stats update)))

    (concat (powerline-render lhs)
            (powerline-fill 'mode-line (powerline-width rhs))
            (powerline-render rhs))))

(setq rmh-elfeed-org-files '("~/.doom.d/testfeed.org"))
(after! elfeed
  (setq elfeed-search-filter "@2-month-ago"
        elfeed-goodies/tag-column-width 14)
  ;; (add-hook! elfeed-show-mode-hook #'mixed-pitch-mode)
  (set-popup-rule! "^\\*elfeed-entry" :ignore t))
(add-hook! 'elfeed-show-mode-hook
  (setq left-margin-width 2))
(defun =elfeed ()
  (interactive)
  (elfeed))

(add-hook! elfeed-show-mode-hook #'mixed-pitch-mode)
(map! :n "SPC o l" #'=elfeed)
(map! :map elfeed-search-mode-map :localleader "u" #'elfeed-update)

(use-package elfeed-tube
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)
  :bind (:map elfeed-show-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)
         :map elfeed-search-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)))

(use-package elfeed-tube-mpv
  :bind (:map elfeed-show-mode-map
              ("C-c C-f" . elfeed-tube-mpv-follow-mode)
              ("C-c C-w" . elfeed-tube-mpv-where)))

;; FIXME
(after! pocket-reader
  (set-evil-initial-state! 'pocket-reader-mode
    'insert))
(setq pocket-reader-open-url-default-function #'eww
      pocket-reader-pop-to-url-default-function #'eww)

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(map! :map pdf-view-mode-map :localleader "h" #'pdf-annot-add-highlight-markup-annotation)

;; Dictionary lookup (Issue with multiple results)
(use-package lexic
    :commands lexic-search lexic-list-dictionary
    :bind (:map lexic-mode-map
                (("q" . lexic-return-from-lexic)
                 ("RET" . lexic-search-word-at-point)
                 ("a" . outline-show-all)
                 ("h" . (lambda () (interactive) (outline-hide-sublevels 3)))
                 ("o" . lexic-toggle-entry)
                 ("n" . lexic-next-entry)
                 ("N" . (lambda () (interactive) (lexic-next-entry t)))
                 ("p" . lexic-previous-entry)
                 ("P" . (lambda () (interactive) (lexic-previous-entry t)))
                 ("E" . (lambda () (interactive) (lexic-return-from-lexic) ; expand
                                            (switch-to-buffer (lexic-get-buffer))))
                 ("M" . (lambda () (interactive) (lexic-return-from-lexic) ; minimise
                                            (lexic-goto-lexic)))
                 ("C-p" . lexic-search-history-backwards)
                 ("C-n" . lexic-search-history-forwards)
                 ("P" . (lambda () (interactive) (call-interactively #'lexic-search)))))
    :config (setq lexic-dictionary-specs '(("牛津现代英汉双解词典" :priority 1)
                                           ("Collins Cobuild 5" :priority 2))))
(add-to-list 'evil-insert-state-modes 'lexic-mode)

;;; Dashboard

(setq-hook! 'doom-init-ui-hook doom-fallback-buffer-name "*dashboard*")
(dashboard-setup-startup-hook)

(setq fancy-splash-image "~/.doom.d/sink.png")
(setq +doom-dashboard-menu-sections
      '(("Reload last session"
         :icon (all-the-icons-octicon "history" :face 'doom-dashboard-menu-title)
         :when (cond ((require 'persp-mode nil t)
                      (file-exists-p (expand-file-name persp-auto-save-fname persp-save-dir)))
                     ((require 'desktop nil t)
                      (file-exists-p (desktop-full-file-name))))
         :face (:inherit (doom-dashboard-menu-title bold))
         :action doom/quickload-session)
        ("Open gnus"
         :icon (all-the-icons-octicon "mention" :face 'doom-dashboard-menu-title)
         :face (:inherit (doom-dashboard-menu-title bold))
         :action gnus)
        ("Open elfeed"
         :icon (all-the-icons-octicon "book" :face 'doom-dashboard-menu-title)
         :face (:inherit (doom-dashboard-menu-title bold))
         :action =elfeed)
        ("Open Agenda"
         :icon (all-the-icons-octicon "check" :face 'doom-dashboard-menu-title)
         :face (:inherit (doom-dashboard-menu-title bold))
         :action =agenda)
     ))
(add-hook! '+doom-dashboard-mode-hook #'hide-mode-line-mode)

(use-package! info-colors
  :after info
  :hook (Info-selection . info-colors-fontify-node))

(add-hook 'Info-mode-hook #'info-variable-pitch-mode) ;;; Window Management

(after! info
  (set-popup-rule! "^\\*info\\*$" :ignore t))

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

(set-popup-rules!
  '(("^\\*Completions" :ignore t)
    ("^\\*[Hh]elp"
     :slot 2 :vslot -8 :size 0.35 :select t)
    ;; ("^\\*eww\\*"  ; `eww' (and used by dash docsets)
    ;;  :vslot -11 :size 0.35 :select t)
    ;; ("^\\*info\\*$"  ; `Info-mode'
    ;;  :slot 2 :vslot 2 :size 0.45 :select t)
    ;;    ))
    ;;'(
    ("^\\*OrgOutlineTree\\:$" :side left)
    ("^\\*\\(?:Proced\\|timer-list\\|Abbrevs\\|Output\\|Occur\\|unsent mail\\|info\\|eww\\)\\*$" :ignore t)))

;;; Mail

;;(setq +notmuch-sync-backend 'mbsync)
(autoload 'notmuch "notmuch" "notmuch mail" t)
;; setup the mail address and use name
(setq mail-user-agent 'message-user-agent
      user-mail-address "prashantrameshtak@gmail.com"
      user-full-name "Prashant Tak"
      ;; postponed message is put in the following draft directory
      message-auto-save-directory "~/.mail/gmail/draft"
      ;; change the directory to store the sent mail
      message-directory "~/.mail/gmail/")

(map! :n "SPC o n" 'gnus)

;;; Code
;;;; LSP Test
(setq lsp-ui-doc-enable t
      lsp-ui-doc-use-childframe t
      lsp-headerline-breadcrumb-enable t
      ;; lsp-ui-doc-enhanced-markdown nil
      lsp-ui-doc-use-webkit nil)

(after! lsp-ui
  (setq lsp-ui-doc-max-width 100
        lsp-ui-doc-max-height 14))

(setq leetcode-prefer-language "cpp"
      leetcode-prefer-sql "mssql"
      leetcode-save-solutions t
      leetcode-directory "/mnt/Data/Documents/problems/leetcode/")

(add-hook 'leetcode-solution-mode-hook
          (lambda() (flycheck-mode -1)
               (lsp-mode -1)))

(defun lsp-ui-popup-focus(&optional arg)
  (interactive)
  (progn
    (lsp-ui-doc-show)
    (lsp-ui-doc-focus-frame)))

(defun lsp-ui-popup-kill(&optional arg)
  (interactive)
  (progn
    (lsp-ui-doc-unfocus-frame)
    (lsp-ui-doc-hide)))

(map! :map lsp-mode-map :localleader "k" #'lsp-ui-popup-focus)
(map! :map lsp-mode-map
      "ESC" nil
      "ESC" #'lsp-ui-popup-kill)

(after! lsp-mode
  (set-lookup-handlers! 'lsp-mode
    :documentation '(lsp-ui-doc-show :async t)))

;;;; Languages
(defun java-ide-view-enable ()
  (interactive)
  (progn
    (lsp-treemacs-symbols)
    (lsp-treemacs-java-deps-list)))

(map! :map java-mode-map
      :n "SPC m p" #'java-ide-view-enable)

(set-file-template! "\\.pl$" :trigger "__pl" :mode 'perl-mode)
(add-to-list 'evil-insert-state-modes 'perl-mode)

(setq oj-home-dir "/mnt/Data/Documents/problems")

(defun end-process ()
  (interactive)
  (progn
    (delete-process (get-buffer-process (current-buffer)))
    (kill-current-buffer)
    (+workspace/close-window-or-workspace)))

;; Compile commands
(add-hook! 'racket-mode-hook
  (setq-local compile-command (concat
                               "racket " (shell-quote-argument buffer-file-name))))

(add-hook! 'python-mode-hook
  (setq-local compile-command (concat
                               "python " (shell-quote-argument buffer-file-name) " < ./in"
                               (shell-quote-argument (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))

(add-hook! 'c++-mode-hook
    (setq-local compile-command
          (concat "g++ -std=c++17 -Wall -Wextra -Wshadow -Wno-sign-conversion -O2 -DLOCAL -I/mnt/Data/Documents/problems/include "
                  (shell-quote-argument buffer-file-name)
                  " && ./a.out < ./in"
                  (shell-quote-argument (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))

;; Copy input from clipboard
(defun paste-input (&optional arg)
  (interactive)
  (find-file (concat
              "in"
              (shell-quote-argument (file-name-sans-extension (file-name-nondirectory buffer-file-name)))))
  (erase-buffer)
  (clipboard-yank)
  (basic-save-buffer)
  (kill-current-buffer)
  (message "Populated input file"))

;; Test using the cf-tool CLI
(defun cf-test (&optional arg)
  (interactive)
  (require 'vterm)
  (eval-when-compile (require 'subr-x))
  (let ((command (concat "cf test " (shell-quote-argument buffer-file-name))))
    (let ((dir default-directory))
      (vterm)
      (switch-to-buffer vterm-buffer-name)
      (vterm--goto-line -1)
      (message command)
      (vterm-send-string (concat "cd " dir))
      (vterm-send-return)
      (vterm-send-string command)
      (vterm-send-return))))

(map! "<f3>" nil
      "<f3>" #'paste-input
      "<f4>" nil
      "<f4>" #'compile
      "<f5>" nil
      "<f5>" #'cf-test
      "<f9>" nil
      "<f9>" #'mark-whole-buffer)

;; (map! :map comint-mode-map
;;       :ni "q" #'end-process
;;       :ni "<escape>" #'end-process)
(map! :map compilation-mode-map
      :ni "q" #'+workspace/close-window-or-workspace
      :ni "<escape>" #'+workspace/close-window-or-workspace)

(add-hook! c++-mode
           ;; FIXED (Finally) Disable naive completion of angle brackets <>
           (sp-local-pair 'c++-mode "<" ">" :actions :rem)
           ;; Disable built-in "smart" completion of tags
           (map! :map c++-mode-map
                 "<" nil
                 ">" nil))

;; Start c++ files in insert state, why would one want it any other way...
;; (add-to-list 'evil-insert-state-modes 'c++-mode)

(setq dap-cpptools-extension-version "1.5.1")

(after! lsp-mode
  (require 'dap-cpptools)
  (add-to-list 'lsp-file-watch-ignored-directories "/mnt/Data/Documents/problems/leetcode/"))

(with-eval-after-load 'lsp-rust
  (require 'dap-cpptools))

(after! dap-cpptools
  ;; Add a template specific for debugging Rust programs.
  ;; It is used for new projects, where I can M-x dap-edit-debug-template
  (dap-register-debug-template "test"
                               (list :type "cppdbg"
                                     :request "launch"
                                     :program "${fileDirname}${fileBasenameNoExtension}"
                                     :cwd "${workspaceFolder}"
                                     :dap-compilation "g++ -g ${file} -o ${fileBasenameNoExtension}"
                                     :dap-compilation-dir "${fileDirname}"
                                     ;; FIXME
                                     ))
  (dap-register-debug-template "Rust::CppTools Run Configuration"
                               (list :type "cppdbg"
                                     :request "launch"
                                     :name "Rust::Run"
                                     :MIMode "gdb"
                                     :miDebuggerPath "rust-gdb"
                                     :environment []
                                     :program "${workspaceFolder}/target/debug/hello / replace with binary"
                                     :cwd "${workspaceFolder}"
                                     :console "external"
                                     :dap-compilation "cargo build"
                                     :dap-compilation-dir "${workspaceFolder}")))

(after! dap-mode
  (setq dap-default-terminal-kind "integrated") ;; Make sure that terminal programs open a term for I/O in an Emacs buffer
  (dap-auto-configure-mode +1))

(after! projectile
  (projectile-register-project-type 'cpp '("*.cpp")
                                    :compile "g++ -std=c++17 -O2 -o "))
(setq lsp-enable-folding t)

(after! scheme
  ;;(put 'test-group 'scheme-indent-function 1)
  (setq geiser-mode-start-repl-p t))

;;; --------- SSH STUFFF ---------------
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

;; (after! tramp-mode
(add-to-list 'auto-mode-alist '("\\.j2\\'" . cpp-mode))
(setq lsp-warn-no-matched-clients nil
      +format-on-save-enabled-modes '(not c-mode c++-mode cpp-mode emacs-lisp-mode sql-mode tex-mode latex-mode org-msg-edit-mode)
      projectile-enable-caching t
      vc-handled-backends '(Git)
      projectile-file-exists-remote-cache-expire nil)
;; )

(defadvice projectile-project-root (around ignore-remote first activate)
  (unless (file-remote-p default-directory) ad-do-it))

(add-hook 'find-file-hook
          (lambda ()
            (when (file-remote-p default-directory)
              (setq-local projectile-mode-line "Projectile"))))

;; Tramp and SSH
(customize-set-variable 'tramp-encoding-shell "/bin/bash")

(setq tramp-default-method "sshx"
      remote-file-name-inhibit-cache nil
      vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)" vc-ignore-dir-regexp tramp-file-name-regexp)
      tramp-verbose 3)

(add-hook! 'dired-mode-hook #'dired-hide-details-mode)
(setq ls-lisp-ignore-case t)
(after! dired
        (map! :map dired-mode-map
        :n "~" nil
        :n "~" (cmd! (dired "/home/prashant/"))))

;;; Gnus
(load! "gnus-conf")

;;; Insert Package Name here

(load! "agenda-sidebar")

;;;; Insert em-dash
(defun help/real-insert (char)
  (cl-flet ((do-insert
             () (if (bound-and-true-p org-mode)
                    (org-self-insert-command 1)
                  (self-insert-command 1))))
    (setq last-command-event char)
    (do-insert)))
(defun help/insert-em-dash ()
  "Insert a EM-DASH.
- \"best limited to two appearances per sentence\"
- \"can be used in place of commas to enhance readability.
   Note, however, that dashes are always more emphatic than
   commas\"
- \"can replace a pair of parentheses. Dashes are considered
   less formal than parentheses; they are also more intrusive.
   If you want to draw attention to the parenthetical content,
   use dashes. If you want to include the parenthetical content
   more subtly, use parentheses.\"
  - \"Note that when dashes are used in place of parentheses,
     surrounding punctuation should be omitted.\"
- \"can be used in place of a colon when you want to emphasize
   the conclusion of your sentence. The dash is less formal than
   the colon.\"
- \"Two em dashes can be used to indicate missing portions of a
   word, whether unknown or intentionally omitted.\"
  - \"When an entire word is missing, either two or three em
     dashes can be used. Whichever length you choose, use it
     consistently throughout your document. Surrounding punctuation
     should be placed as usual.\"
- \"The em dash is typically used without spaces on either side,
   and that is the style used in this guide. Most newspapers,
   however, set the em dash off with a single space on each side.\"
Source: URL `https://www.thepunctuationguide.com/em-dash.html'"
  (interactive)
  (help/real-insert ?—))
(defun help/insert-en-dash ()
  "Insert a EN-DASH.
- \"is used to represent a span or range of numbers, dates,
   or time. There should be no space between the en dash and
   the adjacent material. Depending on the context, the en
   dash is read as “to” or “through.”\"
  - \"If you introduce a span or range with words such as
     'from' or 'between', do not use the en dash.\"
- \"is used to report scores or results of contests.\"
- \"an also be used between words to represent conflict,
   connection, or direction.\"
- \"When a compound adjective is formed with an element that
   is itself an open compound or hyphenated compound, some
   writers replace the customary hyphen with an en dash. This
   is an aesthetic choice more than anything.
Source: URL `https://www.thepunctuationguide.com/en-dash.html'"
  (interactive)
  (help/real-insert ?–))
(defun help/insert-hyphen ()
  "Insert a HYPHEN
- \"For most writers, the hyphen’s primary function is the
   formation of certain compound terms. The hyphen is also
   used for word division [in typesetting].
- \"Compound terms are those that consist of more than one
   word but represent a single item or idea.\"
Source: URL `https://www.thepunctuationguide.com/hyphen.html'"
  (interactive)
  (help/real-insert ?-))
;; (global-set-key (kbd "-") #'help/insert-hyphen)
(global-set-key (kbd "s-_") #'help/insert-em-dash)
(global-set-key (kbd "s--") #'help/insert-en-dash)
