(defsystem #:sample-caveman
  :version "0.1.0"
  :author "Tomasz Kurcz"
  :license ""
  :depends-on (#:clack
               #:lack
               #:caveman2
               #:envy
               #:cl-ppcre
               #:uiop

               ;; for @route annotation
               #:cl-syntax-annot

               ;; HTML Template
               #:djula

               ;; for DB
               #:datafly
               #:sxql

               ;; for storing session data
               #:lack-session-store-dbi
               )
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (test-op "sample-caveman-test"))))
