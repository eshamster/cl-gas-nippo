(defpackage cl-gas-nippo/src/utils/sheet
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :get-or-create-sheet
           :get-spreadhsheet)
  (:import-from :cl-gas-nippo/src/utils/config
                :get-value))
(in-package :cl-gas-nippo/src/utils/sheet)

(defvar.ps+ *spreadsheet* nil)

(defun.ps get-spreadhsheet ()
  (unless *spreadsheet*
    (setf *spreadsheet* (-spreadsheet-app.open-by-id (get-value :spreadsheet-id))))
  *spreadsheet*)

(defun.ps get-or-create-sheet (ss sheet-name)
  (let ((sheet (ss.get-sheet-by-name sheet-name)))
    (when sheet
      (return-from get-or-create-sheet (values sheet t)))
    (ss.insert-sheet sheet-name)
    (values (ss.get-sheet-by-name sheet-name) nil)))
