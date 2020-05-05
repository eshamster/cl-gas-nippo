(defpackage cl-gas-nippo/src/utils/config
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :get-value
           :check-if-other-category
           :get-title-of-category
           :do-other-category)
  (:import-from :cl-gas-nippo/config
                :get-config-list)
  (:import-from :cl-gas-nippo/src/const
                :get-const)
  (:import-from :alexandria
                :with-gensyms))
(in-package :cl-gas-nippo/src/utils/config)

(defvar.ps+ *config-table* nil)
(defvar.ps+ *other-categories* (list)
  "list of (:category X :title Y)
Note: Hold as list instead of as hash-table to keep order")

(defun.ps+ get-value (key)
  (gethash key (get-config-table)))

(defun.ps+ get-config-table ()
  (unless *config-table*
    (init-config-table))
  *config-table*)

(defun.ps+ init-config-table ()
  (let ((table (make-hash-table)))
    (dolist (pair (get-config-list))
      (setf (gethash (car pair) table)
            (cadr pair)))
    (setf *config-table* table)
    (let ((categories (gethash :other-categories table)))
      (when categories
        (check-other-category categories)
        (setf *other-categories* categories)))))

;; --- other categories --- ;;

(defun.ps+ check-other-category (categories)
  (dolist (c categories)
    (let* ((name (getf c :category))
           (found (find name (list (get-const :category-do)))))
      (when found
        (error "The category \"~S\" is not allowed as an other category because it is defined as a default category" found)))))

(defun.ps+ get-other-categories ()
  *other-categories*)

(defun.ps+ must-find-other-category (name)
  (let ((res (find-if (lambda (c) (string= name (getf c :category)))
                      (get-other-categories))))
    (unless res
      (error "Unrecognized category: ~S" name))
    res))

(defun.ps+ check-if-other-category (name)
  (must-find-other-category name))

(defun.ps+ get-title-of-category (name)
  (getf (must-find-other-category name) :title))

(defmacro.ps+ do-other-category ((var) &body body)
  (with-gensyms (c)
    `(dolist (,c (get-other-categories))
       (let ((,var (getf ,c :category)))
         ,@body))))
