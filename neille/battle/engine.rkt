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
 
 neille/utils/broadcast-feedback-channel)



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



(define (broadcast-end-of-game player opponent)
  
  (send 
      
   broadcast-feedback-channel 
   
   broadcast 
   
   game-finished-event-id 
      
   opponent))

  
  

(define (battle-loop player)
  
  
  (define deck     (get-deck      player))
  
  (define staging  (get-staging   player))
  
  (define inplay   (get-inplay    player))
  
  (define opponent (get-opponent  players player))
  
  
  (cond
    
    ((send deck empty?)
     
     (broadcast-end-of-game player opponent))
         
    (else
     
     
     (send staging add-card (send deck pop))
     
     
     (adapt-readiness-of-staging-cards staging)
     
     
     (deploy-cards-from-staging staging inplay)
     
     
     ;(sleep 0.6)
     
     (battle-loop 
      
      (select-next-player player-ring))))
  
  void)



(define (load-decks-with-active-squads players)
  
  (for-each
   
   (lambda (player)
     
     (define   deck    (get-deck player))
     
     (define   squad   (get-active-squad player))
     
     
     (send deck from-list (send squad to-list))
     
     (send deck shuffle))
   
   players)
  
  void)



(define (start-playing)
  
  (init-players 
 
   players 
 
   (deck graveyard reserve inplay staging opponent active-squad))

  (load-decks-with-active-squads players)

  (battle-loop (cadr players)))

















