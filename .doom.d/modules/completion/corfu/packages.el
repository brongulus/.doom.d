;; -*- no-byte-compile: t; -*-
;;; completion/corfu/packages.el

(package! corfu)
(package! cape)
(package! orderless)
(package! corfu-terminal
  :recipe (:repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))
(package! popon
  :recipe (:repo "https://codeberg.org/akib/emacs-popon.git"))

(when (featurep! +lsp)
  (package! kind-icon)
  (package! corfu-doc
    :recipe (:host github :repo "galeo/corfu-doc")))
