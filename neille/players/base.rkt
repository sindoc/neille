#lang racket



(require 
 
 neille/common/model-classes
 
 neille/players/reflection
 
 racket/mpair
 
 (prefix-in ring: a-d/ring))



(provide 
 
 (all-defined-out)
 
 (all-from-out
  
  neille/players/reflection))


(define human-player-name 'human)

(define robot-player-name 'robot)



(define human (new player% (name human-player-name)))

(define robot (new player% (name robot-player-name)))



(define (human-player? player)
  
  (eq? (send player name) human-player-name))



(define (robot-player? player)
  
  (eq? (send player name) robot-player-name))



(define players   (list robot human))

(define-values
  
  (opponent -opponent) 
  
  (let ((split-point 1))
    
    (values
     
     (car (take players split-point))
     
     (car (drop players split-point)))))



(define player-ring 
  
  (ring:from-scheme-list (list->mlist players)))





















