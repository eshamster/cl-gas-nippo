(defpackage cl-gas-nippo/src/nippo-content
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :make-content)
  (:import-from :cl-gas-nippo/src/const
                :get-const)
  (:import-from :cl-gas-nippo/src/utils/date
                :date-to-string
                :get-today-date
                :date=
                :date>)
  (:import-from :cl-gas-nippo/src/utils/sheet
                :get-spreadhsheet
                :get-sheet
                :get-column-index-by-name))
(in-package :cl-gas-nippo/src/nippo-content)

;; The followings are assumed.
;; - Rows are soreted by date
;; - Next date of today in the sheet is a next business day

(defun.ps make-content (now)
  (let* ((sheet (get-sheet (get-spreadhsheet)
                           (get-const :sheet-name-nippo)))
         (date-index (get-column-index-by-name
                      sheet (get-const :column-name-date)))
         (category-index (get-column-index-by-name
                          sheet (get-const :column-name-category)))
         (content-index (get-column-index-by-name
                         sheet (get-const :column-name-content)))
         (last-row (sheet.get-last-row))
         (today-contents (list))
         (next-contents (list))
         (today (get-today-date))
         (next-date nil))
    (loop :for row :from 2 :to last-row :do
         ;; TODO: Don't read category and content if not required.
         (let ((date-val (chain (sheet.get-range row date-index)
                                (get-value)))
               (category-val (chain (sheet.get-range row category-index)
                                    (get-value)))
               (content-val (chain (sheet.get-range row content-index)
                                   (get-value))))
           (when (and (date> date-val today)
                      (null next-date))
             (setf next-date date-val))
           (if (string= category-val (get-const :category-do))
               (cond ((date= date-val today)
                      (today-contents.push content-val))
                     ((and next-date (date= date-val next-date))
                      (next-contents.push content-val)))
               (error "not implemented"))))
    (let ((today-content-text (format-content "やったこと" today-contents))
          (next-content-text (format-content "次にすること" next-contents)))
      (+ today-content-text next-content-text))))

(defun.ps format-content (title contents)
  (when (= contents.length 0)
    (return-from format-content ""))
  (let* ((nl #\Newline)
         (res (+ "【" title "】" nl)))
    (dolist (c contents)
      (setf res (+ res "- "
                   (c.replace (regex "/\\n/g") (+ nl "  "))
                   nl)))
    (+ res nl)))
