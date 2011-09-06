#lang racket



(require
 
 neille/utils/base
 
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
  
  
  (define/private (insert-in-middle val pos)
    
    (define size (length cards-))
    
    (assert 
     
     (>= pos 1)
      
     "Position must be greater than or equal to 1 " 
     
     "cardlist%: insert-in-middle")
    
    (let ((head
           
           (let ((cut (- pos 1)))
      
             (cond
        
               ((<= cut size)
           
                (take cards- cut))
          
               (else
           
                (append
            
                 cards-
            
                 (build-list 
                  
                  (- cut size)
                  
                  (lambda (_) null)))))))
          
          (tail
      
           (cond
        
             ((<= pos size)
         
              (drop cards- pos))
        
             (else null))))
           
    
      (append head (cons val tail))))
  
  
  (define/public (add-card card . pos)
    
    (set! 
     
     cards- 
       
     (cond
       
       ((null? pos)
        
        (cons card cards-))
       
       (else
        
        (insert-in-middle card (car pos)))))
    
    (send this notify))
  
  
  (define/public (remove-card card)
    
    (set! cards- (remq card cards-))
    
    (send this notify))
  
  
  (define/override (externalize)
    
    (serialize cards-))
  
  
  (define/override (internalize cards)
    
    (send this from-list cards)
    
    this))