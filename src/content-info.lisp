(defpackage cl-gas-nippo/src/content-info
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :make-category-info-list
           :find-category-info
           :do-subcategory
           :category-info-contents
           :push-content-row)
  (:import-from :alexandria
                :with-gensyms))
(in-package :cl-gas-nippo/src/content-info)

;; --- types --- ;;

(defstruct.ps+ subcategory-info
  name
  ;; Use list not to change order
  contents)

(defstruct.ps+ category-info
  name
  ;; Use list not to change order
  subcategory-info-list)

;; --- export --- ;;

(defun.ps+ make-category-info-list ()
  ;; empty list
  (list))

(defun.ps+ push-content-row (&key category-info-list category subcategory content)
  (let* ((c-info (find-or-create-category-info
                  category-info-list
                  category))
         (subc-info (find-or-create-subcategory-info
                     (category-info-subcategory-info-list c-info)
                     subcategory)))
    (push content (subcategory-info-contents subc-info))))

(defun.ps+ find-category-info (category-info-list category)
  (find-if (lambda (info)
             (string= (category-info-name info) category))
           category-info-list))

(defun.ps+ category-info-contents (category-info)
  (let ((result (list)))
    (dolist (subc-info (category-info-subcategory-info-list category-info))
      (setf result
            (append result (subcategory-info-contents subc-info))))))

(defmacro.ps+ do-subcategory (((var-name var-contents) category-info) &body body)
  (with-gensyms (subc-info)
    `(dolist (,subc-info (reverse (category-info-subcategory-info-list ,category-info)))
       (let ((,var-name (subcategory-info-name ,subc-info))
             (,var-contents (reverse (subcategory-info-contents ,subc-info))))
         ,@body))))

;; --- internal --- ;;

(defun.ps+ find-or-create-category-info (category-info-list category)
  (let ((info (find-category-info category-info-list category)))
    (unless info
      (setf info (make-category-info
                  :name category
                  :subcategory-info-list (list)))
      (push info category-info-list))
    info))

(defun.ps+ find-subcategory-info (subcategory-info-list subcategory)
  (find-if (lambda (info)
             (string= (subcategory-info-name info) subcategory))
           subcategory-info-list))

(defun.ps+ find-or-create-subcategory-info (subcategory-info-list subcategory)
  (let ((info (find-subcategory-info subcategory-info-list subcategory)))
    (unless info
      (setf info (make-subcategory-info
                  :name subcategory
                  :contents (list)))
      (push info subcategory-info-list))
    info))
