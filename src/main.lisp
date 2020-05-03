(defpackage cl-gas-nippo/src/main
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :main))
(in-package :cl-gas-nippo/src/main)

(defun.ps main ()
  (-logger.log "Hello GAS on Lisp"))
