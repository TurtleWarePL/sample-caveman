(defsystem "sample-caveman-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Tomasz Kurcz"
  :license ""
  :depends-on ("sample-caveman"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "sample-caveman"))))
  :description "Test system for sample-caveman"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
