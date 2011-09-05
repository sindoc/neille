#lang racket



(require
 
 "view.rkt"
 
 "syntax.rkt"
 
 neille/cards/base
 
 neille/common/base)



(provide
 
 cardlist-view%)



(define cardlist-view%
  
  (class view%
    
    
    (setup-view root- region- cardlist- children-)
    
    
    (define max- (length children-))
    
    
    (define/public (get-capacity) max-)
    
    
    (define (cardlist-length)
      
      (send cardlist- get-length))
    
    
    (define/override (update)
      
      (for-each
       
       (lambda (child card)
         
         (define card-view (send+ card card-view-delegate))
         
         (send root- remove-cards (list card-view))
         
         (send root- add-cards-to-region (list card-view) child))
       
       (take children- (min (cardlist-length) max-))
       
       (take (send cardlist- to-list) (min (cardlist-length) max-))))))


















