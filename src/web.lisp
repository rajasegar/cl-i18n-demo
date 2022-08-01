(in-package :cl-user)
(defpackage cl-i18n-demo.web
  (:use :cl
        :caveman2
        :cl-i18n-demo.config
        :cl-i18n-demo.view
        :cl-i18n-demo.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :cl-i18n-demo.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;; i18n
(cl-locale:enable-locale-syntax)

(cl-locale:define-dictionary i18n-dictionary
  (:en (merge-pathnames #P"src/i18n/en.lisp" *application-root*))
  (:fr (merge-pathnames #P"src/i18n/fr.lisp" *application-root*)))

(setf (cl-locale:current-dictionary) :i18n-dictionary)

(djula:def-filter :i18n-en (val)
	(cl-locale:i18n val :locale :en))
;;
;; Routing rules

(defroute "/" ()
	(let ((djula:*current-language* :en))
  (render #P"index.html" (list
													:calendar (cl-locale:i18n "Calendar" :locale :en)))))

(defroute "/fr" ()
  (render #P"french.html" (list
													:calendar (cl-locale:i18n "Calendar" :locale :fr))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
