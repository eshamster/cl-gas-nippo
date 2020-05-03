(defpackage cl-gas-nippo/src/const
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :nippo-sheet-name
           :nippo-log-sheet-name))
(in-package :cl-gas-nippo/src/const)

(defun.ps+ nippo-sheet-name () "日報用")
(defun.ps+ nippo-log-sheet-name () "日報ログ")
