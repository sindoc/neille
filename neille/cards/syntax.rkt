#lang racket



(require
 
 (for-syntax
  
  neille/common/syntax
  
  "ws-card-fields.rkt"))



(provide
 
 (all-defined-out))



(define-syntax (setup-card-fields stx)
  
  (syntax-case stx ()
    
    ((_ card query add update)
     
     (with-syntax
         
         ((fields 
           
           #`(begin
               
              #,@(map
                  
                  (lambda (f)
                    
                    (define field (datum->syntax stx f))
                    
                    (define (make-id- pattern)
                      
                      (make-id stx pattern field))
                    
                    (define stem (make-id- "~a"))
                    
                    (define get-field (make-id- "get-~a"))
                    
                    (define set-field (make-id- "set-~a"))
                    
                    #`(begin
                        
                        (add '#,stem (#,(make-id- "ws-card-~a") card))
                        
                        (define/public (#,get-field) (query '#,stem))
                        
                        (define/public (#,set-field val) 
                          
                          (update '#,stem (lambda (_) val))
                          
                          (send this notify)
                          
                          void)))
                  
                  ws-card-fields))))
       
       #'(begin
           
             fields
           
             (add 'ws-card card))))))



















