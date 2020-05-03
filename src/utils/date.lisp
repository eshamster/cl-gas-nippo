(defpackage cl-gas-nippo/src/utils/date
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :now
           :date-to-string))
(in-package :cl-gas-nippo/src/utils/date)

(defun.ps now ()
  (new (-date)))

(defun.ps date-to-string (date)
  (+ (date.get-full-year) "/"
     (1+ (date.get-month)) "/"
     (date.get-date)))
