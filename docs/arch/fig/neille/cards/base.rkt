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
(define (artifact? c) (q 'squadrole 'Artifact))
(define (spell? c) (q 'squadrole 'Spell))
(define (infantry? c) (q c 'type 'Infantry))
(define (hero*? c) (q c 'type 'Hero))
(define (beast? c) (q c 'type 'Beast))
(define (barrier? c) (q c 'type 'Barrier))
(define (archer? c) (q c 'type 'Archer))
(define (cavalry? c) (q c 'type 'Cavalry))
(define (artifact*? c) (q 'type 'Artifact))
(define (spell*? c) (q 'type 'Spell))
(define (neutral? c) (q 'faction 'Neutral))
(define (demon? c) (q 'faction 'Demon))
(define (human? c) (q 'faction 'Human))
(define (elf? c) (q 'faction 'Elf))
(define (orc? c) (q 'faction 'Orc))
(define (undead? c) (q 'faction 'Undead))
(define (dead? c) (q 'health 0))
(define (ready? c) (q 'ready 0))

(define cards 
  (map 
   (lambda (ws-card)
     (define card (new card% (ws-card ws-card)))
     (send+
      card 'add-delegate 'make-view
      (λ (c)
	 (define bmp (car (ws-card-graphic-scales (send+ card 'image))))
	 (define view (make-card bmp bmp 0 0))
	 (send+ c 'add-delegate 'view view)))
     ((send+ card 'make-view) card)
     card)
   ws-cards))