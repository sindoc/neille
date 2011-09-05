#lang racket



(require
 
 games/cards
 
 neille/common/base
 
 (prefix-in stk: neille/utils/stack))



(provide
 
 deck%)



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






















