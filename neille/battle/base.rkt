#lang racket

(require 
 
 neille/base
 
 neille/model
 
 neille/battle/layout/base
 
 neille/cards/base
 
 neille/utils/syntax
 
 neille/squads/static
 
 (prefix-in ring: a-d/ring))



(init-players players (deck graveyard reserve inplay staging active-squad))



(define (get-deck player)
  
  (send+ player 'deck))



(define (get-staging player)
  
  (send+ player 'staging))



(define (get-active-squad player)
  
  (send+ player 'active-squad))



(define (get-inplay player)
  
  (send+ player 'inplay))



(define (get-card-readiness card)
  
  (send card get-ready))



(define (select-next-player player-ring)
  
  (ring:shift-forward! player-ring)
  
  (ring:peek player-ring))



(define (take-card-from-deck-to-staging deck staging)
  
  (send   staging  add-card (send deck pop))
  
  void)



(define (decrement-card-readiness card (amount 1))
  
  (send 
   
   card set-ready 
   
   (- 
    
    (send card get-ready) 
    
    amount))
  
  void)



(define (for-each-card collection proc)
  
  (send 
   
   collection for-each
   
   (lambda (card)
     
     (proc card)))
  
  void)



(define (adapt-readiness-of-staging-cards staging)
  
  (for-each-card 
   
   staging
   
   (lambda (card)
     
     (decrement-card-readiness card)))
  
  void)



(define (deploy-cards-from-staging staging inplay)
  
  (for-each-card
   
   staging
   
   (lambda (card)
     
     (when (<= (get-card-readiness card) 0)
       
       (send inplay add-card card)))))



(define (game-finished? player)
  
  (define deck (get-deck player))
  
  (send deck empty?))



(define (battle-loop player)
  
  
  (define deck     (get-deck      player))
  
  (define staging  (get-staging   player))
  
  (define inplay   (get-inplay    player))
  
  
  (cond
    
    ((game-finished? player)
     
     (error "Oops!"))
    
    (else
     
     (take-card-from-deck-to-staging   deck staging)
     
     (adapt-readiness-of-staging-cards staging)
     
     (deploy-cards-from-staging        staging inplay)
     
     (sleep 1)
     
     (battle-loop 
      
      (select-next-player player-ring))))
  
  void)



(define (load-decks-with-active-squads)
  
  (for-each
   
   (lambda (player)
     
     (define deck  (get-deck player))
     
     (define squad (get-active-squad player))
     
     (send deck from-list (send squad to-list))
     
     (send deck shuffle))
   
   players)
  
  void)



(define (init-battle)
  
  (load-decks-with-active-squads)
  
  void)



(init-battle)



(battle-loop (cadr players))



(send table- show #t)






