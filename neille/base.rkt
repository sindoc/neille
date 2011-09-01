#lang racket



(require 
 
 neille/model
 
 racket/mpair
 
 (prefix-in ring: a-d/ring))



(provide 
 
 (all-defined-out))


(define human-player-name 'human)

(define robot-player-name 'robot)



(define human (new player% (name human-player-name)))

(define robot (new player% (name robot-player-name)))



(define (human-player? player)
  
  (eq? (send player name) human-player-name))



(define (robot-player? player)
  
  (eq? (send player name) robot-player-name))



(define players (list human robot))



(define player-ring 
  
  (ring:from-scheme-list (list->mlist players)))





















