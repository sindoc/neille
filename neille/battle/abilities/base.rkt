#lang racket



(require

 neille/players/base
 
 neille/cards/reflection
 
 ;neille/battle/common
 
 neille/common/base
 
 "abilities.rkt")



(provide
 
 (all-defined-out)
 
 (all-from-out
  
  "abilities.rkt"))



(define (load-card-abilities players)
  
  (for-each
   
   (lambda (player)
     
     (define squad (get-active-squad player))
     
     (for-each
      
      (lambda (card)
     
        (send 
      
         card update-delegate card-abilities-delegate
         
         (lambda (_)
      
           (map
       
            (lambda (ability-descriptor)
         
              (send ability-space dispatch-ability ability-descriptor))
       
            (send card get-specials))))
        
        (send
         
         card update-delegate clean-reflection-delegate
         
         (lambda (current-reflection-cleaners)
           
           (cons
            
            (lambda (card)
              
              (send
               
               player remove-delegate card-abilities-delegate))
            
            current-reflection-cleaners))))
      
      (send squad to-list)))
   
   players))
        
        



















