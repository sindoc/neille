#lang racket



(require
 
 "syntax.rkt"
 
 "reader.rkt"
 
 "space.rkt"
 
 neille/utils/base)



(define space (make-ability-space))



(define +/- "[+|-]")

(define n  "[\\d]+")



(define-ability 
  
  space
  
  "Attack" 
  
  (+/- n)
  
  (lambda vars
    
    (lambda (player)
      
      (define amount    (get-amount vars))
      
      (define direction (get-direction vars))
      
      (show "Amount: " amount " ; Direction: " direction "\n"))))
      


((send space dispatch-ability "Attack -2") 'player)

((send space dispatch-ability "Attack") 'player)

((send space dispatch-ability "Attack 4") 'player)


















