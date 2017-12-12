(in-package :cl-user)
(defpackage sample-caveman.web
  (:use :cl
        :caveman2
        :sample-caveman.config
        :sample-caveman.view
        :sample-caveman.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :sample-caveman.web)

(use-package '(:sample-caveman.db :sxql :datafly))

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute "/user" (&key |name|)
  (render-todo-list |name|))

(defroute ("/task-update" :method :POST) (&key |id| |state| |desc|)
  (render-todo-list (update-entry |id| (if |state| 1 0) |desc|)))

(defroute ("/task-add" :method :POST) (&key |user-name|)
  (progn
    (add-empty-entry |user-name|)
    (render-todo-list |user-name|)))

(defroute ("/task-delete" :method :POST) (&key |id|)
  (render-todo-list (delete-entry |id|)))

;;
;; Functions

(defun ensure-db ()
  (with-connection (db)
    (execute
     (create-table (:entries :if-not-exists t)
         ((id :type 'integer :primary-key t :unique t :autoincrement t)
          (user :type '(:varchar 20) :not-null t)
          (state :type '(:int 8) :not-null t)
          (desc :type '(:varchar 2048) :not-null nil :default nil))))))

(defun render-todo-list (user-name)
  (render #P"list.html"
          `(:user (:name ,user-name)
                  :entries ,(get-entries user-name))))

(defun add-empty-entry (user-name)
  (with-connection (db)
    (execute
     (insert-into :entries
       (set= :user user-name
             :state 0
             :desc "")))))

(defun get-entries (user-id)
  (with-connection (db)
    (retrieve-all
     (select :*
       (from :entries)
       (where (:= :user user-id))))))

(defun update-entry (entry-id state desc)
  (with-connection (db)
    (execute
     (update :entries
       (set= :state state
             :desc desc)
       (where (:= :id entry-id)))))
  (get-user-by-entry entry-id))

(defun delete-entry (entry-id)
  (prog1
      (get-user-by-entry entry-id)
    (with-connection (db)
      (execute
       (delete-from :entries
         (where (:= :id entry-id)))))))

(defun get-user-by-entry (entry-id)
  (second (with-connection (db)
            (retrieve-one
             (select :user
               (from :entries)
               (where (:= :id entry-id)))))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
