(defsystem "cl-i18n-demo-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Rajasegar Chandran"
  :license ""
  :depends-on ("cl-i18n-demo"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cl-i18n-demo"))))
  :description "Test system for cl-i18n-demo"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
