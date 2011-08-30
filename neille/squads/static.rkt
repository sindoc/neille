#lang racket

(require
 neille/model
 neille/cards/base
 neille/utils/syntax)

(provide (all-defined-out))

(define (make-squad- discriminator)
  
  (define (make-card stem)
    (define clone 
      (apply (send+ stem 'make-clone) '()))
    ((send+ clone 'make-view) clone)
    clone)
  
  (define units-count 6)
  
  (define hero 
    (make-card 
     (list-ref
      (filter hero? cards)
      discriminator)))
    
  (define units
    (take-right
     (take
      (filter-not hero? (map make-card cards))
      (* discriminator units-count))
     units-count))
    
  (list 
   (new 
    squad% 
    (hero hero)
    (units units))))

(define-values (squads -squads)
  (values 
   (make-squad- 2) 
   (make-squad- 3)))

(define-values (active-squad -active-squad)
  (values
   (car squads)
   (car -squads)))