#!/usr/bin/env doomscript
;;; ../doomscript/org-babel-execute.el -*- lexical-binding: t; -*-

(require 'doom-start)
(require 'org)
(require 'ob-plantuml)

(defcli! my/org-exec
  (src-dir &optional dest-dir)
  "Execute org-babel code blocks in an Org file.

ARGUMENTS:
  FILE  The Org file to process.
  DEST-DIR  The destination directory for org content (optional).

EXAMPLES:
  doom org-babel-execute ~/org-files/README.org -a
  doom org-babel-execute ~/org-files/document.org -s
  doom org-babel-execute ~/org-files/code.org -b"
  (unless src-dir
    (user-error "No file specified"))

  (find-file src-dir)
  (print! "Executing all code blocks in %s" src-dir)
  (org-babel-execute-buffer)
  (org-babel-tangle)
  (save-buffer)
  (kill-buffer))

;; Run the command
(run! "my/org-exec" (cdr (member "--" argv)))
