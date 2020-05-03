(defpackage cl-gas-nippo/src/nippo
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :make-nippo)
  (:import-from :cl-gas-nippo/config
                :get-body-template)
  (:import-from :cl-gas-nippo/src/utils/config
                :get-value)
  (:import-from :cl-gas-nippo/src/utils/date
                :now
                :date-to-string))
(in-package :cl-gas-nippo/src/nippo)

(defun.ps make-nippo ()
  (let* ((today-string (date-to-string (now)))
         (title (chain (get-value :title)
                       (replace "{date}" today-string)))
         (content "hoge")
         (body (chain (get-body-template)
                      (replace "{content}" content)))
         (opts (make-hash-table))
         (to (get-value :to))
         (cc (get-value :cc))
         (bcc (get-value :bcc)))
    (unless to
      (error ":to configuration is required"))
    (when cc
      (setf (gethash :cc opts) cc))
    (when bcc
      (setf (gethash :bcc opts) bcc))
    (-gmail-app.create-draft to title body opts)))
