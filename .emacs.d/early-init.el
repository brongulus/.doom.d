;;; early-init.el -*- lexical-binding: t; -*-

(defconst my-saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil
			load-prefer-newer t
			mode-line-format nil)

(setq default-frame-alist
			'((menu-bar-lines . 0)
			 (tool-bar-lines . 0)
			 (vertical-scroll-bars)
			 (left-fringe . 0)
			 (right-fringe . 0)
			 (internal-border-width . 8)))

(setq gc-cons-threshold (* 128 1024 1024)
      garbage-collection-messages nil)

(setq package-enable-at-startup nil
      load-prefer-newer t
      auto-save-default nil
      auto-save-list-file-prefix nil
      make-backup-files nil
      create-lockfiles nil
      inhibit-startup-screen t
      frame-inhibit-implied-resize t)

(provide 'early-init)
;;; early-init.el ends here
