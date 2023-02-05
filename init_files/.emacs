(setq-default major-mode 'text-mode)
(setq inhibit-startup-screen t)
(setq column-number-mode t)
(setq show-paren-mode t)
(setq require-final-newline t)
(setq save-abbrevs nil)
(setq show-paren-style 'parenthesis) ; otherwise 'expression
(setq font-latex-fontify-script nil)

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
(setq ess-nuke-trailing-whitespace-p t)
(ess-toggle-underscore nil)

;;; Perl
(add-hook 'perl-mode-hook
          (lambda () (setq perl-indent-level 4)))

(setq c-default-style "bsd")
(setq c-basic-offset 4)
