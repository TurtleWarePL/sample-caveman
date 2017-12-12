(ql:quickload :sample-caveman)

(defpackage sample-caveman.app
  (:use :cl)
  (:import-from :lack.builder
                :builder)
  (:import-from :ppcre
                :scan
                :regex-replace)
  (:import-from :sample-caveman.web
                :*web*)
  (:import-from :sample-caveman.config
                :config
                :productionp
                :*static-directory*)
  (:import-from #:lack.session.store.dbi
                #:make-dbi-store))
(in-package :sample-caveman.app)

(builder
 (:static
  :path (lambda (path)
          (if (ppcre:scan "^(?:/images/|/css/|/js/|/robot\\.txt$|/favicon\\.ico$)" path)
              path
              nil))
  :root *static-directory*)
 (if (productionp)
     nil
     :accesslog)
 (if (getf (config) :error-log)
     `(:backtrace
       :output ,(getf (config) :error-log))
     nil)
 :session
 (if (productionp)
     nil
     (lambda (app)
       (lambda (env)
         (let ((datafly:*trace-sql* t))
           (funcall app env)))))
 *web*)

#+(or)
(:session
  :store (make-dbi-store :connector (lambda ()
                                      (apply #'dbi:connect
                                             (sample-caveman.db:connection-settings)))
                         :disconnector (lambda (conn)
                                         (funcall #'dbi:disconnect conn))))
