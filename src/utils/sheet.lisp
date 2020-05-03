(defpackage cl-gas-nippo/src/utils/sheet
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :get-or-create-sheet))
(in-package :cl-gas-nippo/src/utils/sheet)

(defun.ps get-or-create-sheet (ss sheet-name)
  (let ((sheet (ss.get-sheet-by-name sheet-name)))
    (when sheet
      (return-from get-or-create-sheet sheet))
    (ss.insert-sheet sheet-name)
    (ss.get-sheet-by-name sheet-name)))
