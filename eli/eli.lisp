(in-package :stext)
;;
;; eli is a keyprocessing entity
;;

(defclass eli ()
  ((state :accessor state
	  :documentation "first= binding during search, rest are previous bindings")
   (keymap :accessor keymap :initarg :keymap :initform nil)
   (x :accessor x :initform 0)
   (y :accessor y :initform 0)
   ))

(defmethod eli-reset ((eli eli))
  (with-slots (state keymap minibuf) eli
    (setf state (cons keymap nil))
    ;;(-wipe minibuf)
    ;(terpri *echo*)
    t))

(defun eli-state-print(eli stream)
  (labels ((printer (state stream)
	     (and (cdr state)
		(printer (cdr state) stream))
	   (and (car (car state))
		(progn (key-write (car (car state)) stream)
		       (write-char #\space stream)))))
    (terpri stream)
    (printer (state eli) stream)))

(defun eli-active (eli)
  "Return t if eli is in the middle of a search"
  (with-slots (keymap state) eli
    (not (eq keymap (car state)))))

(defmethod initialize-instance :after ((eli eli) &key)
  (with-slots (state keymap ) eli
    (unless keymap (setf keymap (keymap-make)))
    (eli-reset eli)
    ;; built-in bindings
    (eli-def eli (kbd "C-g") (lambda () (eli-reset eli)))
    ))

;;
;; active  found
;;   0       0      pass on
;;   0       1      eli
;;   1       0      cancel
;;   1       1      eli

(defun process-key (eli key mx my event)
  "process a key with modifiers..."
  (with-slots (state keymap x y) eli
    (setf x mx
	  y my)
    (format t "eli:process-key ~A ~A ~A~&" key x y)
    (let ((found (key-lookup (car state) key)))
     ;; (format t "ELI:PROCESSKEY ~A~& ~A~&" state keymap)
      (if found
	  (typecase (cdr found)
	    (function (eli-reset eli) ;reset search
		      (funcall (cdr found) ))
	    (cons (push found state)
		  (eli-state-print eli *echo*)
		  t))
	  ;;not found...
	  
	  (if (eli-active eli)
	      (progn
		(eli-state-print eli *echo*)
		(key-write key *echo*)
		(format *echo* " NOT BOUND")
		(eli-reset eli))
	      (progn
		nil))))))

(defun eli-find (eli keyseq)
  "find a keyseq in this eli"
  (key-find (keymap eli) keyseq))

(defun eli-def (eli keyseq data)
  (key-def (keymap eli) keyseq data))

