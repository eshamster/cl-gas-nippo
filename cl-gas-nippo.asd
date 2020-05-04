#|
  This file is a part of cl-gas-nippo project.
  Copyright (c) 2020 eshamster (hamgoostar@gmail.com)
|#

#|
  Google App Script to create nippo

  Author: eshamster (hamgoostar@gmail.com)
|#

(defsystem "cl-gas-nippo"
  :version "0.1.0"
  :author "eshamster"
  :class :package-inferred-system
  :defsystem-depends-on (:asdf-package-system)
  :license "MIT"
  :depends-on (:parenscript
               :ps-experiment
               :alexandria
               :split-sequence
               :cl-gas-nippo/main)
  :description "Google App Script to create nippo"
  :in-order-to ((test-op (test-op "cl-gas-nippo/t"))))

(defsystem cl-gas-nippo/t
  :class :package-inferred-system
  :depends-on (:cl-gas-nippo
               :rove)
  :perform (test-op (o c) (symbol-call :rove '#:run c)))
