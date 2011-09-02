#lang racket

(require
 
 games/cards
 
 neille/utils/syntax
 
 neille/utils/serialize
 
 neille/cards/ws-cards
 
 (prefix-in stk: neille/utils/stack)
 
 (prefix-in dls: neille/utils/double-linked-list))



(provide
 
 (all-defined-out))



(define observable%
  
  (class object%
    
    (super-new)
    
    
    (define observers (dls:new =))
    
    
    (define/public (add-observer observer)
      
      (dls:attach-first! observers observer))
    
    
    (define/public (observer-list)
      
      (send observers to-list))
    
    
    (define/public (notify)
      
      (unless (dls:empty? observers)
        
	(dls:map!
         
	 observers
         
	 (lambda (_ observer)
           
	   (send observer update)
           
	   observer)))
      
      void)))



(define deck%
  
  (class observable%
    
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
    
    
    (define/public (push card)
      
      (stk:push! cards- card)
      
      (send this notify))
    
    
    (define/public (pop)
      
      (let ((top (stk:pop! cards-)))
        
	(send this notify)
        
	top))))



(define cardlist%
  
  (class observable%
    
    (init (cards null))
    
    
    (define cards- (dls:new* eq? cards))
    
    
    (super-new)
    
    
    (define/public (from-list cards)
      
      (set! cards- (dls:new* eq? cards))
      
      (send this notify))
    
    
    (define/public (to-list)
      
      (dls:to-list cards-))
    
    
    (define/public (map! proc)
      
      (dls:map! cards- proc))
    
    
    (define/public (for-each proc)
      
      (dls:map!
       
       cards-
       
       (lambda (_ card)
         
         (proc card)
         
         card)))
    
    
    (define/public (get-length)
      
      (dls:length cards-))
    
    
    (define/public (poke)
      
      (send this notify))
    
    
    (define/public (add-card card)
      
      (dls:attach-first! cards- card)
      
      (send this notify))))



(define cardlist-%
  
  (class observable%
    
    
    (init (cards null))
    
    
    (define cards- cards)
    
    
    (super-new)
    
    
    (define/public (from-list cards)
      
      (set! cards- cards)
      
      (send this notify))
    
    
    (define/public (to-list) cards-)
    
    
    (define/public (map! proc)
      
      (set! cards- (map proc cards-)))
    
    
    (define/public (get-length)
      
      (length cards-))
    
    
    (define/public (poke)
      
      (send this notify))
    
    
    (define (insert-in-middle lst val pos)
      
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
      
      (send this notify))))



(define player%
  
  
  (class* observable% (externalizable<%>)  
    
    (init (name null))
    
    
    (super-new)
    
    
    (define name- name)
    
    
    (define initial-morale- 20)
    
    
    (define morale- initial-morale-)
    
    
    (setup-dispatcher 
     
     dispatcher- query add! update! remove!)
    
    
    (define/public (get-morale) morale-)
    
    
    (define/public (get-initial-morale) initial-morale-)
    
    
    (define/public (set-morale new-morale)
      
      (set! morale- new-morale)
      
      (send this notify)
      
      void)
    
    
    (define/public (get-name) name-)
    
    
    (define/public (set-name new-name)
      
      (set! name- new-name)
      
      (send this notify)
      
      void)
    
    
    (define/public (externalize)
      
      (define squads 
        
        (map 
         
         (lambda (squad) 
           
           (send squad externalize))
         
         (send+ this 'squads)))
      
      (make-ws-player name- squads))
    
    
    (define/public (internalize ws-player)
      
      (new 
       
       player%
       
       (name (ws-player-name ws-player))))))



(define squad%
  
  (class* cardlist% (externalizable<%>)
    
    
    (init hero units)
    
        
    (super-new 
     
     (cards (cons hero units)))
    
    
    (define hero- hero)
    

    (define (include-hero card) 
      
      (eq? hero- card))
    
    
    (define (exclude-hero card)
      
      (not (include-hero card)))
    
    
    (define/public (get-units)
      
      (filter exclude-hero (send this to-list)))
    
    
    (define/public (get-hero) hero-)
    
    
    (define/public (externalize)
      
      (make-ws-squad
       
       (send hero- externalize)
       
       (map serialize- (get-units))))
    
    
    (define/public (internalize ws-squad)
      
      (new
       
       squad%
       
       (hero (ws-squad-hero ws-squad))
       
       (units (ws-squad-units ws-squad))))))



(define card%
  
  (class* observable% (externalizable<%>)
    
    
    (init ws-card)
    
    
    (super-new)
    
    
    (define ws-card- ws-card)
    
    
    (setup-dispatcher 
     
     dispatcher- query add! update! remove!)
    
    
    (setup-card-fields ws-card- query add! update!)
    
    
    (define/public (externalize) 
      
      ws-card-)
    
    
    (define/public (internalize ws-card)
      
      (new card% (ws-card ws-card)))))























