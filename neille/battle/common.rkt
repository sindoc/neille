#lang racket



(require
 
 neille/common/syntax
 
 (prefix-in ring: a-d/ring))



(provide
 
 (all-defined-out))



(define (get-deck           player) (send+ player 'deck))

(define (get-inplay         player) (send+ player 'inplay))

(define (get-staging        player) (send+ player 'staging))

(define (get-active-squad   player) (send+ player 'active-squad))


(define (get-card-readiness card)   (send card get-ready))


(define (for-each-card collection proc)
  
  (send 
   
   collection for-each
   
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


















