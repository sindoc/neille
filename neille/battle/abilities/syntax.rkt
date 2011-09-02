#lang racket



(provide
 
 (all-defined-out))



(define-syntax (define-ability stx)
  
  (syntax-case stx ()
    
    ((_ ability-space ability-hook (ability-var-template ...) ability-var-binder)
     
     #'(send 
        
        ability-space
        
        register-ability
        
        ability-hook
        
        (lambda (var-values)
          
          (apply 
           
           ability-var-binder
          
           (map
           
            (lambda (matcher)
              
              (let ((value (regexp-match matcher var-values)))
              
                (if (false? value)
                    
                    value
                    
                    (car value))))
          
            (list
           
             (pregexp ability-var-template) ...))))))))




















