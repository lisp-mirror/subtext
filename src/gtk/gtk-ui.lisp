;;; ----------------------------------------------------------------------------
;; (ql:quickload :present)(in-package :present)(test)
;; (progn (push  (authors-view *g*) *view*) nil)
;; (progn (push  (groups-view *g*) *view*) nil)
;;; ----------------------------------------------------------------------------
(in-package #:subtext)

(defgeneric -on-destroy (obj))
(defmethod  -on-destroy ((obj t) ))
(defgeneric -on-key-press (obj event from))
(defmethod  -on-key-press ((obj t) event from) nil) ;default: pass key on

(defparameter *pbuf* nil)
(defparameter *rview* nil)
;;for debugging ranges

;------------------------------------------------
#||

(defmethod  present ((p ptest) stream other)
  (with-slots (text1 text2 num toggle) p
    (unless toggle
      (progn
	(with-tag *tag*
	  (princ text1 stream)
	  (with-tag "output"
	    (with-range stream (make-instance 'pfake)
	      (format stream "~A"  num)))
	  (princ text2 stream))))))
||#

;; text new pmark system...

(defparameter *top* nil)
(defparameter *tag* nil)


;;;======================================
(defcontext p3 (ctx) ())
(defcontext p4 (ctx) ())
(defmethod -pres-on-mouse ((pres p4) enterp)
  (with-slots (out) pres
    (context-bounds out pres)
    (if enterp
	(gtb-apply-tag out "bg-bluish" (iter out) (iter1 out) )
	(gtb-remove-tag out "bg-bluish" (iter out) (iter1 out) ))))

(defcontext p5 (ctx) ())


(defmethod -pres-on-mouse ((pres p5)  enterp)
  (with-slots (out) pres
    (context-bounds out pres)
    (if enterp
	(gtb-apply-tag out "bg-greenish" (iter out) (iter1 out) )
	(gtb-remove-tag out "bg-greenish" (iter out) (iter1 out) ))))


(defun t11 ( &key (stdout *standard-output*) (package *package*))
  "final"
  (within-main-loop
   ;; (setf *ui-thread* (bt:current-thread))
    (setf *standard-output* stdout) ;re-enable output
    (setf *package* package)
    (let ((*standard-output* stdout)
	  (*package* package)
	  (buffer (make-instance 'buflisp))) ;in test.lisp
      (setf *pbuf* buffer)
      (let ((top (make-frame (make-window (setf *top* (make-rview buffer)))
			     :kill t))
	    r)
	(gtk-widget-show-all top)
	(format buffer "SHOWING~&")
	(prin buffer "hello " (pr 'ps00 () "p0..." (pr 'ps01 () "p1...") "p0 again"
				  (pr 'ps02 () ".2.." (pr 'ps03 () "3/")) "and 0") "---")
	;;	(with-range buffer (range:make)	  (format buffer "hello~&"))
#||
	(let ((stream buffer))
	  (time
	   (loop for i from 1 to 1 do
	      ;;(with-range buffer)
	      ;;(stream  (make-instance 'ptest :text1 "hello" :num i :text2 "world" )(present it buffer nil))
		(with-pres p5
		  (format buffer "...")
		  (with-pres p4
		    (format buffer "Hello "))
		  (format buffer "...")
		  (with-pres p3
		    (format buffer "world")))
		
		(format buffer "...~&")
	      ;;	(terpri buffer)
		)))
||#	
	(finish-output buffer))
      
      
	)))

;;;-----------------------------------------------------------------------------------
;;;
;;; SWANK REPL

(defun t3 ( &key (stdout *standard-output*) (package *package*))
  "final"
  ;;(format t "AAA STANDARD OUTPUT?~A ~A ~&"*standard-output* *package*)
  (within-main-loop
    (setf *standard-output* stdout); Why can't I just bind it?
    (let* ((*standard-output* stdout)
	   (*package* package)			;re-enable output
;;	   (ass  (format t "STANDARD OUTPUT?~A ~A ~&"*standard-output* *package*))
	   (top (make-frame (make-window (make-rview (make-instance 'swarepl))) 
			    :kill t)))
     

      (gtk-widget-show-all top)
      (-on-initial-display top))))



(defun t99 (&key (stdout *standard-output*) (package *package*))
  (within-main-loop
   ;; (setf *standard-output* stdout)
    (let* ((*standard-output* stdout);; (*package* package)
	   (win (make-instance 'gtk-window :type :toplevel :default-width 640 :default-height 480)))
      (format t "FUCK!!!!~&")
      (g-signal-connect win "destroy" (lambda (widget) (print widget) (leave-gtk-main)))
      (g-signal-connect win "key-press-event" (lambda (widget event) (print event stdout) nil))
      (gtk-widget-show-all win)
      (print *package*))))

(defun t101 (&key (stdout *standard-output*))
  (within-main-loop
    (let* ((*standard-output* stdout))
      (format t "HELLO!!!!~&")
)
))



(defun t100 ()
  (within-main-loop
    (let (;; Create a toplevel window.
          (window (gtk-window-new :toplevel)))
      ;; Signal handler for the window to handle the signal "destroy".
      (g-signal-connect window "destroy"
                        (lambda (widget)
			  
                          (declare (ignore widget))
                          (leave-gtk-main)))
      ;; Show the window.
      (gtk-widget-show-all window))))


(defcontext button (ctx) (code))


