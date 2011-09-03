#lang racket



(provide 
 
 (all-defined-out))



(define-syntax (setup-view stx)
  
  (syntax-case stx ()
    
    ((_ root- region- model- children-)
     
     #'(begin
         
         (init (root null) (region null) (model null) (children null))
         
         (define root- root)
         
         (define region- region)
         
         (define model- model)
         
         (define children- children)
         
         (send model- add-observer this)
         
         (super-new
          
          (root root-)
          
          (region region-)
          
          (model model-)
          
          (children children-))))))



(define-for-syntax (make-id stx template . ids)
  
  (datum->syntax 
   
   stx 
   
   (string->symbol 
    
    (apply format template (map syntax->datum ids)))))


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



(define-syntax (setup-dispatcher stx)
  
  (syntax-case stx ()
    
    ((_ dispatcher query add update remove)
     
     (with-syntax
         
	 ((check-msg-type (generate-temporaries '(check-msg-type))))
       
       #'(begin
           
           
	   (define dispatcher null)
           
           
	   (define (check-msg-type source msg)
             
	     (unless (or (symbol? msg) (string? msg))
               
	       (raise-type-error 
                
                source 
                
                "(or/c symbol? string?)" msg)))
           
           
	   (define (add msg delegate)
             
	     (check-msg-type 'add-delegate msg)
             
	     (hash-set! dispatcher msg delegate))
           
           
	   (define (update msg delegate)
             
	     (check-msg-type 'add-delegate msg)
             
	     (hash-update!
              
	      dispatcher msg
              
	      (lambda (_) delegate)
              
	      (lambda () #f)))
    	   
           
           (define (remove msg)
             
	     (check-msg-type 'remove-delegate msg)
             
	     (hash-remove! dispatcher msg))
           
           
	   (set!
            
	    dispatcher
            
	    (make-hash
             
	     (list 
              
	      (cons 'update-delegate update)
              
	      (cons 'add-delegate add)
              
	      (cons 'remove-delegate remove))))
           
           
	   (define/public (query msg)
             
	     (hash-ref 
              
	      dispatcher msg
              
	      (lambda ()
                
		(raise-mismatch-error 
                 
		 (object-name this) "Unknown message " msg)))))))))






















