#lang racket



(require
 
 neille/common/model-classes/cardlist
 
 neille/players/reflection
 
 neille/cards/reflection
 
 neille/battle/common)


(provide
 
 inplay%)


(define (normalize a b)
  
  (define a-length (length a))
    
  (define b-length (length b))
  
  (define (add-dummy lst n)
    
    (append lst (make-list n null)))
  
  (if (< a-length b-length)
      
      (add-dummy a (- b-length a-length))
      
      (add-dummy b (- a-length b-length))))



(define inplay%
  
  (class cardlist%
    
    
    (init (cards null))
    
    
    (super-new (cards cards))
    
  
    (define/public (attack player opponent)
    
      (define player-cards-   (send (get-inplay player  ) to-list))
    
      (define opponent-cards- (send (get-inplay opponent) to-list))
    
      (define player-cards   (normalize player-cards- opponent-cards-))
    
      (define opponent-cards (normalize opponent-cards- player-cards-))
    
    
      (for-each
     
       (lambda (player-card opponent-card)
         
         (cond
           
           ((null? opponent-card)
            
            (send player decrement-morale))
           
           (else
         
            (set-attacking-card       player player-card)
       
            (set-card-being-attacked  player opponent-card)
       
            (for-each
        
             (lambda (ability)
          
               (ability player))
        
             (get-card-abilities player-card)))))
     
       player-cards
     
       opponent-cards))))






















