#lang racket


(require
 
 games/cards
 
 racket/gui/base)



(provide
 
 (all-defined-out))



(define fallback-card-view-filename  "fallback-card.jpg")

(define fallback-card-view-dirname   "neille/cards/img/")

(define fallback-card-view-type      'jpeg)

(define fallback-card-view-value     'fallback)



(define (make-fallback-card-view)
  
  
  (define bitmap 
    
    (make-object bitmap%
      
      (collection-file-path 
       
       fallback-card-view-filename
       
       fallback-card-view-dirname)
      
      fallback-card-view-type))
                          
  
  (make-card
   
   bitmap
   
   bitmap
   
   #f
   
   fallback-card-view-value))












