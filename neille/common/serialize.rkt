#lang racket



(require
 
 neille/common/base
  
 (prefix-in rkt: racket/serialize))



(provide 
 
 (all-defined-out))



(define storage-file-path "neille-storage")



(define-struct ws-player
  
  (name squads active-squad)
  
  #:prefab)



(define-struct ws-squad
  
  (hero units)
  
  #:prefab)



(define (remove-reflection object)
  
  (when (is-a? object observable%)
    
    (send object remove-all-observers))
  
  (when (is-a? object reflective<%>)
    
    (send object remove-reflection)
     
    (send
   
     object for-each-delegate
   
     (lambda (_ delegate)
     
       (cond
       
         ((list? delegate)
        
          (for-each
         
           (lambda (sub-delegate)
        
             (remove-reflection sub-delegate))
         
           delegate))
       
         ((is-a? delegate collection<%>)
        
          (send
         
           delegate foreach
         
           (lambda (sub-delegate)
           
             (remove-reflection sub-delegate))))
         
         (else void))))))    



(define (serialize object)
  
  (remove-reflection object)
    
  (rkt:serialize object))



(define (deserialize any)
  
  (rkt:deserialize any))




















