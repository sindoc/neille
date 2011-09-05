#lang racket



(require
 
 (for-syntax
  
  neille/common/syntax)

 neille/common/syntax
 
 neille/players/reflection)




(provide
 
 (all-defined-out))



(define-syntax (init-players stx)
  
  (syntax-case stx ()
    
    ((_ players (field ...))
     
     (with-syntax
         
	 ((fields- 
           
	   (let ((lst (syntax->list #'(field ...))))
             
	     (map 
              
	      (lambda (f)
                
		(make-id stx "-~a" f))
              
	      lst)))
          
          (delegates
           
           (let ((lst (syntax->list #'(field ...))))
             
             (map
              
              (lambda (f)
                
                (make-id stx "player-~a-delegate" f))
              
              lst))))
       
       #`(begin
           
           (for-each 
            
	    (lambda (goody goody-name)
              
	      (send (car players) add-delegate goody-name goody))
            
	    (list field ...)
            
            #,(syntax-case #'delegates ()
                
                ((delegate ...)
                 
                 #'(list delegate ...))))
           
           
	   (for-each 
            
	    (lambda (goody goody-name)
              
	      (send (cadr players) add-delegate goody-name goody))
            
	    #,(syntax-case #'fields- ()
                
		  ((fs- ...)
                   
		   #'(list fs- ...)))
            
	    #,(syntax-case #'delegates ()
                
                ((delegate ...)
                 
                 #'(list delegate ...)))))))))



















