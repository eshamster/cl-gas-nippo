(defpackage cl-gas-nippo/src/aggregate
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :aggregate)
  (:import-from :cl-gas-nippo/src/const
                :get-const)
  (:import-from :cl-gas-nippo/src/utils/date
                :date=
                :date>)
  (:import-from :cl-gas-nippo/src/utils/sheet
                :get-column-index-by-name
                :get-spreadhsheet
                :get-sheet
                :get-value-at))
(in-package :cl-gas-nippo/src/aggregate)

(defun.ps+ aggregate (date today-contents next-contents)
  (log-today-and-next date today-contents next-contents))

(defun.ps+ log-today-and-next (date today-contents next-contents)
  (let* ((sheet (get-sheet (get-spreadhsheet)
                           (get-const :sheet-name-nippo-log))))
    (delete-date-logs sheet date)
    (log-contents sheet date "やったこと" today-contents)
    (log-contents sheet date "次にすること" next-contents)))

(defun.ps log-contents (sheet date category contents)
  (let ((date-index (get-column-index-by-name
                     sheet (get-const :column-name-date)))
        (category-index (get-column-index-by-name
                         sheet (get-const :column-name-category)))
        (content-index (get-column-index-by-name
                        sheet (get-const :column-name-content)))
        (from-row (1+ (sheet.get-last-row)))
        (len (length contents)))
    (chain (sheet.get-range from-row date-index len 1)
           (set-values (make-same-element-list
                        len (lambda () (list date)))))
    (chain (sheet.get-range from-row category-index len 1)
           (set-values (make-same-element-list
                        len (lambda () (list category)))))
    (chain (sheet.get-range from-row content-index len 1)
           (set-values (mapcar (lambda (c) (list c))
                               contents)))))

(defun.ps+ make-same-element-list (len fn-make-element)
  (let ((res (list)))
    (dotimes (i len)
      (push (funcall fn-make-element) res))
    res))

(defun.ps delete-date-logs (sheet date)
  (let ((date-index (get-column-index-by-name
                     sheet (get-const :column-name-date)))
        (last-row (sheet.get-last-row)))
    (loop :for row :from last-row :downto 2 :do
         (let ((date-val (get-value-at sheet row date-index)))
           (cond ((and date-val (date= date date-val))
                  (sheet.delete-row row))
                 ((and date-val (date> date date-val))
                  (return)))))))
