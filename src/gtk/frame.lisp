;;; ----------------------------------------------------------------------------
;; Frame
;;
;; contains an echobar at the bottom, and content on top.
;;
;; key processing:
;;
;; All keys are sent to minibuf (which may send them back up)
;;; ----------------------------------------------------------------------------
(in-package #:subtext)

(defgeneric -on-key (object key event)) ; return nil to keep processing
(defgeneric -pre-initial-display (target frame))

(defparameter *frame* nil)
(defparameter *echo* *standard-output*)
(defclass frame (gtk-window)
  ((holder   :accessor holder  :initform (make-instance 'gtk-box :orientation :vertical))
   (minibuf  :accessor minibuf )
   (content  :accessor content :initarg :content))
  (:metaclass gobject-class))

(defmethod -on-destroy ((frame frame))
  (with-slots (content) frame
    (format t "destroy:frame content ~A~&" content)
    (and content (-on-destroy content))
    ))

(defmacro make-frame (content &rest rest)
  `(make-instance 'frame :content ,content
		 :type :toplevel
		 :default-width 640
		 :default-height 480
		 ,@rest))

(defmethod -on-initial-display ((frame frame))
  (with-slots (minibuf content) frame
    (-on-initial-display minibuf)
    (-on-initial-display content)))

(defmethod initialize-instance :after ((frame frame) &key kill)
  (with-slots (holder minibuf content) frame
    (setf *frame* frame);;TODO** FIX THIS, ELI SETS MINIBUF WITH THIS!

    (setf minibuf (make-minibuf frame))
    (gtk-box-pack-end holder minibuf :expand nil)
    (and content (gtk-box-pack-start holder content))
    (gtk-container-add frame holder)

    (g-signal-connect
     frame "destroy"
     (lambda (widget) (-on-destroy widget)
	     (if kill (leave-gtk-main))))


    
    (-pre-initial-display content frame)
    frame
    
    ))



