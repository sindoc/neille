#lang racket



(provide 
 
 (all-defined-out))



(define (make-id stx template . ids)
  
  (datum->syntax 
   
   stx 
   
   (string->symbol 
    
    (apply format template (map syntax->datum ids)))))



(define-syntax (send+ stx)
  
  (syntax-case stx ()
    
    ((_ object msg)
     
     #'(send object query msg))
    
    ((_ object msg args ...)
     
     #'((send object query msg) args ...))))



