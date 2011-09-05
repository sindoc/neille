#lang racket



(require
 
 racket/gui/base
 
 games/cards
 
 neille/common/model-classes
 
 neille/common/syntax
 
 neille/cards/ws-cards
 
 neille/cards/reflection
 
 neille/players/reflection
 
 neille/common/reflection)



(provide 
 
 (all-from-out 
  
  neille/cards/ws-cards
  
  neille/cards/reflection)
 
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
    
    (send card add-delegate delegate view)))



(define (make-card-cloner stem)
  
  (lambda ()
    
    
    (define new-card (new card% (ws-card (send+ stem card-ws-card-delegate))))
    
    
    (send
     
     new-card add-delegate card-view-maker-delegate
     
     (send+ stem card-view-maker-delegate))
    
    
    (send
     
     new-card add-delegate card-detail-view-maker-delegate
     
     (send+ stem card-detail-view-maker-delegate))
    
    
    (send
     
     new-card add-delegate card-clone-maker-delegate
     
     (send+ stem card-clone-maker-delegate))
    
    
    (send
     
     new-card add-delegate clean-reflection-delegate
     
     (send+ stem clean-reflection-delegate))
    
    new-card))



(define (prepare-card ws-card)
  
  
  (define card (new card% (ws-card ws-card)))
  
  
  (send
   
   card add-delegate 
   
   card-view-maker-delegate 
   
   (make-card-view-maker 
    
    card-view-delegate 
    
    card-view-selector))
  
  
  (send
   
   card add-delegate 
   
   card-detail-view-maker-delegate
   
   (make-card-view-maker 
    
    card-detail-view-delegate 
    
    card-detail-view-selector))
  
  
  (send
   
   card add-delegate 
   
   card-clone-maker-delegate
   
   (make-card-cloner card))
   
  
  ((send+ card card-view-maker-delegate) card)
  
  
  (send
   
   card update-delegate
   
   clean-reflection-delegate
   
   (lambda (current-reflection-cleaners)
     
     (cons 
      
      (lambda (card)
        
        (send 
         
         card remove-delegate
         
         card-view-maker-delegate)
        
        (send
         
         card remove-delegate
         
         card-detail-view-maker-delegate)
        
        (send
         
         card remove-delegate
         
         card-clone-maker-delegate)
        
        (send
         
         card remove-delegate
         
         card-view-delegate)
        
        (send
         
         card remove-delegate
         
         card-detail-view-delegate))
      
      current-reflection-cleaners)))
  
  card)



(define (make-fallback-card)
  
  (prepare-card fallback-ws-card))



(define (make-fallback-card-view)
  
  (send+ (make-fallback-card) card-view-delegate))



(define (prepare-player-cards player)
  
  (define active-squad (send+ player player-active-squad-delegate))
  
  (send 
   
   active-squad from-list
   
   (map
    
    (lambda (card)
      
      (define prepared-card 
        
        (prepare-card (send+ card card-ws-card-delegate)))
      
      ((send+ prepared-card card-view-maker-delegate) prepared-card)
      
      prepared-card)
    
    (send active-squad to-list)))
  
  player)



(define cards (map prepare-card ws-cards))




















