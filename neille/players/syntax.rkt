#lang racket



(require
 
 (for-syntax
  
  neille/common/syntax)

 neille/common/syntax)




(provide
 
 (all-defined-out))



(define-syntax (init-players stx)
  
  (syntax-case stx ()
    
    ((_ players (field ...))
     
     (with-syntax
         
	 ((fields- 
           
	   (let ((l (syntax->list #'(field ...))))
             
	     (map 
              
	      (lambda (f)
                
		(make-id stx "-~a" f))
              
	      l))))
       
       #`(begin
           
	   (for-each 
            
	    (lambda (goody goody-name)
              
	      (send (car players) add-delegate goody-name goody))
            
	    (list field ...)
            
	    '(field ...))
           
	   (for-each 
            
	    (lambda (goody goody-name)
              
	      (send (cadr players) add-delegate goody-name goody))
            
	    #,(syntax-case #'fields- ()
                
		  ((fs- ...)
                   
		   #'(list fs- ...)))
            
	    '(field ...)))))))



















