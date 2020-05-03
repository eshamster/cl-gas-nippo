(defpackage cl-gas-nippo/src/init
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :init)
  (:import-from :cl-gas-nippo/src/const
                :nippo-sheet-name
                :nippo-log-sheet-name)
  (:import-from :cl-gas-nippo/src/utils/sheet
                :get-or-create-sheet
                :get-spreadhsheet))
(in-package :cl-gas-nippo/src/init)

(defun.ps+ init ()
  (let ((ss (get-spreadhsheet)))
    (multiple-value-bind (sheet existing-p)
        (get-or-create-sheet ss (nippo-log-sheet-name))
      (unless existing-p
        (init-nippo-log-sheet sheet)))
    (multiple-value-bind (sheet existing-p)
        (get-or-create-sheet ss (nippo-sheet-name))
      (unless existing-p
        (init-nippo-sheet sheet)))))

(defun.ps init-nippo-sheet (sheet)
  (init-nippo-sheet-header sheet))

(defun.ps init-nippo-log-sheet (sheet)
  (init-nippo-sheet-header sheet))

(defun.ps init-nippo-sheet-header (sheet)
  (chain (sheet.get-range "A1:C1")
         (set-values '(("Date" "Catergory" "Content")))))
