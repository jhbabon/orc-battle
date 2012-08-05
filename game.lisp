; Orc Battle

(load 'environment)
(load 'structs)
(load 'engine)

; Main function
(defun orc-battle ()
  (init-monsters)
  (init-player)
  (game-loop)
  (when (player-dead)
    (princ "You have been killed. Game over."))
  (when (monsters-dead)
    (princ "Congratulations! You have vanquished all of your foes. You win!")))
