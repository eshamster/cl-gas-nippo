(defpackage cl-gas-nippo/src/nippo-content
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :make-content)
  (:import-from :cl-gas-nippo/src/aggregate
                :aggregate)
  (:import-from :cl-gas-nippo/src/const
                :get-const)
  (:import-from :cl-gas-nippo/src/utils/config
                :check-if-other-category
                :get-title-of-category
                :do-other-category)
  (:import-from :cl-gas-nippo/src/utils/date
                :date-to-string
                :get-today-date
                :date=
                :date>)
  (:import-from :cl-gas-nippo/src/utils/sheet
                :get-spreadhsheet
                :get-sheet
                :get-column-index-by-name
                :get-value-at
                :do-sheet-row-rev))
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
         (other-contents-table (make-hash-table))
         (today (get-today-date)))
    (multiple-value-bind (start-row end-row)
        (find-today-and-next-rows sheet today date-index)
      (loop :for row :from start-row :to end-row :do
           (let ((date-val (get-value-at sheet row date-index))
                 (category-val (get-value-at sheet row category-index))
                 (content-val (get-value-at sheet row content-index)))
             (if (string= category-val (get-const :category-do))
                 (cond ((date= date-val today)
                        (today-contents.push content-val))
                       ;; Note: Range from start-row to end-row includes only today and next date.
                       ;; So if a date is not today, it is next date.
                       (t (next-contents.push content-val)))
                 (when (date= date-val today)
                   (check-if-other-category category-val)
                   (let ((lst (gethash category-val other-contents-table)))
                     (unless lst (setf lst (list)))
                     (lst.push content-val)
                     (setf (gethash category-val other-contents-table) lst)))))))
    (let ((today-content-text (format-content "やったこと" today-contents))
          (next-content-text (format-content "次にすること" next-contents))
          (aggregate-text (format-content "集計" (aggregate today today-contents next-contents)))
          (other-text ""))
      (do-other-category (c)
        (let ((contents (gethash c other-contents-table)))
          (when contents
            (setf other-text
                  (+ other-text (format-content
                                 (get-title-of-category c) contents))))))
      (+ aggregate-text today-content-text next-content-text other-text))))

(defun.ps find-today-and-next-rows (sheet today-date date-index)
  (let (start-row end-row next-date)
    (do-sheet-row-rev (row sheet)
      (let ((date-val (get-value-at sheet row date-index)))
        (unless next-date
          (setf next-date date-val
                start-row row
                end-row row))
        (when (date> today-date date-val)
          (return))
        (cond ((date= today-date date-val)
               (setf start-row row))
              ((date> next-date date-val)
               (setf next-date date-val
                     end-row row))
              (t (setf start-row row)))))
    (values start-row end-row)))

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
