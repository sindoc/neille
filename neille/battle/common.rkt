#lang racket



(require
 
 neille/common/syntax
 
 neille/players/reflection
 
 (prefix-in ring: a-d/ring))



(provide
 
 (all-defined-out))



(define (get-deck           player) (send+ player player-deck-delegate))

(define (get-inplay         player) (send+ player player-inplay-delegate))

(define (get-staging        player) (send+ player player-staging-delegate))

(define (get-active-squad   player) (send+ player player-active-squad-delegate))


(define (get-card-readiness card)   (send card get-ready))


(define (for-each-card collection proc)
  
  (send 
   
   collection foreach
   
   (lambda (card)
     
     (proc card)))

  void)



(define (select-next-player player-ring)
  
  (ring:shift-forward! player-ring)
  
  (ring:peek player-ring))



(define (get-opponent players player)
  
  (car
    
    (filter-not
       
     (lambda (player-)
       
       (eq? player player-))
     
     players)))


















