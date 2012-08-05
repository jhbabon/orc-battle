; Orc Battle

(load 'lib/environment)
(load 'lib/monsters)
(load 'lib/engine)

; Main function
(defun orc-battle ()
  (init-monsters)
  (init-player)
  (game-loop)
  (when (player-dead)
    (fresh-line)
    (princ "You have been killed. Game over."))
  (when (monsters-dead)
    (fresh-line)
    (princ "Congratulations! You have vanquished all of your foes. You win!")))
