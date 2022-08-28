(defpackage cl-gas-nippo/src/nippo-content
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :make-content)
  (:import-from :cl-gas-nippo/src/aggregate
                :aggregate)
  (:import-from :cl-gas-nippo/config
                :get-config)
  (:import-from :cl-gas-nippo/src/const
                :get-const)
  (:import-from :cl-gas-nippo/src/content-info
                :make-category-info-list
                :find-category-info
                :do-subcategory
                :category-info-contents
                :push-content-row)
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
                           (get-config :sheet-name-nippo)))
         (date-index (get-column-index-by-name
                      sheet (get-const :column-name-date)))
         (category-index (get-column-index-by-name
                          sheet (get-const :column-name-category)))
         (subcategory-index (get-column-index-by-name
                             sheet (get-const :column-name-subcategory)))
         (content-index (get-column-index-by-name
                         sheet (get-const :column-name-content)))
         (last-row (sheet.get-last-row))
         (today-category-info-list (make-category-info-list))
         (next-category-info-list (make-category-info-list))
         (today (get-today-date)))
    (multiple-value-bind (start-row end-row)
        (find-today-and-next-rows sheet today date-index)
      (loop :for row :from start-row :to end-row :do
           (let* ((date-val (get-value-at sheet row date-index))
                  (category-val (get-value-at sheet row category-index))
                  (subcategory-val (get-value-at sheet row subcategory-index))
                  (content-val (get-value-at sheet row content-index))
                  ;; Note: Range from start-row to end-row includes only today and next date.
                  ;; So if a date is not today, it is next date.
                  (target-list (if (date= date-val today)
                                   today-category-info-list
                                   next-category-info-list)))
             (push-content-row :category-info-list target-list
                               :category category-val
                               :subcategory subcategory-val
                               :content content-val))))
    (let* ( ; today do
           (today-do-info (find-category-info today-category-info-list
                                              (get-const :category-do)))
           (today-content-text (format-content "やったこと" today-do-info))
           ;; next day do
           (next-do-info (find-category-info next-category-info-list
                                             (get-const :category-do)))
           (next-content-text (format-content "次にすること" next-do-info))
           ;; aggregate
           (aggregate-contents (aggregate today today-do-info next-do-info))
           (aggregate-category "集計")
           (aggregate-text "")
           ;; other
           (other-text ""))
      ;; format aggregate
      (dolist (c aggregate-contents)
        (push-content-row :category-info-list today-category-info-list
                          :category aggregate-category
                          :subcategory ""
                          :content c))
      (setf aggregate-text
            (format-content aggregate-category
                            (find-category-info today-category-info-list
                                                aggregate-category)))
      ;; format others
      (do-other-category (c)
        (let ((category-info (find-category-info today-category-info-list c)))
          (when category-info
            (setf other-text
                  (+ other-text (format-content
                                 (get-title-of-category c) category-info))))))
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

(defun.ps format-content (title category-info)
  (unless category-info
    (return-from format-content ""))
  (let* ((nl #\Newline)
         (res (+ "【" title "】" nl)))
    (do-subcategory ((name contents) category-info)
      (let* ((has-name (not (string= name "")))
             (offset (if has-name "    " "")))
        (when has-name
          (setf res (+ res "- " name nl)))
        (dolist (c contents)
          (setf res (+ res offset "- "
                       (c.replace (regex "/\\n/g") (+ nl offset "  "))
                       nl)))))
    (+ res nl)))
