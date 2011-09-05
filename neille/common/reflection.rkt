#lang racket



(require
 
 neille/common/syntax)



(provide
 
 (all-defined-out))


(define clean-reflection-delegate 'clean-reflection)


(define reflective<%> 
  
  (interface () 
    
    query 
    
    add-delegate 
    
    update-delegate 
    
    remove-delegate

    for-each-delegate

    remove-reflection))



(define (common-clean-reflection object)
    
  (for-each
     
   (lambda (reflection-cleaner)
       
     (reflection-cleaner object))
     
   (send+ object clean-reflection-delegate))
    
  (send object remove-delegate clean-reflection-delegate))
