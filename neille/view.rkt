#lang racket

(require 
 games/cards
 racket/gui/base
 neille/model
 neille/utils/base
 neille/utils/syntax)

(provide (all-defined-out))

(define observer-
  (interface () update))

(define view%
  (class* object% (observer-)
    (super-new)
    (init (root null) (region null) (model null) (children null))
    (define root- root)
    (define region- region)
    (define model- model)
    (define children- children)
    (define/public (get-region) region-)
    (define/public (set-region new-region)
      (set! region- new-region))
    (define/public (get-root) root-)
    (define/public (set-root new-root)
      (set! root- new-root))
    (define/public (get-model) model-)
    (define/public (set-model new-model)
      (set! model- new-model))
    (define/public (get-children) children-)
    (define/public (set-children new-children)
      (set! children- new-children))
    (define/public (update)
      void)))

(define deck-view%
  (class view%
    (setup-view root- region- deck- children-)
    (define visible-card 
      (if (send deck- empty?) null (send deck- top)))
    (define/override (update)
      (set! visible-card (send deck- top))
      (send root- remove-card (send+ visible-card 'view))
      (send 
       root- add-cards-to-region 
       (list (send+ visible-card 'view)) region-))))

(define cardlist-view%
  (class view%
    (setup-view root- region- cardlist- children-)
    (define/override (update)
      (for-each
       (lambda (child card)
         (send 
          root- remove-cards 
          (list (send+ card 'view)))
         (send 
          root- add-cards-to-region 
          (list (send+ card 'view)) child))
       (take children- (send cardlist- length))
       (send cardlist- to-list)))))

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