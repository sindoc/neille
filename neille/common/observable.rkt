#lang racket



(provide
 
 (all-defined-out))



(define-serializable-class

  observable%
  
  object%
    
  (super-new)
  
    
  (define observers- null)
  
  
  (define/public (add-observer observer)
      
    (set! observers- (cons observer observers-)))
  
  
  (define/public (get-observers) observers-)
  
    
  (define/public (notify)
    
    (for-each
     
     (lambda (observer)
       
       (send observer update))
     
     observers-))
  
  
  (define/public (remove-all-observers)
    
    (set! observers- null))
  
  
  (define/public (externalize) null)
  
  (define/public (internalize)
    
    this))


















