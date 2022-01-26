;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)
;
;;##########PACKAGES###########
(unpin! doom-themes)
;; (package! solaire-mode :disable t)


(package! org-fragtog)
(package! anki-editor)
;;(package! xkcd)
;;(package! pocket-reader)
(package! geiser)
(package! elvish-mode)
(package! dirvish)
(package! spray)
(package! oj)
(package! guix)
(package! iscroll)
(package! rainbow-mode)
(package! ox-hugo)
;; (package! vuiet)
;; (package! tree-sitter)
;; (package! tree-sitter-langs)
(package! info-colors)
(package! yequake)
(package! devdocs)
(package! vertico-posframe)
;;(package! systemd)
;;(package! emms)
;;(package! theme-magic)
;;(package! counsel-spotify)
;; (package! telega)
;;(package! nov)
(package! conllu-mode)
(package! graphviz-dot-mode)
;;(package! modus-vivendi-theme)
;;(package! modus-operandi-theme)
(package! lexic
  :recipe (:host github :repo "tecosaur/lexic"))
;;(package! el-secretario
;;  :recipe (:host github :repo "zetagon/el-secretario"))
;;(package! org-ql)
(package! lsp-julia :recipe (:host github :repo "non-jedi/lsp-julia"))
;;(package! doom-nano-testing
;;  :recipe (:host github :repo "brongulus/doom-nano-testing"))
(package! nano-emacs
  :recipe (:host github :repo "rougier/nano-emacs"))
(package! notebook-mode
  :recipe (:host github :repo "rougier/notebook-mode"))
;; FIXME
(package! pdf-continuous-scroll-mode
  :recipe (:host github :repo "dalanicolai/pdf-continuous-scroll-mode.el"))
(package! org-ol-tree
  :recipe (:host github :repo "Townk/org-ol-tree"))
;; TEMP
;; (package! company-box
;;   :recipe (:host github :repo "brongulus/company-box"))

;; If I end up testing gccemacs
(package! webkit
 :recipe (:type git :host github :repo "akirakyle/emacs-webkit"
          :branch "main" :files (:defaults "*.js" "*.css" "*.so")
          :pre-build ("make")))
;; (package! paper-mode
;;   :recipe (:host github :repo "ymarco/paper-mode"))


;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)
