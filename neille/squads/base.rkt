#lang racket

(require
 
 games/cards

 racket/gui/base
  
 neille/players/base
 
 neille/common/model-classes
 
 neille/cards/base
 
 neille/utils/base
 
 neille/common/syntax

 neille/utils/storage
 
 neille/squads/static
 
 neille/squads/layout/base)



(provide
 
 setup-squad-selection-screen)



(define cards- null)



(define (clone-card stem)
  
  (define clone ((send+ stem 'make-clone)))
  
  ((send+ clone 'make-view) clone)
  
  clone)



(define (setup-cards)
  (set! 
   cards-
   
   (map
    
    (lambda (stem-card)
      
      (define clone (clone-card stem-card))
      
      (let ((card-view (send+ clone 'view)))
        
        (send card-view snap-back-after-move #t)
        
        clone))
    
    cards)))



(define (update-detail-view card)
  
  (define old-region (send detail-view get-region))
 
  (define new-region
    
    (make-background-region
     
     (region-x old-region)
     
     (region-y old-region)
     
     (region-w old-region)
     
     (region-h old-region)
     
     (lambda (dc x y w h)
       (send 
        
        dc draw-bitmap 
        
        (make-card-bitmap card card-detail-view-selector)
        
        x y))))
  
  (send table- remove-region old-region)
  
  (send table- add-region new-region)
  
  void)



(define (setup-card-browser)
  
  (define cards                cards-)
  
  (define next-button          (send next-cards-view get-region))
  
  (define previous-button      (send previous-cards-view get-region))
  
  (define view-capacity        (send card-list-view get-capacity))
  
  (define cards-length         (length cards))
  
  (define max-pages            (ceiling (/ cards-length view-capacity)))
  
  (define remaining-card-count (remainder cards-length view-capacity))
  
  (define page-content         (take cards view-capacity))

  (define page-number          1)
  
  
  (define (get-card-view card) 
    
    (send+ card 'view))
  
  
  (send card-list from-list page-content)
  
  
  (set-region-callback!
   
   next-button
   
   (lambda ()
     
     (unless (>= page-number max-pages)
       
       (send table- remove-cards (map get-card-view page-content))
       
       (let ((split-point (* page-number view-capacity)))
              
         (define head-cut-off (drop cards split-point))
         
         (set! 
          
          page-content 
          
          (take 
           
           head-cut-off 
           
           (if (>= (length head-cut-off) view-capacity)
               
               view-capacity
               
               remaining-card-count))))
       
       (set! page-number (+ page-number 1))
       
       (send card-list from-list page-content))
     
     void))
  
  
  (set-region-callback!
   
   previous-button
   
   (lambda ()
     
     (unless (<= page-number 1)
       
       (send table- remove-cards (map get-card-view page-content))
       
       (set! page-number (- page-number 1))
       
       (let ((split-point (* page-number view-capacity)))
       
         (set! 
          
          page-content 
          
          (take-right
           
           (take cards split-point)
           
           view-capacity)))
       
       (send card-list from-list page-content))
     
     void)))



(define (setup-existing-squad squad)
  
  (define units- (send squad get-units))
  
  (define hero-  (send squad get-hero))
  
  (send units from-list units-)
  
  (send hero-view set-model hero-)
  
  void)



(define (setup-squad-container)
  
  (vector-map!
   
   (list->vector (send units-view get-children))
   
   (lambda (unit-index unit-region)
     
     (set-region-callback!
      
      unit-region
      
      (lambda (card-views)
      
        (define card-view (car card-views))
        
        (define card (send card-view get-value))
        
        (unless (hero? card)
        
          (let ((clone (clone-card card)))
          
            (send units add-card clone unit-index)))
        
        void))))
  
  (set-region-callback!
   
   (send hero-view get-region)
   
   (lambda (card-views)
     
     (define card-view (car card-views))
     
     (define card (send card-view get-value))
     
     (when (hero? card)
       
       (let ((clone (clone-card card)))
         
         (send hero-view set-model clone)))
     
     void)))



(define (setup-trash)
  
  (define trash-region (send trash-view get-region))
  
  (define (translate-x old-x) (+ old-x 30))
  
  (define (translate-y old-y) (- old-y 170))
  
  (define new-x (translate-x (region-x trash-region)))
  
  (define new-y (translate-y (region-y trash-region)))
  
  
  (define (trash-callback card-views)
    
    (define card-view   (car card-views))
    
    (define card        (send card-view get-value))
    
    (define home-region (send card-view home-region))
    
    (send units remove-card card)
    
    (send table- remove-cards card-views)
    
    void)
  
  
  (define (trash-bg-callback dc x y w h)
    (send
     
     dc draw-bitmap
     
     (make-object bitmap%
       
       (collection-file-path 
        
        "trash-can.jpg"
        
        "neille/squads/img/")
       
       'jpeg)
     
     (+ new-x 30)
     
     (+ new-y 40)))
  
  (define new-trash-region
    
    (make-region
     
     new-x
     
     new-y
     
     (region-w trash-region)
     
     (region-h trash-region)
     
     (region-label trash-region)
     
     trash-callback))
  
  
  (define trash-bg
    
    (make-background-region
     
     new-x
     
     new-y
     
     (region-w new-trash-region)
     
     (region-h new-trash-region)
     
     trash-bg-callback))
  
  
  (send table- remove-region trash-region)
  
  (send table- add-region    new-trash-region)
  
  (send table- add-region    trash-bg)
  
  void)

(define (setup-card-click-action)
  
  (send 
   
   table- set-single-click-action
   
   (lambda (card-view)
     
     (update-detail-view 
      
      (send card-view get-value)))))



(define (setup-save-button player)
  
  (define save-button (send save-squad-view get-region))
  
  (set-region-callback!
   
   save-button
   
   (lambda ()
     
     (define hero   (send hero-view get-model))
     
     (define units- (send units to-list))
     
     (define squad  (new squad% (hero hero) (units units-)))
     
     (send player update-delegate 'active-squad squad)
     
     (marshal player)

     void)))



(define (setup-squad-selection-screen player)
  
  (define squad (send+ player 'active-squad))
  
  (when (is-a? squad squad%)
    
    (setup-existing-squad squad))
  
  (setup-cards)
  
  (setup-card-browser)
  
  (setup-card-click-action)
  
  (setup-squad-container)
  
  (setup-trash)
  
  (setup-save-button player)
  
  void)


(setup-squad-selection-screen human)

(send table- show #t)
