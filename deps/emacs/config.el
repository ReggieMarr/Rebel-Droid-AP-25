;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(with-eval-after-load 'ox-latex
(add-to-list 'org-latex-classes
             '("org-plain-latex"
               "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

;; LATEX
(setq +latex-viewrs '(pdf-tools))

(defun latex-compile ()
    (interactive)
    (save-buffer)
    (TeX-command "LaTeX" 'TeX-master-file))

(eval-after-load 'latex
  '(define-key TeX-mode-map (kbd "C-c C-g") 'latex-compile))

(with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("altacv" "\\documentclass[10pt,a4paper,ragged2e,withhyper]{altacv}
    \\usepackage{fontspec}
    \\usepackage[english]{babel}
    \\usepackage[utf8]{inputenc}
    \\usepackage[T1]{fontenc}
    \\usepackage{lmodern}
    \\usepackage{hyperref}
    \\usepackage{tabularx}
    \\usepackage{graphicx}
    \\usepackage{fontawesome}
    \\usepackage{academicons}
    \\usepackage[margin=1cm]{geometry}
    \\usepackage{paracol}
    \\usepackage{enumitem}
    [NO-DEFAULT-PACKAGES]
    [NO-PACKAGES]"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))

(require 'ox-hugo)
(after! org
  (use-package! ox-extra
    :config
    (ox-extras-activate '(latex-header-blocks ignore-headlines))))

;; (defun export-org-files-to-hugo (src-dir dest-dir)
;;   (dolist (file (directory-files-recursively src-dir "\\.org$"))
;;     (with-current-buffer (find-file-noselect file)
;;       (let ((org-hugo-base-dir dest-dir))
;;         (org-hugo-export-to-md))
;;       (kill-buffer))))

;; (defun batch-export-org-to-hugo ()
;;   (export-org-files-to-hugo "/home/user/org_src" "/home/user/.org_out"))

;; ;; Only run the export when in batch mode
;; (when noninteractive
;;   (batch-export-org-to-hugo))

(use-package dired
  :custom ((dired-listing-switches "-lagh --dired --group-directories-first"))
  :config

  (map! :map dired-mode-map
        :localleader
        "q" #'dired-toggle-read-only)

(with-eval-after-load 'evil-collection
        (evil-define-key* '(normal) dired-mode-map
                (kbd "M-RET") #'my/dired-open-externally)

        (evil-collection-define-key 'normal 'dired-mode-map
                "h" 'dired-up-directory
                "l" 'dired-find-file))

  (setq dired-recursive-deletes "top"))

(after! org
  (setq org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
  (setq plantuml-default-exec-mode 'jar)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)
     )))

(setq plantuml-executable-path "/usr/bin/plantuml")
(setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
