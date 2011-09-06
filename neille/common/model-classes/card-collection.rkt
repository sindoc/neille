#lang racket



(require
 
 racket/vector
 
 neille/common/base
 
 neille/common/serialize)



(provide
 
 make-card-collection)



(define-serializable-class*
  
  card-collection%
  
  observable%
  
  (collection<%>)
  
  
  (init 
   
   (cards null))
  
  
  (define cards- (list->vector cards))
  
  
  (define/public (from-list cards)
    
    (set! cards- (vector->list cards)))
  
  
  (define/public (to-list)
    
    (list->vector cards-))
  
  
  (define/public (map! proc)
    
    (vector-map! cards- proc)
    
    this)
  
  
  (define/public (foreach proc)
    
    (vector-map!
     
     cards-
     
     (lambda (idx val)
       
       (proc idx val)
       
       val))
    
    void)
  
  
  (define/public (poke)
    
    (send this notify)))
  

(define (make-card-collection (cards null))
  
  (new card-collection% (cards cards)))





















