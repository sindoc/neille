#lang racket



(require
 
 "observer.rkt")


(provide
 
 view%)



(define view%
  
  (class* object% 
    
    (observer<%>)
    
    
    (super-new)
    
    
    (init 
     
     (root null) 
     
     (region null) 
     
     (model null) 
     
     (children null))
    
    
    (define root- root)
    
    
    (define region- region)
    
    
    (define model- model)
    
    
    (define children- children)
    
    
    (define/public (get-region) region-)
    
    
    (define/public (set-region new-region)
      
      (set! region- new-region))
    
    
    (define/public (get-root) root-)
    
    
    (define/public (set-root new-root)
      
      (set! root- new-root))
    
    
    (define/public (get-model) model-)
    
    
    (define/public (set-model new-model)
      
      (set! model- new-model)
      
      (send this update)
      
      void)
    
    
    (define/public (get-children) children-)
    
    
    (define/public (set-children new-children)
      
      (set! children- new-children))
    
    
    (define/public (update)
      
      void)))




















