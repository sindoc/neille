#lang racket



(require
 
 neille/utils/syntax)



(provide
 
 (all-defined-out))



(define (get-deck player)         (send+ player 'deck))

(define (get-inplay player)       (send+ player 'inplay))

(define (get-staging player)      (send+ player 'staging))

(define (get-active-squad player) (send+ player 'active-squad))

(define (get-card-readiness card) (send card get-ready))


(define (for-each-card collection proc)
  
  (send 
   
   collection for-each
   
   (lambda (card)
     
     (proc card)))

  void)



