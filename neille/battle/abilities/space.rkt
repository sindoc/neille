#lang racket



(require
 
 "reader.rkt")



(provide
 
 (all-defined-out))



(define ability-space%
  
  (class object%
    
    
    (super-new)
    
    
    (define db- (make-hash))


    (define/public (register-ability hook binder)
      
      (hash-update!
       
       db- (normalize-ws-card-ability-descriptor hook)
       
       (lambda (existing-hook)
         
         (unless (null? existing-hook)
           
           (error 
            
            "Cannot register ability, a hook already exists"
            
            existing-hook))
         
         binder)
       
       (lambda ()
         
         null)))
    
    
    (define/public (dispatch-ability ability-descriptor)
      
      (define deified  (read-ws-card-ability-descriptor ability-descriptor))
      
      (define hook     (ws-card-ability-descriptor-hook deified))
      
      (define vars     (ws-card-ability-descriptor-vars deified))
      
      (define binder
        
        (hash-ref
         
         db- hook
         
         (lambda ()
           
           (error "No handler is registered for this ability: " hook))))
      
      (binder vars))
    
    
    (define/public (clean)
      
      (set! db- (make-hash)))))



(define (make-ability-space)
  
  (new ability-space%))
























      
