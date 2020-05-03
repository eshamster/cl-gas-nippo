(defpackage cl-gas-nippo/src/main
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :main)
  (:import-from :cl-gas-nippo/src/init
                :init))
(in-package :cl-gas-nippo/src/main)

(defun.ps main ()
  (init))
