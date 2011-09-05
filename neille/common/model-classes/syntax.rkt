#lang racket



(provide
 
 (all-defined-out))



(define-syntax (setup-dispatcher stx)
  
  (syntax-case stx ()
    
    ((_ dispatcher query add update remove foreach)
     
     (with-syntax
         
         ((check-msg-type (generate-temporaries '(check-msg-type))))
       
       #'(begin
           
           
	   (define dispatcher (make-hash))
           
           
	   (define/public (check-msg-type source msg)
             
	     (unless (or (symbol? msg) (string? msg))
               
	       (raise-type-error 
                
                source 
                
                "(or/c symbol? string?)" msg)))
           
           
	   (define/public (add msg delegate)
             
	     (check-msg-type 'add-delegate msg)
             
	     (hash-set! dispatcher msg delegate))
           
           
	   (define/public (update msg updater)
             
	     (check-msg-type 'update-delegate msg)
             
	     (hash-update!
              
	      dispatcher msg
              
              updater
              
	      (lambda () null)))
    	   
           
           (define/public (remove msg)
             
	     (check-msg-type 'remove-delegate msg)
             
	     (hash-remove! dispatcher msg))
           
           
           (define/public (foreach proc)
             
             (hash-for-each
              
              dispatcher proc))
                      
           
	   (define/public (query msg)
             
	     (hash-ref 
              
	      dispatcher msg
              
	      (lambda ()
                
		; (raise-mismatch-error 
                 
                ; (object-name this) "Unknown message " msg)
                
                null))))))))























