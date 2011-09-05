#lang racket



(require
 
 neille/utils/broadcast-feedback)



(provide
 
 (all-defined-out))



(define broadcast-feedback-channel 
  
  (make-broadcast-feedback-channel
   
   (lambda (message . args)
     
     (case message
         
       ((cool)
        
        message)
       
       (else
     
        (error 
         
         "I'm afraid we don't speak the same language. You said: " 
         
         message))))))