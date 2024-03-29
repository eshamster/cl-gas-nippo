(defpackage cl-gas-nippo/src/const
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :get-const))
(in-package :cl-gas-nippo/src/const)

(defvar.ps+ *const-table*
    (let ((res (make-hash-table))
          (lst '((:column-name-date "Date")
                 (:column-name-category "Category")
                 (:column-name-subcategory "Subcategory")
                 (:column-name-content "Content")
                 (:category-do "やること")
                 (:log-name-done "やったこと")
                 (:log-name-next "次にすること"))))
      (dolist (pair lst)
        (setf (gethash (car pair) res)
              (cadr pair)))
      res))

(defun.ps+ get-const (name)
  (let ((res (gethash name *const-table*)))
    (unless res
      (error "Constant value \"~S\" is not defined" name))
    res))
