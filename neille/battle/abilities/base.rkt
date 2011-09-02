#lang racket



(require
 
 "syntax.rkt"
 
 "reader.rkt"
 
 "space.rkt"
 
 neille/utils/base)



(provide
 
 ability-space)



(define ability-space (make-ability-space))



(define *+/-*     "[+|-]" )

(define *amount*  "[\\d]+")



(define-ability 
  
  ability-space
  
  "Attack" 
  
  (*+/-* *amount*)
  
  (lambda vars
    
    (lambda (player)
      
      (define amount    (get-amount vars))
      
      (define direction (get-direction vars))
      
      (show "Amount: " amount " ; Direction: " direction "\n"))))



(define-ability
  
  ability-space
  
  "Heal"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Pikeman"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Archery"
  
  ()
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Zap"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Poison"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Sabotage"
  
  ()
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Retaliate"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Trap"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Sap"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Health"
  
  (*+/-* *amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Regenerate"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Trample"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Block"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  ""
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))



(define-ability
  
  ability-space
  
  "Rush"
  
  (*amount*)
  
  (lambda vars
    
    (lambda (player)
      
      void)))


















