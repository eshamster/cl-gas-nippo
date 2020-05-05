(defpackage cl-gas-nippo/src/utils/date
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :now
           :date-to-string
           :get-date
           :get-today-date
           :date=
           :date>
           :date-month=
           :date-month>))
(in-package :cl-gas-nippo/src/utils/date)

(defun.ps now ()
  (new (-date)))

(defun.ps date-to-string (date)
  (+ (date.get-full-year) "/"
     (1+ (date.get-month)) "/"
     (date.get-date)))

(defun.ps get-date (date-diff)
  (let ((now (now)))
    (new (-date (now.get-full-year)
                (now.get-month)
                (+ (now.get-date) date-diff)))))

(defun.ps+ get-today-date ()
  (get-date 0))

(defun.ps date= (date1 date2)
  (= (date1.get-time) (date2.get-time)))

(defun.ps date> (date1 date2)
  (> (date1.get-time) (date2.get-time)))

(defun.ps date-month= (date1 date2)
  (and (= (date1.get-year) (date2.get-year))
       (= (date1.get-month) (date2.get-month))))

(defun.ps date-month> (date1 date2)
  (or (> (date1.get-year) (date2.get-year))
      (and (= (date1.get-year) (date2.get-year))
           (> (date1.get-month) (date2.get-month)))))
