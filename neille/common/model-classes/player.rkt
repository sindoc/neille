#lang racket



(require
 
 "syntax.rkt"
 
 neille/common/base
 
 neille/common/serialize
 
 neille/players/reflection)



(provide
 
 player%)



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