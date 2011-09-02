#lang racket



(provide
 
 (all-defined-out))



(define-struct ws-card-ability-descriptor
  
  (hook vars))



(define ws-card-ability-direction-var car)


(define ws-card-ability-amount-var cadr)



(define (get-amount vars)
  
  (if (false? (ws-card-ability-amount-var vars))
            
      1
            
      (ws-card-ability-amount-var vars)))


(define (get-direction vars)
  
  (if (false? (ws-card-ability-direction-var vars))
            
      "+"
            
      (ws-card-ability-direction-var vars)))



(define (normalize-ws-card-ability-descriptor raw-descriptor)
  
  (string-downcase raw-descriptor))



(define (read-ws-card-ability-descriptor raw-descriptor)
  
  (define deified
    
    (regexp-split
         
     #rx" "
    
     (normalize-ws-card-ability-descriptor 
     
      raw-descriptor)))
  
  (make-ws-card-ability-descriptor
   
   (car deified)
   
   (if (null? (cdr deified))
       
       ""
       
       (cadr deified))))
              
             
   


  














