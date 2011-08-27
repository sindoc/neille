#lang racket

(require
 games/cards
 neille/utils/syntax
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
      observers)
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
    (define/public (to-list)
      (dls:to-list cards-))
    (define/public (map! proc)
      (dls:map! cards- proc))
    (define/public (length)
      (dls:length cards-))
    (define/public (poke)
      (send this notify))
    (define/public (add-card card)
      (dls:attach-first! cards- card)
      (send this notify))))

(define player%
  (class observable%
    (init name)
    (super-new)
    (define name- name)
    (define initial-morale- 20)
    (define morale- initial-morale-)
    (setup-dispatcher dispatcher- query add! update! remove!)
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
      void)))
  
(define squad%
  (class cardlist%
    (init hero-selector squad)
    (define hero- (hero-selector squad))
    (super-new (cards squad))))

(define card%
  (class observable%
    (init ws-card)
    (super-new)
    (define ws-card- ws-card)
    (setup-dispatcher dispatcher- query add! update! remove!)
    (setup-card-fields ws-card- query add! update!)))