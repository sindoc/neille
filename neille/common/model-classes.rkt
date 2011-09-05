#lang racket



(require
 
 games/cards
 
 neille/cards/syntax
 
 neille/common/syntax
 
 neille/common/serialize
 
 neille/cards/ws-cards
 
 neille/cards/reflection
 
 neille/common/reflection
 
 neille/players/reflection
 
 neille/common/collection
 
 neille/common/observable
 
 (prefix-in stk: neille/utils/stack))



(provide
 
 card%
 
 cardlist%
 
 squad%
 
 deck%
 
 player%)



;; -----------
;;    Deck
;; -----------


(define deck%
  
  (class* observable%
    
    (collection<%>)
    
    
    (super-new)
    
    
    (init (cards null))
    
    
    (define cards- (stk:new* cards))
    
    
    (define/public (shuffle)
      
      (define lst (stk:to-list cards-))
      
      (set! cards- (stk:new* (shuffle-list lst 7)))
      
      cards-)
    
    
    (define/public (empty?)
      
      (stk:empty? cards-))
    
    
    (define/public (from-list lst)
      
      (set! cards- (stk:new* lst))
      
      (send this notify))
    
    
    (define/public (to-list)
      
      (stk:to-list cards-))
    
    
    (define/public (top)
      
      (stk:top cards-))
    
    
    (define/public (foreach proc)
      
      void)
    
    (define/public (push card)
      
      (stk:push! cards- card)
      
      (send this notify))
    
    
    (define/public (pop)
      
      (let ((top (stk:pop! cards-)))
        
	(send this notify)
        
	top))))




;; -----------
;;  Card List
;; -----------


(define-serializable-class*
  
  cardlist%
  
  observable%
  
  (collection<%>)
    
  (init (cards null))
    
    
  (define cards- cards)
    
    
  (super-new)
    
    
  (define/public (from-list cards)
      
    (set! cards- cards)
    
    (send this notify))
  
  
  (define/public (to-list) cards-)
  
  
  (define/public (map! proc)
    
    (set! cards- (map proc cards-)))
  
  
  (define/public (foreach proc)
    
    (for-each proc cards-))
  
  
  (define/public (get-length)
    
    (length cards-))
  
  
  (define/public (poke)
      
    (send this notify))
  
  
  (define/private (insert-in-middle lst val pos)
      
    (flatten
     
     (cons
      
      (take lst pos)
      
      (cons val (drop lst pos)))))
  
  
  (define/public (add-card card . pos)
    
    (set! 
     
     cards- 
       
     (cond
       
       ((or (null? pos)
            
            (empty? cards-))
        
        (cons card cards-))
       
       (else
        
        (insert-in-middle cards- card (car pos)))))
    
    (send this notify))
  
  
  (define/public (remove-card card)
    
    (set! cards- (remq card cards-))
    
    (send this notify))
  
  
  (define/override (externalize)
    
    (serialize cards-))
  
  
  (define/override (internalize cards)
    
    (send this from-list cards)
    
    this))




;; -----------
;;   Player
;; -----------


(define-serializable-class*
  
  player%
  
  observable%
  
  (reflective<%>)
    
  (init (name null))
    
    
  (super-new)
    
    
  (define name- name)
    
    
  (define initial-morale- 20)
    
    
  (define morale- initial-morale-)
    
    
  (setup-dispatcher 
     
   dispatcher- query add-delegate update-delegate 
   
   remove-delegate for-each-delegate)
    
    
  (define/public (get-morale) morale-)
    
    
  (define/public (get-initial-morale) initial-morale-)
    
    
  (define/public (set-morale new-morale)
      
    (set! morale- new-morale)
      
    (send this notify)
      
    void)
    
  
  (define/public (get-name) name-)
  
  
  (define/public (remove-reflection)
    
    (common-clean-reflection this))
  
    
  (define/public (set-name new-name)
      
    (set! name- new-name)
      
    (send this notify)
      
    void)
  
    
  (define/override (externalize)
      
    (define squads 
        
      (map 
         
       (lambda (squad)
         
         (serialize squad))
         
       (send+ this player-squads-delegate)))
    
      
    (define active-squad 
      
      (serialize 
       
       (send+ this player-active-squad-delegate)))
    
    (remove-reflection)
      
    (make-ws-player name- squads active-squad))
    
    
  (define/override (internalize ws-player)
      
    (send this set-name (ws-player-name ws-player))
    
    (send
       
     this update-delegate 'squads
     
     (lambda (_)
       
       (ws-player-squads ws-player)))
    
    (send
     
     this update-delegate 'active-squad
     
     (lambda (_)
     
       (ws-player-active-squad ws-player)))
    
    this))




;; -----------
;;    Squad
;; -----------


(define-serializable-class
  
  squad%
  
  cardlist% 
  
  
  (init hero units)
  
        
  (super-new 
     
   (cards (cons hero units)))
  
    
  (define hero- hero)
  
    
  (define/public (get-units)
           
     (cdr (send this to-list)))
  
  
  (define/public (set-units new-unit-list)
    
    (send 
     
     this from-list 
     
     (cons hero- new-unit-list)))
    
  
  (define/public (get-hero)
    
    (car (send this to-list)))
  
  
  (define/public (set-hero new-hero)
    
    (set! hero- new-hero)
    
    (send 
     
     this from-list
     
     (cons hero- (cdr (send this to-list)))))
    
    
  (define/override (externalize)
    
    (make-ws-squad
     
     (serialize hero-)
     
     (map serialize (get-units))))
  
  
  (define/override (internalize ws-squad)
    
    (set-hero (ws-squad-hero ws-squad))
    
    (set-units (ws-card-units ws-squad))
    
    this))




;; -----------
;;    Card
;; -----------


(define-serializable-class*
  
  card%
  
  observable%
  
  (reflective<%>)
    
  (init (ws-card null))
  
  
  (super-new)
  
  
  (define ws-card- 
    
    (if (null? ws-card) 
       
        fallback-ws-card 
       
        ws-card))
  
  
  (setup-dispatcher 
   
   dispatcher- query add-delegate update-delegate 
   
   remove-delegate for-each-delegate)
  
  
  (setup-card-fields 
   
   ws-card- query add-delegate update-delegate)
  
  
  (define/public (remove-reflection)
    
    (common-clean-reflection this))
  
  
  (define/public (set-ws-card new-ws-card)
    
    (set! ws-card- new-ws-card))
  
  
  (define/override (externalize)
      
    (remove-reflection)
    
    ws-card-)
  
  
  (define/override (internalize ws-card)
    
    (new card% (ws-card ws-card))))























