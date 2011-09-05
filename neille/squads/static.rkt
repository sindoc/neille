#lang racket

(require
 neille/common/model-classes
 neille/cards/base
 neille/common/syntax
 neille/cards/reflection)

(provide (all-defined-out))

(define (make-squad- discriminator)
  
  (define (make-card stem)
    (define clone 
      (apply (send+ stem card-clone-maker-delegate) '()))
    ((send+ clone card-view-maker-delegate) clone)
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