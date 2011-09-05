#lang racket



(require
 
 neille/cards/base
 
 neille/common/base
 
 neille/common/serialize
 
 neille/common/model-classes/cardlist)



(provide
 
 squad%)



(define-serializable-class
  
  squad%
  
  cardlist% 
  
  
  (init hero units)
  
        
  (super-new 
     
   (cards (cons hero units)))
  
    
  (define hero- hero)
  
    
  (define/public (get-units)
           
     (cdr (send this to-list)))
  
  
  (define/public (set-units new-unit-list)
    
    (send 
     
     this from-list 
     
     (cons hero- new-unit-list)))
    
  
  (define/public (get-hero)
    
    (car (send this to-list)))
  
  
  (define/public (set-hero new-hero)
    
    (set! hero- new-hero)
    
    (send 
     
     this from-list
     
     (cons hero- (cdr (send this to-list)))))
    
    
  (define/override (externalize)
    
    (make-ws-squad
     
     (serialize hero-)
     
     (map serialize (get-units))))
  
  
  (define/override (internalize ws-squad)
    
    (set-hero (ws-squad-hero ws-squad))
    
    (set-units (ws-card-units ws-squad))
    
    this))
