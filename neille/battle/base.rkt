#lang racket

(require 
 neille/base
 neille/model
 neille/battle/layout/base
 neille/cards/base
 neille/utils/syntax
 neille/squads/base
 games/cards
 racket/mpair
 (prefix-in ring: a-d/ring))

(init-players players (deck graveyard reserve inplay staging squads))

(define (init-battle)
  (for-each
   (lambda (player)
     (send 
      (send+ player 'deck) from-list 
      (send (car (send+ player 'squads)) to-list)))
   players))

(define (battle-loop player)
  (define deck (send+ player 'deck))
  (define staging (send+ player 'staging))
  (send staging add-card (send deck pop)))

(send table- show #t)
(init-battle)
(battle-loop (cadr players))