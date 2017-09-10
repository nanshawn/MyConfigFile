;;; packages.el --- mineo-rtags layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Wieland Hoffmann <wieland@mineo>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `mineo-rtags-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `mineo-rtags/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `mineo-rtags/pre-init-PACKAGE' and/or
;;   `mineo-rtags/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst mineo-rtags-packages
  '(cmake-ide
    helm-rtags
    ;; ivy-rtags
    rtags
    flycheck-rtags
    company-rtags
    ))

(defun mineo-rtags/init-cmake-ide ()
  (use-package cmake-ide
    ;; :config
    :init
    (cmake-ide-setup)))

(defun mineo-rtags/init-rtags ()
  (use-package rtags
    :init
    (setq rtags-autostart-diagnostics t
          rtags-completions-enabled t
          rtags-display-result-backend 'helm
          company-rtags-begin-after-member-access t
          )
    ;(push '(company-rtags)
    ;      company-backends-c-mode-common)
    (rtags-enable-standard-keybindings c-mode-base-map)
    (rtags-diagnostics)
    (add-hook 'c-mode-hook 'rtags-start-process-unless-running)
    (add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
    (add-hook 'objc-mode-hook 'rtags-start-process-unless-running)
    )
    ;; (use-package flycheck-rtags
    ;;    :ensure rtags)
    )

(defun mineo-rtags/init-flycheck-rtags()
    (use-package flycheck-rtags
      :init
      (progn
        (defun mineo-flycheck-rtags-setup ()
          "Setup Flycheck and RTags integration."
          ;; See RTags Flycheck integration at https://github.com/Andersbakken/rtags
          (interactive)
          (flycheck-select-checker 'rtags)
          (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
          (setq-local flycheck-check-syntax-automatically nil))
        ;; c-mode-common-hook is also called by c++-mode
        ;; (add-hook 'c-mode-common-hook 'mineo-rtags/flycheck-rtags-setup)
        (add-hook 'c-mode-hook #'mineo-flycheck-rtags-setup)
        (add-hook 'c++-mode-hook #'mineo-flycheck-rtags-setup)
        (add-hook 'objc-mode-hook #'mineo-flycheck-rtags-setup)
         )
      ))


(when (configuration-layer/layer-usedp 'auto-completion)
  (defun mineo-rtags/init-company-rtags()
    (use-package company-rtags
      ;if (configuration-layer/package-usedp 'company)
      :defer t
      :commands company-rtags
      :init
      (progn
        ;; (eval-after-load 'company
        ;;   '(add-to-list
        ;;     'company-backends-c-mode-common 'company-rtags))
        ;; (global-company-mode)
        ;; (eval-after-load 'company
        ;;   '(add-to-list
        ;;     'company-backends 'company-irony))
        ;; (eval-after-load 'company
        ;;   '(add-to-list
        ;;     'company-backends 'company-irony-c-headers))
        (eval-after-load 'company
          '(define-key c-mode-base-map (kbd "<C-tab>") (function company-rtags)))
        ;; (eval-after-load 'company
        ;;   '(define-key c-mode-base-map (kbd "<tab>") (function company-complete)))
        )
      ))
  )

(defun mineo-rtags/init-helm-rtags ()
  (use-package helm-rtags
    :init))

;; (defun mineo-rtags/init-ivy-rtags ()
;;   (use-package ivy-rtags
;;     :init))
;;; packages.el ends here
