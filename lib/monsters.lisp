; Monsters

;; Generic
(defstruct monster (health (randval 10)))

(defmethod monster-hit (m x)
  (decf (monster-health m) x)
  (if (monster-dead m)
    (progn (princ "You killed the ")
           (princ (monster-type-of m))
           (princ "! "))
    (progn (princ "You hit the ")
           (princ (monster-type-of m))
           (princ ", knocking off ")
           (princ x)
           (princ " health points."))))

(defmethod monster-show (m)
  (princ "A fierce ")
  (princ (monster-type-of m))
  (princ "."))

(defmethod monster-attack (m))

(defmethod monster-type-of (m)
  (string-downcase (type-of m)))

;; Orc
(defstruct (orc (:include monster)) (club-level (randval 8)))
(push #'make-orc *monsters-builders*)

(defmethod monster-show ((m orc))
  (princ "A wicked orc with a level ")
  (princ (orc-club-level m))
  (princ " club."))

(defmethod monster-attack ((m orc))
  (fresh-line)
  (let ((x (randval (orc-club-level m))))
    (princ "An orc swings his club at you and knocks off ")
    (princ x)
    (princ " of your health points.")
    (decf *player-health* x)))

;; Hydra
(defstruct (hydra (:include monster)))
(push #'make-hydra *monsters-builders*)

(defmethod monster-show ((m hydra))
  (princ "A malicious hydra with ")
  (princ (monster-health m))
  (princ " heads."))

(defmethod monster-hit ((m hydra) x)
  (decf (monster-health m) x)
  (if (monster-dead m)
    (princ "The corpse of the fully decapitated and decapacitated hydra falls to the floor!.")
    (progn (princ "You lop off ")
           (princ x)
           (princ " of the hydra's heads!"))))

(defmethod monster-attack ((m hydra))
  (fresh-line)
  (let ((x (randval (ash (monster-health m) -1))))
    (princ "A hydra attack you with ")
    (princ x)
    (princ " of its heads! It also grows back one more head!")
    (incf (monster-health m))
    (decf *player-health* x)))

;; Slime Mold
(defstruct (slime-mold (:include monster)) (sliminess (randval 5)))
(push #'make-slime-mold *monsters-builders*)

(defmethod monster-show ((m slime-mold))
  (princ "A slime mold with sliminess of ")
  (princ (slime-mold-sliminess m)))

(defmethod monster-attack ((m slime-mold))
  (fresh-line)
  (let ((x (randval (slime-mold-sliminess m))))
    (princ "A slime mold wraps around your legs and decreases your agility by ")
    (princ x)
    (princ "!")
    (decf *player-agility* x)
    (when (zerop (random 2))
      (princ " It also squirts in your face, taking away a health point!")
      (decf *player-health*))))

;; Cunning Brigand
(defstruct (brigand (:include monster)))
(push #'make-brigand *monsters-builders*)

(defmethod monster-attack ((m brigand))
  (fresh-line)
  (let ((x (max *player-health* *player-agility* *player-strength*)))
    (cond ((= x *player-health*)
           (princ "A brigand hits you with his slingshot, taking off 2 health points!")
           (decf *player-health* 2))
          ((= x *player-agility*)
           (princ "A brigand catches your leg with his whip, taking off 2 agility points!")
           (decf *player-agility* 2))
          ((= x *player-strength*)
           (princ "A brigand cuts your arm with his whip, taking off 2 strength points!")
           (decf *player-strength* 2)))))
