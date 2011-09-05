#lang racket



(require
 
 neille/common/base
 
 neille/common/serialize)



(provide
 
 cardlist%)



(define-serializable-class*
  
  cardlist%
  
  observable%
  
  (collection<%>)
    
  (init (cards null))
    
    
  (define cards- cards)
    
    
  (super-new)
    
    
  (define/public (from-list cards)
      
    (set! cards- cards)
    
    (send this notify))
  
  
  (define/public (to-list) cards-)
  
  
  (define/public (map! proc)
    
    (set! cards- (map proc cards-)))
  
  
  (define/public (foreach proc)
    
    (for-each proc cards-))
  
  
  (define/public (get-length)
    
    (length cards-))
  
  
  (define/public (poke)
      
    (send this notify))
  
  
  (define/private (insert-in-middle lst val pos)
      
    (flatten
     
     (cons
      
      (take lst pos)
      
      (cons val (drop lst pos)))))
  
  
  (define/public (add-card card . pos)
    
    (set! 
     
     cards- 
       
     (cond
       
       ((or (null? pos)
            
            (empty? cards-))
        
        (cons card cards-))
       
       (else
        
        (insert-in-middle cards- card (car pos)))))
    
    (send this notify))
  
  
  (define/public (remove-card card)
    
    (set! cards- (remq card cards-))
    
    (send this notify))
  
  
  (define/override (externalize)
    
    (serialize cards-))
  
  
  (define/override (internalize cards)
    
    (send this from-list cards)
    
    this))