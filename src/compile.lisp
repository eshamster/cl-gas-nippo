(defpackage cl-gas-nippo/src/compile
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :compile-gas)
  (:import-from :cl-gas-nippo/src/main
                :main)
  (:import-from :split-sequence
                :split-sequence))
(in-package :cl-gas-nippo/src/compile)

(defun compile-gas (out)
  (let* ((str (with-use-ps-pack (:this)
                (main)))
         (splitted (split-sequence #\Newline str)))
    (format out "~{~A~%~}
function main() {
  ~A
}" (butlast splitted) (car (last splitted)))))
