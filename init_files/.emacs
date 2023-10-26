(setq-default major-mode 'text-mode)
(setq-default tab-width 4)
(setq-default inhibit-startup-screen t)
(setq-default column-number-mode t)
(setq-default show-paren-mode t)
(setq-default require-final-newline t)
(setq-default save-abbrevs nil)
(setq-default show-paren-style 'parenthesis) ; otherwise 'expression
(setq-default font-latex-fontify-script nil)

(add-to-list 'default-frame-alist '(width  . 80))
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(font   . "Menlo-18"))
(load-theme 'misterioso t)

(remove-hook 'text-mode-hook 'turn-on-auto-fill)

;;; ESS
(add-hook 'ess-mode-hook
          (lambda ()
            (ess-set-style 'C++ 'quiet)
            ;; Because
            ;;                                 DEF GNU BSD K&R C++
            ;; ess-indent-level                  2   2   8   5   4
            ;; ess-continued-statement-offset    2   2   8   5   4
            ;; ess-brace-offset                  0   0  -8  -5  -4
            ;; ess-arg-function-offset           2   4   0   0   0
            ;; ess-expression-offset             4   2   8   5   4
            ;; ess-else-offset                   0   0   0   0   0
            ;; ess-close-brace-offset            0   0   0   0   0
            (add-hook 'local-write-file-hooks
                      (lambda ()
                        (ess-nuke-trailing-whitespace)))))
(setq-default ess-nuke-trailing-whitespace-p t)

;;; Perl
(add-hook 'perl-mode-hook
          (lambda () (setq perl-indent-level 4)))

(setq-default c-default-style "bsd")
(setq-default c-basic-offset 4)
