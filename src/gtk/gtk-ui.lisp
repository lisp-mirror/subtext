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
(defpres p3 (pres) ())
(defpres p4 (pres) ())
(defmethod -pres-on-mouse ((pres p4) enterp)
  (with-slots (out) pres
    (pres-bounds out pres)
    (if enterp
	(gtb-apply-tag out "bg-bluish" (iter out) (iter1 out) )
	(gtb-remove-tag out "bg-bluish" (iter out) (iter1 out) ))))

(defpres p5 (pres) ())


(defmethod -pres-on-mouse ((pres p5)  enterp)
  (with-slots (out) pres
    (pres-bounds out pres)
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


(defpres button (pres) (code))

;; A simple test for debugging eli
(defun teli( &key (stdout *standard-output*) (package *package*))
  "final"
  ;;(format t "AAA STANDARD OUTPUT?~A ~A ~&"*standard-output* *package*)
  (within-main-loop
    (setf *standard-output* stdout); Why can't I just bind it?
    (let* ((*standard-output* stdout)
	   (*package* package)			;re-enable output
;;	   (ass  (format t "STANDARD OUTPUT?~A ~A ~&"*standard-output* *package*))
	   (top (make-frame (make-window
			     (print (setf *rview* (make-rview (setf *pbuf* (make-instance 'termstream)))))) 
			    :kill t)))
           (setf *top* top)
	   (eli-def *rview*  (kbd "C-x C-y") (lambda () (print "HELLO")))
	   (pres-tag *pbuf* button (:foreground "DarkGoldenrod" :background "aquamarine" :editable nil)  )

	   (prin *pbuf* "Hello " (tg "error" "cruel") nil " Wrold" #\linefeed)
	   (let ((p 'button))   (prin *pbuf* (pr p (:code (lambda () (format t "shid"))) "HOdamn")))
;	   (let ((tag "pres"))     (prin *pbuf* (tg tag "yo") " man"))
;;	   (pr *pbuf* 1 #\space  (tg *pbuf* "error" "fuck") 3)
;;	   (with-tag ("error" *pbuf*) (print "SHIT" *pbuf*) )
;;	   (prin-walk *pbuf* '("error" "hello" ("pres" " cruel") "world"))
;;	   (with-tag ("pres" *pbuf*) (princ "hello" *pbuf*)    (with-tag ("error" *pbuf*) (princ " cruel" *pbuf*))    (princ "world" *pbuf*))
	   ;(print (promises *pbuf*))
	   (promises-fulfill *pbuf* *pbuf*)
	   (gtk-widget-show-all top)
	   (-on-initial-display top))))


(defun crap ()
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (pr *pbuf* "hello " (tg "error" "cruel") " world"))
