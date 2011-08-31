#lang racket



(require
 
 racket/gui/base
 
 games/cards
 
 neille/model
 
 neille/utils/syntax
 
 neille/cards/ws-cards
 
 neille/cards/fallback)



(provide 
 
 
 (all-from-out 
  
  neille/cards/ws-cards
  
  neille/cards/fallback)
 
 
 (all-defined-out)
 
 
 (except-out query))



(define (query card field value)
  
  (eq? (send+ card field) value))



(define (hero?      card) (query card 'squadrole 'Hero))

(define (unit?      card) (query card 'squadrole 'Unit))

(define (artifact?  card) (query card 'squadrole 'Artifact))

(define (spell?     card) (query card 'squadrole 'Spell))

(define (neutral?   card) (query card 'faction   'Neutral))

(define (demon?     card) (query card 'faction   'Demon))

(define (human?     card) (query card 'faction   'Human))

(define (elf?       card) (query card 'faction   'Elf))

(define (orc?       card) (query card 'faction   'Orc))

(define (undead?    card) (query card 'faction   'Undead))

(define (infantry?  card) (query card 'type      'Infantry))

(define (hero*?     card) (query card 'type      'Hero))

(define (beast?     card) (query card 'type      'Beast))

(define (barrier?   card) (query card 'type      'Barrier))

(define (archer?    card) (query card 'type      'Archer))

(define (cavalry?   card) (query card 'type      'Cavalry))

(define (artifact*? card) (query card 'type      'Artifact))

(define (spell*?    card) (query card 'type      'Spell))

(define (dead?      card) (query card 'health    0))

(define (ready?     card) (query card 'ready     0))



(define card-view-selector car)


(define card-detail-view-selector cadr)



(define clone-maker-delegate 'make-clone)


(define view-maker-delegate 'make-view)


(define detail-view-maker-delegate 'make-detail-view)



(define view-delegate 'view)


(define detail-view-delegate 'detail-view)



(define (get-card-meta-images card)
  
  (ws-card-graphic-scales 
   
   (send card get-image)))



(define (make-card-view card bitmap)
  
  (let ((view 
         
         (make-card
          
          bitmap bitmap
          
          (send card get-id)
          
          card)))
    
    (send view flip)
    
    view))



(define (make-card-bitmap card scale-selector)
  
  (define meta-image 
    
    (scale-selector 
     
     (get-card-meta-images card)))
  
  
  (make-object bitmap%
    
    (collection-file-path
     
     (meta-image-filename meta-image)
     
     (meta-image-dirname meta-image))
    
    (meta-image-type meta-image)))



(define (make-card-view-maker delegate scale-selector)
  
  (lambda (card)
    
    (define bitmap (make-card-bitmap card scale-selector))
    
    (define view (make-card-view card bitmap))
    
    (send+ card 'add-delegate delegate view)))



(define (make-card-cloner stem)
  
  (lambda ()
    
    
    (define new-card (new card% (ws-card (send+ stem 'ws-card))))
    
    
    (send+ 
     
     new-card 'add-delegate view-maker-delegate
     
     (send+ stem view-maker-delegate))
    
    
    (send+ 
     
     new-card 'add-delegate detail-view-maker-delegate
     
     (send+ stem detail-view-maker-delegate))
    
    
    (send+ 
     
     new-card 'add-delegate clone-maker-delegate
     
     (send+ stem clone-maker-delegate))
    
    new-card))



(define (prepare-card ws-card)
  
  
  (define card (new card% (ws-card ws-card)))
  
  
  (send+ 
   
   card 'add-delegate view-maker-delegate
   
   (make-card-view-maker view-delegate card-view-selector))
  
  
  (send+ 
   
   card 'add-delegate detail-view-maker-delegate
   
   (make-card-view-maker detail-view-delegate card-detail-view-selector))
  
  
  (send+ 
   
   card 'add-delegate clone-maker-delegate
   
   (make-card-cloner card))
  
  
  ((send+ card 'make-view) card)
  
  
  card)



(define cards (map prepare-card ws-cards))





















