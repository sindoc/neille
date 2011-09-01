#lang racket



(provide
 
 (all-defined-out))



(define broadcast-feedback-channel%
  
  (class object%
    
    
    (init feedback-agent)
    
    
    (super-new)
    
    
    (define dispatcher-      (make-hash))
    
    
    (define feedback-agent-  feedback-agent)
    
    
    (define/public (subscribe event action)
      
      (hash-update!
       
       dispatcher-  event
       
       (lambda (existing-actions)
         
         (cons action existing-actions))
       
       (lambda () null)))
    
    
    (define/public (broadcast event . args)
      
      (for-each
       
       (lambda (event-delegate)

         (apply 
          
          feedback-agent- 
           
          (apply event-delegate args)))
       
       (hash-ref
        
        dispatcher- event
        
        (lambda () null)))
      
      void)))



(define (make-broadcast-feedback-channel master)
  
  (new 
   
   broadcast-feedback-channel% 
   
   (feedback-agent master)))

















