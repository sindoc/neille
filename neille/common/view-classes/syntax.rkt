#lang racket



(provide
 
 (all-defined-out))



(define-syntax (setup-view stx)
  
  (syntax-case stx ()
    
    ((_ root- region- model- children-)
     
     #'(begin
         
         (init 
          
          (root null) 
               
          (region null) 
          
          (model null) 
          
          (children null))
         
         
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
