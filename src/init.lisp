(defpackage cl-gas-nippo/src/init
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :init)
  (:import-from :cl-gas-nippo/src/const
                :get-const)
  (:import-from :cl-gas-nippo/src/utils/sheet
                :get-or-create-sheet
                :get-spreadhsheet))
(in-package :cl-gas-nippo/src/init)

(defun.ps+ init ()
  (let ((ss (get-spreadhsheet)))
    (multiple-value-bind (sheet existing-p)
        (get-or-create-sheet ss (get-const :sheet-name-nippo-log))
      (unless existing-p
        (init-nippo-log-sheet sheet)))
    (multiple-value-bind (sheet existing-p)
        (get-or-create-sheet ss (get-const :sheet-name-nippo))
      (unless existing-p
        (init-nippo-sheet sheet)))))

(defun.ps init-nippo-sheet (sheet)
  (init-nippo-sheet-header sheet))

(defun.ps init-nippo-log-sheet (sheet)
  (init-nippo-sheet-header sheet))

(defun.ps init-nippo-sheet-header (sheet)
  (chain (sheet.get-range "A1:C1")
         (set-values (list (list (get-const :column-name-date)
                                 (get-const :column-name-category)
                                 (get-const :column-name-content))))))
