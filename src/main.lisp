(defpackage cl-gas-nippo/src/main
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :main)
  (:import-from :cl-gas-nippo/src/utils/config
                :get-value)
  (:import-from :cl-gas-nippo/src/utils/sheet
                :get-or-create-sheet))
(in-package :cl-gas-nippo/src/main)

(defun.ps main ()
  (let ((ss (-spreadsheet-app.open-by-id (get-value :spreadsheet-id))))
    (get-or-create-sheet ss "日報用")))
