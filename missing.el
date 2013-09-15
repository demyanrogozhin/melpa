#!/bin/sh
:;exec emacs --script "$0" "$@"

(defun missing-packages (recipes packages)
  "Show elements of RECIPES that are no in PACKAGES."
  (let (missing)
    (while recipes
      (let ((recipe (car recipes))
            (package (car packages)))
        (cond
         ((or (not package) (string< recipe package))
          (setq missing (cons recipe missing)))
         ((string< package recipe)
          (error "Package has no recipe: %s" package))
         (t (setq packages (cdr packages)))))
      (setq recipes (cdr recipes)))
    (reverse missing)))

(defun stripstuff (fn)
  "Strip the date and extension from FN."
  (string-match "\\(.*\\)-[0-9]+\\.[0-9]+\\.\\(el$\\|tar$\\)" fn)
  (match-string 1 fn))

(mapc 'print
      (missing-packages
       (sort (directory-files "recipes/" nil "^[^.].*") 'string<)
       (sort (mapcar 'stripstuff (directory-files "packages/" nil "^[^.].*\\\(el$\\\|tar$\\\)")) 'string<)))
