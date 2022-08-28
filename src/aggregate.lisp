(defpackage cl-gas-nippo/src/aggregate
  (:use :cl
        :ps-experiment
        :parenscript)
  (:export :aggregate)
  (:import-from :cl-gas-nippo/src/const
                :get-const)
  (:import-from :cl-gas-nippo/config
                :get-config)
  (:import-from :cl-gas-nippo/src/utils/config
                :do-other-category
                :get-title-of-category)
  (:import-from :cl-gas-nippo/src/utils/date
                :date=
                :date>
                :date-month=
                :date-month>)
  (:import-from :cl-gas-nippo/src/utils/sheet
                :get-column-index-by-name
                :get-spreadhsheet
                :get-sheet
                :get-value-at
                :do-sheet-row-rev))
(in-package :cl-gas-nippo/src/aggregate)

(defun.ps+ aggregate (date today-contents next-contents)
  (let ((ss (get-spreadhsheet))
        (str-lst (list)))
    (log-today-and-next ss date today-contents next-contents)
    (dolist (pair (append (aggregate-nippo-sheet ss date)
                          (aggregate-nippo-log-sheet ss date)))
      (let ((title (car pair))
            (count (cadr pair)))
        (push (+ count "：今月の" title) str-lst)))
    (reverse str-lst)))

;; --- aggregate --- ;;

(defun.ps aggregate-nippo-log-sheet (ss date)
  "Aggregate done and next works of this month.
Return list ((title count)...)"
  (let* ((sheet (get-sheet ss (get-config :sheet-name-nippo-log)))
         (date-index (get-column-index-by-name
                      sheet (get-const :column-name-date)))
         (category-index (get-column-index-by-name
                          sheet (get-const :column-name-category)))
         (category-done (get-const :log-name-done))
         (category-next (get-const :log-name-next))
         (count-done 0)
         (count-next 0))
    (do-sheet-row-rev (row sheet)
      (let ((date-val (get-value-at sheet row date-index)))
        (when (date-month> date date-val)
          (return))
        (when (date-month= date date-val)
          (let ((category-val (get-value-at sheet row category-index)))
            (cond ((string= category-val category-done)
                   (incf count-done))
                  ((string= category-val category-next)
                   (incf count-next))
                  (t (error "Not recognized category \"~S\"" category-val)))))))
    (list (list "「やったこと」" count-done)
          (list "「つぎにすること」" count-next))))

(defun.ps aggregate-nippo-sheet (ss date)
  "Aggregate other categories of this month.
Return list ((title count)...)"
  (let* ((sheet (get-sheet ss (get-config :sheet-name-nippo)))
         (date-index (get-column-index-by-name
                      sheet (get-const :column-name-date)))
         (category-index (get-column-index-by-name
                          sheet (get-const :column-name-category)))
         (count-table (make-hash-table)))
    (do-other-category (c)
      (setf (gethash c count-table) 0))
    (do-sheet-row-rev (row sheet)
      (let ((date-val (get-value-at sheet row date-index)))
        (when (date-month> date date-val)
          (return))
        (when (and (date-month= date date-val))
          (let* ((category-val (get-value-at sheet row category-index))
                 (count (gethash category-val count-table)))
            (unless (null count)
              (setf (gethash category-val count-table) (1+ count)))))))
    (let ((res (list)))
      (do-other-category (c)
        (res.push (list (get-title-of-category c)
                        (gethash c count-table))))
      res)))

;; --- logging ---- ;;

(defun.ps+ log-today-and-next (ss date today-contents next-contents)
  (let* ((sheet (get-sheet ss (get-config :sheet-name-nippo-log))))
    (delete-date-logs sheet date)
    (when today-contents
      (log-contents sheet date (get-const :log-name-done) today-contents))
    (when next-contents
      (log-contents sheet date (get-const :log-name-next) next-contents))))

(defun.ps log-contents (sheet date category contents)
  (when (= (length contents) 0)
    (return-from log-contents))
  (let ((date-index (get-column-index-by-name
                     sheet (get-const :column-name-date)))
        (category-index (get-column-index-by-name
                         sheet (get-const :column-name-category)))
        (subcategory-index (get-column-index-by-name
                            sheet (get-const :column-name-subcategory)))
        (content-index (get-column-index-by-name
                        sheet (get-const :column-name-content)))
        (from-row (1+ (sheet.get-last-row)))
        (len (length contents)))
    (chain (sheet.get-range from-row date-index len 1)
           (set-values (make-same-element-list
                        len (lambda () (list date)))))
    (chain (sheet.get-range from-row category-index len 1)
           (set-values (make-same-element-list
                        len (lambda () (list category)))))
    (chain (sheet.get-range from-row subcategory-index len 1)
           (set-values (make-same-element-list
                        len (lambda () (list subcategory)))))
    (chain (sheet.get-range from-row content-index len 1)
           (set-values (mapcar (lambda (c) (list c))
                               contents)))))

(defun.ps+ make-same-element-list (len fn-make-element)
  (let ((res (list)))
    (dotimes (i len)
      (push (funcall fn-make-element) res))
    res))

(defun.ps delete-date-logs (sheet date)
  (let ((date-index (get-column-index-by-name
                     sheet (get-const :column-name-date))))
    (do-sheet-row-rev (row sheet)
      (let ((date-val (get-value-at sheet row date-index)))
        (cond ((and date-val (date= date date-val))
               (sheet.delete-row row))
              ((and date-val (date> date date-val))
               (return)))))))
