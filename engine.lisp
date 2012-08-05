; Game engine functions

;; Helpers
(defun randval (n)
  (1+ (random (max 1 n))))

(defun pick-monster ()
 (fresh-line)
 (princ "Monster #: ")
 (let ((x (read)))
   (if (not (and (integerp x) (>= x 1) (<= x *monsters-num*)))
     (progn (princ "That is not a valid monster number.")
            (pick-monster))
     (let ((m (aref *monsters* (1- x))))
       (if (monster-dead m)
         (progn (princ "That monster is alread dead.")
                (pick-monster))
         m)))))

(defun random-monster ()
  (let ((m (aref *monsters* (random (length *monsters*)))))
    (if (monster-dead m)
      (random-monster)
      m)))

;; Player management functions
(defun init-player ()
  (setf *player-health* 30)
  (setf *player-agility* 30)
  (setf *player-strength* 30))

(defun player-dead ()
  (<= *player-health* 0))

(defun show-player ()
  (fresh-line)
  (princ "You are a valiant kinght with a health of ")
  (princ *player-health*)
  (princ ", an agility of ")
  (princ *player-agility*)
  (princ ", and a strength of ")
  (princ *player-strength*))

(defun player-attack ()
  (fresh-line)
  (princ "Attack style: [s]tab [d]ouble swing [r]oundhouse: ")
  (case (read)
    (s (player-stab-attack))
    (d (player-double-swing-attack))
    (otherwise (player-roundhouse-attack))))

(defun player-stab-attack ()
  (monster-hit (pick-monster) (+ 2 (randval (ash *player-strength* -1)))))

(defun player-double-swing-attack ()
  (let ((x (randval (truncate (/ *player-strength* 6)))))
    (princ "Your double swing has a strength of ")
    (princ x)
    (fresh-line)
    (monster-hit (pick-monster) x)
    (unless (monsters-dead)
      (monster-hit (pick-monster) x))))

(defun player-roundhouse-attack ()
  (dotimes (x (1+ (randval (truncate (/ *player-strength* 3)))))
    (unless (monsters-dead)
      (monster-hit (random-monster) 1))))

;; Monsters management functions
(defun init-monsters ()
  (setf *monsters*
        (map 'vector (lambda (x)
                       (funcall (nth (random (length *monsters-builders*))
                                     *monsters-builders*)))
             (make-array *monsters-num*))))

(defun monster-dead (m)
  (<= (monster-health m) 0))

(defun monsters-dead ()
  (every #'monster-dead *monsters*))

(defun show-monsters ()
  (fresh-line)
  (princ "Your foes:")
  (let ((x 0))
    (map 'list
         (lambda (m)
           (fresh-line)
           (princ "    ")
           (princ (incf x))
           (princ ". ")
           (if (monster-dead m)
             (princ "** dead **")
             (progn (princ "(Health=")
                    (princ (monster-health m))
                    (princ ") ")
                    (monster-show m))))
         *monsters*)))

;; Main loop
(defun game-loop ()
  (unless (or (player-dead) (monsters-dead))
    (show-player)
    (dotimes (k (1+ (truncate (/ (max 0 *player-agility*) 15))))
      (unless (monsters-dead)
        (show-monsters)
        (player-attack)))
    (fresh-line)
    (map 'list (lambda (m)
                 (or (monster-dead m) (monster-attack m)))
         *monsters*)
    (game-loop)))
