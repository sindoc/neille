#lang racket

(require
 games/cards
 neille/utils/syntax
 neille/model
 neille/squads/layout/base
 neille/cards/base)

(provide (all-defined-out))

(define (make-squad* m)
  (define (mk-card stem)
    (define clone ((send+ stem 'make-clone)))
    ((send+ clone 'make-view) clone)
    clone)
  (define squad
    (cons 
     (mk-card (car (filter hero? cards)))
     (map (lambda (c) (mk-card c)) (take cards (* m 6)))))
  (list (new squad% (hero (car squad)) (squad squad))))

(define squads (make-squad* 1))
(define -squads (make-squad* 2))

(define cards- null)

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
        ((card-detail-view-selector (get-card-scale-thunks card)))
        10 10))))
  (send table- remove-region old-region)
  (send table- add-region new-region)
  void)

(define (init squad)
  (define units- (send squad get-units))
  (define hero- (send squad get-hero))
  (set! 
   cards-
   (map
    (lambda (stem-card)
      (define clone ((send+ stem-card 'make-clone)))
      ((send+ clone 'make-view) clone)
      clone)
    cards))
  (send units from-list units-)
  (send hero-view set-model hero-)
  (send card-list from-list cards-)
  (send
   table- set-single-click-action
   (lambda (card-view)
     (update-detail-view (send card-view get-value))))
  void)

(init (car squads))
(send table- show #t)