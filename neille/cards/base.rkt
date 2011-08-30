#lang racket

(require
 games/cards
 neille/model
 neille/utils/syntax
 neille/cards/ws-cards)

(provide 
 (all-from-out neille/cards/ws-cards)
 (all-defined-out)
 (except-out q))

(define (q card field value)
  (eq? (send+ card field) value))

(define (hero? c) (q c 'squadrole 'Hero))
(define (unit? c) (q c 'squadrole 'Unit))
(define (artifact? c) (q c 'squadrole 'Artifact))
(define (spell? c) (q c 'squadrole 'Spell))
(define (infantry? c) (q c 'type 'Infantry))
(define (hero*? c) (q c 'type 'Hero))
(define (beast? c) (q c 'type 'Beast))
(define (barrier? c) (q c 'type 'Barrier))
(define (archer? c) (q c 'type 'Archer))
(define (cavalry? c) (q c 'type 'Cavalry))
(define (artifact*? c) (q c 'type 'Artifact))
(define (spell*? c) (q c 'type 'Spell))
(define (neutral? c) (q c 'faction 'Neutral))
(define (demon? c) (q c 'faction 'Demon))
(define (human? c) (q c 'faction 'Human))
(define (elf? c) (q c 'faction 'Elf))
(define (orc? c) (q c 'faction 'Orc))
(define (undead? c) (q c 'faction 'Undead))
(define (dead? c) (q c 'health 0))
(define (ready? c) (q c 'ready 0))

(define card-view-selector car)
(define card-detail-view-selector cadr)

(define (get-card-scale-thunks card)
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
     new-card 'add-delegate clone-maker
     (send+ stem clone-maker))
    new-card))

(define cards 
  (map 
   (lambda (ws-card)
     (define card (new card% (ws-card ws-card)))
     (send+ 
      card 'add-delegate view-maker-delegate
      (make-card-view-maker 'view card-view-selector))
     (send+ 
      card 'add-delegate detail-view-maker-delegate
      (make-card-view-maker 'detail-view card-detail-view-selector))
     (send+ 
      card 'add-delegate clone-maker
      (make-card-cloner card))
     ((send+ card 'make-view) card)
     card)
   ws-cards))