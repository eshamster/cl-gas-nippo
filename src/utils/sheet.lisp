(defpackage cl-gas-nippo/src/utils/sheet
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :get-sheet
           :get-or-create-sheet
           :get-spreadhsheet
           :get-column-index-by-name
           :get-value-at)
  (:import-from :cl-gas-nippo/src/utils/config
                :get-value))
(in-package :cl-gas-nippo/src/utils/sheet)

(defvar.ps+ *spreadsheet* nil)

(defun.ps get-spreadhsheet ()
  (unless *spreadsheet*
    (setf *spreadsheet* (-spreadsheet-app.open-by-id (get-value :spreadsheet-id))))
  *spreadsheet*)

(defun.ps get-sheet (ss sheet-name)
  (let ((sheet (ss.get-sheet-by-name sheet-name)))
    (unless sheet
      (error "The sheet \"~S\" is not found" sheet-name))
    sheet))

(defun.ps get-or-create-sheet (ss sheet-name)
  (let ((sheet (ss.get-sheet-by-name sheet-name)))
    (when sheet
      (return-from get-or-create-sheet (values sheet t)))
    (ss.insert-sheet sheet-name)
    (values (ss.get-sheet-by-name sheet-name) nil)))

(defun.ps get-column-index-by-name (sheet column-name)
  (let* ((last-index (sheet.get-last-column))
         (headers (chain (sheet.get-range 1 1 1 last-index)
                         (get-values)
                         (shift))))
    (1+ (headers.index-of column-name))))

(defun.ps get-value-at (sheet row column)
  (chain (sheet.get-range row column)
         (get-value)))
