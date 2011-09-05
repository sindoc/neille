#lang racket



(require
 
 "view.rkt"
 
 "syntax.rkt"
 
 racket/gui/base
 
 games/cards)



(provide
 
 morale-view%)



(define morale-view%
  
  (class view%
    
    
    (setup-view root- region- player- children-)
    
    
    (define (paint-callback- dc x y w h)
      
      (send 
       
       dc set-brush 
       
       (new 
        
        brush% 
        
        (style 'solid)
        
        (color (send the-color-database find-color "Plum"))))
      
      (send 
       
       dc draw-rectangle x y w 
       
       (* (/ h (send player- get-initial-morale))
          
          (send player- get-morale)))
      
      void)
    
    
    (define/public (get-paint-callback) paint-callback-)
    
    
    (define/override (update)
      
      (define new-region
        
        (make-background-region
         
         (region-x region-)
         
         (region-y region-)
         
         (region-w region-)
         
         (region-h region-)
         
         paint-callback-))
      
      (send root- remove-region region-)
      
      (send root- add-region new-region)
      
      (set! region- new-region)
      
      void)))

