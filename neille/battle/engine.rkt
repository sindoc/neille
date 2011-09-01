#lang racket

(require 
 
 neille/base
 
 neille/model
 
 neille/cards/base
 
 neille/utils/syntax
 
 neille/squads/static
 
 neille/battle/model
 
 neille/battle/common
 
 neille/battle/events
 
 neille/utils/broadcast-feedback-channel
 
 (prefix-in ring: a-d/ring))



(provide
 
 (all-defined-out))



(define broadcast-feedback-channel 
  
  (make-broadcast-feedback-channel
   
   (lambda (message . args)
     
     (case message
         
       ((cool)
        
        message)
       
       (else
     
        (error 
         
         "I'm afraid we don't speak the same language. You said: " 
         
         message))))))



(init-players 
 
 players 
 
 (deck graveyard reserve inplay staging active-squad))



(define (select-next-player player-ring)
  
  (ring:shift-forward! player-ring)
  
  (ring:peek player-ring))



(define (decrement-card-readiness card (amount 1))
  
  (send 
   
   card set-ready 
   
   (- (send card get-ready) 
    
      amount))
  
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



(define (broadcast-end-of-game player)
  
  (send 
      
   broadcast-feedback-channel 
   
   broadcast 
   
   game-finished-event-id 
      
   (car
    
    (filter-not
       
     (lambda (player-)
       
       (eq? player player-))
     
     players))))

  
  

(define (battle-loop player)
  
  
  (define deck     (get-deck      player))
  
  (define staging  (get-staging   player))
  
  (define inplay   (get-inplay    player))
  
  
  (cond
    
    ((send deck empty?)
     
     (broadcast-end-of-game player))
         
    (else
     
     
     (send staging add-card (send deck pop))
     
     
     (adapt-readiness-of-staging-cards staging)
     
     
     (deploy-cards-from-staging staging inplay)
     
     
     (sleep 0.6)
     
     (battle-loop 
      
      (select-next-player player-ring))))
  
  void)



(define (load-decks-with-active-squads)
  
  (for-each
   
   (lambda (player)
     
     (define   deck    (get-deck player))
     
     (define   squad   (get-active-squad player))
     
     
     (send deck from-list (send squad to-list))
     
     (send deck shuffle))
   
   players)
  
  void)



(define (start-playing)
  
  (load-decks-with-active-squads)

  (battle-loop (cadr players)))

















