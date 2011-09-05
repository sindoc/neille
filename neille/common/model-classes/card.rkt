#lang racket



(require
 
 "syntax.rkt"
 
 neille/cards/ws-cards
 
 neille/cards/syntax
 
 neille/common/base)



(provide
 
 card%)



(define-serializable-class*
  
  card%
  
  observable%
  
  (reflective<%>)
    
  (init (ws-card null))
  
  
  (super-new)
  
  
  (define ws-card- 
    
    (if (null? ws-card) 
       
        fallback-ws-card 
       
        ws-card))
  
  
  (setup-dispatcher 
   
   dispatcher- query add-delegate update-delegate 
   
   remove-delegate for-each-delegate)
  
  
  (setup-card-fields 
   
   ws-card- query add-delegate update-delegate)
  
  
  (define/public (remove-reflection)
    
    (common-clean-reflection this))
  
  
  (define/public (set-ws-card new-ws-card)
    
    (set! ws-card- new-ws-card))
  
  
  (define/override (externalize)
      
    (remove-reflection)
    
    ws-card-)
  
  
  (define/override (internalize ws-card)
    
    (new card% (ws-card ws-card))))

















