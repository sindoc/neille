#lang racket

(require
 neille/utils/syntax
 neille/model
 neille/cards/base)

(provide (all-defined-out))

(define (make-squad* m)
  (define (mk-card base)
    (define c (new card% (ws-card (send+ base 'ws-card))))
    (send+ c 'add-delegate 'make-view (send+ base 'make-view))
    ((send+ c 'make-view) c)
    c)
  (list 
   (new 
    squad% (hero-selector car)
    (squad 
     (cons 
      (mk-card (car (filter hero? cards))) 
      (map (λ (c) (mk-card c)) (take cards (* m 6))))))))

(define squads (make-squad* 1))
(define -squads (make-squad* 2))