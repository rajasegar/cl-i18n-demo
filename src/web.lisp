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

;;
;; Routing rules

(defroute "/" ()
	(let ((djula:*current-language* :en)
				(djula:*translation-backend* :locale))
  (render #P"index.html" )))

(defroute "/fr" ()
	(let ((djula:*current-language* :fr)
				(djula:*translation-backend* :locale))
  (render #P"french.html" )))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
