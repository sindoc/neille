#lang racket



(require
 
 neille/common/syntax)



(provide
 
 (all-defined-out))



(define player-deck-delegate                'deck)

(define player-graveyard-delegate           'graveyard)

(define player-reserve-delegate             'reserve)

(define player-inplay-delegate              'inplay)

(define player-staging-delegate             'staging)

(define player-opponent-delegate            'opponent)

(define player-active-squad-delegate        'active-squad)

(define player-squads-delegate              'squads)

(define player-attacking-card-delegate      'attacking-card)

(define player-card-being-attacked-delegate 'card-being-attacked)



(define (get-deck           player) (send+ player player-deck-delegate))

(define (get-inplay         player) (send+ player player-inplay-delegate))

(define (get-staging        player) (send+ player player-staging-delegate))

(define (get-active-squad   player) (send+ player player-active-squad-delegate))



(define (set-attacking-card      player card)
  
  (send player update-delegate player-attacking-card-delegate
        
        (lambda (_) card)))


(define (set-card-being-attacked player card)
  
  (send player update-delegate player-card-being-attacked-delegate
        
        (lambda (_) card)))













