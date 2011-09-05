#lang racket



(require
 
 "view.rkt"
 
 "syntax.rkt"
 
 neille/common/base
 
 neille/cards/base)



(provide
 
 card-view%)



(define card-view%
  
  (class view%
    
    
    (setup-view root- region- card- children-)
    
    
    (define card-view- null)
    
    
    (define (update-view)
      
      (set! card- (send this get-model))
      
      (set! card-view- (send+ card- card-view-delegate))
      
      card-view-)
    
    
    (update-view)
    
    
    (define/override (update)
      
      (send root- remove-card card-view-)
      
      (send 
       
       root- add-cards-to-region 
       
       (list (update-view)) region-))))















