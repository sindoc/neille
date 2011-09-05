#lang racket



(require
 
 neille/common/base
 
 neille/players/base
 
 (prefix-in ring: a-d/ring))



(provide
 
 (all-defined-out))


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


















