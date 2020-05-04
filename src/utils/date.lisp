(defpackage cl-gas-nippo/src/utils/date
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :now
           :date-to-string
           :get-date
           :get-today-date
           :date=
           :date>))
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
