(in-package :cl-user)
(defpackage sample-caveman.db
  (:use :cl)
  (:import-from :sample-caveman.config
                :config)
  (:import-from :datafly
                :*connection*)
  (:import-from :cl-dbi
                :connect-cached)
  (:import-from #:lack.session.store.dbi
                #:make-dbi-store)
  (:export :connection-settings
           :db
           :with-connection))
(in-package :sample-caveman.db)

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))
