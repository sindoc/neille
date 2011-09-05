#lang racket



(require
 
 neille/cards/base
 
 neille/common/base
 
 "syntax.rkt"
 
 "view.rkt")



(provide
 
 deck-view%)



(define deck-view%
  
  (class view%
    
    
    (setup-view root- region- deck- children-)
    
    
    (define visible-card- null)
    
    
    (define (update-view)
      
      (set!
       
       visible-card-
      
       (if (send deck- empty?)
          
           (make-fallback-card-view)
          
           (send+ (send deck- top) card-view-delegate))))
    
    
    (update-view)
    
    
    (define/override (update)
      
      (send root- remove-card visible-card-)
      
      (update-view)
      
      (send 
       
       root- add-cards-to-region 
       
       (list visible-card-)
       
       region-))))




















