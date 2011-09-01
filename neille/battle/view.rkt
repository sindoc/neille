#lang racket



(require
 
 racket/gui/base
 
 neille/battle/engine
 
 neille/battle/events
 
 neille/battle/layout/base)



(provide
 
 start-battle-view)



(define (start-battle-view)
  
  (send 
   
   broadcast-feedback-channel 
   
   subscribe 
   
   game-finished-event-id

   (lambda (winner)
     
     (define dialog 
       
       (new 
        
        dialog%
        
        (label
        
         (format 
         
          "~a won the game" 
         
          (symbol->string
          
           (send winner get-name))))
        
        (width 300)
        
        (height 80)))
            
     (define feedback 'wow)
     
     (send dialog show #t)
     
     (send 
      
      table- remove-cards
      
      (send table- all-cards))
     
     (list feedback)))
  
  (send table- show #t)
  
  (start-playing))


(start-battle-view)
















