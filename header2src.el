;;; header2src.el --- Generates C source from header files by simply replacing extern variables  -*- lexical-binding: t; -*-

;; Author: 9timestheSolarMass
;; Maintainer: 9timestheSolarMass
;; Version: 0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: c, tools, convenience
;; URL: https://github.com/NGC250/header2src.el

;;; Commentary:
;; This package extracts extern variable declarations from a C header
;; and generates a matching C source file defining those variables.
;;
;; Usage:
;;   M-x header2src-generate
;;

;;; Code:

(defun header2src-generate ()
  "Generate a .c file containing definitions for all extern vars in the current header."
  (interactive)
  (unless (buffer-file-name)
    (error "This buffer is not visiting a file"))
  (let* ((header-file (buffer-file-name))
         (source-file (concat (file-name-sans-extension header-file) ".c"))
         (python-code "
import numpy as np
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("--headerPath" , help="Path to header file." , type=str , required=True)
parser.add_argument("--sourcePath" , help="Path to save source file." , type=str , required=True)

args = parser.parse_args()

file_path = args.headerPath
save_path = args.sourcePath

body = open(file_path)
header = np.array(body.readlines())

first_char = np.array([line[0] for line in header if len(line) != 0])

check_extern = header[np.where(first_char == "e")[0]] 

extern_loc = [line[7:] for line in check_extern if line[:7] == "extern "]

open(save_path , "w").write(f'#include "{file_path}"\n\n')

with open(save_path , "a") as s:
    s.writelines(str(line) for line in extern_loc)

")
         (output-buffer "*header2src*"))

    (with-current-buffer (get-buffer-create output-buffer)
      (erase-buffer))
    (call-process-region python-code nil "python3"
                         nil output-buffer nil
                         header-file source-file)
    (message "header2src: Generated %s" source-file)))

(provide 'header2src)
